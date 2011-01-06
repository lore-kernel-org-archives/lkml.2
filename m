Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1AFAEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:04:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:60668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab1AFAES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874833905"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg@vger.kernel.org, Kroah-Hartman@vger.kernel.org, <gregkh@suse.de>,
        Vasiliy@vger.kernel.org, Kulikov@vger.kernel.org,
        <segoon@openwall.com>, Alan@vger.kernel.org, Cox@vger.kernel.org,
        <alan@linux.intel.com>, Russ@vger.kernel.org, Gorby@vger.kernel.org,
        <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 4/7] serial: ifx6x60: set SPI max_speed_hz based on platform type
Date: Wed,  5 Jan 2011 16:05:10 -0800
Message-Id: <1294272313-15899-5-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms containing the 6260 can run up to 25Mhz.

For these platforms set max_speed_hz to 25Mhz.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/serial/ifx6x60.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index fd10103..b54a990 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
@@ -722,7 +722,7 @@ static void ifx_spi_io(unsigned long data)
 		/* note len is BYTES, not transfers */
 		ifx_dev->spi_xfer.len = IFX_SPI_TRANSFER_SIZE;
 		ifx_dev->spi_xfer.cs_change = 0;
-		ifx_dev->spi_xfer.speed_hz = 12500000;
+		ifx_dev->spi_xfer.speed_hz = ifx_dev->spi_dev->max_speed_hz;
 		/* ifx_dev->spi_xfer.speed_hz = 390625; */
 		ifx_dev->spi_xfer.bits_per_word = spi_bpw;
 
@@ -984,6 +984,10 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	ifx_dev->spi_timer.function = ifx_spi_timeout;
 	ifx_dev->spi_timer.data = (unsigned long)ifx_dev;
 	ifx_dev->is_6160 = pl_data->is_6160;
+	if (ifx_dev->is_6160)
+		spi->max_speed_hz = 12500000;
+	else
+		spi->max_speed_hz = 25000000;
 
 	/* ensure SPI protocol flags are initialized to enable transfer */
 	ifx_dev->spi_more = 0;
-- 
1.7.2.3

