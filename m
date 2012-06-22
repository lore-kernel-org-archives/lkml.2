Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab2FVP13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:27:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40759 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab2FVP10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:27:26 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/12] kobil_sct: Fix some bogus tty handling
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:43:22 +0100
Message-ID: <20120622154251.1405.12270.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stuff noticed while doing the termios conversion.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/kobil_sct.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index fafeabb..0852472 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -192,8 +192,8 @@ static void kobil_init_termios(struct tty_struct *tty)
 {
 	/* Default to echo off and other sane device settings */
 	tty->termios->c_lflag = 0;
-	tty->termios->c_lflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
-	tty->termios->c_iflag = IGNBRK | IGNPAR | IXOFF;
+	tty->termios->c_iflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
+	tty->termios->c_iflag |= IGNBRK | IGNPAR | IXOFF;
 	/* do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D) */
 	tty->termios->c_oflag &= ~ONLCR;
 }
@@ -588,7 +588,7 @@ static void kobil_set_termios(struct tty_struct *tty,
 	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
 			priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID) {
 		/* This device doesn't support ioctl calls */
-		*tty->termios = *old;
+		tty_termios_copy_hw(tty->termios, old_termios);
 		return;
 	}
 

