Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2K3LHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:07:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2K3LH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:07:27 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-9b-50b8936d096a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] ata_piix: re-oder code and remove prototypes
Date: Fri, 30 Nov 2012 11:56:04 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-version: 1.0
Message-id: <201211301156.04953.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQd3cyTsCDJ5dlLY4tuMRk8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo4cuU7W8HHpIoNP4+yNDAu9O9i5OSQEDCR6DjTzwRh
	i0lcuLeerYuRi0NIYDqjxOxX01ggnBYmif1/t7OAVLEJWElMbF/FCGKLCChL/FjZBmYLC9hK
	TH80GWwSi4CqxI9dx1hBbFEBB4nOqRPYQGxmAWuJra3T2EFsXgFBiR+T77FA2JYS12+9Y4Go
	0ZJofrOJEcKWl9i85i3zBEa+WUhaZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4OB6JrWDcWWDxSFGAQ5GJR7eDRu2BwixJpYVV+YeYpTgYFYS4d0nuCNAiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOG+zR0qAkEB6YklqdmpqQWoRTJaJg1OqgfGI2J/9df1a+SyLfoUXlN/K
	LWDLlv75d3Pu5PDD8xsU3Ge8bbm7cGN43J0oFUufHd+jzkep3fzd76s9bXMQq9Llv3OSdbIV
	z131XLTFerHER/c24dSlIlwNEzN/c09PL7MV8fhyj/fgJrPupcfP/BG8Lv3oirBN/XoNz4TA
	b9NlpM7uT1thf02JpTgj0VCLuag4EQCDAZoxKgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] ata_piix: re-oder code and remove prototypes

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Jeff, please apply.  Thanks!

 drivers/ata/ata_piix.c |  419 +++++++++++++++++++++++--------------------------
 1 file changed, 198 insertions(+), 221 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c	2012-11-28 18:53:41.469707219 +0100
+++ b/drivers/ata/ata_piix.c	2012-11-28 19:00:44.513715161 +0100
@@ -164,28 +164,6 @@ struct piix_host_priv {
 	void __iomem *sidpr;
 };
 
-static int piix_init_one(struct pci_dev *pdev,
-			 const struct pci_device_id *ent);
-static void piix_remove_one(struct pci_dev *pdev);
-static int piix_pata_prereset(struct ata_link *link, unsigned long deadline);
-static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev);
-static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
-static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
-static int ich_pata_cable_detect(struct ata_port *ap);
-static u8 piix_vmw_bmdma_status(struct ata_port *ap);
-static int piix_sidpr_scr_read(struct ata_link *link,
-			       unsigned int reg, u32 *val);
-static int piix_sidpr_scr_write(struct ata_link *link,
-				unsigned int reg, u32 val);
-static int piix_sidpr_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
-			      unsigned hints);
-static bool piix_irq_check(struct ata_port *ap);
-static int piix_port_start(struct ata_port *ap);
-#ifdef CONFIG_PM
-static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int piix_pci_device_resume(struct pci_dev *pdev);
-#endif
-
 static unsigned int in_module_init = 1;
 
 static const struct pci_device_id piix_pci_tbl[] = {
@@ -342,64 +320,6 @@ static const struct pci_device_id piix_p
 	{ }	/* terminate list */
 };
 
-static struct pci_driver piix_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= piix_pci_tbl,
-	.probe			= piix_init_one,
-	.remove			= piix_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= piix_pci_device_suspend,
-	.resume			= piix_pci_device_resume,
-#endif
-};
-
-static struct scsi_host_template piix_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-};
-
-static struct ata_port_operations piix_sata_ops = {
-	.inherits		= &ata_bmdma32_port_ops,
-	.sff_irq_check		= piix_irq_check,
-	.port_start		= piix_port_start,
-};
-
-static struct ata_port_operations piix_pata_ops = {
-	.inherits		= &piix_sata_ops,
-	.cable_detect		= ata_cable_40wire,
-	.set_piomode		= piix_set_piomode,
-	.set_dmamode		= piix_set_dmamode,
-	.prereset		= piix_pata_prereset,
-};
-
-static struct ata_port_operations piix_vmw_ops = {
-	.inherits		= &piix_pata_ops,
-	.bmdma_status		= piix_vmw_bmdma_status,
-};
-
-static struct ata_port_operations ich_pata_ops = {
-	.inherits		= &piix_pata_ops,
-	.cable_detect		= ich_pata_cable_detect,
-	.set_dmamode		= ich_set_dmamode,
-};
-
-static struct device_attribute *piix_sidpr_shost_attrs[] = {
-	&dev_attr_link_power_management_policy,
-	NULL
-};
-
-static struct scsi_host_template piix_sidpr_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-	.shost_attrs		= piix_sidpr_shost_attrs,
-};
-
-static struct ata_port_operations piix_sidpr_sata_ops = {
-	.inherits		= &piix_sata_ops,
-	.hardreset		= sata_std_hardreset,
-	.scr_read		= piix_sidpr_scr_read,
-	.scr_write		= piix_sidpr_scr_write,
-	.set_lpm		= piix_sidpr_set_lpm,
-};
-
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -504,147 +424,6 @@ static const struct piix_map_db *piix_ma
 	[ich8_sata_snb]		= &ich8_map_db,
 };
 
-static struct ata_port_info piix_port_info[] = {
-	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.port_ops	= &piix_pata_ops,
-	},
-
-	[piix_pata_33] =	/* PIIX4 at 33MHz */
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &piix_pata_ops,
-	},
-
-	[ich_pata_33] = 	/* ICH0 - ICH at 33Mhz*/
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask 	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* Check: maybe MWDMA0 is ok  */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &ich_pata_ops,
-	},
-
-	[ich_pata_66] = 	/* ICH controllers up to 66MHz */
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask 	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
-		.udma_mask	= ATA_UDMA4,
-		.port_ops	= &ich_pata_ops,
-	},
-
-	[ich_pata_100] =
-	{
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask	= ATA_UDMA5,
-		.port_ops	= &ich_pata_ops,
-	},
-
-	[ich_pata_100_nomwdma1] =
-	{
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2_ONLY,
-		.udma_mask	= ATA_UDMA5,
-		.port_ops	= &ich_pata_ops,
-	},
-
-	[ich5_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich6_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich6m_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich8_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich8_2port_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[tolapai_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich8m_apple_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[piix_pata_vmw] =
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &piix_vmw_ops,
-	},
-
-	/*
-	 * some Sandybridge chipsets have broken 32 mode up to now,
-	 * see https://bugzilla.kernel.org/show_bug.cgi?id=40592
-	 */
-	[ich8_sata_snb] =
-	{
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-};
-
 static struct pci_bits piix_enable_bits[] = {
 	{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
 	{ 0x43U, 1U, 0x80UL, 0x80UL },	/* port 1 */
@@ -1261,6 +1040,193 @@ static u8 piix_vmw_bmdma_status(struct a
 	return ata_bmdma_status(ap) & ~ATA_DMA_ERR;
 }
 
+static struct scsi_host_template piix_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations piix_sata_ops = {
+	.inherits		= &ata_bmdma32_port_ops,
+	.sff_irq_check		= piix_irq_check,
+	.port_start		= piix_port_start,
+};
+
+static struct ata_port_operations piix_pata_ops = {
+	.inherits		= &piix_sata_ops,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+	.prereset		= piix_pata_prereset,
+};
+
+static struct ata_port_operations piix_vmw_ops = {
+	.inherits		= &piix_pata_ops,
+	.bmdma_status		= piix_vmw_bmdma_status,
+};
+
+static struct ata_port_operations ich_pata_ops = {
+	.inherits		= &piix_pata_ops,
+	.cable_detect		= ich_pata_cable_detect,
+	.set_dmamode		= ich_set_dmamode,
+};
+
+static struct device_attribute *piix_sidpr_shost_attrs[] = {
+	&dev_attr_link_power_management_policy,
+	NULL
+};
+
+static struct scsi_host_template piix_sidpr_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+	.shost_attrs		= piix_sidpr_shost_attrs,
+};
+
+static struct ata_port_operations piix_sidpr_sata_ops = {
+	.inherits		= &piix_sata_ops,
+	.hardreset		= sata_std_hardreset,
+	.scr_read		= piix_sidpr_scr_read,
+	.scr_write		= piix_sidpr_scr_write,
+	.set_lpm		= piix_sidpr_set_lpm,
+};
+
+static struct ata_port_info piix_port_info[] = {
+	[piix_pata_mwdma] =	/* PIIX3 MWDMA only */
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.port_ops	= &piix_pata_ops,
+	},
+
+	[piix_pata_33] =	/* PIIX4 at 33MHz */
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &piix_pata_ops,
+	},
+
+	[ich_pata_33] =		/* ICH0 - ICH at 33Mhz*/
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* Check: maybe MWDMA0 is ok  */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich_pata_66] =		/* ICH controllers up to 66MHz */
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
+		.udma_mask	= ATA_UDMA4,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich_pata_100] =
+	{
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA5,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich_pata_100_nomwdma1] =
+	{
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2_ONLY,
+		.udma_mask	= ATA_UDMA5,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich5_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich6_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich6m_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich8_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich8_2port_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[tolapai_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich8m_apple_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[piix_pata_vmw] =
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &piix_vmw_ops,
+	},
+
+	/*
+	 * some Sandybridge chipsets have broken 32 mode up to now,
+	 * see https://bugzilla.kernel.org/show_bug.cgi?id=40592
+	 */
+	[ich8_sata_snb] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+};
+
 #define AHCI_PCI_BAR 5
 #define AHCI_GLOBAL_CTL 0x04
 #define AHCI_ENABLE (1 << 31)
@@ -1727,6 +1693,17 @@ static void piix_remove_one(struct pci_d
 	ata_pci_remove_one(pdev);
 }
 
+static struct pci_driver piix_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= piix_pci_tbl,
+	.probe			= piix_init_one,
+	.remove			= piix_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= piix_pci_device_suspend,
+	.resume			= piix_pci_device_resume,
+#endif
+};
+
 static int __init piix_init(void)
 {
 	int rc;
