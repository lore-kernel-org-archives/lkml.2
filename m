Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2KIVdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:33:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59710 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2KIVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:33:10 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/4] staging/serqt_usb2: fixed line over issue in serqt_usb2.c
Date: Sat, 10 Nov 2012 06:33:02 +0900
Message-Id: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a description of the procedure call dev_dbg().

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   59 +++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 099bc69..9bc8923 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -272,7 +272,8 @@ static void qt_write_bulk_callback(struct urb *urb)
 	status = urb->status;
 
 	if (status) {
-		dev_dbg(&urb->dev->dev, "nonzero write bulk status received:%d\n", status);
+		dev_dbg(&urb->dev->dev,
+			"nonzero write bulk status received:%d\n", status);
 		return;
 	}
 
@@ -321,7 +322,8 @@ static void qt_read_bulk_callback(struct urb *urb)
 	/* index = MINOR(port->tty->device) - serial->minor; */
 	index = tty->index - serial->minor;
 
-	dev_dbg(&port->dev, "%s - port->RxHolding = %d\n", __func__, qt_port->RxHolding);
+	dev_dbg(&port->dev,
+		"%s - port->RxHolding = %d\n", __func__, qt_port->RxHolding);
 
 	if (port_paranoia_check(port, __func__) != 0) {
 		qt_port->ReadBulkStopped = 1;
@@ -333,7 +335,8 @@ static void qt_read_bulk_callback(struct urb *urb)
 
 	if (qt_port->closePending == 1) {
 		/* Were closing , stop reading */
-		dev_dbg(&port->dev, "%s - (qt_port->closepending == 1\n", __func__);
+		dev_dbg(&port->dev,
+			"%s - (qt_port->closepending == 1\n", __func__);
 		qt_port->ReadBulkStopped = 1;
 		goto exit;
 	}
@@ -912,10 +915,14 @@ static int qt_open(struct tty_struct *tty,
 
 	dev_dbg(&port->dev, "port number is %d\n", port->number);
 	dev_dbg(&port->dev, "serial number is %d\n", port->serial->minor);
-	dev_dbg(&port->dev, "Bulkin endpoint is %d\n", port->bulk_in_endpointAddress);
-	dev_dbg(&port->dev, "BulkOut endpoint is %d\n", port->bulk_out_endpointAddress);
-	dev_dbg(&port->dev, "Interrupt endpoint is %d\n", port->interrupt_in_endpointAddress);
-	dev_dbg(&port->dev, "port's number in the device is %d\n", quatech_port->port_num);
+	dev_dbg(&port->dev,
+		"Bulkin endpoint is %d\n", port->bulk_in_endpointAddress);
+	dev_dbg(&port->dev,
+		"BulkOut endpoint is %d\n", port->bulk_out_endpointAddress);
+	dev_dbg(&port->dev, "Interrupt endpoint is %d\n",
+		port->interrupt_in_endpointAddress);
+	dev_dbg(&port->dev, "port's number in the device is %d\n",
+		quatech_port->port_num);
 	quatech_port->read_urb = port->read_urb;
 
 	/* set up our bulk in urb */
@@ -928,7 +935,8 @@ static int qt_open(struct tty_struct *tty,
 			  quatech_port->read_urb->transfer_buffer_length,
 			  qt_read_bulk_callback, quatech_port);
 
-	dev_dbg(&port->dev, "qt_open: bulkin endpoint is %d\n", port->bulk_in_endpointAddress);
+	dev_dbg(&port->dev, "qt_open: bulkin endpoint is %d\n",
+		port->bulk_in_endpointAddress);
 	quatech_port->read_urb_busy = true;
 	result = usb_submit_urb(quatech_port->read_urb, GFP_KERNEL);
 	if (result) {
@@ -1021,15 +1029,18 @@ static void qt_close(struct usb_serial_port *port)
 	/* Close uart channel */
 	status = qt_close_channel(serial, index);
 	if (status < 0)
-		dev_dbg(&port->dev, "%s - port %d qt_close_channel failed.\n", __func__, port->number);
+		dev_dbg(&port->dev,
+			"%s - port %d qt_close_channel failed.\n",
+			__func__, port->number);
 
 	port0->open_ports--;
 
-	dev_dbg(&port->dev, "qt_num_open_ports in close%d:in port%d\n", port0->open_ports, port->number);
+	dev_dbg(&port->dev, "qt_num_open_ports in close%d:in port%d\n",
+		port0->open_ports, port->number);
 
 	if (port0->open_ports == 0) {
 		if (serial->port[0]->interrupt_in_urb) {
-			dev_dbg(&port->dev, "%s", "Shutdown interrupt_in_urb\n");
+			dev_dbg(&port->dev, "Shutdown interrupt_in_urb\n");
 			usb_kill_urb(serial->port[0]->interrupt_in_urb);
 		}
 
@@ -1053,7 +1064,8 @@ static int qt_write(struct tty_struct *tty, struct usb_serial_port *port,
 		return -ENODEV;
 
 	if (count == 0) {
-		dev_dbg(&port->dev, "%s - write request of 0 bytes\n", __func__);
+		dev_dbg(&port->dev,
+			"%s - write request of 0 bytes\n", __func__);
 		return 0;
 	}
 
@@ -1080,7 +1092,8 @@ static int qt_write(struct tty_struct *tty, struct usb_serial_port *port,
 		/* send the data out the bulk port */
 		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 		if (result)
-			dev_dbg(&port->dev, "%s - failed submitting write urb, error %d\n",
+			dev_dbg(&port->dev,
+				"%s - failed submitting write urb, error %d\n",
 				__func__, result);
 		else
 			result = count;
@@ -1163,7 +1176,8 @@ static int qt_ioctl(struct tty_struct *tty,
 		return 0;
 	}
 
-	dev_dbg(&port->dev, "%s -No ioctl for that one.  port = %d\n", __func__, port->number);
+	dev_dbg(&port->dev, "%s -No ioctl for that one.  port = %d\n",
+		__func__, port->number);
 	return -ENOIOCTLCMD;
 }
 
@@ -1238,7 +1252,8 @@ static void qt_set_termios(struct tty_struct *tty,
 
 	/* Now determine flow control */
 	if (cflag & CRTSCTS) {
-		dev_dbg(&port->dev, "%s - Enabling HW flow control port %d\n", __func__, port->number);
+		dev_dbg(&port->dev, "%s - Enabling HW flow control port %d\n",
+			__func__, port->number);
 
 		/* Enable RTS/CTS flow control */
 		status = BoxSetHW_FlowCtrl(port->serial, index, 1);
@@ -1249,7 +1264,9 @@ static void qt_set_termios(struct tty_struct *tty,
 		}
 	} else {
 		/* Disable RTS/CTS flow control */
-		dev_dbg(&port->dev, "%s - disabling HW flow control port %d\n", __func__, port->number);
+		dev_dbg(&port->dev,
+			"%s - disabling HW flow control port %d\n",
+			__func__, port->number);
 
 		status = BoxSetHW_FlowCtrl(port->serial, index, 0);
 		if (status < 0) {
@@ -1268,17 +1285,21 @@ static void qt_set_termios(struct tty_struct *tty,
 		    BoxSetSW_FlowCtrl(port->serial, index, stop_char,
 				      start_char);
 		if (status < 0)
-			dev_dbg(&port->dev, "BoxSetSW_FlowCtrl (enabled) failed\n");
+			dev_dbg(&port->dev,
+				"BoxSetSW_FlowCtrl (enabled) failed\n");
 
 	} else {
 		/* disable SW flow control */
 		status = BoxDisable_SW_FlowCtrl(port->serial, index);
 		if (status < 0)
-			dev_dbg(&port->dev, "BoxSetSW_FlowCtrl (diabling) failed\n");
+			dev_dbg(&port->dev,
+				"BoxSetSW_FlowCtrl (diabling) failed\n");
 
 	}
 	termios->c_cflag &= ~CMSPAR;
-	/* FIXME: Error cases should be returning the actual bits changed only */
+	/* FIXME:
+	   Error cases should be returning the actual bits changed only
+	*/
 }
 
 static void qt_break(struct tty_struct *tty, int break_state)
-- 
1.7.9.5

