Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab2JZJJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:09:14 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36246 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839Ab2JZJGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:06:54 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: tglx@linutronix.de
Cc: mingo@redhat.com, x86@kernel.org, rui.zhang@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH 2/3] x86: ce4100: force reboot method to be KBD
Date: Fri, 26 Oct 2012 11:05:24 +0200
Message-Id: <1351242325-23724-3-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351242325-23724-1-git-send-email-ffainelli@freebox.fr>
References: <1351242325-23724-1-git-send-email-ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

The default reboot is via ACPI for this platform, and the CEFDK bootloader
actually supports this, but will issue a system power off instead of a real
reboot. Setting the reboot method to be KBD instead of ACPI ensures proper
system reboot.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
 arch/x86/platform/ce4100/ce4100.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 74f8774..8c9ed9a 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -21,6 +21,7 @@
 #include <asm/i8259.h>
 #include <asm/io.h>
 #include <asm/io_apic.h>
+#include <asm/emergency-restart.h>
 
 static int ce4100_i8042_detect(void)
 {
@@ -144,6 +145,8 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.pci.init = ce4100_pci_init;
 
+	reboot_type = BOOT_KBD;
+
 #ifdef CONFIG_X86_IO_APIC
 	x86_init.pci.init_irq = sdv_pci_init;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
-- 
1.7.10.4

