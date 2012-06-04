Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380Ab2FDLkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:32 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44999 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 20/24] TTY: usb-serial, use tty_port_install
Date: Mon,  4 Jun 2012 13:35:34 +0200
Message-Id: <1338809738-18967-21-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To have tty->port set in ->install.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/usb-serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 6a1b609..2dc92d5 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -207,7 +207,7 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 	if (retval)
 		goto error_get_interface;
 
-	retval = tty_standard_install(driver, tty);
+	retval = tty_port_install(&port->port, driver, tty);
 	if (retval)
 		goto error_init_termios;
 
-- 
1.7.10.3


