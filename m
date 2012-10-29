Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab2J2Nls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:41:48 -0400
Received: from zmc.proxad.net ([212.27.53.206]:41639 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab2J2Nlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:41:46 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: tglx@linutronix.de
Cc: mingo@redhat.com, x86@kernel.org, rui.zhang@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Florian Fainelli <ffainelli@freebox.fr>,
        Maxime Bizon <mbizon@freebox.fr>
Subject: [PATCH 2/3 v3] x86: ce4100: force reboot method to be KBD
Date: Mon, 29 Oct 2012 14:40:19 +0100
Message-Id: <1351518020-25556-3-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351518020-25556-1-git-send-email-ffainelli@freebox.fr>
References: <1351251054-19892-1-git-send-email-ffainelli@freebox.fr>
 <1351518020-25556-1-git-send-email-ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

The default reboot is via ACPI for this platform, and the CEFDK bootloader
actually supports this, but will issue a system power off instead of a real
reboot. Setting the reboot method to be KBD instead of ACPI ensures proper
system reboot.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
 arch/x86/platform/ce4100/ce4100.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 5de16e3..92525cb 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -21,6 +21,7 @@
 #include <asm/i8259.h>
 #include <asm/io.h>
 #include <asm/io_apic.h>
+#include <asm/emergency-restart.h>
 
 static int ce4100_i8042_detect(void)
 {
@@ -151,6 +152,15 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.pci.init = ce4100_pci_init;
 
+	/*
+	 * By default, the reboot method is ACPI which is supported by the
+	 * CE4100 bootloader CEFDK using FADT.ResetReg Address and ResetValue
+	 * the bootloader will however issue a system power off instead of
+	 * reboot. By using BOOT_KBD we ensure proper system reboot as
+	 * expected.
+	 */
+	reboot_type = BOOT_KBD;
+
 #ifdef CONFIG_X86_IO_APIC
 	x86_init.pci.init_irq = sdv_pci_init;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
-- 
1.7.10.4

