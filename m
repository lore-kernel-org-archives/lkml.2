Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab0G3RVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:21:12 -0400
Received: from kroah.org ([198.145.64.141]:52373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758944Ab0G3RUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:20:41 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:14 2010
Message-Id: <20100730171514.535502699@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:16:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Ritz <daniel.ritz@gmx.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>
Subject: [165/165] V4L/DVB (13830): uvcvideo: add another YUYV format GUID for iSight cameras
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Ritz <daniel.ritz@gmx.ch>

commit 68f194e027ecfbbc8d5515bc40787e542eed59e9 upstream.

For some unknown reason, on a MacBookPro5,3 the iSight sometimes report
a different video format GUID. This patch add the other (wrong) GUID to
the format table, making the iSight work always w/o other problems.

What it should report: 32595559-0000-0010-8000-00aa00389b71
What it often reports: 32595559-0000-0010-8000-000000389b71

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |    5 +++++
 drivers/media/video/uvc/uvcvideo.h   |    3 +++
 2 files changed, 8 insertions(+)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -58,6 +58,11 @@ static struct uvc_format_desc uvc_fmts[]
 		.fcc		= V4L2_PIX_FMT_YUYV,
 	},
 	{
+		.name		= "YUV 4:2:2 (YUYV)",
+		.guid		= UVC_GUID_FORMAT_YUY2_ISIGHT,
+		.fcc		= V4L2_PIX_FMT_YUYV,
+	},
+	{
 		.name		= "YUV 4:2:0 (NV12)",
 		.guid		= UVC_GUID_FORMAT_NV12,
 		.fcc		= V4L2_PIX_FMT_NV12,
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -112,6 +112,9 @@ struct uvc_xu_control {
 #define UVC_GUID_FORMAT_YUY2 \
 	{ 'Y',  'U',  'Y',  '2', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_YUY2_ISIGHT \
+	{ 'Y',  'U',  'Y',  '2', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0x00, 0x00, 0x38, 0x9b, 0x71}
 #define UVC_GUID_FORMAT_NV12 \
 	{ 'N',  'V',  '1',  '2', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}


