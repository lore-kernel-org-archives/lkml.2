Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab2JSLxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:53:20 -0400
Received: from zmc.proxad.net ([212.27.53.206]:53935 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371Ab2JSLxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:53:16 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: bigeasy@linutronix.de
Cc: linux-kernel@vger.kernel.org, x86@vger.kernel.org, mbizon@freebox.fr,
        Florian Fainelli <ffainelli@freebox.fr>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/3] x86: ce4100: force reboot method to be KBD
Date: Fri, 19 Oct 2012 13:51:55 +0200
Message-Id: <1350647516-4842-3-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350647516-4842-1-git-send-email-ffainelli@freebox.fr>
References: <1350647516-4842-1-git-send-email-ffainelli@freebox.fr>
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
1.7.9.5

