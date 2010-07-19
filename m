Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966063Ab0GSSk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:40:29 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11773 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965904Ab0GSSkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:20 -0400
Subject: [PATCH 14/26] cciss: cleanup some debug ifdefs
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:51 -0500
Message-ID: <20100719184551.7908.98211.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: cleanup some debug ifdefs

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e1c2bf1..10502a2 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3711,9 +3711,9 @@ static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
  *   the io functions.
  *   This is for debug only.
  */
-#ifdef CCISS_DEBUG
 static void print_cfg_table(CfgTable_struct *tb)
 {
+#ifdef CCISS_DEBUG
 	int i;
 	char temp_name[17];
 
@@ -3742,8 +3742,8 @@ static void print_cfg_table(CfgTable_struct *tb)
 	temp_name[16] = '\0';
 	printk("   Server Name = %s\n", temp_name);
 	printk("   Heartbeat Counter = 0x%x\n\n\n", readl(&(tb->HeartBeat)));
-}
 #endif				/* CCISS_DEBUG */
+}
 
 static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 {
@@ -3833,6 +3833,7 @@ cciss_put_controller_into_performant_mode(ctlr_info_t *h)
 
 	BUILD_BUG_ON(28 > MAXSGENTRIES + 4);
 
+	dev_dbg(&h->pdev->dev, "Trying to put board into Performant mode\n");
 	/* Attempt to put controller into performant mode if supported */
 	/* Does board support performant mode? */
 	trans_support = readl(&(h->cfgtable->TransportSupport));
@@ -4190,9 +4191,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 	err = cciss_find_cfgtables(c);
 	if (err)
 		goto err_out_free_res;
-#ifdef CCISS_DEBUG
 	print_cfg_table(c->cfgtable);
-#endif				/* CCISS_DEBUG */
 	cciss_find_board_params(c);
 
 	if (!CISS_signature_present(c)) {
@@ -4201,9 +4200,6 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 	}
 	cciss_enable_scsi_prefetch(c);
 	cciss_p600_dma_prefetch_quirk(c);
-#ifdef CCISS_DEBUG
-	printk(KERN_WARNING "Trying to put board into Performant mode\n");
-#endif				/* CCISS_DEBUG */
 	cciss_put_controller_into_performant_mode(c);
 	return 0;
 

