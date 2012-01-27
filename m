Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2A0VjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:39:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab2A0Vgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:50 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 20/25] irq_domain/powerpc: constify irq_domain_ops
Date: Fri, 27 Jan 2012 14:36:14 -0700
Message-Id: <1327700179-17454-21-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make all the irq_domain_ops structures in powerpc 'static const'

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    2 +-
 arch/powerpc/platforms/52xx/media5200.c          |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |    2 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    2 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |    2 +-
 arch/powerpc/platforms/86xx/gef_pic.c            |    2 +-
 arch/powerpc/platforms/cell/axon_msi.c           |    2 +-
 arch/powerpc/platforms/cell/beat_interrupt.c     |    2 +-
 arch/powerpc/platforms/cell/interrupt.c          |    2 +-
 arch/powerpc/platforms/cell/spider-pic.c         |    2 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |    2 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    2 +-
 arch/powerpc/platforms/iseries/irq.c             |    2 +-
 arch/powerpc/platforms/powermac/pic.c            |    2 +-
 arch/powerpc/platforms/powermac/smp.c            |    2 +-
 arch/powerpc/platforms/ps3/interrupt.c           |    2 +-
 arch/powerpc/platforms/wsp/opb_pic.c             |    2 +-
 arch/powerpc/sysdev/cpm1.c                       |    2 +-
 arch/powerpc/sysdev/cpm2_pic.c                   |    2 +-
 arch/powerpc/sysdev/ehv_pic.c                    |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                    |    2 +-
 22 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
index 291d61c..ca3a062 100644
--- a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
+++ b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
@@ -137,7 +137,7 @@ cpld_pic_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_domain_ops cpld_pic_host_ops = {
+static const struct irq_domain_ops cpld_pic_host_ops = {
 	.match = cpld_pic_host_match,
 	.map = cpld_pic_host_map,
 };
diff --git a/arch/powerpc/platforms/52xx/media5200.c b/arch/powerpc/platforms/52xx/media5200.c
index 5db5cfb..17d91b7 100644
--- a/arch/powerpc/platforms/52xx/media5200.c
+++ b/arch/powerpc/platforms/52xx/media5200.c
@@ -136,7 +136,7 @@ static int media5200_irq_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops media5200_irq_ops = {
+static const struct irq_domain_ops media5200_irq_ops = {
 	.map = media5200_irq_map,
 	.xlate = media5200_irq_xlate,
 };
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index b53275d..028470b 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -236,7 +236,7 @@ static int mpc52xx_gpt_irq_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops mpc52xx_gpt_irq_ops = {
+static const struct irq_domain_ops mpc52xx_gpt_irq_ops = {
 	.map = mpc52xx_gpt_irq_map,
 	.xlate = mpc52xx_gpt_irq_xlate,
 };
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index 41fa671..8520b58 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -384,7 +384,7 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_domain_ops mpc52xx_irqhost_ops = {
+static const struct irq_domain_ops mpc52xx_irqhost_ops = {
 	.xlate = mpc52xx_irqhost_xlate,
 	.map = mpc52xx_irqhost_map,
 };
diff --git a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
index 4ef9d69..328d221 100644
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -112,7 +112,7 @@ static int pci_pic_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_domain_ops pci_pic_host_ops = {
+static const struct irq_domain_ops pci_pic_host_ops = {
 	.map = pci_pic_host_map,
 };
 
diff --git a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
index 1092c12..3bbbf74 100644
--- a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
+++ b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
@@ -269,7 +269,7 @@ static int socrates_fpga_pic_host_xlate(struct irq_domain *h,
 	return 0;
 }
 
-static struct irq_domain_ops socrates_fpga_pic_host_ops = {
+static const struct irq_domain_ops socrates_fpga_pic_host_ops = {
 	.map    = socrates_fpga_pic_host_map,
 	.xlate  = socrates_fpga_pic_host_xlate,
 };
diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/platforms/86xx/gef_pic.c
index 126a94b..af3fd69 100644
--- a/arch/powerpc/platforms/86xx/gef_pic.c
+++ b/arch/powerpc/platforms/86xx/gef_pic.c
@@ -177,7 +177,7 @@ static int gef_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops gef_pic_host_ops = {
+static const struct irq_domain_ops gef_pic_host_ops = {
 	.map	= gef_pic_host_map,
 	.xlate	= gef_pic_host_xlate,
 };
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index cf9fd3c..db360fc 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -327,7 +327,7 @@ static int msic_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_domain_ops msic_host_ops = {
+static const struct irq_domain_ops msic_host_ops = {
 	.map	= msic_host_map,
 };
 
diff --git a/arch/powerpc/platforms/cell/beat_interrupt.c b/arch/powerpc/platforms/cell/beat_interrupt.c
index bbdf574..e5c3a2c 100644
--- a/arch/powerpc/platforms/cell/beat_interrupt.c
+++ b/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -172,7 +172,7 @@ static int beatic_pic_host_match(struct irq_domain *h, struct device_node *np)
 	return 1;
 }
 
-static struct irq_domain_ops beatic_pic_host_ops = {
+static const struct irq_domain_ops beatic_pic_host_ops = {
 	.map = beatic_pic_host_map,
 	.unmap = beatic_pic_host_unmap,
 	.xlate = beatic_pic_host_xlate,
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index c844797..2d42f3b 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -285,7 +285,7 @@ static int iic_host_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops iic_host_ops = {
+static const struct irq_domain_ops iic_host_ops = {
 	.match = iic_host_match,
 	.map = iic_host_map,
 	.xlate = iic_host_xlate,
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index 6521d20..d8b7cc8 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -194,7 +194,7 @@ static int spider_host_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops spider_host_ops = {
+static const struct irq_domain_ops spider_host_ops = {
 	.map = spider_host_map,
 	.xlate = spider_host_xlate,
 };
diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
index 4345971..675335a 100644
--- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -113,7 +113,7 @@ static int flipper_pic_match(struct irq_domain *h, struct device_node *np)
 }
 
 
-static struct irq_domain_ops flipper_irq_domain_ops = {
+static const struct irq_domain_ops flipper_irq_domain_ops = {
 	.map = flipper_pic_map,
 	.match = flipper_pic_match,
 };
diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index 499d410..da6ca02 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -100,7 +100,7 @@ static int hlwd_pic_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_domain_ops hlwd_irq_domain_ops = {
+static const struct irq_domain_ops hlwd_irq_domain_ops = {
 	.map = hlwd_pic_map,
 };
 
diff --git a/arch/powerpc/platforms/iseries/irq.c b/arch/powerpc/platforms/iseries/irq.c
index 5538b59..05ce516 100644
--- a/arch/powerpc/platforms/iseries/irq.c
+++ b/arch/powerpc/platforms/iseries/irq.c
@@ -356,7 +356,7 @@ static int iseries_irq_host_match(struct irq_domain *h, struct device_node *np)
 	return 1;
 }
 
-static struct irq_domain_ops iseries_irq_domain_ops = {
+static const struct irq_domain_ops iseries_irq_domain_ops = {
 	.map = iseries_irq_host_map,
 	.match = iseries_irq_host_match,
 };
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 646fdf3..46a5f32 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -299,7 +299,7 @@ static int pmac_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops pmac_pic_host_ops = {
+static const struct irq_domain_ops pmac_pic_host_ops = {
 	.match = pmac_pic_host_match,
 	.map = pmac_pic_host_map,
 	.xlate = pmac_pic_host_xlate,
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index 09afd70..a81e5a8 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -184,7 +184,7 @@ static int psurge_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-struct irq_domain_ops psurge_host_ops = {
+static const struct irq_domain_ops psurge_host_ops = {
 	.map	= psurge_host_map,
 };
 
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index c05808f..2a4ff86 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -684,7 +684,7 @@ static int ps3_host_match(struct irq_domain *h, struct device_node *np)
 	return 1;
 }
 
-static struct irq_domain_ops ps3_host_ops = {
+static const struct irq_domain_ops ps3_host_ops = {
 	.map = ps3_host_map,
 	.match = ps3_host_match,
 };
diff --git a/arch/powerpc/platforms/wsp/opb_pic.c b/arch/powerpc/platforms/wsp/opb_pic.c
index 4837515..0c6fe0b 100644
--- a/arch/powerpc/platforms/wsp/opb_pic.c
+++ b/arch/powerpc/platforms/wsp/opb_pic.c
@@ -207,7 +207,7 @@ static int opb_host_xlate(struct irq_domain *host, struct device_node *dn,
 	return 0;
 }
 
-static struct irq_domain_ops opb_host_ops = {
+static const struct irq_domain_ops opb_host_ops = {
 	.map = opb_host_map,
 	.xlate = opb_host_xlate,
 };
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index 53f39db..d4fa03f 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -123,7 +123,7 @@ static struct irqaction cpm_error_irqaction = {
 	.name = "error",
 };
 
-static struct irq_domain_ops cpm_pic_host_ops = {
+static const struct irq_domain_ops cpm_pic_host_ops = {
 	.map = cpm_pic_host_map,
 };
 
diff --git a/arch/powerpc/sysdev/cpm2_pic.c b/arch/powerpc/sysdev/cpm2_pic.c
index b364332..8c9fc9c 100644
--- a/arch/powerpc/sysdev/cpm2_pic.c
+++ b/arch/powerpc/sysdev/cpm2_pic.c
@@ -236,7 +236,7 @@ static int cpm2_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops cpm2_pic_host_ops = {
+static const struct irq_domain_ops cpm2_pic_host_ops = {
 	.map = cpm2_pic_host_map,
 	.xlate = cpm2_pic_host_xlate,
 };
diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
index adea322..6e0e100 100644
--- a/arch/powerpc/sysdev/ehv_pic.c
+++ b/arch/powerpc/sysdev/ehv_pic.c
@@ -248,7 +248,7 @@ static int ehv_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops ehv_pic_host_ops = {
+static const struct irq_domain_ops ehv_pic_host_ops = {
 	.match = ehv_pic_host_match,
 	.map = ehv_pic_host_map,
 	.xlate = ehv_pic_host_xlate,
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index f4fd95b..0c01deb 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -74,7 +74,7 @@ static int fsl_msi_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_domain_ops fsl_msi_host_ops = {
+static const struct irq_domain_ops fsl_msi_host_ops = {
 	.map = fsl_msi_host_map,
 };
 
-- 
1.7.5.4

