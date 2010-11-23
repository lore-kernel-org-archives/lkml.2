Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0KWM1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:27:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48718 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab0KWM12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:27:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=enXGYI8Ibka/JQBNQ055jVxblQ4bCwLdta28nffqnKfnWk55d8oXQIobo8JixZn87r
         ICl5KLfGSxgYVmlAP9qbM0bVnR8fsbwmwbb+2k5GRgIyMSW0S7qlKu7X4gXf7cd6xlYk
         XW7fLxHrWLgG0nKRXb04/dV3l7D3OSYGCl15Y=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 6/6] staging: ft1000: Check return value of ft1000_CreateDevice().
Date: Tue, 23 Nov 2010 13:29:33 +0100
Message-Id: <1290515373-16145-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registering of misc device could fail so add checking
of return value.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 57a235f..fd1f071 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -948,9 +948,12 @@ int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
 	return rc;
     }
 
-
-    //Create character device, implemented by Jim
-    ft1000_CreateDevice(ft1000dev);
+	rc = ft1000_CreateDevice(ft1000dev);
+	if (rc) {
+		DEBUG("Could not register misc device :%d\n", rc);
+		free_netdev(netdev);
+		return rc;
+	}
 
     DEBUG ("reg_ft1000_netdev returned\n");
 
-- 
1.7.1

