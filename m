Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab0GAWDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:03:18 -0400
Received: from kroah.org ([198.145.64.141]:33758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758757Ab0GAVMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:54 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:47 2010
Message-Id: <20100701174247.712412886@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [015/200] sata_nv: use ata_pci_sff_activate_host() instead of ata_host_activate()
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 95cc2c70c139936a2142bcd583da8af6f9d88efb upstream.

sata_nv was incorrectly using ata_host_activate() instead of
ata_pci_sff_activate_host() leading to IRQ assignment failure in
legacy mode.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_nv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -2479,8 +2479,7 @@ static int nv_init_one(struct pci_dev *p
 	}
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
-				 IRQF_SHARED, ipriv->sht);
+	return ata_pci_sff_activate_host(host, ipriv->irq_handler, ipriv->sht);
 }
 
 #ifdef CONFIG_PM


