Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2GYT4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:56:42 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:9169 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2GYT4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:56:40 -0400
Message-ID: <201207251956.q6PJudJi016693@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 25 Jul 2012 15:49:23 -0400
Subject: [PATCH] tilepro pci: fix pci_bus.subordinate bad bombing from b918c62e
To: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bombing to convert pci_bus.subordinate to busn_res.end accidentally
modified a "struct pci_dev" site, causing this file not to compile.
This commit reverts that code to use dev->subordinate again.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 0fdd99d..33c1086 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -369,7 +369,7 @@ int __init pcibios_init(void)
 				 */
 				if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
 					(PCI_SLOT(dev->devfn) == 0)) {
-					next_bus = dev->busn_res.end;
+					next_bus = dev->subordinate;
 					controllers[i].mem_resources[0] =
 						*next_bus->resource[0];
 					controllers[i].mem_resources[1] =
-- 
1.7.10.3

