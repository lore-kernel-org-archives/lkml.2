Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab2K1Flz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 00:41:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39669 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2K1Flx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 00:41:53 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 2/2] Input: RMI4 - F11 - remove relreport attribute
Date: Tue, 27 Nov 2012 21:41:48 -0800
Message-Id: <1354081308-21636-2-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354081308-21636-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1354081308-21636-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This data item does not seem to be used anywhere.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_f11.c | 37 -------------------------------------
 include/linux/rmi.h          |  1 -
 2 files changed, 38 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
index 717e2d8..da3fd2a 100644
--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -832,42 +832,6 @@ enum finger_state_values {
 	F11_RESERVED	= 0x03
 };
 
-static ssize_t rmi_f11_relreport_show(struct device *dev,
-				      struct device_attribute *attr,
-				      char *buf)
-{
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f11_data *data = fn->data;
-
-	return snprintf(buf, PAGE_SIZE, "%u\n",
-			data->sensors[0].axis_align.rel_report_enabled);
-}
-
-static ssize_t rmi_f11_relreport_store(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf,
-				       size_t count)
-{
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f11_data *data = fn->data;
-	unsigned int new_value;
-	int error;
-
-	error = kstrtouint(buf, 0, &new_value);
-	if (error)
-		return error;
-
-	if (new_value > 1)
-		return -ERANGE;
-
-	data->sensors[0].axis_align.rel_report_enabled = new_value;
-
-	return count;
-}
-
-static DEVICE_ATTR(relreport, RMI_RW_ATTR,
-		   rmi_f11_relreport_show, rmi_f11_relreport_store);
-
 static ssize_t rmi_f11_rezero_store(struct device *dev,
 				    struct device_attribute *attr,
 				    const char *buf, size_t count)
@@ -906,7 +870,6 @@ static ssize_t rmi_f11_rezero_store(struct device *dev,
 static DEVICE_ATTR(rezero, RMI_WO_ATTR, NULL, rmi_f11_rezero_store);
 
 static struct attribute *rmi_f11_attrs[] = {
-	&dev_attr_relreport.attr,
 	&dev_attr_rezero.attr,
 	NULL
 };
diff --git a/include/linux/rmi.h b/include/linux/rmi.h
index d4e1438..3969e61 100644
--- a/include/linux/rmi.h
+++ b/include/linux/rmi.h
@@ -73,7 +73,6 @@ enum rmi_attn_polarity {
  *               automatically enabled for this sensor.
  */
 struct rmi_f11_2d_axis_alignment {
-	bool rel_report_enabled;
 	u32 swap_axes;	/* boolean, but u32 is needed by debugfs API */
 	u32 flip_x;	/* boolean */
 	u32 flip_y;	/* boolean */
-- 
1.7.11.7

