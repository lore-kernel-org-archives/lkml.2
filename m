Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab2FQSc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:32:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50287 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758257Ab2FQSWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:47 -0400
Message-Id: <20120617175947.875700790@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        =?ISO-8859-15?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 46/69] USB: cdc-wdm: Add Vodafone/Huawei K5005 support
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit de102ef41f24a4c251c4a3838796bb27557d4d93 upstream.

Tested-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index ea8b304..8fd398d 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -55,6 +55,15 @@ static const struct usb_device_id wdm_ids[] = {
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
 


