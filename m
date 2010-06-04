Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0FDUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:09:58 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:38049 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0FDUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:09:57 -0400
Date: Fri, 4 Jun 2010 15:14:43 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>, dab@hp.com,
       scameron@beardog.cce.hp.com, gerry.morong@hp.com, mike.miller@hp.com,
       scott.benesh@hp.com, scott.stacy.teel@hp.com, tom.lawler@hp.com,
       mikem@beardog.cce.hp.com
Subject: [PATCH 4/5] cciss: remove errant debug code
Message-ID: <20100604201443.GD30870@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 4 of 5
cciss: remove a debug statement left behind by accident
Ths debug statement got left behind. It was commented out after use but not
deleted.

From: Mike Miller <mike.miller@hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com
---
 drivers/block/cciss_scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index df26a4f..f89726d 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -213,8 +213,6 @@ scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
 
 	/* Check alignment, see cciss_cmd.h near CommandList_struct def. */
 	BUILD_BUG_ON((sizeof(*stk->pool) % COMMANDLIST_ALIGNMENT) != 0);
-	/* printk(KERN_WARNING "cciss_scsi.c: 0x%08x 0x%08x 0x%08x\n",
-			0xdeadbeef, sizeof(*stk->pool), 0xbeefdead); */
 	/* pci_alloc_consistent guarantees 32-bit DMA address will be used */
 	stk->pool = (struct cciss_scsi_cmd_stack_elem_t *)
 		pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
