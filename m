Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0J3VOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:14:06 -0400
Received: from mail.perches.com ([173.55.12.10]:3730 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0J3VJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/39] drivers/mfd: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:32 -0700
Message-Id: <726f9189d4f8427f23b4e5ae98879012f7a88dea.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mfd/ezx-pcap.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index c2b698d..4f674275 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -199,8 +199,7 @@ static void pcap_isr_work(struct work_struct *work)
 			if (service & 1) {
 				struct irq_desc *desc = irq_to_desc(irq);
 
-				if (WARN(!desc, KERN_WARNING
-						"Invalid PCAP IRQ %d\n", irq))
+				if (WARN(!desc, "Invalid PCAP IRQ %d\n", irq))
 					break;
 
 				if (desc->status & IRQ_DISABLED)
@@ -282,7 +281,7 @@ static irqreturn_t pcap_adc_irq(int irq, void *_pcap)
 	mutex_lock(&pcap->adc_mutex);
 	req = pcap->adc_queue[pcap->adc_head];
 
-	if (WARN(!req, KERN_WARNING "adc irq without pending request\n")) {
+	if (WARN(!req, "adc irq without pending request\n")) {
 		mutex_unlock(&pcap->adc_mutex);
 		return IRQ_HANDLED;
 	}
-- 
1.7.3.1.g432b3.dirty

