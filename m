Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1LHMyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:54:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38835 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1LHMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:53:56 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 13/30] Staging: comedi: fix printk issue in contec_pci_dio.c
Date: Thu,  8 Dec 2011 18:22:08 +0530
Message-Id: <1323348745-31477-13-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the contec_pci_dio.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to pr_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 64f5f49..2ca740a 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -179,7 +179,7 @@ static int contec_detach(struct comedi_device *dev)
 static int contec_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_cmd *cmd)
 {
-	printk("contec_cmdtest called\n");
+	pr_debug("contec_cmdtest called\n");
 	return 0;
 }
 
@@ -194,8 +194,8 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 
-	printk("contec_do_insn_bits called\n");
-	printk(" data: %d %d\n", data[0], data[1]);
+	pr_debug("contec_do_insn_bits called\n");
+	pr_debug("data: %d %d\n", data[0], data[1]);
 
 	if (insn->n != 2)
 		return -EINVAL;
@@ -203,8 +203,8 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
-		printk("  out: %d on %lx\n", s->state,
-		       dev->iobase + thisboard->out_offs);
+		pr_debug("out: %d on %lx\n", s->state,
+			 dev->iobase + thisboard->out_offs);
 		outw(s->state, dev->iobase + thisboard->out_offs);
 	}
 	return 2;
@@ -215,8 +215,8 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 
-	printk("contec_di_insn_bits called\n");
-	printk(" data: %d %d\n", data[0], data[1]);
+	pr_debug("contec_di_insn_bits called\n");
+	pr_debug("data: %d %d\n", data[0], data[1]);
 
 	if (insn->n != 2)
 		return -EINVAL;
-- 
1.7.0.4

