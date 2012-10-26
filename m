Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab2JZI5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:57:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61903 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab2JZI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:56:34 -0400
X-AuditID: 9c930179-b7c8bae000003559-53-508a503f6210
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Borislav Petkov <bp@amd64.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] perf tools: Convert invocation of MAKE into SUBDIR
Date: Fri, 26 Oct 2012 17:55:50 +0900
Message-Id: <1351241752-2919-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
References: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

This will show directory change info in a consistent form.  Also it
can be converted again into David Howell's descend command.

Cc: Borislav Petkov <bp@amd64.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5cf40cbdaaf9..2d0c09ab58b8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -985,7 +985,7 @@ INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
 
 # 'make doc' should call 'make -C Documentation all'
 $(DOC_TARGETS):
-	$(MAKE) -C Documentation $(@:doc=all)
+	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:doc=all)
 
 TAGS:
 	$(RM) TAGS
@@ -1058,7 +1058,7 @@ install-python_ext:
 
 # 'make install-doc' should call 'make -C Documentation install'
 $(INSTALL_DOC_TARGETS):
-	$(MAKE) -C Documentation $(@:-doc=)
+	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:-doc=)
 
 ### Cleaning rules
 
@@ -1066,7 +1066,7 @@ clean: $(LIBTRACEEVENT)-clean
 	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
-	$(MAKE) -C Documentation/ clean
+	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
 	$(RM) $(OUTPUT)util/*-bison*
 	$(RM) $(OUTPUT)util/*-flex*
-- 
1.7.11.7

