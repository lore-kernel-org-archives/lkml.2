Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2AKUXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:23:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41455 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933643Ab2AKUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:22:54 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC 11/14] powerpc: Eliminate NO_IRQ usage
Date: Wed, 11 Jan 2012 13:22:14 -0700
Message-Id: <1326313337-24603-12-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NO_IRQ is evil.  Stop using it in arch/powerpc and powerpc device drivers

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/machdep.h               |    2 +-
 arch/powerpc/include/asm/parport.h               |    2 +-
 arch/powerpc/include/asm/qe_ic.h                 |   12 ++++++------
 arch/powerpc/kernel/ibmebus.c                    |    2 +-
 arch/powerpc/kernel/irq.c                        |    2 +-
 arch/powerpc/kernel/legacy_serial.c              |   14 +++++++-------
 arch/powerpc/kernel/pci-common.c                 |    4 ++--
 arch/powerpc/kernel/pci_of_scan.c                |    2 +-
 arch/powerpc/platforms/44x/warp.c                |    2 +-
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    8 ++++----
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |    2 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    2 +-
 arch/powerpc/platforms/83xx/mpc832x_rdb.c        |    2 +-
 arch/powerpc/platforms/83xx/suspend.c            |    4 ++--
 arch/powerpc/platforms/85xx/common.c             |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c        |    4 ++--
 arch/powerpc/platforms/85xx/mpc85xx_ds.c         |    4 ++--
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |    7 +++----
 arch/powerpc/platforms/86xx/gef_pic.c            |    8 ++++----
 arch/powerpc/platforms/86xx/pic.c                |    4 ++--
 arch/powerpc/platforms/8xx/m8xx_setup.c          |    2 +-
 arch/powerpc/platforms/cell/axon_msi.c           |    6 +++---
 arch/powerpc/platforms/cell/beat.c               |    2 +-
 arch/powerpc/platforms/cell/beat_interrupt.c     |    4 ++--
 arch/powerpc/platforms/cell/interrupt.c          |   12 ++++++------
 arch/powerpc/platforms/cell/iommu.c              |    2 +-
 arch/powerpc/platforms/cell/pmu.c                |    4 ++--
 arch/powerpc/platforms/cell/spider-pic.c         |   20 ++++++++++----------
 arch/powerpc/platforms/cell/spu_base.c           |   16 ++++++++--------
 arch/powerpc/platforms/cell/spu_manage.c         |    6 +++---
 arch/powerpc/platforms/chrp/setup.c              |    4 ++--
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |    2 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    4 ++--
 arch/powerpc/platforms/maple/pci.c               |    6 +++---
 arch/powerpc/platforms/pasemi/misc.c             |    2 +-
 arch/powerpc/platforms/pasemi/setup.c            |    4 ++--
 arch/powerpc/platforms/powermac/low_i2c.c        |    6 +++---
 arch/powerpc/platforms/powermac/pfunc_base.c     |    4 ++--
 arch/powerpc/platforms/powermac/pic.c            |    6 +++---
 arch/powerpc/platforms/powernv/opal.c            |    2 +-
 arch/powerpc/platforms/powernv/pci.c             |    4 ++--
 arch/powerpc/platforms/ps3/interrupt.c           |   10 +++++-----
 arch/powerpc/platforms/ps3/smp.c                 |    4 ++--
 arch/powerpc/platforms/ps3/spu.c                 |    4 ++--
 arch/powerpc/platforms/pseries/event_sources.c   |    4 ++--
 arch/powerpc/platforms/pseries/msi.c             |    7 +++----
 arch/powerpc/platforms/pseries/setup.c           |    4 ++--
 arch/powerpc/platforms/wsp/msi.c                 |    4 ++--
 arch/powerpc/sysdev/axonram.c                    |    6 +++---
 arch/powerpc/sysdev/bestcomm/bestcomm.c          |    4 ++--
 arch/powerpc/sysdev/cpm1.c                       |    8 ++++----
 arch/powerpc/sysdev/ehv_pic.c                    |    4 ++--
 arch/powerpc/sysdev/fsl_gtm.c                    |    2 +-
 arch/powerpc/sysdev/fsl_ifc.c                    |    4 ++--
 arch/powerpc/sysdev/fsl_lbc.c                    |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                    |   13 ++++++-------
 arch/powerpc/sysdev/i8259.c                      |    4 ++--
 arch/powerpc/sysdev/ipic.c                       |    4 ++--
 arch/powerpc/sysdev/mpc8xx_pic.c                 |    2 +-
 arch/powerpc/sysdev/mpic.c                       |   14 +++++++-------
 arch/powerpc/sysdev/mpic_pasemi_msi.c            |    4 ++--
 arch/powerpc/sysdev/mpic_u3msi.c                 |    4 ++--
 arch/powerpc/sysdev/mv64x60_pic.c                |    2 +-
 arch/powerpc/sysdev/pmi.c                        |    2 +-
 arch/powerpc/sysdev/ppc4xx_msi.c                 |    6 +++---
 arch/powerpc/sysdev/ppc4xx_soc.c                 |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |   13 ++++++-------
 arch/powerpc/sysdev/tsi108_pci.c                 |    2 +-
 arch/powerpc/sysdev/uic.c                        |    2 +-
 arch/powerpc/sysdev/xics/icp-hv.c                |    6 +++---
 arch/powerpc/sysdev/xics/icp-native.c            |    6 +++---
 arch/powerpc/sysdev/xics/xics-common.c           |    2 +-
 drivers/ata/pata_mpc52xx.c                       |    2 +-
 drivers/dma/fsldma.c                             |   15 ++++++---------
 drivers/dma/mpc512x_dma.c                        |    4 ++--
 drivers/dma/ppc4xx/adma.c                        |    4 ++--
 drivers/edac/mpc85xx_edac.c                      |    6 +++---
 drivers/edac/ppc4xx_edac.c                       |    6 +++---
 drivers/macintosh/macio_asic.c                   |    4 ++--
 drivers/macintosh/rack-meter.c                   |    2 +-
 drivers/macintosh/smu.c                          |   18 +++++++++---------
 drivers/macintosh/via-cuda.c                     |    2 +-
 drivers/macintosh/via-pmu.c                      |    6 +++---
 drivers/mmc/host/of_mmc_spi.c                    |    7 +------
 drivers/mtd/nand/mpc5121_nfc.c                   |    2 +-
 drivers/net/can/sja1000/sja1000_of_platform.c    |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c |    2 +-
 drivers/net/ethernet/freescale/gianfar.c         |    6 +++---
 drivers/net/ethernet/freescale/gianfar_ptp.c     |    2 +-
 drivers/net/ethernet/ibm/emac/core.c             |   10 +++++-----
 drivers/net/ethernet/ibm/emac/mal.c              |    5 ++---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c     |    4 ++--
 drivers/ps3/ps3-vuart.c                          |    4 ++--
 drivers/tty/serial/cpm_uart/cpm_uart_core.c      |    2 +-
 drivers/tty/serial/mpc52xx_uart.c                |    4 ++--
 drivers/tty/serial/pmac_zilog.c                  |    3 +--
 drivers/tty/serial/ucc_uart.c                    |    2 +-
 drivers/usb/host/ehci-xilinx-of.c                |    2 +-
 drivers/usb/host/ohci-ppc-of.c                   |    2 +-
 drivers/virt/fsl_hypervisor.c                    |    2 +-
 sound/aoa/core/gpio-feature.c                    |    5 +----
 sound/ppc/tumbler.c                              |    8 ++++----
 sound/soc/fsl/fsl_ssi.c                          |    2 +-
 105 files changed, 247 insertions(+), 264 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index bf37931..d15a45f 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -99,7 +99,7 @@ struct machdep_calls {
 
 	void		(*init_IRQ)(void);
 
-	/* Return an irq, or NO_IRQ to indicate there are none pending.
+	/* Return an irq, or 0 to indicate there are none pending.
 	 * If for some reason there is no irq, but the interrupt
 	 * shouldn't be counted as spurious, return NO_IRQ_IGNORE. */
 	unsigned int	(*get_irq)(void);
diff --git a/arch/powerpc/include/asm/parport.h b/arch/powerpc/include/asm/parport.h
index 1ca1102..c25b94d 100644
--- a/arch/powerpc/include/asm/parport.h
+++ b/arch/powerpc/include/asm/parport.h
@@ -30,7 +30,7 @@ static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
 		io1 = prop[1]; io2 = prop[2];
 
 		virq = irq_of_parse_and_map(np, 0);
-		if (virq == NO_IRQ)
+		if (!virq)
 			continue;
 
 		if (parport_pc_probe_port(io1, io2, virq, autodma, NULL, 0)
diff --git a/arch/powerpc/include/asm/qe_ic.h b/arch/powerpc/include/asm/qe_ic.h
index f706164..20fe6fe 100644
--- a/arch/powerpc/include/asm/qe_ic.h
+++ b/arch/powerpc/include/asm/qe_ic.h
@@ -84,7 +84,7 @@ static inline void qe_ic_cascade_low_ipic(unsigned int irq,
 	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_low_irq(qe_ic);
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 }
 
@@ -94,7 +94,7 @@ static inline void qe_ic_cascade_high_ipic(unsigned int irq,
 	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_high_irq(qe_ic);
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 }
 
@@ -105,7 +105,7 @@ static inline void qe_ic_cascade_low_mpic(unsigned int irq,
 	unsigned int cascade_irq = qe_ic_get_low_irq(qe_ic);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 
 	chip->irq_eoi(&desc->irq_data);
@@ -118,7 +118,7 @@ static inline void qe_ic_cascade_high_mpic(unsigned int irq,
 	unsigned int cascade_irq = qe_ic_get_high_irq(qe_ic);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 
 	chip->irq_eoi(&desc->irq_data);
@@ -132,10 +132,10 @@ static inline void qe_ic_cascade_muxed_mpic(unsigned int irq,
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	cascade_irq = qe_ic_get_high_irq(qe_ic);
-	if (cascade_irq == NO_IRQ)
+	if (!cascade_irq)
 		cascade_irq = qe_ic_get_low_irq(qe_ic);
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 
 	chip->irq_eoi(&desc->irq_data);
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index d39ae60..268e4a8 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -226,7 +226,7 @@ int ibmebus_request_irq(u32 ist, irq_handler_t handler,
 {
 	unsigned int irq = irq_create_mapping(NULL, ist);
 
-	if (irq == NO_IRQ)
+	if (!irq)
 		return -EINVAL;
 
 	return request_irq(irq, handler, irq_flags, devname, dev_id);
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index e3673ff..0cf5a0e 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -362,7 +362,7 @@ void do_IRQ(struct pt_regs *regs)
 
 	irq = ppc_md.get_irq();
 
-	if (irq != NO_IRQ && irq != NO_IRQ_IGNORE)
+	if (irq && irq != NO_IRQ_IGNORE)
 		handle_one_irq(irq);
 	else if (irq != NO_IRQ_IGNORE)
 		__get_cpu_var(irq_stat).spurious_irqs++;
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 3fea368..cddda43 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -185,9 +185,9 @@ static int __init add_legacy_soc_port(struct device_node *np,
 	 * IO port value. It will be fixed up later along with the irq
 	 */
 	if (tsi && !strcmp(tsi->type, "tsi-bridge"))
-		return add_legacy_port(np, -1, UPIO_TSI, addr, addr, NO_IRQ, flags, 0);
+		return add_legacy_port(np, -1, UPIO_TSI, addr, addr, 0, flags, 0);
 	else
-		return add_legacy_port(np, -1, UPIO_MEM, addr, addr, NO_IRQ, flags, 0);
+		return add_legacy_port(np, -1, UPIO_MEM, addr, addr, 0, flags, 0);
 }
 
 static int __init add_legacy_isa_port(struct device_node *np,
@@ -228,7 +228,7 @@ static int __init add_legacy_isa_port(struct device_node *np,
 
 	/* Add port, irq will be dealt with later */
 	return add_legacy_port(np, index, UPIO_PORT, be32_to_cpu(reg[1]), taddr,
-			       NO_IRQ, UPF_BOOT_AUTOCONF, 0);
+			       0, UPF_BOOT_AUTOCONF, 0);
 
 }
 
@@ -300,7 +300,7 @@ static int __init add_legacy_pci_port(struct device_node *np,
 	/* Add port, irq will be dealt with later. We passed a translated
 	 * IO port value. It will be fixed up later along with the irq
 	 */
-	return add_legacy_port(np, index, iotype, base, addr, NO_IRQ,
+	return add_legacy_port(np, index, iotype, base, addr, 0,
 			       UPF_BOOT_AUTOCONF, np != pci_dev);
 }
 #endif
@@ -430,14 +430,14 @@ static void __init fixup_port_irq(int index,
 	DBG("fixup_port_irq(%d)\n", index);
 
 	virq = irq_of_parse_and_map(np, 0);
-	if (virq == NO_IRQ && legacy_serial_infos[index].irq_check_parent) {
+	if (!virq && legacy_serial_infos[index].irq_check_parent) {
 		np = of_get_parent(np);
 		if (np == NULL)
 			return;
 		virq = irq_of_parse_and_map(np, 0);
 		of_node_put(np);
 	}
-	if (virq == NO_IRQ)
+	if (!virq)
 		return;
 
 	port->irq = virq;
@@ -509,7 +509,7 @@ static int __init serial_dev_init(void)
 		struct plat_serial8250_port *port = &legacy_serial_ports[i];
 		struct device_node *np = legacy_serial_infos[i].np;
 
-		if (port->irq == NO_IRQ)
+		if (!port->irq)
 			fixup_port_irq(i, np, port);
 		if (port->iotype == UPIO_PORT)
 			fixup_port_pio(i, np, port);
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index cce98d7..0625525 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -261,7 +261,7 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
 			 line, pin);
 
 		virq = irq_create_mapping(NULL, line);
-		if (virq != NO_IRQ)
+		if (virq)
 			irq_set_irq_type(virq, IRQ_TYPE_LEVEL_LOW);
 	} else {
 		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
@@ -272,7 +272,7 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
 		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
 					     oirq.size);
 	}
-	if(virq == NO_IRQ) {
+	if(!virq) {
 		pr_debug(" Failed to map !\n");
 		return -1;
 	}
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index b37d0b5..adbc17e 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -181,7 +181,7 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
 		dev->hdr_type = PCI_HEADER_TYPE_NORMAL;
 		dev->rom_base_reg = PCI_ROM_ADDRESS;
 		/* Maybe do a default OF mapping here */
-		dev->irq = NO_IRQ;
+		dev->irq = 0;
 	}
 
 	of_pci_parse_addrs(node, dev);
diff --git a/arch/powerpc/platforms/44x/warp.c b/arch/powerpc/platforms/44x/warp.c
index 4cfa499..ec43889 100644
--- a/arch/powerpc/platforms/44x/warp.c
+++ b/arch/powerpc/platforms/44x/warp.c
@@ -206,7 +206,7 @@ static void pika_setup_critical_temp(struct device_node *np,
 	i2c_smbus_write_byte_data(client, 3,  0); /* Tlow */
 
 	irq = irq_of_parse_and_map(np, 0);
-	if (irq  == NO_IRQ) {
+	if (!irq) {
 		printk(KERN_ERR __FILE__ ": Unable to get ad7414 irq\n");
 		return;
 	}
diff --git a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
index 2301f7e..8433b71 100644
--- a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
+++ b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
@@ -97,7 +97,7 @@ cpld_pic_get_irq(int offset, u8 ignore, u8 __iomem *statusp,
 	status |= (ignore | mask);
 
 	if (status == 0xff)
-		return NO_IRQ;
+		return 0;
 
 	cpld_irq = ffz(status) + offset;
 
@@ -109,14 +109,14 @@ cpld_pic_cascade(unsigned int irq, struct irq_desc *desc)
 {
 	irq = cpld_pic_get_irq(0, PCI_IGNORE, &cpld_regs->pci_status,
 		&cpld_regs->pci_mask);
-	if (irq != NO_IRQ) {
+	if (irq) {
 		generic_handle_irq(irq);
 		return;
 	}
 
 	irq = cpld_pic_get_irq(8, MISC_IGNORE, &cpld_regs->misc_status,
 		&cpld_regs->misc_mask);
-	if (irq != NO_IRQ) {
+	if (irq) {
 		generic_handle_irq(irq);
 		return;
 	}
@@ -175,7 +175,7 @@ mpc5121_ads_cpld_pic_init(void)
 		goto end;
 
 	cascade_irq = irq_of_parse_and_map(np, 0);
-	if (cascade_irq == NO_IRQ)
+	if (!cascade_irq)
 		goto end;
 
 	/*
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index 844405c..98ba620 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -510,7 +510,7 @@ unsigned int mpc52xx_get_irq(void)
 			irq |= (MPC52xx_IRQ_L1_PERP << MPC52xx_IRQ_L1_OFFSET);
 		}
 	} else {
-		return NO_IRQ;
+		return 0;
 	}
 
 	return irq_linear_revmap(mpc52xx_irqhost, irq);
diff --git a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
index 80c9312..9a6ffec 100644
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -132,7 +132,7 @@ int __init pq2ads_pci_init_irq(void)
 	}
 
 	irq = irq_of_parse_and_map(np, 0);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		printk(KERN_ERR "No interrupt in pci pic node.\n");
 		of_node_put(np);
 		goto out;
diff --git a/arch/powerpc/platforms/83xx/mpc832x_rdb.c b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
index eff5baa..bd9b28a 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -89,7 +89,7 @@ static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
 			goto err;
 
 		ret = of_irq_to_resource(np, 0, &res[1]);
-		if (ret == NO_IRQ)
+		if (!ret)
 			goto err;
 
 		pdev = platform_device_alloc("mpc83xx_spi", i);
diff --git a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
index edf6687..8629e41 100644
--- a/arch/powerpc/platforms/83xx/suspend.c
+++ b/arch/powerpc/platforms/83xx/suspend.c
@@ -350,7 +350,7 @@ static int pmc_probe(struct platform_device *ofdev)
 		return -ENODEV;
 
 	pmc_irq = irq_of_parse_and_map(np, 0);
-	if (pmc_irq != NO_IRQ) {
+	if (pmc_irq) {
 		ret = request_irq(pmc_irq, pmc_irq_handler, IRQF_SHARED,
 		                  "pmc", ofdev);
 
@@ -398,7 +398,7 @@ out_syscr:
 out_pmc:
 	iounmap(pmc_regs);
 out:
-	if (pmc_irq != NO_IRQ)
+	if (pmc_irq)
 		free_irq(pmc_irq, ofdev);
 
 	return ret;
diff --git a/arch/powerpc/platforms/85xx/common.c b/arch/powerpc/platforms/85xx/common.c
index 9fef530..bdc1291 100644
--- a/arch/powerpc/platforms/85xx/common.c
+++ b/arch/powerpc/platforms/85xx/common.c
@@ -53,7 +53,7 @@ void __init mpc85xx_cpm2_pic_init(void)
 		return;
 	}
 	irq = irq_of_parse_and_map(np, 0);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		of_node_put(np);
 		printk(KERN_ERR "PIC init: got no IRQ for cpm cascade\n");
 		return;
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 40f03da..b4b11c7 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -164,7 +164,7 @@ static void mpc85xx_8259_cascade_handler(unsigned int irq,
 {
 	unsigned int cascade_irq = i8259_irq();
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		/* handle an interrupt from the 8259 */
 		generic_handle_irq(cascade_irq);
 
@@ -216,7 +216,7 @@ static int mpc85xx_cds_8259_attach(void)
 	}
 
 	cascade_irq = irq_of_parse_and_map(cascade_node, 0);
-	if (cascade_irq == NO_IRQ) {
+	if (!cascade_irq) {
 		printk(KERN_ERR "Failed to map cascade interrupt\n");
 		return -ENXIO;
 	}
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index eefbb91..0e7f9f5 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -53,7 +53,7 @@ static void mpc85xx_8259_cascade(unsigned int irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned int cascade_irq = i8259_irq();
 
-	if (cascade_irq != NO_IRQ) {
+	if (cascade_irq) {
 		generic_handle_irq(cascade_irq);
 	}
 	chip->irq_eoi(&desc->irq_data);
@@ -100,7 +100,7 @@ void __init mpc85xx_ds_pic_init(void)
 	}
 
 	cascade_irq = irq_of_parse_and_map(cascade_node, 0);
-	if (cascade_irq == NO_IRQ) {
+	if (!cascade_irq) {
 		printk(KERN_ERR "Failed to map cascade interrupt\n");
 		return;
 	}
diff --git a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
index 655c39e..c91d693 100644
--- a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
+++ b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
@@ -76,7 +76,7 @@ static inline unsigned int socrates_fpga_pic_get_irq(unsigned int irq)
 			break;
 	}
 	if (i == 3)
-		return NO_IRQ;
+		return 0;
 
 	raw_spin_lock_irqsave(&socrates_fpga_pic_lock, flags);
 	cause = socrates_fpga_pic_read(FPGA_PIC_IRQMASK(i));
@@ -99,8 +99,7 @@ void socrates_fpga_pic_cascade(unsigned int irq, struct irq_desc *desc)
 	 * we do.
 	 */
 	cascade_irq = socrates_fpga_pic_get_irq(irq);
-
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 	chip->irq_eoi(&desc->irq_data);
 }
@@ -289,7 +288,7 @@ void socrates_fpga_pic_init(struct device_node *pic)
 
 	for (i = 0; i < 3; i++) {
 		socrates_fpga_irqs[i] = irq_of_parse_and_map(pic, i);
-		if (socrates_fpga_irqs[i] == NO_IRQ) {
+		if (!socrates_fpga_irqs[i]) {
 			pr_warning("FPGA PIC: can't get irq%d.\n", i);
 			continue;
 		}
diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/platforms/86xx/gef_pic.c
index ca6f7a2..6f5670b 100644
--- a/arch/powerpc/platforms/86xx/gef_pic.c
+++ b/arch/powerpc/platforms/86xx/gef_pic.c
@@ -102,7 +102,7 @@ void gef_pic_cascade(unsigned int irq, struct irq_desc *desc)
 	 */
 	cascade_irq = gef_pic_get_irq();
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 
 	chip->irq_eoi(&desc->irq_data);
@@ -206,7 +206,7 @@ void __init gef_pic_init(struct device_node *np)
 
 	/* Map controller */
 	gef_pic_cascade_irq = irq_of_parse_and_map(np, 0);
-	if (gef_pic_cascade_irq == NO_IRQ) {
+	if (!gef_pic_cascade_irq) {
 		printk(KERN_ERR "SBC610: failed to map cascade interrupt");
 		return;
 	}
@@ -223,12 +223,12 @@ void __init gef_pic_init(struct device_node *np)
 
 /*
  * This is called when we receive an interrupt with apparently comes from this
- * chip - check, returning the highest interrupt generated or return NO_IRQ
+ * chip - check, returning the highest interrupt generated or return 0
  */
 unsigned int gef_pic_get_irq(void)
 {
 	u32 cause, mask, active;
-	unsigned int virq = NO_IRQ;
+	unsigned int virq = 0;
 	int hwirq;
 
 	cause = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_STATUS);
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index 52bbfa0..d603e15 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -22,7 +22,7 @@ static void mpc86xx_8259_cascade(unsigned int irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned int cascade_irq = i8259_irq();
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 
 	chip->irq_eoi(&desc->irq_data);
@@ -59,7 +59,7 @@ void __init mpc86xx_init_irq(void)
 	}
 
 	cascade_irq = irq_of_parse_and_map(cascade_node, 0);
-	if (cascade_irq == NO_IRQ) {
+	if (!cascade_irq) {
 		printk(KERN_ERR "Failed to map cascade interrupt\n");
 		return;
 	}
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 1e12108..03d4448 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -250,6 +250,6 @@ void __init mpc8xx_pics_init(void)
 	}
 
 	irq = cpm_pic_init();
-	if (irq != NO_IRQ)
+	if (irq)
 		irq_set_chained_handler(irq, cpm_cascade);
 }
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index 93b49f1..2ecbcd7 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -281,7 +281,7 @@ static int axon_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		virq = irq_create_direct_mapping(msic->irq_domain);
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			dev_warn(&dev->dev,
 				 "axon_msi: virq allocation failed!\n");
 			return -1;
@@ -303,7 +303,7 @@ static void axon_msi_teardown_msi_irqs(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "axon_msi: tearing down msi irqs\n");
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq == NO_IRQ)
+		if (!entry->irq)
 			continue;
 
 		irq_set_msi_desc(entry->irq, NULL);
@@ -385,7 +385,7 @@ static int axon_msi_probe(struct platform_device *device)
 	}
 
 	virq = irq_of_parse_and_map(dn, 0);
-	if (virq == NO_IRQ) {
+	if (!virq) {
 		printk(KERN_ERR "axon_msi: irq parse and map failed for %s\n",
 		       dn->full_name);
 		goto out_free_fifo;
diff --git a/arch/powerpc/platforms/cell/beat.c b/arch/powerpc/platforms/cell/beat.c
index 852592b..9b8a849 100644
--- a/arch/powerpc/platforms/cell/beat.c
+++ b/arch/powerpc/platforms/cell/beat.c
@@ -221,7 +221,7 @@ static int __init beat_register_event(void)
 		}
 
 		virq = irq_create_mapping(NULL, data[0]);
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			printk(KERN_ERR "Beat: failed to get virtual IRQ"
 			       " for event receive port for %s\n",
 			       ev->typecode);
diff --git a/arch/powerpc/platforms/cell/beat_interrupt.c b/arch/powerpc/platforms/cell/beat_interrupt.c
index 2aee1e5..27ab2df 100644
--- a/arch/powerpc/platforms/cell/beat_interrupt.c
+++ b/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -212,14 +212,14 @@ static inline unsigned int beatic_get_irq_plug(void)
 			return i + ub + 192;
 	}
 
-	return NO_IRQ;
+	return 0;
 }
 unsigned int beatic_get_irq(void)
 {
 	unsigned int ret;
 
 	ret = beatic_get_irq_plug();
-	if (ret != NO_IRQ)
+	if (ret)
 		beatic_ack_irq(irq_get_irq_data(ret));
 	return ret;
 }
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index dca3825..5c6b864 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -122,7 +122,7 @@ static void iic_ioexc_cascade(unsigned int irq, struct irq_desc *desc)
 				unsigned int cirq =
 					irq_linear_revmap(iic_host,
 							  base | cascade);
-				if (cirq != NO_IRQ)
+				if (cirq)
 					generic_handle_irq(cirq);
 			}
 		/* post-ack level interrupts */
@@ -152,10 +152,10 @@ static unsigned int iic_get_irq(void)
 	*(unsigned long *) &pending =
 		in_be64((u64 __iomem *) &iic->regs->pending_destr);
 	if (!(pending.flags & CBE_IIC_IRQ_VALID))
-		return NO_IRQ;
+		return 0;
 	virq = irq_linear_revmap(iic_host, iic_pending_to_hwnum(pending));
-	if (virq == NO_IRQ)
-		return NO_IRQ;
+	if (!virq)
+		return 0;
 	iic->eoi_stack[++iic->eoi_ptr] = pending.prio;
 	BUG_ON(iic->eoi_ptr > 15);
 	return virq;
@@ -197,7 +197,7 @@ static void iic_request_ipi(int msg)
 	int virq;
 
 	virq = irq_create_mapping(iic_host, iic_msg_to_irq(msg));
-	if (virq == NO_IRQ) {
+	if (!virq) {
 		printk(KERN_ERR
 		       "iic: failed to map IPI %s\n", smp_ipi_name[msg]);
 		return;
@@ -351,7 +351,7 @@ static int __init setup_iic(void)
 		cascade |= 1 << IIC_IRQ_CLASS_SHIFT;
 		cascade |= IIC_UNIT_IIC;
 		cascade = irq_create_mapping(iic_host, cascade);
-		if (cascade == NO_IRQ)
+		if (!cascade)
 			continue;
 		/*
 		 * irq_data is a generic pointer that gets passed back
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index ae9fc7b..30c63af 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -410,7 +410,7 @@ static void cell_iommu_enable_hardware(struct cbe_iommu *iommu)
 
 	virq = irq_create_mapping(NULL,
 			IIC_IRQ_IOEX_ATI | (iommu->nid << IIC_IRQ_NODE_SHIFT));
-	BUG_ON(virq == NO_IRQ);
+	BUG_ON(!virq);
 
 	ret = request_irq(virq, ioc_interrupt, 0, iommu->name, iommu);
 	BUG_ON(ret);
diff --git a/arch/powerpc/platforms/cell/pmu.c b/arch/powerpc/platforms/cell/pmu.c
index 59c1a16..5870343 100644
--- a/arch/powerpc/platforms/cell/pmu.c
+++ b/arch/powerpc/platforms/cell/pmu.c
@@ -385,7 +385,7 @@ static int __init cbe_init_pm_irq(void)
 	for_each_node(node) {
 		irq = irq_create_mapping(NULL, IIC_IRQ_IOEX_PMI |
 					       (node << IIC_IRQ_NODE_SHIFT));
-		if (irq == NO_IRQ) {
+		if (!irq) {
 			printk("ERROR: Unable to allocate irq for node %d\n",
 			       node);
 			return -EINVAL;
@@ -412,7 +412,7 @@ void cbe_sync_irq(int node)
 			       IIC_IRQ_IOEX_PMI
 			       | (node << IIC_IRQ_NODE_SHIFT));
 
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		printk(KERN_WARNING "ERROR, unable to get existing irq %d " \
 		"for node %d\n", irq, node);
 		return;
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index 8153e4e..458380a 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -207,11 +207,11 @@ static void spider_irq_cascade(unsigned int irq, struct irq_desc *desc)
 
 	cs = in_be32(pic->regs + TIR_CS) >> 24;
 	if (cs == SPIDER_IRQ_INVALID)
-		virq = NO_IRQ;
+		virq = 0;
 	else
 		virq = irq_linear_revmap(pic->host, cs);
 
-	if (virq != NO_IRQ)
+	if (virq)
 		generic_handle_irq(virq);
 
 	chip->irq_eoi(&desc->irq_data);
@@ -244,20 +244,20 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 
 	/* Now do the horrible hacks */
 	tmp = of_get_property(pic->host->of_node, "#interrupt-cells", NULL);
-	if (tmp == NULL)
-		return NO_IRQ;
+	if (!tmp)
+		return 0;
 	intsize = *tmp;
 	imap = of_get_property(pic->host->of_node, "interrupt-map", &imaplen);
 	if (imap == NULL || imaplen < (intsize + 1))
-		return NO_IRQ;
+		return 0;
 	iic = of_find_node_by_phandle(imap[intsize]);
 	if (iic == NULL)
-		return NO_IRQ;
+		return 0;
 	imap += intsize + 1;
 	tmp = of_get_property(iic, "#interrupt-cells", NULL);
 	if (tmp == NULL) {
 		of_node_put(iic);
-		return NO_IRQ;
+		return 0;
 	}
 	intsize = *tmp;
 	/* Assume unit is last entry of interrupt specifier */
@@ -266,7 +266,7 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 	tmp = of_get_property(iic, "ibm,interrupt-server-ranges", NULL);
 	if (tmp == NULL) {
 		of_node_put(iic);
-		return NO_IRQ;
+		return 0;
 	}
 	/* ugly as hell but works for now */
 	pic->node_id = (*tmp) >> 1;
@@ -281,7 +281,7 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 				  (pic->node_id << IIC_IRQ_NODE_SHIFT) |
 				  (2 << IIC_IRQ_CLASS_SHIFT) |
 				  unit);
-	if (virq == NO_IRQ)
+	if (!virq)
 		printk(KERN_ERR "spider_pic: failed to map cascade !");
 	return virq;
 }
@@ -318,7 +318,7 @@ static void __init spider_init_one(struct device_node *of_node, int chip,
 
 	/* Hook up the cascade interrupt to the iic and nodeid */
 	virq = spider_find_cascade_and_node(pic);
-	if (virq == NO_IRQ)
+	if (!virq)
 		return;
 	irq_set_handler_data(virq, pic);
 	irq_set_chained_handler(virq, spider_irq_cascade);
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index 8b12139..7a00301 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -438,7 +438,7 @@ static int spu_request_irqs(struct spu *spu)
 {
 	int ret = 0;
 
-	if (spu->irqs[0] != NO_IRQ) {
+	if (spu->irqs[0]) {
 		snprintf(spu->irq_c0, sizeof (spu->irq_c0), "spe%02d.0",
 			 spu->number);
 		ret = request_irq(spu->irqs[0], spu_irq_class_0,
@@ -446,7 +446,7 @@ static int spu_request_irqs(struct spu *spu)
 		if (ret)
 			goto bail0;
 	}
-	if (spu->irqs[1] != NO_IRQ) {
+	if (spu->irqs[1]) {
 		snprintf(spu->irq_c1, sizeof (spu->irq_c1), "spe%02d.1",
 			 spu->number);
 		ret = request_irq(spu->irqs[1], spu_irq_class_1,
@@ -454,7 +454,7 @@ static int spu_request_irqs(struct spu *spu)
 		if (ret)
 			goto bail1;
 	}
-	if (spu->irqs[2] != NO_IRQ) {
+	if (spu->irqs[2]) {
 		snprintf(spu->irq_c2, sizeof (spu->irq_c2), "spe%02d.2",
 			 spu->number);
 		ret = request_irq(spu->irqs[2], spu_irq_class_2,
@@ -465,10 +465,10 @@ static int spu_request_irqs(struct spu *spu)
 	return 0;
 
 bail2:
-	if (spu->irqs[1] != NO_IRQ)
+	if (spu->irqs[1])
 		free_irq(spu->irqs[1], spu);
 bail1:
-	if (spu->irqs[0] != NO_IRQ)
+	if (spu->irqs[0])
 		free_irq(spu->irqs[0], spu);
 bail0:
 	return ret;
@@ -476,11 +476,11 @@ bail0:
 
 static void spu_free_irqs(struct spu *spu)
 {
-	if (spu->irqs[0] != NO_IRQ)
+	if (spu->irqs[0])
 		free_irq(spu->irqs[0], spu);
-	if (spu->irqs[1] != NO_IRQ)
+	if (spu->irqs[1])
 		free_irq(spu->irqs[1], spu);
-	if (spu->irqs[2] != NO_IRQ)
+	if (spu->irqs[2])
 		free_irq(spu->irqs[2], spu);
 }
 
diff --git a/arch/powerpc/platforms/cell/spu_manage.c b/arch/powerpc/platforms/cell/spu_manage.c
index 2bb6977..3ac1659 100644
--- a/arch/powerpc/platforms/cell/spu_manage.c
+++ b/arch/powerpc/platforms/cell/spu_manage.c
@@ -105,7 +105,7 @@ static int __init spu_map_interrupts_old(struct spu *spu,
 	spu->irqs[2] = irq_create_mapping(NULL, IIC_IRQ_CLASS_2 | isrc);
 
 	/* Right now, we only fail if class 2 failed */
-	return spu->irqs[2] == NO_IRQ ? -EINVAL : 0;
+	return !spu->irqs[2] ? -EINVAL : 0;
 }
 
 static void __iomem * __init spu_map_prop_old(struct spu *spu,
@@ -192,7 +192,7 @@ static int __init spu_map_interrupts(struct spu *spu, struct device_node *np)
 			 oirq.controller->full_name);
 		spu->irqs[i] = irq_create_of_mapping(oirq.controller,
 					oirq.specifier, oirq.size);
-		if (spu->irqs[i] == NO_IRQ) {
+		if (!spu->irqs[i]) {
 			pr_debug("spu_new: failed to map it !\n");
 			goto err;
 		}
@@ -203,7 +203,7 @@ err:
 	pr_debug("failed to map irq %x for spu %s\n", *oirq.specifier,
 		spu->name);
 	for (; i >= 0; i--) {
-		if (spu->irqs[i] != NO_IRQ)
+		if (spu->irqs[i])
 			irq_dispose_mapping(spu->irqs[i]);
 	}
 	return ret;
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index f1f17bb..9c3227f 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -368,7 +368,7 @@ static void chrp_8259_cascade(unsigned int irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned int cascade_irq = i8259_irq();
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 
 	chip->irq_eoi(&desc->irq_data);
@@ -513,7 +513,7 @@ static void __init chrp_find_8259(void)
 	}
 	if (chrp_mpic != NULL) {
 		cascade_irq = irq_of_parse_and_map(pic, 0);
-		if (cascade_irq == NO_IRQ)
+		if (!cascade_irq)
 			printk(KERN_ERR "i8259: failed to map cascade irq\n");
 		else
 			irq_set_chained_handler(cascade_irq,
diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
index 5e411ad..32b17b0 100644
--- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -181,7 +181,7 @@ unsigned int flipper_pic_get_irq(void)
 	irq_status = in_be32(io_base + FLIPPER_ICR) &
 		     in_be32(io_base + FLIPPER_IMR);
 	if (irq_status == 0)
-		return NO_IRQ;	/* no more IRQs pending */
+		return 0;	/* no more IRQs pending */
 
 	irq = __ffs(irq_status);
 	return irq_linear_revmap(flipper_irq_domain, irq);
diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index 00434c8..3c910c9 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -113,7 +113,7 @@ static unsigned int __hlwd_pic_get_irq(struct irq_domain *h)
 	irq_status = in_be32(io_base + HW_BROADWAY_ICR) &
 		     in_be32(io_base + HW_BROADWAY_IMR);
 	if (irq_status == 0)
-		return NO_IRQ;	/* no more IRQs pending */
+		return 0;	/* no more IRQs pending */
 
 	irq = __ffs(irq_status);
 	return irq_linear_revmap(h, irq);
@@ -131,7 +131,7 @@ static void hlwd_pic_irq_cascade(unsigned int cascade_virq,
 	raw_spin_unlock(&desc->lock);
 
 	virq = __hlwd_pic_get_irq(irq_domain);
-	if (virq != NO_IRQ)
+	if (virq)
 		generic_handle_irq(virq);
 	else
 		pr_err("spurious interrupt!\n");
diff --git a/arch/powerpc/platforms/maple/pci.c b/arch/powerpc/platforms/maple/pci.c
index 401e3f3..10b8889 100644
--- a/arch/powerpc/platforms/maple/pci.c
+++ b/arch/powerpc/platforms/maple/pci.c
@@ -552,7 +552,7 @@ void __devinit maple_pci_irq_fixup(struct pci_dev *dev)
 	    pci_bus_to_host(dev->bus) == u4_pcie) {
 		printk(KERN_DEBUG "Fixup U4 PCIe IRQ\n");
 		dev->irq = irq_create_mapping(NULL, 1);
-		if (dev->irq != NO_IRQ)
+		if (dev->irq)
 			irq_set_irq_type(dev->irq, IRQ_TYPE_LEVEL_LOW);
 	}
 
@@ -562,7 +562,7 @@ void __devinit maple_pci_irq_fixup(struct pci_dev *dev)
 	if (dev->vendor == PCI_VENDOR_ID_AMD &&
 	    dev->device == PCI_DEVICE_ID_AMD_8111_IDE &&
 	    (dev->class & 5) != 5) {
-		dev->irq = NO_IRQ;
+		dev->irq = 0;
 	}
 
 	DBG(" <- maple_pci_irq_fixup\n");
@@ -640,7 +640,7 @@ int maple_pci_get_legacy_ide_irq(struct pci_dev *pdev, int channel)
 		return defirq;
 	}
 	irq = irq_of_parse_and_map(np, channel & 0x1);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		printk("Failed to map onboard IDE interrupt for channel %d\n",
 		       channel);
 		return defirq;
diff --git a/arch/powerpc/platforms/pasemi/misc.c b/arch/powerpc/platforms/pasemi/misc.c
index e0ab299..8571e7b 100644
--- a/arch/powerpc/platforms/pasemi/misc.c
+++ b/arch/powerpc/platforms/pasemi/misc.c
@@ -76,7 +76,7 @@ static int __init pasemi_register_i2c_devices(void)
 			}
 
 			info.irq = irq_of_parse_and_map(node, 0);
-			if (info.irq == NO_IRQ)
+			if (!info.irq)
 				info.irq = -1;
 
 			if (find_i2c_driver(node, &info) < 0)
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 98b7a7c..dffe757 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -59,7 +59,7 @@ struct mce_regs {
 
 static struct mce_regs mce_regs[MAX_MCE_REGS];
 static int num_mce_regs;
-static int nmi_virq = NO_IRQ;
+static int nmi_virq = 0;
 
 
 static void pas_restart(char *cmd)
@@ -264,7 +264,7 @@ static int pas_machine_check_handler(struct pt_regs *regs)
 	srr0 = regs->nip;
 	srr1 = regs->msr;
 
-	if (nmi_virq != NO_IRQ && mpic_get_mcirq() == nmi_virq) {
+	if (nmi_virq && mpic_get_mcirq() == nmi_virq) {
 		printk(KERN_ERR "NMI delivered\n");
 		debugger(regs);
 		mpic_end_irq(irq_get_irq_data(nmi_virq));
diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index 996c5ff..961f1bd6 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -392,7 +392,7 @@ static int kw_i2c_xfer(struct pmac_i2c_bus *bus, u8 addrdir, int subsize,
 {
 	struct pmac_i2c_host_kw *host = bus->hostdata;
 	u8 mode_reg = host->speed;
-	int use_irq = host->irq != NO_IRQ && !bus->polled;
+	int use_irq = host->irq && !bus->polled;
 
 	/* Setup mode & subaddress if any */
 	switch(bus->mode) {
@@ -526,7 +526,7 @@ static struct pmac_i2c_host_kw *__init kw_i2c_host_init(struct device_node *np)
 		break;
 	}	
 	host->irq = irq_of_parse_and_map(np, 0);
-	if (host->irq == NO_IRQ)
+	if (!host->irq)
 		printk(KERN_WARNING
 		       "low_i2c: Failed to map interrupt for %s\n",
 		       np->full_name);
@@ -548,7 +548,7 @@ static struct pmac_i2c_host_kw *__init kw_i2c_host_init(struct device_node *np)
 	 */
 	if (request_irq(host->irq, kw_i2c_irq, IRQF_NO_SUSPEND,
 			"keywest i2c", host))
-		host->irq = NO_IRQ;
+		host->irq = 0;
 
 	printk(KERN_INFO "KeyWest i2c @0x%08x irq %d %s\n",
 	       *addrp, host->irq, np->full_name);
diff --git a/arch/powerpc/platforms/powermac/pfunc_base.c b/arch/powerpc/platforms/powermac/pfunc_base.c
index f5e3cda..467a7eb 100644
--- a/arch/powerpc/platforms/powermac/pfunc_base.c
+++ b/arch/powerpc/platforms/powermac/pfunc_base.c
@@ -25,7 +25,7 @@ static irqreturn_t macio_gpio_irq(int irq, void *data)
 static int macio_do_gpio_irq_enable(struct pmf_function *func)
 {
 	unsigned int irq = irq_of_parse_and_map(func->node, 0);
-	if (irq == NO_IRQ)
+	if (!irq)
 		return -EINVAL;
 	return request_irq(irq, macio_gpio_irq, 0, func->node->name, func);
 }
@@ -33,7 +33,7 @@ static int macio_do_gpio_irq_enable(struct pmf_function *func)
 static int macio_do_gpio_irq_disable(struct pmf_function *func)
 {
 	unsigned int irq = irq_of_parse_and_map(func->node, 0);
-	if (irq == NO_IRQ)
+	if (!irq)
 		return -EINVAL;
 	free_irq(irq, func);
 	return 0;
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 079d921..4cd4423 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -251,7 +251,7 @@ static unsigned int pmac_pic_get_irq(void)
 	}
 	raw_spin_unlock_irqrestore(&pmac_pic_lock, flags);
 	if (unlikely(irq < 0))
-		return NO_IRQ;
+		return 0;
 	return irq_linear_revmap(pmac_pic_host, irq);
 }
 
@@ -394,7 +394,7 @@ static void __init pmac_pic_probe_oldstyle(void)
 		out_le32(&pmac_irq_hw[i]->enable, 0);
 
 	/* Hookup cascade irq */
-	if (slave && pmac_irq_cascade != NO_IRQ)
+	if (slave && pmac_irq_cascade)
 		setup_irq(pmac_irq_cascade, &gatwick_cascade_action);
 
 	printk(KERN_INFO "irq: System has %d possible interrupts\n", max_irqs);
@@ -449,7 +449,7 @@ static void __init pmac_pic_setup_mpic_nmi(struct mpic *mpic)
 	pswitch = of_find_node_by_name(NULL, "programmer-switch");
 	if (pswitch) {
 		nmi_irq = irq_of_parse_and_map(pswitch, 0);
-		if (nmi_irq != NO_IRQ) {
+		if (nmi_irq) {
 			mpic_irq_set_priority(nmi_irq, 9);
 			setup_irq(nmi_irq, &xmon_action);
 		}
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index aaa0dba..9a54f46 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -308,7 +308,7 @@ static int __init opal_init(void)
 	for (i = 0; irqs && i < (irqlen / 4); i++, irqs++) {
 		unsigned int hwirq = be32_to_cpup(irqs);
 		unsigned int irq = irq_create_mapping(NULL, hwirq);
-		if (irq == NO_IRQ) {
+		if (!irq) {
 			pr_warning("opal: Failed to map irq 0x%x\n", hwirq);
 			continue;
 		}
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index a70bc1e..a84d120 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -105,7 +105,7 @@ static int pnv_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 			return -ENOSPC;
 		}
 		virq = irq_create_mapping(NULL, hwirq);
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			pr_warn("%s: Failed to map MSI to linux irq\n",
 				pci_name(pdev));
 			pnv_put_msi(phb, hwirq);
@@ -135,7 +135,7 @@ static void pnv_teardown_msi_irqs(struct pci_dev *pdev)
 		return;
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
-		if (entry->irq == NO_IRQ)
+		if (!entry->irq)
 			continue;
 		irq_set_msi_desc(entry->irq, NULL);
 		pnv_put_msi(phb, virq_to_hw(entry->irq));
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index 66891b8..6fb9f13 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -192,7 +192,7 @@ static int ps3_virq_setup(enum ps3_cpu_binding cpu, unsigned long outlet,
 
 	*virq = irq_create_mapping(NULL, outlet);
 
-	if (*virq == NO_IRQ) {
+	if (!(*virq)) {
 		FAIL("%s:%d: irq_create_mapping failed: outlet %lu\n",
 			__func__, __LINE__, outlet);
 		result = -ENOMEM;
@@ -339,7 +339,7 @@ int ps3_event_receive_port_setup(enum ps3_cpu_binding cpu, unsigned int *virq)
 	if (result) {
 		FAIL("%s:%d: lv1_construct_event_receive_port failed: %s\n",
 			__func__, __LINE__, ps3_result(result));
-		*virq = NO_IRQ;
+		*virq = 0;
 		return result;
 	}
 
@@ -418,7 +418,7 @@ int ps3_sb_event_receive_port_setup(struct ps3_system_bus_device *dev,
 			" failed: %s\n", __func__, __LINE__,
 			ps3_result(result));
 		ps3_event_receive_port_destroy(*virq);
-		*virq = NO_IRQ;
+		*virq = 0;
 		return result;
 	}
 
@@ -723,12 +723,12 @@ static unsigned int ps3_get_irq(void)
 	asm volatile("cntlzd %0,%1" : "=r" (plug) : "r" (x));
 	plug &= 0x3f;
 
-	if (unlikely(plug == NO_IRQ)) {
+	if (unlikely(!plug)) {
 		DBG("%s:%d: no plug found: thread_id %llu\n", __func__,
 			__LINE__, pd->thread_id);
 		dump_bmp(&per_cpu(ps3_private, 0));
 		dump_bmp(&per_cpu(ps3_private, 1));
-		return NO_IRQ;
+		return 0;
 	}
 
 #if defined(DEBUG)
diff --git a/arch/powerpc/platforms/ps3/smp.c b/arch/powerpc/platforms/ps3/smp.c
index 4b35166..48a9686 100644
--- a/arch/powerpc/platforms/ps3/smp.c
+++ b/arch/powerpc/platforms/ps3/smp.c
@@ -91,7 +91,7 @@ static int __init ps3_smp_probe(void)
 			result = smp_request_message_ipi(virqs[i], i);
 
 			if (result)
-				virqs[i] = NO_IRQ;
+				virqs[i] = 0;
 			else
 				ps3_register_ipi_irq(cpu, virqs[i]);
 		}
@@ -114,7 +114,7 @@ void ps3_smp_cleanup_cpu(int cpu)
 	for (i = 0; i < MSG_COUNT; i++) {
 		/* Can't call free_irq from interrupt context. */
 		ps3_event_receive_port_destroy(virqs[i]);
-		virqs[i] = NO_IRQ;
+		virqs[i] = 0;
 	}
 
 	DBG(" <- %s:%d: (%d)\n", __func__, __LINE__, cpu);
diff --git a/arch/powerpc/platforms/ps3/spu.c b/arch/powerpc/platforms/ps3/spu.c
index e17fa14..625fbb2 100644
--- a/arch/powerpc/platforms/ps3/spu.c
+++ b/arch/powerpc/platforms/ps3/spu.c
@@ -284,7 +284,7 @@ fail_alloc_2:
 fail_alloc_1:
 	ps3_spe_irq_destroy(spu->irqs[0]);
 fail_alloc_0:
-	spu->irqs[0] = spu->irqs[1] = spu->irqs[2] = NO_IRQ;
+	spu->irqs[0] = spu->irqs[1] = spu->irqs[2] = 0;
 	return result;
 }
 
@@ -334,7 +334,7 @@ static int ps3_destroy_spu(struct spu *spu)
 	ps3_spe_irq_destroy(spu->irqs[1]);
 	ps3_spe_irq_destroy(spu->irqs[0]);
 
-	spu->irqs[0] = spu->irqs[1] = spu->irqs[2] = NO_IRQ;
+	spu->irqs[0] = spu->irqs[1] = spu->irqs[2] = 0;
 
 	spu_unmap(spu);
 
diff --git a/arch/powerpc/platforms/pseries/event_sources.c b/arch/powerpc/platforms/pseries/event_sources.c
index 2605c31..6ba30eb 100644
--- a/arch/powerpc/platforms/pseries/event_sources.c
+++ b/arch/powerpc/platforms/pseries/event_sources.c
@@ -41,7 +41,7 @@ void request_event_sources_irqs(struct device_node *np,
 			if (count > 15)
 				break;
 			virqs[count] = irq_create_mapping(NULL, *(opicprop++));
-			if (virqs[count] == NO_IRQ) {
+			if (!virqs[count]) {
 				pr_err("event-sources: Unable to allocate "
 				       "interrupt number for %s\n",
 				       np->full_name);
@@ -62,7 +62,7 @@ void request_event_sources_irqs(struct device_node *np,
 			virqs[count] = irq_create_of_mapping(oirq.controller,
 							    oirq.specifier,
 							    oirq.size);
-			if (virqs[count] == NO_IRQ) {
+			if (!virqs[count]) {
 				pr_err("event-sources: Unable to allocate "
 				       "interrupt number for %s\n",
 				       np->full_name);
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 38d24e7..ec9d5fb 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -134,7 +134,7 @@ static void rtas_teardown_msi_irqs(struct pci_dev *pdev)
 	struct msi_desc *entry;
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
-		if (entry->irq == NO_IRQ)
+		if (!entry->irq)
 			continue;
 
 		irq_set_msi_desc(entry->irq, NULL);
@@ -430,8 +430,7 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		}
 
 		virq = irq_create_mapping(NULL, hwirq);
-
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			pr_debug("rtas_msi: Failed mapping hwirq %d\n", hwirq);
 			return -ENOSPC;
 		}
@@ -450,7 +449,7 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 static void rtas_msi_pci_irq_fixup(struct pci_dev *pdev)
 {
 	/* No LSI -> leave MSIs (if any) configured */
-	if (pdev->irq == NO_IRQ) {
+	if (!pdev->irq) {
 		dev_dbg(&pdev->dev, "rtas_msi: no LSI, nothing to do.\n");
 		return;
 	}
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index f79f127..e9cfad7 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -115,7 +115,7 @@ static void pseries_8259_cascade(unsigned int irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned int cascade_irq = i8259_irq();
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 
 	chip->irq_eoi(&desc->irq_data);
@@ -142,7 +142,7 @@ static void __init pseries_setup_i8259_cascade(void)
 	}
 
 	cascade = irq_of_parse_and_map(found, 0);
-	if (cascade == NO_IRQ) {
+	if (!cascade) {
 		printk(KERN_ERR "pic: failed to map cascade interrupt");
 		return;
 	}
diff --git a/arch/powerpc/platforms/wsp/msi.c b/arch/powerpc/platforms/wsp/msi.c
index 380882f..9c82bfb 100644
--- a/arch/powerpc/platforms/wsp/msi.c
+++ b/arch/powerpc/platforms/wsp/msi.c
@@ -50,7 +50,7 @@ int wsp_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		}
 
 		virq = irq_create_mapping(NULL, hwirq);
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			dev_warn(&dev->dev, "wsp_msi: virq alloc failed!\n");
 			return -1;
 		}
@@ -78,7 +78,7 @@ void wsp_teardown_msi_irqs(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "wsp_msi: tearing down msi irqs\n");
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq == NO_IRQ)
+		if (!entry->irq)
 			continue;
 
 		irq_set_msi_desc(entry->irq, NULL);
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 1c16141..a1a573a7 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -248,7 +248,7 @@ static int axon_ram_probe(struct platform_device *device)
 	add_disk(bank->disk);
 
 	bank->irq_id = irq_of_parse_and_map(device->dev.of_node, 0);
-	if (bank->irq_id == NO_IRQ) {
+	if (!bank->irq_id) {
 		dev_err(&device->dev, "Cannot access ECC interrupt ID\n");
 		rc = -EFAULT;
 		goto failed;
@@ -258,7 +258,7 @@ static int axon_ram_probe(struct platform_device *device)
 			AXON_RAM_IRQ_FLAGS, bank->disk->disk_name, device);
 	if (rc != 0) {
 		dev_err(&device->dev, "Cannot register ECC interrupt handler\n");
-		bank->irq_id = NO_IRQ;
+		bank->irq_id = 0;
 		rc = -EFAULT;
 		goto failed;
 	}
@@ -276,7 +276,7 @@ static int axon_ram_probe(struct platform_device *device)
 
 failed:
 	if (bank != NULL) {
-		if (bank->irq_id != NO_IRQ)
+		if (bank->irq_id)
 			free_irq(bank->irq_id, device);
 		if (bank->disk != NULL) {
 			if (bank->disk->major > 0)
diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.c b/arch/powerpc/sysdev/bestcomm/bestcomm.c
index b3fbb27..b0f3bd4 100644
--- a/arch/powerpc/sysdev/bestcomm/bestcomm.c
+++ b/arch/powerpc/sysdev/bestcomm/bestcomm.c
@@ -82,7 +82,7 @@ bcom_task_alloc(int bd_count, int bd_size, int priv_size)
 
 	/* Get IRQ of that task */
 	tsk->irq = irq_of_parse_and_map(bcom_eng->ofnode, tsk->tasknum);
-	if (tsk->irq == NO_IRQ)
+	if (!tsk->irq)
 		goto error;
 
 	/* Init the BDs, if needed */
@@ -104,7 +104,7 @@ bcom_task_alloc(int bd_count, int bd_size, int priv_size)
 
 error:
 	if (tsk) {
-		if (tsk->irq != NO_IRQ)
+		if (tsk->irq)
 			irq_dispose_mapping(tsk->irq);
 		bcom_sram_free(tsk->bd);
 		kfree(tsk->cookie);
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index 2c90726..10159f3 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -131,7 +131,7 @@ unsigned int cpm_pic_init(void)
 {
 	struct device_node *np = NULL;
 	struct resource res;
-	unsigned int sirq = NO_IRQ, hwirq, eirq;
+	unsigned int sirq = 0, hwirq, eirq;
 	int ret;
 
 	pr_debug("cpm_pic_init\n");
@@ -153,7 +153,7 @@ unsigned int cpm_pic_init(void)
 		goto end;
 
 	sirq = irq_of_parse_and_map(np, 0);
-	if (sirq == NO_IRQ)
+	if (!sirq)
 		goto end;
 
 	/* Initialize the CPM interrupt controller. */
@@ -167,7 +167,7 @@ unsigned int cpm_pic_init(void)
 	cpm_pic_host = irq_domain_add_linear(np, 64, &cpm_pic_host_ops);
 	if (cpm_pic_host == NULL) {
 		printk(KERN_ERR "CPM2 PIC: failed to allocate irq host!\n");
-		sirq = NO_IRQ;
+		sirq = 0;
 		goto end;
 	}
 
@@ -181,7 +181,7 @@ unsigned int cpm_pic_init(void)
 	}
 
 	eirq = irq_of_parse_and_map(np, 0);
-	if (eirq == NO_IRQ)
+	if (!eirq)
 		goto end;
 
 	if (setup_irq(eirq, &cpm_error_irqaction))
diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
index 888b75b..72a5812f 100644
--- a/arch/powerpc/sysdev/ehv_pic.c
+++ b/arch/powerpc/sysdev/ehv_pic.c
@@ -160,7 +160,7 @@ static struct irq_chip ehv_pic_direct_eoi_irq_chip = {
 	.irq_set_type	= ehv_pic_set_irq_type,
 };
 
-/* Return an interrupt vector or NO_IRQ if no interrupt is pending. */
+/* Return an interrupt vector or 0 if no interrupt is pending. */
 unsigned int ehv_pic_get_irq(void)
 {
 	int irq;
@@ -173,7 +173,7 @@ unsigned int ehv_pic_get_irq(void)
 		ev_int_iack(0, &irq); /* legacy mode */
 
 	if (irq == 0xFFFF)    /* 0xFFFF --> no irq is pending */
-		return NO_IRQ;
+		return 0;
 
 	/*
 	 * this will also setup revmap[] in the slow path for the first
diff --git a/arch/powerpc/sysdev/fsl_gtm.c b/arch/powerpc/sysdev/fsl_gtm.c
index 02cf1e7..9449e18 100644
--- a/arch/powerpc/sysdev/fsl_gtm.c
+++ b/arch/powerpc/sysdev/fsl_gtm.c
@@ -405,7 +405,7 @@ static int __init fsl_gtm_init(void)
 			struct resource irq;
 
 			ret = of_irq_to_resource(np, i, &irq);
-			if (ret == NO_IRQ) {
+			if (!ret) {
 				pr_err("%s: not enough interrupts specified\n",
 				       np->full_name);
 				goto err;
diff --git a/arch/powerpc/sysdev/fsl_ifc.c b/arch/powerpc/sysdev/fsl_ifc.c
index b31f19f..562d89e 100644
--- a/arch/powerpc/sysdev/fsl_ifc.c
+++ b/arch/powerpc/sysdev/fsl_ifc.c
@@ -234,7 +234,7 @@ static int __devinit fsl_ifc_ctrl_probe(struct platform_device *dev)
 
 	/* get the Controller level irq */
 	fsl_ifc_ctrl_dev->irq = irq_of_parse_and_map(dev->dev.of_node, 0);
-	if (fsl_ifc_ctrl_dev->irq == NO_IRQ) {
+	if (!fsl_ifc_ctrl_dev->irq) {
 		dev_err(&dev->dev, "failed to get irq resource "
 							"for IFC\n");
 		ret = -ENODEV;
@@ -244,7 +244,7 @@ static int __devinit fsl_ifc_ctrl_probe(struct platform_device *dev)
 	/* get the nand machine irq */
 	fsl_ifc_ctrl_dev->nand_irq =
 			irq_of_parse_and_map(dev->dev.of_node, 1);
-	if (fsl_ifc_ctrl_dev->nand_irq == NO_IRQ) {
+	if (!fsl_ifc_ctrl_dev->nand_irq) {
 		dev_err(&dev->dev, "failed to get irq resource "
 						"for NAND Machine\n");
 		ret = -ENODEV;
diff --git a/arch/powerpc/sysdev/fsl_lbc.c b/arch/powerpc/sysdev/fsl_lbc.c
index 483126d..c200541 100644
--- a/arch/powerpc/sysdev/fsl_lbc.c
+++ b/arch/powerpc/sysdev/fsl_lbc.c
@@ -299,7 +299,7 @@ static int __devinit fsl_lbc_ctrl_probe(struct platform_device *dev)
 	}
 
 	fsl_lbc_ctrl_dev->irq = irq_of_parse_and_map(dev->dev.of_node, 0);
-	if (fsl_lbc_ctrl_dev->irq == NO_IRQ) {
+	if (!fsl_lbc_ctrl_dev->irq) {
 		dev_err(&dev->dev, "failed to get irq resource\n");
 		ret = -ENODEV;
 		goto err;
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 82bac2c..b80ad34 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -110,7 +110,7 @@ static void fsl_teardown_msi_irqs(struct pci_dev *pdev)
 	struct fsl_msi *msi_data;
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
-		if (entry->irq == NO_IRQ)
+		if (!entry->irq)
 			continue;
 		msi_data = irq_get_chip_data(entry->irq);
 		irq_set_msi_desc(entry->irq, NULL);
@@ -205,8 +205,7 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		}
 
 		virq = irq_create_mapping(msi_data->irqhost, hwirq);
-
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			dev_err(&pdev->dev, "fail mapping hwirq %i\n", hwirq);
 			msi_bitmap_free_hwirqs(&msi_data->bitmap, hwirq, 1);
 			rc = -ENOSPC;
@@ -257,7 +256,7 @@ static void fsl_msi_cascade(unsigned int irq, struct irq_desc *desc)
 	msir_index = cascade_data->index;
 
 	if (msir_index >= NR_MSI_REG)
-		cascade_irq = NO_IRQ;
+		cascade_irq = 0;
 
 	irqd_set_chained_irq_inprogress(idata);
 	switch (msi_data->feature & FSL_PIC_IP_MASK) {
@@ -284,7 +283,7 @@ static void fsl_msi_cascade(unsigned int irq, struct irq_desc *desc)
 		cascade_irq = irq_linear_revmap(msi_data->irqhost,
 				msir_index * IRQS_PER_MSI_REG +
 					intr_index + have_shift);
-		if (cascade_irq != NO_IRQ)
+		if (cascade_irq)
 			generic_handle_irq(cascade_irq);
 		have_shift += intr_index + 1;
 		msir_value = msir_value >> (intr_index + 1);
@@ -315,7 +314,7 @@ static int fsl_of_msi_remove(struct platform_device *ofdev)
 		list_del(&msi->list);
 	for (i = 0; i < NR_MSI_REG; i++) {
 		virq = msi->msi_virqs[i];
-		if (virq != NO_IRQ) {
+		if (virq) {
 			cascade_data = irq_get_handler_data(virq);
 			kfree(cascade_data);
 			irq_dispose_mapping(virq);
@@ -338,7 +337,7 @@ static int __devinit fsl_msi_setup_hwirq(struct fsl_msi *msi,
 	int virt_msir;
 
 	virt_msir = irq_of_parse_and_map(dev->dev.of_node, irq_index);
-	if (virt_msir == NO_IRQ) {
+	if (!virt_msir) {
 		dev_err(&dev->dev, "%s: Cannot translate IRQ index %d\n",
 			__func__, irq_index);
 		return 0;
diff --git a/arch/powerpc/sysdev/i8259.c b/arch/powerpc/sysdev/i8259.c
index 4a49b5e..c591b31 100644
--- a/arch/powerpc/sysdev/i8259.c
+++ b/arch/powerpc/sysdev/i8259.c
@@ -69,9 +69,9 @@ unsigned int i8259_irq(void)
 		if (!pci_intack)
 			outb(0x0B, 0x20);	/* ISR register */
 		if(~inb(0x20) & 0x80)
-			irq = NO_IRQ;
+			irq = 0;
 	} else if (irq == 0xff)
-		irq = NO_IRQ;
+		irq = 0;
 
 	if (lock)
 		raw_spin_unlock(&i8259_lock);
diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index b764917..a905745c 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -869,7 +869,7 @@ void ipic_clear_mcp_status(u32 mask)
 	ipic_write(primary_ipic->regs, IPIC_SERMR, mask);
 }
 
-/* Return an interrupt vector or NO_IRQ if no interrupt is pending. */
+/* Return an interrupt vector or 0 if no interrupt is pending. */
 unsigned int ipic_get_irq(void)
 {
 	int irq;
@@ -880,7 +880,7 @@ unsigned int ipic_get_irq(void)
 	irq = ipic_read(primary_ipic->regs, IPIC_SIVCR) & IPIC_SIVCR_VECTOR_MASK;
 
 	if (irq == 0)    /* 0 --> no irq is pending */
-		return NO_IRQ;
+		return 0;
 
 	return irq_linear_revmap(primary_ipic->irqhost, irq);
 }
diff --git a/arch/powerpc/sysdev/mpc8xx_pic.c b/arch/powerpc/sysdev/mpc8xx_pic.c
index 43f22b2..faac8fe 100644
--- a/arch/powerpc/sysdev/mpc8xx_pic.c
+++ b/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -104,7 +104,7 @@ unsigned int mpc8xx_get_irq(void)
 	irq = in_be32(&siu_reg->sc_sivec) >> 26;
 
 	if (irq == PIC_VEC_SPURRIOUS)
-		irq = NO_IRQ;
+		irq = 0;
 
         return irq_linear_revmap(mpc8xx_pic_host, irq);
 
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 45e33e5..7ed58b0 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1506,7 +1506,7 @@ void __init mpic_init(struct mpic *mpic)
 	/* Check if this MPIC is chained from a parent interrupt controller */
 	if (mpic->flags & MPIC_SECONDARY) {
 		int virq = irq_of_parse_and_map(mpic->node, 0);
-		if (virq != NO_IRQ) {
+		if (virq) {
 			printk(KERN_INFO "%s: hooking up to IRQ %d\n",
 					mpic->node->full_name, virq);
 			irq_set_handler_data(virq, mpic);
@@ -1656,13 +1656,13 @@ static unsigned int _mpic_get_one_irq(struct mpic *mpic, int reg)
 	if (unlikely(src == mpic->spurious_vec)) {
 		if (mpic->flags & MPIC_SPV_EOI)
 			mpic_eoi(mpic);
-		return NO_IRQ;
+		return 0;
 	}
 	if (unlikely(mpic->protected && test_bit(src, mpic->protected))) {
 		printk_ratelimited(KERN_WARNING "%s: Got protected source %d !\n",
 				   mpic->name, (int)src);
 		mpic_eoi(mpic);
-		return NO_IRQ;
+		return 0;
 	}
 
 	return irq_linear_revmap(mpic->irqhost, src);
@@ -1695,17 +1695,17 @@ unsigned int mpic_get_coreint_irq(void)
 	if (unlikely(src == mpic->spurious_vec)) {
 		if (mpic->flags & MPIC_SPV_EOI)
 			mpic_eoi(mpic);
-		return NO_IRQ;
+		return 0;
 	}
 	if (unlikely(mpic->protected && test_bit(src, mpic->protected))) {
 		printk_ratelimited(KERN_WARNING "%s: Got protected source %d !\n",
 				   mpic->name, (int)src);
-		return NO_IRQ;
+		return 0;
 	}
 
 	return irq_linear_revmap(mpic->irqhost, src);
 #else
-	return NO_IRQ;
+	return 0;
 #endif
 }
 
@@ -1730,7 +1730,7 @@ void mpic_request_ipis(void)
 	for (i = 0; i < 4; i++) {
 		unsigned int vipi = irq_create_mapping(mpic->irqhost,
 						       mpic->ipi_vecs[0] + i);
-		if (vipi == NO_IRQ) {
+		if (!vipi) {
 			printk(KERN_ERR "Failed to map %s\n", smp_ipi_name[i]);
 			continue;
 		}
diff --git a/arch/powerpc/sysdev/mpic_pasemi_msi.c b/arch/powerpc/sysdev/mpic_pasemi_msi.c
index 38e6238..20feb24 100644
--- a/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ b/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -78,7 +78,7 @@ static void pasemi_msi_teardown_msi_irqs(struct pci_dev *pdev)
 	pr_debug("pasemi_msi_teardown_msi_irqs, pdev %p\n", pdev);
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
-		if (entry->irq == NO_IRQ)
+		if (!entry->irq)
 			continue;
 
 		irq_set_msi_desc(entry->irq, NULL);
@@ -117,7 +117,7 @@ static int pasemi_msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		}
 
 		virq = irq_create_mapping(msi_mpic->irqhost, hwirq);
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			pr_debug("pasemi_msi: failed mapping hwirq 0x%x\n",
 				  hwirq);
 			msi_bitmap_free_hwirqs(&msi_mpic->msi_bitmap, hwirq,
diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_u3msi.c
index 9a7aa0e..61f5275 100644
--- a/arch/powerpc/sysdev/mpic_u3msi.c
+++ b/arch/powerpc/sysdev/mpic_u3msi.c
@@ -126,7 +126,7 @@ static void u3msi_teardown_msi_irqs(struct pci_dev *pdev)
 	struct msi_desc *entry;
 
         list_for_each_entry(entry, &pdev->msi_list, list) {
-		if (entry->irq == NO_IRQ)
+		if (!entry->irq)
 			continue;
 
 		irq_set_msi_desc(entry->irq, NULL);
@@ -160,7 +160,7 @@ static int u3msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		msg.address_hi = addr >> 32;
 
 		virq = irq_create_mapping(msi_mpic->irqhost, hwirq);
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			pr_debug("u3msi: failed mapping hwirq 0x%x\n", hwirq);
 			msi_bitmap_free_hwirqs(&msi_mpic->msi_bitmap, hwirq, 1);
 			return -ENOSPC;
diff --git a/arch/powerpc/sysdev/mv64x60_pic.c b/arch/powerpc/sysdev/mv64x60_pic.c
index 3d1ef09..bc2ae08 100644
--- a/arch/powerpc/sysdev/mv64x60_pic.c
+++ b/arch/powerpc/sysdev/mv64x60_pic.c
@@ -272,7 +272,7 @@ unsigned int mv64x60_get_irq(void)
 	u32 cause;
 	int level1;
 	irq_hw_number_t hwirq;
-	int virq = NO_IRQ;
+	int virq = 0;
 
 	cause = in_le32(mv64x60_irq_reg_base + MV64X60_IC_CPU0_SELECT_CAUSE);
 	if (cause & MV64X60_SELECT_CAUSE_HIGH) {
diff --git a/arch/powerpc/sysdev/pmi.c b/arch/powerpc/sysdev/pmi.c
index 8f04654..532f076 100644
--- a/arch/powerpc/sysdev/pmi.c
+++ b/arch/powerpc/sysdev/pmi.c
@@ -158,7 +158,7 @@ static int pmi_of_probe(struct platform_device *dev)
 	data->dev = dev;
 
 	data->irq = irq_of_parse_and_map(np, 0);
-	if (data->irq == NO_IRQ) {
+	if (!data->irq) {
 		printk(KERN_ERR "pmi: invalid interrupt.\n");
 		rc = -EFAULT;
 		goto error_cleanup_iomap;
diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
index 1c2d7af..a79a904 100644
--- a/arch/powerpc/sysdev/ppc4xx_msi.c
+++ b/arch/powerpc/sysdev/ppc4xx_msi.c
@@ -92,7 +92,7 @@ static int ppc4xx_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 					__func__);
 		}
 		virq = irq_of_parse_and_map(msi_data->msi_dev, int_no);
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			dev_err(&dev->dev, "%s: fail mapping irq\n", __func__);
 			msi_bitmap_free_hwirqs(&msi_data->bitmap, int_no, 1);
 			return -ENOSPC;
@@ -118,7 +118,7 @@ void ppc4xx_teardown_msi_irqs(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "PCIE-MSI: tearing down msi irqs\n");
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq == NO_IRQ)
+		if (!entry->irq)
 			continue;
 		irq_set_msi_desc(entry->irq, NULL);
 		msi_bitmap_free_hwirqs(&msi_data->bitmap,
@@ -196,7 +196,7 @@ static int ppc4xx_of_msi_remove(struct platform_device *dev)
 
 	for (i = 0; i < NR_MSI_IRQS; i++) {
 		virq = msi->msi_virqs[i];
-		if (virq != NO_IRQ)
+		if (virq)
 			irq_dispose_mapping(virq);
 	}
 
diff --git a/arch/powerpc/sysdev/ppc4xx_soc.c b/arch/powerpc/sysdev/ppc4xx_soc.c
index 0debcc3..334e0cc 100644
--- a/arch/powerpc/sysdev/ppc4xx_soc.c
+++ b/arch/powerpc/sysdev/ppc4xx_soc.c
@@ -108,7 +108,7 @@ static int __init ppc4xx_l2c_probe(void)
 
 	/* Get and map irq number from device tree */
 	irq = irq_of_parse_and_map(np, 0);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		printk(KERN_ERR "irq_of_parse_and_map failed\n");
 		of_node_put(np);
 		return -ENODEV;
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index 621523f..e59791b 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -291,7 +291,7 @@ static struct irq_domain_ops qe_ic_host_ops = {
 	.xlate = qe_ic_host_xlate,
 };
 
-/* Return an interrupt vector or NO_IRQ if no interrupt is pending. */
+/* Return an interrupt vector or 0 if no interrupt is pending. */
 unsigned int qe_ic_get_low_irq(struct qe_ic *qe_ic)
 {
 	int irq;
@@ -302,12 +302,12 @@ unsigned int qe_ic_get_low_irq(struct qe_ic *qe_ic)
 	irq = qe_ic_read(qe_ic->regs, QEIC_CIVEC) >> 26;
 
 	if (irq == 0)
-		return NO_IRQ;
+		return 0;
 
 	return irq_linear_revmap(qe_ic->irqhost, irq);
 }
 
-/* Return an interrupt vector or NO_IRQ if no interrupt is pending. */
+/* Return an interrupt vector or 0 if no interrupt is pending. */
 unsigned int qe_ic_get_high_irq(struct qe_ic *qe_ic)
 {
 	int irq;
@@ -318,7 +318,7 @@ unsigned int qe_ic_get_high_irq(struct qe_ic *qe_ic)
 	irq = qe_ic_read(qe_ic->regs, QEIC_CHIVEC) >> 26;
 
 	if (irq == 0)
-		return NO_IRQ;
+		return 0;
 
 	return irq_linear_revmap(qe_ic->irqhost, irq);
 }
@@ -353,7 +353,7 @@ void __init qe_ic_init(struct device_node *node, unsigned int flags,
 	qe_ic->virq_high = irq_of_parse_and_map(node, 0);
 	qe_ic->virq_low = irq_of_parse_and_map(node, 1);
 
-	if (qe_ic->virq_low == NO_IRQ) {
+	if (!qe_ic->virq_low) {
 		printk(KERN_ERR "Failed to map QE_IC low IRQ\n");
 		kfree(qe_ic);
 		return;
@@ -385,8 +385,7 @@ void __init qe_ic_init(struct device_node *node, unsigned int flags,
 	irq_set_handler_data(qe_ic->virq_low, qe_ic);
 	irq_set_chained_handler(qe_ic->virq_low, low_handler);
 
-	if (qe_ic->virq_high != NO_IRQ &&
-			qe_ic->virq_high != qe_ic->virq_low) {
+	if (qe_ic->virq_high && qe_ic->virq_high != qe_ic->virq_low) {
 		irq_set_handler_data(qe_ic->virq_high, qe_ic);
 		irq_set_chained_handler(qe_ic->virq_high, high_handler);
 	}
diff --git a/arch/powerpc/sysdev/tsi108_pci.c b/arch/powerpc/sysdev/tsi108_pci.c
index 6d4a38d..f2c2c3a 100644
--- a/arch/powerpc/sysdev/tsi108_pci.c
+++ b/arch/powerpc/sysdev/tsi108_pci.c
@@ -433,7 +433,7 @@ void tsi108_irq_cascade(unsigned int irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned int cascade_irq = get_pci_source();
 
-	if (cascade_irq != NO_IRQ)
+	if (cascade_irq)
 		generic_handle_irq(cascade_irq);
 
 	chip->irq_eoi(&desc->irq_data);
diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 139dfab..c48dc60 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -333,7 +333,7 @@ void __init uic_init_tree(void)
 	}
 }
 
-/* Return an interrupt vector or NO_IRQ if no interrupt is pending. */
+/* Return an interrupt vector or 0 if no interrupt is pending. */
 unsigned int uic_get_irq(void)
 {
 	u32 msr;
diff --git a/arch/powerpc/sysdev/xics/icp-hv.c b/arch/powerpc/sysdev/xics/icp-hv.c
index 253dce9..571b945 100644
--- a/arch/powerpc/sysdev/xics/icp-hv.c
+++ b/arch/powerpc/sysdev/xics/icp-hv.c
@@ -109,10 +109,10 @@ static unsigned int icp_hv_get_irq(void)
 	unsigned int irq;
 
 	if (vec == XICS_IRQ_SPURIOUS)
-		return NO_IRQ;
+		return 0;
 
 	irq = irq_radix_revmap_lookup(xics_host, vec);
-	if (likely(irq != NO_IRQ)) {
+	if (likely(irq)) {
 		xics_push_cppr(vec);
 		return irq;
 	}
@@ -123,7 +123,7 @@ static unsigned int icp_hv_get_irq(void)
 	/* We might learn about it later, so EOI it */
 	icp_hv_set_xirr(xirr);
 
-	return NO_IRQ;
+	return 0;
 }
 
 static void icp_hv_set_cpu_priority(unsigned char cppr)
diff --git a/arch/powerpc/sysdev/xics/icp-native.c b/arch/powerpc/sysdev/xics/icp-native.c
index 4c79b6f..bd1fa29 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -117,10 +117,10 @@ static unsigned int icp_native_get_irq(void)
 	unsigned int irq;
 
 	if (vec == XICS_IRQ_SPURIOUS)
-		return NO_IRQ;
+		return 0;
 
 	irq = irq_radix_revmap_lookup(xics_host, vec);
-	if (likely(irq != NO_IRQ)) {
+	if (likely(irq)) {
 		xics_push_cppr(vec);
 		return irq;
 	}
@@ -131,7 +131,7 @@ static unsigned int icp_native_get_irq(void)
 	/* We might learn about it later, so EOI it */
 	icp_native_set_xirr(xirr);
 
-	return NO_IRQ;
+	return 0;
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
index 84c97a7..c9b245f 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -131,7 +131,7 @@ static void xics_request_ipi(void)
 	unsigned int ipi;
 
 	ipi = irq_create_mapping(xics_host, XICS_IPI);
-	BUG_ON(ipi == NO_IRQ);
+	BUG_ON(!ipi);
 
 	/*
 	 * IPIs are marked IRQF_PERCPU. The handler was set in map.
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 00748ae..ba87900 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -743,7 +743,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 		udma_mask = ATA_UDMA2 & ((1 << (*prop + 1)) - 1);
 
 	ata_irq = irq_of_parse_and_map(op->dev.of_node, 0);
-	if (ata_irq == NO_IRQ) {
+	if (!ata_irq) {
 		dev_err(&op->dev, "error mapping irq\n");
 		return -EINVAL;
 	}
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index b98070c..0cedfe1 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1159,7 +1159,7 @@ static void fsldma_free_irqs(struct fsldma_device *fdev)
 	struct fsldma_chan *chan;
 	int i;
 
-	if (fdev->irq != NO_IRQ) {
+	if (fdev->irq) {
 		dev_dbg(fdev->dev, "free per-controller IRQ\n");
 		free_irq(fdev->irq, fdev);
 		return;
@@ -1167,7 +1167,7 @@ static void fsldma_free_irqs(struct fsldma_device *fdev)
 
 	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
 		chan = fdev->chan[i];
-		if (chan && chan->irq != NO_IRQ) {
+		if (chan && chan->irq) {
 			chan_dbg(chan, "free per-channel IRQ\n");
 			free_irq(chan->irq, chan);
 		}
@@ -1181,7 +1181,7 @@ static int fsldma_request_irqs(struct fsldma_device *fdev)
 	int i;
 
 	/* if we have a per-controller IRQ, use that */
-	if (fdev->irq != NO_IRQ) {
+	if (fdev->irq) {
 		dev_dbg(fdev->dev, "request per-controller IRQ\n");
 		ret = request_irq(fdev->irq, fsldma_ctrl_irq, IRQF_SHARED,
 				  "fsldma-controller", fdev);
@@ -1194,7 +1194,7 @@ static int fsldma_request_irqs(struct fsldma_device *fdev)
 		if (!chan)
 			continue;
 
-		if (chan->irq == NO_IRQ) {
+		if (!chan->irq) {
 			chan_err(chan, "interrupts property missing in device tree\n");
 			ret = -ENODEV;
 			goto out_unwind;
@@ -1214,10 +1214,7 @@ static int fsldma_request_irqs(struct fsldma_device *fdev)
 out_unwind:
 	for (/* none */; i >= 0; i--) {
 		chan = fdev->chan[i];
-		if (!chan)
-			continue;
-
-		if (chan->irq == NO_IRQ)
+		if (!chan || !chan->irq)
 			continue;
 
 		free_irq(chan->irq, chan);
@@ -1312,7 +1309,7 @@ static int __devinit fsl_dma_chan_probe(struct fsldma_device *fdev,
 	fdev->common.chancnt++;
 
 	dev_info(fdev->dev, "#%d (%s), irq %d\n", chan->id, compatible,
-		 chan->irq != NO_IRQ ? chan->irq : fdev->irq);
+		 chan->irq ? chan->irq : fdev->irq);
 
 	return 0;
 
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 4d6d4cf..3baaaa7 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -667,7 +667,7 @@ static int __devinit mpc_dma_probe(struct platform_device *op)
 	}
 
 	mdma->irq = irq_of_parse_and_map(dn, 0);
-	if (mdma->irq == NO_IRQ) {
+	if (!mdma->irq) {
 		dev_err(dev, "Error mapping IRQ!\n");
 		return -EINVAL;
 	}
@@ -675,7 +675,7 @@ static int __devinit mpc_dma_probe(struct platform_device *op)
 	if (of_device_is_compatible(dn, "fsl,mpc8308-dma")) {
 		mdma->is_mpc8308 = 1;
 		mdma->irq2 = irq_of_parse_and_map(dn, 1);
-		if (mdma->irq2 == NO_IRQ) {
+		if (!mdma->irq2) {
 			dev_err(dev, "Error mapping IRQ!\n");
 			return -EINVAL;
 		}
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index fc457a7..91dfdc0 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -4265,7 +4265,7 @@ static int ppc440spe_adma_setup_irqs(struct ppc440spe_adma_device *adev,
 	np = ofdev->dev.of_node;
 	if (adev->id != PPC440SPE_XOR_ID) {
 		adev->err_irq = irq_of_parse_and_map(np, 1);
-		if (adev->err_irq == NO_IRQ) {
+		if (!adev->err_irq) {
 			dev_warn(adev->dev, "no err irq resource?\n");
 			*initcode = PPC_ADMA_INIT_IRQ2;
 			adev->err_irq = -ENXIO;
@@ -4276,7 +4276,7 @@ static int ppc440spe_adma_setup_irqs(struct ppc440spe_adma_device *adev,
 	}
 
 	adev->irq = irq_of_parse_and_map(np, 0);
-	if (adev->irq == NO_IRQ) {
+	if (!adev->irq) {
 		dev_err(adev->dev, "no irq resource\n");
 		*initcode = PPC_ADMA_INIT_IRQ1;
 		ret = -ENXIO;
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 73464a6..a067c43 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -216,7 +216,7 @@ static int __devinit mpc85xx_pci_err_probe(struct platform_device *op)
 
 	pdata = pci->pvt_info;
 	pdata->name = "mpc85xx_pci_err";
-	pdata->irq = NO_IRQ;
+	pdata->irq = 0;
 	dev_set_drvdata(&op->dev, pci);
 	pci->dev = &op->dev;
 	pci->mod_name = EDAC_MOD_STR;
@@ -522,7 +522,7 @@ static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 
 	pdata = edac_dev->pvt_info;
 	pdata->name = "mpc85xx_l2_err";
-	pdata->irq = NO_IRQ;
+	pdata->irq = 0;
 	edac_dev->dev = &op->dev;
 	dev_set_drvdata(edac_dev->dev, edac_dev);
 	edac_dev->ctl_name = pdata->name;
@@ -973,7 +973,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 
 	pdata = mci->pvt_info;
 	pdata->name = "mpc85xx_mc_err";
-	pdata->irq = NO_IRQ;
+	pdata->irq = 0;
 	mci->dev = &op->dev;
 	pdata->edac_idx = edac_mc_idx++;
 	dev_set_drvdata(mci->dev, mci);
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index fc75706..84b42c7 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1031,8 +1031,8 @@ ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
 	pdata			= mci->pvt_info;
 
 	pdata->dcr_host		= *dcr_host;
-	pdata->irqs.sec		= NO_IRQ;
-	pdata->irqs.ded		= NO_IRQ;
+	pdata->irqs.sec		= 0;
+	pdata->irqs.ded		= 0;
 
 	/* Initialize controller capabilities and configuration */
 
@@ -1113,7 +1113,7 @@ ppc4xx_edac_register_irq(struct platform_device *op, struct mem_ctl_info *mci)
 	ded_irq = irq_of_parse_and_map(np, INTMAP_ECCDED_INDEX);
 	sec_irq = irq_of_parse_and_map(np, INTMAP_ECCSEC_INDEX);
 
-	if (ded_irq == NO_IRQ || sec_irq == NO_IRQ) {
+	if (!ded_irq || !sec_irq) {
 		ppc4xx_edac_mc_printk(KERN_ERR, mci,
 				      "Unable to map interrupts.\n");
 		status = -ENODEV;
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 4daf9e5..992afb4 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -235,7 +235,7 @@ static void macio_create_fixup_irq(struct macio_dev *dev, int index,
 	unsigned int irq;
 
 	irq = irq_create_mapping(NULL, line);
-	if (irq != NO_IRQ) {
+	if (irq) {
 		dev->interrupt[index].start = irq;
 		dev->interrupt[index].flags = IORESOURCE_IRQ;
 		dev->interrupt[index].name = dev_name(&dev->ofdev.dev);
@@ -298,7 +298,7 @@ static void macio_setup_interrupts(struct macio_dev *dev)
 			break;
 		res = &dev->interrupt[j];
 		irq = irq_of_parse_and_map(np, i++);
-		if (irq == NO_IRQ)
+		if (!irq)
 			break;
 		res->start = irq;
 		res->flags = IORESOURCE_IRQ;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 6dc26b6..de175b2 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -424,7 +424,7 @@ static int __devinit rackmeter_probe(struct macio_dev* mdev,
 	rm->irq = macio_irq(mdev, 1);
 #else
 	rm->irq = irq_of_parse_and_map(i2s, 1);
-	if (rm->irq == NO_IRQ ||
+	if (!rm->irq ||
 	    of_address_to_resource(i2s, 0, &ri2s) ||
 	    of_address_to_resource(i2s, 1, &rdma)) {
 		printk(KERN_ERR
diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index 54ac7ff..7b5f427 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -281,7 +281,7 @@ int smu_queue_cmd(struct smu_cmd *cmd)
 	spin_unlock_irqrestore(&smu->lock, flags);
 
 	/* Workaround for early calls when irq isn't available */
-	if (!smu_irq_inited || smu->db_irq == NO_IRQ)
+	if (!smu_irq_inited || !smu->db_irq)
 		smu_spinwait_cmd(cmd);
 
 	return 0;
@@ -495,8 +495,8 @@ int __init smu_init (void)
 	INIT_LIST_HEAD(&smu->cmd_list);
 	INIT_LIST_HEAD(&smu->cmd_i2c_list);
 	smu->of_node = np;
-	smu->db_irq = NO_IRQ;
-	smu->msg_irq = NO_IRQ;
+	smu->db_irq = 0;
+	smu->msg_irq = 0;
 
 	/* smu_cmdbuf_abs is in the low 2G of RAM, can be converted to a
 	 * 32 bits value safely
@@ -585,13 +585,13 @@ static int smu_late_init(void)
 
 	if (smu->db_node) {
 		smu->db_irq = irq_of_parse_and_map(smu->db_node, 0);
-		if (smu->db_irq == NO_IRQ)
+		if (!smu->db_irq)
 			printk(KERN_ERR "smu: failed to map irq for node %s\n",
 			       smu->db_node->full_name);
 	}
 	if (smu->msg_node) {
 		smu->msg_irq = irq_of_parse_and_map(smu->msg_node, 0);
-		if (smu->msg_irq == NO_IRQ)
+		if (!smu->msg_irq)
 			printk(KERN_ERR "smu: failed to map irq for node %s\n",
 			       smu->msg_node->full_name);
 	}
@@ -600,23 +600,23 @@ static int smu_late_init(void)
 	 * Try to request the interrupts
 	 */
 
-	if (smu->db_irq != NO_IRQ) {
+	if (smu->db_irq) {
 		if (request_irq(smu->db_irq, smu_db_intr,
 				IRQF_SHARED, "SMU doorbell", smu) < 0) {
 			printk(KERN_WARNING "SMU: can't "
 			       "request interrupt %d\n",
 			       smu->db_irq);
-			smu->db_irq = NO_IRQ;
+			smu->db_irq = 0;
 		}
 	}
 
-	if (smu->msg_irq != NO_IRQ) {
+	if (smu->msg_irq) {
 		if (request_irq(smu->msg_irq, smu_msg_intr,
 				IRQF_SHARED, "SMU message", smu) < 0) {
 			printk(KERN_WARNING "SMU: can't "
 			       "request interrupt %d\n",
 			       smu->msg_irq);
-			smu->msg_irq = NO_IRQ;
+			smu->msg_irq = 0;
 		}
 	}
 
diff --git a/drivers/macintosh/via-cuda.c b/drivers/macintosh/via-cuda.c
index 971bc95..502e660 100644
--- a/drivers/macintosh/via-cuda.c
+++ b/drivers/macintosh/via-cuda.c
@@ -210,7 +210,7 @@ static int __init via_cuda_start(void)
     cuda_irq = IRQ_MAC_ADB;
 #else
     cuda_irq = irq_of_parse_and_map(vias, 0);
-    if (cuda_irq == NO_IRQ) {
+    if (!cuda_irq) {
 	printk(KERN_ERR "via-cuda: can't map interrupts for %s\n",
 	       vias->full_name);
 	return -ENODEV;
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 6cccd60..2beddcf 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -144,7 +144,7 @@ static int pmu_fully_inited;
 static int pmu_has_adb;
 static struct device_node *gpio_node;
 static unsigned char __iomem *gpio_reg;
-static int gpio_irq = NO_IRQ;
+static int gpio_irq = 0;
 static int gpio_irq_enabled = -1;
 static volatile int pmu_suspended;
 static spinlock_t pmu_lock;
@@ -398,7 +398,7 @@ static int __init via_pmu_start(void)
 	batt_req.complete = 1;
 
 	irq = irq_of_parse_and_map(vias, 0);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		printk(KERN_ERR "via-pmu: can't map interrupt\n");
 		return -ENODEV;
 	}
@@ -420,7 +420,7 @@ static int __init via_pmu_start(void)
 		if (gpio_node)
 			gpio_irq = irq_of_parse_and_map(gpio_node, 0);
 
-		if (gpio_irq != NO_IRQ) {
+		if (gpio_irq) {
 			if (request_irq(gpio_irq, gpio1_interrupt, IRQF_TIMER,
 					"GPIO1 ADB", (void *)0))
 				printk(KERN_ERR "pmu: can't get irq %d"
diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index ab66f24..a8a7eb7 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -25,11 +25,6 @@
 #include <linux/mmc/core.h>
 #include <linux/mmc/host.h>
 
-/* For archs that don't support NO_IRQ (such as mips), provide a dummy value */
-#ifndef NO_IRQ
-#define NO_IRQ 0
-#endif
-
 MODULE_LICENSE("GPL");
 
 enum {
@@ -146,7 +141,7 @@ struct mmc_spi_platform_data *mmc_spi_get_pdata(struct spi_device *spi)
 		oms->pdata.get_ro = of_mmc_spi_get_ro;
 
 	oms->detect_irq = irq_of_parse_and_map(np, 0);
-	if (oms->detect_irq != NO_IRQ) {
+	if (oms->detect_irq) {
 		oms->pdata.init = of_mmc_spi_init;
 		oms->pdata.exit = of_mmc_spi_exit;
 	} else {
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index c240cf1..963c918 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -693,7 +693,7 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 	}
 
 	prv->irq = irq_of_parse_and_map(dn, 0);
-	if (prv->irq == NO_IRQ) {
+	if (!prv->irq) {
 		dev_err(dev, "Error mapping IRQ!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index f2683eb..309d887 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -119,7 +119,7 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 	}
 
 	irq = irq_of_parse_and_map(np, 0);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		dev_err(&ofdev->dev, "no irq found\n");
 		err = -ENODEV;
 		goto exit_unmap_mem;
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
index 7583a95..e4e1f74 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
@@ -89,7 +89,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 	int ret = -EINVAL;
 
 	fep->interrupt = of_irq_to_resource(ofdev->dev.of_node, 0, NULL);
-	if (fep->interrupt == NO_IRQ)
+	if (!fep->interrupt)
 		goto out;
 
 	fep->fcc.fccp = of_iomap(ofdev->dev.of_node, 0);
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
index b9fbc83..b966122 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
@@ -99,7 +99,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 	struct platform_device *ofdev = to_platform_device(fep->dev);
 
 	fep->interrupt = of_irq_to_resource(ofdev->dev.of_node, 0, NULL);
-	if (fep->interrupt == NO_IRQ)
+	if (!fep->interrupt)
 		return -EINVAL;
 
 	fep->fec.fecp = of_iomap(ofdev->dev.of_node, 0);
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
index 22a02a7..4a23691 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
@@ -99,7 +99,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 	struct platform_device *ofdev = to_platform_device(fep->dev);
 
 	fep->interrupt = of_irq_to_resource(ofdev->dev.of_node, 0, NULL);
-	if (fep->interrupt == NO_IRQ)
+	if (!fep->interrupt)
 		return -EINVAL;
 
 	fep->scc.sccp = of_iomap(ofdev->dev.of_node, 0);
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index e01cdaa..90d69b6 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -574,9 +574,9 @@ static int gfar_parse_group(struct device_node *np,
 			irq_of_parse_and_map(np, 1);
 		priv->gfargrp[priv->num_grps].interruptError =
 			irq_of_parse_and_map(np,2);
-		if (priv->gfargrp[priv->num_grps].interruptTransmit == NO_IRQ ||
-		    priv->gfargrp[priv->num_grps].interruptReceive  == NO_IRQ ||
-		    priv->gfargrp[priv->num_grps].interruptError    == NO_IRQ)
+		if (!priv->gfargrp[priv->num_grps].interruptTransmit ||
+		    !priv->gfargrp[priv->num_grps].interruptReceive ||
+		    !priv->gfargrp[priv->num_grps].interruptError)
 			return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ptp.c b/drivers/net/ethernet/freescale/gianfar_ptp.c
index 83e0ed7..8f700ec 100644
--- a/drivers/net/ethernet/freescale/gianfar_ptp.c
+++ b/drivers/net/ethernet/freescale/gianfar_ptp.c
@@ -464,7 +464,7 @@ static int gianfar_ptp_probe(struct platform_device *dev)
 
 	etsects->irq = platform_get_irq(dev, 0);
 
-	if (etsects->irq == NO_IRQ) {
+	if (!etsects->irq) {
 		pr_err("irq not in device tree\n");
 		goto no_node;
 	}
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 2abce96..3450581 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2731,7 +2731,7 @@ static int __devinit emac_probe(struct platform_device *ofdev)
 	/* Get interrupts. EMAC irq is mandatory, WOL irq is optional */
 	dev->emac_irq = irq_of_parse_and_map(np, 0);
 	dev->wol_irq = irq_of_parse_and_map(np, 1);
-	if (dev->emac_irq == NO_IRQ) {
+	if (!dev->emac_irq) {
 		printk(KERN_ERR "%s: Can't map main interrupt\n", np->full_name);
 		goto err_free;
 	}
@@ -2887,9 +2887,9 @@ static int __devinit emac_probe(struct platform_device *ofdev)
  err_reg_unmap:
 	iounmap(dev->emacp);
  err_irq_unmap:
-	if (dev->wol_irq != NO_IRQ)
+	if (dev->wol_irq)
 		irq_dispose_mapping(dev->wol_irq);
-	if (dev->emac_irq != NO_IRQ)
+	if (dev->emac_irq)
 		irq_dispose_mapping(dev->emac_irq);
  err_free:
 	free_netdev(ndev);
@@ -2933,9 +2933,9 @@ static int __devexit emac_remove(struct platform_device *ofdev)
 	emac_dbg_unregister(dev);
 	iounmap(dev->emacp);
 
-	if (dev->wol_irq != NO_IRQ)
+	if (dev->wol_irq)
 		irq_dispose_mapping(dev->wol_irq);
-	if (dev->emac_irq != NO_IRQ)
+	if (dev->emac_irq)
 		irq_dispose_mapping(dev->emac_irq);
 
 	free_netdev(dev->ndev);
diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index f3c50b9..e605fcb 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -600,9 +600,8 @@ static int __devinit mal_probe(struct platform_device *ofdev)
 		mal->rxde_irq = irq_of_parse_and_map(ofdev->dev.of_node, 4);
 	}
 
-	if (mal->txeob_irq == NO_IRQ || mal->rxeob_irq == NO_IRQ ||
-	    mal->serr_irq == NO_IRQ || mal->txde_irq == NO_IRQ ||
-	    mal->rxde_irq == NO_IRQ) {
+	if (!mal->txeob_irq || !mal->rxeob_irq || !mal->serr_irq ||
+	    !mal->txde_irq || !mal->rxde_irq) {
 		printk(KERN_ERR
 		       "mal%d: failed to map interrupts !\n", index);
 		err = -ENODEV;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 5ee82a7..e1891ed 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1796,7 +1796,7 @@ fail_alloc_rx:
 	gelic_card_free_chain(card, card->tx_chain.head);
 fail_alloc_tx:
 	free_irq(card->irq, card);
-	netdev->irq = NO_IRQ;
+	netdev->irq = 0;
 fail_request_irq:
 	ps3_sb_event_receive_port_destroy(dev, card->irq);
 fail_alloc_irq:
@@ -1848,7 +1848,7 @@ static int ps3_gelic_driver_remove(struct ps3_system_bus_device *dev)
 	netdev0 = card->netdev[GELIC_PORT_ETHERNET_0];
 	/* disconnect event port */
 	free_irq(card->irq, card);
-	netdev0->irq = NO_IRQ;
+	netdev0->irq = 0;
 	ps3_sb_event_receive_port_destroy(card->dev, card->irq);
 
 	wait_event(card->waitq,
diff --git a/drivers/ps3/ps3-vuart.c b/drivers/ps3/ps3-vuart.c
index fb73008..79ef207 100644
--- a/drivers/ps3/ps3-vuart.c
+++ b/drivers/ps3/ps3-vuart.c
@@ -965,7 +965,7 @@ static int ps3_vuart_bus_interrupt_get(void)
 
 fail_request_irq:
 	ps3_vuart_irq_destroy(vuart_bus_priv.virq);
-	vuart_bus_priv.virq = NO_IRQ;
+	vuart_bus_priv.virq = 0;
 fail_alloc_irq:
 	kfree(vuart_bus_priv.bmp);
 	vuart_bus_priv.bmp = NULL;
@@ -989,7 +989,7 @@ static int ps3_vuart_bus_interrupt_put(void)
 	free_irq(vuart_bus_priv.virq, &vuart_bus_priv);
 
 	ps3_vuart_irq_destroy(vuart_bus_priv.virq);
-	vuart_bus_priv.virq = NO_IRQ;
+	vuart_bus_priv.virq = 0;
 
 	kfree(vuart_bus_priv.bmp);
 	vuart_bus_priv.bmp = NULL;
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index b418947..a5b6a9c 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1193,7 +1193,7 @@ static int cpm_uart_init_port(struct device_node *np,
 	spin_lock_init(&pinfo->port.lock);
 
 	pinfo->port.irq = of_irq_to_resource(np, 0, NULL);
-	if (pinfo->port.irq == NO_IRQ) {
+	if (!pinfo->port.irq) {
 		ret = -EINVAL;
 		goto out_pram;
 	}
diff --git a/drivers/tty/serial/mpc52xx_uart.c b/drivers/tty/serial/mpc52xx_uart.c
index 1093a88..c7cbc5a 100644
--- a/drivers/tty/serial/mpc52xx_uart.c
+++ b/drivers/tty/serial/mpc52xx_uart.c
@@ -507,7 +507,7 @@ static int __init mpc512x_psc_fifoc_init(void)
 
 	psc_fifoc_irq = irq_of_parse_and_map(np, 0);
 	of_node_put(np);
-	if (psc_fifoc_irq == NO_IRQ) {
+	if (!psc_fifoc_irq) {
 		pr_err("%s: Can't get FIFOC irq\n", __func__);
 		iounmap(psc_fifoc);
 		return -ENODEV;
@@ -1354,7 +1354,7 @@ static int __devinit mpc52xx_uart_of_probe(struct platform_device *op)
 	}
 
 	psc_ops->get_irq(port, op->dev.of_node);
-	if (port->irq == NO_IRQ) {
+	if (!port->irq) {
 		dev_dbg(&op->dev, "Could not get irq\n");
 		return -EINVAL;
 	}
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index e9c2dfe4..be6f57e 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1506,8 +1506,7 @@ no_dma:
 	 * fixed up interrupt info, but we use the device-tree directly
 	 * here due to early probing so we need the fixup too.
 	 */
-	if (uap->port.irq == NO_IRQ &&
-	    np->parent && np->parent->parent &&
+	if (!uap->port.irq && np->parent && np->parent->parent &&
 	    of_device_is_compatible(np->parent->parent, "gatwick")) {
 		/* IRQs on gatwick are offset by 64 */
 		uap->port.irq = irq_create_mapping(NULL, 64 + 15);
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 2ebe606..d3c9877 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -1360,7 +1360,7 @@ static int ucc_uart_probe(struct platform_device *ofdev)
 	}
 
 	qe_port->port.irq = irq_of_parse_and_map(np, 0);
-	if (qe_port->port.irq == NO_IRQ) {
+	if (!qe_port->port.irq) {
 		dev_err(&ofdev->dev, "could not map IRQ for UCC%u\n",
 		       qe_port->ucc_num + 1);
 		ret = -EINVAL;
diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index 32793ce..9c2cc46 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -183,7 +183,7 @@ static int __devinit ehci_hcd_xilinx_of_probe(struct platform_device *op)
 	}
 
 	irq = irq_of_parse_and_map(dn, 0);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_irq;
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index d24cc89d..d9df42e 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -119,7 +119,7 @@ static int __devinit ohci_hcd_ppc_of_probe(struct platform_device *op)
 	}
 
 	irq = irq_of_parse_and_map(dn, 0);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_irq;
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 4939e0c..6747942 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -846,7 +846,7 @@ static int __init fsl_hypervisor_init(void)
 
 		handle = of_get_property(np, "interrupts", NULL);
 		irq = irq_of_parse_and_map(np, 0);
-		if (!handle || (irq == NO_IRQ)) {
+		if (!handle || !irq) {
 			pr_err("fsl-hv: no 'interrupts' property in %s node\n",
 				np->full_name);
 			continue;
diff --git a/sound/aoa/core/gpio-feature.c b/sound/aoa/core/gpio-feature.c
index faa3174..e13a705 100644
--- a/sound/aoa/core/gpio-feature.c
+++ b/sound/aoa/core/gpio-feature.c
@@ -114,10 +114,7 @@ static struct device_node *get_gpio(char *name,
 
 static void get_irq(struct device_node * np, int *irqptr)
 {
-	if (np)
-		*irqptr = irq_of_parse_and_map(np, 0);
-	else
-		*irqptr = NO_IRQ;
+	*irqptr = np ? irq_of_parse_and_map(np, 0) : 0;
 }
 
 /* 0x4 is outenable, 0x1 is out, thus 4 or 5 */
diff --git a/sound/ppc/tumbler.c b/sound/ppc/tumbler.c
index 9cea84c..a3c8ddd 100644
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -1307,19 +1307,19 @@ static int __devinit tumbler_init(struct snd_pmac *chip)
 				    &mix->line_mute, 1);
 	irq = tumbler_find_device("headphone-detect",
 				  NULL, &mix->hp_detect, 0);
-	if (irq <= NO_IRQ)
+	if (!irq)
 		irq = tumbler_find_device("headphone-detect",
 					  NULL, &mix->hp_detect, 1);
-	if (irq <= NO_IRQ)
+	if (!irq)
 		irq = tumbler_find_device("keywest-gpio15",
 					  NULL, &mix->hp_detect, 1);
 	mix->headphone_irq = irq;
  	irq = tumbler_find_device("line-output-detect",
 				  NULL, &mix->line_detect, 0);
- 	if (irq <= NO_IRQ)
+	if (!irq)
 		irq = tumbler_find_device("line-output-detect",
 					  NULL, &mix->line_detect, 1);
-	if (IS_G4DA && irq <= NO_IRQ)
+	if (IS_G4DA && !irq)
 		irq = tumbler_find_device("keywest-gpio16",
 					  NULL, &mix->line_detect, 1);
 	mix->lineout_irq = irq;
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 3e06696..55c6ff9 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -666,7 +666,7 @@ static int __devinit fsl_ssi_probe(struct platform_device *pdev)
 	ssi_private->ssi_phys = res.start;
 
 	ssi_private->irq = irq_of_parse_and_map(np, 0);
-	if (ssi_private->irq == NO_IRQ) {
+	if (!ssi_private->irq) {
 		dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
 		ret = -ENXIO;
 		goto error_iomap;
-- 
1.7.5.4

