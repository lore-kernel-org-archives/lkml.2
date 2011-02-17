Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1BQPE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:04:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:38142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab1BQPEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:04:23 -0500
Date: Thu, 17 Feb 2011 15:04:07 GMT
From: tip-bot for Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, jesse.brandeburg@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, jesse.brandeburg@intel.com
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Update Makefile with some help
Message-ID: <tip-4187e262bc90369ba581ee28ec74ed416618889e@git.kernel.org>
Git-Commit-ID: 4187e262bc90369ba581ee28ec74ed416618889e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 15:04:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4187e262bc90369ba581ee28ec74ed416618889e
Gitweb:     http://git.kernel.org/tip/4187e262bc90369ba581ee28ec74ed416618889e
Author:     Jesse Brandeburg <jesse.brandeburg@intel.com>
AuthorDate: Wed, 9 Feb 2011 17:11:00 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Feb 2011 14:47:56 -0200

perf tools: Update Makefile with some help

The perf makefile is nicely complete except for

a) an uninstall option
b) a 'make help' description

This patch implements b)
it also comments out other non-working makefile targets

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile |   19 ++++++++++---------
 tools/perf/Makefile               |   30 ++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index bd498d4..4626a39 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -178,8 +178,8 @@ install-pdf: pdf
 	$(INSTALL) -d -m 755 $(DESTDIR)$(pdfdir)
 	$(INSTALL) -m 644 user-manual.pdf $(DESTDIR)$(pdfdir)
 
-install-html: html
-	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
+#install-html: html
+#	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
 ../PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) PERF-VERSION-FILE
@@ -288,15 +288,16 @@ $(patsubst %.txt,%.html,$(wildcard howto/*.txt)): %.html : %.txt
 	sed -e '1,/^$$/d' $< | $(ASCIIDOC) -b xhtml11 - >$@+ && \
 	mv $@+ $@
 
-install-webdoc : html
-	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(WEBDOC_DEST)
+# UNIMPLEMENTED
+#install-webdoc : html
+#	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(WEBDOC_DEST)
 
-quick-install: quick-install-man
+# quick-install: quick-install-man
 
-quick-install-man:
-	'$(SHELL_PATH_SQ)' ./install-doc-quick.sh $(DOC_REF) $(DESTDIR)$(mandir)
+# quick-install-man:
+#	'$(SHELL_PATH_SQ)' ./install-doc-quick.sh $(DOC_REF) $(DESTDIR)$(mandir)
 
-quick-install-html:
-	'$(SHELL_PATH_SQ)' ./install-doc-quick.sh $(HTML_REF) $(DESTDIR)$(htmldir)
+#quick-install-html:
+#	'$(SHELL_PATH_SQ)' ./install-doc-quick.sh $(HTML_REF) $(DESTDIR)$(htmldir)
 
 .PHONY: .FORCE-PERF-VERSION-FILE
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ffd1047..7c75f1d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1102,6 +1102,36 @@ $(sort $(dir $(DIRECTORY_DEPS))):
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
+help:
+	@echo 'Perf make targets:'
+	@echo '  doc		- make *all* documentation (see below)'
+	@echo '  man		- make manpage documentation (access with man <foo>)'
+	@echo '  html		- make html documentation'
+	@echo '  info		- make GNU info documentation (access with info <foo>)'
+	@echo '  pdf		- make pdf documentation'
+	@echo '  TAGS		- use etags to make tag information for source browsing'
+	@echo '  tags		- use ctags to make tag information for source browsing'
+	@echo '  cscope	- use cscope to make interactive browsing database'
+	@echo ''
+	@echo 'Perf install targets:'
+	@echo '  NOTE: documentation build requires asciidoc, xmlto packages to be installed'
+	@echo '  HINT: use "make prefix=<path> <install target>" to install to a particular'
+	@echo '        path like make prefix=/usr/local install install-doc'
+	@echo '  install	- install compiled binaries'
+	@echo '  install-doc	- install *all* documentation'
+	@echo '  install-man	- install manpage documentation'
+	@echo '  install-html	- install html documentation'
+	@echo '  install-info	- install GNU info documentation'
+	@echo '  install-pdf	- install pdf documentation'
+	@echo ''
+	@echo '  quick-install-doc	- alias for quick-install-man'
+	@echo '  quick-install-man	- install the documentation quickly'
+	@echo '  quick-install-html	- install the html documentation quickly'
+	@echo ''
+	@echo 'Perf maintainer targets:'
+	@echo '  distclean		- alias to clean'
+	@echo '  clean			- clean all binary objects and build output'
+
 doc:
 	$(MAKE) -C Documentation all
 
