Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab2JZOcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:32:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:44267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2JZOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@amd64.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/9] perf tools: Cleanup doc related targets
Date: Fri, 26 Oct 2012 12:31:46 -0200
Message-Id: <1351261913-28250-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351261913-28250-1-git-send-email-acme@infradead.org>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Documentation targets handling rules are duplicate.  Consolidate them
with DOC_TARGETS and INSTALL_DOC_TARGETS.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351241752-2919-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   46 +++++++++-------------------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b14eeb8..5cf40cb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -977,20 +977,15 @@ help:
 	@echo 'Perf maintainer targets:'
 	@echo '  clean			- clean all binary objects and build output'
 
-doc:
-	$(MAKE) -C Documentation all
 
-man:
-	$(MAKE) -C Documentation man
+DOC_TARGETS := doc man html info pdf
 
-html:
-	$(MAKE) -C Documentation html
+INSTALL_DOC_TARGETS := $(patsubst %,install-%,$(DOC_TARGETS)) try-install-man
+INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
 
-info:
-	$(MAKE) -C Documentation info
-
-pdf:
-	$(MAKE) -C Documentation pdf
+# 'make doc' should call 'make -C Documentation all'
+$(DOC_TARGETS):
+	$(MAKE) -C Documentation $(@:doc=all)
 
 TAGS:
 	$(RM) TAGS
@@ -1061,32 +1056,9 @@ install: all try-install-man
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
 
-install-doc:
-	$(MAKE) -C Documentation install
-
-install-man:
-	$(MAKE) -C Documentation install-man
-
-try-install-man:
-	$(MAKE) -C Documentation try-install-man
-
-install-html:
-	$(MAKE) -C Documentation install-html
-
-install-info:
-	$(MAKE) -C Documentation install-info
-
-install-pdf:
-	$(MAKE) -C Documentation install-pdf
-
-quick-install-doc:
-	$(MAKE) -C Documentation quick-install
-
-quick-install-man:
-	$(MAKE) -C Documentation quick-install-man
-
-quick-install-html:
-	$(MAKE) -C Documentation quick-install-html
+# 'make install-doc' should call 'make -C Documentation install'
+$(INSTALL_DOC_TARGETS):
+	$(MAKE) -C Documentation $(@:-doc=)
 
 ### Cleaning rules
 
-- 
1.7.9.2.358.g22243

