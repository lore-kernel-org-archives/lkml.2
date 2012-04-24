Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2DXWiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:38:01 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab2DXWh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:59 -0400
Message-Id: <20120424223254.943787527@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yuri Matylitski <ym@tekinsoft.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [ 17/42] USB: serial: cp210x: Fixed usb_control_msg timeout values
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Matylitski <ym@tekinsoft.com>

commit 2d5733fcd33dd451022d197cb6b476e970519ca7 upstream.

Fixed too small hardcoded timeout values for usb_control_msg
in driver for SiliconLabs cp210x-based usb-to-serial adapters.
Replaced with USB_CTRL_GET_TIMEOUT/USB_CTRL_SET_TIMEOUT.

Signed-off-by: Yuri Matylitski <ym@tekinsoft.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -285,7 +285,8 @@ static int cp210x_get_config(struct usb_
 	/* Issue the request, attempting to read 'size' bytes */
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
-				port_priv->bInterfaceNumber, buf, size, 300);
+				port_priv->bInterfaceNumber, buf, size,
+				USB_CTRL_GET_TIMEOUT);
 
 	/* Convert data into an array of integers */
 	for (i = 0; i < length; i++)
@@ -335,12 +336,14 @@ static int cp210x_set_config(struct usb_
 		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
 				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
-				port_priv->bInterfaceNumber, buf, size, 300);
+				port_priv->bInterfaceNumber, buf, size,
+				USB_CTRL_SET_TIMEOUT);
 	} else {
 		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
 				request, REQTYPE_HOST_TO_DEVICE, data[0],
-				port_priv->bInterfaceNumber, NULL, 0, 300);
+				port_priv->bInterfaceNumber, NULL, 0,
+				USB_CTRL_SET_TIMEOUT);
 	}
 
 	kfree(buf);


