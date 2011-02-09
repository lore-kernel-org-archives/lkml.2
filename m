Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1BIPGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:06:44 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:46878
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750935Ab1BIPGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:06:43 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH] Staging: cx25821: removed unnecessary NULL-Pointer-checks
Date: Wed,  9 Feb 2011 16:06:26 +0100
Message-Id: <1297263986-3073-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4
X-Null-Tag: f6d9ac22c5a91b0604b3fb8ef22011a4
X-Authenticated-Sender: user tvh from 86.103.159.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary NULL-Pointer-checks preceeding kfree as kfree(NULL)
is safe.

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c   |    9 +++------
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |    9 +++------
 drivers/staging/cx25821/cx25821-video-upstream.c   |    9 +++------
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 7992a3b..0f9ca77 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -244,13 +244,10 @@ void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 	dev->_audioframe_count = 0;
 	dev->_audiofile_status = END_OF_FILE;
 
-	if (dev->_irq_audio_queues) {
-		kfree(dev->_irq_audio_queues);
-		dev->_irq_audio_queues = NULL;
-	}
+	kfree(dev->_irq_audio_queues);
+	dev->_irq_audio_queues = NULL;
 
-	if (dev->_audiofilename != NULL)
-		kfree(dev->_audiofilename);
+	kfree(dev->_audiofilename);
 }
 
 void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev)
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index e2efacd..655357d 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -234,13 +234,10 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 	dev->_frame_count_ch2 = 0;
 	dev->_file_status_ch2 = END_OF_FILE;
 
-	if (dev->_irq_queues_ch2) {
-		kfree(dev->_irq_queues_ch2);
-		dev->_irq_queues_ch2 = NULL;
-	}
+	kfree(dev->_irq_queues_ch2);
+	dev->_irq_queues_ch2 = NULL;
 
-	if (dev->_filename_ch2 != NULL)
-		kfree(dev->_filename_ch2);
+	kfree(dev->_filename_ch2);
 
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 31b4e3c..eb0172b 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -279,13 +279,10 @@ void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 	dev->_frame_count = 0;
 	dev->_file_status = END_OF_FILE;
 
-	if (dev->_irq_queues) {
-		kfree(dev->_irq_queues);
-		dev->_irq_queues = NULL;
-	}
+	kfree(dev->_irq_queues);
+	dev->_irq_queues = NULL;
 
-	if (dev->_filename != NULL)
-		kfree(dev->_filename);
+	kfree(dev->_filename);
 
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
-- 
1.7.4

