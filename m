Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2HVHGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:06:55 -0400
Received: from mail.telros.ru ([83.136.244.21]:63772 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab2HVHGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:06:53 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 05/10] staging: media: go7007: Cleanup unused old code
Date: Wed, 22 Aug 2012 14:45:14 +0400
Message-Id: <1345632319-23224-5-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/wis-tw2804.c |  138 -----------------------------
 1 files changed, 0 insertions(+), 138 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 0b49342..7bd3058 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -33,12 +33,7 @@ struct wis_tw2804 {
 	struct v4l2_ctrl_handler hdl;
 	u8 channel:2;
 	u8 input:1;
-	int channel;
 	int norm;
-	int brightness;
-	int contrast;
-	int saturation;
-	int hue;
 };
 
 static u8 global_registers[] = {
@@ -404,139 +399,6 @@ static int wis_tw2804_command(struct i2c_client *client,
 				"channel number is set\n", cmd);
 		return 0;
 	}
-
-	switch (cmd) {
-	case VIDIOC_S_STD:
-	{
-		v4l2_std_id *input = arg;
-		u8 regs[] = {
-			0x01, *input & V4L2_STD_NTSC ? 0xc4 : 0x84,
-			0x09, *input & V4L2_STD_NTSC ? 0x07 : 0x04,
-			0x0a, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
-			0x0b, *input & V4L2_STD_NTSC ? 0x07 : 0x04,
-			0x0c, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
-			0x0d, *input & V4L2_STD_NTSC ? 0x40 : 0x4a,
-			0x16, *input & V4L2_STD_NTSC ? 0x00 : 0x40,
-			0x17, *input & V4L2_STD_NTSC ? 0x00 : 0x40,
-			0x20, *input & V4L2_STD_NTSC ? 0x07 : 0x0f,
-			0x21, *input & V4L2_STD_NTSC ? 0x07 : 0x0f,
-			0xff,	0xff,
-		};
-		write_regs(client, regs, dec->channel);
-		dec->norm = *input;
-		break;
-	}
-	case VIDIOC_QUERYCTRL:
-	{
-		struct v4l2_queryctrl *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Brightness", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_CONTRAST:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Contrast", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_SATURATION:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Saturation", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_HUE:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Hue", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		}
-		break;
-	}
-	case VIDIOC_S_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			if (ctrl->value > 255)
-				dec->brightness = 255;
-			else if (ctrl->value < 0)
-				dec->brightness = 0;
-			else
-				dec->brightness = ctrl->value;
-			write_reg(client, 0x12, dec->brightness, dec->channel);
-			break;
-		case V4L2_CID_CONTRAST:
-			if (ctrl->value > 255)
-				dec->contrast = 255;
-			else if (ctrl->value < 0)
-				dec->contrast = 0;
-			else
-				dec->contrast = ctrl->value;
-			write_reg(client, 0x11, dec->contrast, dec->channel);
-			break;
-		case V4L2_CID_SATURATION:
-			if (ctrl->value > 255)
-				dec->saturation = 255;
-			else if (ctrl->value < 0)
-				dec->saturation = 0;
-			else
-				dec->saturation = ctrl->value;
-			write_reg(client, 0x10, dec->saturation, dec->channel);
-			break;
-		case V4L2_CID_HUE:
-			if (ctrl->value > 255)
-				dec->hue = 255;
-			else if (ctrl->value < 0)
-				dec->hue = 0;
-			else
-				dec->hue = ctrl->value;
-			write_reg(client, 0x0f, dec->hue, dec->channel);
-			break;
-		}
-		break;
-	}
-	case VIDIOC_G_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			ctrl->value = dec->brightness;
-			break;
-		case V4L2_CID_CONTRAST:
-			ctrl->value = dec->contrast;
-			break;
-		case V4L2_CID_SATURATION:
-			ctrl->value = dec->saturation;
-			break;
-		case V4L2_CID_HUE:
-			ctrl->value = dec->hue;
-			break;
-		}
-		break;
-	}
-	default:
-		break;
-	}
 	return 0;
 }
 
-- 
1.7.7.6

