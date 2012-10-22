Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2JVM2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:28:10 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40767 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2JVM2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:28:08 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH RESEND 2/2] media: davinci: vpbe: set device capabilities
Date: Mon, 22 Oct 2012 17:57:14 +0530
Message-Id: <1350908834-11619-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1350908834-11619-1-git-send-email-prabhakar.lad@ti.com>
References: <1350908834-11619-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

set device_caps and also change the driver and
bus_info to proper values as per standard.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/platform/davinci/vpbe_display.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 974957f..2bfde79 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -702,9 +702,12 @@ static int vpbe_display_querycap(struct file *file, void  *priv,
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 
 	cap->version = VPBE_DISPLAY_VERSION_CODE;
-	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
-	strlcpy(cap->driver, VPBE_DISPLAY_DRIVER, sizeof(cap->driver));
-	strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	snprintf(cap->driver, sizeof(cap->driver), "%s",
+		dev_name(vpbe_dev->pdev));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(vpbe_dev->pdev));
 	strlcpy(cap->card, vpbe_dev->cfg->module_name, sizeof(cap->card));
 
 	return 0;
-- 
1.7.4.1

