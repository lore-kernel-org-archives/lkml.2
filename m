Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2CSF6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:58:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30823 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161546Ab2CSFsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:11 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 33/47] PCI: Add debug print out for pci related dev release
Date: Sun, 18 Mar 2012 22:46:22 -0700
Message-Id: <1332135996-13860-34-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F66C899.0019,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some case, they could not be called because some users just use
get_device() without put device back.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a819e76..14f2e69 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -57,6 +57,7 @@ static void release_pcibus_dev(struct device *dev)
 
 	if (pci_bus->bridge)
 		put_device(pci_bus->bridge);
+	dev_printk(KERN_DEBUG, dev, "freeing pci_bus info\n");
 	pci_bus_remove_resources(pci_bus);
 	pci_release_bus_of_node(pci_bus);
 	kfree(pci_bus);
@@ -1259,6 +1260,7 @@ static void pci_release_dev(struct device *dev)
 {
 	struct pci_dev *pci_dev;
 
+	dev_printk(KERN_DEBUG, dev, "freeing pci_dev info\n");
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
@@ -1323,6 +1325,7 @@ static void pci_release_bus_bridge_dev(struct device *dev)
 {
 	struct pci_host_bridge *bridge = to_pci_host_bridge(dev);
 
+	dev_printk(KERN_DEBUG, dev, "freeing pci_host_bridge info\n");
 	if (bridge->release_fn)
 		bridge->release_fn(bridge);
 
-- 
1.7.7

