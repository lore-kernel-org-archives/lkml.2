Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab2HNFXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 01:23:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59697 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab2HNFXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 01:23:49 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2] media: davinci: fix section mismatch warnings
Date: Tue, 14 Aug 2012 10:53:09 +0530
Message-ID: <1344921789-16647-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch fixes section mismatch warnings for
davinci video drivers.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 Changes for v2:
 1: Annotate probe with __devinit.
 2: Fixed the commit message.

 drivers/media/video/davinci/dm355_ccdc.c   |    2 +-
 drivers/media/video/davinci/dm644x_ccdc.c  |    2 +-
 drivers/media/video/davinci/isif.c         |    2 +-
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 drivers/media/video/davinci/vpif.c         |    2 +-
 drivers/media/video/davinci/vpss.c         |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index 5b68847..ce0e413 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -965,7 +965,7 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int __init dm355_ccdc_probe(struct platform_device *pdev)
+static int __devinit dm355_ccdc_probe(struct platform_device *pdev)
 {
 	void (*setup_pinmux)(void);
 	struct resource	*res;
diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 9303fe5..ee7942b 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -957,7 +957,7 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int __init dm644x_ccdc_probe(struct platform_device *pdev)
+static int __devinit dm644x_ccdc_probe(struct platform_device *pdev)
 {
 	struct resource	*res;
 	int status = 0;
diff --git a/drivers/media/video/davinci/isif.c b/drivers/media/video/davinci/isif.c
index 5278fe7..b99d542 100644
--- a/drivers/media/video/davinci/isif.c
+++ b/drivers/media/video/davinci/isif.c
@@ -1032,7 +1032,7 @@ static struct ccdc_hw_device isif_hw_dev = {
 	},
 };
 
-static int __init isif_probe(struct platform_device *pdev)
+static int __devinit isif_probe(struct platform_device *pdev)
 {
 	void (*setup_pinmux)(void);
 	struct resource	*res;
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 49a845f..843b138 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1829,7 +1829,7 @@ static struct vpfe_device *vpfe_initialize(void)
  * itself to the V4L2 driver and initializes fields of each
  * device objects
  */
-static __init int vpfe_probe(struct platform_device *pdev)
+static __devinit int vpfe_probe(struct platform_device *pdev)
 {
 	struct vpfe_subdev_info *sdinfo;
 	struct vpfe_config *vpfe_cfg;
diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index b3637af..9bd3caa 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -417,7 +417,7 @@ int vpif_channel_getfid(u8 channel_id)
 }
 EXPORT_SYMBOL(vpif_channel_getfid);
 
-static int __init vpif_probe(struct platform_device *pdev)
+static int __devinit vpif_probe(struct platform_device *pdev)
 {
 	int status = 0;
 
diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
index 3e5cf27..146e4b0 100644
--- a/drivers/media/video/davinci/vpss.c
+++ b/drivers/media/video/davinci/vpss.c
@@ -357,7 +357,7 @@ void dm365_vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
 }
 EXPORT_SYMBOL(dm365_vpss_set_pg_frame_size);
 
-static int __init vpss_probe(struct platform_device *pdev)
+static int __devinit vpss_probe(struct platform_device *pdev)
 {
 	struct resource		*r1, *r2;
 	char *platform_name;
-- 
1.7.0.4

