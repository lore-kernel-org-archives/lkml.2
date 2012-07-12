Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab2GLGMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:12:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55708 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab2GLGMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:12:02 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sage Ahn <syahn@gctsemi.com>, Devendra Naga <devendra.aaru@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging/gdm72xx: use kzalloc for phydev and udev
Date: Thu, 12 Jul 2012 11:56:54 +0545
Message-Id: <1342073514-12050-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are doing kmalloc and memset, can be done using kzalloc itself.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/gdm72xx/gdm_usb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 126150d..3dee4d4 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -590,20 +590,17 @@ static int gdm_usb_probe(struct usb_interface *intf,
 		goto out;
 	}
 
-	phy_dev = kmalloc(sizeof(*phy_dev), GFP_KERNEL);
+	phy_dev = kzalloc(sizeof(*phy_dev), GFP_KERNEL);
 	if (phy_dev == NULL) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	udev = kmalloc(sizeof(*udev), GFP_KERNEL);
+	udev = kzalloc(sizeof(*udev), GFP_KERNEL);
 	if (udev == NULL) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	memset(phy_dev, 0, sizeof(*phy_dev));
-	memset(udev, 0, sizeof(*udev));
-
 	if (idProduct == 0x7205 || idProduct == 0x7206)
 		udev->padding = GDM7205_PADDING;
 	else
-- 
1.7.9.5

