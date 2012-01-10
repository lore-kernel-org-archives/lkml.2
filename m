Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2AJDEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 22:04:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34635 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755975Ab2AJDEi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 22:04:38 -0500
Message-ID: <1326164672.3432.34.camel@deadeye>
Subject: [PATCHv2 2/2] cpu: Register a generic CPU device on architectures
 that currently do not
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org,
        Richard Weinberger <richard@nod.at>
Date: Tue, 10 Jan 2012 03:04:32 +0000
In-Reply-To: <1326164389.3432.29.camel@deadeye>
References: <1326164389.3432.29.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frv, h8300, m68k, microblaze, openrisc, score, um and xtensa currently
do not register a CPU device.  Add the config option
GENERIC_CPU_DEVICES which causes a generic CPU device to be registered
for each present CPU, and make all these architectures select it.

Richard Weinberger <richard@nod.at> covered UML and suggested using
per_cpu.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This is a combination of the previous version with Richard's patch for
UML.  I also changed the error path to use panic() so that nothing else
has to check for missing CPU devices.

Ben.

 arch/frv/Kconfig        |    1 +
 arch/h8300/Kconfig      |    1 +
 arch/m68k/Kconfig       |    1 +
 arch/microblaze/Kconfig |    1 +
 arch/openrisc/Kconfig   |    1 +
 arch/score/Kconfig      |    1 +
 arch/um/Kconfig.common  |    1 +
 arch/xtensa/Kconfig     |    1 +
 drivers/base/Kconfig    |    4 ++++
 drivers/base/cpu.c      |   19 +++++++++++++++++++
 10 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index bad27a6..70554ba 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -8,6 +8,7 @@ config FRV
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CPU_DEVICES
 
 config ZONE_DMA
 	bool
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index d1f377f..56e890d 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -4,6 +4,7 @@ config H8300
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CPU_DEVICES
 
 config SYMBOL_PREFIX
 	string
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 81fdaa7..f755ecf 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
+	select GENERIC_CPU_DEVICES
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index e446bab..16ca257 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -17,6 +17,7 @@ config MICROBLAZE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CPU_DEVICES
 
 config SWAP
 	def_bool n
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index e518a5a..978e0bd 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -15,6 +15,7 @@ config OPENRISC
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
+	select GENERIC_CPU_DEVICES
 
 config MMU
 	def_bool y
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 8b0c946..51cbf1e 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -7,6 +7,7 @@ config SCORE
        select HAVE_MEMBLOCK
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
+       select GENERIC_CPU_DEVICES
 
 choice
 	prompt "System type"
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index a923483..b37ae70 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -8,6 +8,7 @@ config UML
 	default y
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CPU_DEVICES
 
 config MMU
 	bool
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index c346ccd..8a3f835 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -9,6 +9,7 @@ config XTENSA
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CPU_DEVICES
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 21cf46f..4ebc5d3 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -172,6 +172,10 @@ config SYS_HYPERVISOR
 	bool
 	default n
 
+config GENERIC_CPU_DEVICES
+	bool
+	default n
+
 source "drivers/base/regmap/Kconfig"
 
 endmenu
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index bba70d0..db87e78 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/node.h>
 #include <linux/gfp.h>
+#include <linux/percpu.h>
 
 #include "base.h"
 
@@ -275,11 +276,29 @@ bool cpu_is_hotpluggable(unsigned cpu)
 }
 EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
 
+#ifdef CONFIG_GENERIC_CPU_DEVICES
+static DEFINE_PER_CPU(struct cpu, cpu_devices);
+#endif
+
+static void __init cpu_dev_register_generic(void)
+{
+#ifdef CONFIG_GENERIC_CPU_DEVICES
+	int i;
+
+	for_each_possible_cpu(i) {
+		if (register_cpu(&per_cpu(cpu_devices, i), i))
+			panic("Failed to register CPU device");
+	}
+#endif
+}
+
 void __init cpu_dev_init(void)
 {
 	if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
 		panic("Failed to register CPU subsystem");
 
+	cpu_dev_register_generic();
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
 #endif
-- 
1.7.8.2


