Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2BYVzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 16:55:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:23650 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2BYVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 16:54:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/4] PCI: export __pci_remove_bus_device
Date: Sat, 25 Feb 2012 13:54:21 -0800
Message-Id: <1330206863-31381-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
References: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F4958A7.005E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use pci_remove_bus_device yet, still keep __ prefix.
That means it only remove without stop at first.

So other non in kernel users or pending patches get notified from
compiler warning.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/remove.c |    4 +++-
 include/linux/pci.h  |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -90,7 +90,7 @@ static void __pci_remove_behind_bridge(s
  * device lists, remove the /proc entry, and notify userspace
  * (/sbin/hotplug).
  */
-static void __pci_remove_bus_device(struct pci_dev *dev)
+void __pci_remove_bus_device(struct pci_dev *dev)
 {
 	if (dev->subordinate) {
 		struct pci_bus *b = dev->subordinate;
@@ -102,6 +102,8 @@ static void __pci_remove_bus_device(stru
 
 	pci_destroy_dev(dev);
 }
+EXPORT_SYMBOL(__pci_remove_bus_device);
+
 void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 {
 	pci_stop_bus_device(dev);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -686,6 +686,7 @@ u8 pci_common_swizzle(struct pci_dev *de
 extern struct pci_dev *pci_dev_get(struct pci_dev *dev);
 extern void pci_dev_put(struct pci_dev *dev);
 extern void pci_remove_bus(struct pci_bus *b);
+extern void __pci_remove_bus_device(struct pci_dev *dev);
 extern void pci_stop_and_remove_bus_device(struct pci_dev *dev);
 extern void pci_stop_bus_device(struct pci_dev *dev);
 void pci_setup_cardbus(struct pci_bus *bus);
