Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2JTNTF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 09:19:05 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46941 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab2JTNTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 09:19:02 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux-davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 2/2] media: davinci: vpbe: set device capabilities
Date: Sat, 20 Oct 2012 18:48:44 +0530
Message-Id: <1350739124-22590-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1350739124-22590-1-git-send-email-prabhakar.lad@ti.com>
References: <1350739124-22590-1-git-send-email-prabhakar.lad@ti.com>
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

