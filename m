Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2JDJbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:31:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45084 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab2JDJbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:31:00 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v3] media: davinci: vpif: set device capabilities
Date: Thu,  4 Oct 2012 14:59:58 +0530
Message-Id: <1349342998-31804-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1349342998-31804-1-git-send-email-prabhakar.lad@ti.com>
References: <1349342998-31804-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

set device_caps and also change the driver and
bus_info to proper values as per standard.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 Changes for v3:
 1: Removed READWRITE flag for device_caps pointed by Hans.

 Changes for v2:
 1: Change the bus_info and driver to proper values,
    pointed by Hans.

 drivers/media/platform/davinci/vpif_capture.c |    8 +++++---
 drivers/media/platform/davinci/vpif_display.c |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index cabd5a2..fcabc02 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1635,9 +1635,11 @@ static int vpif_querycap(struct file *file, void  *priv,
 {
 	struct vpif_capture_config *config = vpif_dev->platform_data;
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-	strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
-	strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(vpif_dev));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
 
 	return 0;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 7f20ca5..b716fbd 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -827,9 +827,11 @@ static int vpif_querycap(struct file *file, void  *priv,
 {
 	struct vpif_display_config *config = vpif_dev->platform_data;
 
-	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
-	strlcpy(cap->driver, "vpif display", sizeof(cap->driver));
-	strlcpy(cap->bus_info, "Platform", sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(vpif_dev));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
 
 	return 0;
-- 
1.7.4.1

