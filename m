Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1KJVR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:17:57 -0500
Received: from havoc.gtf.org ([69.61.125.42]:43263 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab1KJVRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:17:55 -0500
Date: Thu, 10 Nov 2011 16:17:54 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes, GPG-signed
Message-ID: <20111110211754.GA10869@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Summary:
0) New GPG pull request format; flame away.  I dislike James B's
   encrypted blob, though plaintext+sig isn't much better.
1) pata_of_platform build fix
2) Port Multiplier fix
3) trivial changes and a new PCI ID

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please pull 2d5fcc986da944bca8257f358b155eec79fc4120 from
git://github.com/jgarzik/libata-dev.git upstream-linus

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrw+nSWzCDIBeCsvAQJWew//UMgPXtzf5MaIlk2KOuniCEXlVlhaaGI9
Kj5CFPl0ZzHBTq8J76uVbKPjBfwRtP2hQMCjBFvmyiRCzOE/bUH84I375p7pya+w
Fzn8zrdErZAwEI1n6Op462KOuZ47o5QGUrVWAZr51FC2Q2sF9wdfEuzpMOrrNfzU
n3Rjz8dioOF71DkWCQDt8+vLnemGwCbWqaKJQrS56b/o+Bb8STM0Cjk5Ne9Enohi
s2M42KeQeG4OTOX00/+K092xIcz4Li++YEYQ/0EbTYbkrZsKlvLCjrWdxlYA7okK
Us6wgaGal22ZaJ8uhcJt+0/jFPLel1iN/2qgxcW4Qaa4WBmMQRakQoEUtCoPXc0P
8Kz7GZp7Np+TESgD7YWev92Rue9S7IU1rOvBHv/xRhS0GlBoWYdme0XTdURg5tPi
kiJnfL6yGVKZWkVN64F6jiIUhC7lBcWWbwj+wN6qmuVBTyBQuED3eTKx6q62N0l9
kSrt/DH8GOIdd2ExWNr40RGsYEsxiOnqi2A33OAdX6M7fB6LDuaJ6gCWfBtByzHY
G+7bsirhMBie52TorNScCPsN67kOq6u9zgiiAcndyI0lMprbfP/vSCJ/JQ/EvrTi
dI9tGuVlBnimyXdFZmsH7EQKuTaKRm0Mt0hw/jJvGxeaQe/31LI3B/mohusmHogr
TKLpxAmaUqg=
=s2M3
-----END PGP SIGNATURE-----

to receive the following updates:

 drivers/ata/ahci.c             |    3 +++
 drivers/ata/ahci_platform.c    |    4 ++--
 drivers/ata/libata-eh.c        |   12 +++++++++++-
 drivers/ata/libata-pmp.c       |    7 ++-----
 drivers/ata/libata-scsi.c      |    4 ++++
 drivers/ata/pata_of_platform.c |    2 +-
 drivers/ata/sata_sis.c         |    2 +-
 include/linux/pci_ids.h        |    2 ++
 8 files changed, 26 insertions(+), 10 deletions(-)

Anton Vorontsov (1):
      pata_of_platform: Don't use NO_IRQ

Chris Dunlop (1):
      sata_sis.c: trivial spelling fix

Gwendal Grignou (1):
      [libata] Issue SRST to Sil3726 PMP

JiSheng Zhang (1):
      ahci_platform: use dev_get_platdata()

Keng-Yu Lin (1):
      [libata] ahci: Add ASMedia ASM1061 support

Marcos Paulo de Souza (1):
      [libata] libata-scsi.c: Add function parameter documentation

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fb7b90b..cf26222 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -390,6 +390,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
+	/* Asmedia */
+	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1061 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 004f2ce..ec55595 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -65,7 +65,7 @@ static struct scsi_host_template ahci_platform_sht = {
 static int __init ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct ahci_platform_data *pdata = dev->platform_data;
+	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	const struct platform_device_id *id = platform_get_device_id(pdev);
 	struct ata_port_info pi = ahci_port_info[id->driver_data];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -191,7 +191,7 @@ err0:
 static int __devexit ahci_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct ahci_platform_data *pdata = dev->platform_data;
+	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f22957c..a9b2820 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2883,7 +2883,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	    sata_scr_read(link, SCR_STATUS, &sstatus))
 		rc = -ERESTART;
 
-	if (rc == -ERESTART || try >= max_tries) {
+	if (try >= max_tries) {
 		/*
 		 * Thaw host port even if reset failed, so that the port
 		 * can be retried on the next phy event.  This risks
@@ -2909,6 +2909,16 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		ata_eh_acquire(ap);
 	}
 
+	/*
+	 * While disks spinup behind PMP, some controllers fail sending SRST.
+	 * They need to be reset - as well as the PMP - before retrying.
+	 */
+	if (rc == -ERESTART) {
+		if (ata_is_host_link(link))
+			ata_eh_thaw_port(ap);
+		goto out;
+	}
+
 	if (try == max_tries - 1) {
 		sata_down_spd_limit(link, 0);
 		if (slave)
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 104462d..21b80c5 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -389,12 +389,9 @@ static void sata_pmp_quirks(struct ata_port *ap)
 			/* link reports offline after LPM */
 			link->flags |= ATA_LFLAG_NO_LPM;
 
-			/* Class code report is unreliable and SRST
-			 * times out under certain configurations.
-			 */
+			/* Class code report is unreliable. */
 			if (link->pmp < 5)
-				link->flags |= ATA_LFLAG_NO_SRST |
-					       ATA_LFLAG_ASSUME_ATA;
+				link->flags |= ATA_LFLAG_ASSUME_ATA;
 
 			/* port 5 is for SEMB device and it doesn't like SRST */
 			if (link->pmp == 5)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 72a9770..2a5412e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1217,6 +1217,10 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 
 /**
  *	__ata_change_queue_depth - helper for ata_scsi_change_queue_depth
+ *	@ap: ATA port to which the device change the queue depth
+ *	@sdev: SCSI device to configure queue depth for
+ *	@queue_depth: new queue depth
+ *	@reason: calling context
  *
  *	libsas and libata have different approaches for associating a sdev to
  *	its ata_port.
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index a72ab0d..2a472c5 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -52,7 +52,7 @@ static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 	}
 
 	ret = of_irq_to_resource(dn, 0, &irq_res);
-	if (ret == NO_IRQ)
+	if (!ret)
 		irq_res.start = irq_res.end = 0;
 	else
 		irq_res.flags = 0;
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 447d9c0..95ec435 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -104,7 +104,7 @@ static const struct ata_port_info sis_port_info = {
 };
 
 MODULE_AUTHOR("Uwe Koziolek");
-MODULE_DESCRIPTION("low-level driver for Silicon Integratad Systems SATA controller");
+MODULE_DESCRIPTION("low-level driver for Silicon Integrated Systems SATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sis_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3fdf251..172ba70 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2405,6 +2405,8 @@
 
 #define PCI_VENDOR_ID_AZWAVE		0x1a3b
 
+#define PCI_VENDOR_ID_ASMEDIA		0x1b21
+
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
 #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
 
