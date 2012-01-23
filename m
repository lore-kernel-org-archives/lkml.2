Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2AWVIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:08:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58444 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2AWVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:08:06 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Michal Simek <monstr@monstr.eu>
Subject: [RFCv2 04/14] irq_domain: convert microblaze from irq_host to irq_domain
Date: Mon, 23 Jan 2012 14:07:40 -0700
Message-Id: <1327352870-14687-5-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial change, microblaze doesn't use irq remapping yet.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/irq.h |    4 ++--
 arch/microblaze/kernel/irq.c      |    2 +-
 arch/microblaze/kernel/setup.c    |    2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
index a175132..7798ad1 100644
--- a/arch/microblaze/include/asm/irq.h
+++ b/arch/microblaze/include/asm/irq.h
@@ -39,7 +39,7 @@ static inline void irq_dispose_mapping(unsigned int virq)
 	return;
 }
 
-struct irq_host;
+struct irq_domain;
 
 /**
  * irq_create_mapping - Map a hardware interrupt into linux virq space
@@ -51,7 +51,7 @@ struct irq_host;
  * If the sense/trigger is to be specified, set_irq_type() should be called
  * on the number returned from that call.
  */
-extern unsigned int irq_create_mapping(struct irq_host *host,
+extern unsigned int irq_create_mapping(struct irq_domain *host,
 					irq_hw_number_t hwirq);
 
 #endif /* _ASM_MICROBLAZE_IRQ_H */
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index bbebcae..3f613df 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -51,7 +51,7 @@ next_irq:
 
 /* MS: There is no any advance mapping mechanism. We are using simple 32bit
   intc without any cascades or any connection that's why mapping is 1:1 */
-unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)
+unsigned int irq_create_mapping(struct irq_domain *host, irq_hw_number_t hwirq)
 {
 	return hwirq + IRQ_OFFSET;
 }
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index d4fc1a9..208cd04 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -52,8 +52,6 @@ void __init setup_arch(char **cmdline_p)
 
 	unflatten_device_tree();
 
-	/* NOTE I think that this function is not necessary to call */
-	/* irq_early_init(); */
 	setup_cpuinfo();
 
 	microblaze_cache_init();
-- 
1.7.5.4

