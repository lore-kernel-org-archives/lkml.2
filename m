Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2KSM21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:28:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65154 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2KSM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:28:26 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: alan@lxorguk.ukuu.org.uk, dan.carpenter@oracle.com, wfp5p@virginia.edu,
        geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: dgrp: dgrp_tty.c: Remove the TIOCSSOFTCAR ioctl handler from dgrp driver
Date: Mon, 19 Nov 2012 17:57:51 +0530
Message-Id: <1353328071-12044-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the TIOCSSOFTCAR ioctl handler from dgrp driver to allow the core tty
layer to take care of this ioctl instead.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/dgrp/dgrp_tty.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index e125b03..b46f56f 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -2623,13 +2623,6 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg);
 		return 0;
 
-	case TIOCSSOFTCAR:
-		get_user(arg, (unsigned long __user *) arg);
-		tty->termios.c_cflag =
-			((tty->termios.c_cflag & ~CLOCAL) |
-			 (arg ? CLOCAL : 0));
-		return 0;
-
 	case TIOCMGET:
 		rc = access_ok(VERIFY_WRITE, (void __user *) arg,
 				 sizeof(unsigned int));
-- 
1.7.9.5

