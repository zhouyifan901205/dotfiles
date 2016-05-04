;; .emacs
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;(when (fboundp 'global-font-lock-mode)
;    (global-font-lock-mode t))

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; always end a file with a newline
(setq require-final-newline 'query)
;; font
(set-default-font "DejaVu Sans Mono 15")

; copy and paste
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)
(load "/home/yzhou/.emacs.d/lisp/copypaste.el")

(defun C++-template-args-cont (langelem)
""  (save-excursion
    (beginning-of-line)
    (if (re-search-forward "^[\t ]*>" (line-end-position) t)
        0)))
;; C++ Coding Style
(defun volant-cpp-style()
  (c-set-style "linux")
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (setq c-tab-always-indent 't)
  (c-set-offset 'innamespace '0)
  (c-set-offset 'inline-open '0)
  (c-set-offset 'inextern-lang 0)
  (c-set-offset 'label 0)
  (c-set-offset 'case-label 0)
  (c-set-offset 'statement-cont 0)
  (c-set-offset 'arglist-close 0)
  (c-set-offset 'template-args-cont
                '(c++-template-args-cont c-lineup-template-args +))
  (require 'whitespace)
  (auto-fill-mode t)
  (setq fill-column 80)
  (setq whitespace-style '(face lines-tail trailing))
  (whitespace-mode t)
  (add-hook 'before-save-hook
            'delete-trailing-whitespace)
  (add-hook 'before-save-hook
            (lambda ()
              (untabify (point-min) (point-max))
              ))
  )

(add-hook 'c-mode-hook 'volant-cpp-style)
(add-hook 'c++-mode-hook 'volant-cpp-style)

(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;(defvar myPython
;  '(elpy
;    ein
;    flycheck
;    py-autopep8))
;(mapc #'(lambda (package)
;          (unless (package-installed-p package)
;            (package-install package)))
;      myPython)

(defun python-style()
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
  (elpy-enable)
  (elpy-use-ipython)
  ;; use flycheck not flymake with elpy
  (when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
  ;; enable autopep8 formatting on save
  (require 'py-autopep8)
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
  (add-hook 'before-save-hook
            'delete-trailing-whitespace)
  (require 'fill-column-indicator)
  (fci-mode)
  (flycheck-mode))

(add-hook 'python-mode-hook 'python-style)