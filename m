Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2DTJjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:39:21 -0400
Received: from grania.neolocation.net ([91.149.189.243]:39562 "EHLO
	grania.neolocation.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2DTJjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:39:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tekinsoft.com;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:DomainKey-Status;
	b=KEkV14rsr9q8Vy5I0IJUF5bVCL6ivhFbyJdicsjZo6XW9HoL05X0/AtNTjHfpFhJSdlNmZ0N785HFMt1dh3bhis0NPTRrklSwu5V69eZiwokUbuo9Tx2HhZ251NpYlnMaLRyBE4ggP2+SqynnP2cAtXC9oOtyI7hTwEdun2bJQY=;
From: Yuri Matylitski <ym@tekinsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <jhovold@gmail.com>,
        Preston Fick <preston.fick@silabs.com>,
        Yuri Matylitski <ym@tekinsoft.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kirill@shutemov.name, Yuri Matylitski <ym@tekinsoft.com>
Subject: [PATCH] Fixed usb_control_msg timeout values in cp210x driver
Date: Fri, 20 Apr 2012 12:38:32 +0300
Message-Id: <1334914712-7642-1-git-send-email-ym@tekinsoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334910722-7357-1-git-send-email-ym@tekinsoft.com>
References: <1334910722-7357-1-git-send-email-ym@tekinsoft.com>
DomainKey-Status: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed too small hardcoded timeout values for usb_control_msg
in driver for SiliconLabs cp210x-based usb-to-serial adapters.
Replaced with USB_CTRL_GET_TIMEOUT/USB_CTRL_SET_TIMEOUT.

Signed-off-by: Yuri Matylitski <ym@tekinsoft.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 drivers/usb/serial/cp210x.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 0310e2d..e56066b 100644
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
1.7.0.4

