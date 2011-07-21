Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1GUJTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:19:10 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57248 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1GUJSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:18:47 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 09/10] um: Ajdust size of pid_buf
Date: Thu, 21 Jul 2011 11:18:33 +0200
Message-Id: <1311239914-8301-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311239914-8301-1-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux can have pids up to 4*1024*1024.
To handle such huge numbers pid_buf needs to be larger.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/harddog_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/harddog_user.c b/arch/um/drivers/harddog_user.c
index b56f8e0..84dce3f 100644
--- a/arch/um/drivers/harddog_user.c
+++ b/arch/um/drivers/harddog_user.c
@@ -32,7 +32,7 @@ int start_watchdog(int *in_fd_ret, int *out_fd_ret, char *sock)
 {
 	struct dog_data data;
 	int in_fds[2], out_fds[2], pid, n, err;
-	char pid_buf[sizeof("nnnnn\0")], c;
+	char pid_buf[sizeof("nnnnnnn\0")], c;
 	char *pid_args[] = { "/usr/bin/uml_watchdog", "-pid", pid_buf, NULL };
 	char *mconsole_args[] = { "/usr/bin/uml_watchdog", "-mconsole", NULL,
 				  NULL };
-- 
1.7.6

