Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201Ab2JZQGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:06:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818Ab2JZQGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:06:43 -0400
Date: Fri, 26 Oct 2012 08:05:24 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-536e2b0fc2af42a464ea6eb6b67a2c754e14f2e2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, bp@amd64.org, namhyung@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, bp@amd64.org,
        tglx@linutronix.de
In-Reply-To: <1351241752-2919-2-git-send-email-namhyung@kernel.org>
References: <1351241752-2919-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Cleanup doc related targets
Git-Commit-ID: 536e2b0fc2af42a464ea6eb6b67a2c754e14f2e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 08:05:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  536e2b0fc2af42a464ea6eb6b67a2c754e14f2e2
Gitweb:     http://git.kernel.org/tip/536e2b0fc2af42a464ea6eb6b67a2c754e14f2e2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 26 Oct 2012 17:55:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Oct 2012 11:22:24 -0200

perf tools: Cleanup doc related targets

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
 1 files changed, 9 insertions(+), 37 deletions(-)

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
 
