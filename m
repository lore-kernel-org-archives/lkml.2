Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2IYLQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:16:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33647 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2IYLQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:16:42 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: davinci: vpif: set device capabilities
Date: Tue, 25 Sep 2012 16:46:24 +0530
Message-Id: <1348571784-4237-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_capture.c |    4 +++-
 drivers/media/platform/davinci/vpif_display.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 4828888..faeca98 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1630,7 +1630,9 @@ static int vpif_querycap(struct file *file, void  *priv,
 {
 	struct vpif_capture_config *config = vpif_dev->platform_data;
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
 	strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index d94b8a2..171e449 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -827,7 +827,9 @@ static int vpif_querycap(struct file *file, void  *priv,
 {
 	struct vpif_display_config *config = vpif_dev->platform_data;
 
-	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
+			    V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, "vpif display", sizeof(cap->driver));
 	strlcpy(cap->bus_info, "Platform", sizeof(cap->bus_info));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
-- 
1.7.4.1

