Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162039Ab2CSFyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:54:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25453 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161947Ab2CSFtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:42 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 08/26] PCI, acpiphp: Use for_each_pci_dev_resource helper
Date: Sun, 18 Mar 2012 22:48:31 -0700
Message-Id: <1332136129-14010-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F66C8F3.008B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 9d781a7..90e68670d 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1025,10 +1025,10 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 	struct pci_dev *dev;
 	int i;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM;
+	struct resource *res;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		for (i=0; i<PCI_BRIDGE_RESOURCES; i++) {
-			struct resource *res = &dev->resource[i];
+		for_each_pci_dev_nobridge_resource(dev, res, i) {
 			if ((res->flags & type_mask) && !res->start &&
 					res->end) {
 				/* Could not assign a required resources
-- 
1.7.7

