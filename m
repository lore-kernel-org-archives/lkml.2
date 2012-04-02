Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2DBMJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:09:37 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47937 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2DBLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 30/69] TTY: sclp_vt220, remove unused allocation
Date: Mon,  2 Apr 2012 13:54:14 +0200
Message-Id: <1333367693-3244-31-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

80 bytes which are allocated in tty->ops->open and assigned to
tty->driver_data are never used. Remove that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/sclp_vt220.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 25cf2e8..edfc0fd 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -34,7 +34,6 @@
 #define SCLP_VT220_DEVICE_NAME		"ttysclp"
 #define SCLP_VT220_CONSOLE_NAME		"ttyS"
 #define SCLP_VT220_CONSOLE_INDEX	1	/* console=ttyS1 */
-#define SCLP_VT220_BUF_SIZE		80
 
 /* Representation of a single write request */
 struct sclp_vt220_request {
@@ -496,9 +495,6 @@ sclp_vt220_open(struct tty_struct *tty, struct file *filp)
 {
 	if (tty->count == 1) {
 		tty_port_tty_set(&sclp_vt220_port, tty);
-		tty->driver_data = kmalloc(SCLP_VT220_BUF_SIZE, GFP_KERNEL);
-		if (tty->driver_data == NULL)
-			return -ENOMEM;
 		tty->low_latency = 0;
 		if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
 			tty->winsize.ws_row = 24;
@@ -514,11 +510,8 @@ sclp_vt220_open(struct tty_struct *tty, struct file *filp)
 static void
 sclp_vt220_close(struct tty_struct *tty, struct file *filp)
 {
-	if (tty->count == 1) {
+	if (tty->count == 1)
 		tty_port_tty_set(&sclp_vt220_port, NULL);
-		kfree(tty->driver_data);
-		tty->driver_data = NULL;
-	}
 }
 
 /*
-- 
1.7.9.2


