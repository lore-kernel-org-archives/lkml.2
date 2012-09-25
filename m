Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2IYM7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:59:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab2IYM7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:59:47 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] media: mt9p031/mt9t001/mt9v032: use V4L2_CID_TEST_PATTERN for test pattern control
Date: Tue, 25 Sep 2012 18:29:25 +0530
Message-Id: <1348577965-17351-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/i2c/mt9p031.c |   27 ++++++++----------------
 drivers/media/i2c/mt9t001.c |   33 +++++++++++++++++++++++-------
 drivers/media/i2c/mt9v032.c |   46 +++++++++++++++++++++++++++++-------------
 3 files changed, 66 insertions(+), 40 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 2c0f407..a45c2ea 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -574,11 +574,10 @@ static int mt9p031_set_crop(struct v4l2_subdev *subdev,
  * V4L2 subdev control operations
  */
 
-#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
-#define V4L2_CID_BLC_AUTO		(V4L2_CID_USER_BASE | 0x1002)
-#define V4L2_CID_BLC_TARGET_LEVEL	(V4L2_CID_USER_BASE | 0x1003)
-#define V4L2_CID_BLC_ANALOG_OFFSET	(V4L2_CID_USER_BASE | 0x1004)
-#define V4L2_CID_BLC_DIGITAL_OFFSET	(V4L2_CID_USER_BASE | 0x1005)
+#define V4L2_CID_BLC_AUTO		(V4L2_CID_USER_BASE | 0x1001)
+#define V4L2_CID_BLC_TARGET_LEVEL	(V4L2_CID_USER_BASE | 0x1002)
+#define V4L2_CID_BLC_ANALOG_OFFSET	(V4L2_CID_USER_BASE | 0x1003)
+#define V4L2_CID_BLC_DIGITAL_OFFSET	(V4L2_CID_USER_BASE | 0x1004)
 
 static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -740,18 +739,6 @@ static const char * const mt9p031_test_pattern_menu[] = {
 static const struct v4l2_ctrl_config mt9p031_ctrls[] = {
 	{
 		.ops		= &mt9p031_ctrl_ops,
-		.id		= V4L2_CID_TEST_PATTERN,
-		.type		= V4L2_CTRL_TYPE_MENU,
-		.name		= "Test Pattern",
-		.min		= 0,
-		.max		= ARRAY_SIZE(mt9p031_test_pattern_menu) - 1,
-		.step		= 0,
-		.def		= 0,
-		.flags		= 0,
-		.menu_skip_mask	= 0,
-		.qmenu		= mt9p031_test_pattern_menu,
-	}, {
-		.ops		= &mt9p031_ctrl_ops,
 		.id		= V4L2_CID_BLC_AUTO,
 		.type		= V4L2_CTRL_TYPE_BOOLEAN,
 		.name		= "BLC, Auto",
@@ -950,7 +937,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->model = did->driver_data;
 	mt9p031->reset = -1;
 
-	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 5);
+	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 6);
 
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
 			  V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
@@ -966,6 +953,10 @@ static int mt9p031_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
 			  V4L2_CID_PIXEL_RATE, pdata->target_freq,
 			  pdata->target_freq, 1, pdata->target_freq);
+	v4l2_ctrl_new_std_menu_items(&mt9p031->ctrls, &mt9p031_ctrl_ops,
+			  V4L2_CID_TEST_PATTERN,
+			  ARRAY_SIZE(mt9p031_test_pattern_menu) - 1, 0,
+			  0, mt9p031_test_pattern_menu);
 
 	for (i = 0; i < ARRAY_SIZE(mt9p031_ctrls); ++i)
 		v4l2_ctrl_new_custom(&mt9p031->ctrls, &mt9p031_ctrls[i], NULL);
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 6d343ad..16eac3f 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -124,6 +124,7 @@ struct mt9t001 {
 
 	u16 output_control;
 	u16 black_level;
+	bool test_pattern;
 };
 
 static inline struct mt9t001 *to_mt9t001(struct v4l2_subdev *sd)
@@ -371,10 +372,10 @@ static int mt9t001_set_crop(struct v4l2_subdev *subdev,
  * V4L2 subdev control operations
  */
 
-#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
-#define V4L2_CID_BLACK_LEVEL_AUTO	(V4L2_CID_USER_BASE | 0x1002)
-#define V4L2_CID_BLACK_LEVEL_OFFSET	(V4L2_CID_USER_BASE | 0x1003)
-#define V4L2_CID_BLACK_LEVEL_CALIBRATE	(V4L2_CID_USER_BASE | 0x1004)
+#define V4L2_CID_PARAMETRIC_TEST_PATTERN	(V4L2_CID_USER_BASE | 0x1001)
+#define V4L2_CID_BLACK_LEVEL_AUTO		(V4L2_CID_USER_BASE | 0x1002)
+#define V4L2_CID_BLACK_LEVEL_OFFSET		(V4L2_CID_USER_BASE | 0x1003)
+#define V4L2_CID_BLACK_LEVEL_CALIBRATE		(V4L2_CID_USER_BASE | 0x1004)
 
 #define V4L2_CID_GAIN_RED		(V4L2_CTRL_CLASS_CAMERA | 0x1001)
 #define V4L2_CID_GAIN_GREEN_RED		(V4L2_CTRL_CLASS_CAMERA | 0x1002)
@@ -485,8 +486,15 @@ static int mt9t001_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		return mt9t001_write(client, MT9T001_SHUTTER_WIDTH_HIGH,
 				     ctrl->val >> 16);
-
 	case V4L2_CID_TEST_PATTERN:
+		mt9t001->test_pattern = ctrl->val;
+		break;
+
+	case V4L2_CID_PARAMETRIC_TEST_PATTERN:
+		if (!mt9t001->test_pattern) {
+			pr_warn("Enable test pattern!!");
+			return -EINVAL;
+		}
 		ret = mt9t001_set_output_control(mt9t001,
 			ctrl->val ? 0 : MT9T001_OUTPUT_CONTROL_TEST_DATA,
 			ctrl->val ? MT9T001_OUTPUT_CONTROL_TEST_DATA : 0);
@@ -533,12 +541,17 @@ static struct v4l2_ctrl_ops mt9t001_ctrl_ops = {
 	.s_ctrl = mt9t001_s_ctrl,
 };
 
+static const char * const mt9t001_test_pattern_menu[] = {
+	"Disabled",
+	"Enable",
+};
+
 static const struct v4l2_ctrl_config mt9t001_ctrls[] = {
 	{
 		.ops		= &mt9t001_ctrl_ops,
-		.id		= V4L2_CID_TEST_PATTERN,
+		.id		= V4L2_CID_PARAMETRIC_TEST_PATTERN,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Test pattern",
+		.name		= "Parametric Test Pattern Values",
 		.min		= 0,
 		.max		= 1023,
 		.step		= 1,
@@ -741,7 +754,7 @@ static int mt9t001_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	v4l2_ctrl_handler_init(&mt9t001->ctrls, ARRAY_SIZE(mt9t001_ctrls) +
-						ARRAY_SIZE(mt9t001_gains) + 3);
+						ARRAY_SIZE(mt9t001_gains) + 4);
 
 	v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
 			  V4L2_CID_EXPOSURE, MT9T001_SHUTTER_WIDTH_MIN,
@@ -752,6 +765,10 @@ static int mt9t001_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
 			  V4L2_CID_PIXEL_RATE, pdata->ext_clk, pdata->ext_clk,
 			  1, pdata->ext_clk);
+	v4l2_ctrl_new_std_menu_items(&mt9t001->ctrls, &mt9t001_ctrl_ops,
+			V4L2_CID_TEST_PATTERN,
+			ARRAY_SIZE(mt9t001_test_pattern_menu) - 1, 0,
+			0, mt9t001_test_pattern_menu);
 
 	for (i = 0; i < ARRAY_SIZE(mt9t001_ctrls); ++i)
 		v4l2_ctrl_new_custom(&mt9t001->ctrls, &mt9t001_ctrls[i], NULL);
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index e217740..7ef01c0 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -141,6 +141,7 @@ struct mt9v032 {
 	u16 chip_control;
 	u16 aec_agc;
 	u16 hblank;
+	u32 test_pattern;
 };
 
 static struct mt9v032 *to_mt9v032(struct v4l2_subdev *sd)
@@ -500,7 +501,7 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
  * V4L2 subdev control operations
  */
 
-#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
+#define V4L2_CID_PARAMETRIC_TEST_PATTERN	(V4L2_CID_USER_BASE | 0x1001)
 
 static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -508,7 +509,7 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 			container_of(ctrl->handler, struct mt9v032, ctrls);
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
 	u32 freq;
-	u16 data;
+	u16 data = 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUTOGAIN:
@@ -543,8 +544,10 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 		mt9v032->pixel_rate->val64 = freq;
 		mt9v032->sysclk = freq;
 		break;
-
 	case V4L2_CID_TEST_PATTERN:
+		mt9v032->test_pattern = ctrl->val;
+		if (mt9v032->test_pattern > 3)
+			break;
 		switch (ctrl->val) {
 		case 0:
 			data = 0;
@@ -561,15 +564,18 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 			data = MT9V032_TEST_PATTERN_GRAY_DIAGONAL
 			     | MT9V032_TEST_PATTERN_ENABLE;
 			break;
-		default:
-			data = (ctrl->val << MT9V032_TEST_PATTERN_DATA_SHIFT)
-			     | MT9V032_TEST_PATTERN_USE_DATA
-			     | MT9V032_TEST_PATTERN_ENABLE
-			     | MT9V032_TEST_PATTERN_FLIP;
-			break;
 		}
 
 		return mt9v032_write(client, MT9V032_TEST_PATTERN, data);
+
+	case V4L2_CID_PARAMETRIC_TEST_PATTERN:
+		if (mt9v032->test_pattern != 4)
+			return 0;
+		data = (ctrl->val << MT9V032_TEST_PATTERN_DATA_SHIFT)
+		     | MT9V032_TEST_PATTERN_USE_DATA
+		     | MT9V032_TEST_PATTERN_ENABLE
+		     | MT9V032_TEST_PATTERN_FLIP;
+		return mt9v032_write(client, MT9V032_TEST_PATTERN, data);
 	}
 
 	return 0;
@@ -579,16 +585,24 @@ static struct v4l2_ctrl_ops mt9v032_ctrl_ops = {
 	.s_ctrl = mt9v032_s_ctrl,
 };
 
+static const char * const mt9v032_test_pattern_menu[] = {
+	"Disabled",
+	"Gray Vertical Shade",
+	"Gray Horizontal Shade",
+	"Gray Diagonal Shade",
+	"Parametric Test Pattern",
+};
+
 static const struct v4l2_ctrl_config mt9v032_ctrls[] = {
 	{
 		.ops		= &mt9v032_ctrl_ops,
-		.id		= V4L2_CID_TEST_PATTERN,
+		.id		= V4L2_CID_PARAMETRIC_TEST_PATTERN,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Test pattern",
-		.min		= 0,
+		.name		= "Parametric Test Pattern Values",
+		.min		= 4,
 		.max		= 1023,
 		.step		= 1,
-		.def		= 0,
+		.def		= 4,
 		.flags		= 0,
 	}
 };
@@ -741,7 +755,7 @@ static int mt9v032_probe(struct i2c_client *client,
 	mutex_init(&mt9v032->power_lock);
 	mt9v032->pdata = pdata;
 
-	v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 8);
+	v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 9);
 
 	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
 			  V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
@@ -763,6 +777,10 @@ static int mt9v032_probe(struct i2c_client *client,
 			  V4L2_CID_VBLANK, MT9V032_VERTICAL_BLANKING_MIN,
 			  MT9V032_VERTICAL_BLANKING_MAX, 1,
 			  MT9V032_VERTICAL_BLANKING_DEF);
+	v4l2_ctrl_new_std_menu_items(&mt9v032->ctrls, &mt9v032_ctrl_ops,
+			V4L2_CID_TEST_PATTERN,
+			ARRAY_SIZE(mt9v032_test_pattern_menu) - 1, 0,
+			0, mt9v032_test_pattern_menu);
 
 	mt9v032->pixel_rate =
 		v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
-- 
1.7.4.1

