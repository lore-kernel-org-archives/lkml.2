Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab0KWSgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:36:50 -0500
Received: from [69.28.251.93] ([69.28.251.93]:37238 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab0KWSgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:36:49 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <alex@ozo.com>, <florian@openwrt.org>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] MIPS: Fix regression on BCM4710 processor detection
Date: Tue, 23 Nov 2010 10:26:45 -0800
Message-Id: <e5a865920b2154408318972b62e92953@localhost>
In-Reply-To: <8a8eee995454c8b271cceb440e31699a@localhost>
References: <8a8eee995454c8b271cceb440e31699a@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BCM4710 uses the BMIPS32 core (like BCM6345), not the MIPS 4Kc core as
was previously believed.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Tested-by: Alexandros C. Couloumbis <alex@ozo.com>
---
 arch/mips/include/asm/cpu.h  |    4 ++--
 arch/mips/kernel/cpu-probe.c |    7 ++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 06d59dc..8687753 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -111,8 +111,8 @@
  * These are the PRID's for when 23:16 == PRID_COMP_BROADCOM
  */
 
-#define PRID_IMP_BMIPS4KC	0x4000
-#define PRID_IMP_BMIPS32	0x8000
+#define PRID_IMP_BMIPS32_REV4	0x4000
+#define PRID_IMP_BMIPS32_REV8	0x8000
 #define PRID_IMP_BMIPS3300	0x9000
 #define PRID_IMP_BMIPS3300_ALT	0x9100
 #define PRID_IMP_BMIPS3300_BUG	0x0000
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 71620e1..68dae7b 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -905,7 +905,8 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 {
 	decode_configs(c);
 	switch (c->processor_id & 0xff00) {
-	case PRID_IMP_BMIPS32:
+	case PRID_IMP_BMIPS32_REV4:
+	case PRID_IMP_BMIPS32_REV8:
 		c->cputype = CPU_BMIPS32;
 		__cpu_name[cpu] = "Broadcom BMIPS32";
 		break;
@@ -933,10 +934,6 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 		__cpu_name[cpu] = "Broadcom BMIPS5000";
 		c->options |= MIPS_CPU_ULRI;
 		break;
-	case PRID_IMP_BMIPS4KC:
-		c->cputype = CPU_4KC;
-		__cpu_name[cpu] = "MIPS 4Kc";
-		break;
 	}
 }
 
-- 
1.7.0.4

