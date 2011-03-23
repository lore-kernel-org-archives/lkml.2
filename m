Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1CWIuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:50:08 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:56910 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1CWIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:50:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/7] tty: VT, remove unused variable
Date: Wed, 23 Mar 2011 09:49:54 +0100
Message-Id: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/vt/vt_ioctl.c:1525:2: warning: Value stored to 'kbd' is never read
kbd = kbd_table + console;
^     ~~~~~~~~~~~~~~~~~~~

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/vt/vt_ioctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 937d172..8c7208a 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1499,7 +1499,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 {
 	struct vc_data *vc = tty->driver_data;
 	struct console_font_op op;	/* used in multiple places here */
-	struct kbd_struct *kbd;
 	unsigned int console;
 	void __user *up = (void __user *)arg;
 	int perm;
@@ -1522,7 +1521,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 	if (current->signal->tty == tty || capable(CAP_SYS_TTY_CONFIG))
 		perm = 1;
 
-	kbd = kbd_table + console;
 	switch (cmd) {
 	/*
 	 * these need special handlers for incompatible data structures
-- 
1.7.4.1


