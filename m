Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1FTTKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:10:10 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:35967 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755526Ab1FTTKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:10:04 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] [resend] tea575x: remove useless input ioctls
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Mon, 20 Jun 2011 21:09:55 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202109.58370.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove empty and useless g_input and s_input ioctls.
This fixes one fail of v4l2-compliance test.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-06-11 15:29:18.000000000 +0200
+++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-06-11 15:29:51.000000000 +0200
@@ -269,19 +269,6 @@ static int tea575x_s_ctrl(struct v4l2_ct
 	return -EINVAL;
 }
 
-static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	if (i != 0)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct v4l2_file_operations tea575x_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= video_ioctl2,
@@ -293,8 +280,6 @@ static const struct v4l2_ioctl_ops tea57
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_audio     = vidioc_g_audio,
 	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 };


-- 
Ondrej Zary
