Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2CaLiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 07:38:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49018 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab2CaLh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 07:37:28 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 3/3] spi: omap2-mcspi: Trivial optimisation
Date: Sat, 31 Mar 2012 17:06:58 +0530
Message-ID: <1333193818-3984-4-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333193818-3984-1-git-send-email-shubhrajyoti@ti.com>
References: <1333193818-3984-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial optimisation of tmp variable by directly writing the value
to the register.

Cc :  Tarun Kanti DebBarma <tarun.kanti@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 0b0da2f..f374eee 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1050,16 +1050,15 @@ static int __init omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
 {
 	struct spi_master	*master = mcspi->master;
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
-	u32			tmp;
 	int			ret = 0;
 
 	ret = omap2_mcspi_enable_clocks(mcspi);
 	if (ret < 0)
 		return ret;
 
-	tmp = OMAP2_MCSPI_WAKEUPENABLE_WKEN;
-	mcspi_write_reg(master, OMAP2_MCSPI_WAKEUPENABLE, tmp);
-	ctx->wakeupenable = tmp;
+	mcspi_write_reg(master, OMAP2_MCSPI_WAKEUPENABLE,
+				OMAP2_MCSPI_WAKEUPENABLE_WKEN);
+	ctx->wakeupenable = OMAP2_MCSPI_WAKEUPENABLE_WKEN;
 
 	omap2_mcspi_set_master_mode(master);
 	omap2_mcspi_disable_clocks(mcspi);
-- 
1.7.1

