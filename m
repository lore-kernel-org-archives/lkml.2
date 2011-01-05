Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1AEGUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 01:20:49 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41306 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388Ab1AEGUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 01:20:48 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <omar.ramirez@ti.com>
Cc: <gregkh@suse.de>, <rene.sapiens@ti.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>
Subject: [PATCH] staging: tidspbridge - configure full L1 MMU range
Date: Wed,  5 Jan 2011 00:20:10 -0600
Message-Id: <1294208410-4772-1-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise a virtual address beyond of the L1 size is used,
the MMU hardware will look into a memory that does not belong to
L1 translation tables. IOW; the MMU would allow to access any
memory, configured or not.

Reported-by: Felipe Contreras <felipe.contreras@nokia.com>
Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 1be081f..ec96d1e 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -70,6 +70,7 @@
 #define MMU_LARGE_PAGE_MASK      0xFFFF0000
 #define MMU_SMALL_PAGE_MASK      0xFFFFF000
 #define OMAP3_IVA2_BOOTADDR_MASK 0xFFFFFC00
+#define MMU_L1_SIZE              0x4000
 #define PAGES_II_LVL_TABLE   512
 #define PHYS_TO_PAGE(phys)      pfn_to_page((phys) >> PAGE_SHIFT)
 
@@ -786,10 +787,7 @@ static int bridge_dev_create(struct bridge_dev_context
 
 	pt_attrs = kzalloc(sizeof(struct pg_table_attrs), GFP_KERNEL);
 	if (pt_attrs != NULL) {
-		/* Assuming that we use only DSP's memory map
-		 * until 0x4000:0000 , we would need only 1024
-		 * L1 enties i.e L1 size = 4K */
-		pt_attrs->l1_size = 0x1000;
+		pt_attrs->l1_size = MMU_L1_SIZE;
 		align_size = pt_attrs->l1_size;
 		/* Align sizes are expected to be power of 2 */
 		/* we like to get aligned on L1 table size */
-- 
1.7.1

