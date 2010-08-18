Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0HRS17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:27:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34728 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0HRS16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:27:58 -0400
Subject: [PATCH] powerpc/pci: fix checking for child bridges in PCI code.
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Julia Lawall <julia@diku.dk>
Date: Wed, 18 Aug 2010 12:27:55 -0600
Message-ID: <20100818182727.29483.53699.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_device_to_OF_node() can return null, and list_for_each_entry will
never enter the loop when dev is NULL, so it looks like this test is
a typo.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/kernel/pci_of_scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 6ddb795..e751506 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -336,7 +336,7 @@ static void __devinit __of_scan_bus(struct device_node *node,
 		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
 		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 			struct device_node *child = pci_device_to_OF_node(dev);
-			if (dev)
+			if (child)
 				of_scan_pci_bridge(child, dev);
 		}
 	}

