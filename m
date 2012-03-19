Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162022Ab2CSFtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31314 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161952Ab2CSFtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 11/26] PCI: Use for_each_pci_dev_resource pci_reassigndev
Date: Sun, 18 Mar 2012 22:48:34 -0700
Message-Id: <1332136129-14010-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F66C8F7.003C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 44b4835..5439033 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3718,8 +3718,7 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	command &= ~PCI_COMMAND_MEMORY;
 	pci_write_config_word(dev, PCI_COMMAND, command);
 
-	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
-		r = &dev->resource[i];
+	for_each_pci_dev_nobridge_resource(dev, r, i) {
 		if (!(r->flags & IORESOURCE_MEM))
 			continue;
 		size = resource_size(r);
@@ -3738,8 +3737,7 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	 */
 	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
 	    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
-		for (i = PCI_BRIDGE_RESOURCES; i < PCI_NUM_RESOURCES; i++) {
-			r = &dev->resource[i];
+		for_each_pci_dev_bridge_resource(dev, r, i) {
 			if (!(r->flags & IORESOURCE_MEM))
 				continue;
 			r->end = resource_size(r) - 1;
-- 
1.7.7

