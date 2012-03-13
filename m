Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab2CMH1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:27:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27828 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759877Ab2CMH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:27:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/12] PCI: Add debug print out for pci related dev release
Date: Tue, 13 Mar 2012 00:26:23 -0700
Message-Id: <1331623594-30543-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F5EF6C8.0010,ss=1,re=0.000,fgs=0
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
index 0ca213c..972553b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -57,6 +57,7 @@ static void release_pcibus_dev(struct device *dev)
 
 	if (pci_bus->bridge)
 		put_device(pci_bus->bridge);
+	dev_printk(KERN_DEBUG, dev, "freeing pci_bus info\n");
 	pci_bus_remove_resources(pci_bus);
 	pci_release_bus_of_node(pci_bus);
 	kfree(pci_bus);
@@ -1278,6 +1279,7 @@ static void pci_release_dev(struct device *dev)
 {
 	struct pci_dev *pci_dev;
 
+	dev_printk(KERN_DEBUG, dev, "freeing pci_dev info\n");
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
@@ -1342,6 +1344,7 @@ static void pci_release_bus_bridge_dev(struct device *dev)
 {
 	struct pci_host_bridge *bridge = to_pci_host_bridge(dev);
 
+	dev_printk(KERN_DEBUG, dev, "freeing pci_host_bridge info\n");
 	if (bridge->release_fn)
 		bridge->release_fn(bridge);
 
-- 
1.7.7

