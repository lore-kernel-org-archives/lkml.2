Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2KNJQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:16:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40339 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab2KNJQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:16:08 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: wfp5p@virginia.edu, geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: dgrp: dgrp_tty.c: return an -EFAULT if get_user() fails
Date: Wed, 14 Nov 2012 13:11:18 +0530
Message-Id: <1352878879-19840-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspect the return value of get_user() and return -EFAULT on error.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/dgrp/dgrp_tty.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index b294197..720940f 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -2286,7 +2286,8 @@ static int set_modem_info(struct ch_struct *ch, unsigned int command,
 	if (error == 0)
 		return -EFAULT;
 
-	get_user(arg, (unsigned int __user *) value);
+	if (get_user(arg, (unsigned int __user *) value))
+		return -EFAULT;
 	mval |= ((arg & TIOCM_RTS) ? DM_RTS : 0)
 		| ((arg & TIOCM_DTR) ? DM_DTR : 0);
 
@@ -2626,7 +2627,8 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		return 0;
 
 	case TIOCSSOFTCAR:
-		get_user(arg, (unsigned long __user *) arg);
+		if (get_user(arg, (unsigned long __user *) arg))
+			return -EFAULT;
 		tty->termios.c_cflag =
 			((tty->termios.c_cflag & ~CLOCAL) |
 			 (arg ? CLOCAL : 0));
@@ -2864,7 +2866,8 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	{
 		int new_rate;
 
-		get_user(new_rate, (unsigned int __user *) arg);
+		if (get_user(new_rate, (unsigned int __user *) arg))
+			return -EFAULT;
 		dgrp_set_custom_speed(ch, new_rate);
 
 		break;
-- 
1.7.9.5

