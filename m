Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2ABNQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:16:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35881 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2ABNQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:16:46 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu, jj@chaosbits.net,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 5/6] Staging: comedi: fix line over 80 character issue in daqboard2000.c
Date: Mon,  2 Jan 2012 18:40:01 +0530
Message-Id: <1325509801-20036-5-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325509801-20036-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325509801-20036-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a
line over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index e61c6a8..3550c6a 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -414,7 +414,7 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 
 	/* If pacer clock is not set to some high value (> 10 us), we
 	   risk multiple samples to be put into the result FIFO. */
-	fpga->acqPacerClockDivLow = 1000000;	/* 1 second, should be long enough */
+	/* 1 second, should be long enough */
 	fpga->acqPacerClockDivHigh = 0;
 
 	gain = CR_RANGE(insn->chanspec);
@@ -526,7 +526,8 @@ static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRProgPinLo, devpriv->plx + 0x6c);
-	udelay(10000);		/* Not in the original code, but I like symmetry... */
+	/* Not in the original code, but I like symmetry... */
+	udelay(10000);
 }
 
 static int daqboard2000_pollCPLD(struct comedi_device *dev, int mask)
-- 
1.7.0.4

