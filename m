Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1HATB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:01:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:50480 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1HATBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:01:44 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 1/4] kdb: cleanup unused variables missed in the original kdb merge
Date: Mon, 1 Aug 2011 14:00:57 -0500
Message-ID: <1312225260-1028-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
References: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BTARGS and BTSYMARG variables do not have any function in the
mainline version of kdb.

Reported-by: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_bt.c   |    5 ++---
 kernel/debug/kdb/kdb_cmds   |    4 ----
 kernel/debug/kdb/kdb_main.c |    2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/debug/kdb/kdb_bt.c b/kernel/debug/kdb/kdb_bt.c
index 2f62fe8..7179eac 100644
--- a/kernel/debug/kdb/kdb_bt.c
+++ b/kernel/debug/kdb/kdb_bt.c
@@ -112,9 +112,8 @@ kdb_bt(int argc, const char **argv)
 	unsigned long addr;
 	long offset;
 
-	kdbgetintenv("BTARGS", &argcount);	/* Arguments to print */
-	kdbgetintenv("BTAPROMPT", &btaprompt);	/* Prompt after each
-						 * proc in bta */
+	/* Prompt after each proc in bta */
+	kdbgetintenv("BTAPROMPT", &btaprompt);
 
 	if (strcmp(argv[0], "bta") == 0) {
 		struct task_struct *g, *p;
diff --git a/kernel/debug/kdb/kdb_cmds b/kernel/debug/kdb/kdb_cmds
index 56c88e4..9834ad3 100644
--- a/kernel/debug/kdb/kdb_cmds
+++ b/kernel/debug/kdb/kdb_cmds
@@ -18,16 +18,12 @@ defcmd dumpcommon "" "Common kdb debugging"
 endefcmd
 
 defcmd dumpall "" "First line debugging"
-  set BTSYMARG 1
-  set BTARGS 9
   pid R
   -dumpcommon
   -bta
 endefcmd
 
 defcmd dumpcpu "" "Same as dumpall but only tasks on cpus"
-  set BTSYMARG 1
-  set BTARGS 9
   pid R
   -dumpcommon
   -btc
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index be14779..b33116e 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -145,7 +145,6 @@ static char *__env[] = {
 #endif
  "RADIX=16",
  "MDCOUNT=8",			/* lines of md output */
- "BTARGS=9",			/* 9 possible args in bt */
  KDB_PLATFORM_ENV,
  "DTABCOUNT=30",
  "NOSECT=1",
@@ -172,6 +171,7 @@ static char *__env[] = {
  (char *)0,
  (char *)0,
  (char *)0,
+ (char *)0,
 };
 
 static const int __nenv = (sizeof(__env) / sizeof(char *));
-- 
1.7.1

