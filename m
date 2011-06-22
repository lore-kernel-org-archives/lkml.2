Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1FVIGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:06:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59903 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1FVIGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:06:42 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, corentin.chary@gmail.com
Subject: [PATCH 2/3] ideapad: let camera_power node invisiable if no camera
Date: Wed, 22 Jun 2011 16:06:37 +0800
Message-Id: <1308729997-2658-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308729781-2590-1-git-send-email-ike.pan@canonical.com>
References: <1308729781-2590-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 51d4144..678bbf7 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -38,6 +38,7 @@
 #define CFG_BT_BIT	(16)
 #define CFG_3G_BIT	(17)
 #define CFG_WIFI_BIT	(18)
+#define CFG_CAMERA_BIT	(19)
 
 struct ideapad_private {
 	struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
@@ -208,7 +209,24 @@ static struct attribute *ideapad_attributes[] = {
 	NULL
 };
 
+static mode_t ideapad_is_visible(struct kobject *kobj,
+				 struct attribute *attr,
+				 int idx)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct ideapad_private *priv = dev_get_drvdata(dev);
+	bool supported;
+
+	if (attr == &dev_attr_camera_power.attr)
+		supported = test_bit(CFG_CAMERA_BIT, &(priv->cfg));
+	else
+		supported = true;
+
+	return supported ? attr->mode : 0;
+}
+
 static struct attribute_group ideapad_attribute_group = {
+	.is_visible = ideapad_is_visible,
 	.attrs = ideapad_attributes
 };
 
-- 
1.7.4.1

