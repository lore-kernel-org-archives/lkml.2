Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab1CaOyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:54:54 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57429 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1CaOwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 14/21] irq: export handle_simple_irq and irq_to_desc to allow for virtual irqs in IIO
Date: Thu, 31 Mar 2011 15:54:08 +0100
Message-Id: <1301583255-28468-15-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 kernel/irq/chip.c    |    1 +
 kernel/irq/irqdesc.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c9c0601..4647fe9 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -431,6 +431,7 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL_GPL(handle_simple_irq);
 
 /**
  *	handle_level_irq - Level type irq handler
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 6fb014f..0403c5a 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -110,6 +110,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 {
 	return radix_tree_lookup(&irq_desc_tree, irq);
 }
+EXPORT_SYMBOL_GPL(irq_to_desc);
 
 static void delete_irq_desc(unsigned int irq)
 {
-- 
1.7.3.4

