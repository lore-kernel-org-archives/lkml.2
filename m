Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1CQSt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:49:58 -0400
Received: from setoy.chost.de ([217.160.209.225]:58392 "EHLO smtp.chost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab1CQSt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:49:56 -0400
From: Sascha Silbe <sascha-ml-reply-to-2011-2@silbe.org>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH] mmc: enable ERASE caps for mvsdio host
Date: Thu, 17 Mar 2011 19:42:26 +0100
Message-Id: <1300387346-1938-1-git-send-email-sascha-ml-reply-to-2011-2@silbe.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Silbe <sascha-pgp@silbe.org>

The Marvell SDIO host controller can transmit Erase commands to the card quite
fine.

Signed-off-by: Sascha Silbe <sascha-pgp@silbe.org>
---
 drivers/mmc/host/mvsdio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Tested on OpenRD-Base using a SanDisk 4GB class 4 card (retail). The
BLKDISCARD ioctl returned immediately, no timeout issue encountered.
I had to remove and reinsert the card to read the new (i.e. erased) data, but
that's most likely either by design or a bug on a different layer.


diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index eeb1147..758251d 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -735,7 +735,8 @@ static int __init mvsd_probe(struct platform_device *pdev)

 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ |
-		    MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
+		    MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED |
+		    MMC_CAP_ERASE;

 	mmc->f_min = DIV_ROUND_UP(host->base_clock, MVSD_BASE_DIV_MAX);
 	mmc->f_max = maxfreq;
--
1.7.4.1

