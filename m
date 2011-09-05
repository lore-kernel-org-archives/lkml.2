Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1IESdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:33:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1IESdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:33:02 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 5/5] ideapad: remove sysfs node for cfg
Date: Tue,  6 Sep 2011 02:33:00 +0800
Message-Id: <1315247580-9182-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315247467-8812-1-git-send-email-ike.pan@canonical.com>
References: <1315247467-8812-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced by the one in debugfs.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 .../ABI/testing/sysfs-platform-ideapad-laptop      |   15 ---------------
 drivers/platform/x86/ideapad-laptop.c              |   12 ------------
 2 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
index ff53183..814b013 100644
--- a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
@@ -5,19 +5,4 @@ Contact:	"Ike Panhc <ike.pan@canonical.com>"
 Description:
 		Control the power of camera module. 1 means on, 0 means off.
 
-What:		/sys/devices/platform/ideapad/cfg
-Date:		Jun 2011
-KernelVersion:	3.1
-Contact:	"Ike Panhc <ike.pan@canonical.com>"
-Description:
-		Ideapad capability bits.
-		Bit 8-10: 1 - Intel graphic only
-		          2 - ATI graphic only
-		          3 - Nvidia graphic only
-		          4 - Intel and ATI graphic
-		          5 - Intel and Nvidia graphic
-		Bit 16: Bluetooth exist (1 for exist)
-		Bit 17: 3G exist (1 for exist)
-		Bit 18: Wifi exist (1 for exist)
-		Bit 19: Camera exist (1 for exist)
 
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 1c8b506..a36addf 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -363,20 +363,8 @@ static ssize_t store_ideapad_cam(struct device *dev,
 
 static DEVICE_ATTR(camera_power, 0644, show_ideapad_cam, store_ideapad_cam);
 
-static ssize_t show_ideapad_cfg(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	struct ideapad_private *priv = dev_get_drvdata(dev);
-
-	return sprintf(buf, "0x%.8lX\n", priv->cfg);
-}
-
-static DEVICE_ATTR(cfg, 0444, show_ideapad_cfg, NULL);
-
 static struct attribute *ideapad_attributes[] = {
 	&dev_attr_camera_power.attr,
-	&dev_attr_cfg.attr,
 	NULL
 };
 
-- 
1.7.5.4

