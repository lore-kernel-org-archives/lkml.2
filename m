Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1JKS1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:27:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37696 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1JKSZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:43 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/3] pata_serverworks: use standard cable detection methods
Date: Tue, 11 Oct 2011 20:09:31 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112009.32126.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: use standard cable detection methods

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/375

 drivers/ata/pata_serverworks.c |   45 ++++++++++-------------------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -64,7 +64,8 @@ static const char *csb_bad_ata100[] = {
  *	bits of the subsystem ID.
  */
 
-static int dell_cable(struct ata_port *ap) {
+static int dell_cable(struct ata_port *ap)
+{
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
@@ -81,7 +82,8 @@ static int dell_cable(struct ata_port *a
  *	need to extend the Dell one in future
  */
 
-static int sun_cable(struct ata_port *ap) {
+static int sun_cable(struct ata_port *ap)
+{
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
@@ -89,29 +91,6 @@ static int sun_cable(struct ata_port *ap
 	return ATA_CBL_PATA40;
 }
 
-/**
- *	osb4_cable	-	OSB4 cable detect
- *	@ap: ATA port to check
- *
- *	The OSB4 isn't UDMA66 capable so this is easy
- */
-
-static int osb4_cable(struct ata_port *ap) {
-	return ATA_CBL_PATA40;
-}
-
-/**
- *	csb_cable	-	CSB5/6 cable detect
- *	@ap: ATA port to check
- *
- *	Serverworks default arrangement is to use the drive side detection
- *	only.
- */
-
-static int csb_cable(struct ata_port *ap) {
-	return ATA_CBL_PATA_UNK;
-}
-
 struct sv_cable_table {
 	int device;
 	int subvendor;
@@ -124,14 +103,14 @@ struct sv_cable_table {
  */
 
 static struct sv_cable_table cable_detect[] = {
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_VENDOR_ID_DELL, dell_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE, PCI_VENDOR_ID_DELL, dell_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_VENDOR_ID_SUN,  sun_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE, PCI_ANY_ID, osb4_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_ANY_ID, csb_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE, PCI_ANY_ID, csb_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2, PCI_ANY_ID, csb_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, csb_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, dell_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, dell_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  sun_cable  },
+	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE,   PCI_ANY_ID, ata_cable_40wire  },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2,  PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, ata_cable_unknown },
 	{ }
 };
 
