Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2AIJdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:33:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46610 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2AIJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:33:11 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH] fix starting of transfers in i.MX dma drivers
Date: Mon,  9 Jan 2012 10:32:46 +0100
Message-Id: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the start of transfers from tx_submit to issue_pending
for the i.MX dma drivers as requested by Vinoud here:

https://lkml.org/lkml/2012/1/7/23

This requires the users (mxcmmc and i.MX sound) to be fixed first.
So Chris, Mark, given your Ack I would suggest to send this via
Vinouds DMA tree.

Sascha

Sascha Hauer (4):
      mmc: mxcmmc: add missing dma_async_issue_pending
      ASoC: i.MX: Add missing dma_async_issue_pending
      dma: imx-dma: start transfer in issue_pending
      dma: imx-sdma: start transfer in issue_pending

 drivers/dma/imx-dma.c           |    9 ++++-----
 drivers/dma/imx-sdma.c          |   11 +++++------
 drivers/mmc/host/mxcmmc.c       |    1 +
 sound/soc/imx/imx-pcm-dma-mx2.c |    1 +
 4 files changed, 11 insertions(+), 11 deletions(-)
