Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab1DRSoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:44:08 -0400
Received: from [69.28.251.93] ([69.28.251.93]:40379 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755954Ab1DRSoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:44:05 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Robert Millan <rmh@gnu.org>, David Daney <ddaney@caviumnetworks.com>,
        wu zhangjin <wuzhangjin@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] MIPS: Introduce set_elf_platform() helper function
Date: Mon, 18 Apr 2011 11:37:55 -0700
Message-Id: <12309140238d597edc0b48cbc07df218@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Millan <rmh@gnu.org>

Replace these sequences:

if (cpu == 0)
	__elf_platform = "foo";

with a trivial inline function.

Signed-off-by: Robert Millan <rmh@gnu.org>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---

v2: Move the new function into cpu-probe.c .  Retained the "inline"
qualifier because all but one of the other helper functions in
cpu-probe.c use it.

 arch/mips/kernel/cpu-probe.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index f65d4c8..4e4a0fd 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -771,6 +771,12 @@ static void __cpuinit decode_configs(struct cpuinfo_mips *c)
 		c->core = read_c0_ebase() & 0x3ff;
 }
 
+static inline void set_elf_platform(int cpu, const char *plat)
+{
+	if (cpu == 0)
+		__elf_platform = plat;
+}
+
 static inline void cpu_probe_mips(struct cpuinfo_mips *c, unsigned int cpu)
 {
 	decode_configs(c);
@@ -956,14 +962,12 @@ static inline void cpu_probe_cavium(struct cpuinfo_mips *c, unsigned int cpu)
 		c->cputype = CPU_CAVIUM_OCTEON_PLUS;
 		__cpu_name[cpu] = "Cavium Octeon+";
 platform:
-		if (cpu == 0)
-			__elf_platform = "octeon";
+		set_elf_platform(cpu, "octeon");
 		break;
 	case PRID_IMP_CAVIUM_CN63XX:
 		c->cputype = CPU_CAVIUM_OCTEON2;
 		__cpu_name[cpu] = "Cavium Octeon II";
-		if (cpu == 0)
-			__elf_platform = "octeon2";
+		set_elf_platform(cpu, "octeon2");
 		break;
 	default:
 		printk(KERN_INFO "Unknown Octeon chip!\n");
-- 
1.7.4.3

