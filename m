Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2G2Vz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 17:55:26 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39345 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2G2VzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 17:55:24 -0400
From: Palmer Cox <p@lmercox.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Palmer Cox <p@lmercox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Remove brace expansion from clean target
Date: Sun, 29 Jul 2012 17:54:43 -0400
Message-Id: <1343598883-17907-1-git-send-email-p@lmercox.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clean target uses brace expansion to remove some generated
files. However, the default shells on many systems do not
support this feature resulting in some generated files not
being removed by clean.

Signed-off-by: Palmer Cox <p@lmercox.com>
---
 tools/perf/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 75d74e5..842cf67 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -979,7 +979,8 @@ clean:
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-	$(RM) $(OUTPUT)util/*-{bison,flex}*
+	$(RM) $(OUTPUT)util/*-bison*
+	$(RM) $(OUTPUT)util/*-flex*
 	$(python-clean)
 
 .PHONY: all install clean strip $(LIBTRACEEVENT)
-- 
1.7.9.5

