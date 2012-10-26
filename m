Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2JZI4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:56:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46717 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab2JZI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:56:33 -0400
X-AuditID: 9c930179-b7c8bae000003559-52-508a503e455d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 2/5] perf tools: Cleanup doc related targets
Date: Fri, 26 Oct 2012 17:55:49 +0900
Message-Id: <1351241752-2919-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
References: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Documentation targets handling rules are duplicate.  Consolidate them
with DOC_TARGETS and INSTALL_DOC_TARGETS.

Cc: Borislav Petkov <bp@amd64.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile | 46 +++++++++-------------------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b14eeb86d8d7..5cf40cbdaaf9 100644
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
1.7.11.7

