Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2EBPCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:02:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35920 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2EBPCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:02:35 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] perf tools: Fix Makefile to clean auto-generated bison/flex files properly
Date: Sat, 28 Jan 2012 01:50:56 -0800
Message-Id: <1327744256-10786-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 65f3e56e0c81 ("perf tools: Remove auto-generated bison/flex
files") removed those files from git and modified Makefile to clean
auto-generated bison/flex files. But, in Makefile, regular expression
"*-{bison,flex}*" doesn't work. Fix it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9bf3fc7..295c477 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -987,7 +987,7 @@ clean:
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-	$(RM) $(OUTPUT)util/*-{bison,flex}*
+	$(RM) $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(python-clean)
 
 .PHONY: all install clean strip
-- 
1.7.0.4

