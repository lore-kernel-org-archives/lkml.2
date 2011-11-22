Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab1KVWCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:02:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52536 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758549Ab1KVWC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:02:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / Hotplug: Fix the ordering of operations in pcied_cleanup()
Date: Tue, 22 Nov 2011 23:05:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111222305.16077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make pcied_cleanup() unregister the port service before
destroying workqueues that are flushed during the port service
unregistration.

Reported-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/hotplug/pciehp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- linux.orig/drivers/pci/hotplug/pciehp_core.c
+++ linux/drivers/pci/hotplug/pciehp_core.c
@@ -366,9 +366,9 @@ static int __init pcied_init(void)
 static void __exit pcied_cleanup(void)
 {
 	dbg("unload_pciehpd()\n");
+	pcie_port_service_unregister(&hpdriver_portdrv);
 	destroy_workqueue(pciehp_ordered_wq);
 	destroy_workqueue(pciehp_wq);
-	pcie_port_service_unregister(&hpdriver_portdrv);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
 
