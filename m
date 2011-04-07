Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1DGWTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:19:06 -0400
Received: from zucker.schokokeks.org ([178.63.68.96]:43968 "EHLO
	zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab1DGWTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:19:04 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Apr 2011 18:19:03 EDT
Date: Fri, 8 Apr 2011 00:13:55 +0200
From: Hanno =?ISO-8859-1?B?QvZjaw==?= <hanno@hboeck.de>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] constify functions in drivers/ata
Message-ID: <20110408001355.796fb5bb@laverne>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-27406-1302214437-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-27406-1302214437-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Attached patch will const-ify lots of functions within drivers/ata.

Patch is an extract from grsecurity. Please apply.


Signed-off-by: Hanno Boeck <hanno@hboeck.de>
---
diff -Naur linux-2.6.38/drivers/ata//acard-ahci.c linux-2.6.38-ata/drivers/=
ata//acard-ahci.c
--- linux-2.6.38/drivers/ata//acard-ahci.c	2011-03-15 02:20:32.000000000 +0=
100
+++ linux-2.6.38-ata/drivers/ata//acard-ahci.c	2011-04-08 00:02:57.65688080=
7 +0200
@@ -87,7 +87,7 @@
 	AHCI_SHT("acard-ahci"),
 };
=20
-static struct ata_port_operations acard_ops =3D {
+static const struct ata_port_operations acard_ops =3D {
 	.inherits		=3D &ahci_ops,
 	.qc_prep		=3D acard_ahci_qc_prep,
 	.qc_fill_rtf		=3D acard_ahci_qc_fill_rtf,
diff -Naur linux-2.6.38/drivers/ata//ahci.c linux-2.6.38-ata/drivers/ata//a=
hci.c
--- linux-2.6.38/drivers/ata//ahci.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//ahci.c	2011-04-08 00:02:57.669880734 +0200
@@ -94,17 +94,17 @@
 	AHCI_SHT("ahci"),
 };
=20
-static struct ata_port_operations ahci_vt8251_ops =3D {
+static const struct ata_port_operations ahci_vt8251_ops =3D {
 	.inherits		=3D &ahci_ops,
 	.hardreset		=3D ahci_vt8251_hardreset,
 };
=20
-static struct ata_port_operations ahci_p5wdh_ops =3D {
+static const struct ata_port_operations ahci_p5wdh_ops =3D {
 	.inherits		=3D &ahci_ops,
 	.hardreset		=3D ahci_p5wdh_hardreset,
 };
=20
-static struct ata_port_operations ahci_sb600_ops =3D {
+static const struct ata_port_operations ahci_sb600_ops =3D {
 	.inherits		=3D &ahci_ops,
 	.softreset		=3D ahci_sb600_softreset,
 	.pmp_softreset		=3D ahci_sb600_softreset,
diff -Naur linux-2.6.38/drivers/ata//ahci.h linux-2.6.38-ata/drivers/ata//a=
hci.h
--- linux-2.6.38/drivers/ata//ahci.h	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//ahci.h	2011-04-08 00:02:57.671880724 +0200
@@ -309,7 +309,7 @@
 	.shost_attrs		=3D ahci_shost_attrs,			\
 	.sdev_attrs		=3D ahci_sdev_attrs
=20
-extern struct ata_port_operations ahci_ops;
+extern const struct ata_port_operations ahci_ops;
=20
 void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			u32 opts);
diff -Naur linux-2.6.38/drivers/ata//ata_generic.c linux-2.6.38-ata/drivers=
/ata//ata_generic.c
--- linux-2.6.38/drivers/ata//ata_generic.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//ata_generic.c	2011-04-08 00:02:57.6718807=
24 +0200
@@ -101,7 +101,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations generic_port_ops =3D {
+static const struct ata_port_operations generic_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D ata_cable_unknown,
 	.set_mode	=3D generic_set_mode,
diff -Naur linux-2.6.38/drivers/ata//ata_piix.c linux-2.6.38-ata/drivers/at=
a//ata_piix.c
--- linux-2.6.38/drivers/ata//ata_piix.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//ata_piix.c	2011-04-08 00:02:57.671880724 =
+0200
@@ -327,12 +327,12 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations piix_sata_ops =3D {
+static const struct ata_port_operations piix_sata_ops =3D {
 	.inherits		=3D &ata_bmdma32_port_ops,
 	.sff_irq_check		=3D piix_irq_check,
 };
=20
-static struct ata_port_operations piix_pata_ops =3D {
+static const struct ata_port_operations piix_pata_ops =3D {
 	.inherits		=3D &piix_sata_ops,
 	.cable_detect		=3D ata_cable_40wire,
 	.set_piomode		=3D piix_set_piomode,
@@ -340,12 +340,12 @@
 	.prereset		=3D piix_pata_prereset,
 };
=20
-static struct ata_port_operations piix_vmw_ops =3D {
+static const struct ata_port_operations piix_vmw_ops =3D {
 	.inherits		=3D &piix_pata_ops,
 	.bmdma_status		=3D piix_vmw_bmdma_status,
 };
=20
-static struct ata_port_operations ich_pata_ops =3D {
+static const struct ata_port_operations ich_pata_ops =3D {
 	.inherits		=3D &piix_pata_ops,
 	.cable_detect		=3D ich_pata_cable_detect,
 	.set_dmamode		=3D ich_set_dmamode,
@@ -361,7 +361,7 @@
 	.shost_attrs		=3D piix_sidpr_shost_attrs,
 };
=20
-static struct ata_port_operations piix_sidpr_sata_ops =3D {
+static const struct ata_port_operations piix_sidpr_sata_ops =3D {
 	.inherits		=3D &piix_sata_ops,
 	.hardreset		=3D sata_std_hardreset,
 	.scr_read		=3D piix_sidpr_scr_read,
diff -Naur linux-2.6.38/drivers/ata//libahci.c linux-2.6.38-ata/drivers/ata=
//libahci.c
--- linux-2.6.38/drivers/ata//libahci.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//libahci.c	2011-04-08 00:02:57.672880718 +=
0200
@@ -137,7 +137,7 @@
 };
 EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
=20
-struct ata_port_operations ahci_ops =3D {
+const struct ata_port_operations ahci_ops =3D {
 	.inherits		=3D &sata_pmp_port_ops,
=20
 	.qc_defer		=3D ahci_pmp_qc_defer,
diff -Naur linux-2.6.38/drivers/ata//libata-acpi.c linux-2.6.38-ata/drivers=
/ata//libata-acpi.c
--- linux-2.6.38/drivers/ata//libata-acpi.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//libata-acpi.c	2011-04-08 00:02:57.6798806=
78 +0200
@@ -218,12 +218,12 @@
 	ata_acpi_uevent(dev->link->ap, dev, event);
 }
=20
-static struct acpi_dock_ops ata_acpi_dev_dock_ops =3D {
+static const struct acpi_dock_ops ata_acpi_dev_dock_ops =3D {
 	.handler =3D ata_acpi_dev_notify_dock,
 	.uevent =3D ata_acpi_dev_uevent,
 };
=20
-static struct acpi_dock_ops ata_acpi_ap_dock_ops =3D {
+static const struct acpi_dock_ops ata_acpi_ap_dock_ops =3D {
 	.handler =3D ata_acpi_ap_notify_dock,
 	.uevent =3D ata_acpi_ap_uevent,
 };
diff -Naur linux-2.6.38/drivers/ata//libata-core.c linux-2.6.38-ata/drivers=
/ata//libata-core.c
--- linux-2.6.38/drivers/ata//libata-core.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//libata-core.c	2011-04-08 00:02:57.6848806=
50 +0200
@@ -5755,7 +5755,7 @@
  *	LOCKING:
  *	None.
  */
-static void ata_finalize_port_ops(struct ata_port_operations *ops)
+static void ata_finalize_port_ops(const struct ata_port_operations *ops)
 {
 	static DEFINE_SPINLOCK(lock);
 	const struct ata_port_operations *cur;
@@ -5878,7 +5878,7 @@
  */
 /* KILLME - the only user left is ipr */
 void ata_host_init(struct ata_host *host, struct device *dev,
-		   unsigned long flags, struct ata_port_operations *ops)
+		   unsigned long flags, const struct ata_port_operations *ops)
 {
 	spin_lock_init(&host->lock);
 	mutex_init(&host->eh_mutex);
@@ -6584,7 +6584,7 @@
 	/* truly dummy */
 }
=20
-struct ata_port_operations ata_dummy_port_ops =3D {
+const struct ata_port_operations ata_dummy_port_ops =3D {
 	.qc_prep		=3D ata_noop_qc_prep,
 	.qc_issue		=3D ata_dummy_qc_issue,
 	.error_handler		=3D ata_dummy_error_handler,
diff -Naur linux-2.6.38/drivers/ata//libata-eh.c linux-2.6.38-ata/drivers/a=
ta//libata-eh.c
--- linux-2.6.38/drivers/ata//libata-eh.c	2011-03-15 02:20:32.000000000 +01=
00
+++ linux-2.6.38-ata/drivers/ata//libata-eh.c	2011-04-08 00:02:57.697880575=
 +0200
@@ -3880,7 +3880,7 @@
  */
 void ata_std_error_handler(struct ata_port *ap)
 {
-	struct ata_port_operations *ops =3D ap->ops;
+	const struct ata_port_operations *ops =3D ap->ops;
 	ata_reset_fn_t hardreset =3D ops->hardreset;
=20
 	/* ignore built-in hardreset if SCR access is not available */
diff -Naur linux-2.6.38/drivers/ata//libata-pmp.c linux-2.6.38-ata/drivers/=
ata//libata-pmp.c
--- linux-2.6.38/drivers/ata//libata-pmp.c	2011-03-15 02:20:32.000000000 +0=
100
+++ linux-2.6.38-ata/drivers/ata//libata-pmp.c	2011-04-08 00:02:57.69788057=
5 +0200
@@ -912,7 +912,7 @@
  */
 static int sata_pmp_eh_recover(struct ata_port *ap)
 {
-	struct ata_port_operations *ops =3D ap->ops;
+	const struct ata_port_operations *ops =3D ap->ops;
 	int pmp_tries, link_tries[SATA_PMP_MAX_PORTS];
 	struct ata_link *pmp_link =3D &ap->link;
 	struct ata_device *pmp_dev =3D pmp_link->device;
diff -Naur linux-2.6.38/drivers/ata//pata_acpi.c linux-2.6.38-ata/drivers/a=
ta//pata_acpi.c
--- linux-2.6.38/drivers/ata//pata_acpi.c	2011-03-15 02:20:32.000000000 +01=
00
+++ linux-2.6.38-ata/drivers/ata//pata_acpi.c	2011-04-08 00:02:57.697880575=
 +0200
@@ -216,7 +216,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations pacpi_ops =3D {
+static const struct ata_port_operations pacpi_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.qc_issue		=3D pacpi_qc_issue,
 	.cable_detect		=3D pacpi_cable_detect,
diff -Naur linux-2.6.38/drivers/ata//pata_ali.c linux-2.6.38-ata/drivers/at=
a//pata_ali.c
--- linux-2.6.38/drivers/ata//pata_ali.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_ali.c	2011-04-08 00:02:57.699880564 =
+0200
@@ -363,7 +363,7 @@
  *	Port operations for PIO only ALi
  */
=20
-static struct ata_port_operations ali_early_port_ops =3D {
+static const struct ata_port_operations ali_early_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	.set_piomode	=3D ali_set_piomode,
@@ -380,7 +380,7 @@
  *	Port operations for DMA capable ALi without cable
  *	detect
  */
-static struct ata_port_operations ali_20_port_ops =3D {
+static const struct ata_port_operations ali_20_port_ops =3D {
 	.inherits	=3D &ali_dma_base_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	.mode_filter	=3D ali_20_filter,
@@ -391,7 +391,7 @@
 /*
  *	Port operations for DMA capable ALi with cable detect
  */
-static struct ata_port_operations ali_c2_port_ops =3D {
+static const struct ata_port_operations ali_c2_port_ops =3D {
 	.inherits	=3D &ali_dma_base_ops,
 	.check_atapi_dma =3D ali_check_atapi_dma,
 	.cable_detect	=3D ali_c2_cable_detect,
@@ -402,7 +402,7 @@
 /*
  *	Port operations for DMA capable ALi with cable detect
  */
-static struct ata_port_operations ali_c4_port_ops =3D {
+static const struct ata_port_operations ali_c4_port_ops =3D {
 	.inherits	=3D &ali_dma_base_ops,
 	.check_atapi_dma =3D ali_check_atapi_dma,
 	.cable_detect	=3D ali_c2_cable_detect,
@@ -412,7 +412,7 @@
 /*
  *	Port operations for DMA capable ALi with cable detect and LBA48
  */
-static struct ata_port_operations ali_c5_port_ops =3D {
+static const struct ata_port_operations ali_c5_port_ops =3D {
 	.inherits	=3D &ali_dma_base_ops,
 	.check_atapi_dma =3D ali_check_atapi_dma,
 	.dev_config	=3D ali_warn_atapi_dma,
diff -Naur linux-2.6.38/drivers/ata//pata_amd.c linux-2.6.38-ata/drivers/at=
a//pata_amd.c
--- linux-2.6.38/drivers/ata//pata_amd.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_amd.c	2011-04-08 00:02:57.707880520 =
+0200
@@ -397,28 +397,28 @@
 	.prereset	=3D amd_pre_reset,
 };
=20
-static struct ata_port_operations amd33_port_ops =3D {
+static const struct ata_port_operations amd33_port_ops =3D {
 	.inherits	=3D &amd_base_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	.set_piomode	=3D amd33_set_piomode,
 	.set_dmamode	=3D amd33_set_dmamode,
 };
=20
-static struct ata_port_operations amd66_port_ops =3D {
+static const struct ata_port_operations amd66_port_ops =3D {
 	.inherits	=3D &amd_base_port_ops,
 	.cable_detect	=3D ata_cable_unknown,
 	.set_piomode	=3D amd66_set_piomode,
 	.set_dmamode	=3D amd66_set_dmamode,
 };
=20
-static struct ata_port_operations amd100_port_ops =3D {
+static const struct ata_port_operations amd100_port_ops =3D {
 	.inherits	=3D &amd_base_port_ops,
 	.cable_detect	=3D ata_cable_unknown,
 	.set_piomode	=3D amd100_set_piomode,
 	.set_dmamode	=3D amd100_set_dmamode,
 };
=20
-static struct ata_port_operations amd133_port_ops =3D {
+static const struct ata_port_operations amd133_port_ops =3D {
 	.inherits	=3D &amd_base_port_ops,
 	.cable_detect	=3D amd_cable_detect,
 	.set_piomode	=3D amd133_set_piomode,
@@ -433,13 +433,13 @@
 	.host_stop	=3D nv_host_stop,
 };
=20
-static struct ata_port_operations nv100_port_ops =3D {
+static const struct ata_port_operations nv100_port_ops =3D {
 	.inherits	=3D &nv_base_port_ops,
 	.set_piomode	=3D nv100_set_piomode,
 	.set_dmamode	=3D nv100_set_dmamode,
 };
=20
-static struct ata_port_operations nv133_port_ops =3D {
+static const struct ata_port_operations nv133_port_ops =3D {
 	.inherits	=3D &nv_base_port_ops,
 	.set_piomode	=3D nv133_set_piomode,
 	.set_dmamode	=3D nv133_set_dmamode,
diff -Naur linux-2.6.38/drivers/ata//pata_artop.c linux-2.6.38-ata/drivers/=
ata//pata_artop.c
--- linux-2.6.38/drivers/ata//pata_artop.c	2011-03-15 02:20:32.000000000 +0=
100
+++ linux-2.6.38-ata/drivers/ata//pata_artop.c	2011-04-08 00:02:57.71388048=
5 +0200
@@ -312,7 +312,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations artop6210_ops =3D {
+static const struct ata_port_operations artop6210_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.cable_detect		=3D ata_cable_40wire,
 	.set_piomode		=3D artop6210_set_piomode,
@@ -321,7 +321,7 @@
 	.qc_defer		=3D artop6210_qc_defer,
 };
=20
-static struct ata_port_operations artop6260_ops =3D {
+static const struct ata_port_operations artop6260_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.cable_detect		=3D artop6260_cable_detect,
 	.set_piomode		=3D artop6260_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_at32.c linux-2.6.38-ata/drivers/a=
ta//pata_at32.c
--- linux-2.6.38/drivers/ata//pata_at32.c	2011-03-15 02:20:32.000000000 +01=
00
+++ linux-2.6.38-ata/drivers/ata//pata_at32.c	2011-04-08 00:02:57.725880417=
 +0200
@@ -173,7 +173,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations at32_port_ops =3D {
+static const struct ata_port_operations at32_port_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
 	.cable_detect		=3D ata_cable_40wire,
 	.set_piomode		=3D pata_at32_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_at91.c linux-2.6.38-ata/drivers/a=
ta//pata_at91.c
--- linux-2.6.38/drivers/ata//pata_at91.c	2011-03-15 02:20:32.000000000 +01=
00
+++ linux-2.6.38-ata/drivers/ata//pata_at91.c	2011-04-08 00:02:57.725880417=
 +0200
@@ -196,7 +196,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations pata_at91_port_ops =3D {
+static const struct ata_port_operations pata_at91_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
=20
 	.sff_data_xfer	=3D pata_at91_data_xfer_noirq,
diff -Naur linux-2.6.38/drivers/ata//pata_atiixp.c linux-2.6.38-ata/drivers=
/ata//pata_atiixp.c
--- linux-2.6.38/drivers/ata//pata_atiixp.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_atiixp.c	2011-04-08 00:02:57.7258804=
17 +0200
@@ -214,7 +214,7 @@
 	.sg_tablesize		=3D LIBATA_DUMB_MAX_PRD,
 };
=20
-static struct ata_port_operations atiixp_port_ops =3D {
+static const struct ata_port_operations atiixp_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
=20
 	.qc_prep 	=3D ata_bmdma_dumb_qc_prep,
diff -Naur linux-2.6.38/drivers/ata//pata_atp867x.c linux-2.6.38-ata/driver=
s/ata//pata_atp867x.c
--- linux-2.6.38/drivers/ata//pata_atp867x.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_atp867x.c	2011-04-08 00:02:57.726880=
412 +0200
@@ -275,7 +275,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations atp867x_ops =3D {
+static const struct ata_port_operations atp867x_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.cable_detect		=3D atp867x_cable_detect,
 	.set_piomode		=3D atp867x_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_bf54x.c linux-2.6.38-ata/drivers/=
ata//pata_bf54x.c
--- linux-2.6.38/drivers/ata//pata_bf54x.c	2011-03-15 02:20:32.000000000 +0=
100
+++ linux-2.6.38-ata/drivers/ata//pata_bf54x.c	2011-04-08 00:02:57.72688041=
2 +0200
@@ -1420,7 +1420,7 @@
 	.dma_boundary		=3D ATA_DMA_BOUNDARY,
 };
=20
-static struct ata_port_operations bfin_pata_ops =3D {
+static const struct ata_port_operations bfin_pata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
=20
 	.set_piomode		=3D bfin_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_cmd640.c linux-2.6.38-ata/drivers=
/ata//pata_cmd640.c
--- linux-2.6.38/drivers/ata//pata_cmd640.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_cmd640.c	2011-04-08 00:02:57.7428803=
21 +0200
@@ -176,7 +176,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations cmd640_port_ops =3D {
+static const struct ata_port_operations cmd640_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	/* In theory xfer_noirq is not needed once we kill the prefetcher */
 	.sff_data_xfer	=3D ata_sff_data_xfer_noirq,
diff -Naur linux-2.6.38/drivers/ata//pata_cmd64x.c linux-2.6.38-ata/drivers=
/ata//pata_cmd64x.c
--- linux-2.6.38/drivers/ata//pata_cmd64x.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_cmd64x.c	2011-04-08 00:02:57.7428803=
21 +0200
@@ -268,18 +268,18 @@
 	.set_dmamode	=3D cmd64x_set_dmamode,
 };
=20
-static struct ata_port_operations cmd64x_port_ops =3D {
+static const struct ata_port_operations cmd64x_port_ops =3D {
 	.inherits	=3D &cmd64x_base_ops,
 	.cable_detect	=3D ata_cable_40wire,
 };
=20
-static struct ata_port_operations cmd646r1_port_ops =3D {
+static const struct ata_port_operations cmd646r1_port_ops =3D {
 	.inherits	=3D &cmd64x_base_ops,
 	.bmdma_stop	=3D cmd646r1_bmdma_stop,
 	.cable_detect	=3D ata_cable_40wire,
 };
=20
-static struct ata_port_operations cmd648_port_ops =3D {
+static const struct ata_port_operations cmd648_port_ops =3D {
 	.inherits	=3D &cmd64x_base_ops,
 	.bmdma_stop	=3D cmd648_bmdma_stop,
 	.cable_detect	=3D cmd648_cable_detect,
diff -Naur linux-2.6.38/drivers/ata//pata_cs5520.c linux-2.6.38-ata/drivers=
/ata//pata_cs5520.c
--- linux-2.6.38/drivers/ata//pata_cs5520.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_cs5520.c	2011-04-08 00:02:57.7428803=
21 +0200
@@ -108,7 +108,7 @@
 	.sg_tablesize		=3D LIBATA_DUMB_MAX_PRD,
 };
=20
-static struct ata_port_operations cs5520_port_ops =3D {
+static const struct ata_port_operations cs5520_port_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.qc_prep		=3D ata_bmdma_dumb_qc_prep,
 	.cable_detect		=3D ata_cable_40wire,
diff -Naur linux-2.6.38/drivers/ata//pata_cs5530.c linux-2.6.38-ata/drivers=
/ata//pata_cs5530.c
--- linux-2.6.38/drivers/ata//pata_cs5530.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_cs5530.c	2011-04-08 00:02:57.7428803=
21 +0200
@@ -164,7 +164,7 @@
 	.sg_tablesize	=3D LIBATA_DUMB_MAX_PRD,
 };
=20
-static struct ata_port_operations cs5530_port_ops =3D {
+static const struct ata_port_operations cs5530_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
=20
 	.qc_prep 	=3D ata_bmdma_dumb_qc_prep,
diff -Naur linux-2.6.38/drivers/ata//pata_cs5535.c linux-2.6.38-ata/drivers=
/ata//pata_cs5535.c
--- linux-2.6.38/drivers/ata//pata_cs5535.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_cs5535.c	2011-04-08 00:02:57.7438803=
15 +0200
@@ -160,7 +160,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations cs5535_port_ops =3D {
+static const struct ata_port_operations cs5535_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D cs5535_cable_detect,
 	.set_piomode	=3D cs5535_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_cs5536.c linux-2.6.38-ata/drivers=
/ata//pata_cs5536.c
--- linux-2.6.38/drivers/ata//pata_cs5536.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_cs5536.c	2011-04-08 00:02:57.7438803=
15 +0200
@@ -233,7 +233,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations cs5536_port_ops =3D {
+static const struct ata_port_operations cs5536_port_ops =3D {
 	.inherits		=3D &ata_bmdma32_port_ops,
 	.cable_detect		=3D cs5536_cable_detect,
 	.set_piomode		=3D cs5536_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_cypress.c linux-2.6.38-ata/driver=
s/ata//pata_cypress.c
--- linux-2.6.38/drivers/ata//pata_cypress.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_cypress.c	2011-04-08 00:02:57.746880=
300 +0200
@@ -115,7 +115,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations cy82c693_port_ops =3D {
+static const struct ata_port_operations cy82c693_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	.set_piomode	=3D cy82c693_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_efar.c linux-2.6.38-ata/drivers/a=
ta//pata_efar.c
--- linux-2.6.38/drivers/ata//pata_efar.c	2011-03-15 02:20:32.000000000 +01=
00
+++ linux-2.6.38-ata/drivers/ata//pata_efar.c	2011-04-08 00:02:57.746880300=
 +0200
@@ -238,7 +238,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations efar_ops =3D {
+static const struct ata_port_operations efar_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.cable_detect		=3D efar_cable_detect,
 	.set_piomode		=3D efar_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_hpt366.c linux-2.6.38-ata/drivers=
/ata//pata_hpt366.c
--- linux-2.6.38/drivers/ata//pata_hpt366.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_hpt366.c	2011-04-08 00:02:57.7468803=
00 +0200
@@ -275,7 +275,7 @@
  *	Configuration for HPT366/68
  */
=20
-static struct ata_port_operations hpt366_port_ops =3D {
+static const struct ata_port_operations hpt366_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D hpt36x_cable_detect,
 	.mode_filter	=3D hpt366_filter,
diff -Naur linux-2.6.38/drivers/ata//pata_hpt37x.c linux-2.6.38-ata/drivers=
/ata//pata_hpt37x.c
--- linux-2.6.38/drivers/ata//pata_hpt37x.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_hpt37x.c	2011-04-08 00:02:57.7588802=
32 +0200
@@ -587,7 +587,7 @@
  *	Configuration for HPT370
  */
=20
-static struct ata_port_operations hpt370_port_ops =3D {
+static const struct ata_port_operations hpt370_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
=20
 	.bmdma_stop	=3D hpt370_bmdma_stop,
@@ -603,7 +603,7 @@
  *	Configuration for HPT370A. Close to 370 but less filters
  */
=20
-static struct ata_port_operations hpt370a_port_ops =3D {
+static const struct ata_port_operations hpt370a_port_ops =3D {
 	.inherits	=3D &hpt370_port_ops,
 	.mode_filter	=3D hpt370a_filter,
 };
@@ -613,7 +613,7 @@
  *	mode setting functionality.
  */
=20
-static struct ata_port_operations hpt302_port_ops =3D {
+static const struct ata_port_operations hpt302_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
=20
 	.bmdma_stop	=3D hpt37x_bmdma_stop,
@@ -629,7 +629,7 @@
  *	but we have a mode filter.
  */
=20
-static struct ata_port_operations hpt372_port_ops =3D {
+static const struct ata_port_operations hpt372_port_ops =3D {
 	.inherits	=3D &hpt302_port_ops,
 	.mode_filter	=3D hpt372_filter,
 };
@@ -639,7 +639,7 @@
  *	but we have a different cable detection procedure for function 1.
  */
=20
-static struct ata_port_operations hpt374_fn1_port_ops =3D {
+static const struct ata_port_operations hpt374_fn1_port_ops =3D {
 	.inherits	=3D &hpt372_port_ops,
 	.cable_detect	=3D hpt374_fn1_cable_detect,
 };
diff -Naur linux-2.6.38/drivers/ata//pata_hpt3x2n.c linux-2.6.38-ata/driver=
s/ata//pata_hpt3x2n.c
--- linux-2.6.38/drivers/ata//pata_hpt3x2n.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_hpt3x2n.c	2011-04-08 00:02:57.758880=
232 +0200
@@ -348,7 +348,7 @@
  *	Configuration for HPT302N/371N.
  */
=20
-static struct ata_port_operations hpt3xxn_port_ops =3D {
+static const struct ata_port_operations hpt3xxn_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
=20
 	.bmdma_stop	=3D hpt3x2n_bmdma_stop,
@@ -366,7 +366,7 @@
  *	Configuration for HPT372N. Same as 302N/371N but we have a mode filter.
  */
=20
-static struct ata_port_operations hpt372n_port_ops =3D {
+static const struct ata_port_operations hpt372n_port_ops =3D {
 	.inherits	=3D &hpt3xxn_port_ops,
 	.mode_filter	=3D &hpt372n_filter,
 };
diff -Naur linux-2.6.38/drivers/ata//pata_hpt3x3.c linux-2.6.38-ata/drivers=
/ata//pata_hpt3x3.c
--- linux-2.6.38/drivers/ata//pata_hpt3x3.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_hpt3x3.c	2011-04-08 00:02:57.7588802=
32 +0200
@@ -141,7 +141,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations hpt3x3_port_ops =3D {
+static const struct ata_port_operations hpt3x3_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	.set_piomode	=3D hpt3x3_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_icside.c linux-2.6.38-ata/drivers=
/ata//pata_icside.c
--- linux-2.6.38/drivers/ata//pata_icside.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_icside.c	2011-04-08 00:02:57.7598802=
27 +0200
@@ -320,7 +320,7 @@
 	}
 }
=20
-static struct ata_port_operations pata_icside_port_ops =3D {
+static const struct ata_port_operations pata_icside_port_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	/* no need to build any PRD tables for DMA */
 	.qc_prep		=3D ata_noop_qc_prep,
diff -Naur linux-2.6.38/drivers/ata//pata_isapnp.c linux-2.6.38-ata/drivers=
/ata//pata_isapnp.c
--- linux-2.6.38/drivers/ata//pata_isapnp.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_isapnp.c	2011-04-08 00:02:57.7598802=
27 +0200
@@ -23,12 +23,12 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations isapnp_port_ops =3D {
+static const struct ata_port_operations isapnp_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 };
=20
-static struct ata_port_operations isapnp_noalt_port_ops =3D {
+static const struct ata_port_operations isapnp_noalt_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	/* No altstatus so we don't want to use the lost interrupt poll */
diff -Naur linux-2.6.38/drivers/ata//pata_it8213.c linux-2.6.38-ata/drivers=
/ata//pata_it8213.c
--- linux-2.6.38/drivers/ata//pata_it8213.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_it8213.c	2011-04-08 00:02:57.7598802=
27 +0200
@@ -233,7 +233,7 @@
 };
=20
=20
-static struct ata_port_operations it8213_ops =3D {
+static const struct ata_port_operations it8213_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.cable_detect		=3D it8213_cable_detect,
 	.set_piomode		=3D it8213_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_it821x.c linux-2.6.38-ata/drivers=
/ata//pata_it821x.c
--- linux-2.6.38/drivers/ata//pata_it821x.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_it821x.c	2011-04-08 00:02:57.7608802=
22 +0200
@@ -801,7 +801,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations it821x_smart_port_ops =3D {
+static const struct ata_port_operations it821x_smart_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
=20
 	.check_atapi_dma=3D it821x_check_atapi_dma,
@@ -815,7 +815,7 @@
 	.port_start	=3D it821x_port_start,
 };
=20
-static struct ata_port_operations it821x_passthru_port_ops =3D {
+static const struct ata_port_operations it821x_passthru_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
=20
 	.check_atapi_dma=3D it821x_check_atapi_dma,
@@ -831,7 +831,7 @@
 	.port_start	=3D it821x_port_start,
 };
=20
-static struct ata_port_operations it821x_rdc_port_ops =3D {
+static const struct ata_port_operations it821x_rdc_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
=20
 	.check_atapi_dma=3D it821x_check_atapi_dma,
diff -Naur linux-2.6.38/drivers/ata//pata_ixp4xx_cf.c linux-2.6.38-ata/driv=
ers/ata//pata_ixp4xx_cf.c
--- linux-2.6.38/drivers/ata//pata_ixp4xx_cf.c	2011-03-15 02:20:32.00000000=
0 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_ixp4xx_cf.c	2011-04-08 00:02:57.7608=
80222 +0200
@@ -89,7 +89,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations ixp4xx_port_ops =3D {
+static const struct ata_port_operations ixp4xx_port_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
 	.sff_data_xfer		=3D ixp4xx_mmio_data_xfer,
 	.cable_detect		=3D ata_cable_40wire,
diff -Naur linux-2.6.38/drivers/ata//pata_jmicron.c linux-2.6.38-ata/driver=
s/ata//pata_jmicron.c
--- linux-2.6.38/drivers/ata//pata_jmicron.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_jmicron.c	2011-04-08 00:02:57.760880=
222 +0200
@@ -111,7 +111,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations jmicron_ops =3D {
+static const struct ata_port_operations jmicron_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.prereset		=3D jmicron_pre_reset,
 };
diff -Naur linux-2.6.38/drivers/ata//pata_legacy.c linux-2.6.38-ata/drivers=
/ata//pata_legacy.c
--- linux-2.6.38/drivers/ata//pata_legacy.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_legacy.c	2011-04-08 00:02:57.7608802=
22 +0200
@@ -116,7 +116,7 @@
=20
 struct legacy_controller {
 	const char *name;
-	struct ata_port_operations *ops;
+	const struct ata_port_operations *ops;
 	unsigned int pio_mask;
 	unsigned int flags;
 	unsigned int pflags;
@@ -239,12 +239,12 @@
  *	pio_mask as well.
  */
=20
-static struct ata_port_operations simple_port_ops =3D {
+static const struct ata_port_operations simple_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.sff_data_xfer	=3D ata_sff_data_xfer_noirq,
 };
=20
-static struct ata_port_operations legacy_port_ops =3D {
+static const struct ata_port_operations legacy_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.sff_data_xfer	=3D ata_sff_data_xfer_noirq,
 	.set_mode	=3D legacy_set_mode,
@@ -340,7 +340,7 @@
 	return buflen;
 }
=20
-static struct ata_port_operations pdc20230_port_ops =3D {
+static const struct ata_port_operations pdc20230_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D pdc20230_set_piomode,
 	.sff_data_xfer	=3D pdc_data_xfer_vlb,
@@ -373,7 +373,7 @@
 	ioread8(ap->ioaddr.status_addr);
 }
=20
-static struct ata_port_operations ht6560a_port_ops =3D {
+static const struct ata_port_operations ht6560a_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D ht6560a_set_piomode,
 };
@@ -416,7 +416,7 @@
 	ioread8(ap->ioaddr.status_addr);
 }
=20
-static struct ata_port_operations ht6560b_port_ops =3D {
+static const struct ata_port_operations ht6560b_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D ht6560b_set_piomode,
 };
@@ -515,7 +515,7 @@
 }
=20
=20
-static struct ata_port_operations opti82c611a_port_ops =3D {
+static const struct ata_port_operations opti82c611a_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D opti82c611a_set_piomode,
 };
@@ -625,7 +625,7 @@
 	return ata_sff_qc_issue(qc);
 }
=20
-static struct ata_port_operations opti82c46x_port_ops =3D {
+static const struct ata_port_operations opti82c46x_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D opti82c46x_set_piomode,
 	.qc_issue	=3D opti82c46x_qc_issue,
@@ -787,20 +787,20 @@
 	return 0;
 }
=20
-static struct ata_port_operations qdi6500_port_ops =3D {
+static const struct ata_port_operations qdi6500_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D qdi6500_set_piomode,
 	.qc_issue	=3D qdi_qc_issue,
 	.sff_data_xfer	=3D vlb32_data_xfer,
 };
=20
-static struct ata_port_operations qdi6580_port_ops =3D {
+static const struct ata_port_operations qdi6580_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D qdi6580_set_piomode,
 	.sff_data_xfer	=3D vlb32_data_xfer,
 };
=20
-static struct ata_port_operations qdi6580dp_port_ops =3D {
+static const struct ata_port_operations qdi6580dp_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D qdi6580dp_set_piomode,
 	.qc_issue	=3D qdi_qc_issue,
@@ -872,7 +872,7 @@
 	return 0;
 }
=20
-static struct ata_port_operations winbond_port_ops =3D {
+static const struct ata_port_operations winbond_port_ops =3D {
 	.inherits	=3D &legacy_base_port_ops,
 	.set_piomode	=3D winbond_set_piomode,
 	.sff_data_xfer	=3D vlb32_data_xfer,
@@ -995,7 +995,7 @@
 	int pio_modes =3D controller->pio_mask;
 	unsigned long io =3D probe->port;
 	u32 mask =3D (1 << probe->slot);
-	struct ata_port_operations *ops =3D controller->ops;
+	const struct ata_port_operations *ops =3D controller->ops;
 	struct legacy_data *ld =3D &legacy_data[probe->slot];
 	struct ata_host *host =3D NULL;
 	struct ata_port *ap;
diff -Naur linux-2.6.38/drivers/ata//pata_macio.c linux-2.6.38-ata/drivers/=
ata//pata_macio.c
--- linux-2.6.38/drivers/ata//pata_macio.c	2011-03-15 02:20:32.000000000 +0=
100
+++ linux-2.6.38-ata/drivers/ata//pata_macio.c	2011-04-08 00:02:57.76188021=
6 +0200
@@ -918,9 +918,8 @@
 	.slave_configure	=3D pata_macio_slave_config,
 };
=20
-static struct ata_port_operations pata_macio_ops =3D {
+static const struct ata_port_operations pata_macio_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
-
 	.freeze			=3D pata_macio_freeze,
 	.set_piomode		=3D pata_macio_set_timings,
 	.set_dmamode		=3D pata_macio_set_timings,
diff -Naur linux-2.6.38/drivers/ata//pata_marvell.c linux-2.6.38-ata/driver=
s/ata//pata_marvell.c
--- linux-2.6.38/drivers/ata//pata_marvell.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_marvell.c	2011-04-08 00:02:57.761880=
216 +0200
@@ -100,7 +100,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations marvell_ops =3D {
+static const struct ata_port_operations marvell_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.cable_detect		=3D marvell_cable_detect,
 	.prereset		=3D marvell_pre_reset,
diff -Naur linux-2.6.38/drivers/ata//pata_mpc52xx.c linux-2.6.38-ata/driver=
s/ata//pata_mpc52xx.c
--- linux-2.6.38/drivers/ata//pata_mpc52xx.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_mpc52xx.c	2011-04-08 00:02:57.762880=
210 +0200
@@ -609,7 +609,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations mpc52xx_ata_port_ops =3D {
+static const struct ata_port_operations mpc52xx_ata_port_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.sff_dev_select		=3D mpc52xx_ata_dev_select,
 	.set_piomode		=3D mpc52xx_ata_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_mpiix.c linux-2.6.38-ata/drivers/=
ata//pata_mpiix.c
--- linux-2.6.38/drivers/ata//pata_mpiix.c	2011-03-15 02:20:32.000000000 +0=
100
+++ linux-2.6.38-ata/drivers/ata//pata_mpiix.c	2011-04-08 00:02:57.76288021=
0 +0200
@@ -140,7 +140,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations mpiix_port_ops =3D {
+static const struct ata_port_operations mpiix_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.qc_issue	=3D mpiix_qc_issue,
 	.cable_detect	=3D ata_cable_40wire,
diff -Naur linux-2.6.38/drivers/ata//pata_netcell.c linux-2.6.38-ata/driver=
s/ata//pata_netcell.c
--- linux-2.6.38/drivers/ata//pata_netcell.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_netcell.c	2011-04-08 00:02:57.762880=
210 +0200
@@ -34,7 +34,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations netcell_ops =3D {
+static const struct ata_port_operations netcell_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D ata_cable_80wire,
 	.read_id	=3D netcell_read_id,
diff -Naur linux-2.6.38/drivers/ata//pata_ninja32.c linux-2.6.38-ata/driver=
s/ata//pata_ninja32.c
--- linux-2.6.38/drivers/ata//pata_ninja32.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_ninja32.c	2011-04-08 00:02:57.762880=
210 +0200
@@ -81,7 +81,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations ninja32_port_ops =3D {
+static const struct ata_port_operations ninja32_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.sff_dev_select =3D ninja32_dev_select,
 	.cable_detect	=3D ata_cable_40wire,
diff -Naur linux-2.6.38/drivers/ata//pata_ns87410.c linux-2.6.38-ata/driver=
s/ata//pata_ns87410.c
--- linux-2.6.38/drivers/ata//pata_ns87410.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_ns87410.c	2011-04-08 00:02:57.762880=
210 +0200
@@ -132,7 +132,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations ns87410_port_ops =3D {
+static const struct ata_port_operations ns87410_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.qc_issue	=3D ns87410_qc_issue,
 	.cable_detect	=3D ata_cable_40wire,
diff -Naur linux-2.6.38/drivers/ata//pata_ns87415.c linux-2.6.38-ata/driver=
s/ata//pata_ns87415.c
--- linux-2.6.38/drivers/ata//pata_ns87415.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_ns87415.c	2011-04-08 00:02:57.762880=
210 +0200
@@ -299,7 +299,7 @@
 }
 #endif		/* 87560 SuperIO Support */
=20
-static struct ata_port_operations ns87415_pata_ops =3D {
+static const struct ata_port_operations ns87415_pata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
=20
 	.check_atapi_dma	=3D ns87415_check_atapi_dma,
@@ -313,7 +313,7 @@
 };
=20
 #if defined(CONFIG_SUPERIO)
-static struct ata_port_operations ns87560_pata_ops =3D {
+static const struct ata_port_operations ns87560_pata_ops =3D {
 	.inherits		=3D &ns87415_pata_ops,
 	.sff_tf_read		=3D ns87560_tf_read,
 	.sff_check_status	=3D ns87560_check_status,
diff -Naur linux-2.6.38/drivers/ata//pata_octeon_cf.c linux-2.6.38-ata/driv=
ers/ata//pata_octeon_cf.c
--- linux-2.6.38/drivers/ata//pata_octeon_cf.c	2011-03-15 02:20:32.00000000=
0 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_octeon_cf.c	2011-04-08 00:02:57.7638=
80204 +0200
@@ -780,7 +780,7 @@
 	return 0;
 }
=20
-static struct ata_port_operations octeon_cf_ops =3D {
+static struct ata_port_operations octeon_cf_ops =3D {	/* cannot be const */
 	.inherits		=3D &ata_sff_port_ops,
 	.check_atapi_dma	=3D octeon_cf_check_atapi_dma,
 	.qc_prep		=3D ata_noop_qc_prep,
diff -Naur linux-2.6.38/drivers/ata//pata_oldpiix.c linux-2.6.38-ata/driver=
s/ata//pata_oldpiix.c
--- linux-2.6.38/drivers/ata//pata_oldpiix.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_oldpiix.c	2011-04-08 00:02:57.763880=
204 +0200
@@ -208,7 +208,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations oldpiix_pata_ops =3D {
+static const struct ata_port_operations oldpiix_pata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.qc_issue		=3D oldpiix_qc_issue,
 	.cable_detect		=3D ata_cable_40wire,
diff -Naur linux-2.6.38/drivers/ata//pata_opti.c linux-2.6.38-ata/drivers/a=
ta//pata_opti.c
--- linux-2.6.38/drivers/ata//pata_opti.c	2011-03-15 02:20:32.000000000 +01=
00
+++ linux-2.6.38-ata/drivers/ata//pata_opti.c	2011-04-08 00:02:57.769880170=
 +0200
@@ -152,7 +152,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations opti_port_ops =3D {
+static const struct ata_port_operations opti_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	.set_piomode	=3D opti_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_optidma.c linux-2.6.38-ata/driver=
s/ata//pata_optidma.c
--- linux-2.6.38/drivers/ata//pata_optidma.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_optidma.c	2011-04-08 00:02:57.772880=
154 +0200
@@ -337,7 +337,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations optidma_port_ops =3D {
+static const struct ata_port_operations optidma_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	.set_piomode	=3D optidma_set_pio_mode,
@@ -346,7 +346,7 @@
 	.prereset	=3D optidma_pre_reset,
 };
=20
-static struct ata_port_operations optiplus_port_ops =3D {
+static const struct ata_port_operations optiplus_port_ops =3D {
 	.inherits	=3D &optidma_port_ops,
 	.set_piomode	=3D optiplus_set_pio_mode,
 	.set_dmamode	=3D optiplus_set_dma_mode,
diff -Naur linux-2.6.38/drivers/ata//pata_palmld.c linux-2.6.38-ata/drivers=
/ata//pata_palmld.c
--- linux-2.6.38/drivers/ata//pata_palmld.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_palmld.c	2011-04-08 00:02:57.7738801=
48 +0200
@@ -37,7 +37,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations palmld_port_ops =3D {
+static const struct ata_port_operations palmld_port_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
 	.sff_data_xfer		=3D ata_sff_data_xfer_noirq,
 	.cable_detect		=3D ata_cable_40wire,
diff -Naur linux-2.6.38/drivers/ata//pata_pcmcia.c linux-2.6.38-ata/drivers=
/ata//pata_pcmcia.c
--- linux-2.6.38/drivers/ata//pata_pcmcia.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_pcmcia.c	2011-04-08 00:02:57.7738801=
48 +0200
@@ -151,14 +151,14 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations pcmcia_port_ops =3D {
+static const struct ata_port_operations pcmcia_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.sff_data_xfer	=3D ata_sff_data_xfer_noirq,
 	.cable_detect	=3D ata_cable_40wire,
 	.set_mode	=3D pcmcia_set_mode,
 };
=20
-static struct ata_port_operations pcmcia_8bit_port_ops =3D {
+static const struct ata_port_operations pcmcia_8bit_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.sff_data_xfer	=3D ata_data_xfer_8bit,
 	.cable_detect	=3D ata_cable_40wire,
@@ -205,7 +205,7 @@
 	unsigned long io_base, ctl_base;
 	void __iomem *io_addr, *ctl_addr;
 	int n_ports =3D 1;
-	struct ata_port_operations *ops =3D &pcmcia_port_ops;
+	const struct ata_port_operations *ops =3D &pcmcia_port_ops;
=20
 	/* Set up attributes in order to probe card and get resources */
 	pdev->config_flags |=3D CONF_ENABLE_IRQ | CONF_AUTO_SET_IO |
diff -Naur linux-2.6.38/drivers/ata//pata_pdc2027x.c linux-2.6.38-ata/drive=
rs/ata//pata_pdc2027x.c
--- linux-2.6.38/drivers/ata//pata_pdc2027x.c	2011-03-15 02:20:32.000000000=
 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_pdc2027x.c	2011-04-08 00:02:57.77988=
0112 +0200
@@ -132,14 +132,14 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations pdc2027x_pata100_ops =3D {
+static const struct ata_port_operations pdc2027x_pata100_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.check_atapi_dma	=3D pdc2027x_check_atapi_dma,
 	.cable_detect		=3D pdc2027x_cable_detect,
 	.prereset		=3D pdc2027x_prereset,
 };
=20
-static struct ata_port_operations pdc2027x_pata133_ops =3D {
+static const struct ata_port_operations pdc2027x_pata133_ops =3D {
 	.inherits		=3D &pdc2027x_pata100_ops,
 	.mode_filter		=3D pdc2027x_mode_filter,
 	.set_piomode		=3D pdc2027x_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_pdc202xx_old.c linux-2.6.38-ata/d=
rivers/ata//pata_pdc202xx_old.c
--- linux-2.6.38/drivers/ata//pata_pdc202xx_old.c	2011-03-15 02:20:32.00000=
0000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_pdc202xx_old.c	2011-04-08 00:02:57.7=
80880107 +0200
@@ -295,7 +295,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations pdc2024x_port_ops =3D {
+static const struct ata_port_operations pdc2024x_port_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
=20
 	.cable_detect		=3D ata_cable_40wire,
@@ -306,7 +306,7 @@
 	.sff_irq_check		=3D pdc202xx_irq_check,
 };
=20
-static struct ata_port_operations pdc2026x_port_ops =3D {
+static const struct ata_port_operations pdc2026x_port_ops =3D {
 	.inherits		=3D &pdc2024x_port_ops,
=20
 	.check_atapi_dma	=3D pdc2026x_check_atapi_dma,
diff -Naur linux-2.6.38/drivers/ata//pata_piccolo.c linux-2.6.38-ata/driver=
s/ata//pata_piccolo.c
--- linux-2.6.38/drivers/ata//pata_piccolo.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_piccolo.c	2011-04-08 00:02:57.780880=
107 +0200
@@ -67,7 +67,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations tosh_port_ops =3D {
+static const struct ata_port_operations tosh_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D ata_cable_unknown,
 	.set_piomode	=3D tosh_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_platform.c linux-2.6.38-ata/drive=
rs/ata//pata_platform.c
--- linux-2.6.38/drivers/ata//pata_platform.c	2011-03-15 02:20:32.000000000=
 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_platform.c	2011-04-08 00:02:57.78188=
0102 +0200
@@ -48,7 +48,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations pata_platform_port_ops =3D {
+static const struct ata_port_operations pata_platform_port_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
 	.sff_data_xfer		=3D ata_sff_data_xfer_noirq,
 	.cable_detect		=3D ata_cable_unknown,
diff -Naur linux-2.6.38/drivers/ata//pata_pxa.c linux-2.6.38-ata/drivers/at=
a//pata_pxa.c
--- linux-2.6.38/drivers/ata//pata_pxa.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_pxa.c	2011-04-08 00:02:57.782880097 =
+0200
@@ -198,7 +198,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations pxa_ata_port_ops =3D {
+static const struct ata_port_operations pxa_ata_port_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.cable_detect		=3D ata_cable_40wire,
=20
diff -Naur linux-2.6.38/drivers/ata//pata_qdi.c linux-2.6.38-ata/drivers/at=
a//pata_qdi.c
--- linux-2.6.38/drivers/ata//pata_qdi.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_qdi.c	2011-04-08 00:02:57.784880087 =
+0200
@@ -157,7 +157,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations qdi6500_port_ops =3D {
+static const struct ata_port_operations qdi6500_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.qc_issue	=3D qdi_qc_issue,
 	.sff_data_xfer	=3D qdi_data_xfer,
@@ -165,7 +165,7 @@
 	.set_piomode	=3D qdi6500_set_piomode,
 };
=20
-static struct ata_port_operations qdi6580_port_ops =3D {
+static const struct ata_port_operations qdi6580_port_ops =3D {
 	.inherits	=3D &qdi6500_port_ops,
 	.set_piomode	=3D qdi6580_set_piomode,
 };
diff -Naur linux-2.6.38/drivers/ata//pata_radisys.c linux-2.6.38-ata/driver=
s/ata//pata_radisys.c
--- linux-2.6.38/drivers/ata//pata_radisys.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_radisys.c	2011-04-08 00:02:57.785880=
081 +0200
@@ -187,7 +187,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations radisys_pata_ops =3D {
+static const struct ata_port_operations radisys_pata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.qc_issue		=3D radisys_qc_issue,
 	.cable_detect		=3D ata_cable_unknown,
diff -Naur linux-2.6.38/drivers/ata//pata_rb532_cf.c linux-2.6.38-ata/drive=
rs/ata//pata_rb532_cf.c
--- linux-2.6.38/drivers/ata//pata_rb532_cf.c	2011-03-15 02:20:32.000000000=
 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_rb532_cf.c	2011-04-08 00:02:57.79588=
0024 +0200
@@ -69,7 +69,7 @@
 	return IRQ_HANDLED;
 }
=20
-static struct ata_port_operations rb532_pata_port_ops =3D {
+static const struct ata_port_operations rb532_pata_port_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
 	.sff_data_xfer		=3D ata_sff_data_xfer32,
 };
diff -Naur linux-2.6.38/drivers/ata//pata_rdc.c linux-2.6.38-ata/drivers/at=
a//pata_rdc.c
--- linux-2.6.38/drivers/ata//pata_rdc.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_rdc.c	2011-04-08 00:02:57.796880019 =
+0200
@@ -273,7 +273,7 @@
 	pci_write_config_byte(dev, 0x48, udma_enable);
 }
=20
-static struct ata_port_operations rdc_pata_ops =3D {
+static const struct ata_port_operations rdc_pata_ops =3D {
 	.inherits		=3D &ata_bmdma32_port_ops,
 	.cable_detect		=3D rdc_pata_cable_detect,
 	.set_piomode		=3D rdc_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_rz1000.c linux-2.6.38-ata/drivers=
/ata//pata_rz1000.c
--- linux-2.6.38/drivers/ata//pata_rz1000.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_rz1000.c	2011-04-08 00:02:57.7968800=
19 +0200
@@ -54,7 +54,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations rz1000_port_ops =3D {
+static const struct ata_port_operations rz1000_port_ops =3D {
 	.inherits	=3D &ata_sff_port_ops,
 	.cable_detect	=3D ata_cable_40wire,
 	.set_mode	=3D rz1000_set_mode,
diff -Naur linux-2.6.38/drivers/ata//pata_samsung_cf.c linux-2.6.38-ata/dri=
vers/ata//pata_samsung_cf.c
--- linux-2.6.38/drivers/ata//pata_samsung_cf.c	2011-03-15 02:20:32.0000000=
00 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_samsung_cf.c	2011-04-08 00:02:57.796=
880019 +0200
@@ -399,7 +399,7 @@
 	ATA_PIO_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations pata_s3c_port_ops =3D {
+static const struct ata_port_operations pata_s3c_port_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
 	.sff_check_status	=3D pata_s3c_check_status,
 	.sff_check_altstatus    =3D pata_s3c_check_altstatus,
@@ -413,7 +413,7 @@
 	.set_piomode		=3D pata_s3c_set_piomode,
 };
=20
-static struct ata_port_operations pata_s5p_port_ops =3D {
+static const struct ata_port_operations pata_s5p_port_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
 	.set_piomode		=3D pata_s3c_set_piomode,
 };
diff -Naur linux-2.6.38/drivers/ata//pata_sc1200.c linux-2.6.38-ata/drivers=
/ata//pata_sc1200.c
--- linux-2.6.38/drivers/ata//pata_sc1200.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_sc1200.c	2011-04-08 00:02:57.7978800=
13 +0200
@@ -207,7 +207,7 @@
 	.sg_tablesize	=3D LIBATA_DUMB_MAX_PRD,
 };
=20
-static struct ata_port_operations sc1200_port_ops =3D {
+static const struct ata_port_operations sc1200_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.qc_prep 	=3D ata_bmdma_dumb_qc_prep,
 	.qc_issue	=3D sc1200_qc_issue,
diff -Naur linux-2.6.38/drivers/ata//pata_scc.c linux-2.6.38-ata/drivers/at=
a//pata_scc.c
--- linux-2.6.38/drivers/ata//pata_scc.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_scc.c	2011-04-08 00:02:57.797880013 =
+0200
@@ -926,7 +926,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations scc_pata_ops =3D {
+static const struct ata_port_operations scc_pata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
=20
 	.set_piomode		=3D scc_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_sch.c linux-2.6.38-ata/drivers/at=
a//pata_sch.c
--- linux-2.6.38/drivers/ata//pata_sch.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_sch.c	2011-04-08 00:02:57.803879977 =
+0200
@@ -75,7 +75,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations sch_pata_ops =3D {
+static const struct ata_port_operations sch_pata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.cable_detect		=3D ata_cable_unknown,
 	.set_piomode		=3D sch_set_piomode,
diff -Naur linux-2.6.38/drivers/ata//pata_serverworks.c linux-2.6.38-ata/dr=
ivers/ata//pata_serverworks.c
--- linux-2.6.38/drivers/ata//pata_serverworks.c	2011-03-15 02:20:32.000000=
000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_serverworks.c	2011-04-08 00:02:57.80=
3879977 +0200
@@ -300,7 +300,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations serverworks_osb4_port_ops =3D {
+static const struct ata_port_operations serverworks_osb4_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D serverworks_cable_detect,
 	.mode_filter	=3D serverworks_osb4_filter,
@@ -308,7 +308,7 @@
 	.set_dmamode	=3D serverworks_set_dmamode,
 };
=20
-static struct ata_port_operations serverworks_csb_port_ops =3D {
+static const struct ata_port_operations serverworks_csb_port_ops =3D {
 	.inherits	=3D &serverworks_osb4_port_ops,
 	.mode_filter	=3D serverworks_csb_filter,
 };
diff -Naur linux-2.6.38/drivers/ata//pata_sil680.c linux-2.6.38-ata/drivers=
/ata//pata_sil680.c
--- linux-2.6.38/drivers/ata//pata_sil680.c	2011-03-15 02:20:32.000000000 +=
0100
+++ linux-2.6.38-ata/drivers/ata//pata_sil680.c	2011-04-08 00:02:57.8038799=
77 +0200
@@ -225,8 +225,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-
-static struct ata_port_operations sil680_port_ops =3D {
+static const struct ata_port_operations sil680_port_ops =3D {
 	.inherits		=3D &ata_bmdma32_port_ops,
 	.sff_exec_command	=3D sil680_sff_exec_command,
 	.sff_irq_check		=3D sil680_sff_irq_check,
diff -Naur linux-2.6.38/drivers/ata//pata_sis.c linux-2.6.38-ata/drivers/at=
a//pata_sis.c
--- linux-2.6.38/drivers/ata//pata_sis.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_sis.c	2011-04-08 00:02:57.804879971 =
+0200
@@ -503,47 +503,47 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations sis_133_for_sata_ops =3D {
+static const struct ata_port_operations sis_133_for_sata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.set_piomode		=3D sis_133_set_piomode,
 	.set_dmamode		=3D sis_133_set_dmamode,
 	.cable_detect		=3D sis_133_cable_detect,
 };
=20
-static struct ata_port_operations sis_base_ops =3D {
+static const struct ata_port_operations sis_base_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.prereset		=3D sis_pre_reset,
 };
=20
-static struct ata_port_operations sis_133_ops =3D {
+static const struct ata_port_operations sis_133_ops =3D {
 	.inherits		=3D &sis_base_ops,
 	.set_piomode		=3D sis_133_set_piomode,
 	.set_dmamode		=3D sis_133_set_dmamode,
 	.cable_detect		=3D sis_133_cable_detect,
 };
=20
-static struct ata_port_operations sis_133_early_ops =3D {
+static const struct ata_port_operations sis_133_early_ops =3D {
 	.inherits		=3D &sis_base_ops,
 	.set_piomode		=3D sis_100_set_piomode,
 	.set_dmamode		=3D sis_133_early_set_dmamode,
 	.cable_detect		=3D sis_66_cable_detect,
 };
=20
-static struct ata_port_operations sis_100_ops =3D {
+static const struct ata_port_operations sis_100_ops =3D {
 	.inherits		=3D &sis_base_ops,
 	.set_piomode		=3D sis_100_set_piomode,
 	.set_dmamode		=3D sis_100_set_dmamode,
 	.cable_detect		=3D sis_66_cable_detect,
 };
=20
-static struct ata_port_operations sis_66_ops =3D {
+static const struct ata_port_operations sis_66_ops =3D {
 	.inherits		=3D &sis_base_ops,
 	.set_piomode		=3D sis_old_set_piomode,
 	.set_dmamode		=3D sis_66_set_dmamode,
 	.cable_detect		=3D sis_66_cable_detect,
 };
=20
-static struct ata_port_operations sis_old_ops =3D {
+static const struct ata_port_operations sis_old_ops =3D {
 	.inherits		=3D &sis_base_ops,
 	.set_piomode		=3D sis_old_set_piomode,
 	.set_dmamode		=3D sis_old_set_dmamode,
diff -Naur linux-2.6.38/drivers/ata//pata_sl82c105.c linux-2.6.38-ata/drive=
rs/ata//pata_sl82c105.c
--- linux-2.6.38/drivers/ata//pata_sl82c105.c	2011-03-15 02:20:32.000000000=
 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_sl82c105.c	2011-04-08 00:02:57.80487=
9971 +0200
@@ -241,7 +241,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations sl82c105_port_ops =3D {
+static const struct ata_port_operations sl82c105_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.qc_defer	=3D sl82c105_qc_defer,
 	.bmdma_start 	=3D sl82c105_bmdma_start,
diff -Naur linux-2.6.38/drivers/ata//pata_triflex.c linux-2.6.38-ata/driver=
s/ata//pata_triflex.c
--- linux-2.6.38/drivers/ata//pata_triflex.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//pata_triflex.c	2011-04-08 00:02:57.804879=
971 +0200
@@ -178,7 +178,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations triflex_port_ops =3D {
+static const struct ata_port_operations triflex_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.bmdma_start 	=3D triflex_bmdma_start,
 	.bmdma_stop	=3D triflex_bmdma_stop,
diff -Naur linux-2.6.38/drivers/ata//pata_via.c linux-2.6.38-ata/drivers/at=
a//pata_via.c
--- linux-2.6.38/drivers/ata//pata_via.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pata_via.c	2011-04-08 00:02:57.804879971 =
+0200
@@ -441,7 +441,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations via_port_ops =3D {
+static const struct ata_port_operations via_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
 	.cable_detect	=3D via_cable_detect,
 	.set_piomode	=3D via_set_piomode,
@@ -452,7 +452,7 @@
 	.mode_filter	=3D via_mode_filter,
 };
=20
-static struct ata_port_operations via_port_ops_noirq =3D {
+static const struct ata_port_operations via_port_ops_noirq =3D {
 	.inherits	=3D &via_port_ops,
 	.sff_data_xfer	=3D ata_sff_data_xfer_noirq,
 };
diff -Naur linux-2.6.38/drivers/ata//pdc_adma.c linux-2.6.38-ata/drivers/at=
a//pdc_adma.c
--- linux-2.6.38/drivers/ata//pdc_adma.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//pdc_adma.c	2011-04-08 00:02:57.804879971 =
+0200
@@ -146,7 +146,7 @@
 	.dma_boundary		=3D ADMA_DMA_BOUNDARY,
 };
=20
-static struct ata_port_operations adma_ata_ops =3D {
+static const struct ata_port_operations adma_ata_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
=20
 	.lost_interrupt		=3D ATA_OP_NULL,
diff -Naur linux-2.6.38/drivers/ata//sata_dwc_460ex.c linux-2.6.38-ata/driv=
ers/ata//sata_dwc_460ex.c
--- linux-2.6.38/drivers/ata//sata_dwc_460ex.c	2011-03-15 02:20:32.00000000=
0 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_dwc_460ex.c	2011-04-08 00:02:57.8058=
79966 +0200
@@ -1560,7 +1560,7 @@
 	.dma_boundary		=3D ATA_DMA_BOUNDARY,
 };
=20
-static struct ata_port_operations sata_dwc_ops =3D {
+static const struct ata_port_operations sata_dwc_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
=20
 	.error_handler		=3D sata_dwc_error_handler,
diff -Naur linux-2.6.38/drivers/ata//sata_fsl.c linux-2.6.38-ata/drivers/at=
a//sata_fsl.c
--- linux-2.6.38/drivers/ata//sata_fsl.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_fsl.c	2011-04-08 00:02:57.817879898 =
+0200
@@ -1258,7 +1258,7 @@
 	.dma_boundary =3D ATA_DMA_BOUNDARY,
 };
=20
-static struct ata_port_operations sata_fsl_ops =3D {
+static const struct ata_port_operations sata_fsl_ops =3D {
 	.inherits		=3D &sata_pmp_port_ops,
=20
 	.qc_defer =3D ata_std_qc_defer,
diff -Naur linux-2.6.38/drivers/ata//sata_inic162x.c linux-2.6.38-ata/drive=
rs/ata//sata_inic162x.c
--- linux-2.6.38/drivers/ata//sata_inic162x.c	2011-03-15 02:20:32.000000000=
 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_inic162x.c	2011-04-08 00:02:57.81787=
9898 +0200
@@ -705,7 +705,7 @@
 	return 0;
 }
=20
-static struct ata_port_operations inic_port_ops =3D {
+static const struct ata_port_operations inic_port_ops =3D {
 	.inherits		=3D &sata_port_ops,
=20
 	.check_atapi_dma	=3D inic_check_atapi_dma,
diff -Naur linux-2.6.38/drivers/ata//sata_mv.c linux-2.6.38-ata/drivers/ata=
//sata_mv.c
--- linux-2.6.38/drivers/ata//sata_mv.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_mv.c	2011-04-08 00:02:57.827879843 +=
0200
@@ -663,7 +663,7 @@
 	.dma_boundary		=3D MV_DMA_BOUNDARY,
 };
=20
-static struct ata_port_operations mv5_ops =3D {
+static const struct ata_port_operations mv5_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
=20
 	.lost_interrupt		=3D ATA_OP_NULL,
@@ -683,7 +683,7 @@
 	.port_stop		=3D mv_port_stop,
 };
=20
-static struct ata_port_operations mv6_ops =3D {
+static const struct ata_port_operations mv6_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
=20
 	.lost_interrupt		=3D ATA_OP_NULL,
@@ -717,7 +717,7 @@
 	.port_stop		=3D mv_port_stop,
 };
=20
-static struct ata_port_operations mv_iie_ops =3D {
+static const struct ata_port_operations mv_iie_ops =3D {
 	.inherits		=3D &mv6_ops,
 	.dev_config		=3D ATA_OP_NULL,
 	.qc_prep		=3D mv_qc_prep_iie,
diff -Naur linux-2.6.38/drivers/ata//sata_nv.c linux-2.6.38-ata/drivers/ata=
//sata_nv.c
--- linux-2.6.38/drivers/ata//sata_nv.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_nv.c	2011-04-08 00:02:57.828879837 +=
0200
@@ -465,7 +465,7 @@
  * cases.  Define nv_hardreset() which only kicks in for post-boot
  * probing and use it for all variants.
  */
-static struct ata_port_operations nv_generic_ops =3D {
+static const struct ata_port_operations nv_generic_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.lost_interrupt		=3D ATA_OP_NULL,
 	.scr_read		=3D nv_scr_read,
@@ -473,20 +473,20 @@
 	.hardreset		=3D nv_hardreset,
 };
=20
-static struct ata_port_operations nv_nf2_ops =3D {
+static const struct ata_port_operations nv_nf2_ops =3D {
 	.inherits		=3D &nv_generic_ops,
 	.freeze			=3D nv_nf2_freeze,
 	.thaw			=3D nv_nf2_thaw,
 };
=20
-static struct ata_port_operations nv_ck804_ops =3D {
+static const struct ata_port_operations nv_ck804_ops =3D {
 	.inherits		=3D &nv_generic_ops,
 	.freeze			=3D nv_ck804_freeze,
 	.thaw			=3D nv_ck804_thaw,
 	.host_stop		=3D nv_ck804_host_stop,
 };
=20
-static struct ata_port_operations nv_adma_ops =3D {
+static const struct ata_port_operations nv_adma_ops =3D {
 	.inherits		=3D &nv_ck804_ops,
=20
 	.check_atapi_dma	=3D nv_adma_check_atapi_dma,
@@ -510,7 +510,7 @@
 	.host_stop		=3D nv_adma_host_stop,
 };
=20
-static struct ata_port_operations nv_swncq_ops =3D {
+static const struct ata_port_operations nv_swncq_ops =3D {
 	.inherits		=3D &nv_generic_ops,
=20
 	.qc_defer		=3D ata_std_qc_defer,
diff -Naur linux-2.6.38/drivers/ata//sata_promise.c linux-2.6.38-ata/driver=
s/ata//sata_promise.c
--- linux-2.6.38/drivers/ata//sata_promise.c	2011-03-15 02:20:32.000000000 =
+0100
+++ linux-2.6.38-ata/drivers/ata//sata_promise.c	2011-04-08 00:02:57.834879=
804 +0200
@@ -196,7 +196,7 @@
 	.error_handler		=3D pdc_error_handler,
 };
=20
-static struct ata_port_operations pdc_sata_ops =3D {
+static const struct ata_port_operations pdc_sata_ops =3D {
 	.inherits		=3D &pdc_common_ops,
 	.cable_detect		=3D pdc_sata_cable_detect,
 	.freeze			=3D pdc_sata_freeze,
@@ -209,14 +209,14 @@
=20
 /* First-generation chips need a more restrictive ->check_atapi_dma op,
    and ->freeze/thaw that ignore the hotplug controls. */
-static struct ata_port_operations pdc_old_sata_ops =3D {
+static const struct ata_port_operations pdc_old_sata_ops =3D {
 	.inherits		=3D &pdc_sata_ops,
 	.freeze			=3D pdc_freeze,
 	.thaw			=3D pdc_thaw,
 	.check_atapi_dma	=3D pdc_old_sata_check_atapi_dma,
 };
=20
-static struct ata_port_operations pdc_pata_ops =3D {
+static const struct ata_port_operations pdc_pata_ops =3D {
 	.inherits		=3D &pdc_common_ops,
 	.cable_detect		=3D pdc_pata_cable_detect,
 	.freeze			=3D pdc_freeze,
diff -Naur linux-2.6.38/drivers/ata//sata_qstor.c linux-2.6.38-ata/drivers/=
ata//sata_qstor.c
--- linux-2.6.38/drivers/ata//sata_qstor.c	2011-03-15 02:20:32.000000000 +0=
100
+++ linux-2.6.38-ata/drivers/ata//sata_qstor.c	2011-04-08 00:02:57.83587979=
9 +0200
@@ -131,7 +131,7 @@
 	.dma_boundary		=3D QS_DMA_BOUNDARY,
 };
=20
-static struct ata_port_operations qs_ata_ops =3D {
+static const struct ata_port_operations qs_ata_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
=20
 	.check_atapi_dma	=3D qs_check_atapi_dma,
diff -Naur linux-2.6.38/drivers/ata//sata_sil24.c linux-2.6.38-ata/drivers/=
ata//sata_sil24.c
--- linux-2.6.38/drivers/ata//sata_sil24.c	2011-03-15 02:20:32.000000000 +0=
100
+++ linux-2.6.38-ata/drivers/ata//sata_sil24.c	2011-04-08 00:02:57.83687979=
3 +0200
@@ -389,7 +389,7 @@
 	.dma_boundary		=3D ATA_DMA_BOUNDARY,
 };
=20
-static struct ata_port_operations sil24_ops =3D {
+static const struct ata_port_operations sil24_ops =3D {
 	.inherits		=3D &sata_pmp_port_ops,
=20
 	.qc_defer		=3D sil24_qc_defer,
diff -Naur linux-2.6.38/drivers/ata//sata_sil.c linux-2.6.38-ata/drivers/at=
a//sata_sil.c
--- linux-2.6.38/drivers/ata//sata_sil.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_sil.c	2011-04-08 00:02:57.837879787 =
+0200
@@ -182,7 +182,7 @@
 	.sg_tablesize		=3D ATA_MAX_PRD
 };
=20
-static struct ata_port_operations sil_ops =3D {
+static const struct ata_port_operations sil_ops =3D {
 	.inherits		=3D &ata_bmdma32_port_ops,
 	.dev_config		=3D sil_dev_config,
 	.set_mode		=3D sil_set_mode,
diff -Naur linux-2.6.38/drivers/ata//sata_sis.c linux-2.6.38-ata/drivers/at=
a//sata_sis.c
--- linux-2.6.38/drivers/ata//sata_sis.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_sis.c	2011-04-08 00:02:57.837879787 =
+0200
@@ -89,7 +89,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations sis_ops =3D {
+static const struct ata_port_operations sis_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.scr_read		=3D sis_scr_read,
 	.scr_write		=3D sis_scr_write,
diff -Naur linux-2.6.38/drivers/ata//sata_svw.c linux-2.6.38-ata/drivers/at=
a//sata_svw.c
--- linux-2.6.38/drivers/ata//sata_svw.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_svw.c	2011-04-08 00:02:57.838879781 =
+0200
@@ -344,7 +344,7 @@
 };
=20
=20
-static struct ata_port_operations k2_sata_ops =3D {
+static const struct ata_port_operations k2_sata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.sff_tf_load		=3D k2_sata_tf_load,
 	.sff_tf_read		=3D k2_sata_tf_read,
diff -Naur linux-2.6.38/drivers/ata//sata_sx4.c linux-2.6.38-ata/drivers/at=
a//sata_sx4.c
--- linux-2.6.38/drivers/ata//sata_sx4.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_sx4.c	2011-04-08 00:02:57.838879781 =
+0200
@@ -249,7 +249,7 @@
 };
=20
 /* TODO: inherit from base port_ops after converting to new EH */
-static struct ata_port_operations pdc_20621_ops =3D {
+static const struct ata_port_operations pdc_20621_ops =3D {
 	.inherits		=3D &ata_sff_port_ops,
=20
 	.check_atapi_dma	=3D pdc_check_atapi_dma,
diff -Naur linux-2.6.38/drivers/ata//sata_uli.c linux-2.6.38-ata/drivers/at=
a//sata_uli.c
--- linux-2.6.38/drivers/ata//sata_uli.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_uli.c	2011-04-08 00:02:57.839879775 =
+0200
@@ -80,7 +80,7 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations uli_ops =3D {
+static const struct ata_port_operations uli_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.scr_read		=3D uli_scr_read,
 	.scr_write		=3D uli_scr_write,
diff -Naur linux-2.6.38/drivers/ata//sata_via.c linux-2.6.38-ata/drivers/at=
a//sata_via.c
--- linux-2.6.38/drivers/ata//sata_via.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_via.c	2011-04-08 00:02:57.842879757 =
+0200
@@ -115,32 +115,32 @@
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
-static struct ata_port_operations svia_base_ops =3D {
+static const struct ata_port_operations svia_base_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	.sff_tf_load		=3D svia_tf_load,
 };
=20
-static struct ata_port_operations vt6420_sata_ops =3D {
+static const struct ata_port_operations vt6420_sata_ops =3D {
 	.inherits		=3D &svia_base_ops,
 	.freeze			=3D svia_noop_freeze,
 	.prereset		=3D vt6420_prereset,
 	.bmdma_start		=3D vt6420_bmdma_start,
 };
=20
-static struct ata_port_operations vt6421_pata_ops =3D {
+static const struct ata_port_operations vt6421_pata_ops =3D {
 	.inherits		=3D &svia_base_ops,
 	.cable_detect		=3D vt6421_pata_cable_detect,
 	.set_piomode		=3D vt6421_set_pio_mode,
 	.set_dmamode		=3D vt6421_set_dma_mode,
 };
=20
-static struct ata_port_operations vt6421_sata_ops =3D {
+static const struct ata_port_operations vt6421_sata_ops =3D {
 	.inherits		=3D &svia_base_ops,
 	.scr_read		=3D svia_scr_read,
 	.scr_write		=3D svia_scr_write,
 };
=20
-static struct ata_port_operations vt8251_ops =3D {
+static const struct ata_port_operations vt8251_ops =3D {
 	.inherits		=3D &svia_base_ops,
 	.hardreset		=3D sata_std_hardreset,
 	.scr_read		=3D vt8251_scr_read,
diff -Naur linux-2.6.38/drivers/ata//sata_vsc.c linux-2.6.38-ata/drivers/at=
a//sata_vsc.c
--- linux-2.6.38/drivers/ata//sata_vsc.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-ata/drivers/ata//sata_vsc.c	2011-04-08 00:02:57.843879751 =
+0200
@@ -300,7 +300,7 @@
 };
=20
=20
-static struct ata_port_operations vsc_sata_ops =3D {
+static const struct ata_port_operations vsc_sata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
 	/* The IRQ handling is not quite standard SFF behaviour so we
 	   cannot use the default lost interrupt handler */

--=_zucker.schokokeks.org-27406-1302214437-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBCAAGBQJNnjcjAAoJEKWIAHK7tR5CHcYP/RkOGnNZRJGFJM0gHziU40bl
wcXhtXgCoWoWFOugAKoW55RSKsN2jny/9xe7CmLNAyG/T6lNqafZFsD5tghIrhBr
Fk8jAWjmc/DECLpSKiQf1dX98hpv6MhQ2BYs6UthODtJPNYHZzPlKHx/LwyWQ/G9
Lb78gKvvq/cGsXbk1PI+CG2pKwQUX4QfmMZRKmdkFQ95ZzG4OvkheMqmbvCUmOpa
AM8Ujgb9ygN5WGb9ORNE7umVMX82Fq8+7OdKSJkP4xLQFJqEPw5gyJ2b2M18wsKX
dZuqQQ82PWjdlIb65VJvXNWOPx7i+jCR2MDrLxlyYdwcC183ouJ1znl+9K6dtPV5
E4P0edY1jyRL2yniDPWjKt39P/6Pl582Un1F7AAFYrPMweTxPiB0BQTahvLrm7n/
dPsFK+wjW1PEoezRM/hbFdwJw5Lm8yq7+cQcyG5G3E4Z3H54EPLDuyVoTz27eNBK
GgfTaXL97+iNZBYJlyvWjF1RF/XVzNYK1DjJxF6IcAmZcs420cb2+0DvJcpHMrBI
JJpbZku+hnBvBegzQKfxKPAARjqd4UGjQe5xZvTIZ2BjF282jdT54SHV9GZvMdcY
Jw6fBsaGpI9aoOUZE/hiy/pibmr9oSnqvg4YL8maKupiY3CD6J1OnZ2riLOKqsu/
x0Dj4cnWW8g1s64NbMRe
=3TCJ
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-27406-1302214437-0001-2--
