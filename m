Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598Ab1FWXUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:20:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17212 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456Ab1FWXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:20:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 23 Jun 2011 16:20:00 -0700
From: <achew@nvidia.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
CC: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>, <olof@lixom.net>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 5/6 v3] [media] ov9740: Reorder video and core ops
Date: Thu, 23 Jun 2011 16:19:43 -0700
Message-ID: <1308871184-6307-5-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308871184-6307-1-git-send-email-achew@nvidia.com>
References: <1308871184-6307-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

This is to avoid needing a forward declaration when ov9740_s_power() (in the
subsequent patch) calls ov9740_s_fmt().

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/media/video/ov9740.c |  186 +++++++++++++++++++++---------------------
 1 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index decd706..cd63eaa 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -573,90 +573,6 @@ static unsigned long ov9740_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
-/* Get status of additional camera capabilities */
-static int ov9740_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct ov9740_priv *priv = to_ov9740(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		ctrl->value = priv->flag_vflip;
-		break;
-	case V4L2_CID_HFLIP:
-		ctrl->value = priv->flag_hflip;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/* Set status of additional camera capabilities */
-static int ov9740_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct ov9740_priv *priv = to_ov9740(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		priv->flag_vflip = ctrl->value;
-		break;
-	case V4L2_CID_HFLIP:
-		priv->flag_hflip = ctrl->value;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/* Get chip identification */
-static int ov9740_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct ov9740_priv *priv = to_ov9740(sd);
-
-	id->ident = priv->ident;
-	id->revision = priv->revision;
-
-	return 0;
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int ov9740_get_register(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_register *reg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret;
-	u8 val;
-
-	if (reg->reg & ~0xffff)
-		return -EINVAL;
-
-	reg->size = 2;
-
-	ret = ov9740_reg_read(client, reg->reg, &val);
-	if (ret)
-		return ret;
-
-	reg->val = (__u64)val;
-
-	return ret;
-}
-
-static int ov9740_set_register(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_register *reg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (reg->reg & ~0xffff || reg->val & ~0xff)
-		return -EINVAL;
-
-	return ov9740_reg_write(client, reg->reg, reg->val);
-}
-#endif
-
 /* select nearest higher resolution for capture */
 static void ov9740_res_roundup(u32 *width, u32 *height)
 {
@@ -863,6 +779,90 @@ static int ov9740_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	return 0;
 }
 
+/* Get status of additional camera capabilities */
+static int ov9740_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct ov9740_priv *priv = to_ov9740(sd);
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		ctrl->value = priv->flag_vflip;
+		break;
+	case V4L2_CID_HFLIP:
+		ctrl->value = priv->flag_hflip;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Set status of additional camera capabilities */
+static int ov9740_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct ov9740_priv *priv = to_ov9740(sd);
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		priv->flag_vflip = ctrl->value;
+		break;
+	case V4L2_CID_HFLIP:
+		priv->flag_hflip = ctrl->value;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Get chip identification */
+static int ov9740_g_chip_ident(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_chip_ident *id)
+{
+	struct ov9740_priv *priv = to_ov9740(sd);
+
+	id->ident = priv->ident;
+	id->revision = priv->revision;
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov9740_get_register(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+	u8 val;
+
+	if (reg->reg & ~0xffff)
+		return -EINVAL;
+
+	reg->size = 2;
+
+	ret = ov9740_reg_read(client, reg->reg, &val);
+	if (ret)
+		return ret;
+
+	reg->val = (__u64)val;
+
+	return ret;
+}
+
+static int ov9740_set_register(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (reg->reg & ~0xffff || reg->val & ~0xff)
+		return -EINVAL;
+
+	return ov9740_reg_write(client, reg->reg, reg->val);
+}
+#endif
+
 static int ov9740_video_probe(struct soc_camera_device *icd,
 			      struct i2c_client *client)
 {
@@ -929,6 +929,15 @@ static struct soc_camera_ops ov9740_ops = {
 	.num_controls		= ARRAY_SIZE(ov9740_controls),
 };
 
+static struct v4l2_subdev_video_ops ov9740_video_ops = {
+	.s_stream		= ov9740_s_stream,
+	.s_mbus_fmt		= ov9740_s_fmt,
+	.try_mbus_fmt		= ov9740_try_fmt,
+	.enum_mbus_fmt		= ov9740_enum_fmt,
+	.cropcap		= ov9740_cropcap,
+	.g_crop			= ov9740_g_crop,
+};
+
 static struct v4l2_subdev_core_ops ov9740_core_ops = {
 	.g_ctrl			= ov9740_g_ctrl,
 	.s_ctrl			= ov9740_s_ctrl,
@@ -939,15 +948,6 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
 #endif
 };
 
-static struct v4l2_subdev_video_ops ov9740_video_ops = {
-	.s_stream		= ov9740_s_stream,
-	.s_mbus_fmt		= ov9740_s_fmt,
-	.try_mbus_fmt		= ov9740_try_fmt,
-	.enum_mbus_fmt		= ov9740_enum_fmt,
-	.cropcap		= ov9740_cropcap,
-	.g_crop			= ov9740_g_crop,
-};
-
 static struct v4l2_subdev_ops ov9740_subdev_ops = {
 	.core			= &ov9740_core_ops,
 	.video			= &ov9740_video_ops,
-- 
1.7.5.4

