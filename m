Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1JKSZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab1JKSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:45 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 2/3] pata_serverworks: cleanup cable detection
Date: Tue, 11 Oct 2011 20:11:44 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112011.44748.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: cleanup cable detection

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2010/1/18/324

 drivers/ata/pata_serverworks.c |   37 +++++++------------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -57,32 +57,14 @@ static const char *csb_bad_ata100[] = {
 };
 
 /**
- *	dell_cable	-	Dell serverworks cable detection
+ *	oem_cable	-	Dell/Sun serverworks cable detection
  *	@ap: ATA port to do cable detect
  *
- *	Dell hide the 40/80 pin select for their interfaces in the top two
- *	bits of the subsystem ID.
+ *	Dell PowerEdge and Sun Cobalt 'Alpine' hide the 40/80 pin select
+ *	for their interfaces in the top two bits of the subsystem ID.
  */
 
-static int dell_cable(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
-		return ATA_CBL_PATA80;
-	return ATA_CBL_PATA40;
-}
-
-/**
- *	sun_cable	-	Sun Cobalt 'Alpine' cable detection
- *	@ap: ATA port to do cable select
- *
- *	Cobalt CSB5 IDE hides the 40/80pin in the top two bits of the
- *	subsystem ID the same as dell. We could use one function but we may
- *	need to extend the Dell one in future
- */
-
-static int sun_cable(struct ata_port *ap)
+static int oem_cable(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
@@ -97,15 +79,10 @@ struct sv_cable_table {
 	int (*cable_detect)(struct ata_port *ap);
 };
 
-/*
- *	Note that we don't copy the old serverworks code because the old
- *	code contains obvious mistakes
- */
-
 static struct sv_cable_table cable_detect[] = {
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, dell_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, dell_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  sun_cable  },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  oem_cable },
 	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE,   PCI_ANY_ID, ata_cable_40wire  },
 	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_ANY_ID, ata_cable_unknown },
 	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_ANY_ID, ata_cable_unknown },
