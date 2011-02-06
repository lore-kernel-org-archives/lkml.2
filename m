Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1BFSEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:04:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:35213 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab1BFSEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:04:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,434,1291622400"; 
   d="scan'208";a="384871009"
From: Pierre Tardy <pierre.tardy@intel.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pierre Tardy <pierre.tardy@intel.com>, Pierre Tardy <tardyp@gmail.com>
Subject: [PATCH v2 3/3] mmc: remove BROCKEN_CLK_GATING quirk for wl1271
Date: Sun,  6 Feb 2011 19:04:17 +0100
Message-Id: <0b3533accd30f25b0ee92ac7181240a5bd9eb36e.1297014807.git.pierre.tardy@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1297014807.git.pierre.tardy@intel.com>
References: <cover.1297014807.git.pierre.tardy@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sdio card is supporting having its sdio clock shutdown
It is also not using the SDIO IRQ, but rather uses
a side gpio irq.

Signed-off-by: Pierre Tardy <tardyp@gmail.com>
---
 drivers/mmc/core/quirks.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/quirks.c b/drivers/mmc/core/quirks.c
index d004106..4fb16ac 100644
--- a/drivers/mmc/core/quirks.c
+++ b/drivers/mmc/core/quirks.c
@@ -49,11 +49,21 @@ static void add_quirk_for_sdio_devices(struct mmc_card *card, int data)
 		card->quirks |= data;
 }
 
+#ifndef SDIO_VENDOR_ID_TI
+#define SDIO_VENDOR_ID_TI		0x0097
+#endif
+
+#ifndef SDIO_DEVICE_ID_TI_WL1271
+#define SDIO_DEVICE_ID_TI_WL1271	0x4076
+#endif
+
 static const struct mmc_fixup mmc_fixup_methods[] = {
 	/* by default sdio devices are considered CLK_GATING broken */
 	/* good cards will be whitelisted as they are tested */
 	{ SDIO_ANY_ID, SDIO_ANY_ID,
-		add_quirk_for_sdio_devices, MMC_QUIRK_BROKEN_CLK_GATING }
+		add_quirk_for_sdio_devices, MMC_QUIRK_BROKEN_CLK_GATING },
+	{ SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271,
+		remove_quirk, MMC_QUIRK_BROKEN_CLK_GATING },
 	{ 0 }
 };
 
-- 
1.7.2.3

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

