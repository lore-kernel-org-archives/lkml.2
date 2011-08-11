Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1HKGnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 02:43:17 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:34878 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1HKGnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 02:43:15 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk() issue in das1800.c
Date: Thu, 11 Aug 2011 12:27:44 +0530
Message-Id: <1313045864-20313-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix printk warning issue in das1800.c>
References: <[PATCH]Staging: comedi: fix printk warning issue in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das1800.c |   49 +++++++++++++----------------
 1 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index a6df30b..ee5f614 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -826,76 +826,71 @@ static int das1800_probe(struct comedi_device *dev)
 	int id;
 	int board;
 
-	id = (inb(dev->iobase + DAS1800_DIGITAL) >> 4) & 0xf;	/* get id bits */
+	/* get id bits */
+	id = (inb(dev->iobase + DAS1800_DIGITAL) >> 4) & 0xf;
 	board = ((struct das1800_board *)dev->board_ptr) - das1800_boards;
 
 	switch (id) {
 	case 0x3:
 		if (board == das1801st_da || board == das1802st_da ||
 		    board == das1701st_da || board == das1702st_da) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			printk(KERN_DEBUG " Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800st-da series\n");
+		printk(KERN_DEBUG " Board model (probed, not recommended): das-1800st-da series\n");
 		return das1801st;
 		break;
 	case 0x4:
 		if (board == das1802hr_da || board == das1702hr_da) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			printk(KERN_DEBUG " Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1802hr-da\n");
+		printk(KERN_DEBUG " Board model (probed, not recommended): das-1802hr-da\n");
 		return das1802hr;
 		break;
 	case 0x5:
 		if (board == das1801ao || board == das1802ao ||
 		    board == das1701ao || board == das1702ao) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			printk(KERN_DEBUG " Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800ao series\n");
+		printk(KERN_DEBUG " Board model (probed, not recommended): das-1800ao series\n");
 		return das1801ao;
 		break;
 	case 0x6:
 		if (board == das1802hr || board == das1702hr) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			printk(KERN_DEBUG " Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk(" Board model (probed, not recommended): das-1802hr\n");
+		printk(KERN_DEBUG " Board model (probed, not recommended): das-1802hr\n");
 		return das1802hr;
 		break;
 	case 0x7:
 		if (board == das1801st || board == das1802st ||
 		    board == das1701st || board == das1702st) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			printk(KERN_DEBUG " Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800st series\n");
+		printk(KERN_DEBUG " Board model (probed, not recommended): das-1800st series\n");
 		return das1801st;
 		break;
 	case 0x8:
 		if (board == das1801hc || board == das1802hc) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			printk(KERN_DEBUG " Board model: %s\n",
+					das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800hc series\n");
+		printk(KERN_DEBUG " Board model (probed, not recommended): das-1800hc series\n");
 		return das1801hc;
 		break;
 	default:
-		printk
-		    (" Board model: probe returned 0x%x (unknown, please report)\n",
-		     id);
+		printk(KERN_DEBUG " Board model: probe returned 0x%x (unknown, please report)\n",
+				id);
 		return board;
 		break;
 	}
-- 
1.6.5.2

