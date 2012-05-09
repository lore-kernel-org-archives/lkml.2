Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab2EIG0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:26:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38812 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755895Ab2EIFxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:02 -0400
Message-Id: <20120509055033.296383170@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yuri Matylitski <ym@tekinsoft.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 027/167] [PATCH] USB: serial: cp210x: Fixed usb_control_msg timeout values
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Matylitski <ym@tekinsoft.com>

commit 2d5733fcd33dd451022d197cb6b476e970519ca7 upstream.

Fixed too small hardcoded timeout values for usb_control_msg
in driver for SiliconLabs cp210x-based usb-to-serial adapters.
Replaced with USB_CTRL_GET_TIMEOUT/USB_CTRL_SET_TIMEOUT.

Signed-off-by: Yuri Matylitski <ym@tekinsoft.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/cp210x.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 0310e2d..ec30f95 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -287,7 +287,8 @@ static int cp210x_get_config(struct usb_serial_port *port, u8 request,
 	/* Issue the request, attempting to read 'size' bytes */
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
-				port_priv->bInterfaceNumber, buf, size, 300);
+				port_priv->bInterfaceNumber, buf, size,
+				USB_CTRL_GET_TIMEOUT);
 
 	/* Convert data into an array of integers */
 	for (i = 0; i < length; i++)
@@ -340,12 +341,14 @@ static int cp210x_set_config(struct usb_serial_port *port, u8 request,
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
-- 
1.7.10



