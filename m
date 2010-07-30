Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab0G3RU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:20:57 -0400
Received: from kroah.org ([198.145.64.141]:52325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758915Ab0G3RU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:20:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:13 2010
Message-Id: <20100730171513.843541343@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:16:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [157/165] V4L/DVB: uvcvideo: Add support for V4L2_PIX_FMT_Y16
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 61421206833a4085d9bdf35b2b84cd9a67dfdfac upstream.

The Miricle 307K (17dc:0202) camera reports a 16-bit greyscale format,
support it in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |    7 ++++++-
 drivers/media/video/uvc/uvcvideo.h   |    4 +++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -83,11 +83,16 @@ static struct uvc_format_desc uvc_fmts[]
 		.fcc		= V4L2_PIX_FMT_UYVY,
 	},
 	{
-		.name		= "Greyscale",
+		.name		= "Greyscale (8-bit)",
 		.guid		= UVC_GUID_FORMAT_Y800,
 		.fcc		= V4L2_PIX_FMT_GREY,
 	},
 	{
+		.name		= "Greyscale (16-bit)",
+		.guid		= UVC_GUID_FORMAT_Y16,
+		.fcc		= V4L2_PIX_FMT_Y16,
+	},
+	{
 		.name		= "RGB Bayer",
 		.guid		= UVC_GUID_FORMAT_BY8,
 		.fcc		= V4L2_PIX_FMT_SBGGR8,
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -127,11 +127,13 @@ struct uvc_xu_control {
 #define UVC_GUID_FORMAT_Y800 \
 	{ 'Y',  '8',  '0',  '0', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_Y16 \
+	{ 'Y',  '1',  '6',  ' ', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 #define UVC_GUID_FORMAT_BY8 \
 	{ 'B',  'Y',  '8',  ' ', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 
-
 /* ------------------------------------------------------------------------
  * Driver specific constants.
  */


