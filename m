Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1LIEOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:14:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51544 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1LIEOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:14:10 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/4][RESEND] spi-topcliff-pch: supports a spi mode setup and bit order setup by IO control
Date: Fri,  9 Dec 2011 13:13:28 +0900
Message-Id: <1323404009-3476-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323404009-3476-1-git-send-email-tomoya.rohm@gmail.com>
References: <1323404009-3476-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports a spi mode setup and bit order setup by IO control.
    spi mode:     mode 0 to mode 3
    bit order:    LSB first, MSB first

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/spi/spi-topcliff-pch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 7339765..1864555 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1430,6 +1430,7 @@ static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
 	master->num_chipselect = PCH_MAX_CS;
 	master->setup = pch_spi_setup;
 	master->transfer = pch_spi_transfer;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
 
 	data->board_dat = board_dat;
 	data->plat_dev = plat_dev;
-- 
1.7.4.4

