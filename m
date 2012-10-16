Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2JPBVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:21:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47181 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2JPBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:21:14 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Colin Cross <ccross@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 1/7] kdb: Remove currently unused kdbtab_t->cmd_flags
Date: Mon, 15 Oct 2012 18:17:59 -0700
Message-Id: <1350350285-3095-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121016011724.GB23146@lizard>
References: <20121016011724.GB23146@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct member is never used in the code, so we can remove it.

We will introduce real flags soon by renaming cmd_repeat to cmd_flags.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/debug/kdb/kdb_main.c    | 1 -
 kernel/debug/kdb/kdb_private.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 4d5f8d5..cdaaa52 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2748,7 +2748,6 @@ int kdb_register_repeat(char *cmd,
 	kp->cmd_func   = func;
 	kp->cmd_usage  = usage;
 	kp->cmd_help   = help;
-	kp->cmd_flags  = 0;
 	kp->cmd_minlen = minlen;
 	kp->cmd_repeat = repeat;
 
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 392ec6a..f8245b3 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -175,7 +175,6 @@ typedef struct _kdbtab {
 	kdb_func_t cmd_func;		/* Function to execute command */
 	char    *cmd_usage;		/* Usage String for this command */
 	char    *cmd_help;		/* Help message for this command */
-	short    cmd_flags;		/* Parsing flags */
 	short    cmd_minlen;		/* Minimum legal # command
 					 * chars required */
 	kdb_repeat_t cmd_repeat;	/* Does command auto repeat on enter? */
-- 
1.7.12.3

