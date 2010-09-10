Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0IJQL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:11:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab0IJQLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:11:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/17] MIPS: Add missing #inclusions of <linux/irq.h>
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>
Date: Fri, 10 Sep 2010 17:10:54 +0100
Message-ID: <20100910161053.20226.87615.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100910161002.20226.27995.stgit@warthog.procyon.org.uk>
References: <20100910161002.20226.27995.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing #inclusions of <linux/irq.h> to a whole bunch of files that should
really include it.  Note that this can replace #inclusions of <asm/irq.h>.

This is required for the patch to sort out irqflags handling function naming to
compile on MIPS.

The problem is that these files require access to things like setup_irq() -
which isn't available by #including <linux/interrupt.h>

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---

 arch/mips/alchemy/devboards/bcsr.c             |    1 +
 arch/mips/ar7/irq.c                            |    1 +
 arch/mips/bcm63xx/irq.c                        |    1 +
 arch/mips/cavium-octeon/serial.c               |    1 +
 arch/mips/dec/setup.c                          |    1 +
 arch/mips/include/asm/mach-loongson/loongson.h |    1 +
 arch/mips/jazz/irq.c                           |    1 +
 arch/mips/kernel/cevt-bcm1480.c                |    1 +
 arch/mips/kernel/cevt-ds1287.c                 |    1 +
 arch/mips/kernel/cevt-gt641xx.c                |    1 +
 arch/mips/kernel/cevt-r4k.c                    |    1 +
 arch/mips/kernel/cevt-sb1250.c                 |    1 +
 arch/mips/kernel/cevt-smtc.c                   |    1 +
 arch/mips/kernel/cevt-txx9.c                   |    1 +
 arch/mips/kernel/i8253.c                       |    1 +
 arch/mips/kernel/i8259.c                       |    1 +
 arch/mips/kernel/irq-gic.c                     |    2 +-
 arch/mips/kernel/irq-rm7000.c                  |    1 +
 arch/mips/kernel/irq-rm9000.c                  |    1 +
 arch/mips/kernel/irq_cpu.c                     |    1 +
 arch/mips/kernel/irq_txx9.c                    |    1 +
 arch/mips/kernel/traps.c                       |    2 +-
 arch/mips/mti-malta/malta-platform.c           |    1 +
 arch/mips/pci/ops-tx3927.c                     |    1 +
 arch/mips/pci/ops-tx4927.c                     |    1 +
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c     |    1 +
 arch/mips/powertv/asic/irq_asic.c              |    1 +
 arch/mips/rb532/serial.c                       |    1 +
 arch/mips/sni/a20r.c                           |    1 +
 arch/mips/sni/pcimt.c                          |    1 +
 arch/mips/sni/pcit.c                           |    1 +
 arch/mips/sni/rm200.c                          |    1 +
 arch/mips/sni/time.c                           |    1 +
 arch/mips/txx9/generic/irq_tx4927.c            |    1 +
 arch/mips/txx9/generic/irq_tx4938.c            |    1 +
 arch/mips/txx9/generic/irq_tx4939.c            |    1 +
 arch/mips/txx9/generic/setup.c                 |    1 +
 arch/mips/txx9/jmr3927/irq.c                   |    1 +
 arch/mips/txx9/rbtx4927/irq.c                  |    1 +
 arch/mips/txx9/rbtx4938/irq.c                  |    1 +
 arch/mips/txx9/rbtx4939/irq.c                  |    1 +
 arch/mips/vr41xx/common/irq.c                  |    1 +
 arch/mips/vr41xx/common/siu.c                  |    1 +
 drivers/vlynq/vlynq.c                          |    1 +
 drivers/watchdog/octeon-wdt-main.c             |    1 +
 45 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/mips/alchemy/devboards/bcsr.c b/arch/mips/alchemy/devboards/bcsr.c
index 3bc4fd2..c52af88 100644
--- a/arch/mips/alchemy/devboards/bcsr.c
+++ b/arch/mips/alchemy/devboards/bcsr.c
@@ -10,6 +10,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/irq.h>
 #include <asm/addrspace.h>
 #include <asm/io.h>
 #include <asm/mach-db1x00/bcsr.h>
diff --git a/arch/mips/ar7/irq.c b/arch/mips/ar7/irq.c
index c781556..4ec2642 100644
--- a/arch/mips/ar7/irq.c
+++ b/arch/mips/ar7/irq.c
@@ -19,6 +19,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
diff --git a/arch/mips/bcm63xx/irq.c b/arch/mips/bcm63xx/irq.c
index a0c5cd1..3be87f2 100644
--- a/arch/mips/bcm63xx/irq.c
+++ b/arch/mips/bcm63xx/irq.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/irq.h>
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <bcm63xx_cpu.h>
diff --git a/arch/mips/cavium-octeon/serial.c b/arch/mips/cavium-octeon/serial.c
index 638adab..12dbf53 100644
--- a/arch/mips/cavium-octeon/serial.c
+++ b/arch/mips/cavium-octeon/serial.c
@@ -13,6 +13,7 @@
 #include <linux/serial_8250.h>
 #include <linux/serial_reg.h>
 #include <linux/tty.h>
+#include <linux/irq.h>
 
 #include <asm/time.h>
 
diff --git a/arch/mips/dec/setup.c b/arch/mips/dec/setup.c
index bd5431e..fa45e92 100644
--- a/arch/mips/dec/setup.c
+++ b/arch/mips/dec/setup.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/pm.h>
+#include <linux/irq.h>
 
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
diff --git a/arch/mips/include/asm/mach-loongson/loongson.h b/arch/mips/include/asm/mach-loongson/loongson.h
index cb6985f..1e29b9d 100644
--- a/arch/mips/include/asm/mach-loongson/loongson.h
+++ b/arch/mips/include/asm/mach-loongson/loongson.h
@@ -13,6 +13,7 @@
 
 #include <linux/io.h>
 #include <linux/init.h>
+#include <linux/irq.h>
 
 /* loongson internal northbridge initialization */
 extern void bonito_irq_init(void);
diff --git a/arch/mips/jazz/irq.c b/arch/mips/jazz/irq.c
index ee18028..35b3e2f 100644
--- a/arch/mips/jazz/irq.c
+++ b/arch/mips/jazz/irq.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
+#include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/i8253.h>
diff --git a/arch/mips/kernel/cevt-bcm1480.c b/arch/mips/kernel/cevt-bcm1480.c
index bfea327..36c3898 100644
--- a/arch/mips/kernel/cevt-bcm1480.c
+++ b/arch/mips/kernel/cevt-bcm1480.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 #include <asm/addrspace.h>
 #include <asm/io.h>
diff --git a/arch/mips/kernel/cevt-ds1287.c b/arch/mips/kernel/cevt-ds1287.c
index 00a4da2..939157e 100644
--- a/arch/mips/kernel/cevt-ds1287.c
+++ b/arch/mips/kernel/cevt-ds1287.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/mc146818rtc.h>
+#include <linux/irq.h>
 
 #include <asm/time.h>
 
diff --git a/arch/mips/kernel/cevt-gt641xx.c b/arch/mips/kernel/cevt-gt641xx.c
index 392ef37..339f363 100644
--- a/arch/mips/kernel/cevt-gt641xx.c
+++ b/arch/mips/kernel/cevt-gt641xx.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/irq.h>
 
 #include <asm/gt64120.h>
 #include <asm/time.h>
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 2a4d50f..2f4d7a9 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -10,6 +10,7 @@
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 #include <asm/smtc_ipi.h>
 #include <asm/time.h>
diff --git a/arch/mips/kernel/cevt-sb1250.c b/arch/mips/kernel/cevt-sb1250.c
index da78eea..590c54f 100644
--- a/arch/mips/kernel/cevt-sb1250.c
+++ b/arch/mips/kernel/cevt-sb1250.c
@@ -17,6 +17,7 @@
  */
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/percpu.h>
 #include <linux/smp.h>
 
diff --git a/arch/mips/kernel/cevt-smtc.c b/arch/mips/kernel/cevt-smtc.c
index b102e4f..2e72d30 100644
--- a/arch/mips/kernel/cevt-smtc.c
+++ b/arch/mips/kernel/cevt-smtc.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 #include <asm/smtc_ipi.h>
 #include <asm/time.h>
diff --git a/arch/mips/kernel/cevt-txx9.c b/arch/mips/kernel/cevt-txx9.c
index 218ee6b..0b73773 100644
--- a/arch/mips/kernel/cevt-txx9.c
+++ b/arch/mips/kernel/cevt-txx9.c
@@ -13,6 +13,7 @@
  */
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/time.h>
 #include <asm/txx9tmr.h>
 
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index 9479406..2392a7a2 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
+#include <linux/irq.h>
 
 #include <asm/delay.h>
 #include <asm/i8253.h>
diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
index 2779911..c58176c 100644
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/sysdev.h>
+#include <linux/irq.h>
 
 #include <asm/i8259.h>
 #include <asm/io.h>
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index b181f2f..e0ff05d 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -3,12 +3,12 @@
 #include <linux/bitmap.h>
 #include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 #include <asm/io.h>
 #include <asm/gic.h>
 #include <asm/gcmpregs.h>
 #include <asm/mips-boards/maltaint.h>
-#include <asm/irq.h>
 #include <linux/hardirq.h>
 #include <asm-generic/bitops/find.h>
 
diff --git a/arch/mips/kernel/irq-rm7000.c b/arch/mips/kernel/irq-rm7000.c
index fb50cc7..9731e8b 100644
--- a/arch/mips/kernel/irq-rm7000.c
+++ b/arch/mips/kernel/irq-rm7000.c
@@ -11,6 +11,7 @@
  */
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 
 #include <asm/irq_cpu.h>
diff --git a/arch/mips/kernel/irq-rm9000.c b/arch/mips/kernel/irq-rm9000.c
index b47e461..b7e4025 100644
--- a/arch/mips/kernel/irq-rm9000.c
+++ b/arch/mips/kernel/irq-rm9000.c
@@ -11,6 +11,7 @@
  */
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index 55c8a3c..0262abe 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
diff --git a/arch/mips/kernel/irq_txx9.c b/arch/mips/kernel/irq_txx9.c
index 9b78029..95a96f6 100644
--- a/arch/mips/kernel/irq_txx9.c
+++ b/arch/mips/kernel/irq_txx9.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/types.h>
+#include <linux/irq.h>
 #include <asm/txx9irq.h>
 
 struct txx9_irc_reg {
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 03ec001..d053bf4 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -28,6 +28,7 @@
 #include <linux/kprobes.h>
 #include <linux/notifier.h>
 #include <linux/kdb.h>
+#include <linux/irq.h>
 
 #include <asm/bootinfo.h>
 #include <asm/branch.h>
@@ -51,7 +52,6 @@
 #include <asm/mmu_context.h>
 #include <asm/types.h>
 #include <asm/stacktrace.h>
-#include <asm/irq.h>
 #include <asm/uasm.h>
 
 extern void check_wait(void);
diff --git a/arch/mips/mti-malta/malta-platform.c b/arch/mips/mti-malta/malta-platform.c
index 72e32a7..4c35301 100644
--- a/arch/mips/mti-malta/malta-platform.c
+++ b/arch/mips/mti-malta/malta-platform.c
@@ -25,6 +25,7 @@
 #include <linux/serial_8250.h>
 #include <linux/mc146818rtc.h>
 #include <linux/module.h>
+#include <linux/irq.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 #include <linux/platform_device.h>
diff --git a/arch/mips/pci/ops-tx3927.c b/arch/mips/pci/ops-tx3927.c
index 31c1501..6a3bdb5 100644
--- a/arch/mips/pci/ops-tx3927.c
+++ b/arch/mips/pci/ops-tx3927.c
@@ -38,6 +38,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <asm/addrspace.h>
 #include <asm/txx9irq.h>
diff --git a/arch/mips/pci/ops-tx4927.c b/arch/mips/pci/ops-tx4927.c
index 5989e74..a1e7e6d 100644
--- a/arch/mips/pci/ops-tx4927.c
+++ b/arch/mips/pci/ops-tx4927.c
@@ -17,6 +17,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/txx9/pci.h>
 #include <asm/txx9/tx4927pcic.h>
 
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
index 94c9c2c..07e71ff 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/bitops.h>
+#include <linux/irq.h>
 
 #include <asm/system.h>
 
diff --git a/arch/mips/powertv/asic/irq_asic.c b/arch/mips/powertv/asic/irq_asic.c
index b54d244..e553824 100644
--- a/arch/mips/powertv/asic/irq_asic.c
+++ b/arch/mips/powertv/asic/irq_asic.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
diff --git a/arch/mips/rb532/serial.c b/arch/mips/rb532/serial.c
index 00ed19f..7048254 100644
--- a/arch/mips/rb532/serial.c
+++ b/arch/mips/rb532/serial.c
@@ -29,6 +29,7 @@
 #include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
+#include <linux/irq.h>
 
 #include <asm/serial.h>
 #include <asm/mach-rc32434/rb.h>
diff --git a/arch/mips/sni/a20r.c b/arch/mips/sni/a20r.c
index e698089..bbe7187 100644
--- a/arch/mips/sni/a20r.c
+++ b/arch/mips/sni/a20r.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 
diff --git a/arch/mips/sni/pcimt.c b/arch/mips/sni/pcimt.c
index 51e62bb..8c92c73 100644
--- a/arch/mips/sni/pcimt.c
+++ b/arch/mips/sni/pcimt.c
@@ -11,6 +11,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/pci.h>
 #include <linux/serial_8250.h>
 
diff --git a/arch/mips/sni/pcit.c b/arch/mips/sni/pcit.c
index f4699d3..dc98745 100644
--- a/arch/mips/sni/pcit.c
+++ b/arch/mips/sni/pcit.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/pci.h>
 #include <linux/serial_8250.h>
 
diff --git a/arch/mips/sni/rm200.c b/arch/mips/sni/rm200.c
index 90c558f..0e6f42c 100644
--- a/arch/mips/sni/rm200.c
+++ b/arch/mips/sni/rm200.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/io.h>
diff --git a/arch/mips/sni/time.c b/arch/mips/sni/time.c
index f3b60e6..c76151b 100644
--- a/arch/mips/sni/time.c
+++ b/arch/mips/sni/time.c
@@ -1,5 +1,6 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/smp.h>
 #include <linux/time.h>
 #include <linux/clockchips.h>
diff --git a/arch/mips/txx9/generic/irq_tx4927.c b/arch/mips/txx9/generic/irq_tx4927.c
index ad2870d..e1828e8 100644
--- a/arch/mips/txx9/generic/irq_tx4927.c
+++ b/arch/mips/txx9/generic/irq_tx4927.c
@@ -25,6 +25,7 @@
  */
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/irq_cpu.h>
 #include <asm/txx9/tx4927.h>
 
diff --git a/arch/mips/txx9/generic/irq_tx4938.c b/arch/mips/txx9/generic/irq_tx4938.c
index 025ae11..a6e6e80 100644
--- a/arch/mips/txx9/generic/irq_tx4938.c
+++ b/arch/mips/txx9/generic/irq_tx4938.c
@@ -13,6 +13,7 @@
  */
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/irq_cpu.h>
 #include <asm/txx9/tx4938.h>
 
diff --git a/arch/mips/txx9/generic/irq_tx4939.c b/arch/mips/txx9/generic/irq_tx4939.c
index 013213a..3886ad7 100644
--- a/arch/mips/txx9/generic/irq_tx4939.c
+++ b/arch/mips/txx9/generic/irq_tx4939.c
@@ -19,6 +19,7 @@
  */
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/types.h>
 #include <asm/irq_cpu.h>
 #include <asm/txx9irq.h>
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 575d219b..812816c 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -24,6 +24,7 @@
 #include <linux/leds.h>
 #include <linux/sysdev.h>
 #include <linux/slab.h>
+#include <linux/irq.h>
 #include <asm/bootinfo.h>
 #include <asm/time.h>
 #include <asm/reboot.h>
diff --git a/arch/mips/txx9/jmr3927/irq.c b/arch/mips/txx9/jmr3927/irq.c
index 6ec626c..0a7f8e3 100644
--- a/arch/mips/txx9/jmr3927/irq.c
+++ b/arch/mips/txx9/jmr3927/irq.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <asm/io.h>
 #include <asm/mipsregs.h>
diff --git a/arch/mips/txx9/rbtx4927/irq.c b/arch/mips/txx9/rbtx4927/irq.c
index 9c14ebb..c4b54d2 100644
--- a/arch/mips/txx9/rbtx4927/irq.c
+++ b/arch/mips/txx9/rbtx4927/irq.c
@@ -111,6 +111,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/io.h>
 #include <asm/mipsregs.h>
 #include <asm/txx9/generic.h>
diff --git a/arch/mips/txx9/rbtx4938/irq.c b/arch/mips/txx9/rbtx4938/irq.c
index 7d21bef..67a73a8 100644
--- a/arch/mips/txx9/rbtx4938/irq.c
+++ b/arch/mips/txx9/rbtx4938/irq.c
@@ -64,6 +64,7 @@
  */
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/mipsregs.h>
 #include <asm/txx9/generic.h>
 #include <asm/txx9/rbtx4938.h>
diff --git a/arch/mips/txx9/rbtx4939/irq.c b/arch/mips/txx9/rbtx4939/irq.c
index 500cc0a..57fa740 100644
--- a/arch/mips/txx9/rbtx4939/irq.c
+++ b/arch/mips/txx9/rbtx4939/irq.c
@@ -11,6 +11,7 @@
  */
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/mipsregs.h>
 #include <asm/txx9/rbtx4939.h>
 
diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
index bef0687..0975eb7 100644
--- a/arch/mips/vr41xx/common/irq.c
+++ b/arch/mips/vr41xx/common/irq.c
@@ -19,6 +19,7 @@
  */
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/system.h>
diff --git a/arch/mips/vr41xx/common/siu.c b/arch/mips/vr41xx/common/siu.c
index 54eae56..bbd45d2 100644
--- a/arch/mips/vr41xx/common/siu.c
+++ b/arch/mips/vr41xx/common/siu.c
@@ -22,6 +22,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/serial_core.h>
+#include <linux/irq.h>
 
 #include <asm/cpu.h>
 #include <asm/vr41xx/siu.h>
diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index f2d9e66..f885c86 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/irq.h>
 
 #include <linux/vlynq.h>
 
diff --git a/drivers/watchdog/octeon-wdt-main.c b/drivers/watchdog/octeon-wdt-main.c
index 2a41017..9099238 100644
--- a/drivers/watchdog/octeon-wdt-main.c
+++ b/drivers/watchdog/octeon-wdt-main.c
@@ -64,6 +64,7 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/fs.h>
+#include <linux/irq.h>
 
 #include <asm/mipsregs.h>
 #include <asm/uasm.h>

