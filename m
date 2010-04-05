Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0DETGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:06:21 -0400
Received: from mail.perches.com ([173.55.12.10]:1359 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab0DETFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:05:49 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Vrabel <david.vrabel@csr.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] drivers/usb/host/hwa-hc.c: Rename dev_info to hdi
Date: Mon,  5 Apr 2010 12:05:32 -0700
Message-Id: <0d6b9010d1fd6965951685a46e2effa0e3db89d4.1270493677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
In-Reply-To: <cover.1270493677.git.joe@perches.com>
References: <cover.1270493677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro called dev_info that prints struct device specific
information.  Having variables with the same name can be confusing and
prevents conversion of the macro to a function.

Rename the existing dev_info variables to something else in preparation
to converting the dev_info macro to a function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/host/hwa-hc.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/hwa-hc.c b/drivers/usb/host/hwa-hc.c
index 88b0321..5366ab1 100644
--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -375,16 +375,16 @@ static int __hwahc_op_dev_info_set(struct wusbhc *wusbhc,
 	struct hwahc *hwahc = container_of(wusbhc, struct hwahc, wusbhc);
 	struct wahc *wa = &hwahc->wa;
 	u8 iface_no = wa->usb_iface->cur_altsetting->desc.bInterfaceNumber;
-	struct hwa_dev_info *dev_info;
+	struct hwa_dev_info *hdi;
 	int ret;
 
 	/* fill out the Device Info buffer and send it */
-	dev_info = kzalloc(sizeof(struct hwa_dev_info), GFP_KERNEL);
-	if (!dev_info)
+	hdi = kzalloc(sizeof(struct hwa_dev_info), GFP_KERNEL);
+	if (!hdi)
 		return -ENOMEM;
-	uwb_mas_bm_copy_le(dev_info->bmDeviceAvailability,
+	uwb_mas_bm_copy_le(hdi->bmDeviceAvailability,
 			   &wusb_dev->availability);
-	dev_info->bDeviceAddress = wusb_dev->addr;
+	hdi->bDeviceAddress = wusb_dev->addr;
 
 	/*
 	 * If the descriptors haven't been read yet, use a default PHY
@@ -394,17 +394,17 @@ static int __hwahc_op_dev_info_set(struct wusbhc *wusbhc,
 	 * have been read).
 	 */
 	if (wusb_dev->wusb_cap_descr)
-		dev_info->wPHYRates = wusb_dev->wusb_cap_descr->wPHYRates;
+		hdi->wPHYRates = wusb_dev->wusb_cap_descr->wPHYRates;
 	else
-		dev_info->wPHYRates = cpu_to_le16(USB_WIRELESS_PHY_53);
+		hdi->wPHYRates = cpu_to_le16(USB_WIRELESS_PHY_53);
 
 	ret = usb_control_msg(wa->usb_dev, usb_sndctrlpipe(wa->usb_dev, 0),
 			WUSB_REQ_SET_DEV_INFO,
 			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			0, wusb_dev->port_idx << 8 | iface_no,
-			dev_info, sizeof(struct hwa_dev_info),
+			hdi, sizeof(struct hwa_dev_info),
 			1000 /* FIXME: arbitrary */);
-	kfree(dev_info);
+	kfree(hdi);
 	return ret;
 }
 
-- 
1.7.0.3.311.g6a6955

