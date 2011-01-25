Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1AYKTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:32 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60299 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab1AYKTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:17 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 10/32] dma40: use sg_dma_address() instead of sg_phys()
Date: Tue, 25 Jan 2011 11:18:13 +0100
Message-ID: <1295950715-22340-11-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The address to use for DMA should be taken from sg_dma_address() and not
sg_phys().

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40_ll.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 0b096a3..6f03f58 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -272,7 +272,7 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		if (target)
 			dst = target;
 		else
-			dst = sg_phys(current_sg);
+			dst = sg_dma_address(current_sg);
 
 		l_phys = ALIGN(lli_phys + (lli - lli_sg) *
 			       sizeof(struct d40_phy_lli), D40_LLI_ALIGN);
@@ -416,7 +416,7 @@ int d40_log_sg_to_dev(struct scatterlist *sg,
 		if (direction == DMA_TO_DEVICE) {
 			lli_src =
 				d40_log_buf_to_lli(lli_src,
-						   sg_phys(current_sg),
+						   sg_dma_address(current_sg),
 						   sg_dma_len(current_sg),
 						   lcsp->lcsp1, src_data_width,
 						   dst_data_width,
@@ -431,7 +431,7 @@ int d40_log_sg_to_dev(struct scatterlist *sg,
 		} else {
 			lli_dst =
 				d40_log_buf_to_lli(lli_dst,
-						   sg_phys(current_sg),
+						   sg_dma_address(current_sg),
 						   sg_dma_len(current_sg),
 						   lcsp->lcsp3, dst_data_width,
 						   src_data_width,
@@ -491,7 +491,7 @@ int d40_log_sg_to_lli(struct scatterlist *sg,
 	for_each_sg(sg, current_sg, sg_len, i) {
 		total_size += sg_dma_len(current_sg);
 		lli = d40_log_buf_to_lli(lli,
-					 sg_phys(current_sg),
+					 sg_dma_address(current_sg),
 					 sg_dma_len(current_sg),
 					 lcsp13,
 					 data_width1, data_width2, true);
-- 
1.7.3.2

