Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1H2OPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:15:37 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58720 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1H2OPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:15:31 -0400
From: Ravishankarkm <ravi.shankar@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankarkm <ravi.shankar@greenturtles.in>
Subject: [PATCH 2/3] Staging: comedi: fix printk issue in das1800.c
Date: Mon, 29 Aug 2011 19:45:08 +0530
Message-Id: <1314627308-14232-1-git-send-email-ravi.shankar@greenturtles.in>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi: fix printk issue in das1800.c>
References: <[PATCH]Staging: comedi: fix printk issue in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankarkm <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankarkm <ravi.shankar@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |   57 +++++++++++++-----------------
 1 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 222232c..e548a03 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -573,22 +573,21 @@ static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 			devpriv->dma_bits |= DMA_CH7_CH5;
 			break;
 		default:
-			printk(" only supports dma channels 5 through 7\n"
-			       " Dual dma only allows the following combinations:\n"
-			       " dma 5,6 / 6,7 / or 7,5\n");
+			pr_warn(" only supports dma channels 5 through 7\n"
+					" Dual dma only allows the following combinations:\n"
+					" dma 5,6 / 6,7 / or 7,5\n");
 			return -EINVAL;
 			break;
 		}
 		if (request_dma(dma0, driver_das1800.driver_name)) {
-			printk(" failed to allocate dma channel %i\n", dma0);
+			pr_warn(" failed to allocate dma channel %i\n", dma0);
 			return -EINVAL;
 		}
 		devpriv->dma0 = dma0;
 		devpriv->dma_current = dma0;
 		if (dma1) {
 			if (request_dma(dma1, driver_das1800.driver_name)) {
-				printk(" failed to allocate dma channel %i\n",
-				       dma1);
+				pr_warn(" failed to allocate dma channel %i\n",
+						dma1);
 				return -EINVAL;
 			}
 			devpriv->dma1 = dma1;
@@ -834,69 +833,63 @@ static int das1800_probe(struct comedi_device *dev)
 	case 0x3:
 		if (board == das1801st_da || board == das1802st_da ||
 		    board == das1701st_da || board == das1702st_da) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			pr_debug(" Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800st-da series\n");
+		pr_debug(" Board model (probed, not recommended): das-1800st-da series\n");
 		return das1801st;
 		break;
 	case 0x4:
 		if (board == das1802hr_da || board == das1702hr_da) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			pr_debug(" Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1802hr-da\n");
+		pr_debug(" Board model (probed, not recommended): das-1802hr-da\n");
 		return das1802hr;
 		break;
 	case 0x5:
 		if (board == das1801ao || board == das1802ao ||
 		    board == das1701ao || board == das1702ao) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			pr_debug(" Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800ao series\n");
+		pr_debug(" Board model (probed, not recommended): das-1800ao series\n");
 		return das1801ao;
 		break;
 	case 0x6:
 		if (board == das1802hr || board == das1702hr) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			pr_debug(" Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk(" Board model (probed, not recommended): das-1802hr\n");
+		pr_debug(" Board model (probed, not recommended): das-1802hr\n");
 		return das1802hr;
 		break;
 	case 0x7:
 		if (board == das1801st || board == das1802st ||
 		    board == das1701st || board == das1702st) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			pr_debug(" Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800st series\n");
+		pr_debug(" Board model (probed, not recommended): das-1800st series\n");
 		return das1801st;
 		break;
 	case 0x8:
 		if (board == das1801hc || board == das1802hc) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			pr_debug(" Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800hc series\n");
+		pr_debug(" Board model (probed, not recommended): das-1800hc series\n");
 		return das1801hc;
 		break;
 	default:
-		printk
-		    (" Board model: probe returned 0x%x (unknown, please report)\n",
-		     id);
+		pr_debug(" Board model: probe returned 0x%x (unknown, please report)\n",
+				id);
 		return board;
 		break;
 	}
-- 
1.7.6

