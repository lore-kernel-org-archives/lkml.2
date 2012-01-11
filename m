Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab2AKUYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:24:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47650 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933758Ab2AKUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:22:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC 14/14] irq_domain: Remove irq_domain_add_simple()
Date: Wed, 11 Jan 2012 13:22:17 -0700
Message-Id: <1326313337-24603-15-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_domain_add_simple() was a stop-gap measure until complete irq_domain
support was complete.  This patch removes the irq_domain_add_simple()
interface.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/mach-imx/imx51-dt.c        |    4 ++--
 arch/arm/mach-imx/imx53-dt.c        |    4 ++--
 arch/arm/mach-imx/mach-imx6q.c      |    2 +-
 arch/arm/mach-msm/board-msm8x60.c   |    8 ++------
 arch/arm/mach-omap2/board-generic.c |    2 +-
 arch/arm/mach-prima2/irq.c          |    2 +-
 include/linux/irqdomain.h           |    1 -
 kernel/irq/irqdomain.c              |   10 ++--------
 8 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
index e6bad17..83e660f 100644
--- a/arch/arm/mach-imx/imx51-dt.c
+++ b/arch/arm/mach-imx/imx51-dt.c
@@ -47,7 +47,7 @@ static const struct of_dev_auxdata imx51_auxdata_lookup[] __initconst = {
 static int __init imx51_tzic_add_irq_domain(struct device_node *np,
 				struct device_node *interrupt_parent)
 {
-	irq_domain_add_simple(np, 0);
+	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops);
 	return 0;
 }
 
@@ -57,7 +57,7 @@ static int __init imx51_gpio_add_irq_domain(struct device_node *np,
 	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
 
 	gpio_irq_base -= 32;
-	irq_domain_add_simple(np, gpio_irq_base);
+	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops);
 
 	return 0;
 }
diff --git a/arch/arm/mach-imx/imx53-dt.c b/arch/arm/mach-imx/imx53-dt.c
index 05ebb3e..ba2558d 100644
--- a/arch/arm/mach-imx/imx53-dt.c
+++ b/arch/arm/mach-imx/imx53-dt.c
@@ -51,7 +51,7 @@ static const struct of_dev_auxdata imx53_auxdata_lookup[] __initconst = {
 static int __init imx53_tzic_add_irq_domain(struct device_node *np,
 				struct device_node *interrupt_parent)
 {
-	irq_domain_add_simple(np, 0);
+	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops);
 	return 0;
 }
 
@@ -61,7 +61,7 @@ static int __init imx53_gpio_add_irq_domain(struct device_node *np,
 	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
 
 	gpio_irq_base -= 32;
-	irq_domain_add_simple(np, gpio_irq_base);
+	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops);
 
 	return 0;
 }
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index c257281..7a98354 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -97,7 +97,7 @@ static int __init imx6q_gpio_add_irq_domain(struct device_node *np,
 	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
 
 	gpio_irq_base -= 32;
-	irq_domain_add_simple(np, gpio_irq_base);
+	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops);
 
 	return 0;
 }
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 0a11342..962e711 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -80,12 +80,8 @@ static struct of_device_id msm_dt_gic_match[] __initdata = {
 
 static void __init msm8x60_dt_init(void)
 {
-	struct device_node *node;
-
-	node = of_find_matching_node_by_address(NULL, msm_dt_gic_match,
-			MSM8X60_QGIC_DIST_PHYS);
-	if (node)
-		irq_domain_add_simple(node, GIC_SPI_START);
+	irq_domain_generate_simple(msm_dt_gic_match, MSM8X60_QGIC_DIST_PHYS,
+				GIC_SPI_START);
 
 	if (of_machine_is_compatible("qcom,msm8660-surf")) {
 		printk(KERN_INFO "Init surf UART registers\n");
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index d587560..0b8e095 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -67,7 +67,7 @@ static void __init omap_generic_init(void)
 {
 	struct device_node *node = of_find_matching_node(NULL, intc_match);
 	if (node)
-		irq_domain_add_simple(node, 0);
+		irq_domain_add_legacy(node, 32, 0, 0, &irq_domain_simple_ops);
 
 	omap_sdrc_init(NULL, NULL);
 
diff --git a/arch/arm/mach-prima2/irq.c b/arch/arm/mach-prima2/irq.c
index d93ceef..676d512 100644
--- a/arch/arm/mach-prima2/irq.c
+++ b/arch/arm/mach-prima2/irq.c
@@ -68,7 +68,7 @@ void __init sirfsoc_of_irq_init(void)
 	if (!sirfsoc_intc_base)
 		panic("unable to map intc cpu registers\n");
 
-	irq_domain_add_simple(np, 0);
+	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops);
 
 	of_node_put(np);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 7c25e7c..5818908 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -163,7 +163,6 @@ extern unsigned int irq_linear_revmap(struct irq_domain *host,
 
 extern struct irq_domain_ops irq_domain_simple_ops;
 #if defined(CONFIG_OF_IRQ)
-extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
 extern void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start);
 #else /* CONFIG_OF_IRQ */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index b90a32e..d3e00c7 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -689,13 +689,6 @@ struct irq_domain_ops irq_domain_simple_ops = {
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
 
 #ifdef CONFIG_OF_IRQ
-void irq_domain_add_simple(struct device_node *controller, int irq_base)
-{
-	irq_domain_add_legacy(controller, 32, irq_base, 0,
-			      &irq_domain_simple_ops);
-}
-EXPORT_SYMBOL_GPL(irq_domain_add_simple);
-
 void irq_domain_generate_simple(const struct of_device_id *match,
 				u64 phys_base, unsigned int irq_start)
 {
@@ -704,7 +697,8 @@ void irq_domain_generate_simple(const struct of_device_id *match,
 		(unsigned long long) phys_base, (int) irq_start);
 	node = of_find_matching_node_by_address(NULL, match, phys_base);
 	if (node)
-		irq_domain_add_simple(node, irq_start);
+		irq_domain_add_legacy(controller, 32, irq_start, 0,
+					&irq_domain_simple_ops);
 }
 EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
 #endif
-- 
1.7.5.4

