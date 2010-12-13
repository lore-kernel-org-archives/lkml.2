Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0LMMaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:30:16 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36131 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab0LMMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:30:10 -0500
Date: Mon, 13 Dec 2010 13:30:09 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/20] mfd: ezx-pcap: irq_data conversion.
Message-ID: <20101213123009.GO15575@mail.wantstofly.org>
References: <cover.1292241952.git.buytenh@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292241952.git.buytenh@wantstofly.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
---
 drivers/mfd/ezx-pcap.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index c2b698d..601e433 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -144,26 +144,26 @@ int pcap_to_irq(struct pcap_chip *pcap, int irq)
 }
 EXPORT_SYMBOL_GPL(pcap_to_irq);
 
-static void pcap_mask_irq(unsigned int irq)
+static void pcap_mask_irq(struct irq_data *d)
 {
-	struct pcap_chip *pcap = get_irq_chip_data(irq);
+	struct pcap_chip *pcap = irq_data_get_irq_chip_data(d);
 
-	pcap->msr |= 1 << irq_to_pcap(pcap, irq);
+	pcap->msr |= 1 << irq_to_pcap(pcap, d->irq);
 	queue_work(pcap->workqueue, &pcap->msr_work);
 }
 
-static void pcap_unmask_irq(unsigned int irq)
+static void pcap_unmask_irq(struct irq_data *d)
 {
-	struct pcap_chip *pcap = get_irq_chip_data(irq);
+	struct pcap_chip *pcap = irq_data_get_irq_chip_data(d);
 
-	pcap->msr &= ~(1 << irq_to_pcap(pcap, irq));
+	pcap->msr &= ~(1 << irq_to_pcap(pcap, d->irq));
 	queue_work(pcap->workqueue, &pcap->msr_work);
 }
 
 static struct irq_chip pcap_irq_chip = {
-	.name	= "pcap",
-	.mask	= pcap_mask_irq,
-	.unmask	= pcap_unmask_irq,
+	.name		= "pcap",
+	.irq_mask	= pcap_mask_irq,
+	.irq_unmask	= pcap_unmask_irq,
 };
 
 static void pcap_msr_work(struct work_struct *work)
@@ -218,7 +218,7 @@ static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct pcap_chip *pcap = get_irq_data(irq);
 
-	desc->chip->ack(irq);
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
 	queue_work(pcap->workqueue, &pcap->isr_work);
 	return;
 }
-- 
1.7.1

