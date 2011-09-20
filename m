Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1ITO5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:57:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44146 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1ITO5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:57:40 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
        <tony@atomide.com>, <hvaibhav@ti.com>, <linux-media@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <kyungmin.park@samsung.com>, <hverkuil@xs4all.nl>,
        <m.szyprowski@samsung.com>, <g.liakhovetski@gmx.de>,
        <santosh.shilimkar@ti.com>, <khilman@deeprootsystems.com>,
        <david.woodhouse@intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 4/5] ispccdc: Configure CCDC_SYN_MODE register for UYVY8_2X8 and YUYV8_2X8 formats
Date: Tue, 20 Sep 2011 20:26:51 +0530
Message-ID: <1316530612-23075-5-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com>
References: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure INPMOD and PACK8 fileds of CCDC_SYN_MODE
register for UYVY8_2X8 and YUYV8_2X8 formats.

Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 drivers/media/video/omap3isp/ispccdc.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 418ba65..1dcf180 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -985,8 +985,12 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 
 	syn_mode &= ~ISPCCDC_SYN_MODE_INPMOD_MASK;
 	if (format->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
-	    format->code == V4L2_MBUS_FMT_UYVY8_2X8)
-		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+	    format->code == V4L2_MBUS_FMT_UYVY8_2X8){
+		if (pdata && pdata->bt656)
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+		else
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+	}
 	else if (format->code == V4L2_MBUS_FMT_YUYV8_1X16 ||
 		 format->code == V4L2_MBUS_FMT_UYVY8_1X16)
 		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
@@ -1172,7 +1176,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 
 	/* Use PACK8 mode for 1byte per pixel formats. */
-	if (omap3isp_video_format_info(format->code)->width <= 8)
+	if ((omap3isp_video_format_info(format->code)->width <= 8) &&
+			(omap3isp_video_format_info(format->code)->bpp <= 8))
 		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
-- 
1.7.0.4

