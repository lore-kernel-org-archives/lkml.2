Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2HEQ76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:59:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2HEQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:59:56 -0400
Date: Sun, 5 Aug 2012 09:59:39 -0700
From: tip-bot for Palmer Cox <p@lmercox.com>
Message-ID: <tip-7f309ed6453926a81e2a97d274f67f1e48f0d74c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, p@lmercox.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, p@lmercox.com
In-Reply-To: <1343598883-17907-1-git-send-email-p@lmercox.com>
References: <1343598883-17907-1-git-send-email-p@lmercox.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Remove brace expansion from clean target
Git-Commit-ID: 7f309ed6453926a81e2a97d274f67f1e48f0d74c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:59:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f309ed6453926a81e2a97d274f67f1e48f0d74c
Gitweb:     http://git.kernel.org/tip/7f309ed6453926a81e2a97d274f67f1e48f0d74c
Author:     Palmer Cox <p@lmercox.com>
AuthorDate: Sun, 29 Jul 2012 17:54:43 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Aug 2012 10:46:32 -0300

perf tools: Remove brace expansion from clean target

The clean target uses brace expansion to remove some generated files. However,
the default shells on many systems do not support this feature resulting in
some generated files not being removed by clean.

Signed-off-by: Palmer Cox <p@lmercox.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1343598883-17907-1-git-send-email-p@lmercox.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 32912af..35655c3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -987,7 +987,8 @@ clean:
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-	$(RM) $(OUTPUT)util/*-{bison,flex}*
+	$(RM) $(OUTPUT)util/*-bison*
+	$(RM) $(OUTPUT)util/*-flex*
 	$(python-clean)
 
 .PHONY: all install clean strip $(LIBTRACEEVENT)
