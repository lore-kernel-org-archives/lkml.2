Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790Ab2EPIBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:01:43 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:16720
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758255Ab2EPIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:01:37 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 4/5] mmc: bfin_sdh: Remove redundent suspend and resume setting.
Date: Wed, 16 May 2012 15:50:36 +0800
Message-ID: <1337154637-11724-4-git-send-email-sonic.zhang@analog.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337154637-11724-1-git-send-email-sonic.zhang@analog.com>
References: <1337154637-11724-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

mmc core suspend and resume functions had already called sdh_set_ios with proper flags.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/mmc/host/bfin_sdh.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 22e347b..b31e1ab 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -604,11 +604,6 @@ static int sdh_suspend(struct platform_device *dev, pm_message_t state)
 	if (mmc)
 		ret = mmc_suspend_host(mmc);
 
-#ifndef RSI_BLKSZ
-	bfin_write_SDH_PWR_CTL(bfin_read_SDH_PWR_CTL() & ~PWR_ON);
-#else
-	bfin_write_SDH_CFG(bfin_read_SDH_CFG() & ~PWR_ON);
-#endif
 	peripheral_free_list(drv_data->pin_req);
 
 	return ret;
@@ -630,16 +625,6 @@ static int sdh_resume(struct platform_device *dev)
 	/* Secure Digital Host shares DMA with Nand controller */
 	bfin_write_DMAC1_PERIMUX(bfin_read_DMAC1_PERIMUX() | 0x1);
 #endif
-#ifndef RSI_BLKSZ
-	bfin_write_SDH_PWR_CTL(bfin_read_SDH_PWR_CTL() | PWR_ON);
-	bfin_write_SDH_CFG(bfin_read_SDH_CFG() | CLKS_EN);
-#else
-	bfin_write_SDH_CFG(bfin_read_SDH_CFG() | CLKS_EN | PWR_ON);
-#endif
-	SSYNC();
-
-	bfin_write_SDH_CFG((bfin_read_SDH_CFG() & 0x1F) | (PUP_SDDAT | PUP_SDDAT3));
-	SSYNC();
 
 	if (mmc)
 		ret = mmc_resume_host(mmc);
-- 
1.7.0.4


