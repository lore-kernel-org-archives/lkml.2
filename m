Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1BIKgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:36:23 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55544 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1BIKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:36:22 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/8] intel_mid_ssp_spi: Re-introduce quirks fields
To: spi-devel-general@lists.sourceforge.net, russ.gorby@intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Date: Wed, 09 Feb 2011 10:07:30 +0000
Message-ID: <20110209100713.555.65955.stgit@bob.linux.org.uk>
In-Reply-To: <20110209100231.555.90520.stgit@bob.linux.org.uk>
References: <20110209100231.555.90520.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This adds the quirks field to the driver and the flags. We don't yet
implement any of them so we don't confuse the driver.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/spi/intel_mid_ssp_spi.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)


diff --git a/drivers/spi/intel_mid_ssp_spi.c b/drivers/spi/intel_mid_ssp_spi.c
index 19c62bc..f201edd 100644
--- a/drivers/spi/intel_mid_ssp_spi.c
+++ b/drivers/spi/intel_mid_ssp_spi.c
@@ -125,6 +125,15 @@ struct driver_data {
 	/* SPI framework hookup */
 	struct spi_master *master;
 
+	/* Chip specific quirks */
+	int quirks;
+#define QUIRKS_PLATFORM_MRST		1
+#define QUIRKS_SRAM_ADDITIONAL_CPY	2
+#define QUIRKS_USE_PM_QOS		4
+#define QUIRKS_BIT_BANGING		8
+#define QUIRKS_SPI_SLAVE_CLOCK_MODE	16
+#define QUIRKS_PLATFORM_MDFL		32
+
 	/* SSP register addresses */
 	unsigned long paddr;
 	void __iomem *ioaddr;
@@ -137,7 +146,6 @@ struct driver_data {
 	u32 clear_sr;
 	u32 mask_sr;
 
-
 	/* Current message transfer state info */
 	struct tasklet_struct poll_transfer;
 	struct spi_message *cur_msg;
@@ -1163,6 +1171,7 @@ static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
 	}
 
 	drv_data = spi_master_get_devdata(master);
+	drv_data->quirks = ent->driver_data;
 	drv_data->master = master;
 	drv_data->pdev = pdev;
 	drv_data->pwrstate = PWRSTATE_ON;

