Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966155Ab0CPNYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:24:00 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:51413 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964979Ab0CPNX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:23:58 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Oliver Neukum <oliver@neukum.org>
Subject: usbtouchscreen: support bigger iNexio touchscreens
Date: Tue, 16 Mar 2010 14:23:53 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003161423.54495.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bigger Nexio touchscreens not only send more data but also the header values
are modified somehow. Fix the header somehow (it's a guesswork but it works
at least on one 46" touchscreen with 2.00SMS firmware) and also increase
rept_size.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.34-rc1-orig/drivers/input/touchscreen/usbtouchscreen.c	2010-03-16 13:34:51.000000000 +0100
+++ linux-2.6.34-rc1/drivers/input/touchscreen/usbtouchscreen.c	2010-03-16 13:46:15.000000000 +0100
@@ -858,6 +858,11 @@
 	if ((pkt[0] & 0xe0) != 0xe0)
 		return 0;
 
+	if (be16_to_cpu(packet->data_len) > 0xff)
+		packet->data_len = cpu_to_be16(be16_to_cpu(packet->data_len) - 0x100);
+	if (be16_to_cpu(packet->x_len) > 0xff)
+		packet->x_len = cpu_to_be16(be16_to_cpu(packet->x_len) - 0x80);
+
 	/* send ACK */
 	ret = usb_submit_urb(priv->ack, GFP_ATOMIC);
 
@@ -1113,7 +1118,7 @@
 
 #ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
 	[DEVTYPE_NEXIO] = {
-		.rept_size	= 128,
+		.rept_size	= 1024,
 		.irq_always	= true,
 		.read_data	= nexio_read_data,
 		.init		= nexio_init,


-- 
Ondrej Zary
