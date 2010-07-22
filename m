Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab0GVWbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:31:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38066 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759985Ab0GVWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:30:20 -0400
Subject: [PATCH 3/4] sparc: remove references to of_device and to_of_device
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Jul 2010 16:30:16 -0600
Message-ID: <20100722223016.21557.40832.stgit@angua>
In-Reply-To: <20100722222600.21557.34167.stgit@angua>
References: <20100722222600.21557.34167.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_device is just a #define alias to platform_device.  This patch
replaces all references to it with platform_device.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/sparc/include/asm/prom.h        |    2 +-
 arch/sparc/kernel/apc.c              |    4 ++--
 arch/sparc/kernel/auxio_64.c         |    3 ++-
 arch/sparc/kernel/central.c          |    4 ++--
 arch/sparc/kernel/chmc.c             |   12 ++++++------
 arch/sparc/kernel/ioport.c           |    2 +-
 arch/sparc/kernel/of_device_32.c     |   14 +++++++-------
 arch/sparc/kernel/of_device_64.c     |   16 ++++++++--------
 arch/sparc/kernel/of_device_common.c |   14 +++++++-------
 arch/sparc/kernel/pci.c              |    4 ++--
 arch/sparc/kernel/pci_fire.c         |    4 ++--
 arch/sparc/kernel/pci_impl.h         |    2 +-
 arch/sparc/kernel/pci_psycho.c       |    6 +++---
 arch/sparc/kernel/pci_sabre.c        |    6 +++---
 arch/sparc/kernel/pci_schizo.c       |   10 +++++-----
 arch/sparc/kernel/pci_sun4v.c        |    4 ++--
 arch/sparc/kernel/pmc.c              |    2 +-
 arch/sparc/kernel/power.c            |    2 +-
 arch/sparc/kernel/prom_irqtrans.c    |    2 +-
 arch/sparc/kernel/psycho_common.c    |    2 +-
 arch/sparc/kernel/psycho_common.h    |    2 +-
 arch/sparc/kernel/sbus.c             |   16 ++++++++--------
 arch/sparc/kernel/time_32.c          |    2 +-
 arch/sparc/kernel/time_64.c          |    6 +++---
 arch/sparc/mm/io-unit.c              |    4 ++--
 arch/sparc/mm/iommu.c                |    4 ++--
 26 files changed, 75 insertions(+), 74 deletions(-)

diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index d35df5a..c82a7da 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -57,7 +57,7 @@ extern void of_iounmap(struct resource *res, void __iomem *base, unsigned long s
 
 /* These routines are here to provide compatibility with how powerpc
  * handles IRQ mapping for OF device nodes.  We precompute and permanently
- * register them in the of_device objects, whereas powerpc computes them
+ * register them in the platform_device objects, whereas powerpc computes them
  * on request.
  */
 static inline void irq_dispose_mapping(unsigned int virq)
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index c471251..2c0046e 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -68,7 +68,7 @@ static void apc_swift_idle(void)
 #endif
 } 
 
-static inline void apc_free(struct of_device *op)
+static inline void apc_free(struct platform_device *op)
 {
 	of_iounmap(&op->resource[0], regs, resource_size(&op->resource[0]));
 }
@@ -136,7 +136,7 @@ static const struct file_operations apc_fops = {
 
 static struct miscdevice apc_miscdev = { APC_MINOR, APC_DEVNAME, &apc_fops };
 
-static int __devinit apc_probe(struct of_device *op,
+static int __devinit apc_probe(struct platform_device *op,
 			       const struct of_device_id *match)
 {
 	int err;
diff --git a/arch/sparc/kernel/auxio_64.c b/arch/sparc/kernel/auxio_64.c
index 46ba58a..3efd3c5 100644
--- a/arch/sparc/kernel/auxio_64.c
+++ b/arch/sparc/kernel/auxio_64.c
@@ -102,7 +102,8 @@ static struct of_device_id __initdata auxio_match[] = {
 
 MODULE_DEVICE_TABLE(of, auxio_match);
 
-static int __devinit auxio_probe(struct of_device *dev, const struct of_device_id *match)
+static int __devinit auxio_probe(struct platform_device *dev,
+				 const struct of_device_id *match)
 {
 	struct device_node *dp = dev->dev.of_node;
 	unsigned long size;
diff --git a/arch/sparc/kernel/central.c b/arch/sparc/kernel/central.c
index b6080c3..cfa2624 100644
--- a/arch/sparc/kernel/central.c
+++ b/arch/sparc/kernel/central.c
@@ -59,7 +59,7 @@ static int __devinit clock_board_calc_nslots(struct clock_board *p)
 	}
 }
 
-static int __devinit clock_board_probe(struct of_device *op,
+static int __devinit clock_board_probe(struct platform_device *op,
 				       const struct of_device_id *match)
 {
 	struct clock_board *p = kzalloc(sizeof(*p), GFP_KERNEL);
@@ -157,7 +157,7 @@ static struct of_platform_driver clock_board_driver = {
 	},
 };
 
-static int __devinit fhc_probe(struct of_device *op,
+static int __devinit fhc_probe(struct platform_device *op,
 			       const struct of_device_id *match)
 {
 	struct fhc *p = kzalloc(sizeof(*p), GFP_KERNEL);
diff --git a/arch/sparc/kernel/chmc.c b/arch/sparc/kernel/chmc.c
index 04bb7df..08c466e 100644
--- a/arch/sparc/kernel/chmc.c
+++ b/arch/sparc/kernel/chmc.c
@@ -392,7 +392,7 @@ static void __devinit jbusmc_construct_dimm_groups(struct jbusmc *p,
 	}
 }
 
-static int __devinit jbusmc_probe(struct of_device *op,
+static int __devinit jbusmc_probe(struct platform_device *op,
 				  const struct of_device_id *match)
 {
 	const struct linux_prom64_registers *mem_regs;
@@ -690,7 +690,7 @@ static void chmc_fetch_decode_regs(struct chmc *p)
 				      chmc_read_mcreg(p, CHMCTRL_DECODE4));
 }
 
-static int __devinit chmc_probe(struct of_device *op,
+static int __devinit chmc_probe(struct platform_device *op,
 				const struct of_device_id *match)
 {
 	struct device_node *dp = op->dev.of_node;
@@ -765,7 +765,7 @@ out_free:
 	goto out;
 }
 
-static int __devinit us3mc_probe(struct of_device *op,
+static int __devinit us3mc_probe(struct platform_device *op,
 				const struct of_device_id *match)
 {
 	if (mc_type == MC_TYPE_SAFARI)
@@ -775,21 +775,21 @@ static int __devinit us3mc_probe(struct of_device *op,
 	return -ENODEV;
 }
 
-static void __devexit chmc_destroy(struct of_device *op, struct chmc *p)
+static void __devexit chmc_destroy(struct platform_device *op, struct chmc *p)
 {
 	list_del(&p->list);
 	of_iounmap(&op->resource[0], p->regs, 0x48);
 	kfree(p);
 }
 
-static void __devexit jbusmc_destroy(struct of_device *op, struct jbusmc *p)
+static void __devexit jbusmc_destroy(struct platform_device *op, struct jbusmc *p)
 {
 	mc_list_del(&p->list);
 	of_iounmap(&op->resource[0], p->regs, JBUSMC_REGS_SIZE);
 	kfree(p);
 }
 
-static int __devexit us3mc_remove(struct of_device *op)
+static int __devexit us3mc_remove(struct platform_device *op)
 {
 	void *p = dev_get_drvdata(&op->dev);
 
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 703e4aa..41f7e4e 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -253,7 +253,7 @@ EXPORT_SYMBOL(sbus_set_sbus64);
 static void *sbus_alloc_coherent(struct device *dev, size_t len,
 				 dma_addr_t *dma_addrp, gfp_t gfp)
 {
-	struct of_device *op = to_of_device(dev);
+	struct platform_device *op = to_platform_device(dev);
 	unsigned long len_total = (len + PAGE_SIZE-1) & PAGE_MASK;
 	unsigned long va;
 	struct resource *res;
diff --git a/arch/sparc/kernel/of_device_32.c b/arch/sparc/kernel/of_device_32.c
index 75fc9d5..2d055a1 100644
--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -241,10 +241,10 @@ static int __init use_1to1_mapping(struct device_node *pp)
 
 static int of_resource_verbose;
 
-static void __init build_device_resources(struct of_device *op,
+static void __init build_device_resources(struct platform_device *op,
 					  struct device *parent)
 {
-	struct of_device *p_op;
+	struct platform_device *p_op;
 	struct of_bus *bus;
 	int na, ns;
 	int index, num_reg;
@@ -253,7 +253,7 @@ static void __init build_device_resources(struct of_device *op,
 	if (!parent)
 		return;
 
-	p_op = to_of_device(parent);
+	p_op = to_platform_device(parent);
 	bus = of_match_bus(p_op->dev.of_node);
 	bus->count_cells(op->dev.of_node, &na, &ns);
 
@@ -335,10 +335,10 @@ static void __init build_device_resources(struct of_device *op,
 	}
 }
 
-static struct of_device * __init scan_one_device(struct device_node *dp,
+static struct platform_device * __init scan_one_device(struct device_node *dp,
 						 struct device *parent)
 {
-	struct of_device *op = kzalloc(sizeof(*op), GFP_KERNEL);
+	struct platform_device *op = kzalloc(sizeof(*op), GFP_KERNEL);
 	const struct linux_prom_irqs *intr;
 	struct dev_archdata *sd;
 	int len, i;
@@ -443,7 +443,7 @@ build_resources:
 static void __init scan_tree(struct device_node *dp, struct device *parent)
 {
 	while (dp) {
-		struct of_device *op = scan_one_device(dp, parent);
+		struct platform_device *op = scan_one_device(dp, parent);
 
 		if (op)
 			scan_tree(dp->child, &op->dev);
@@ -455,7 +455,7 @@ static void __init scan_tree(struct device_node *dp, struct device *parent)
 static int __init scan_of_devices(void)
 {
 	struct device_node *root = of_find_node_by_path("/");
-	struct of_device *parent;
+	struct platform_device *parent;
 
 	parent = scan_one_device(root, NULL);
 	if (!parent)
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 9743d1d..63cd4e5 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -310,10 +310,10 @@ static int __init use_1to1_mapping(struct device_node *pp)
 
 static int of_resource_verbose;
 
-static void __init build_device_resources(struct of_device *op,
+static void __init build_device_resources(struct platform_device *op,
 					  struct device *parent)
 {
-	struct of_device *p_op;
+	struct platform_device *p_op;
 	struct of_bus *bus;
 	int na, ns;
 	int index, num_reg;
@@ -322,7 +322,7 @@ static void __init build_device_resources(struct of_device *op,
 	if (!parent)
 		return;
 
-	p_op = to_of_device(parent);
+	p_op = to_platform_device(parent);
 	bus = of_match_bus(p_op->dev.of_node);
 	bus->count_cells(op->dev.of_node, &na, &ns);
 
@@ -528,7 +528,7 @@ static unsigned int __init pci_irq_swizzle(struct device_node *dp,
 
 static int of_irq_verbose;
 
-static unsigned int __init build_one_device_irq(struct of_device *op,
+static unsigned int __init build_one_device_irq(struct platform_device *op,
 						struct device *parent,
 						unsigned int irq)
 {
@@ -630,10 +630,10 @@ out:
 	return irq;
 }
 
-static struct of_device * __init scan_one_device(struct device_node *dp,
+static struct platform_device * __init scan_one_device(struct device_node *dp,
 						 struct device *parent)
 {
-	struct of_device *op = kzalloc(sizeof(*op), GFP_KERNEL);
+	struct platform_device *op = kzalloc(sizeof(*op), GFP_KERNEL);
 	const unsigned int *irq;
 	struct dev_archdata *sd;
 	int len, i;
@@ -686,7 +686,7 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 static void __init scan_tree(struct device_node *dp, struct device *parent)
 {
 	while (dp) {
-		struct of_device *op = scan_one_device(dp, parent);
+		struct platform_device *op = scan_one_device(dp, parent);
 
 		if (op)
 			scan_tree(dp->child, &op->dev);
@@ -698,7 +698,7 @@ static void __init scan_tree(struct device_node *dp, struct device *parent)
 static int __init scan_of_devices(void)
 {
 	struct device_node *root = of_find_node_by_path("/");
-	struct of_device *parent;
+	struct platform_device *parent;
 
 	parent = scan_one_device(root, NULL);
 	if (!parent)
diff --git a/arch/sparc/kernel/of_device_common.c b/arch/sparc/kernel/of_device_common.c
index 2a5c639..e80729b 100644
--- a/arch/sparc/kernel/of_device_common.c
+++ b/arch/sparc/kernel/of_device_common.c
@@ -13,19 +13,19 @@
 
 static int node_match(struct device *dev, void *data)
 {
-	struct of_device *op = to_of_device(dev);
+	struct platform_device *op = to_platform_device(dev);
 	struct device_node *dp = data;
 
 	return (op->dev.of_node == dp);
 }
 
-struct of_device *of_find_device_by_node(struct device_node *dp)
+struct platform_device *of_find_device_by_node(struct device_node *dp)
 {
 	struct device *dev = bus_find_device(&platform_bus_type, NULL,
 					     dp, node_match);
 
 	if (dev)
-		return to_of_device(dev);
+		return to_platform_device(dev);
 
 	return NULL;
 }
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(of_find_device_by_node);
 
 unsigned int irq_of_parse_and_map(struct device_node *node, int index)
 {
-	struct of_device *op = of_find_device_by_node(node);
+	struct platform_device *op = of_find_device_by_node(node);
 
 	if (!op || index >= op->archdata.num_irqs)
 		return 0;
@@ -43,16 +43,16 @@ unsigned int irq_of_parse_and_map(struct device_node *node, int index)
 EXPORT_SYMBOL(irq_of_parse_and_map);
 
 /* Take the archdata values for IOMMU, STC, and HOSTDATA found in
- * BUS and propagate to all child of_device objects.
+ * BUS and propagate to all child platform_device objects.
  */
-void of_propagate_archdata(struct of_device *bus)
+void of_propagate_archdata(struct platform_device *bus)
 {
 	struct dev_archdata *bus_sd = &bus->dev.archdata;
 	struct device_node *bus_dp = bus->dev.of_node;
 	struct device_node *dp;
 
 	for (dp = bus_dp->child; dp; dp = dp->sibling) {
-		struct of_device *op = of_find_device_by_node(dp);
+		struct platform_device *op = of_find_device_by_node(dp);
 
 		op->dev.archdata.iommu = bus_sd->iommu;
 		op->dev.archdata.stc = bus_sd->stc;
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 1523290..4137579 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -198,7 +198,7 @@ static unsigned long pci_parse_of_flags(u32 addr0)
  * into physical address resources, we only have to figure out the register
  * mapping.
  */
-static void pci_parse_of_addrs(struct of_device *op,
+static void pci_parse_of_addrs(struct platform_device *op,
 			       struct device_node *node,
 			       struct pci_dev *dev)
 {
@@ -248,7 +248,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 {
 	struct dev_archdata *sd;
 	struct pci_slot *slot;
-	struct of_device *op;
+	struct platform_device *op;
 	struct pci_dev *dev;
 	const char *type;
 	u32 class;
diff --git a/arch/sparc/kernel/pci_fire.c b/arch/sparc/kernel/pci_fire.c
index 885f10b..efb896d 100644
--- a/arch/sparc/kernel/pci_fire.c
+++ b/arch/sparc/kernel/pci_fire.c
@@ -410,7 +410,7 @@ static void pci_fire_hw_init(struct pci_pbm_info *pbm)
 }
 
 static int __devinit pci_fire_pbm_init(struct pci_pbm_info *pbm,
-				       struct of_device *op, u32 portid)
+				       struct platform_device *op, u32 portid)
 {
 	const struct linux_prom64_registers *regs;
 	struct device_node *dp = op->dev.of_node;
@@ -455,7 +455,7 @@ static int __devinit pci_fire_pbm_init(struct pci_pbm_info *pbm,
 	return 0;
 }
 
-static int __devinit fire_probe(struct of_device *op,
+static int __devinit fire_probe(struct platform_device *op,
 				const struct of_device_id *match)
 {
 	struct device_node *dp = op->dev.of_node;
diff --git a/arch/sparc/kernel/pci_impl.h b/arch/sparc/kernel/pci_impl.h
index 0318682..e20ed5f 100644
--- a/arch/sparc/kernel/pci_impl.h
+++ b/arch/sparc/kernel/pci_impl.h
@@ -91,7 +91,7 @@ struct pci_pbm_info {
 	char				*name;
 
 	/* OBP specific information. */
-	struct of_device		*op;
+	struct platform_device		*op;
 	u64				ino_bitmap;
 
 	/* PBM I/O and Memory space resources. */
diff --git a/arch/sparc/kernel/pci_psycho.c b/arch/sparc/kernel/pci_psycho.c
index 71550a7..22eab7c 100644
--- a/arch/sparc/kernel/pci_psycho.c
+++ b/arch/sparc/kernel/pci_psycho.c
@@ -285,7 +285,7 @@ static irqreturn_t psycho_ce_intr(int irq, void *dev_id)
 #define  PSYCHO_ECCCTRL_CE	 0x2000000000000000UL /* Enable CE INterrupts */
 static void psycho_register_error_handlers(struct pci_pbm_info *pbm)
 {
-	struct of_device *op = of_find_device_by_node(pbm->op->dev.of_node);
+	struct platform_device *op = of_find_device_by_node(pbm->op->dev.of_node);
 	unsigned long base = pbm->controller_regs;
 	u64 tmp;
 	int err;
@@ -483,7 +483,7 @@ static void psycho_pbm_strbuf_init(struct pci_pbm_info *pbm,
 #define PSYCHO_MEMSPACE_SIZE	0x07fffffffUL
 
 static void __devinit psycho_pbm_init(struct pci_pbm_info *pbm,
-				      struct of_device *op, int is_pbm_a)
+				      struct platform_device *op, int is_pbm_a)
 {
 	psycho_pbm_init_common(pbm, op, "PSYCHO", PBM_CHIP_TYPE_PSYCHO);
 	psycho_pbm_strbuf_init(pbm, is_pbm_a);
@@ -503,7 +503,7 @@ static struct pci_pbm_info * __devinit psycho_find_sibling(u32 upa_portid)
 
 #define PSYCHO_CONFIGSPACE	0x001000000UL
 
-static int __devinit psycho_probe(struct of_device *op,
+static int __devinit psycho_probe(struct platform_device *op,
 				  const struct of_device_id *match)
 {
 	const struct linux_prom64_registers *pr_regs;
diff --git a/arch/sparc/kernel/pci_sabre.c b/arch/sparc/kernel/pci_sabre.c
index 2d7bf30..5c3f5ec 100644
--- a/arch/sparc/kernel/pci_sabre.c
+++ b/arch/sparc/kernel/pci_sabre.c
@@ -311,7 +311,7 @@ static irqreturn_t sabre_ce_intr(int irq, void *dev_id)
 static void sabre_register_error_handlers(struct pci_pbm_info *pbm)
 {
 	struct device_node *dp = pbm->op->dev.of_node;
-	struct of_device *op;
+	struct platform_device *op;
 	unsigned long base = pbm->controller_regs;
 	u64 tmp;
 	int err;
@@ -443,7 +443,7 @@ static void __devinit sabre_scan_bus(struct pci_pbm_info *pbm,
 }
 
 static void __devinit sabre_pbm_init(struct pci_pbm_info *pbm,
-				     struct of_device *op)
+				     struct platform_device *op)
 {
 	psycho_pbm_init_common(pbm, op, "SABRE", PBM_CHIP_TYPE_SABRE);
 	pbm->pci_afsr = pbm->controller_regs + SABRE_PIOAFSR;
@@ -452,7 +452,7 @@ static void __devinit sabre_pbm_init(struct pci_pbm_info *pbm,
 	sabre_scan_bus(pbm, &op->dev);
 }
 
-static int __devinit sabre_probe(struct of_device *op,
+static int __devinit sabre_probe(struct platform_device *op,
 				 const struct of_device_id *match)
 {
 	const struct linux_prom64_registers *pr_regs;
diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index 04f29c4..445a47a 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -844,7 +844,7 @@ static int pbm_routes_this_ino(struct pci_pbm_info *pbm, u32 ino)
  */
 static void tomatillo_register_error_handlers(struct pci_pbm_info *pbm)
 {
-	struct of_device *op = of_find_device_by_node(pbm->op->dev.of_node);
+	struct platform_device *op = of_find_device_by_node(pbm->op->dev.of_node);
 	u64 tmp, err_mask, err_no_mask;
 	int err;
 
@@ -939,7 +939,7 @@ static void tomatillo_register_error_handlers(struct pci_pbm_info *pbm)
 
 static void schizo_register_error_handlers(struct pci_pbm_info *pbm)
 {
-	struct of_device *op = of_find_device_by_node(pbm->op->dev.of_node);
+	struct platform_device *op = of_find_device_by_node(pbm->op->dev.of_node);
 	u64 tmp, err_mask, err_no_mask;
 	int err;
 
@@ -1307,7 +1307,7 @@ static void schizo_pbm_hw_init(struct pci_pbm_info *pbm)
 }
 
 static int __devinit schizo_pbm_init(struct pci_pbm_info *pbm,
-				     struct of_device *op, u32 portid,
+				     struct platform_device *op, u32 portid,
 				     int chip_type)
 {
 	const struct linux_prom64_registers *regs;
@@ -1413,7 +1413,7 @@ static struct pci_pbm_info * __devinit schizo_find_sibling(u32 portid,
 	return NULL;
 }
 
-static int __devinit __schizo_init(struct of_device *op, unsigned long chip_type)
+static int __devinit __schizo_init(struct platform_device *op, unsigned long chip_type)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct pci_pbm_info *pbm;
@@ -1460,7 +1460,7 @@ out_err:
 	return err;
 }
 
-static int __devinit schizo_probe(struct of_device *op,
+static int __devinit schizo_probe(struct platform_device *op,
 				  const struct of_device_id *match)
 {
 	return __schizo_init(op, (unsigned long) match->data);
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 18ee8b6..743344a 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -879,7 +879,7 @@ static void pci_sun4v_msi_init(struct pci_pbm_info *pbm)
 #endif /* !(CONFIG_PCI_MSI) */
 
 static int __devinit pci_sun4v_pbm_init(struct pci_pbm_info *pbm,
-					struct of_device *op, u32 devhandle)
+					struct platform_device *op, u32 devhandle)
 {
 	struct device_node *dp = op->dev.of_node;
 	int err;
@@ -918,7 +918,7 @@ static int __devinit pci_sun4v_pbm_init(struct pci_pbm_info *pbm,
 	return 0;
 }
 
-static int __devinit pci_sun4v_probe(struct of_device *op,
+static int __devinit pci_sun4v_probe(struct platform_device *op,
 				     const struct of_device_id *match)
 {
 	const struct linux_prom64_registers *regs;
diff --git a/arch/sparc/kernel/pmc.c b/arch/sparc/kernel/pmc.c
index a4c73ed..94536a8 100644
--- a/arch/sparc/kernel/pmc.c
+++ b/arch/sparc/kernel/pmc.c
@@ -51,7 +51,7 @@ static void pmc_swift_idle(void)
 #endif
 }
 
-static int __devinit pmc_probe(struct of_device *op,
+static int __devinit pmc_probe(struct platform_device *op,
 			       const struct of_device_id *match)
 {
 	regs = of_ioremap(&op->resource[0], 0,
diff --git a/arch/sparc/kernel/power.c b/arch/sparc/kernel/power.c
index abc194e..2c59f4d 100644
--- a/arch/sparc/kernel/power.c
+++ b/arch/sparc/kernel/power.c
@@ -33,7 +33,7 @@ static int __devinit has_button_interrupt(unsigned int irq, struct device_node *
 	return 1;
 }
 
-static int __devinit power_probe(struct of_device *op, const struct of_device_id *match)
+static int __devinit power_probe(struct platform_device *op, const struct of_device_id *match)
 {
 	struct resource *res = &op->resource[0];
 	unsigned int irq = op->archdata.irqs[0];
diff --git a/arch/sparc/kernel/prom_irqtrans.c b/arch/sparc/kernel/prom_irqtrans.c
index 5702ad4..ce65114 100644
--- a/arch/sparc/kernel/prom_irqtrans.c
+++ b/arch/sparc/kernel/prom_irqtrans.c
@@ -719,7 +719,7 @@ static unsigned int central_build_irq(struct device_node *dp,
 				      void *_data)
 {
 	struct device_node *central_dp = _data;
-	struct of_device *central_op = of_find_device_by_node(central_dp);
+	struct platform_device *central_op = of_find_device_by_node(central_dp);
 	struct resource *res;
 	unsigned long imap, iclr;
 	u32 tmp;
diff --git a/arch/sparc/kernel/psycho_common.c b/arch/sparc/kernel/psycho_common.c
index 3f34ac8..fe2af66 100644
--- a/arch/sparc/kernel/psycho_common.c
+++ b/arch/sparc/kernel/psycho_common.c
@@ -447,7 +447,7 @@ int psycho_iommu_init(struct pci_pbm_info *pbm, int tsbsize,
 
 }
 
-void psycho_pbm_init_common(struct pci_pbm_info *pbm, struct of_device *op,
+void psycho_pbm_init_common(struct pci_pbm_info *pbm, struct platform_device *op,
 			    const char *chip_name, int chip_type)
 {
 	struct device_node *dp = op->dev.of_node;
diff --git a/arch/sparc/kernel/psycho_common.h b/arch/sparc/kernel/psycho_common.h
index 092c278..590b4ed 100644
--- a/arch/sparc/kernel/psycho_common.h
+++ b/arch/sparc/kernel/psycho_common.h
@@ -42,7 +42,7 @@ extern int psycho_iommu_init(struct pci_pbm_info *pbm, int tsbsize,
 			     unsigned long write_complete_offset);
 
 extern void psycho_pbm_init_common(struct pci_pbm_info *pbm,
-				   struct of_device *op,
+				   struct platform_device *op,
 				   const char *chip_name, int chip_type);
 
 #endif /* _PSYCHO_COMMON_H */
diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
index cfeaf04..2ca32d1 100644
--- a/arch/sparc/kernel/sbus.c
+++ b/arch/sparc/kernel/sbus.c
@@ -57,7 +57,7 @@
 void sbus_set_sbus64(struct device *dev, int bursts)
 {
 	struct iommu *iommu = dev->archdata.iommu;
-	struct of_device *op = to_of_device(dev);
+	struct platform_device *op = to_platform_device(dev);
 	const struct linux_prom_registers *regs;
 	unsigned long cfg_reg;
 	int slot;
@@ -204,7 +204,7 @@ static unsigned long sysio_imap_to_iclr(unsigned long imap)
 	return imap + diff;
 }
 
-static unsigned int sbus_build_irq(struct of_device *op, unsigned int ino)
+static unsigned int sbus_build_irq(struct platform_device *op, unsigned int ino)
 {
 	struct iommu *iommu = op->dev.archdata.iommu;
 	unsigned long reg_base = iommu->write_complete_reg - 0x2000UL;
@@ -267,7 +267,7 @@ static unsigned int sbus_build_irq(struct of_device *op, unsigned int ino)
 #define  SYSIO_UEAFSR_RESV2 0x0000001fffffffffUL /* Reserved                  */
 static irqreturn_t sysio_ue_handler(int irq, void *dev_id)
 {
-	struct of_device *op = dev_id;
+	struct platform_device *op = dev_id;
 	struct iommu *iommu = op->dev.archdata.iommu;
 	unsigned long reg_base = iommu->write_complete_reg - 0x2000UL;
 	unsigned long afsr_reg, afar_reg;
@@ -341,7 +341,7 @@ static irqreturn_t sysio_ue_handler(int irq, void *dev_id)
 #define  SYSIO_CEAFSR_RESV2 0x0000001fffffffffUL /* Reserved                  */
 static irqreturn_t sysio_ce_handler(int irq, void *dev_id)
 {
-	struct of_device *op = dev_id;
+	struct platform_device *op = dev_id;
 	struct iommu *iommu = op->dev.archdata.iommu;
 	unsigned long reg_base = iommu->write_complete_reg - 0x2000UL;
 	unsigned long afsr_reg, afar_reg;
@@ -420,7 +420,7 @@ static irqreturn_t sysio_ce_handler(int irq, void *dev_id)
 #define  SYSIO_SBAFSR_RESV3 0x0000001fffffffffUL /* Reserved                  */
 static irqreturn_t sysio_sbus_error_handler(int irq, void *dev_id)
 {
-	struct of_device *op = dev_id;
+	struct platform_device *op = dev_id;
 	struct iommu *iommu = op->dev.archdata.iommu;
 	unsigned long afsr_reg, afar_reg, reg_base;
 	unsigned long afsr, afar, error_bits;
@@ -488,7 +488,7 @@ static irqreturn_t sysio_sbus_error_handler(int irq, void *dev_id)
 #define SYSIO_CE_INO		0x35
 #define SYSIO_SBUSERR_INO	0x36
 
-static void __init sysio_register_error_handlers(struct of_device *op)
+static void __init sysio_register_error_handlers(struct platform_device *op)
 {
 	struct iommu *iommu = op->dev.archdata.iommu;
 	unsigned long reg_base = iommu->write_complete_reg - 0x2000UL;
@@ -534,7 +534,7 @@ static void __init sysio_register_error_handlers(struct of_device *op)
 }
 
 /* Boot time initialization. */
-static void __init sbus_iommu_init(struct of_device *op)
+static void __init sbus_iommu_init(struct platform_device *op)
 {
 	const struct linux_prom64_registers *pr;
 	struct device_node *dp = op->dev.of_node;
@@ -663,7 +663,7 @@ static int __init sbus_init(void)
 	struct device_node *dp;
 
 	for_each_node_by_name(dp, "sbus") {
-		struct of_device *op = of_find_device_by_node(dp);
+		struct platform_device *op = of_find_device_by_node(dp);
 
 		sbus_iommu_init(op);
 		of_propagate_archdata(op);
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 5dc2021..9c743b1 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -142,7 +142,7 @@ static struct platform_device m48t59_rtc = {
 	},
 };
 
-static int __devinit clock_probe(struct of_device *op, const struct of_device_id *match)
+static int __devinit clock_probe(struct platform_device *op, const struct of_device_id *match)
 {
 	struct device_node *dp = op->dev.of_node;
 	const char *model = of_get_property(dp, "model", NULL);
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 2423b33..3bc9c99 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -419,7 +419,7 @@ static struct platform_device rtc_cmos_device = {
 	.num_resources	= 1,
 };
 
-static int __devinit rtc_probe(struct of_device *op, const struct of_device_id *match)
+static int __devinit rtc_probe(struct platform_device *op, const struct of_device_id *match)
 {
 	struct resource *r;
 
@@ -477,7 +477,7 @@ static struct platform_device rtc_bq4802_device = {
 	.num_resources	= 1,
 };
 
-static int __devinit bq4802_probe(struct of_device *op, const struct of_device_id *match)
+static int __devinit bq4802_probe(struct platform_device *op, const struct of_device_id *match)
 {
 
 	printk(KERN_INFO "%s: BQ4802 regs at 0x%llx\n",
@@ -534,7 +534,7 @@ static struct platform_device m48t59_rtc = {
 	},
 };
 
-static int __devinit mostek_probe(struct of_device *op, const struct of_device_id *match)
+static int __devinit mostek_probe(struct platform_device *op, const struct of_device_id *match)
 {
 	struct device_node *dp = op->dev.of_node;
 
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index 005e758..fc58c3e 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -35,7 +35,7 @@
 #define IOPERM        (IOUPTE_CACHE | IOUPTE_WRITE | IOUPTE_VALID)
 #define MKIOPTE(phys) __iopte((((phys)>>4) & IOUPTE_PAGE) | IOPERM)
 
-static void __init iounit_iommu_init(struct of_device *op)
+static void __init iounit_iommu_init(struct platform_device *op)
 {
 	struct iounit_struct *iounit;
 	iopte_t *xpt, *xptend;
@@ -74,7 +74,7 @@ static int __init iounit_init(void)
 	struct device_node *dp;
 
 	for_each_node_by_name(dp, "sbi") {
-		struct of_device *op = of_find_device_by_node(dp);
+		struct platform_device *op = of_find_device_by_node(dp);
 
 		iounit_iommu_init(op);
 		of_propagate_archdata(op);
diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index b2e6e73..7385806 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -56,7 +56,7 @@ static pgprot_t dvma_prot;		/* Consistent mapping pte flags */
 #define IOPERM        (IOPTE_CACHE | IOPTE_WRITE | IOPTE_VALID)
 #define MKIOPTE(pfn, perm) (((((pfn)<<8) & IOPTE_PAGE) | (perm)) & ~IOPTE_WAZ)
 
-static void __init sbus_iommu_init(struct of_device *op)
+static void __init sbus_iommu_init(struct platform_device *op)
 {
 	struct iommu_struct *iommu;
 	unsigned int impl, vers;
@@ -132,7 +132,7 @@ static int __init iommu_init(void)
 	struct device_node *dp;
 
 	for_each_node_by_name(dp, "iommu") {
-		struct of_device *op = of_find_device_by_node(dp);
+		struct platform_device *op = of_find_device_by_node(dp);
 
 		sbus_iommu_init(op);
 		of_propagate_archdata(op);

