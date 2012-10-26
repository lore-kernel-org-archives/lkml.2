Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab2JZOdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:33:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:44283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377Ab2JZOcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@amd64.org>,
        David Howells <dhowells@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/9] perf tools: Convert invocation of MAKE into SUBDIR
Date: Fri, 26 Oct 2012 12:31:47 -0200
Message-Id: <1351261913-28250-4-git-send-email-acme@infradead.org>
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

This will show directory change info in a consistent form.  Also it can
be converted again into David Howell's descend command.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351241752-2919-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5cf40cb..2d0c09a 100644
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
1.7.9.2.358.g22243

