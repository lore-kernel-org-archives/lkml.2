Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab2GLVvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:51:04 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51187 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2GLVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:51:00 -0400
X-Greylist: delayed 3021 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2012 17:51:00 EDT
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/8] staging: ft1000-usb: Change KERN_ERROR usage to pr_err in ft1000_usb.c.
Date: Thu, 12 Jul 2012 23:50:43 +0200
Message-Id: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 7bd7fb2..9d36c5f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -70,7 +70,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	ft1000dev = kzalloc(sizeof(struct ft1000_device), GFP_KERNEL);
 
 	if (!ft1000dev) {
-		printk(KERN_ERR "out of memory allocating device structure\n");
+		pr_err("out of memory allocating device structure\n");
 		return -ENOMEM;
 	}
 
@@ -138,7 +138,7 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	ret = request_firmware(&dsp_fw, "ft3000.img", &dev->dev);
 	if (ret < 0) {
-		printk(KERN_ERR "Error request_firmware().\n");
+		pr_err("Error request_firmware().\n");
 		goto err_fw;
 	}
 
@@ -166,7 +166,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	DEBUG("In probe: pft1000info=%p\n", pft1000info);
 	ret = dsp_reload(ft1000dev);
 	if (ret) {
-		printk(KERN_ERR "Problem with DSP image loading\n");
+		pr_err("Problem with DSP image loading\n");
 		goto err_load;
 	}
 
-- 
1.7.9.5

