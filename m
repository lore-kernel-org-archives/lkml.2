Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2LOUlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:41:55 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63953 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2LOUlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:41:53 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 02:11:52 +0530
Message-ID: <CAA_L+UMcV7XBx0WxccWU2LcGqXLYygcT6HhqJ8FE0rzFY9Eqgg@mail.gmail.com>
Subject: [PATCH 3.7.0 4/9] i82975x_edac.c: remove unnecessary function
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.7.0 4/9] i82975x_edac.c: remove unnecessary function

remove function that returns a constant value and variable to
hold the returned value.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2012-12-15 20:19:16 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-12-15 20:19:02 +0530
@@ -360,14 +360,6 @@ static int dual_channel_active(void __io
 	return dualch;
 }

-static enum dev_type i82975x_dram_type(void __iomem *mch_window, int rank)
-{
-	/*
-	 * ECC is possible on i92975x ONLY with DEV_X8
-	 */
-	return DEV_X8;
-}
-
 static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		struct pci_dev *pdev, void __iomem *mch_window)
 {
@@ -377,7 +369,6 @@ static void i82975x_init_csrows(struct m
 	u32 cumul_size, nr_pages;
 	int index, chan;
 	struct dimm_info *dimm;
-	enum dev_type dtype;

 	last_cumul_size = 0;

@@ -415,7 +406,6 @@ static void i82975x_init_csrows(struct m
 		 *   [0-7] for single-channel; i.e. csrow->nr_channels = 1
 		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
 		 */
-		dtype = i82975x_dram_type(mch_window, index);
 		for (chan = 0; chan < csrow->nr_channels; chan++) {
 			dimm = mci->csrows[index]->channels[chan]->dimm;

@@ -426,7 +416,7 @@ static void i82975x_init_csrows(struct m
 				 (chan == 0) ? 'A' : 'B',
 				 index);
 			dimm->grain = 1 << 7;	/* always */
-			dimm->dtype = i82975x_dram_type(mch_window, index);
+			dimm->dtype = DEV_X8;	/* only with ECC */
 			dimm->mtype = MEM_DDR2; /* only supported */
 			dimm->edac_mode = EDAC_SECDED; /* only supported */
 		}
