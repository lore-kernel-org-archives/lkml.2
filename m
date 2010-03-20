Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0CTSPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:15:55 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:35114 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0CTSPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:15:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vnKKoRm4BOIUqiWVSWcYaujdkRtqFxCcTPxPa3bZTeS/0ppbNOQBQ0wT2ACzU4zrsX
         E83U345Fm8ILHNp5kOGV2EY5eGdV3k9BxtAthAIFUvqThNf0/VhcQ7PbNpj8dDya8r78
         QpEIdBQXXIDGLUh0nIscSxdjCIhBJEQjLnRuA=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 3/9] Staging: comedi: adl_pci9111: fixed multiple brace coding style issue
Date: Sun, 21 Mar 2010 02:14:04 +0800
Message-Id: <1269108850-1414-4-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   30 +++++++++++++-------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index da172a5..7015fc0 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -585,9 +585,9 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	    (cmd->scan_begin_src != TRIG_EXT))
 		error++;
 
-	if ((cmd->convert_src != TRIG_TIMER) && (cmd->convert_src != TRIG_EXT)) {
+	if ((cmd->convert_src != TRIG_TIMER) && (cmd->convert_src != TRIG_EXT))
 		error++;
-	}
+
 	if ((cmd->convert_src == TRIG_TIMER) &&
 	    !((cmd->scan_begin_src == TRIG_TIMER) ||
 	      (cmd->scan_begin_src == TRIG_FOLLOW))) {
@@ -1067,9 +1067,9 @@ static int pci9111_ai_insn_read(struct comedi_device *dev,
 
 	pci9111_ai_channel_set(CR_CHAN((&insn->chanspec)[0]));
 
-	if ((pci9111_ai_range_get()) != CR_RANGE((&insn->chanspec)[0])) {
+	if ((pci9111_ai_range_get()) != CR_RANGE((&insn->chanspec)[0]))
 		pci9111_ai_range_set(CR_RANGE((&insn->chanspec)[0]));
-	}
+
 
 	pci9111_fifo_reset();
 
@@ -1090,11 +1090,11 @@ static int pci9111_ai_insn_read(struct comedi_device *dev,
 
 conversion_done:
 
-		if (resolution == PCI9111_HR_AI_RESOLUTION) {
+		if (resolution == PCI9111_HR_AI_RESOLUTION)
 			data[i] = pci9111_hr_ai_get_data();
-		} else {
+		else
 			data[i] = pci9111_ai_get_data();
-		}
+
 	}
 
 #ifdef AI_INSN_DEBUG
@@ -1131,9 +1131,9 @@ static int pci9111_ao_insn_read(struct comedi_device *dev,
 {
 	int i;
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = dev_private->ao_readback & PCI9111_AO_RESOLUTION_MASK;
-	}
+
 
 	return i;
 }
@@ -1222,9 +1222,9 @@ static int pci9111_attach(struct comedi_device *dev,
 	int error, i;
 	const struct pci9111_board *board;
 
-	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0) {
+	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0)
 		return -ENOMEM;
-	}
+
 	/*  Probe the device to determine what device in the series it is. */
 
 	printk("comedi%d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
@@ -1394,14 +1394,14 @@ static int pci9111_detach(struct comedi_device *dev)
 	}
 	/*  Release previously allocated irq */
 
-	if (dev->irq != 0) {
+	if (dev->irq != 0)
 		free_irq(dev->irq, dev);
-	}
+
 
 	if (dev_private != 0 && dev_private->pci_device != 0) {
-		if (dev->iobase) {
+		if (dev->iobase)
 			comedi_pci_disable(dev_private->pci_device);
-		}
+
 		pci_dev_put(dev_private->pci_device);
 	}
 
-- 
1.7.0.2

