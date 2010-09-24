Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab0IXQgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:36:53 -0400
Received: from kroah.org ([198.145.64.141]:37475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982Ab0IXQgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:36:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.702195055@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [64/68] [PATCH] pata_pdc202xx_old: fix UDMA mode for PDC2026x chipsets
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 750e519da7b3f470fe1b5b55c8d8f52d6d6371e4 upstream.

PDC2026x chipsets need the same treatment as PDC20246 one.

This is completely untested but will hopefully fix UDMA issues
that people have been reporting against pata_pdc202xx_old for
the last couple of years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_pdc202xx_old.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -35,7 +35,7 @@ static int pdc2026x_cable_detect(struct
 	return ATA_CBL_PATA80;
 }
 
-static void pdc20246_exec_command(struct ata_port *ap,
+static void pdc202xx_exec_command(struct ata_port *ap,
 				  const struct ata_taskfile *tf)
 {
 	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
@@ -281,7 +281,7 @@ static struct ata_port_operations pdc202
 	.set_piomode		= pdc202xx_set_piomode,
 	.set_dmamode		= pdc202xx_set_dmamode,
 
-	.sff_exec_command	= pdc20246_exec_command,
+	.sff_exec_command	= pdc202xx_exec_command,
 };
 
 static struct ata_port_operations pdc2026x_port_ops = {
@@ -295,6 +295,8 @@ static struct ata_port_operations pdc202
 	.dev_config		= pdc2026x_dev_config,
 
 	.port_start		= pdc2026x_port_start,
+
+	.sff_exec_command	= pdc202xx_exec_command,
 };
 
 static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)


