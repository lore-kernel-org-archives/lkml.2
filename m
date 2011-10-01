Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1JAAe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 20:34:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45228 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1JAAeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 20:34:04 -0400
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 2/3] [media] tvp5150: Add video format registers configuration values
Date: Sat,  1 Oct 2011 02:33:50 +0200
Message-Id: <1317429231-11359-3-git-send-email-martinez.javier@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tvp5150 video decoder has two operation modes to configure the video
standard used.

If auto-switch mode is enable, the device can sense the signal and detect which
video standard the device is operating. Also the device can be forced to use a
user defined video standard.

Each operation mode uses a different register and the bitmask values to
represent each standard is different.

So we add video standard constants for both autoswitch and no-autoswitch mode.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/media/video/tvp5150_reg.h |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tvp5150_reg.h b/drivers/media/video/tvp5150_reg.h
index 4240043..25a9949 100644
--- a/drivers/media/video/tvp5150_reg.h
+++ b/drivers/media/video/tvp5150_reg.h
@@ -45,7 +45,22 @@
 
 /* Reserved 1Fh-27h */
 
-#define TVP5150_VIDEO_STD           0x28 /* Video standard */
+#define VIDEO_STD_MASK			 (0x07 >> 1)
+#define TVP5150_VIDEO_STD                0x28 /* Video standard */
+#define VIDEO_STD_AUTO_SWITCH_BIT	 0x00
+#define VIDEO_STD_NTSC_MJ_BIT		 0x02
+#define VIDEO_STD_PAL_BDGHIN_BIT	 0x04
+#define VIDEO_STD_PAL_M_BIT		 0x06
+#define VIDEO_STD_PAL_COMBINATION_N_BIT	 0x08
+#define VIDEO_STD_NTSC_4_43_BIT		 0x0a
+#define VIDEO_STD_SECAM_BIT		 0x0c
+
+#define VIDEO_STD_NTSC_MJ_BIT_AS                 0x01
+#define VIDEO_STD_PAL_BDGHIN_BIT_AS              0x03
+#define VIDEO_STD_PAL_M_BIT_AS		         0x05
+#define VIDEO_STD_PAL_COMBINATION_N_BIT_AS	 0x07
+#define VIDEO_STD_NTSC_4_43_BIT_AS		 0x09
+#define VIDEO_STD_SECAM_BIT_AS		         0x0b
 
 /* Reserved 29h-2bh */
 
-- 
1.7.4.1

