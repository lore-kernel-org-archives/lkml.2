Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab1EABih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49864 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab1EABhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hiKxfMQtOfL8RGeXaCa9EgXJAM9MwYr3vBzQUs5iXIOKSC0TsLOwAoCfd7T4i1gGut
         Hnw9e1MMLw+oH2SKei7iBjSL7tqFaz0R39Q2dqec4VfdwcFe3awtccgi2m8oWAOWT/Ac
         sPEvQoxM8FHW5KOuLlemK35DYy7bUMWhc8dsQ=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 19/69] sysctl: remove .child from kernel/pty
Date: Sun,  1 May 2011 03:35:49 +0200
Message-Id: <1304213799-10257-20-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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

