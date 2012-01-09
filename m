Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2AIJdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:33:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46609 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2AIJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:33:11 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/4] mmc: mxcmmc: add missing dma_async_issue_pending
Date: Mon,  9 Jan 2012 10:32:47 +0100
Message-Id: <1326101570-3716-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de>
References: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/mmc/host/mxcmmc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 8e0fbe9..d1c2c31 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -263,6 +263,7 @@ static int mxcmci_setup_data(struct mxcmci_host *host, struct mmc_data *data)
 	wmb();
 
 	dmaengine_submit(host->desc);
+	dma_async_issue_pending(host->dma);
 
 	return 0;
 }
-- 
1.7.7.3

