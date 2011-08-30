Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1H3ETP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:19:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49060 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1H3ETM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:19:12 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v3 12/18] Staging: cx25821: Replace :? by if-else in cx25821-video-upstream-ch2.c
Date: Tue, 30 Aug 2011 12:17:07 +0800
Message-Id: <1314677833-4689-13-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace :? operator by if-else equivalent where it improves readability.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   23 ++++++++++---------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index 655357d..a642416 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -145,15 +145,16 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 	if (dev->_isNTSC_ch2) {
 		odd_num_lines = singlefield_lines + 1;
 		risc_program_size = FRAME1_VID_PROG_SIZE;
-		frame_size =
-		    (bpl ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_NTSC_Y411 :
-		    FRAME_SIZE_NTSC_Y422;
+		if (bpl == Y411_LINE_SZ)
+			frame_size = FRAME_SIZE_NTSC_Y411;
+		else
+			frame_size = FRAME_SIZE_NTSC_Y422;
 	} else {
 		risc_program_size = PAL_VID_PROG_SIZE;
-		frame_size =
-		    (bpl ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
+		if (bpl == Y411_LINE_SZ)
+			frame_size = FRAME_SIZE_PAL_Y411;
+		else
+			frame_size = FRAME_SIZE_PAL_Y422;
 	}
 
 	/* Virtual address of Risc buffer program */
@@ -565,10 +566,10 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 			}
 
 			if (dev->_dma_virt_start_addr_ch2 != NULL) {
-				line_size_in_bytes =
-				    (dev->_pixel_format_ch2 ==
-				     PIXEL_FRMT_411) ? Y411_LINE_SZ :
-				    Y422_LINE_SZ;
+				if (dev->_pixel_format_ch2 == PIXEL_FRMT_411)
+					line_size_in_bytes = Y411_LINE_SZ;
+				else
+					line_size_in_bytes = Y422_LINE_SZ;
 				risc_phys_jump_addr =
 				    dev->_dma_phys_start_addr_ch2 +
 				    odd_risc_prog_size;
-- 
1.7.0.4

