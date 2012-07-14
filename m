Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2GNHmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 03:42:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2GNHmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 03:42:06 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] staging/wlan-ng: use kzalloc rather using kmalloc at create_wlan
Date: Sat, 14 Jul 2012 13:26:59 +0545
Message-Id: <1342251719-16373-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead we would have used kzalloc, so our memory which is allocated will be set to 0.

codepath:

the code path here is prism2sta_probe_usb, calling when ever usb-dev id
and usb-vendor id e.t.c matches with what ever present in the MODULE_DEVICE_TABLE,

and in prism2sta_probe_usb , we call create_wlan, and its called nowhere else...

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/wlan-ng/prism2sta.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 417aea5..1dfd9aa 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -1947,8 +1947,8 @@ static wlandevice_t *create_wlan(void)
 	hfa384x_t *hw = NULL;
 
 	/* Alloc our structures */
-	wlandev = kmalloc(sizeof(wlandevice_t), GFP_KERNEL);
-	hw = kmalloc(sizeof(hfa384x_t), GFP_KERNEL);
+	wlandev = kzalloc(sizeof(wlandevice_t), GFP_KERNEL);
+	hw = kzalloc(sizeof(hfa384x_t), GFP_KERNEL);
 
 	if (!wlandev || !hw) {
 		printk(KERN_ERR "%s: Memory allocation failure.\n", dev_info);
@@ -1957,10 +1957,6 @@ static wlandevice_t *create_wlan(void)
 		return NULL;
 	}
 
-	/* Clear all the structs */
-	memset(wlandev, 0, sizeof(wlandevice_t));
-	memset(hw, 0, sizeof(hfa384x_t));
-
 	/* Initialize the network device object. */
 	wlandev->nsdname = dev_info;
 	wlandev->msdstate = WLAN_MSD_HWPRESENT_PENDING;
-- 
1.7.9.5

