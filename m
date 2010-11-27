Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0K0Ulh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 15:41:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46701 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753380Ab0K0Ulf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 15:41:35 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1/Pk7JVoczPj04bYtL5RgZZQjm2wD7SsAUg0TYGSk
	agHleLsqFXAdSQ
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] arch/arm/kernel: use cpu_relax() in halt loops
Date: Sat, 27 Nov 2010 21:20:24 +0100
Message-Id: <1290889224-23964-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please note that this change is untested.
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

