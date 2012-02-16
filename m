Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2BPJLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2BPJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:48 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Mark Salter <msalter@redhat.com>
Subject: [PATCH v5 21/27] irq_domain/c6x: Use library of xlate functions
Date: Thu, 16 Feb 2012 02:09:22 -0700
Message-Id: <1329383368-12122-22-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The c6x irq controllers don't need to define custom .xlate hooks

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/c6x/kernel/irq.c            |    1 +
 arch/c6x/platforms/megamod-pic.c |   14 +-------------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
index c6b36e8..d77bcfd 100644
--- a/arch/c6x/kernel/irq.c
+++ b/arch/c6x/kernel/irq.c
@@ -88,6 +88,7 @@ static int core_domain_map(struct irq_domain *h, unsigned int virq,
 
 static const struct irq_domain_ops core_domain_ops = {
 	.map = core_domain_map,
+	.xlate = irq_domain_xlate_onecell,
 };
 
 void __init init_IRQ(void)
diff --git a/arch/c6x/platforms/megamod-pic.c b/arch/c6x/platforms/megamod-pic.c
index 9f35fbf..c1c4e2a 100644
--- a/arch/c6x/platforms/megamod-pic.c
+++ b/arch/c6x/platforms/megamod-pic.c
@@ -136,21 +136,9 @@ static int megamod_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static int megamod_xlate(struct irq_domain *h, struct device_node *ct,
-			 const u32 *intspec, unsigned int intsize,
-			 irq_hw_number_t *out_hwirq, unsigned int *out_type)
-
-{
-	/* megamod intspecs must have 1 cell */
-	BUG_ON(intsize != 1);
-	*out_hwirq = intspec[0];
-	*out_type = IRQ_TYPE_NONE;
-	return 0;
-}
-
 static const struct irq_domain_ops megamod_domain_ops = {
 	.map	= megamod_map,
-	.xlate	= megamod_xlate,
+	.xlate	= irq_domain_xlate_onecell,
 };
 
 static void __init set_megamod_mux(struct megamod_pic *pic, int src, int output)
-- 
1.7.9

