Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab1FBJYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:24:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46010 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab1FBJYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:24:52 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] ideapad: Show negative when no camera
Date: Thu,  2 Jun 2011 17:24:47 +0800
Message-Id: <1307006687-12736-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307006553-12667-1-git-send-email-ike.pan@canonical.com>
References: <1307006553-12667-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 9c09891..4a54ed1 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -38,6 +38,7 @@
 #define CFG_BT_BIT	(16)
 #define CFG_3G_BIT	(17)
 #define CFG_WIFI_BIT	(18)
+#define CFG_CAMERA_BIT	(19)
 
 struct ideapad_private {
 	struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
@@ -199,6 +200,10 @@ static ssize_t show_ideapad_cam(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
 {
+	struct ideapad_private *priv = dev_get_drvdata(dev);
+
+	if (!test_bit(CFG_CAMERA_BIT, &(priv->cfg)))
+		return sprintf(buf, "-1\n");
 	return show_ideapad_helper(dev, attr, buf, 0x1D);
 }
 
-- 
1.7.4.1

