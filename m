Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2JYAQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:16:58 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:60135 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2JYAQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:16:57 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH v2] staging/comedi: Use pr_ or dev_ printks in drivers/serial2002.c
Date: Thu, 25 Oct 2012 09:16:49 +0900
Message-Id: <1351124209-5338-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121022195156.GC8567@kroah.com>
References: <20121022195156.GC8567@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

and added pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/serial2002.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 5bf84cf..91fb8b1 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -31,6 +31,8 @@ Status: in development
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "../comedidev.h"
 
 #include <linux/delay.h>
@@ -282,7 +284,7 @@ static struct serial_data serial_read(struct file *f, int timeout)
 
 		length++;
 		if (data < 0) {
-			printk(KERN_ERR "serial2002 error\n");
+			pr_err("Failed to read serial.\n");
 			break;
 		} else if (data & 0x80) {
 			result.value = (result.value << 7) | (data & 0x7f);
@@ -355,7 +357,7 @@ static int serial_2002_open(struct comedi_device *dev)
 	devpriv->tty = filp_open(port, O_RDWR, 0);
 	if (IS_ERR(devpriv->tty)) {
 		result = (int)PTR_ERR(devpriv->tty);
-		printk(KERN_ERR "serial_2002: file open error = %d\n", result);
+		dev_err(dev->class_dev, "file open error = %d\n", result);
 	} else {
 		struct config_t {
 
-- 
1.7.9.5

