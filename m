Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0FILV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:21:56 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37213 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757606Ab0FILVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:21:54 -0400
Date: Wed, 9 Jun 2010 13:21:53 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 5/9] Removing dead CONFIG_BLK_DEV_IDE
Message-ID: <73e9e4bd7615488c9567f02f8962825386956365.1275925108.git.siccegge@cs.fau.de>
References: <cover.1275925108.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925108.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_BLK_DEV_IDE doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/mips/mti-malta/malta-setup.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/arch/mips/mti-malta/malta-setup.c b/arch/mips/mti-malta/malta-setup.c
index b7f37d4..d85143c 100644
--- a/arch/mips/mti-malta/malta-setup.c
+++ b/arch/mips/mti-malta/malta-setup.c
@@ -105,28 +105,6 @@ static void __init fd_activate(void)
 }
 #endif
 
-#ifdef CONFIG_BLK_DEV_IDE
-static void __init pci_clock_check(void)
-{
-	unsigned int __iomem *jmpr_p =
-		(unsigned int *) ioremap(MALTA_JMPRS_REG, sizeof(unsigned int));
-	int jmpr = (__raw_readl(jmpr_p) >> 2) & 0x07;
-	static const int pciclocks[] __initdata = {
-		33, 20, 25, 30, 12, 16, 37, 10
-	};
-	int pciclock = pciclocks[jmpr];
-	char *argptr = prom_getcmdline();
-
-	if (pciclock != 33 && !strstr(argptr, "idebus=")) {
-		printk(KERN_WARNING "WARNING: PCI clock is %dMHz, "
-				"setting idebus\n", pciclock);
-		argptr += strlen(argptr);
-		sprintf(argptr, " idebus=%d", pciclock);
-		if (pciclock < 20 || pciclock > 66)
-			printk(KERN_WARNING "WARNING: IDE timing "
-					"calculations will be incorrect\n");
-	}
-}
 #endif
 
 #if defined(CONFIG_VT) && defined(CONFIG_VGA_CONSOLE)
@@ -207,9 +185,6 @@ void __init plat_mem_setup(void)
 	if (mips_revision_sconid == MIPS_REVISION_SCON_BONITO)
 		bonito_quirks_setup();
 
-#ifdef CONFIG_BLK_DEV_IDE
-	pci_clock_check();
-#endif
 
 #ifdef CONFIG_BLK_DEV_FD
 	fd_activate();
-- 
1.6.3.3

