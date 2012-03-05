Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2CENxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:11 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34615 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2CENxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 01/68] USB: cdc-acm, use tty_standard_install
Date: Mon,  5 Mar 2012 14:51:48 +0100
Message-Id: <1330955575-26641-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a piece I missed the last time.

Do not copy the functionality all over the tree. Instead, use the
helper the tty layer provides us with.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 6dcc3a3..b3fd449 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -509,17 +509,12 @@ static int acm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 	if (!acm)
 		return -ENODEV;
 
-	retval = tty_init_termios(tty);
+	retval = tty_standard_install(driver, tty);
 	if (retval)
 		goto error_init_termios;
 
 	tty->driver_data = acm;
 
-	/* Final install (we use the default method) */
-	tty_driver_kref_get(driver);
-	tty->count++;
-	driver->ttys[tty->index] = tty;
-
 	return 0;
 
 error_init_termios:
-- 
1.7.9.2


