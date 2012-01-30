Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab2A3UV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:21:57 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:39613 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab2A3UV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:21:56 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, jirislaby@gmail.com
Subject: [PATCH 3/5] TTY: use tty_standard_install
Date: Mon, 30 Jan 2012 21:14:30 +0100
Message-Id: <1327954472-26594-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the helper in the rest of the tty drivers. This is a simple
replacement.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/isdn/capi/capi.c     |    9 +++------
 drivers/misc/pti.c           |    6 +-----
 drivers/mmc/card/sdio_uart.c |    9 +++------
 drivers/tty/nozomi.c         |    8 ++------
 4 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index e44933d..ca9261a 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1015,14 +1015,11 @@ capinc_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	int idx = tty->index;
 	struct capiminor *mp = capiminor_get(idx);
-	int ret = tty_init_termios(tty);
+	int ret = tty_standard_install(tty);
 
-	if (ret == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
+	if (ret == 0)
 		tty->driver_data = mp;
-		driver->ttys[idx] = tty;
-	} else
+	else
 		capiminor_put(mp);
 	return ret;
 }
diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 0b56e3f..f05c646 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -481,13 +481,9 @@ static int pti_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	int idx = tty->index;
 	struct pti_tty *pti_tty_data;
-	int ret = tty_init_termios(tty);
+	int ret = tty_standard_install(tty);
 
 	if (ret == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
-		driver->ttys[idx] = tty;
-
 		pti_tty_data = kmalloc(sizeof(struct pti_tty), GFP_KERNEL);
 		if (pti_tty_data == NULL)
 			return -ENOMEM;
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 2c151e1..3206867 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -750,15 +750,12 @@ static int sdio_uart_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	int idx = tty->index;
 	struct sdio_uart_port *port = sdio_uart_port_get(idx);
-	int ret = tty_init_termios(tty);
+	int ret = tty_standard_install(tty);
 
-	if (ret == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
+	if (ret == 0)
 		/* This is the ref sdio_uart_port get provided */
 		tty->driver_data = port;
-		driver->ttys[idx] = tty;
-	} else
+	else
 		sdio_uart_port_put(port);
 	return ret;
 }
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index fd347ff..51f8576 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1602,13 +1602,9 @@ static int ntty_install(struct tty_driver *driver, struct tty_struct *tty)
 	int ret;
 	if (!port || !dc || dc->state != NOZOMI_STATE_READY)
 		return -ENODEV;
-	ret = tty_init_termios(tty);
-	if (ret == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
+	ret = tty_standard_install(tty);
+	if (ret == 0)
 		tty->driver_data = port;
-		driver->ttys[tty->index] = tty;
-	}
 	return ret;
 }
 
-- 
1.7.8.3


