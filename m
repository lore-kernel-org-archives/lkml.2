Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2LYO7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 09:59:12 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:55866 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2LYO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 09:58:57 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/3] staging: drm/imx: check return value of ipu_reset()
Date: Tue, 25 Dec 2012 15:58:37 +0100
Message-Id: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipu_reset() can fail with a timeout. Check the return value and act
appropriately.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 677e665..f7059cd 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -1104,7 +1104,9 @@ static int ipu_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_failed_irq;
 
-	ipu_reset(ipu);
+	ret = ipu_reset(ipu);
+	if (ret)
+		goto out_failed_reset;
 
 	/* Set MCU_T to divide MCU access window into 2 */
 	ipu_cm_write(ipu, 0x00400000L | (IPU_MCU_T_DEFAULT << 18),
@@ -1129,6 +1131,7 @@ failed_add_clients:
 	ipu_submodules_exit(ipu);
 failed_submodules_init:
 	ipu_irq_exit(ipu);
+out_failed_reset:
 out_failed_irq:
 	clk_disable_unprepare(ipu->clk);
 failed_clk_get:
-- 
1.7.2.5

