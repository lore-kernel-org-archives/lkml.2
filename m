Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab0IGPiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:38:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33971 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757818Ab0IGPiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:38:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Jassi Brar <jassi.brar@samsung.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] spi/spi_s3c64xx: Increase dead reckoning time in wait_for_xfer()
Date: Tue,  7 Sep 2010 16:37:52 +0100
Message-Id: <1283873872-8633-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283873872-8633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1283873872-8633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For small transfers at high speeds the expected transfer time can easily
be well under 1ms, causing the delay in wait_for_xfer() to be only the
dead reckoning fudge factor of 5ms currently included. Experiments on
some of my systems shows that this is marginal for some transfers so
double it to 10ms.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi_s3c64xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
index 03b28e4..4abb441 100644
--- a/drivers/spi/spi_s3c64xx.c
+++ b/drivers/spi/spi_s3c64xx.c
@@ -326,7 +326,7 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 
 	/* millisecs to xfer 'len' bytes @ 'cur_speed' */
 	ms = xfer->len * 8 * 1000 / sdd->cur_speed;
-	ms += 5; /* some tolerance */
+	ms += 10; /* some tolerance */
 
 	if (dma_mode) {
 		val = msecs_to_jiffies(ms) + 10;
-- 
1.7.1

