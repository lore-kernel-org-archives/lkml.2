Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab2HPOCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:02:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54251 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621Ab2HPOCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:02:35 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: davinci: vpif: add check for NULL handler
Date: Thu, 16 Aug 2012 19:32:00 +0530
Message-ID: <1345125720-24059-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_capture.c |   12 +++++++-----
 drivers/media/video/davinci/vpif_display.c |   14 ++++++++------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 266025e..a87b7a5 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -311,12 +311,14 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	/* configure 1 or 2 channel mode */
-	ret = vpif_config_data->setup_input_channel_mode
-					(vpif->std_info.ycmux_mode);
+	if (vpif_config_data->setup_input_channel_mode) {
+		ret = vpif_config_data->setup_input_channel_mode
+						(vpif->std_info.ycmux_mode);
 
-	if (ret < 0) {
-		vpif_dbg(1, debug, "can't set vpif channel mode\n");
-		return ret;
+		if (ret < 0) {
+			vpif_dbg(1, debug, "can't set vpif channel mode\n");
+			return ret;
+		}
 	}
 
 	/* Call vpif_set_params function to set the parameters and addresses */
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index e129c98..1e35f92 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -280,12 +280,14 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	/* clock settings */
-	ret =
-	    vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
-					ch->vpifparams.std_info.hd_sd);
-	if (ret < 0) {
-		vpif_err("can't set clock\n");
-		return ret;
+	if (vpif_config_data->set_clock) {
+		ret =
+		vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
+						ch->vpifparams.std_info.hd_sd);
+		if (ret < 0) {
+			vpif_err("can't set clock\n");
+			return ret;
+		}
 	}
 
 	/* set the parameters and addresses */
-- 
1.7.0.4

