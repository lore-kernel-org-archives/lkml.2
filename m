Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1LLFVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1LLFVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:34 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 20/29] Staging: comedi: fix printk issue in das1800.c
Date: Mon, 12 Dec 2011 10:49:32 +0530
Message-Id: <1323667181-17252-20-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das1800.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_dbg().

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 1ea9789..6ef3e8f 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -835,8 +835,8 @@ static int das1800_probe(struct comedi_device *dev)
 	case 0x3:
 		if (board == das1801st_da || board == das1802st_da ||
 		    board == das1701st_da || board == das1702st_da) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
 		printk
@@ -845,8 +845,8 @@ static int das1800_probe(struct comedi_device *dev)
 		break;
 	case 0x4:
 		if (board == das1802hr_da || board == das1702hr_da) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
 		printk
@@ -856,8 +856,8 @@ static int das1800_probe(struct comedi_device *dev)
 	case 0x5:
 		if (board == das1801ao || board == das1802ao ||
 		    board == das1701ao || board == das1702ao) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
 		printk
@@ -866,18 +866,19 @@ static int das1800_probe(struct comedi_device *dev)
 		break;
 	case 0x6:
 		if (board == das1802hr || board == das1702hr) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
-		printk(" Board model (probed, not recommended): das-1802hr\n");
+		printk
+		    (" Board model (probed, not recommended): das-1802hr\n");
 		return das1802hr;
 		break;
 	case 0x7:
 		if (board == das1801st || board == das1802st ||
 		    board == das1701st || board == das1702st) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
 		printk
@@ -886,8 +887,8 @@ static int das1800_probe(struct comedi_device *dev)
 		break;
 	case 0x8:
 		if (board == das1801hc || board == das1802hc) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
 		printk
-- 
1.7.0.4

