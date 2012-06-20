Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab2FTSeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:34:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2FTSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:03 -0400
Message-Id: <20120620173024.533370616@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 42/61] USB: cdc-wdm: Add Vodafone/Huawei K5005 support
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit de102ef41f24a4c251c4a3838796bb27557d4d93 upstream.

Tested-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -55,6 +55,15 @@ static const struct usb_device_id wdm_id
 		.bInterfaceSubClass = 1,
 		.bInterfaceProtocol = 9, /* NOTE: CDC ECM control interface! */
 	},
+	{
+		 /* Vodafone/Huawei K5005 (12d1:14c8) and similar modems */
+		.match_flags        = USB_DEVICE_ID_MATCH_VENDOR |
+				      USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = HUAWEI_VENDOR_ID,
+		.bInterfaceClass    = USB_CLASS_VENDOR_SPEC,
+		.bInterfaceSubClass = 1,
+		.bInterfaceProtocol = 57, /* NOTE: CDC ECM control interface! */
+	},
 	{ }
 };
 


