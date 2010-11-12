Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab0KLViU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:38:20 -0500
Received: from mail.perches.com ([173.55.12.10]:4999 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab0KLViM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:12 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] arch/powerpc: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:53 -0800
Message-Id: <7654162f86bedd7d4cd5ccc883916157af6a2369.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kernel/pci_64.c     |    3 +--
 arch/powerpc/sysdev/tsi108_dev.c |    8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index d43fc65..2ecb1de 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -193,8 +193,7 @@ int __devinit pcibios_map_io_space(struct pci_bus *bus)
 	hose->io_resource.start += io_virt_offset;
 	hose->io_resource.end += io_virt_offset;
 
-	pr_debug("  hose->io_resource=0x%016llx...0x%016llx\n",
-		 hose->io_resource.start, hose->io_resource.end);
+	pr_debug("  hose->io_resource=%pR\n", &hose->io_resource.start);
 
 	return 0;
 }
diff --git a/arch/powerpc/sysdev/tsi108_dev.c b/arch/powerpc/sysdev/tsi108_dev.c
index d4d15aa..5e249a8 100644
--- a/arch/powerpc/sysdev/tsi108_dev.c
+++ b/arch/powerpc/sysdev/tsi108_dev.c
@@ -83,8 +83,8 @@ static int __init tsi108_eth_of_init(void)
 		memset(&tsi_eth_data, 0, sizeof(tsi_eth_data));
 
 		ret = of_address_to_resource(np, 0, &r[0]);
-		DBG("%s: name:start->end = %s:0x%lx-> 0x%lx\n",
-			__func__,r[0].name, r[0].start, r[0].end);
+		DBG("%s: name:start->end = %s:%pR\n",
+		    __func__, r[0].name, &r[0]);
 		if (ret)
 			goto err;
 
@@ -92,8 +92,8 @@ static int __init tsi108_eth_of_init(void)
 		r[1].start = irq_of_parse_and_map(np, 0);
 		r[1].end = irq_of_parse_and_map(np, 0);
 		r[1].flags = IORESOURCE_IRQ;
-		DBG("%s: name:start->end = %s:0x%lx-> 0x%lx\n",
-			__func__,r[1].name, r[1].start, r[1].end);
+		DBG("%s: name:start->end = %s:%pR\n",
+			__func__, r[1].name, &r[1]);
 
 		tsi_eth_dev =
 		    platform_device_register_simple("tsi-ethernet", i++, &r[0],
-- 
1.7.3.1.g432b3.dirty

