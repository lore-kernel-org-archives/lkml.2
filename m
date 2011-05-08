Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab1EHXDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:03:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab1EHWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ryw4XPqBHHVFX9UfaOB9VHpr2a8WSW9zmEH7jbAsh8+iGnN6C4YHP/kSnhSqdNImEY
         LpsdYBNJqqLwtpowg0OhQcG7UjjlyvJ4MTM/uFo3sPwRBn+psOvoyR7qwt+G3WsOD2yw
         qUGOYo5vbHtOUdKx/Jiyjq/3en3D2LXo1t43E=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 019/115] sysctl: remove .child from kernel/pty
Date: Mon,  9 May 2011 00:38:31 +0200
Message-Id: <1304894407-32201-20-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/tty/pty.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 2107747..2a40b34 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -469,25 +469,12 @@ static struct ctl_table pty_table[] = {
 	{}
 };
 
-static struct ctl_table pty_kern_table[] = {
-	{
-		.procname	= "pty",
-		.mode		= 0555,
-		.child		= pty_table,
-	},
-	{}
+static const __initdata struct ctl_path pty_path[] = {
+	{ .procname = "kernel" },
+	{ .procname = "pty" },
+	{ }
 };
 
-static struct ctl_table pty_root_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= pty_kern_table,
-	},
-	{}
-};
-
-
 static int pty_unix98_ioctl(struct tty_struct *tty,
 			    unsigned int cmd, unsigned long arg)
 {
@@ -750,7 +737,7 @@ static void __init unix98_pty_init(void)
 	if (tty_register_driver(pts_driver))
 		panic("Couldn't register Unix98 pts driver");
 
-	register_sysctl_table(pty_root_table);
+	register_sysctl_paths(pty_path, pty_table);
 
 	/* Now create the /dev/ptmx special device */
 	tty_default_fops(&ptmx_fops);
-- 
1.7.5.134.g1c08b

