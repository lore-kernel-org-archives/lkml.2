Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1LLFWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:22:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1LLFWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:22:13 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 28/29] Staging: comedi: fix printk issue in contec_pci_dio.c
Date: Mon, 12 Dec 2011 10:49:40 +0530
Message-Id: <1323667181-17252-28-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the contec_pci_dio.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_dbg().

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index db73638..e3659bd 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -196,8 +196,8 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 
-	printk("contec_do_insn_bits called\n");
-	printk(" data: %d %d\n", data[0], data[1]);
+	dev_dbg(dev->hw_dev, "contec_do_insn_bits called\n");
+	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
 
 	if (insn->n != 2)
 		return -EINVAL;
@@ -205,8 +205,8 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
-		printk("  out: %d on %lx\n", s->state,
-		       dev->iobase + thisboard->out_offs);
+		dev_dbg(dev->hw_dev, "out: %d on %lx\n", s->state,
+			dev->iobase + thisboard->out_offs);
 		outw(s->state, dev->iobase + thisboard->out_offs);
 	}
 	return 2;
@@ -217,8 +217,8 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 
-	printk("contec_di_insn_bits called\n");
-	printk(" data: %d %d\n", data[0], data[1]);
+	dev_dbg(dev->hw_dev, "contec_di_insn_bits called\n");
+	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
 
 	if (insn->n != 2)
 		return -EINVAL;
-- 
1.7.0.4

