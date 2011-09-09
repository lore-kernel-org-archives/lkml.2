Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab1IIVmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:42:37 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:13392 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab1IIVmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:42:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1315604555!11129810!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] probe_roms.c: quiet sparse noise and fix return type of pci_map_biosrom
Date: Fri, 9 Sep 2011 14:42:24 -0700
User-Agent: KMail/1.9.9
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <paul.gortmaker@windriver.com>, <jkosina@suse.cz>,
        <dave.jiang@intel.com>, <joe@perches.com>, <dan.j.williams@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091442.24741.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pci_map_biosrom is declared in <asm/probe_roms.h> as returning
a void __iomem * but is implemented in the code to return a void *.

Include <asm/probe_roms.h> to pick up the declarations and fix the return
type of pci_map_biosrom to match the declaration.  This quiets the following
sparse noise:

warning: incorrect type in return expression (different address spaces)
   expected void *
   got void [noderef] <asn:2>*
warning: symbol 'pci_map_biosrom' was not declared. Should it be static?
warning: symbol 'pci_unmap_biosrom' was not declared. Should it be static?
warning: symbol 'pci_biosrom_size' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dan Williams <dan.j.williams@intel.com>

---

diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 34e06e8..c0a8915 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -19,6 +19,7 @@
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/setup_arch.h>
+#include <asm/probe_roms.h>
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
@@ -149,7 +150,7 @@ static struct resource *find_oprom(struct pci_dev *pdev)
 	return oprom;
 }
 
-void *pci_map_biosrom(struct pci_dev *pdev)
+void __iomem *pci_map_biosrom(struct pci_dev *pdev)
 {
 	struct resource *oprom = find_oprom(pdev);
 
