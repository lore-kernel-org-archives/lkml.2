Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1BPWy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:54:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1BPWyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:54:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf tools: Update Makefile with some help
Date: Wed, 16 Feb 2011 20:54:45 -0200
Message-Id: <1297896887-9983-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297896887-9983-1-git-send-email-acme@infradead.org>
References: <1297896887-9983-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

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
 
-- 
1.6.2.5

