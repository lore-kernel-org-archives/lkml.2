Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2KMSGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:06:50 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:57318 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2KMSGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:06:47 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Till Harbaum <till@harbaum.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/2] i2c: i2c-tiny-usb: Add parameter for optional user-defined devices.
Date: Tue, 13 Nov 2012 19:06:08 +0100
Message-Id: <1352829968-4908-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is an example about how to use this functionality.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Till Harbaum <till@harbaum.org>
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Documentation/i2c/instantiating-devices | 2 ++
 drivers/i2c/busses/i2c-tiny-usb.c       | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/i2c/instantiating-devices b/Documentation/i2c/instantiating-devices
index 1dbfdf3..783a79f 100644
--- a/Documentation/i2c/instantiating-devices
+++ b/Documentation/i2c/instantiating-devices
@@ -246,3 +246,5 @@ modprobe my_i2c_bus devices=ds1307@0x68,pcf8563@0x51
 or even at the kernel command line with
 
 my_i2c_bus.devices=ds1307@0x68,pcf8563@0x51
+
+See the i2c-tiny-usb driver for an exmaple.
diff --git a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
index 0510636..9fd03c6 100644
--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -40,6 +40,8 @@ module_param(delay, ushort, 0);
 MODULE_PARM_DESC(delay, "bit delay in microseconds "
 		 "(default is 10us for 100kHz max)");
 
+MODULE_PARAM_I2C_OPTIONAL_DEVICES(opt_devices);
+
 static int usb_read(struct i2c_adapter *adapter, int cmd,
 		    int value, int index, void *data, int len);
 
@@ -236,6 +238,8 @@ static int i2c_tiny_usb_probe(struct usb_interface *interface,
 	/* inform user about successful attachment to i2c layer */
 	dev_info(&dev->adapter.dev, "connected i2c-tiny-usb device\n");
 
+	i2c_add_optional_devices(&dev->adapter, opt_devices);
+
 	return 0;
 
  error:
-- 
1.7.11.7

