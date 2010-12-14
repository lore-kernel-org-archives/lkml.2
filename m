Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab0LNWsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:48:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:42901 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932211Ab0LNWsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:48:54 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1+XfW5AjtqXwZKM2Apuva2wimCl49571gKoe882EE
	ZFtzj+uVS77Lni
Date: Tue, 14 Dec 2010 23:48:48 +0100
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arch/arm/kernel: use cpu_relax() in halt loops
Message-ID: <20101214224848.GA1706@debian.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking throught arch/arm/kernel/ I found some halt loops.
I just thought we could save some power here using cpu_relax(),
or am I missing something?

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 arch/arm/kernel/process.c |    6 ++++--
 arch/arm/kernel/setup.c   |    7 +++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index e76fcaa..4a83fdf 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -124,7 +124,8 @@ void arm_machine_restart(char mode, const char *cmd)
 	 */
 	mdelay(1000);
 	printk("Reboot failed -- System halted\n");
-	while (1);
+	while (1)
+		cpu_relax();
 }
 
 /*
@@ -235,7 +236,8 @@ void machine_shutdown(void)
 void machine_halt(void)
 {
 	machine_shutdown();
-	while (1);
+	while (1)
+		cpu_relax();
 }
 
 void machine_power_off(void)
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 336f14e..0d77329 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -41,6 +41,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cachetype.h>
 #include <asm/tlbflush.h>
+#include <asm/processor.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
@@ -337,7 +338,8 @@ static void __init setup_processor(void)
 	if (!list) {
 		printk("CPU configuration botched (ID %08x), unable "
 		       "to continue.\n", read_cpuid_id());
-		while (1);
+		while (1)
+			cpu_relax();
 	}
 
 	cpu_name = list->cpu_name;
@@ -434,7 +436,8 @@ static struct machine_desc * __init setup_machine(unsigned int nr)
 	if (!list) {
 		printk("Machine configuration botched (nr %d), unable "
 		       "to continue.\n", nr);
-		while (1);
+		while (1)
+			cpu_relax();
 	}
 
 	printk("Machine: %s\n", list->name);
-- 
1.7.2.3
