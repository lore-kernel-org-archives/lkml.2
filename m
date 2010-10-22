Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab0JVU6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:58:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:36320 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab0JVU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:57:07 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 06/11] kdb: Fix oops in kdb_unregister
Date: Fri, 22 Oct 2010 15:56:26 -0500
Message-Id: <1287780991-7476-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Oct 2010 20:56:52.0659 (UTC) FILETIME=[A7531030:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing should try to use kdb_commands directly as sometimes it is
null.  Instead, use the for_each_kdbcmd() iterator.

This particular problem dates back to the initial kdb merge (2.6.35),
but at that point nothing was dynamically unregistering commands from
the kdb shell.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 5448990..4226f32 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2826,7 +2826,7 @@ int kdb_unregister(char *cmd)
 	/*
 	 *  find the command.
 	 */
-	for (i = 0, kp = kdb_commands; i < kdb_max_commands; i++, kp++) {
+	for_each_kdbcmd(kp, i) {
 		if (kp->cmd_name && (strcmp(kp->cmd_name, cmd) == 0)) {
 			kp->cmd_name = NULL;
 			return 0;
-- 
1.6.3.3

