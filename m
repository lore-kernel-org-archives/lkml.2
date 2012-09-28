Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab2I1TFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:05:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053Ab2I1TFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:05:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Henrik Rydberg <rydberg@euromail.se>, Shea Levy <shea@shealevy.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 221/262] Bluetooth: Add support for Apple vendor-specific devices
Date: Fri, 28 Sep 2012 11:52:30 -0700
Message-Id: <20120928183024.292321416@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 1fa6535faf055cd71311ab887e94fc234f04ee18 upstream.

As pointed out by Gustavo and Marcel, all Apple-specific Broadcom
devices seen so far have the same interface class, subclass and
protocol numbers. This patch adds an entry which matches all of them,
using the new USB_VENDOR_AND_INTERFACE_INFO() macro.

In particular, this patch adds support for the MacBook Pro Retina
(05ac:8286), which is not in the present list.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Shea Levy <shea@shealevy.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -60,6 +60,9 @@ static struct usb_device_id btusb_table[
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
+	/* Apple-specific (Broadcom) devices */
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
+
 	/* Broadcom SoftSailing reporting vendor specific */
 	{ USB_DEVICE(0x0a5c, 0x21e1) },
 


