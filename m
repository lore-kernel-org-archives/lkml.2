Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1HFPcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:32:54 -0400
Received: from www17.your-server.de ([213.133.104.17]:33315 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1HFPcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:32:52 -0400
Subject: [PATCH] [SCSI] aic7xxx: use kstrdup()
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org, hare@suse.de, linux-scsi@vger.kernel.org
Date: Sat, 06 Aug 2011 17:32:20 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312644743.5589.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kstrdup rather than duplicating its implementation

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/kstrdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c 2010-09-13 07:01:17.527194675 +0200
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c 2011-08-01 21:15:57.685101664 +0200
@@ -225,10 +225,9 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 		ahc_get_pci_bus(pci),
 		ahc_get_pci_slot(pci),
 		ahc_get_pci_function(pci));
-	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
 		return (-ENOMEM);
-	strcpy(name, buf);
 	ahc = ahc_alloc(NULL, name);
 	if (ahc == NULL)
 		return (-ENOMEM);



