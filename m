Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1BGT6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:58:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:62816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab1BGT5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:57:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="600292953"
From: Russ Gorby <russ.gorby@intel.com>
To: Russ Gorby <russ.gorby@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 4/6] serial: ifx6x60: set SPI max_speed_hz based on platform type
Date: Mon,  7 Feb 2011 12:02:30 -0800
Message-Id: <1297108952-27371-5-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
References: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms containing the 6260 can run up to 25Mhz.

For these platforms set max_speed_hz to 25Mhz.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 9161cab..766f0c3 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -722,7 +722,7 @@ static void ifx_spi_io(unsigned long data)
 		/* note len is BYTES, not transfers */
 		ifx_dev->spi_xfer.len = IFX_SPI_TRANSFER_SIZE;
 		ifx_dev->spi_xfer.cs_change = 0;
-		ifx_dev->spi_xfer.speed_hz = 12500000;
+		ifx_dev->spi_xfer.speed_hz = ifx_dev->spi_dev->max_speed_hz;
 		/* ifx_dev->spi_xfer.speed_hz = 390625; */
 		ifx_dev->spi_xfer.bits_per_word = spi_bpw;
 
@@ -992,6 +992,7 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	ifx_dev->modem = pl_data->modem_type;
 	ifx_dev->use_dma = pl_data->use_dma;
 	ifx_dev->max_hz = pl_data->max_hz;
+	spi->max_speed_hz = ifx_dev->max_hz;
 
 	/* ensure SPI protocol flags are initialized to enable transfer */
 	ifx_dev->spi_more = 0;
-- 
1.7.3.4

