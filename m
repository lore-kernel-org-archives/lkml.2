Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2G1WxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 18:53:03 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53462 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2G1WxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 18:53:01 -0400
From: Stefan Muenzel <stefanmuenzel@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stefan Muenzel <stefanmuenzel@googlemail.com>
Subject: [PATCH 1/1] [media] uvcvideo: Add 10,12bit and alternate 8bit greyscale
Date: Sat, 28 Jul 2012 18:49:14 -0400
Message-Id: <1343515754-1043-1-git-send-email-stefanmuenzel@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some cameras support 10bit and 12bit greyscale, or use the alternate "Y8
" FOURCC for 8bit greyscale. Add support for these.

Tested on a 12bit camera.

Signed-off-by: Stefan Muenzel <stefanmuenzel@googlemail.com>
---
 drivers/media/video/uvc/uvc_driver.c |   19 +++++++++++++++++--
 drivers/media/video/uvc/uvcvideo.h   |    9 +++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 1d13172..11db262 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -95,12 +95,27 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.fcc		= V4L2_PIX_FMT_UYVY,
 	},
 	{
-		.name		= "Greyscale (8-bit)",
+		.name		= "Greyscale 8-bit (Y800)",
 		.guid		= UVC_GUID_FORMAT_Y800,
 		.fcc		= V4L2_PIX_FMT_GREY,
 	},
 	{
-		.name		= "Greyscale (16-bit)",
+		.name		= "Greyscale 8-bit (Y8  )",
+		.guid		= UVC_GUID_FORMAT_Y8,
+		.fcc		= V4L2_PIX_FMT_GREY,
+	},
+	{
+		.name		= "Greyscale 10-bit (Y10 )",
+		.guid		= UVC_GUID_FORMAT_Y10,
+		.fcc		= V4L2_PIX_FMT_Y10,
+	},
+	{
+		.name		= "Greyscale 12-bit (Y12 )",
+		.guid		= UVC_GUID_FORMAT_Y12,
+		.fcc		= V4L2_PIX_FMT_Y12,
+	},
+	{
+		.name		= "Greyscale 16-bit (Y16 )",
 		.guid		= UVC_GUID_FORMAT_Y16,
 		.fcc		= V4L2_PIX_FMT_Y16,
 	},
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 7c3d082..3764040 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -79,6 +79,15 @@
 #define UVC_GUID_FORMAT_Y800 \
 	{ 'Y',  '8',  '0',  '0', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_Y8 \
+	{ 'Y',  '8',  ' ',  ' ', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_Y10 \
+	{ 'Y',  '1',  '0',  ' ', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_Y12 \
+	{ 'Y',  '1',  '2',  ' ', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 #define UVC_GUID_FORMAT_Y16 \
 	{ 'Y',  '1',  '6',  ' ', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
-- 
1.7.10.4

