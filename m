Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1AEVZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:25:46 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:55259 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369Ab1AEVZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:25:45 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <omar.ramirez@ti.com>
Cc: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>
Subject: [PATCHv2] staging: tidspbridge: configure full L1 MMU range
Date: Wed,  5 Jan 2011 15:25:33 -0600
Message-Id: <1294262733-9585-1-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guzman Lugo, Fernando <fernando.lugo@ti.com>

IVA MMU can manage up to 4GB of address space through its page tables,
given that it's L1 is divided into 1MB sections it requires at least
16KB for its table which represents 4096 entries of 32 bits each.

Previously, only 1GB was being handled by setting the page table size
to 4KB, any virtual address beyond of the L1 size used, would fall
into memory that does not belong to L1 translation tables, leading to
unpredictable results.

So, set the L1 table size to cover the entire MMU range (4GB) whether
is meant to be used or not.

Reported-by: Felipe Contreras <felipe.contreras@nokia.com>
Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index cacd30e..7608822 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -784,10 +784,7 @@ static int bridge_dev_create(struct bridge_dev_context
 
 	pt_attrs = kzalloc(sizeof(struct pg_table_attrs), GFP_KERNEL);
 	if (pt_attrs != NULL) {
-		/* Assuming that we use only DSP's memory map
-		 * until 0x4000:0000 , we would need only 1024
-		 * L1 enties i.e L1 size = 4K */
-		pt_attrs->l1_size = 0x1000;
+		pt_attrs->l1_size = SZ_16K; /* 4096 entries of 32 bits */
 		align_size = pt_attrs->l1_size;
 		/* Align sizes are expected to be power of 2 */
 		/* we like to get aligned on L1 table size */
-- 
1.7.0.4

