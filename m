Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab1HCGtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:49:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53952 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1HCGtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:49:07 -0400
Subject: [PATCH] mmc: tmio: eliminate unused variable 'mmc' warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Aug 2011 14:48:58 +0800
Message-ID: <1312354138.14329.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below compile warning:
  CC      drivers/mmc/host/tmio_mmc.o
drivers/mmc/host/tmio_mmc.c: In function 'tmio_mmc_suspend':
drivers/mmc/host/tmio_mmc.c:30: warning: unused variable 'mmc'
drivers/mmc/host/tmio_mmc.c: In function 'tmio_mmc_resume':
drivers/mmc/host/tmio_mmc.c:45: warning: unused variable 'mmc'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mmc/host/tmio_mmc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 8d185de..44a9668 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -27,7 +27,6 @@
 static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 {
 	const struct mfd_cell *cell = mfd_get_cell(dev);
-	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret;
 
 	ret = tmio_mmc_host_suspend(&dev->dev);
@@ -42,7 +41,6 @@ static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 static int tmio_mmc_resume(struct platform_device *dev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(dev);
-	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret = 0;
 
 	/* Tell the MFD core we are ready to be enabled */
-- 
1.7.4.1



