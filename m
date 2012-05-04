Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab2EDSYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:24:14 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:5616 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324Ab2EDSYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:24:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1336155848!21366135!8
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove debug tracing in vmk80xx driver
Date: Fri, 4 May 2012 11:23:54 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041123.55261.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmk80xx driver uses a non-existant Kconfig symbol to enable
function call debug tracing. This output is really just noise
and doesn't serve any useful purpose. Remove all it's uses in
the driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index a7db686..d0e1065 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -151,27 +151,12 @@ MODULE_DEVICE_TABLE(usb, vmk80xx_id_table);
 #define URB_RCV_FLAG            (1 << 0)
 #define URB_SND_FLAG            (1 << 1)
 
-#define CONFIG_VMK80XX_DEBUG
-#undef CONFIG_VMK80XX_DEBUG
-
-#ifdef CONFIG_VMK80XX_DEBUG
-static int dbgvm = 1;
-#else
-static int dbgvm;
-#endif
-
 #ifdef CONFIG_COMEDI_DEBUG
 static int dbgcm = 1;
 #else
 static int dbgcm;
 #endif
 
-#define dbgvm(fmt, arg...)                     \
-do {                                           \
-	if (dbgvm)                             \
-		printk(KERN_DEBUG fmt, ##arg); \
-} while (0)
-
 #define dbgcm(fmt, arg...)                     \
 do {                                           \
 	if (dbgcm)                             \
@@ -254,8 +239,6 @@ static void vmk80xx_tx_callback(struct urb *urb)
 	struct vmk80xx_usb *dev = urb->context;
 	int stat = urb->status;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	if (stat && !(stat == -ENOENT
 		      || stat == -ECONNRESET || stat == -ESHUTDOWN))
 		dbgcm("comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
@@ -274,8 +257,6 @@ static void vmk80xx_rx_callback(struct urb *urb)
 	struct vmk80xx_usb *dev = urb->context;
 	int stat = urb->status;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	switch (stat) {
 	case 0:
 		break;
@@ -316,8 +297,6 @@ static int vmk80xx_check_data_link(struct vmk80xx_usb *dev)
 	unsigned char tx[1];
 	unsigned char rx[2];
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	tx_pipe = usb_sndbulkpipe(dev->udev, 0x01);
 	rx_pipe = usb_rcvbulkpipe(dev->udev, 0x81);
 
@@ -342,8 +321,6 @@ static void vmk80xx_read_eeprom(struct vmk80xx_usb *dev, int flag)
 	unsigned char rx[64];
 	int cnt;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	tx_pipe = usb_sndbulkpipe(dev->udev, 0x01);
 	rx_pipe = usb_rcvbulkpipe(dev->udev, 0x81);
 
@@ -371,8 +348,6 @@ static int vmk80xx_reset_device(struct vmk80xx_usb *dev)
 	int ival;
 	size_t size;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!urb)
 		return -ENOMEM;
@@ -410,8 +385,6 @@ static void vmk80xx_build_int_urb(struct urb *urb, int flag)
 	void (*callback) (struct urb *);
 	int ival;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	if (flag & URB_RCV_FLAG) {
 		rx_addr = dev->ep_rx->bEndpointAddress;
 		pipe = usb_rcvintpipe(dev->udev, rx_addr);
@@ -439,8 +412,6 @@ static void vmk80xx_do_bulk_msg(struct vmk80xx_usb *dev)
 	unsigned int rx_pipe;
 	size_t size;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	set_bit(TRANS_IN_BUSY, &dev->flags);
 	set_bit(TRANS_OUT_BUSY, &dev->flags);
 
@@ -468,8 +439,6 @@ static int vmk80xx_read_packet(struct vmk80xx_usb *dev)
 	struct urb *urb;
 	int retval;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	if (!dev->intf)
 		return -ENODEV;
 
@@ -516,8 +485,6 @@ static int vmk80xx_write_packet(struct vmk80xx_usb *dev, int cmd)
 	struct urb *urb;
 	int retval;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	if (!dev->intf)
 		return -ENODEV;
 
@@ -592,8 +559,6 @@ static int vmk80xx_ai_rinsn(struct comedi_device *cdev,
 	int reg[2];
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_IN);
 	if (n)
 		return n;
@@ -645,8 +610,6 @@ static int vmk80xx_ao_winsn(struct comedi_device *cdev,
 	int reg;
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_OUT);
 	if (n)
 		return n;
@@ -690,8 +653,6 @@ static int vmk80xx_ao_rinsn(struct comedi_device *cdev,
 	int reg;
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_IN);
 	if (n)
 		return n;
@@ -724,8 +685,6 @@ static int vmk80xx_di_bits(struct comedi_device *cdev,
 	int reg;
 	int retval;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	retval = rudimentary_check(dev, DIR_IN);
 	if (retval)
 		return retval;
@@ -770,8 +729,6 @@ static int vmk80xx_di_rinsn(struct comedi_device *cdev,
 	int inp;
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_IN);
 	if (n)
 		return n;
@@ -817,8 +774,6 @@ static int vmk80xx_do_winsn(struct comedi_device *cdev,
 	int cmd;
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_OUT);
 	if (n)
 		return n;
@@ -865,8 +820,6 @@ static int vmk80xx_do_rinsn(struct comedi_device *cdev,
 	int reg;
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_IN);
 	if (n)
 		return n;
@@ -899,8 +852,6 @@ static int vmk80xx_do_bits(struct comedi_device *cdev,
 	int dir, reg, cmd;
 	int retval;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	dir = 0;
 
 	if (data[0])
@@ -966,8 +917,6 @@ static int vmk80xx_cnt_rinsn(struct comedi_device *cdev,
 	int reg[2];
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_IN);
 	if (n)
 		return n;
@@ -1016,8 +965,6 @@ static int vmk80xx_cnt_cinsn(struct comedi_device *cdev,
 	int reg;
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_OUT);
 	if (n)
 		return n;
@@ -1064,8 +1011,6 @@ static int vmk80xx_cnt_winsn(struct comedi_device *cdev,
 	int cmd;
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_OUT);
 	if (n)
 		return n;
@@ -1110,8 +1055,6 @@ static int vmk80xx_pwm_rinsn(struct comedi_device *cdev,
 	int reg[2];
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_IN);
 	if (n)
 		return n;
@@ -1145,8 +1088,6 @@ static int vmk80xx_pwm_winsn(struct comedi_device *cdev,
 	int cmd;
 	int n;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	n = rudimentary_check(dev, DIR_OUT);
 	if (n)
 		return n;
@@ -1195,8 +1136,6 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	struct comedi_subdevice *s;
 	int minor;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	mutex_lock(&glb_mutex);
 
 	for (i = 0; i < VMK80XX_MAX_BOARDS; i++)
@@ -1316,8 +1255,6 @@ static int vmk80xx_detach(struct comedi_device *cdev)
 	struct vmk80xx_usb *dev;
 	int minor;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	if (!cdev)
 		return -EFAULT;
 
@@ -1350,8 +1287,6 @@ static int vmk80xx_probe(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *ep_desc;
 	size_t size;
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	mutex_lock(&glb_mutex);
 
 	for (i = 0; i < VMK80XX_MAX_BOARDS; i++)
@@ -1499,8 +1434,6 @@ static void vmk80xx_disconnect(struct usb_interface *intf)
 {
 	struct vmk80xx_usb *dev = usb_get_intfdata(intf);
 
-	dbgvm("vmk80xx: %s\n", __func__);
-
 	if (!dev)
 		return;
 
