Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1CGIYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:24:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1CGIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=EcH1QC0Ypcj9/Yjy8pwiATTUQv6XiTR8ySx4Tc6B6ench8vE6KA393mLeEqbrL1rRt
         LtsVj6miIWwNG9ULRGfS+OMNCgIYwkIpZ3/0tp+P7PIYMx9g760kCwr/leZ5x3WiK23x
         oeNR7lcoDLFQPc3dBw152m2PqCbEVE3buHXt4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 09/21] staging: ft1000: Fix coding style in reg_ft1000_netdev function.
Date: Mon,  7 Mar 2011 09:21:14 +0100
Message-Id: <1299486086-7325-10-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   40 +++++++++++-------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 55998ec..0b8ff3d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -848,38 +848,34 @@ err_net:
 // Notes:
 //
 //---------------------------------------------------------------------------
-int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf)
+int reg_ft1000_netdev(struct ft1000_device *ft1000dev,
+		      struct usb_interface *intf)
 {
-    struct net_device *netdev;
+	struct net_device *netdev;
 	struct ft1000_info *pInfo;
 	int rc;
 
-    netdev = ft1000dev->net;
-    pInfo = netdev_priv(ft1000dev->net);
-    DEBUG("Enter reg_ft1000_netdev...\n");
-
+	netdev = ft1000dev->net;
+	pInfo = netdev_priv(ft1000dev->net);
+	DEBUG("Enter reg_ft1000_netdev...\n");
 
-    ft1000_read_register(ft1000dev, &pInfo->AsicID, FT1000_REG_ASIC_ID);
+	ft1000_read_register(ft1000dev, &pInfo->AsicID, FT1000_REG_ASIC_ID);
 
-    usb_set_intfdata(intf, pInfo);
-    SET_NETDEV_DEV(netdev, &intf->dev);
+	usb_set_intfdata(intf, pInfo);
+	SET_NETDEV_DEV(netdev, &intf->dev);
 
-    rc = register_netdev(netdev);
-    if (rc)
-    {
-        DEBUG("reg_ft1000_netdev: could not register network device\n");
-        free_netdev(netdev);
-	return rc;
-    }
-
-
-    //Create character device, implemented by Jim
-    ft1000_create_dev(ft1000dev);
+	rc = register_netdev(netdev);
+	if (rc) {
+		DEBUG("reg_ft1000_netdev: could not register network device\n");
+		free_netdev(netdev);
+		return rc;
+	}
 
-    DEBUG ("reg_ft1000_netdev returned\n");
+	ft1000_create_dev(ft1000dev);
 
-    pInfo->CardReady = 1;
+	DEBUG("reg_ft1000_netdev returned\n");
 
+	pInfo->CardReady = 1;
 
 	return 0;
 }
-- 
1.7.1

