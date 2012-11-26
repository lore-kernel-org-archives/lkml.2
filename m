Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2KZVGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:06:32 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47848 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab2KZVGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:06:22 -0500
Subject: [PATCH 5/5] Add an ioctl to communicate the consign limit to the
 host.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com
Date: Mon, 26 Nov 2012 15:06:06 -0600
Message-ID: <20121126210606.407.85721.stgit@lambeau>
In-Reply-To: <20121126210432.407.50742.stgit@lambeau>
References: <20121126210432.407.50742.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12112621-1396-0000-0000-000002379FED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an ioctl to communicate the consign limit to the host.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 CREDITS                                            |    5 
 Documentation/arm64/memory.txt                     |   12 
 Documentation/cgroups/memory.txt                   |    4 
 .../devicetree/bindings/net/mdio-gpio.txt          |    9 
 Documentation/filesystems/proc.txt                 |   16 
 Documentation/hwmon/fam15h_power                   |    2 
 Documentation/kernel-parameters.txt                |   20 
 Documentation/networking/netdev-features.txt       |    2 
 Documentation/scheduler/numa-problem.txt           |   20 
 MAINTAINERS                                        |   87 +
 Makefile                                           |    2 
 arch/alpha/kernel/osf_sys.c                        |    6 
 arch/arm/boot/Makefile                             |   10 
 arch/arm/boot/dts/tegra30.dtsi                     |    4 
 arch/arm/include/asm/io.h                          |    4 
 arch/arm/include/asm/sched_clock.h                 |    2 
 arch/arm/include/asm/vfpmacros.h                   |   12 
 arch/arm/include/uapi/asm/hwcap.h                  |    3 
 arch/arm/kernel/sched_clock.c                      |   18 
 arch/arm/mach-at91/at91rm9200_devices.c            |    2 
 arch/arm/mach-at91/at91sam9260_devices.c           |    2 
 arch/arm/mach-at91/at91sam9261_devices.c           |    2 
 arch/arm/mach-at91/at91sam9263_devices.c           |    2 
 arch/arm/mach-at91/at91sam9g45_devices.c           |   12 
 arch/arm/mach-davinci/dm644x.c                     |    3 
 arch/arm/mach-highbank/system.c                    |    3 
 arch/arm/mach-imx/clk-gate2.c                      |    2 
 arch/arm/mach-imx/ehci-imx25.c                     |    2 
 arch/arm/mach-imx/ehci-imx35.c                     |    2 
 arch/arm/mach-omap2/board-igep0020.c               |    5 
 arch/arm/mach-omap2/clockdomains44xx_data.c        |    2 
 arch/arm/mach-omap2/devices.c                      |   79 +
 arch/arm/mach-omap2/omap_hwmod.c                   |   63 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   36 
 arch/arm/mach-omap2/twl-common.c                   |    3 
 arch/arm/mach-omap2/vc.c                           |    2 
 arch/arm/mach-pxa/hx4700.c                         |    8 
 arch/arm/mach-pxa/spitz_pm.c                       |    8 
 arch/arm/mm/alignment.c                            |    2 
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |    6 
 arch/arm/tools/Makefile                            |    2 
 arch/arm/vfp/vfpmodule.c                           |    9 
 arch/arm/xen/enlighten.c                           |   11 
 arch/arm/xen/hypercall.S                           |   14 
 arch/arm64/Kconfig                                 |    1 
 arch/arm64/include/asm/elf.h                       |    5 
 arch/arm64/include/asm/fpsimd.h                    |    5 
 arch/arm64/include/asm/io.h                        |   10 
 arch/arm64/include/asm/pgtable-hwdef.h             |    6 
 arch/arm64/include/asm/pgtable.h                   |   40 -
 arch/arm64/include/asm/processor.h                 |    2 
 arch/arm64/include/asm/unistd.h                    |    1 
 arch/arm64/kernel/perf_event.c                     |   10 
 arch/arm64/kernel/process.c                        |   18 
 arch/arm64/kernel/smp.c                            |    3 
 arch/arm64/mm/init.c                               |    2 
 arch/frv/Kconfig                                   |    1 
 arch/frv/boot/Makefile                             |   10 
 arch/frv/include/asm/unistd.h                      |    1 
 arch/frv/kernel/entry.S                            |   28 
 arch/frv/kernel/process.c                          |    5 
 arch/frv/mb93090-mb00/pci-dma-nommu.c              |    1 
 arch/h8300/include/asm/cache.h                     |    3 
 arch/ia64/mm/init.c                                |    1 
 arch/m68k/include/asm/signal.h                     |    6 
 arch/mips/cavium-octeon/executive/cvmx-l2c.c       |  900 ------------
 arch/unicore32/include/asm/byteorder.h             |   24 
 arch/unicore32/include/asm/kvm_para.h              |    1 
 arch/unicore32/include/asm/sigcontext.h            |   29 
 arch/unicore32/include/asm/unistd.h                |   14 
 arch/x86/kvm/x86.c                                 |    6 
 include/linux/kvm_host.h                           |    2 
 include/linux/raid/md_p.h                          |  301 ----
 include/uapi/linux/kvm.h                           |    2 
 tools/perf/builtin-test.c                          | 1559 --------------------
 tools/perf/util/dso-test-data.c                    |  153 --
 tools/perf/util/parse-events-test.c                | 1116 --------------
 tools/testing/selftests/epoll/Makefile             |   11 
 tools/testing/selftests/epoll/test_epoll.c         |  344 ----
 virt/kvm/kvm_main.c                                |    7 
 80 files changed, 471 insertions(+), 4677 deletions(-)
 delete mode 100644 arch/mips/cavium-octeon/executive/cvmx-l2c.c
 delete mode 100644 arch/unicore32/include/asm/byteorder.h
 delete mode 100644 arch/unicore32/include/asm/kvm_para.h
 delete mode 100644 arch/unicore32/include/asm/sigcontext.h
 delete mode 100644 arch/unicore32/include/asm/unistd.h
 delete mode 100644 include/linux/raid/md_p.h
 delete mode 100644 tools/perf/builtin-test.c
 delete mode 100644 tools/perf/util/dso-test-data.c
 delete mode 100644 tools/perf/util/parse-events-test.c
 delete mode 100644 tools/testing/selftests/epoll/Makefile
 delete mode 100644 tools/testing/selftests/epoll/test_epoll.c

diff --git a/CREDITS b/CREDITS
index b4cdc8f..17899e2 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1824,6 +1824,11 @@ S: Kattreinstr 38
 S: D-64295
 S: Germany
 
+N: Avi Kivity
+E: avi.kivity@gmail.com
+D: Kernel-based Virtual Machine (KVM)
+S: Ra'annana, Israel
+
 N: Andi Kleen
 E: andi@firstfloor.org
 U: http://www.halobates.de
diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index dbbdcbb..4110cca 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -27,17 +27,17 @@ Start			End			Size		Use
 -----------------------------------------------------------------------
 0000000000000000	0000007fffffffff	 512GB		user
 
-ffffff8000000000	ffffffbbfffcffff	~240GB		vmalloc
+ffffff8000000000	ffffffbbfffeffff	~240GB		vmalloc
 
-ffffffbbfffd0000	ffffffbcfffdffff	  64KB		[guard page]
+ffffffbbffff0000	ffffffbbffffffff	  64KB		[guard page]
 
-ffffffbbfffe0000	ffffffbcfffeffff	  64KB		PCI I/O space
+ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
 
-ffffffbbffff0000	ffffffbcffffffff	  64KB		[guard page]
+ffffffbe00000000	ffffffbffbbfffff	  ~8GB		[guard, future vmmemap]
 
-ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
+ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O space
 
-ffffffbe00000000	ffffffbffbffffff	  ~8GB		[guard, future vmmemap]
+ffffffbbffff0000	ffffffbcffffffff	  ~2MB		[guard]
 
 ffffffbffc000000	ffffffbfffffffff	  64MB		modules
 
diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index c07f7b4..71c4da4 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -466,6 +466,10 @@ Note:
 5.3 swappiness
 
 Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Please note that unlike the global swappiness, memcg knob set to 0
+really prevents from any swapping even if there is a swap storage
+available. This might lead to memcg OOM killer if there are no file
+pages to reclaim.
 
 Following cgroups' swappiness can't be changed.
 - root cgroup (uses /proc/sys/vm/swappiness).
diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
index bc95495..c79bab0 100644
--- a/Documentation/devicetree/bindings/net/mdio-gpio.txt
+++ b/Documentation/devicetree/bindings/net/mdio-gpio.txt
@@ -8,9 +8,16 @@ gpios property as described in section VIII.1 in the following order:
 
 MDC, MDIO.
 
+Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
+node.
+
 Example:
 
-mdio {
+aliases {
+	mdio-gpio0 = <&mdio0>;
+};
+
+mdio0: mdio {
 	compatible = "virtual,mdio-gpio";
 	#address-cells = <1>;
 	#size-cells = <0>;
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a1793d6..3844d21 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -33,7 +33,7 @@ Table of Contents
   2	Modifying System Parameters
 
   3	Per-Process Parameters
-  3.1	/proc/<pid>/oom_score_adj - Adjust the oom-killer
+  3.1	/proc/<pid>/oom_adj & /proc/<pid>/oom_score_adj - Adjust the oom-killer
 								score
   3.2	/proc/<pid>/oom_score - Display current oom-killer score
   3.3	/proc/<pid>/io - Display the IO accounting fields
@@ -1320,10 +1320,10 @@ of the kernel.
 CHAPTER 3: PER-PROCESS PARAMETERS
 ------------------------------------------------------------------------------
 
-3.1 /proc/<pid>/oom_score_adj- Adjust the oom-killer score
+3.1 /proc/<pid>/oom_adj & /proc/<pid>/oom_score_adj- Adjust the oom-killer score
 --------------------------------------------------------------------------------
 
-This file can be used to adjust the badness heuristic used to select which
+These file can be used to adjust the badness heuristic used to select which
 process gets killed in out of memory conditions.
 
 The badness heuristic assigns a value to each candidate task ranging from 0
@@ -1361,6 +1361,12 @@ same system, cpuset, mempolicy, or memory controller resources to use at least
 equivalent to discounting 50% of the task's allowed memory from being considered
 as scoring against the task.
 
+For backwards compatibility with previous kernels, /proc/<pid>/oom_adj may also
+be used to tune the badness score.  Its acceptable values range from -16
+(OOM_ADJUST_MIN) to +15 (OOM_ADJUST_MAX) and a special value of -17
+(OOM_DISABLE) to disable oom killing entirely for that task.  Its value is
+scaled linearly with /proc/<pid>/oom_score_adj.
+
 The value of /proc/<pid>/oom_score_adj may be reduced no lower than the last
 value set by a CAP_SYS_RESOURCE process. To reduce the value any lower
 requires CAP_SYS_RESOURCE.
@@ -1375,7 +1381,9 @@ minimal amount of work.
 -------------------------------------------------------------
 
 This file can be used to check the current score used by the oom-killer is for
-any given <pid>.
+any given <pid>. Use it together with /proc/<pid>/oom_score_adj to tune which
+process should be killed in an out-of-memory situation.
+
 
 3.3  /proc/<pid>/io - Display the IO accounting fields
 -------------------------------------------------------
diff --git a/Documentation/hwmon/fam15h_power b/Documentation/hwmon/fam15h_power
index a92918e..8065481 100644
--- a/Documentation/hwmon/fam15h_power
+++ b/Documentation/hwmon/fam15h_power
@@ -10,7 +10,7 @@ Supported chips:
   BIOS and Kernel Developer's Guide (BKDG) For AMD Family 15h Processors
     (not yet published)
 
-Author: Andreas Herrmann <andreas.herrmann3@amd.com>
+Author: Andreas Herrmann <herrmann.der.user@googlemail.com>
 
 Description
 -----------
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..52e606d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1304,6 +1304,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
 			disabled it.
 
+	lapic=		[x86,APIC] "notscdeadline" Do not use TSC deadline
+			value for LAPIC timer one-shot implementation. Default
+			back to the programmable timer unit in the LAPIC.
+
 	lapic_timer_c2_ok	[X86,APIC] trust the local apic timer
 			in C2 power state.
 
@@ -2859,6 +2863,22 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
 
+	trace_options=[option-list]
+			[FTRACE] Enable or disable tracer options at boot.
+			The option-list is a comma delimited list of options
+			that can be enabled or disabled just as if you were
+			to echo the option name into
+
+			    /sys/kernel/debug/tracing/trace_options
+
+			For example, to enable stacktrace option (to dump the
+			stack trace of each event), add to the command line:
+
+			      trace_options=stacktrace
+
+			See also Documentation/trace/ftrace.txt "trace options"
+			section.
+
 	transparent_hugepage=
 			[KNL]
 			Format: [always|madvise|never]
diff --git a/Documentation/networking/netdev-features.txt b/Documentation/networking/netdev-features.txt
index 4164f5c..f310ede 100644
--- a/Documentation/networking/netdev-features.txt
+++ b/Documentation/networking/netdev-features.txt
@@ -164,4 +164,4 @@ read the CRC recorded by the NIC on receipt of the packet.
 This requests that the NIC receive all possible frames, including errored
 frames (such as bad FCS, etc).  This can be helpful when sniffing a link with
 bad packets on it.  Some NICs may receive more packets if also put into normal
-PROMISC mdoe.
+PROMISC mode.
diff --git a/Documentation/scheduler/numa-problem.txt b/Documentation/scheduler/numa-problem.txt
index a5d2fee..7f133e3 100644
--- a/Documentation/scheduler/numa-problem.txt
+++ b/Documentation/scheduler/numa-problem.txt
@@ -133,6 +133,8 @@ XXX properties of this M vs a potential optimal
 
  2b) migrate memory towards 'n_i' using 2 samples.
 
+XXX include the statistical babble on double sampling somewhere near
+
 This separates pages into those that will migrate and those that will not due
 to the two samples not matching. We could consider the first to be of 'p_i'
 (private) and the second to be of 's_i' (shared).
@@ -142,7 +144,17 @@ This interpretation can be motivated by the previously observed property that
 's_i' (shared). (here we loose the need for memory limits again, since it
 becomes indistinguishable from shared).
 
-XXX include the statistical babble on double sampling somewhere near
+ 2c) use cpu samples instead of node samples
+
+The problem with sampling on node granularity is that one looses 's_i' for
+the local node, since one cannot distinguish between two accesses from the
+same node.
+
+By increasing the granularity to per-cpu we gain the ability to have both an
+'s_i' and 'p_i' per node. Since we do all task placement per-cpu as well this
+seems like a natural match. The line where we overcommit cpus is where we loose
+granularity again, but when we loose overcommit we naturally spread tasks.
+Therefore it should work out nicely.
 
 This reduces the problem further; we loose 'M' as per 2a, it further reduces
 the 'T_k,l' (interconnect traffic) term to only include shared (since per the
@@ -150,12 +162,6 @@ above all private will be local):
 
   T_k,l = \Sum_i bs_i,l for every n_i = k, l != k
 
-[ more or less matches the state of sched/numa and describes its remaining
-  problems and assumptions. It should work well for tasks without significant
-  shared memory usage between tasks. ]
-
-Possible future directions:
-
 Motivated by the form of 'T_k,l', try and obtain each term of the sum, so we
 can evaluate it;
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 31c4b27..0a2068f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -503,7 +503,7 @@ F:	include/linux/altera_uart.h
 F:	include/linux/altera_jtaguart.h
 
 AMD FAM15H PROCESSOR POWER MONITORING DRIVER
-M:	Andreas Herrmann <andreas.herrmann3@amd.com>
+M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/fam15h_power
@@ -526,10 +526,10 @@ F:	drivers/video/geode/
 F:	arch/x86/include/asm/geode.h
 
 AMD IOMMU (AMD-VI)
-M:	Joerg Roedel <joerg.roedel@amd.com>
+M:	Joerg Roedel <joro@8bytes.org>
 L:	iommu@lists.linux-foundation.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
-S:	Supported
+S:	Maintained
 F:	drivers/iommu/amd_iommu*.[ch]
 F:	include/linux/amd-iommu.h
 
@@ -841,6 +841,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-hpc.git
 F:	arch/arm/mach-sa1100/jornada720.c
 F:	arch/arm/mach-sa1100/include/mach/jornada720.h
 
+ARM/IGEP MACHINE SUPPORT
+M:	Enric Balletbo i Serra <eballetbo@gmail.com>
+M:	Javier Martinez Canillas <javier@dowhile0.org>
+L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/mach-omap2/board-igep0020.c
+
 ARM/INCOME PXA270 SUPPORT
 M:	Marek Vasut <marek.vasut@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -2507,6 +2515,7 @@ M:	Joonyoung Shim <jy0922.shim@samsung.com>
 M:	Seung-Woo Kim <sw0312.kim@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	dri-devel@lists.freedesktop.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git
 S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
@@ -3597,6 +3606,49 @@ F:	drivers/hid/hid-hyperv.c
 F:	drivers/net/hyperv/
 F:	drivers/staging/hv/
 
+I2C OVER PARALLEL PORT
+M:	Jean Delvare <khali@linux-fr.org>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	Documentation/i2c/busses/i2c-parport
+F:	Documentation/i2c/busses/i2c-parport-light
+F:	drivers/i2c/busses/i2c-parport.c
+F:	drivers/i2c/busses/i2c-parport-light.c
+
+I2C/SMBUS CONTROLLER DRIVERS FOR PC
+M:	Jean Delvare <khali@linux-fr.org>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	Documentation/i2c/busses/i2c-ali1535
+F:	Documentation/i2c/busses/i2c-ali1563
+F:	Documentation/i2c/busses/i2c-ali15x3
+F:	Documentation/i2c/busses/i2c-amd756
+F:	Documentation/i2c/busses/i2c-amd8111
+F:	Documentation/i2c/busses/i2c-i801
+F:	Documentation/i2c/busses/i2c-nforce2
+F:	Documentation/i2c/busses/i2c-piix4
+F:	Documentation/i2c/busses/i2c-sis5595
+F:	Documentation/i2c/busses/i2c-sis630
+F:	Documentation/i2c/busses/i2c-sis96x
+F:	Documentation/i2c/busses/i2c-via
+F:	Documentation/i2c/busses/i2c-viapro
+F:	drivers/i2c/busses/i2c-ali1535.c
+F:	drivers/i2c/busses/i2c-ali1563.c
+F:	drivers/i2c/busses/i2c-ali15x3.c
+F:	drivers/i2c/busses/i2c-amd756.c
+F:	drivers/i2c/busses/i2c-amd756-s4882.c
+F:	drivers/i2c/busses/i2c-amd8111.c
+F:	drivers/i2c/busses/i2c-i801.c
+F:	drivers/i2c/busses/i2c-isch.c
+F:	drivers/i2c/busses/i2c-nforce2.c
+F:	drivers/i2c/busses/i2c-nforce2-s4985.c
+F:	drivers/i2c/busses/i2c-piix4.c
+F:	drivers/i2c/busses/i2c-sis5595.c
+F:	drivers/i2c/busses/i2c-sis630.c
+F:	drivers/i2c/busses/i2c-sis96x.c
+F:	drivers/i2c/busses/i2c-via.c
+F:	drivers/i2c/busses/i2c-viapro.c
+
 I2C/SMBUS STUB DRIVER
 M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	linux-i2c@vger.kernel.org
@@ -3604,9 +3656,8 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-stub.c
 
 I2C SUBSYSTEM
-M:	"Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
+M:	Wolfram Sang <w.sang@pengutronix.de>
 M:	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
-M:	"Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
 L:	linux-i2c@vger.kernel.org
 W:	http://i2c.wiki.kernel.org/
 T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
@@ -3617,6 +3668,13 @@ F:	drivers/i2c/
 F:	include/linux/i2c.h
 F:	include/linux/i2c-*.h
 
+I2C-TAOS-EVM DRIVER
+M:	Jean Delvare <khali@linux-fr.org>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	Documentation/i2c/busses/i2c-taos-evm
+F:	drivers/i2c/busses/i2c-taos-evm.c
+
 I2C-TINY-USB DRIVER
 M:	Till Harbaum <till@harbaum.org>
 L:	linux-i2c@vger.kernel.org
@@ -4230,8 +4288,8 @@ F:	include/linux/lockd/
 F:	include/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
-M:	Avi Kivity <avi@redhat.com>
 M:	Marcelo Tosatti <mtosatti@redhat.com>
+M:	Gleb Natapov <gleb@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
@@ -5655,7 +5713,7 @@ S:	Maintained
 F:	drivers/pinctrl/spear/
 
 PKTCDVD DRIVER
-M:	Peter Osterlund <petero2@telia.com>
+M:	Jiri Kosina <jkosina@suse.cz>
 S:	Maintained
 F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
@@ -7217,6 +7275,14 @@ L:	linux-xtensa@linux-xtensa.org
 S:	Maintained
 F:	arch/xtensa/
 
+THERMAL
+M:      Zhang Rui <rui.zhang@intel.com>
+L:      linux-pm@vger.kernel.org
+T:      git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
+S:      Supported
+F:      drivers/thermal/
+F:      include/linux/thermal.h
+
 THINKPAD ACPI EXTRAS DRIVER
 M:	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
 L:	ibm-acpi-devel@lists.sourceforge.net
@@ -7894,13 +7960,6 @@ M:	Roger Luethi <rl@hellgate.ch>
 S:	Maintained
 F:	drivers/net/ethernet/via/via-rhine.c
 
-VIAPRO SMBUS DRIVER
-M:	Jean Delvare <khali@linux-fr.org>
-L:	linux-i2c@vger.kernel.org
-S:	Maintained
-F:	Documentation/i2c/busses/i2c-viapro
-F:	drivers/i2c/busses/i2c-viapro.c
-
 VIA SD/MMC CARD CONTROLLER DRIVER
 M:	Bruce Chang <brucechang@via.com.tw>
 M:	Harald Welte <HaraldWelte@viatech.com>
diff --git a/Makefile b/Makefile
index 42d0e56..9f6ca12 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 7
 SUBLEVEL = 0
-EXTRAVERSION = -rc3
+EXTRAVERSION = -rc6
 NAME = Terrified Chipmunk
 
 # *DOCUMENTATION*
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 1e6956a..14db93e 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -445,7 +445,7 @@ struct procfs_args {
  * unhappy with OSF UFS. [CHECKME]
  */
 static int
-osf_ufs_mount(char *dirname, struct ufs_args __user *args, int flags)
+osf_ufs_mount(const char *dirname, struct ufs_args __user *args, int flags)
 {
 	int retval;
 	struct cdfs_args tmp;
@@ -465,7 +465,7 @@ osf_ufs_mount(char *dirname, struct ufs_args __user *args, int flags)
 }
 
 static int
-osf_cdfs_mount(char *dirname, struct cdfs_args __user *args, int flags)
+osf_cdfs_mount(const char *dirname, struct cdfs_args __user *args, int flags)
 {
 	int retval;
 	struct cdfs_args tmp;
@@ -485,7 +485,7 @@ osf_cdfs_mount(char *dirname, struct cdfs_args __user *args, int flags)
 }
 
 static int
-osf_procfs_mount(char *dirname, struct procfs_args __user *args, int flags)
+osf_procfs_mount(const char *dirname, struct procfs_args __user *args, int flags)
 {
 	struct procfs_args tmp;
 
diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index f2aa09e..9137df5 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -33,7 +33,7 @@ ifeq ($(CONFIG_XIP_KERNEL),y)
 
 $(obj)/xipImage: vmlinux FORCE
 	$(call if_changed,objcopy)
-	$(kecho) '  Kernel: $@ is ready (physical address: $(CONFIG_XIP_PHYS_ADDR))'
+	@$(kecho) '  Kernel: $@ is ready (physical address: $(CONFIG_XIP_PHYS_ADDR))'
 
 $(obj)/Image $(obj)/zImage: FORCE
 	@echo 'Kernel configured for XIP (CONFIG_XIP_KERNEL=y)'
@@ -48,14 +48,14 @@ $(obj)/xipImage: FORCE
 
 $(obj)/Image: vmlinux FORCE
 	$(call if_changed,objcopy)
-	$(kecho) '  Kernel: $@ is ready'
+	@$(kecho) '  Kernel: $@ is ready'
 
 $(obj)/compressed/vmlinux: $(obj)/Image FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
 
 $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
-	$(kecho) '  Kernel: $@ is ready'
+	@$(kecho) '  Kernel: $@ is ready'
 
 endif
 
@@ -90,7 +90,7 @@ fi
 $(obj)/uImage:	$(obj)/zImage FORCE
 	@$(check_for_multiple_loadaddr)
 	$(call if_changed,uimage)
-	$(kecho) '  Image $@ is ready'
+	@$(kecho) '  Image $@ is ready'
 
 $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/bootp $@
@@ -98,7 +98,7 @@ $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 
 $(obj)/bootpImage: $(obj)/bootp/bootp FORCE
 	$(call if_changed,objcopy)
-	$(kecho) '  Kernel: $@ is ready'
+	@$(kecho) '  Kernel: $@ is ready'
 
 PHONY += initrd FORCE
 initrd:
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index b1497c7..df7f227 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -73,8 +73,8 @@
 
 	pinmux: pinmux {
 		compatible = "nvidia,tegra30-pinmux";
-		reg = <0x70000868 0xd0    /* Pad control registers */
-		       0x70003000 0x3e0>; /* Mux registers */
+		reg = <0x70000868 0xd4    /* Pad control registers */
+		       0x70003000 0x3e4>; /* Mux registers */
 	};
 
 	serial@70006000 {
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 35c1ed8..42f042e 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -64,7 +64,7 @@ extern void __raw_readsl(const void __iomem *addr, void *data, int longlen);
 static inline void __raw_writew(u16 val, volatile void __iomem *addr)
 {
 	asm volatile("strh %1, %0"
-		     : "+Qo" (*(volatile u16 __force *)addr)
+		     : "+Q" (*(volatile u16 __force *)addr)
 		     : "r" (val));
 }
 
@@ -72,7 +72,7 @@ static inline u16 __raw_readw(const volatile void __iomem *addr)
 {
 	u16 val;
 	asm volatile("ldrh %1, %0"
-		     : "+Qo" (*(volatile u16 __force *)addr),
+		     : "+Q" (*(volatile u16 __force *)addr),
 		       "=r" (val));
 	return val;
 }
diff --git a/arch/arm/include/asm/sched_clock.h b/arch/arm/include/asm/sched_clock.h
index 05b8e82..e3f7572 100644
--- a/arch/arm/include/asm/sched_clock.h
+++ b/arch/arm/include/asm/sched_clock.h
@@ -10,7 +10,5 @@
 
 extern void sched_clock_postinit(void);
 extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
-extern void setup_sched_clock_needs_suspend(u32 (*read)(void), int bits,
-		unsigned long rate);
 
 #endif
diff --git a/arch/arm/include/asm/vfpmacros.h b/arch/arm/include/asm/vfpmacros.h
index 6a6f1e4..301c1db 100644
--- a/arch/arm/include/asm/vfpmacros.h
+++ b/arch/arm/include/asm/vfpmacros.h
@@ -27,9 +27,9 @@
 #if __LINUX_ARM_ARCH__ <= 6
 	ldr	\tmp, =elf_hwcap		    @ may not have MVFR regs
 	ldr	\tmp, [\tmp, #0]
-	tst	\tmp, #HWCAP_VFPv3D16
-	ldceql	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
-	addne	\base, \base, #32*4		    @ step over unused register space
+	tst	\tmp, #HWCAP_VFPD32
+	ldcnel	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
+	addeq	\base, \base, #32*4		    @ step over unused register space
 #else
 	VFPFMRX	\tmp, MVFR0			    @ Media and VFP Feature Register 0
 	and	\tmp, \tmp, #MVFR0_A_SIMD_MASK	    @ A_SIMD field
@@ -51,9 +51,9 @@
 #if __LINUX_ARM_ARCH__ <= 6
 	ldr	\tmp, =elf_hwcap		    @ may not have MVFR regs
 	ldr	\tmp, [\tmp, #0]
-	tst	\tmp, #HWCAP_VFPv3D16
-	stceql	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
-	addne	\base, \base, #32*4		    @ step over unused register space
+	tst	\tmp, #HWCAP_VFPD32
+	stcnel	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
+	addeq	\base, \base, #32*4		    @ step over unused register space
 #else
 	VFPFMRX	\tmp, MVFR0			    @ Media and VFP Feature Register 0
 	and	\tmp, \tmp, #MVFR0_A_SIMD_MASK	    @ A_SIMD field
diff --git a/arch/arm/include/uapi/asm/hwcap.h b/arch/arm/include/uapi/asm/hwcap.h
index f254f65..3688fd1 100644
--- a/arch/arm/include/uapi/asm/hwcap.h
+++ b/arch/arm/include/uapi/asm/hwcap.h
@@ -18,11 +18,12 @@
 #define HWCAP_THUMBEE	(1 << 11)
 #define HWCAP_NEON	(1 << 12)
 #define HWCAP_VFPv3	(1 << 13)
-#define HWCAP_VFPv3D16	(1 << 14)
+#define HWCAP_VFPv3D16	(1 << 14)	/* also set for VFPv4-D16 */
 #define HWCAP_TLS	(1 << 15)
 #define HWCAP_VFPv4	(1 << 16)
 #define HWCAP_IDIVA	(1 << 17)
 #define HWCAP_IDIVT	(1 << 18)
+#define HWCAP_VFPD32	(1 << 19)	/* set if VFP has 32 regs (not 16) */
 #define HWCAP_IDIV	(HWCAP_IDIVA | HWCAP_IDIVT)
 
 
diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index e21bac2..fc6692e 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -107,13 +107,6 @@ static void sched_clock_poll(unsigned long wrap_ticks)
 	update_sched_clock();
 }
 
-void __init setup_sched_clock_needs_suspend(u32 (*read)(void), int bits,
-		unsigned long rate)
-{
-	setup_sched_clock(read, bits, rate);
-	cd.needs_suspend = true;
-}
-
 void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 {
 	unsigned long r, w;
@@ -189,18 +182,15 @@ void __init sched_clock_postinit(void)
 static int sched_clock_suspend(void)
 {
 	sched_clock_poll(sched_clock_timer.data);
-	if (cd.needs_suspend)
-		cd.suspended = true;
+	cd.suspended = true;
 	return 0;
 }
 
 static void sched_clock_resume(void)
 {
-	if (cd.needs_suspend) {
-		cd.epoch_cyc = read_sched_clock();
-		cd.epoch_cyc_copy = cd.epoch_cyc;
-		cd.suspended = false;
-	}
+	cd.epoch_cyc = read_sched_clock();
+	cd.epoch_cyc_copy = cd.epoch_cyc;
+	cd.suspended = false;
 }
 
 static struct syscore_ops sched_clock_ops = {
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 1e122bc..3cee0e6 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -68,7 +68,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data)
 
 	/* Enable overcurrent notification */
 	for (i = 0; i < data->ports; i++) {
-		if (data->overcurrent_pin[i])
+		if (gpio_is_valid(data->overcurrent_pin[i]))
 			at91_set_gpio_input(data->overcurrent_pin[i], 1);
 	}
 
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index aa1e587..414bd85 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -72,7 +72,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data)
 
 	/* Enable overcurrent notification */
 	for (i = 0; i < data->ports; i++) {
-		if (data->overcurrent_pin[i])
+		if (gpio_is_valid(data->overcurrent_pin[i]))
 			at91_set_gpio_input(data->overcurrent_pin[i], 1);
 	}
 
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index b948769..cd604aa 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -72,7 +72,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data)
 
 	/* Enable overcurrent notification */
 	for (i = 0; i < data->ports; i++) {
-		if (data->overcurrent_pin[i])
+		if (gpio_is_valid(data->overcurrent_pin[i]))
 			at91_set_gpio_input(data->overcurrent_pin[i], 1);
 	}
 
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index cb85da2..9c61e59 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -78,7 +78,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data)
 
 	/* Enable overcurrent notification */
 	for (i = 0; i < data->ports; i++) {
-		if (data->overcurrent_pin[i])
+		if (gpio_is_valid(data->overcurrent_pin[i]))
 			at91_set_gpio_input(data->overcurrent_pin[i], 1);
 	}
 
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index b159607..fcd233c 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -1841,8 +1841,8 @@ static struct resource sha_resources[] = {
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -1874,8 +1874,8 @@ static struct resource tdes_resources[] = {
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -1910,8 +1910,8 @@ static struct resource aes_resources[] = {
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index cd0c8b1..14e9947 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -713,8 +713,7 @@ static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type,
 		break;
 	case VPBE_ENC_CUSTOM_TIMINGS:
 		if (pclock <= 27000000) {
-			v |= DM644X_VPSS_MUXSEL_PLL2_MODE |
-			     DM644X_VPSS_DACCLKEN;
+			v |= DM644X_VPSS_DACCLKEN;
 			writel(v, DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL));
 		} else {
 			/*
diff --git a/arch/arm/mach-highbank/system.c b/arch/arm/mach-highbank/system.c
index 82c2723..86e37cd 100644
--- a/arch/arm/mach-highbank/system.c
+++ b/arch/arm/mach-highbank/system.c
@@ -28,6 +28,7 @@ void highbank_restart(char mode, const char *cmd)
 		hignbank_set_pwr_soft_reset();
 
 	scu_power_mode(scu_base_addr, SCU_PM_POWEROFF);
-	cpu_do_idle();
+	while (1)
+		cpu_do_idle();
 }
 
diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
index 3c1b8ff..cc49c7a 100644
--- a/arch/arm/mach-imx/clk-gate2.c
+++ b/arch/arm/mach-imx/clk-gate2.c
@@ -112,7 +112,7 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
 
 	clk = clk_register(dev, &gate->hw);
 	if (IS_ERR(clk))
-		kfree(clk);
+		kfree(gate);
 
 	return clk;
 }
diff --git a/arch/arm/mach-imx/ehci-imx25.c b/arch/arm/mach-imx/ehci-imx25.c
index 412c583..576af74 100644
--- a/arch/arm/mach-imx/ehci-imx25.c
+++ b/arch/arm/mach-imx/ehci-imx25.c
@@ -30,7 +30,7 @@
 #define MX25_H1_SIC_SHIFT	21
 #define MX25_H1_SIC_MASK	(0x3 << MX25_H1_SIC_SHIFT)
 #define MX25_H1_PP_BIT		(1 << 18)
-#define MX25_H1_PM_BIT		(1 << 8)
+#define MX25_H1_PM_BIT		(1 << 16)
 #define MX25_H1_IPPUE_UP_BIT	(1 << 7)
 #define MX25_H1_IPPUE_DOWN_BIT	(1 << 6)
 #define MX25_H1_TLL_BIT		(1 << 5)
diff --git a/arch/arm/mach-imx/ehci-imx35.c b/arch/arm/mach-imx/ehci-imx35.c
index 779e16e..2933978 100644
--- a/arch/arm/mach-imx/ehci-imx35.c
+++ b/arch/arm/mach-imx/ehci-imx35.c
@@ -30,7 +30,7 @@
 #define MX35_H1_SIC_SHIFT	21
 #define MX35_H1_SIC_MASK	(0x3 << MX35_H1_SIC_SHIFT)
 #define MX35_H1_PP_BIT		(1 << 18)
-#define MX35_H1_PM_BIT		(1 << 8)
+#define MX35_H1_PM_BIT		(1 << 16)
 #define MX35_H1_IPPUE_UP_BIT	(1 << 7)
 #define MX35_H1_IPPUE_DOWN_BIT	(1 << 6)
 #define MX35_H1_TLL_BIT		(1 << 5)
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index 48d5e41..3785906 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -580,6 +580,11 @@ static void __init igep_wlan_bt_init(void)
 	} else
 		return;
 
+	/* Make sure that the GPIO pins are muxed correctly */
+	omap_mux_init_gpio(igep_wlan_bt_gpios[0].gpio, OMAP_PIN_OUTPUT);
+	omap_mux_init_gpio(igep_wlan_bt_gpios[1].gpio, OMAP_PIN_OUTPUT);
+	omap_mux_init_gpio(igep_wlan_bt_gpios[2].gpio, OMAP_PIN_OUTPUT);
+
 	err = gpio_request_array(igep_wlan_bt_gpios,
 				 ARRAY_SIZE(igep_wlan_bt_gpios));
 	if (err) {
diff --git a/arch/arm/mach-omap2/clockdomains44xx_data.c b/arch/arm/mach-omap2/clockdomains44xx_data.c
index b56d06b..95192a0 100644
--- a/arch/arm/mach-omap2/clockdomains44xx_data.c
+++ b/arch/arm/mach-omap2/clockdomains44xx_data.c
@@ -359,7 +359,7 @@ static struct clockdomain iss_44xx_clkdm = {
 	.clkdm_offs	  = OMAP4430_CM2_CAM_CAM_CDOFFS,
 	.wkdep_srcs	  = iss_wkup_sleep_deps,
 	.sleepdep_srcs	  = iss_wkup_sleep_deps,
-	.flags		  = CLKDM_CAN_HWSUP_SWSUP,
+	.flags		  = CLKDM_CAN_SWSUP,
 };
 
 static struct clockdomain l3_dss_44xx_clkdm = {
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index cba60e0..c72b5a7 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -19,6 +19,7 @@
 #include <linux/of.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/platform_data/omap4-keypad.h>
+#include <linux/platform_data/omap_ocp2scp.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/map.h>
@@ -613,6 +614,83 @@ static void omap_init_vout(void)
 static inline void omap_init_vout(void) {}
 #endif
 
+#if defined(CONFIG_OMAP_OCP2SCP) || defined(CONFIG_OMAP_OCP2SCP_MODULE)
+static int count_ocp2scp_devices(struct omap_ocp2scp_dev *ocp2scp_dev)
+{
+	int cnt	= 0;
+
+	while (ocp2scp_dev->drv_name != NULL) {
+		cnt++;
+		ocp2scp_dev++;
+	}
+
+	return cnt;
+}
+
+static void omap_init_ocp2scp(void)
+{
+	struct omap_hwmod	*oh;
+	struct platform_device	*pdev;
+	int			bus_id = -1, dev_cnt = 0, i;
+	struct omap_ocp2scp_dev	*ocp2scp_dev;
+	const char		*oh_name, *name;
+	struct omap_ocp2scp_platform_data *pdata;
+
+	if (!cpu_is_omap44xx())
+		return;
+
+	oh_name = "ocp2scp_usb_phy";
+	name	= "omap-ocp2scp";
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh) {
+		pr_err("%s: could not find omap_hwmod for %s\n", __func__,
+								oh_name);
+		return;
+	}
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		pr_err("%s: No memory for ocp2scp pdata\n", __func__);
+		return;
+	}
+
+	ocp2scp_dev = oh->dev_attr;
+	dev_cnt = count_ocp2scp_devices(ocp2scp_dev);
+
+	if (!dev_cnt) {
+		pr_err("%s: No devices connected to ocp2scp\n", __func__);
+		kfree(pdata);
+		return;
+	}
+
+	pdata->devices = kzalloc(sizeof(struct omap_ocp2scp_dev *)
+					* dev_cnt, GFP_KERNEL);
+	if (!pdata->devices) {
+		pr_err("%s: No memory for ocp2scp pdata devices\n", __func__);
+		kfree(pdata);
+		return;
+	}
+
+	for (i = 0; i < dev_cnt; i++, ocp2scp_dev++)
+		pdata->devices[i] = ocp2scp_dev;
+
+	pdata->dev_cnt	= dev_cnt;
+
+	pdev = omap_device_build(name, bus_id, oh, pdata, sizeof(*pdata), NULL,
+								0, false);
+	if (IS_ERR(pdev)) {
+		pr_err("Could not build omap_device for %s %s\n",
+						name, oh_name);
+		kfree(pdata->devices);
+		kfree(pdata);
+		return;
+	}
+}
+#else
+static inline void omap_init_ocp2scp(void) { }
+#endif
+
 /*-------------------------------------------------------------------------*/
 
 static int __init omap2_init_devices(void)
@@ -640,6 +718,7 @@ static int __init omap2_init_devices(void)
 	omap_init_sham();
 	omap_init_aes();
 	omap_init_vout();
+	omap_init_ocp2scp();
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index b969ab1..87cc6d0 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -422,6 +422,38 @@ static int _set_softreset(struct omap_hwmod *oh, u32 *v)
 }
 
 /**
+ * _wait_softreset_complete - wait for an OCP softreset to complete
+ * @oh: struct omap_hwmod * to wait on
+ *
+ * Wait until the IP block represented by @oh reports that its OCP
+ * softreset is complete.  This can be triggered by software (see
+ * _ocp_softreset()) or by hardware upon returning from off-mode (one
+ * example is HSMMC).  Waits for up to MAX_MODULE_SOFTRESET_WAIT
+ * microseconds.  Returns the number of microseconds waited.
+ */
+static int _wait_softreset_complete(struct omap_hwmod *oh)
+{
+	struct omap_hwmod_class_sysconfig *sysc;
+	u32 softrst_mask;
+	int c = 0;
+
+	sysc = oh->class->sysc;
+
+	if (sysc->sysc_flags & SYSS_HAS_RESET_STATUS)
+		omap_test_timeout((omap_hwmod_read(oh, sysc->syss_offs)
+				   & SYSS_RESETDONE_MASK),
+				  MAX_MODULE_SOFTRESET_WAIT, c);
+	else if (sysc->sysc_flags & SYSC_HAS_RESET_STATUS) {
+		softrst_mask = (0x1 << sysc->sysc_fields->srst_shift);
+		omap_test_timeout(!(omap_hwmod_read(oh, sysc->sysc_offs)
+				    & softrst_mask),
+				  MAX_MODULE_SOFTRESET_WAIT, c);
+	}
+
+	return c;
+}
+
+/**
  * _set_dmadisable: set OCP_SYSCONFIG.DMADISABLE bit in @v
  * @oh: struct omap_hwmod *
  *
@@ -1282,6 +1314,18 @@ static void _enable_sysc(struct omap_hwmod *oh)
 	if (!oh->class->sysc)
 		return;
 
+	/*
+	 * Wait until reset has completed, this is needed as the IP
+	 * block is reset automatically by hardware in some cases
+	 * (off-mode for example), and the drivers require the
+	 * IP to be ready when they access it
+	 */
+	if (oh->flags & HWMOD_CONTROL_OPT_CLKS_IN_RESET)
+		_enable_optional_clocks(oh);
+	_wait_softreset_complete(oh);
+	if (oh->flags & HWMOD_CONTROL_OPT_CLKS_IN_RESET)
+		_disable_optional_clocks(oh);
+
 	v = oh->_sysc_cache;
 	sf = oh->class->sysc->sysc_flags;
 
@@ -1804,7 +1848,7 @@ static int _am33xx_disable_module(struct omap_hwmod *oh)
  */
 static int _ocp_softreset(struct omap_hwmod *oh)
 {
-	u32 v, softrst_mask;
+	u32 v;
 	int c = 0;
 	int ret = 0;
 
@@ -1834,19 +1878,7 @@ static int _ocp_softreset(struct omap_hwmod *oh)
 	if (oh->class->sysc->srst_udelay)
 		udelay(oh->class->sysc->srst_udelay);
 
-	if (oh->class->sysc->sysc_flags & SYSS_HAS_RESET_STATUS)
-		omap_test_timeout((omap_hwmod_read(oh,
-						    oh->class->sysc->syss_offs)
-				   & SYSS_RESETDONE_MASK),
-				  MAX_MODULE_SOFTRESET_WAIT, c);
-	else if (oh->class->sysc->sysc_flags & SYSC_HAS_RESET_STATUS) {
-		softrst_mask = (0x1 << oh->class->sysc->sysc_fields->srst_shift);
-		omap_test_timeout(!(omap_hwmod_read(oh,
-						     oh->class->sysc->sysc_offs)
-				   & softrst_mask),
-				  MAX_MODULE_SOFTRESET_WAIT, c);
-	}
-
+	c = _wait_softreset_complete(oh);
 	if (c == MAX_MODULE_SOFTRESET_WAIT)
 		pr_warning("omap_hwmod: %s: softreset failed (waited %d usec)\n",
 			   oh->name, MAX_MODULE_SOFTRESET_WAIT);
@@ -2352,6 +2384,9 @@ static int __init _setup_reset(struct omap_hwmod *oh)
 	if (oh->_state != _HWMOD_STATE_INITIALIZED)
 		return -EINVAL;
 
+	if (oh->flags & HWMOD_EXT_OPT_MAIN_CLK)
+		return -EPERM;
+
 	if (oh->rst_lines_cnt == 0) {
 		r = _enable(oh);
 		if (r) {
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 652d028..0b1249e 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/platform_data/gpio-omap.h>
 #include <linux/power/smartreflex.h>
+#include <linux/platform_data/omap_ocp2scp.h>
 
 #include <plat/omap_hwmod.h>
 #include <plat/i2c.h>
@@ -2125,6 +2126,14 @@ static struct omap_hwmod omap44xx_mcpdm_hwmod = {
 	.name		= "mcpdm",
 	.class		= &omap44xx_mcpdm_hwmod_class,
 	.clkdm_name	= "abe_clkdm",
+	/*
+	 * It's suspected that the McPDM requires an off-chip main
+	 * functional clock, controlled via I2C.  This IP block is
+	 * currently reset very early during boot, before I2C is
+	 * available, so it doesn't seem that we have any choice in
+	 * the kernel other than to avoid resetting it.
+	 */
+	.flags		= HWMOD_EXT_OPT_MAIN_CLK,
 	.mpu_irqs	= omap44xx_mcpdm_irqs,
 	.sdma_reqs	= omap44xx_mcpdm_sdma_reqs,
 	.main_clk	= "mcpdm_fck",
@@ -2681,6 +2690,32 @@ static struct omap_hwmod_class omap44xx_ocp2scp_hwmod_class = {
 	.sysc	= &omap44xx_ocp2scp_sysc,
 };
 
+/* ocp2scp dev_attr */
+static struct resource omap44xx_usb_phy_and_pll_addrs[] = {
+	{
+		.name		= "usb_phy",
+		.start		= 0x4a0ad080,
+		.end		= 0x4a0ae000,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		/* XXX: Remove this once control module driver is in place */
+		.name		= "ctrl_dev",
+		.start		= 0x4a002300,
+		.end		= 0x4a002303,
+		.flags		= IORESOURCE_MEM,
+	},
+	{ }
+};
+
+static struct omap_ocp2scp_dev ocp2scp_dev_attr[] = {
+	{
+		.drv_name       = "omap-usb2",
+		.res		= omap44xx_usb_phy_and_pll_addrs,
+	},
+	{ }
+};
+
 /* ocp2scp_usb_phy */
 static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
 	.name		= "ocp2scp_usb_phy",
@@ -2694,6 +2729,7 @@ static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
 			.modulemode   = MODULEMODE_HWCTRL,
 		},
 	},
+	.dev_attr	= ocp2scp_dev_attr,
 };
 
 /*
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index 635e109..a256135 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -73,6 +73,7 @@ void __init omap4_pmic_init(const char *pmic_type,
 {
 	/* PMIC part*/
 	omap_mux_init_signal("sys_nirq1", OMAP_PIN_INPUT_PULLUP | OMAP_PIN_OFF_WAKEUPENABLE);
+	omap_mux_init_signal("fref_clk0_out.sys_drm_msecure", OMAP_PIN_OUTPUT);
 	omap_pmic_init(1, 400, pmic_type, 7 + OMAP44XX_IRQ_GIC_START, pmic_data);
 
 	/* Register additional devices on i2c1 bus if needed */
@@ -366,7 +367,7 @@ static struct regulator_init_data omap4_clk32kg_idata = {
 };
 
 static struct regulator_consumer_supply omap4_vdd1_supply[] = {
-	REGULATOR_SUPPLY("vcc", "mpu.0"),
+	REGULATOR_SUPPLY("vcc", "cpu0"),
 };
 
 static struct regulator_consumer_supply omap4_vdd2_supply[] = {
diff --git a/arch/arm/mach-omap2/vc.c b/arch/arm/mach-omap2/vc.c
index 880249b..75878c3 100644
--- a/arch/arm/mach-omap2/vc.c
+++ b/arch/arm/mach-omap2/vc.c
@@ -264,7 +264,7 @@ static void __init omap_vc_i2c_init(struct voltagedomain *voltdm)
 
 	if (initialized) {
 		if (voltdm->pmic->i2c_high_speed != i2c_high_speed)
-			pr_warn("%s: I2C config for vdd_%s does not match other channels (%u).",
+			pr_warn("%s: I2C config for vdd_%s does not match other channels (%u).\n",
 				__func__, voltdm->name, i2c_high_speed);
 		return;
 	}
diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index 5ecbd17..e2c6391 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -28,6 +28,7 @@
 #include <linux/mfd/asic3.h>
 #include <linux/mtd/physmap.h>
 #include <linux/pda_power.h>
+#include <linux/pwm.h>
 #include <linux/pwm_backlight.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/gpio-regulator.h>
@@ -556,7 +557,7 @@ static struct platform_device hx4700_lcd = {
  */
 
 static struct platform_pwm_backlight_data backlight_data = {
-	.pwm_id         = 1,
+	.pwm_id         = -1,	/* Superseded by pwm_lookup */
 	.max_brightness = 200,
 	.dft_brightness = 100,
 	.pwm_period_ns  = 30923,
@@ -571,6 +572,10 @@ static struct platform_device backlight = {
 	},
 };
 
+static struct pwm_lookup hx4700_pwm_lookup[] = {
+	PWM_LOOKUP("pxa27x-pwm.1", 0, "pwm-backlight", NULL),
+};
+
 /*
  * USB "Transceiver"
  */
@@ -872,6 +877,7 @@ static void __init hx4700_init(void)
 	pxa_set_stuart_info(NULL);
 
 	platform_add_devices(devices, ARRAY_SIZE(devices));
+	pwm_add_table(hx4700_pwm_lookup, ARRAY_SIZE(hx4700_pwm_lookup));
 
 	pxa_set_ficp_info(&ficp_info);
 	pxa27x_set_i2c_power_info(NULL);
diff --git a/arch/arm/mach-pxa/spitz_pm.c b/arch/arm/mach-pxa/spitz_pm.c
index 438f02f..842596d 100644
--- a/arch/arm/mach-pxa/spitz_pm.c
+++ b/arch/arm/mach-pxa/spitz_pm.c
@@ -86,10 +86,7 @@ static void spitz_discharge1(int on)
 	gpio_set_value(SPITZ_GPIO_LED_GREEN, on);
 }
 
-static unsigned long gpio18_config[] = {
-	GPIO18_RDY,
-	GPIO18_GPIO,
-};
+static unsigned long gpio18_config = GPIO18_GPIO;
 
 static void spitz_presuspend(void)
 {
@@ -112,7 +109,7 @@ static void spitz_presuspend(void)
 	PGSR3 &= ~SPITZ_GPIO_G3_STROBE_BIT;
 	PGSR2 |= GPIO_bit(SPITZ_GPIO_KEY_STROBE0);
 
-	pxa2xx_mfp_config(&gpio18_config[0], 1);
+	pxa2xx_mfp_config(&gpio18_config, 1);
 	gpio_request_one(18, GPIOF_OUT_INIT_HIGH, "Unknown");
 	gpio_free(18);
 
@@ -131,7 +128,6 @@ static void spitz_presuspend(void)
 
 static void spitz_postsuspend(void)
 {
-	pxa2xx_mfp_config(&gpio18_config[1], 1);
 }
 
 static int spitz_should_wakeup(unsigned int resume_on_alarm)
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 023f4437..b820eda 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -745,7 +745,7 @@ do_alignment_t32_to_handler(unsigned long *pinstr, struct pt_regs *regs,
 static int
 do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
-	union offset_union offset;
+	union offset_union uninitialized_var(offset);
 	unsigned long instr = 0, instrptr;
 	int (*handler)(unsigned long addr, unsigned long instr, struct pt_regs *regs);
 	unsigned int type;
diff --git a/arch/arm/plat-omap/include/plat/omap_hwmod.h b/arch/arm/plat-omap/include/plat/omap_hwmod.h
index b3349f7..1db0294 100644
--- a/arch/arm/plat-omap/include/plat/omap_hwmod.h
+++ b/arch/arm/plat-omap/include/plat/omap_hwmod.h
@@ -443,6 +443,11 @@ struct omap_hwmod_omap4_prcm {
  *     in order to complete the reset. Optional clocks will be disabled
  *     again after the reset.
  * HWMOD_16BIT_REG: Module has 16bit registers
+ * HWMOD_EXT_OPT_MAIN_CLK: The only main functional clock source for
+ *     this IP block comes from an off-chip source and is not always
+ *     enabled.  This prevents the hwmod code from being able to
+ *     enable and reset the IP block early.  XXX Eventually it should
+ *     be possible to query the clock framework for this information.
  */
 #define HWMOD_SWSUP_SIDLE			(1 << 0)
 #define HWMOD_SWSUP_MSTANDBY			(1 << 1)
@@ -453,6 +458,7 @@ struct omap_hwmod_omap4_prcm {
 #define HWMOD_NO_IDLEST				(1 << 6)
 #define HWMOD_CONTROL_OPT_CLKS_IN_RESET		(1 << 7)
 #define HWMOD_16BIT_REG				(1 << 8)
+#define HWMOD_EXT_OPT_MAIN_CLK			(1 << 9)
 
 /*
  * omap_hwmod._int_flags definitions
diff --git a/arch/arm/tools/Makefile b/arch/arm/tools/Makefile
index cd60a81..32d05c8 100644
--- a/arch/arm/tools/Makefile
+++ b/arch/arm/tools/Makefile
@@ -5,6 +5,6 @@
 #
 
 include/generated/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
-	$(kecho) '  Generating $@'
+	@$(kecho) '  Generating $@'
 	@mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index c834b32..3b44e0d 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -701,11 +701,14 @@ static int __init vfp_init(void)
 			elf_hwcap |= HWCAP_VFPv3;
 
 			/*
-			 * Check for VFPv3 D16. CPUs in this configuration
-			 * only have 16 x 64bit registers.
+			 * Check for VFPv3 D16 and VFPv4 D16.  CPUs in
+			 * this configuration only have 16 x 64bit
+			 * registers.
 			 */
 			if (((fmrx(MVFR0) & MVFR0_A_SIMD_MASK)) == 1)
-				elf_hwcap |= HWCAP_VFPv3D16;
+				elf_hwcap |= HWCAP_VFPv3D16; /* also v4-D16 */
+			else
+				elf_hwcap |= HWCAP_VFPD32;
 		}
 #endif
 		/*
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 59bcb96..f576092 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -166,3 +166,14 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
 	*pages = NULL;
 }
 EXPORT_SYMBOL_GPL(free_xenballooned_pages);
+
+/* In the hypervisor.S file. */
+EXPORT_SYMBOL_GPL(HYPERVISOR_event_channel_op);
+EXPORT_SYMBOL_GPL(HYPERVISOR_grant_table_op);
+EXPORT_SYMBOL_GPL(HYPERVISOR_xen_version);
+EXPORT_SYMBOL_GPL(HYPERVISOR_console_io);
+EXPORT_SYMBOL_GPL(HYPERVISOR_sched_op);
+EXPORT_SYMBOL_GPL(HYPERVISOR_hvm_op);
+EXPORT_SYMBOL_GPL(HYPERVISOR_memory_op);
+EXPORT_SYMBOL_GPL(HYPERVISOR_physdev_op);
+EXPORT_SYMBOL_GPL(privcmd_call);
diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
index 074f5ed..71f7239 100644
--- a/arch/arm/xen/hypercall.S
+++ b/arch/arm/xen/hypercall.S
@@ -48,20 +48,16 @@
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include <asm/opcodes-virt.h>
 #include <xen/interface/xen.h>
 
 
-/* HVC 0xEA1 */
-#ifdef CONFIG_THUMB2_KERNEL
-#define xen_hvc .word 0xf7e08ea1
-#else
-#define xen_hvc .word 0xe140ea71
-#endif
+#define XEN_IMM 0xEA1
 
 #define HYPERCALL_SIMPLE(hypercall)		\
 ENTRY(HYPERVISOR_##hypercall)			\
 	mov r12, #__HYPERVISOR_##hypercall;	\
-	xen_hvc;							\
+	__HVC(XEN_IMM);						\
 	mov pc, lr;							\
 ENDPROC(HYPERVISOR_##hypercall)
 
@@ -76,7 +72,7 @@ ENTRY(HYPERVISOR_##hypercall)			\
 	stmdb sp!, {r4}						\
 	ldr r4, [sp, #4]					\
 	mov r12, #__HYPERVISOR_##hypercall;	\
-	xen_hvc								\
+	__HVC(XEN_IMM);						\
 	ldm sp!, {r4}						\
 	mov pc, lr							\
 ENDPROC(HYPERVISOR_##hypercall)
@@ -100,7 +96,7 @@ ENTRY(privcmd_call)
 	mov r2, r3
 	ldr r3, [sp, #8]
 	ldr r4, [sp, #4]
-	xen_hvc
+	__HVC(XEN_IMM)
 	ldm sp!, {r4}
 	mov pc, lr
 ENDPROC(privcmd_call);
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ef54a59..15ac18a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,6 +1,7 @@
 config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IOMAP
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index cf28464..07fea29 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -25,12 +25,10 @@
 #include <asm/user.h>
 
 typedef unsigned long elf_greg_t;
-typedef unsigned long elf_freg_t[3];
 
 #define ELF_NGREG (sizeof (struct pt_regs) / sizeof(elf_greg_t))
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
-
-typedef struct user_fp elf_fpregset_t;
+typedef struct user_fpsimd_state elf_fpregset_t;
 
 #define EM_AARCH64		183
 
@@ -87,7 +85,6 @@ typedef struct user_fp elf_fpregset_t;
 #define R_AARCH64_MOVW_PREL_G2_NC	292
 #define R_AARCH64_MOVW_PREL_G3		293
 
-
 /*
  * These are used to set parameters in the core dumps.
  */
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index b42fab9..c43b4ac 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -25,9 +25,8 @@
  *  - FPSR and FPCR
  *  - 32 128-bit data registers
  *
- * Note that user_fp forms a prefix of this structure, which is relied
- * upon in the ptrace FP/SIMD accessors. struct user_fpsimd_state must
- * form a prefix of struct fpsimd_state.
+ * Note that user_fpsimd forms a prefix of this structure, which is
+ * relied upon in the ptrace FP/SIMD accessors.
  */
 struct fpsimd_state {
 	union {
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 74a2a7d..d2f05a6 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -114,7 +114,7 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
  *  I/O port access primitives.
  */
 #define IO_SPACE_LIMIT		0xffff
-#define PCI_IOBASE		((void __iomem *)0xffffffbbfffe0000UL)
+#define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_2M))
 
 static inline u8 inb(unsigned long addr)
 {
@@ -222,12 +222,12 @@ extern void __iomem *__ioremap(phys_addr_t phys_addr, size_t size, pgprot_t prot
 extern void __iounmap(volatile void __iomem *addr);
 
 #define PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_DIRTY)
-#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_XN | PTE_ATTRINDX(MT_DEVICE_nGnRE))
+#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_ATTRINDX(MT_DEVICE_nGnRE))
 #define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL_NC))
 
-#define ioremap(addr, size)		__ioremap((addr), (size), PROT_DEVICE_nGnRE)
-#define ioremap_nocache(addr, size)	__ioremap((addr), (size), PROT_DEVICE_nGnRE)
-#define ioremap_wc(addr, size)		__ioremap((addr), (size), PROT_NORMAL_NC)
+#define ioremap(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
+#define ioremap_nocache(addr, size)	__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
+#define ioremap_wc(addr, size)		__ioremap((addr), (size), __pgprot(PROT_NORMAL_NC))
 #define iounmap				__iounmap
 
 #define ARCH_HAS_IOREMAP_WC
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 0f3b458..75fd13d 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -38,7 +38,8 @@
 #define PMD_SECT_S		(_AT(pmdval_t, 3) << 8)
 #define PMD_SECT_AF		(_AT(pmdval_t, 1) << 10)
 #define PMD_SECT_NG		(_AT(pmdval_t, 1) << 11)
-#define PMD_SECT_XN		(_AT(pmdval_t, 1) << 54)
+#define PMD_SECT_PXN		(_AT(pmdval_t, 1) << 53)
+#define PMD_SECT_UXN		(_AT(pmdval_t, 1) << 54)
 
 /*
  * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
@@ -57,7 +58,8 @@
 #define PTE_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
 #define PTE_AF			(_AT(pteval_t, 1) << 10)	/* Access Flag */
 #define PTE_NG			(_AT(pteval_t, 1) << 11)	/* nG */
-#define PTE_XN			(_AT(pteval_t, 1) << 54)	/* XN */
+#define PTE_PXN			(_AT(pteval_t, 1) << 53)	/* Privileged XN */
+#define PTE_UXN			(_AT(pteval_t, 1) << 54)	/* User XN */
 
 /*
  * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 8960239..14aba2d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -62,23 +62,23 @@ extern pgprot_t pgprot_default;
 
 #define _MOD_PROT(p, b)	__pgprot(pgprot_val(p) | (b))
 
-#define PAGE_NONE		_MOD_PROT(pgprot_default, PTE_NG | PTE_XN | PTE_RDONLY)
-#define PAGE_SHARED		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_XN)
-#define PAGE_SHARED_EXEC	_MOD_PROT(pgprot_default, PTE_USER | PTE_NG)
-#define PAGE_COPY		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_XN | PTE_RDONLY)
-#define PAGE_COPY_EXEC		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_RDONLY)
-#define PAGE_READONLY		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_XN | PTE_RDONLY)
-#define PAGE_READONLY_EXEC	_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_RDONLY)
-#define PAGE_KERNEL		_MOD_PROT(pgprot_default, PTE_XN | PTE_DIRTY)
-#define PAGE_KERNEL_EXEC	_MOD_PROT(pgprot_default, PTE_DIRTY)
-
-#define __PAGE_NONE		__pgprot(_PAGE_DEFAULT | PTE_NG | PTE_XN | PTE_RDONLY)
-#define __PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_XN)
-#define __PAGE_SHARED_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG)
-#define __PAGE_COPY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_XN | PTE_RDONLY)
-#define __PAGE_COPY_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_RDONLY)
-#define __PAGE_READONLY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_XN | PTE_RDONLY)
-#define __PAGE_READONLY_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_RDONLY)
+#define PAGE_NONE		_MOD_PROT(pgprot_default, PTE_NG | PTE_PXN | PTE_UXN | PTE_RDONLY)
+#define PAGE_SHARED		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_PXN | PTE_UXN)
+#define PAGE_SHARED_EXEC	_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_PXN)
+#define PAGE_COPY		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_RDONLY)
+#define PAGE_COPY_EXEC		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_PXN | PTE_RDONLY)
+#define PAGE_READONLY		_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_RDONLY)
+#define PAGE_READONLY_EXEC	_MOD_PROT(pgprot_default, PTE_USER | PTE_NG | PTE_PXN | PTE_RDONLY)
+#define PAGE_KERNEL		_MOD_PROT(pgprot_default, PTE_PXN | PTE_UXN | PTE_DIRTY)
+#define PAGE_KERNEL_EXEC	_MOD_PROT(pgprot_default, PTE_UXN | PTE_DIRTY)
+
+#define __PAGE_NONE		__pgprot(_PAGE_DEFAULT | PTE_NG | PTE_PXN | PTE_UXN | PTE_RDONLY)
+#define __PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN)
+#define __PAGE_SHARED_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN)
+#define __PAGE_COPY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_RDONLY)
+#define __PAGE_COPY_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_RDONLY)
+#define __PAGE_READONLY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_RDONLY)
+#define __PAGE_READONLY_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_RDONLY)
 
 #endif /* __ASSEMBLY__ */
 
@@ -130,10 +130,10 @@ extern struct page *empty_zero_page;
 #define pte_young(pte)		(pte_val(pte) & PTE_AF)
 #define pte_special(pte)	(pte_val(pte) & PTE_SPECIAL)
 #define pte_write(pte)		(!(pte_val(pte) & PTE_RDONLY))
-#define pte_exec(pte)		(!(pte_val(pte) & PTE_XN))
+#define pte_exec(pte)		(!(pte_val(pte) & PTE_UXN))
 
 #define pte_present_exec_user(pte) \
-	((pte_val(pte) & (PTE_VALID | PTE_USER | PTE_XN)) == \
+	((pte_val(pte) & (PTE_VALID | PTE_USER | PTE_UXN)) == \
 	 (PTE_VALID | PTE_USER))
 
 #define PTE_BIT_FUNC(fn,op) \
@@ -262,7 +262,7 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long addr)
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	const pteval_t mask = PTE_USER | PTE_XN | PTE_RDONLY;
+	const pteval_t mask = PTE_USER | PTE_PXN | PTE_UXN | PTE_RDONLY;
 	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
 	return pte;
 }
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 5d81004..77f696c 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -43,6 +43,8 @@
 #else
 #define STACK_TOP		STACK_TOP_MAX
 #endif /* CONFIG_COMPAT */
+
+#define ARCH_LOW_ADDRESS_LIMIT	PHYS_MASK
 #endif /* __KERNEL__ */
 
 struct debug_info {
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 63f853f..68aff28 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -14,7 +14,6 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 #ifdef CONFIG_COMPAT
-#define __ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 #define __ARCH_WANT_COMPAT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index ecbf2d8..c76c724 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -613,17 +613,11 @@ enum armv8_pmuv3_perf_types {
 	ARMV8_PMUV3_PERFCTR_BUS_ACCESS				= 0x19,
 	ARMV8_PMUV3_PERFCTR_MEM_ERROR				= 0x1A,
 	ARMV8_PMUV3_PERFCTR_BUS_CYCLES				= 0x1D,
-
-	/*
-	 * This isn't an architected event.
-	 * We detect this event number and use the cycle counter instead.
-	 */
-	ARMV8_PMUV3_PERFCTR_CPU_CYCLES				= 0xFF,
 };
 
 /* PMUv3 HW events mapping. */
 static const unsigned armv8_pmuv3_perf_map[PERF_COUNT_HW_MAX] = {
-	[PERF_COUNT_HW_CPU_CYCLES]		= ARMV8_PMUV3_PERFCTR_CPU_CYCLES,
+	[PERF_COUNT_HW_CPU_CYCLES]		= ARMV8_PMUV3_PERFCTR_CLOCK_CYCLES,
 	[PERF_COUNT_HW_INSTRUCTIONS]		= ARMV8_PMUV3_PERFCTR_INSTR_EXECUTED,
 	[PERF_COUNT_HW_CACHE_REFERENCES]	= ARMV8_PMUV3_PERFCTR_L1_DCACHE_ACCESS,
 	[PERF_COUNT_HW_CACHE_MISSES]		= ARMV8_PMUV3_PERFCTR_L1_DCACHE_REFILL,
@@ -1106,7 +1100,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	unsigned long evtype = event->config_base & ARMV8_EVTYPE_EVENT;
 
 	/* Always place a cycle counter into the cycle counter. */
-	if (evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) {
+	if (evtype == ARMV8_PMUV3_PERFCTR_CLOCK_CYCLES) {
 		if (test_and_set_bit(ARMV8_IDX_CYCLE_COUNTER, cpuc->used_mask))
 			return -EAGAIN;
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index f22965e..e04cebd 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -310,24 +310,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
 }
 
 /*
- * Fill in the task's elfregs structure for a core dump.
- */
-int dump_task_regs(struct task_struct *t, elf_gregset_t *elfregs)
-{
-	elf_core_copy_regs(elfregs, task_pt_regs(t));
-	return 1;
-}
-
-/*
- * fill in the fpe structure for a core dump...
- */
-int dump_fpu (struct pt_regs *regs, struct user_fp *fp)
-{
-	return 0;
-}
-EXPORT_SYMBOL(dump_fpu);
-
-/*
  * Shuffle the argument into the correct register before calling the
  * thread function.  x1 is the thread argument, x2 is the pointer to
  * the thread function, and x3 points to the exit function.
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 226b6bf..538300f 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -211,8 +211,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	 * before we continue.
 	 */
 	set_cpu_online(cpu, true);
-	while (!cpu_active(cpu))
-		cpu_relax();
+	complete(&cpu_running);
 
 	/*
 	 * OK, it's off to the idle thread for us
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index efbf7df..4cd2893 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -80,7 +80,7 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
 #ifdef CONFIG_ZONE_DMA32
 	/* 4GB maximum for 32-bit only capable devices */
 	max_dma32 = min(max, MAX_DMA32_PFN);
-	zone_size[ZONE_DMA32] = max_dma32 - min;
+	zone_size[ZONE_DMA32] = max(min, max_dma32) - min;
 #endif
 	zone_size[ZONE_NORMAL] = max - max_dma32;
 
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index b741250..df2eb4b 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -13,6 +13,7 @@ config FRV
 	select GENERIC_CPU_DEVICES
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_KERNEL_THREAD
+	select GENERIC_KERNEL_EXECVE
 
 config ZONE_DMA
 	bool
diff --git a/arch/frv/boot/Makefile b/arch/frv/boot/Makefile
index 6ae3254..636d5bb 100644
--- a/arch/frv/boot/Makefile
+++ b/arch/frv/boot/Makefile
@@ -17,6 +17,8 @@ PARAMS_PHYS	 = 0x0207c000
 INITRD_PHYS	 = 0x02180000
 INITRD_VIRT	 = 0x02180000
 
+OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment
+
 #
 # If you don't define ZRELADDR above,
 # then it defaults to ZTEXTADDR
@@ -32,18 +34,18 @@ Image: $(obj)/Image
 targets: $(obj)/Image
 
 $(obj)/Image: vmlinux FORCE
-	$(OBJCOPY) -O binary -R .note -R .comment -S vmlinux $@
+	$(OBJCOPY) $(OBJCOPYFLAGS) -S vmlinux $@
 
 #$(obj)/Image:	$(CONFIGURE) $(SYSTEM)
-#	$(OBJCOPY) -O binary -R .note -R .comment -g -S $(SYSTEM) $@
+#	$(OBJCOPY) $(OBJCOPYFLAGS) -g -S $(SYSTEM) $@
 
 bzImage: zImage
 
 zImage:	$(CONFIGURE) compressed/$(LINUX)
-	$(OBJCOPY) -O binary -R .note -R .comment -S compressed/$(LINUX) $@
+	$(OBJCOPY) $(OBJCOPYFLAGS) -S compressed/$(LINUX) $@
 
 bootpImage: bootp/bootp
-	$(OBJCOPY) -O binary -R .note -R .comment -S bootp/bootp $@
+	$(OBJCOPY) $(OBJCOPYFLAGS) -S bootp/bootp $@
 
 compressed/$(LINUX): $(LINUX) dep
 	@$(MAKE) -C compressed $(LINUX)
diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index 266a5b2..2358634 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -30,7 +30,6 @@
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_EXECVE
-#define __ARCH_WANT_KERNEL_EXECVE
 
 /*
  * "Conditional" syscalls
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index ee0beb3..dfcd263 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -869,11 +869,6 @@ ret_from_kernel_thread:
 	call		schedule_tail
 	calll.p		@(gr21,gr0)
 	or		gr20,gr20,gr8
-	bra		sys_exit
-
-	.globl		ret_from_kernel_execve
-ret_from_kernel_execve:
-	ori		gr28,0,sp
 	bra		__syscall_exit
 
 ###################################################################################################
@@ -1080,27 +1075,10 @@ __entry_return_from_kernel_interrupt:
 	subicc		gr5,#0,gr0,icc0
 	beq		icc0,#0,__entry_return_direct
 
-__entry_preempt_need_resched:
-	ldi		@(gr15,#TI_FLAGS),gr4
-	andicc		gr4,#_TIF_NEED_RESCHED,gr0,icc0
-	beq		icc0,#1,__entry_return_direct
-
-	setlos		#PREEMPT_ACTIVE,gr5
-	sti		gr5,@(gr15,#TI_FLAGS)
-
-	andi		gr23,#~PSR_PIL,gr23
-	movgs		gr23,psr
-
-	call		schedule
-	sti		gr0,@(gr15,#TI_PRE_COUNT)
-
-	movsg		psr,gr23
-	ori		gr23,#PSR_PIL_14,gr23
-	movgs		gr23,psr
-	bra		__entry_preempt_need_resched
-#else
-	bra		__entry_return_direct
+	subcc		gr0,gr0,gr0,icc2		/* set Z and clear C */
+	call		preempt_schedule_irq
 #endif
+	bra		__entry_return_direct
 
 
 ###############################################################################
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index e1e3aa1..7e33215 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -181,6 +181,9 @@ int copy_thread(unsigned long clone_flags,
 	childregs = (struct pt_regs *)
 		(task_stack_page(p) + THREAD_SIZE - FRV_FRAME0_SIZE);
 
+	/* set up the userspace frame (the only place that the USP is stored) */
+	*childregs = *__kernel_frame0_ptr;
+
 	p->set_child_tid = p->clear_child_tid = NULL;
 
 	p->thread.frame	 = childregs;
@@ -191,10 +194,8 @@ int copy_thread(unsigned long clone_flags,
 	p->thread.frame0 = childregs;
 
 	if (unlikely(!regs)) {
-		memset(childregs, 0, sizeof(struct pt_regs));
 		childregs->gr9 = usp; /* function */
 		childregs->gr8 = arg;
-		childregs->psr = PSR_S;
 		p->thread.pc = (unsigned long) ret_from_kernel_thread;
 		save_user_regs(p->thread.user);
 		return 0;
diff --git a/arch/frv/mb93090-mb00/pci-dma-nommu.c b/arch/frv/mb93090-mb00/pci-dma-nommu.c
index e47857f..b99c2a7 100644
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c
+++ b/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/export.h>
 #include <linux/dma-mapping.h>
 #include <linux/list.h>
 #include <linux/pci.h>
diff --git a/arch/h8300/include/asm/cache.h b/arch/h8300/include/asm/cache.h
index c635028..05887a1 100644
--- a/arch/h8300/include/asm/cache.h
+++ b/arch/h8300/include/asm/cache.h
@@ -2,7 +2,8 @@
 #define __ARCH_H8300_CACHE_H
 
 /* bytes per L1 cache line */
-#define        L1_CACHE_BYTES  4
+#define        L1_CACHE_SHIFT  2
+#define        L1_CACHE_BYTES  (1 << L1_CACHE_SHIFT)
 
 /* m68k-elf-gcc  2.95.2 doesn't like these */
 
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index acd5b68..082e383 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -637,7 +637,6 @@ mem_init (void)
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
-	reset_zone_present_pages();
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
 			totalram_pages += free_all_bootmem_node(pgdat);
diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
index 67e489d..2df26b5 100644
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -41,7 +41,7 @@ struct k_sigaction {
 static inline void sigaddset(sigset_t *set, int _sig)
 {
 	asm ("bfset %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -49,7 +49,7 @@ static inline void sigaddset(sigset_t *set, int _sig)
 static inline void sigdelset(sigset_t *set, int _sig)
 {
 	asm ("bfclr %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -65,7 +65,7 @@ static inline int __gen_sigismember(sigset_t *set, int _sig)
 	int ret;
 	asm ("bfextu %1{%2,#1},%0"
 		: "=d" (ret)
-		: "od" (*set), "id" ((_sig-1) ^ 31)
+		: "o" (*set), "id" ((_sig-1) ^ 31)
 		: "cc");
 	return ret;
 }
diff --git a/arch/mips/cavium-octeon/executive/cvmx-l2c.c b/arch/mips/cavium-octeon/executive/cvmx-l2c.c
deleted file mode 100644
index d38246e..0000000
--- a/arch/mips/cavium-octeon/executive/cvmx-l2c.c
+++ /dev/null
@@ -1,900 +0,0 @@
-/***********************license start***************
- * Author: Cavium Networks
- *
- * Contact: support@caviumnetworks.com
- * This file is part of the OCTEON SDK
- *
- * Copyright (c) 2003-2010 Cavium Networks
- *
- * This file is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, Version 2, as
- * published by the Free Software Foundation.
- *
- * This file is distributed in the hope that it will be useful, but
- * AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
- * NONINFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this file; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
- * or visit http://www.gnu.org/licenses/.
- *
- * This file may also be available under a different license from Cavium.
- * Contact Cavium Networks for more information
- ***********************license end**************************************/
-
-/*
- * Implementation of the Level 2 Cache (L2C) control,
- * measurement, and debugging facilities.
- */
-
-#include <asm/octeon/cvmx.h>
-#include <asm/octeon/cvmx-l2c.h>
-#include <asm/octeon/cvmx-spinlock.h>
-
-/*
- * This spinlock is used internally to ensure that only one core is
- * performing certain L2 operations at a time.
- *
- * NOTE: This only protects calls from within a single application -
- * if multiple applications or operating systems are running, then it
- * is up to the user program to coordinate between them.
- */
-cvmx_spinlock_t cvmx_l2c_spinlock;
-
-int cvmx_l2c_get_core_way_partition(uint32_t core)
-{
-	uint32_t field;
-
-	/* Validate the core number */
-	if (core >= cvmx_octeon_num_cores())
-		return -1;
-
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX))
-		return cvmx_read_csr(CVMX_L2C_WPAR_PPX(core)) & 0xffff;
-
-	/*
-	 * Use the lower two bits of the coreNumber to determine the
-	 * bit offset of the UMSK[] field in the L2C_SPAR register.
-	 */
-	field = (core & 0x3) * 8;
-
-	/*
-	 * Return the UMSK[] field from the appropriate L2C_SPAR
-	 * register based on the coreNumber.
-	 */
-
-	switch (core & 0xC) {
-	case 0x0:
-		return (cvmx_read_csr(CVMX_L2C_SPAR0) & (0xFF << field)) >> field;
-	case 0x4:
-		return (cvmx_read_csr(CVMX_L2C_SPAR1) & (0xFF << field)) >> field;
-	case 0x8:
-		return (cvmx_read_csr(CVMX_L2C_SPAR2) & (0xFF << field)) >> field;
-	case 0xC:
-		return (cvmx_read_csr(CVMX_L2C_SPAR3) & (0xFF << field)) >> field;
-	}
-	return 0;
-}
-
-int cvmx_l2c_set_core_way_partition(uint32_t core, uint32_t mask)
-{
-	uint32_t field;
-	uint32_t valid_mask;
-
-	valid_mask = (0x1 << cvmx_l2c_get_num_assoc()) - 1;
-
-	mask &= valid_mask;
-
-	/* A UMSK setting which blocks all L2C Ways is an error on some chips */
-	if (mask == valid_mask && !OCTEON_IS_MODEL(OCTEON_CN63XX))
-		return -1;
-
-	/* Validate the core number */
-	if (core >= cvmx_octeon_num_cores())
-		return -1;
-
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX)) {
-		cvmx_write_csr(CVMX_L2C_WPAR_PPX(core), mask);
-		return 0;
-	}
-
-	/*
-	 * Use the lower two bits of core to determine the bit offset of the
-	 * UMSK[] field in the L2C_SPAR register.
-	 */
-	field = (core & 0x3) * 8;
-
-	/*
-	 * Assign the new mask setting to the UMSK[] field in the appropriate
-	 * L2C_SPAR register based on the core_num.
-	 *
-	 */
-	switch (core & 0xC) {
-	case 0x0:
-		cvmx_write_csr(CVMX_L2C_SPAR0,
-			       (cvmx_read_csr(CVMX_L2C_SPAR0) & ~(0xFF << field)) |
-			       mask << field);
-		break;
-	case 0x4:
-		cvmx_write_csr(CVMX_L2C_SPAR1,
-			       (cvmx_read_csr(CVMX_L2C_SPAR1) & ~(0xFF << field)) |
-			       mask << field);
-		break;
-	case 0x8:
-		cvmx_write_csr(CVMX_L2C_SPAR2,
-			       (cvmx_read_csr(CVMX_L2C_SPAR2) & ~(0xFF << field)) |
-			       mask << field);
-		break;
-	case 0xC:
-		cvmx_write_csr(CVMX_L2C_SPAR3,
-			       (cvmx_read_csr(CVMX_L2C_SPAR3) & ~(0xFF << field)) |
-			       mask << field);
-		break;
-	}
-	return 0;
-}
-
-int cvmx_l2c_set_hw_way_partition(uint32_t mask)
-{
-	uint32_t valid_mask;
-
-	valid_mask = (0x1 << cvmx_l2c_get_num_assoc()) - 1;
-	mask &= valid_mask;
-
-	/* A UMSK setting which blocks all L2C Ways is an error on some chips */
-	if (mask == valid_mask  && !OCTEON_IS_MODEL(OCTEON_CN63XX))
-		return -1;
-
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX))
-		cvmx_write_csr(CVMX_L2C_WPAR_IOBX(0), mask);
-	else
-		cvmx_write_csr(CVMX_L2C_SPAR4,
-			       (cvmx_read_csr(CVMX_L2C_SPAR4) & ~0xFF) | mask);
-	return 0;
-}
-
-int cvmx_l2c_get_hw_way_partition(void)
-{
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX))
-		return cvmx_read_csr(CVMX_L2C_WPAR_IOBX(0)) & 0xffff;
-	else
-		return cvmx_read_csr(CVMX_L2C_SPAR4) & (0xFF);
-}
-
-void cvmx_l2c_config_perf(uint32_t counter, enum cvmx_l2c_event event,
-			  uint32_t clear_on_read)
-{
-	if (OCTEON_IS_MODEL(OCTEON_CN5XXX) || OCTEON_IS_MODEL(OCTEON_CN3XXX)) {
-		union cvmx_l2c_pfctl pfctl;
-
-		pfctl.u64 = cvmx_read_csr(CVMX_L2C_PFCTL);
-
-		switch (counter) {
-		case 0:
-			pfctl.s.cnt0sel = event;
-			pfctl.s.cnt0ena = 1;
-			pfctl.s.cnt0rdclr = clear_on_read;
-			break;
-		case 1:
-			pfctl.s.cnt1sel = event;
-			pfctl.s.cnt1ena = 1;
-			pfctl.s.cnt1rdclr = clear_on_read;
-			break;
-		case 2:
-			pfctl.s.cnt2sel = event;
-			pfctl.s.cnt2ena = 1;
-			pfctl.s.cnt2rdclr = clear_on_read;
-			break;
-		case 3:
-		default:
-			pfctl.s.cnt3sel = event;
-			pfctl.s.cnt3ena = 1;
-			pfctl.s.cnt3rdclr = clear_on_read;
-			break;
-		}
-
-		cvmx_write_csr(CVMX_L2C_PFCTL, pfctl.u64);
-	} else {
-		union cvmx_l2c_tadx_prf l2c_tadx_prf;
-		int tad;
-
-		cvmx_dprintf("L2C performance counter events are different for this chip, mapping 'event' to cvmx_l2c_tad_event_t\n");
-		if (clear_on_read)
-			cvmx_dprintf("L2C counters don't support clear on read for this chip\n");
-
-		l2c_tadx_prf.u64 = cvmx_read_csr(CVMX_L2C_TADX_PRF(0));
-
-		switch (counter) {
-		case 0:
-			l2c_tadx_prf.s.cnt0sel = event;
-			break;
-		case 1:
-			l2c_tadx_prf.s.cnt1sel = event;
-			break;
-		case 2:
-			l2c_tadx_prf.s.cnt2sel = event;
-			break;
-		default:
-		case 3:
-			l2c_tadx_prf.s.cnt3sel = event;
-			break;
-		}
-		for (tad = 0; tad < CVMX_L2C_TADS; tad++)
-			cvmx_write_csr(CVMX_L2C_TADX_PRF(tad),
-				       l2c_tadx_prf.u64);
-	}
-}
-
-uint64_t cvmx_l2c_read_perf(uint32_t counter)
-{
-	switch (counter) {
-	case 0:
-		if (OCTEON_IS_MODEL(OCTEON_CN5XXX) || OCTEON_IS_MODEL(OCTEON_CN3XXX))
-			return cvmx_read_csr(CVMX_L2C_PFC0);
-		else {
-			uint64_t counter = 0;
-			int tad;
-			for (tad = 0; tad < CVMX_L2C_TADS; tad++)
-				counter += cvmx_read_csr(CVMX_L2C_TADX_PFC0(tad));
-			return counter;
-		}
-	case 1:
-		if (OCTEON_IS_MODEL(OCTEON_CN5XXX) || OCTEON_IS_MODEL(OCTEON_CN3XXX))
-			return cvmx_read_csr(CVMX_L2C_PFC1);
-		else {
-			uint64_t counter = 0;
-			int tad;
-			for (tad = 0; tad < CVMX_L2C_TADS; tad++)
-				counter += cvmx_read_csr(CVMX_L2C_TADX_PFC1(tad));
-			return counter;
-		}
-	case 2:
-		if (OCTEON_IS_MODEL(OCTEON_CN5XXX) || OCTEON_IS_MODEL(OCTEON_CN3XXX))
-			return cvmx_read_csr(CVMX_L2C_PFC2);
-		else {
-			uint64_t counter = 0;
-			int tad;
-			for (tad = 0; tad < CVMX_L2C_TADS; tad++)
-				counter += cvmx_read_csr(CVMX_L2C_TADX_PFC2(tad));
-			return counter;
-		}
-	case 3:
-	default:
-		if (OCTEON_IS_MODEL(OCTEON_CN5XXX) || OCTEON_IS_MODEL(OCTEON_CN3XXX))
-			return cvmx_read_csr(CVMX_L2C_PFC3);
-		else {
-			uint64_t counter = 0;
-			int tad;
-			for (tad = 0; tad < CVMX_L2C_TADS; tad++)
-				counter += cvmx_read_csr(CVMX_L2C_TADX_PFC3(tad));
-			return counter;
-		}
-	}
-}
-
-/**
- * @INTERNAL
- * Helper function use to fault in cache lines for L2 cache locking
- *
- * @addr:   Address of base of memory region to read into L2 cache
- * @len:    Length (in bytes) of region to fault in
- */
-static void fault_in(uint64_t addr, int len)
-{
-	volatile char *ptr;
-	volatile char dummy;
-	/*
-	 * Adjust addr and length so we get all cache lines even for
-	 * small ranges spanning two cache lines.
-	 */
-	len += addr & CVMX_CACHE_LINE_MASK;
-	addr &= ~CVMX_CACHE_LINE_MASK;
-	ptr = (volatile char *)cvmx_phys_to_ptr(addr);
-	/*
-	 * Invalidate L1 cache to make sure all loads result in data
-	 * being in L2.
-	 */
-	CVMX_DCACHE_INVALIDATE;
-	while (len > 0) {
-		dummy += *ptr;
-		len -= CVMX_CACHE_LINE_SIZE;
-		ptr += CVMX_CACHE_LINE_SIZE;
-	}
-}
-
-int cvmx_l2c_lock_line(uint64_t addr)
-{
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX)) {
-		int shift = CVMX_L2C_TAG_ADDR_ALIAS_SHIFT;
-		uint64_t assoc = cvmx_l2c_get_num_assoc();
-		uint64_t tag = addr >> shift;
-		uint64_t index = CVMX_ADD_SEG(CVMX_MIPS_SPACE_XKPHYS, cvmx_l2c_address_to_index(addr) << CVMX_L2C_IDX_ADDR_SHIFT);
-		uint64_t way;
-		union cvmx_l2c_tadx_tag l2c_tadx_tag;
-
-		CVMX_CACHE_LCKL2(CVMX_ADD_SEG(CVMX_MIPS_SPACE_XKPHYS, addr), 0);
-
-		/* Make sure we were able to lock the line */
-		for (way = 0; way < assoc; way++) {
-			CVMX_CACHE_LTGL2I(index | (way << shift), 0);
-			/* make sure CVMX_L2C_TADX_TAG is updated */
-			CVMX_SYNC;
-			l2c_tadx_tag.u64 = cvmx_read_csr(CVMX_L2C_TADX_TAG(0));
-			if (l2c_tadx_tag.s.valid && l2c_tadx_tag.s.tag == tag)
-				break;
-		}
-
-		/* Check if a valid line is found */
-		if (way >= assoc) {
-			/* cvmx_dprintf("ERROR: cvmx_l2c_lock_line: line not found for locking at 0x%llx address\n", (unsigned long long)addr); */
-			return -1;
-		}
-
-		/* Check if lock bit is not set */
-		if (!l2c_tadx_tag.s.lock) {
-			/* cvmx_dprintf("ERROR: cvmx_l2c_lock_line: Not able to lock at 0x%llx address\n", (unsigned long long)addr); */
-			return -1;
-		}
-		return way;
-	} else {
-		int retval = 0;
-		union cvmx_l2c_dbg l2cdbg;
-		union cvmx_l2c_lckbase lckbase;
-		union cvmx_l2c_lckoff lckoff;
-		union cvmx_l2t_err l2t_err;
-
-		cvmx_spinlock_lock(&cvmx_l2c_spinlock);
-
-		l2cdbg.u64 = 0;
-		lckbase.u64 = 0;
-		lckoff.u64 = 0;
-
-		/* Clear l2t error bits if set */
-		l2t_err.u64 = cvmx_read_csr(CVMX_L2T_ERR);
-		l2t_err.s.lckerr = 1;
-		l2t_err.s.lckerr2 = 1;
-		cvmx_write_csr(CVMX_L2T_ERR, l2t_err.u64);
-
-		addr &= ~CVMX_CACHE_LINE_MASK;
-
-		/* Set this core as debug core */
-		l2cdbg.s.ppnum = cvmx_get_core_num();
-		CVMX_SYNC;
-		cvmx_write_csr(CVMX_L2C_DBG, l2cdbg.u64);
-		cvmx_read_csr(CVMX_L2C_DBG);
-
-		lckoff.s.lck_offset = 0; /* Only lock 1 line at a time */
-		cvmx_write_csr(CVMX_L2C_LCKOFF, lckoff.u64);
-		cvmx_read_csr(CVMX_L2C_LCKOFF);
-
-		if (((union cvmx_l2c_cfg)(cvmx_read_csr(CVMX_L2C_CFG))).s.idxalias) {
-			int alias_shift = CVMX_L2C_IDX_ADDR_SHIFT + 2 * CVMX_L2_SET_BITS - 1;
-			uint64_t addr_tmp = addr ^ (addr & ((1 << alias_shift) - 1)) >> CVMX_L2_SET_BITS;
-			lckbase.s.lck_base = addr_tmp >> 7;
-		} else {
-			lckbase.s.lck_base = addr >> 7;
-		}
-
-		lckbase.s.lck_ena = 1;
-		cvmx_write_csr(CVMX_L2C_LCKBASE, lckbase.u64);
-		/* Make sure it gets there */
-		cvmx_read_csr(CVMX_L2C_LCKBASE);
-
-		fault_in(addr, CVMX_CACHE_LINE_SIZE);
-
-		lckbase.s.lck_ena = 0;
-		cvmx_write_csr(CVMX_L2C_LCKBASE, lckbase.u64);
-		/* Make sure it gets there */
-		cvmx_read_csr(CVMX_L2C_LCKBASE);
-
-		/* Stop being debug core */
-		cvmx_write_csr(CVMX_L2C_DBG, 0);
-		cvmx_read_csr(CVMX_L2C_DBG);
-
-		l2t_err.u64 = cvmx_read_csr(CVMX_L2T_ERR);
-		if (l2t_err.s.lckerr || l2t_err.s.lckerr2)
-			retval = 1;  /* We were unable to lock the line */
-
-		cvmx_spinlock_unlock(&cvmx_l2c_spinlock);
-		return retval;
-	}
-}
-
-int cvmx_l2c_lock_mem_region(uint64_t start, uint64_t len)
-{
-	int retval = 0;
-
-	/* Round start/end to cache line boundaries */
-	len += start & CVMX_CACHE_LINE_MASK;
-	start &= ~CVMX_CACHE_LINE_MASK;
-	len = (len + CVMX_CACHE_LINE_MASK) & ~CVMX_CACHE_LINE_MASK;
-
-	while (len) {
-		retval += cvmx_l2c_lock_line(start);
-		start += CVMX_CACHE_LINE_SIZE;
-		len -= CVMX_CACHE_LINE_SIZE;
-	}
-	return retval;
-}
-
-void cvmx_l2c_flush(void)
-{
-	uint64_t assoc, set;
-	uint64_t n_assoc, n_set;
-
-	n_set = cvmx_l2c_get_num_sets();
-	n_assoc = cvmx_l2c_get_num_assoc();
-
-	if (OCTEON_IS_MODEL(OCTEON_CN6XXX)) {
-		uint64_t address;
-		/* These may look like constants, but they aren't... */
-		int assoc_shift = CVMX_L2C_TAG_ADDR_ALIAS_SHIFT;
-		int set_shift = CVMX_L2C_IDX_ADDR_SHIFT;
-		for (set = 0; set < n_set; set++) {
-			for (assoc = 0; assoc < n_assoc; assoc++) {
-				address = CVMX_ADD_SEG(CVMX_MIPS_SPACE_XKPHYS,
-						       (assoc << assoc_shift) |	(set << set_shift));
-				CVMX_CACHE_WBIL2I(address, 0);
-			}
-		}
-	} else {
-		for (set = 0; set < n_set; set++)
-			for (assoc = 0; assoc < n_assoc; assoc++)
-				cvmx_l2c_flush_line(assoc, set);
-	}
-}
-
-
-int cvmx_l2c_unlock_line(uint64_t address)
-{
-
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX)) {
-		int assoc;
-		union cvmx_l2c_tag tag;
-		uint32_t tag_addr;
-		uint32_t index = cvmx_l2c_address_to_index(address);
-
-		tag_addr = ((address >> CVMX_L2C_TAG_ADDR_ALIAS_SHIFT) & ((1 << CVMX_L2C_TAG_ADDR_ALIAS_SHIFT) - 1));
-
-		/*
-		 * For 63XX, we can flush a line by using the physical
-		 * address directly, so finding the cache line used by
-		 * the address is only required to provide the proper
-		 * return value for the function.
-		 */
-		for (assoc = 0; assoc < CVMX_L2_ASSOC; assoc++) {
-			tag = cvmx_l2c_get_tag(assoc, index);
-
-			if (tag.s.V && (tag.s.addr == tag_addr)) {
-				CVMX_CACHE_WBIL2(CVMX_ADD_SEG(CVMX_MIPS_SPACE_XKPHYS, address), 0);
-				return tag.s.L;
-			}
-		}
-	} else {
-		int assoc;
-		union cvmx_l2c_tag tag;
-		uint32_t tag_addr;
-
-		uint32_t index = cvmx_l2c_address_to_index(address);
-
-		/* Compute portion of address that is stored in tag */
-		tag_addr = ((address >> CVMX_L2C_TAG_ADDR_ALIAS_SHIFT) & ((1 << CVMX_L2C_TAG_ADDR_ALIAS_SHIFT) - 1));
-		for (assoc = 0; assoc < CVMX_L2_ASSOC; assoc++) {
-			tag = cvmx_l2c_get_tag(assoc, index);
-
-			if (tag.s.V && (tag.s.addr == tag_addr)) {
-				cvmx_l2c_flush_line(assoc, index);
-				return tag.s.L;
-			}
-		}
-	}
-	return 0;
-}
-
-int cvmx_l2c_unlock_mem_region(uint64_t start, uint64_t len)
-{
-	int num_unlocked = 0;
-	/* Round start/end to cache line boundaries */
-	len += start & CVMX_CACHE_LINE_MASK;
-	start &= ~CVMX_CACHE_LINE_MASK;
-	len = (len + CVMX_CACHE_LINE_MASK) & ~CVMX_CACHE_LINE_MASK;
-	while (len > 0) {
-		num_unlocked += cvmx_l2c_unlock_line(start);
-		start += CVMX_CACHE_LINE_SIZE;
-		len -= CVMX_CACHE_LINE_SIZE;
-	}
-
-	return num_unlocked;
-}
-
-/*
- * Internal l2c tag types.  These are converted to a generic structure
- * that can be used on all chips.
- */
-union __cvmx_l2c_tag {
-	uint64_t u64;
-	struct cvmx_l2c_tag_cn50xx {
-		uint64_t reserved:40;
-		uint64_t V:1;		/* Line valid */
-		uint64_t D:1;		/* Line dirty */
-		uint64_t L:1;		/* Line locked */
-		uint64_t U:1;		/* Use, LRU eviction */
-		uint64_t addr:20;	/* Phys mem addr (33..14) */
-	} cn50xx;
-	struct cvmx_l2c_tag_cn30xx {
-		uint64_t reserved:41;
-		uint64_t V:1;		/* Line valid */
-		uint64_t D:1;		/* Line dirty */
-		uint64_t L:1;		/* Line locked */
-		uint64_t U:1;		/* Use, LRU eviction */
-		uint64_t addr:19;	/* Phys mem addr (33..15) */
-	} cn30xx;
-	struct cvmx_l2c_tag_cn31xx {
-		uint64_t reserved:42;
-		uint64_t V:1;		/* Line valid */
-		uint64_t D:1;		/* Line dirty */
-		uint64_t L:1;		/* Line locked */
-		uint64_t U:1;		/* Use, LRU eviction */
-		uint64_t addr:18;	/* Phys mem addr (33..16) */
-	} cn31xx;
-	struct cvmx_l2c_tag_cn38xx {
-		uint64_t reserved:43;
-		uint64_t V:1;		/* Line valid */
-		uint64_t D:1;		/* Line dirty */
-		uint64_t L:1;		/* Line locked */
-		uint64_t U:1;		/* Use, LRU eviction */
-		uint64_t addr:17;	/* Phys mem addr (33..17) */
-	} cn38xx;
-	struct cvmx_l2c_tag_cn58xx {
-		uint64_t reserved:44;
-		uint64_t V:1;		/* Line valid */
-		uint64_t D:1;		/* Line dirty */
-		uint64_t L:1;		/* Line locked */
-		uint64_t U:1;		/* Use, LRU eviction */
-		uint64_t addr:16;	/* Phys mem addr (33..18) */
-	} cn58xx;
-	struct cvmx_l2c_tag_cn58xx cn56xx;	/* 2048 sets */
-	struct cvmx_l2c_tag_cn31xx cn52xx;	/* 512 sets */
-};
-
-
-/**
- * @INTERNAL
- * Function to read a L2C tag.  This code make the current core
- * the 'debug core' for the L2.  This code must only be executed by
- * 1 core at a time.
- *
- * @assoc:  Association (way) of the tag to dump
- * @index:  Index of the cacheline
- *
- * Returns The Octeon model specific tag structure.  This is
- *         translated by a wrapper function to a generic form that is
- *         easier for applications to use.
- */
-static union __cvmx_l2c_tag __read_l2_tag(uint64_t assoc, uint64_t index)
-{
-
-	uint64_t debug_tag_addr = CVMX_ADD_SEG(CVMX_MIPS_SPACE_XKPHYS, (index << 7) + 96);
-	uint64_t core = cvmx_get_core_num();
-	union __cvmx_l2c_tag tag_val;
-	uint64_t dbg_addr = CVMX_L2C_DBG;
-	unsigned long flags;
-
-	union cvmx_l2c_dbg debug_val;
-	debug_val.u64 = 0;
-	/*
-	 * For low core count parts, the core number is always small
-	 * enough to stay in the correct field and not set any
-	 * reserved bits.
-	 */
-	debug_val.s.ppnum = core;
-	debug_val.s.l2t = 1;
-	debug_val.s.set = assoc;
-
-	local_irq_save(flags);
-	/*
-	 * Make sure core is quiet (no prefetches, etc.) before
-	 * entering debug mode.
-	 */
-	CVMX_SYNC;
-	/* Flush L1 to make sure debug load misses L1 */
-	CVMX_DCACHE_INVALIDATE;
-
-	/*
-	 * The following must be done in assembly as when in debug
-	 * mode all data loads from L2 return special debug data, not
-	 * normal memory contents.  Also, interrupts must be disabled,
-	 * since if an interrupt occurs while in debug mode the ISR
-	 * will get debug data from all its memory * reads instead of
-	 * the contents of memory.
-	 */
-
-	asm volatile (
-		".set push\n\t"
-		".set mips64\n\t"
-		".set noreorder\n\t"
-		"sd    %[dbg_val], 0(%[dbg_addr])\n\t"   /* Enter debug mode, wait for store */
-		"ld    $0, 0(%[dbg_addr])\n\t"
-		"ld    %[tag_val], 0(%[tag_addr])\n\t"   /* Read L2C tag data */
-		"sd    $0, 0(%[dbg_addr])\n\t"          /* Exit debug mode, wait for store */
-		"ld    $0, 0(%[dbg_addr])\n\t"
-		"cache 9, 0($0)\n\t"             /* Invalidate dcache to discard debug data */
-		".set pop"
-		: [tag_val] "=r" (tag_val)
-		: [dbg_addr] "r" (dbg_addr), [dbg_val] "r" (debug_val), [tag_addr] "r" (debug_tag_addr)
-		: "memory");
-
-	local_irq_restore(flags);
-
-	return tag_val;
-}
-
-
-union cvmx_l2c_tag cvmx_l2c_get_tag(uint32_t association, uint32_t index)
-{
-	union cvmx_l2c_tag tag;
-	tag.u64 = 0;
-
-	if ((int)association >= cvmx_l2c_get_num_assoc()) {
-		cvmx_dprintf("ERROR: cvmx_l2c_get_tag association out of range\n");
-		return tag;
-	}
-	if ((int)index >= cvmx_l2c_get_num_sets()) {
-		cvmx_dprintf("ERROR: cvmx_l2c_get_tag index out of range (arg: %d, max: %d)\n",
-			     (int)index, cvmx_l2c_get_num_sets());
-		return tag;
-	}
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX)) {
-		union cvmx_l2c_tadx_tag l2c_tadx_tag;
-		uint64_t address = CVMX_ADD_SEG(CVMX_MIPS_SPACE_XKPHYS,
-						(association << CVMX_L2C_TAG_ADDR_ALIAS_SHIFT) |
-						(index << CVMX_L2C_IDX_ADDR_SHIFT));
-		/*
-		 * Use L2 cache Index load tag cache instruction, as
-		 * hardware loads the virtual tag for the L2 cache
-		 * block with the contents of L2C_TAD0_TAG
-		 * register.
-		 */
-		CVMX_CACHE_LTGL2I(address, 0);
-		CVMX_SYNC;   /* make sure CVMX_L2C_TADX_TAG is updated */
-		l2c_tadx_tag.u64 = cvmx_read_csr(CVMX_L2C_TADX_TAG(0));
-
-		tag.s.V     = l2c_tadx_tag.s.valid;
-		tag.s.D     = l2c_tadx_tag.s.dirty;
-		tag.s.L     = l2c_tadx_tag.s.lock;
-		tag.s.U     = l2c_tadx_tag.s.use;
-		tag.s.addr  = l2c_tadx_tag.s.tag;
-	} else {
-		union __cvmx_l2c_tag tmp_tag;
-		/* __read_l2_tag is intended for internal use only */
-		tmp_tag = __read_l2_tag(association, index);
-
-		/*
-		 * Convert all tag structure types to generic version,
-		 * as it can represent all models.
-		 */
-		if (OCTEON_IS_MODEL(OCTEON_CN58XX) || OCTEON_IS_MODEL(OCTEON_CN56XX)) {
-			tag.s.V    = tmp_tag.cn58xx.V;
-			tag.s.D    = tmp_tag.cn58xx.D;
-			tag.s.L    = tmp_tag.cn58xx.L;
-			tag.s.U    = tmp_tag.cn58xx.U;
-			tag.s.addr = tmp_tag.cn58xx.addr;
-		} else if (OCTEON_IS_MODEL(OCTEON_CN38XX)) {
-			tag.s.V    = tmp_tag.cn38xx.V;
-			tag.s.D    = tmp_tag.cn38xx.D;
-			tag.s.L    = tmp_tag.cn38xx.L;
-			tag.s.U    = tmp_tag.cn38xx.U;
-			tag.s.addr = tmp_tag.cn38xx.addr;
-		} else if (OCTEON_IS_MODEL(OCTEON_CN31XX) || OCTEON_IS_MODEL(OCTEON_CN52XX)) {
-			tag.s.V    = tmp_tag.cn31xx.V;
-			tag.s.D    = tmp_tag.cn31xx.D;
-			tag.s.L    = tmp_tag.cn31xx.L;
-			tag.s.U    = tmp_tag.cn31xx.U;
-			tag.s.addr = tmp_tag.cn31xx.addr;
-		} else if (OCTEON_IS_MODEL(OCTEON_CN30XX)) {
-			tag.s.V    = tmp_tag.cn30xx.V;
-			tag.s.D    = tmp_tag.cn30xx.D;
-			tag.s.L    = tmp_tag.cn30xx.L;
-			tag.s.U    = tmp_tag.cn30xx.U;
-			tag.s.addr = tmp_tag.cn30xx.addr;
-		} else if (OCTEON_IS_MODEL(OCTEON_CN50XX)) {
-			tag.s.V    = tmp_tag.cn50xx.V;
-			tag.s.D    = tmp_tag.cn50xx.D;
-			tag.s.L    = tmp_tag.cn50xx.L;
-			tag.s.U    = tmp_tag.cn50xx.U;
-			tag.s.addr = tmp_tag.cn50xx.addr;
-		} else {
-			cvmx_dprintf("Unsupported OCTEON Model in %s\n", __func__);
-		}
-	}
-	return tag;
-}
-
-uint32_t cvmx_l2c_address_to_index(uint64_t addr)
-{
-	uint64_t idx = addr >> CVMX_L2C_IDX_ADDR_SHIFT;
-	int indxalias = 0;
-
-	if (OCTEON_IS_MODEL(OCTEON_CN6XXX)) {
-		union cvmx_l2c_ctl l2c_ctl;
-		l2c_ctl.u64 = cvmx_read_csr(CVMX_L2C_CTL);
-		indxalias = !l2c_ctl.s.disidxalias;
-	} else {
-		union cvmx_l2c_cfg l2c_cfg;
-		l2c_cfg.u64 = cvmx_read_csr(CVMX_L2C_CFG);
-		indxalias = l2c_cfg.s.idxalias;
-	}
-
-	if (indxalias) {
-		if (OCTEON_IS_MODEL(OCTEON_CN63XX)) {
-			uint32_t a_14_12 = (idx / (CVMX_L2C_MEMBANK_SELECT_SIZE/(1<<CVMX_L2C_IDX_ADDR_SHIFT))) & 0x7;
-			idx ^= idx / cvmx_l2c_get_num_sets();
-			idx ^= a_14_12;
-		} else {
-			idx ^= ((addr & CVMX_L2C_ALIAS_MASK) >> CVMX_L2C_TAG_ADDR_ALIAS_SHIFT);
-		}
-	}
-	idx &= CVMX_L2C_IDX_MASK;
-	return idx;
-}
-
-int cvmx_l2c_get_cache_size_bytes(void)
-{
-	return cvmx_l2c_get_num_sets() * cvmx_l2c_get_num_assoc() *
-		CVMX_CACHE_LINE_SIZE;
-}
-
-/**
- * Return log base 2 of the number of sets in the L2 cache
- * Returns
- */
-int cvmx_l2c_get_set_bits(void)
-{
-	int l2_set_bits;
-	if (OCTEON_IS_MODEL(OCTEON_CN56XX) || OCTEON_IS_MODEL(OCTEON_CN58XX))
-		l2_set_bits = 11;	/* 2048 sets */
-	else if (OCTEON_IS_MODEL(OCTEON_CN38XX) || OCTEON_IS_MODEL(OCTEON_CN63XX))
-		l2_set_bits = 10;	/* 1024 sets */
-	else if (OCTEON_IS_MODEL(OCTEON_CN31XX) || OCTEON_IS_MODEL(OCTEON_CN52XX))
-		l2_set_bits = 9;	/* 512 sets */
-	else if (OCTEON_IS_MODEL(OCTEON_CN30XX))
-		l2_set_bits = 8;	/* 256 sets */
-	else if (OCTEON_IS_MODEL(OCTEON_CN50XX))
-		l2_set_bits = 7;	/* 128 sets */
-	else {
-		cvmx_dprintf("Unsupported OCTEON Model in %s\n", __func__);
-		l2_set_bits = 11;	/* 2048 sets */
-	}
-	return l2_set_bits;
-}
-
-/* Return the number of sets in the L2 Cache */
-int cvmx_l2c_get_num_sets(void)
-{
-	return 1 << cvmx_l2c_get_set_bits();
-}
-
-/* Return the number of associations in the L2 Cache */
-int cvmx_l2c_get_num_assoc(void)
-{
-	int l2_assoc;
-	if (OCTEON_IS_MODEL(OCTEON_CN56XX) ||
-	    OCTEON_IS_MODEL(OCTEON_CN52XX) ||
-	    OCTEON_IS_MODEL(OCTEON_CN58XX) ||
-	    OCTEON_IS_MODEL(OCTEON_CN50XX) ||
-	    OCTEON_IS_MODEL(OCTEON_CN38XX))
-		l2_assoc = 8;
-	else if (OCTEON_IS_MODEL(OCTEON_CN63XX))
-		l2_assoc = 16;
-	else if (OCTEON_IS_MODEL(OCTEON_CN31XX) ||
-		 OCTEON_IS_MODEL(OCTEON_CN30XX))
-		l2_assoc = 4;
-	else {
-		cvmx_dprintf("Unsupported OCTEON Model in %s\n", __func__);
-		l2_assoc = 8;
-	}
-
-	/* Check to see if part of the cache is disabled */
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX)) {
-		union cvmx_mio_fus_dat3 mio_fus_dat3;
-
-		mio_fus_dat3.u64 = cvmx_read_csr(CVMX_MIO_FUS_DAT3);
-		/*
-		 * cvmx_mio_fus_dat3.s.l2c_crip fuses map as follows
-		 * <2> will be not used for 63xx
-		 * <1> disables 1/2 ways
-		 * <0> disables 1/4 ways
-		 * They are cumulative, so for 63xx:
-		 * <1> <0>
-		 * 0 0 16-way 2MB cache
-		 * 0 1 12-way 1.5MB cache
-		 * 1 0 8-way 1MB cache
-		 * 1 1 4-way 512KB cache
-		 */
-
-		if (mio_fus_dat3.s.l2c_crip == 3)
-			l2_assoc = 4;
-		else if (mio_fus_dat3.s.l2c_crip == 2)
-			l2_assoc = 8;
-		else if (mio_fus_dat3.s.l2c_crip == 1)
-			l2_assoc = 12;
-	} else {
-		union cvmx_l2d_fus3 val;
-		val.u64 = cvmx_read_csr(CVMX_L2D_FUS3);
-		/*
-		 * Using shifts here, as bit position names are
-		 * different for each model but they all mean the
-		 * same.
-		 */
-		if ((val.u64 >> 35) & 0x1)
-			l2_assoc = l2_assoc >> 2;
-		else if ((val.u64 >> 34) & 0x1)
-			l2_assoc = l2_assoc >> 1;
-	}
-	return l2_assoc;
-}
-
-/**
- * Flush a line from the L2 cache
- * This should only be called from one core at a time, as this routine
- * sets the core to the 'debug' core in order to flush the line.
- *
- * @assoc:  Association (or way) to flush
- * @index:  Index to flush
- */
-void cvmx_l2c_flush_line(uint32_t assoc, uint32_t index)
-{
-	/* Check the range of the index. */
-	if (index > (uint32_t)cvmx_l2c_get_num_sets()) {
-		cvmx_dprintf("ERROR: cvmx_l2c_flush_line index out of range.\n");
-		return;
-	}
-
-	/* Check the range of association. */
-	if (assoc > (uint32_t)cvmx_l2c_get_num_assoc()) {
-		cvmx_dprintf("ERROR: cvmx_l2c_flush_line association out of range.\n");
-		return;
-	}
-
-	if (OCTEON_IS_MODEL(OCTEON_CN63XX)) {
-		uint64_t address;
-		/* Create the address based on index and association.
-		 * Bits<20:17> select the way of the cache block involved in
-		 *             the operation
-		 * Bits<16:7> of the effect address select the index
-		 */
-		address = CVMX_ADD_SEG(CVMX_MIPS_SPACE_XKPHYS,
-				(assoc << CVMX_L2C_TAG_ADDR_ALIAS_SHIFT) |
-				(index << CVMX_L2C_IDX_ADDR_SHIFT));
-		CVMX_CACHE_WBIL2I(address, 0);
-	} else {
-		union cvmx_l2c_dbg l2cdbg;
-
-		l2cdbg.u64 = 0;
-		if (!OCTEON_IS_MODEL(OCTEON_CN30XX))
-			l2cdbg.s.ppnum = cvmx_get_core_num();
-		l2cdbg.s.finv = 1;
-
-		l2cdbg.s.set = assoc;
-		cvmx_spinlock_lock(&cvmx_l2c_spinlock);
-		/*
-		 * Enter debug mode, and make sure all other writes
-		 * complete before we enter debug mode
-		 */
-		CVMX_SYNC;
-		cvmx_write_csr(CVMX_L2C_DBG, l2cdbg.u64);
-		cvmx_read_csr(CVMX_L2C_DBG);
-
-		CVMX_PREPARE_FOR_STORE(CVMX_ADD_SEG(CVMX_MIPS_SPACE_XKPHYS,
-						    index * CVMX_CACHE_LINE_SIZE),
-				       0);
-		/* Exit debug mode */
-		CVMX_SYNC;
-		cvmx_write_csr(CVMX_L2C_DBG, 0);
-		cvmx_read_csr(CVMX_L2C_DBG);
-		cvmx_spinlock_unlock(&cvmx_l2c_spinlock);
-	}
-}
diff --git a/arch/unicore32/include/asm/byteorder.h b/arch/unicore32/include/asm/byteorder.h
deleted file mode 100644
index ebe1b3f..0000000
--- a/arch/unicore32/include/asm/byteorder.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * linux/arch/unicore32/include/asm/byteorder.h
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * UniCore ONLY support Little Endian mode, the data bus is connected such
- * that byte accesses appear as:
- *  0 = d0...d7, 1 = d8...d15, 2 = d16...d23, 3 = d24...d31
- * and word accesses (data or instruction) appear as:
- *  d0...d31
- */
-#ifndef __UNICORE_BYTEORDER_H__
-#define __UNICORE_BYTEORDER_H__
-
-#include <linux/byteorder/little_endian.h>
-
-#endif
-
diff --git a/arch/unicore32/include/asm/kvm_para.h b/arch/unicore32/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/unicore32/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/unicore32/include/asm/sigcontext.h b/arch/unicore32/include/asm/sigcontext.h
deleted file mode 100644
index 6a2d767..0000000
--- a/arch/unicore32/include/asm/sigcontext.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * linux/arch/unicore32/include/asm/sigcontext.h
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __UNICORE_SIGCONTEXT_H__
-#define __UNICORE_SIGCONTEXT_H__
-
-#include <asm/ptrace.h>
-/*
- * Signal context structure - contains all info to do with the state
- * before the signal handler was invoked.  Note: only add new entries
- * to the end of the structure.
- */
-struct sigcontext {
-	unsigned long trap_no;
-	unsigned long error_code;
-	unsigned long oldmask;
-	unsigned long fault_address;
-	struct pt_regs regs;
-};
-
-#endif
diff --git a/arch/unicore32/include/asm/unistd.h b/arch/unicore32/include/asm/unistd.h
deleted file mode 100644
index 2abcf61..0000000
--- a/arch/unicore32/include/asm/unistd.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * linux/arch/unicore32/include/asm/unistd.h
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-/* Use the standard ABI for syscalls. */
-#include <asm-generic/unistd.h>
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c91f4c9..5d57469 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5938,6 +5938,12 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+int kvm_arch_vcpu_ioctl_set_entitlement(struct kvm_vcpu *vcpu, long entitlement)
+{
+	vcpu->arch.consigned_limit = entitlement;
+	return 0;
+}
+
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct i387_fxsave_struct *fxsave =
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e2212f..de13648 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -590,6 +590,8 @@ void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_ioctl_set_entitlement(struct kvm_vcpu *vcpu,
+					long entitlement);
 
 void kvm_free_physmem(struct kvm *kvm);
 
diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
deleted file mode 100644
index ee75353..0000000
--- a/include/linux/raid/md_p.h
+++ /dev/null
@@ -1,301 +0,0 @@
-/*
-   md_p.h : physical layout of Linux RAID devices
-          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
-	  
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2, or (at your option)
-   any later version.
-   
-   You should have received a copy of the GNU General Public License
-   (for example /usr/src/linux/COPYING); if not, write to the Free
-   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
-*/
-
-#ifndef _MD_P_H
-#define _MD_P_H
-
-#include <linux/types.h>
-
-/*
- * RAID superblock.
- *
- * The RAID superblock maintains some statistics on each RAID configuration.
- * Each real device in the RAID set contains it near the end of the device.
- * Some of the ideas are copied from the ext2fs implementation.
- *
- * We currently use 4096 bytes as follows:
- *
- *	word offset	function
- *
- *	   0  -    31	Constant generic RAID device information.
- *        32  -    63   Generic state information.
- *	  64  -   127	Personality specific information.
- *	 128  -   511	12 32-words descriptors of the disks in the raid set.
- *	 512  -   911	Reserved.
- *	 912  -  1023	Disk specific descriptor.
- */
-
-/*
- * If x is the real device size in bytes, we return an apparent size of:
- *
- *	y = (x & ~(MD_RESERVED_BYTES - 1)) - MD_RESERVED_BYTES
- *
- * and place the 4kB superblock at offset y.
- */
-#define MD_RESERVED_BYTES		(64 * 1024)
-#define MD_RESERVED_SECTORS		(MD_RESERVED_BYTES / 512)
-
-#define MD_NEW_SIZE_SECTORS(x)		((x & ~(MD_RESERVED_SECTORS - 1)) - MD_RESERVED_SECTORS)
-
-#define MD_SB_BYTES			4096
-#define MD_SB_WORDS			(MD_SB_BYTES / 4)
-#define MD_SB_SECTORS			(MD_SB_BYTES / 512)
-
-/*
- * The following are counted in 32-bit words
- */
-#define	MD_SB_GENERIC_OFFSET		0
-#define MD_SB_PERSONALITY_OFFSET	64
-#define MD_SB_DISKS_OFFSET		128
-#define MD_SB_DESCRIPTOR_OFFSET		992
-
-#define MD_SB_GENERIC_CONSTANT_WORDS	32
-#define MD_SB_GENERIC_STATE_WORDS	32
-#define MD_SB_GENERIC_WORDS		(MD_SB_GENERIC_CONSTANT_WORDS + MD_SB_GENERIC_STATE_WORDS)
-#define MD_SB_PERSONALITY_WORDS		64
-#define MD_SB_DESCRIPTOR_WORDS		32
-#define MD_SB_DISKS			27
-#define MD_SB_DISKS_WORDS		(MD_SB_DISKS*MD_SB_DESCRIPTOR_WORDS)
-#define MD_SB_RESERVED_WORDS		(1024 - MD_SB_GENERIC_WORDS - MD_SB_PERSONALITY_WORDS - MD_SB_DISKS_WORDS - MD_SB_DESCRIPTOR_WORDS)
-#define MD_SB_EQUAL_WORDS		(MD_SB_GENERIC_WORDS + MD_SB_PERSONALITY_WORDS + MD_SB_DISKS_WORDS)
-
-/*
- * Device "operational" state bits
- */
-#define MD_DISK_FAULTY		0 /* disk is faulty / operational */
-#define MD_DISK_ACTIVE		1 /* disk is running or spare disk */
-#define MD_DISK_SYNC		2 /* disk is in sync with the raid set */
-#define MD_DISK_REMOVED		3 /* disk is in sync with the raid set */
-
-#define	MD_DISK_WRITEMOSTLY	9 /* disk is "write-mostly" is RAID1 config.
-				   * read requests will only be sent here in
-				   * dire need
-				   */
-
-typedef struct mdp_device_descriptor_s {
-	__u32 number;		/* 0 Device number in the entire set	      */
-	__u32 major;		/* 1 Device major number		      */
-	__u32 minor;		/* 2 Device minor number		      */
-	__u32 raid_disk;	/* 3 The role of the device in the raid set   */
-	__u32 state;		/* 4 Operational state			      */
-	__u32 reserved[MD_SB_DESCRIPTOR_WORDS - 5];
-} mdp_disk_t;
-
-#define MD_SB_MAGIC		0xa92b4efc
-
-/*
- * Superblock state bits
- */
-#define MD_SB_CLEAN		0
-#define MD_SB_ERRORS		1
-
-#define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
-
-/*
- * Notes:
- * - if an array is being reshaped (restriped) in order to change the
- *   the number of active devices in the array, 'raid_disks' will be
- *   the larger of the old and new numbers.  'delta_disks' will
- *   be the "new - old".  So if +ve, raid_disks is the new value, and
- *   "raid_disks-delta_disks" is the old.  If -ve, raid_disks is the
- *   old value and "raid_disks+delta_disks" is the new (smaller) value.
- */
-
-
-typedef struct mdp_superblock_s {
-	/*
-	 * Constant generic information
-	 */
-	__u32 md_magic;		/*  0 MD identifier 			      */
-	__u32 major_version;	/*  1 major version to which the set conforms */
-	__u32 minor_version;	/*  2 minor version ...			      */
-	__u32 patch_version;	/*  3 patchlevel version ...		      */
-	__u32 gvalid_words;	/*  4 Number of used words in this section    */
-	__u32 set_uuid0;	/*  5 Raid set identifier		      */
-	__u32 ctime;		/*  6 Creation time			      */
-	__u32 level;		/*  7 Raid personality			      */
-	__u32 size;		/*  8 Apparent size of each individual disk   */
-	__u32 nr_disks;		/*  9 total disks in the raid set	      */
-	__u32 raid_disks;	/* 10 disks in a fully functional raid set    */
-	__u32 md_minor;		/* 11 preferred MD minor device number	      */
-	__u32 not_persistent;	/* 12 does it have a persistent superblock    */
-	__u32 set_uuid1;	/* 13 Raid set identifier #2		      */
-	__u32 set_uuid2;	/* 14 Raid set identifier #3		      */
-	__u32 set_uuid3;	/* 15 Raid set identifier #4		      */
-	__u32 gstate_creserved[MD_SB_GENERIC_CONSTANT_WORDS - 16];
-
-	/*
-	 * Generic state information
-	 */
-	__u32 utime;		/*  0 Superblock update time		      */
-	__u32 state;		/*  1 State bits (clean, ...)		      */
-	__u32 active_disks;	/*  2 Number of currently active disks	      */
-	__u32 working_disks;	/*  3 Number of working disks		      */
-	__u32 failed_disks;	/*  4 Number of failed disks		      */
-	__u32 spare_disks;	/*  5 Number of spare disks		      */
-	__u32 sb_csum;		/*  6 checksum of the whole superblock        */
-#ifdef __BIG_ENDIAN
-	__u32 events_hi;	/*  7 high-order of superblock update count   */
-	__u32 events_lo;	/*  8 low-order of superblock update count    */
-	__u32 cp_events_hi;	/*  9 high-order of checkpoint update count   */
-	__u32 cp_events_lo;	/* 10 low-order of checkpoint update count    */
-#else
-	__u32 events_lo;	/*  7 low-order of superblock update count    */
-	__u32 events_hi;	/*  8 high-order of superblock update count   */
-	__u32 cp_events_lo;	/*  9 low-order of checkpoint update count    */
-	__u32 cp_events_hi;	/* 10 high-order of checkpoint update count   */
-#endif
-	__u32 recovery_cp;	/* 11 recovery checkpoint sector count	      */
-	/* There are only valid for minor_version > 90 */
-	__u64 reshape_position;	/* 12,13 next address in array-space for reshape */
-	__u32 new_level;	/* 14 new level we are reshaping to	      */
-	__u32 delta_disks;	/* 15 change in number of raid_disks	      */
-	__u32 new_layout;	/* 16 new layout			      */
-	__u32 new_chunk;	/* 17 new chunk size (bytes)		      */
-	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 18];
-
-	/*
-	 * Personality information
-	 */
-	__u32 layout;		/*  0 the array's physical layout	      */
-	__u32 chunk_size;	/*  1 chunk size in bytes		      */
-	__u32 root_pv;		/*  2 LV root PV */
-	__u32 root_block;	/*  3 LV root block */
-	__u32 pstate_reserved[MD_SB_PERSONALITY_WORDS - 4];
-
-	/*
-	 * Disks information
-	 */
-	mdp_disk_t disks[MD_SB_DISKS];
-
-	/*
-	 * Reserved
-	 */
-	__u32 reserved[MD_SB_RESERVED_WORDS];
-
-	/*
-	 * Active descriptor
-	 */
-	mdp_disk_t this_disk;
-
-} mdp_super_t;
-
-static inline __u64 md_event(mdp_super_t *sb) {
-	__u64 ev = sb->events_hi;
-	return (ev<<32)| sb->events_lo;
-}
-
-#define MD_SUPERBLOCK_1_TIME_SEC_MASK ((1ULL<<40) - 1)
-
-/*
- * The version-1 superblock :
- * All numeric fields are little-endian.
- *
- * total size: 256 bytes plus 2 per device.
- *  1K allows 384 devices.
- */
-struct mdp_superblock_1 {
-	/* constant array information - 128 bytes */
-	__le32	magic;		/* MD_SB_MAGIC: 0xa92b4efc - little endian */
-	__le32	major_version;	/* 1 */
-	__le32	feature_map;	/* bit 0 set if 'bitmap_offset' is meaningful */
-	__le32	pad0;		/* always set to 0 when writing */
-
-	__u8	set_uuid[16];	/* user-space generated. */
-	char	set_name[32];	/* set and interpreted by user-space */
-
-	__le64	ctime;		/* lo 40 bits are seconds, top 24 are microseconds or 0*/
-	__le32	level;		/* -4 (multipath), -1 (linear), 0,1,4,5 */
-	__le32	layout;		/* only for raid5 and raid10 currently */
-	__le64	size;		/* used size of component devices, in 512byte sectors */
-
-	__le32	chunksize;	/* in 512byte sectors */
-	__le32	raid_disks;
-	__le32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
-				 * NOTE: signed, so bitmap can be before superblock
-				 * only meaningful of feature_map[0] is set.
-				 */
-
-	/* These are only valid with feature bit '4' */
-	__le32	new_level;	/* new level we are reshaping to		*/
-	__le64	reshape_position;	/* next address in array-space for reshape */
-	__le32	delta_disks;	/* change in number of raid_disks		*/
-	__le32	new_layout;	/* new layout					*/
-	__le32	new_chunk;	/* new chunk size (512byte sectors)		*/
-	__le32  new_offset;	/* signed number to add to data_offset in new
-				 * layout.  0 == no-change.  This can be
-				 * different on each device in the array.
-				 */
-
-	/* constant this-device information - 64 bytes */
-	__le64	data_offset;	/* sector start of data, often 0 */
-	__le64	data_size;	/* sectors in this device that can be used for data */
-	__le64	super_offset;	/* sector start of this superblock */
-	__le64	recovery_offset;/* sectors before this offset (from data_offset) have been recovered */
-	__le32	dev_number;	/* permanent identifier of this  device - not role in raid */
-	__le32	cnt_corrected_read; /* number of read errors that were corrected by re-writing */
-	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
-	__u8	devflags;	/* per-device flags.  Only one defined...*/
-#define	WriteMostly1	1	/* mask for writemostly flag in above */
-	/* Bad block log.  If there are any bad blocks the feature flag is set.
-	 * If offset and size are non-zero, that space is reserved and available
-	 */
-	__u8	bblog_shift;	/* shift from sectors to block size */
-	__le16	bblog_size;	/* number of sectors reserved for list */
-	__le32	bblog_offset;	/* sector offset from superblock to bblog,
-				 * signed - not unsigned */
-
-	/* array state information - 64 bytes */
-	__le64	utime;		/* 40 bits second, 24 bits microseconds */
-	__le64	events;		/* incremented when superblock updated */
-	__le64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
-	__le32	sb_csum;	/* checksum up to devs[max_dev] */
-	__le32	max_dev;	/* size of devs[] array to consider */
-	__u8	pad3[64-32];	/* set to 0 when writing */
-
-	/* device state information. Indexed by dev_number.
-	 * 2 bytes per device
-	 * Note there are no per-device state flags. State information is rolled
-	 * into the 'roles' value.  If a device is spare or faulty, then it doesn't
-	 * have a meaningful role.
-	 */
-	__le16	dev_roles[0];	/* role in array, or 0xffff for a spare, or 0xfffe for faulty */
-};
-
-/* feature_map bits */
-#define MD_FEATURE_BITMAP_OFFSET	1
-#define	MD_FEATURE_RECOVERY_OFFSET	2 /* recovery_offset is present and
-					   * must be honoured
-					   */
-#define	MD_FEATURE_RESHAPE_ACTIVE	4
-#define	MD_FEATURE_BAD_BLOCKS		8 /* badblock list is not empty */
-#define	MD_FEATURE_REPLACEMENT		16 /* This device is replacing an
-					    * active device with same 'role'.
-					    * 'recovery_offset' is also set.
-					    */
-#define	MD_FEATURE_RESHAPE_BACKWARDS	32 /* Reshape doesn't change number
-					    * of devices, but is going
-					    * backwards anyway.
-					    */
-#define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
-#define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
-					|MD_FEATURE_RECOVERY_OFFSET	\
-					|MD_FEATURE_RESHAPE_ACTIVE	\
-					|MD_FEATURE_BAD_BLOCKS		\
-					|MD_FEATURE_REPLACEMENT		\
-					|MD_FEATURE_RESHAPE_BACKWARDS	\
-					|MD_FEATURE_NEW_OFFSET		\
-					)
-
-#endif 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0a6d6ba..86f24bb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -921,6 +921,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
 /* VM is being stopped by host */
 #define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
+/* Set the consignment limit which will be used to separete steal time */
+#define KVM_SET_ENTITLEMENT	  _IOW(KVMIO, 0xae, unsigned long)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
deleted file mode 100644
index a04276e..0000000
--- a/tools/perf/builtin-test.c
+++ /dev/null
@@ -1,1559 +0,0 @@
-/*
- * builtin-test.c
- *
- * Builtin regression testing command: ever growing number of sanity tests
- */
-#include "builtin.h"
-
-#include "util/cache.h"
-#include "util/color.h"
-#include "util/debug.h"
-#include "util/debugfs.h"
-#include "util/evlist.h"
-#include "util/parse-options.h"
-#include "util/parse-events.h"
-#include "util/symbol.h"
-#include "util/thread_map.h"
-#include "util/pmu.h"
-#include "event-parse.h"
-#include "../../include/linux/hw_breakpoint.h"
-
-#include <sys/mman.h>
-
-static int vmlinux_matches_kallsyms_filter(struct map *map __maybe_unused,
-					   struct symbol *sym)
-{
-	bool *visited = symbol__priv(sym);
-	*visited = true;
-	return 0;
-}
-
-static int test__vmlinux_matches_kallsyms(void)
-{
-	int err = -1;
-	struct rb_node *nd;
-	struct symbol *sym;
-	struct map *kallsyms_map, *vmlinux_map;
-	struct machine kallsyms, vmlinux;
-	enum map_type type = MAP__FUNCTION;
-	struct ref_reloc_sym ref_reloc_sym = { .name = "_stext", };
-
-	/*
-	 * Step 1:
-	 *
-	 * Init the machines that will hold kernel, modules obtained from
-	 * both vmlinux + .ko files and from /proc/kallsyms split by modules.
-	 */
-	machine__init(&kallsyms, "", HOST_KERNEL_ID);
-	machine__init(&vmlinux, "", HOST_KERNEL_ID);
-
-	/*
-	 * Step 2:
-	 *
-	 * Create the kernel maps for kallsyms and the DSO where we will then
-	 * load /proc/kallsyms. Also create the modules maps from /proc/modules
-	 * and find the .ko files that match them in /lib/modules/`uname -r`/.
-	 */
-	if (machine__create_kernel_maps(&kallsyms) < 0) {
-		pr_debug("machine__create_kernel_maps ");
-		return -1;
-	}
-
-	/*
-	 * Step 3:
-	 *
-	 * Load and split /proc/kallsyms into multiple maps, one per module.
-	 */
-	if (machine__load_kallsyms(&kallsyms, "/proc/kallsyms", type, NULL) <= 0) {
-		pr_debug("dso__load_kallsyms ");
-		goto out;
-	}
-
-	/*
-	 * Step 4:
-	 *
-	 * kallsyms will be internally on demand sorted by name so that we can
-	 * find the reference relocation * symbol, i.e. the symbol we will use
-	 * to see if the running kernel was relocated by checking if it has the
-	 * same value in the vmlinux file we load.
-	 */
-	kallsyms_map = machine__kernel_map(&kallsyms, type);
-
-	sym = map__find_symbol_by_name(kallsyms_map, ref_reloc_sym.name, NULL);
-	if (sym == NULL) {
-		pr_debug("dso__find_symbol_by_name ");
-		goto out;
-	}
-
-	ref_reloc_sym.addr = sym->start;
-
-	/*
-	 * Step 5:
-	 *
-	 * Now repeat step 2, this time for the vmlinux file we'll auto-locate.
-	 */
-	if (machine__create_kernel_maps(&vmlinux) < 0) {
-		pr_debug("machine__create_kernel_maps ");
-		goto out;
-	}
-
-	vmlinux_map = machine__kernel_map(&vmlinux, type);
-	map__kmap(vmlinux_map)->ref_reloc_sym = &ref_reloc_sym;
-
-	/*
-	 * Step 6:
-	 *
-	 * Locate a vmlinux file in the vmlinux path that has a buildid that
-	 * matches the one of the running kernel.
-	 *
-	 * While doing that look if we find the ref reloc symbol, if we find it
-	 * we'll have its ref_reloc_symbol.unrelocated_addr and then
-	 * maps__reloc_vmlinux will notice and set proper ->[un]map_ip routines
-	 * to fixup the symbols.
-	 */
-	if (machine__load_vmlinux_path(&vmlinux, type,
-				       vmlinux_matches_kallsyms_filter) <= 0) {
-		pr_debug("machine__load_vmlinux_path ");
-		goto out;
-	}
-
-	err = 0;
-	/*
-	 * Step 7:
-	 *
-	 * Now look at the symbols in the vmlinux DSO and check if we find all of them
-	 * in the kallsyms dso. For the ones that are in both, check its names and
-	 * end addresses too.
-	 */
-	for (nd = rb_first(&vmlinux_map->dso->symbols[type]); nd; nd = rb_next(nd)) {
-		struct symbol *pair, *first_pair;
-		bool backwards = true;
-
-		sym  = rb_entry(nd, struct symbol, rb_node);
-
-		if (sym->start == sym->end)
-			continue;
-
-		first_pair = machine__find_kernel_symbol(&kallsyms, type, sym->start, NULL, NULL);
-		pair = first_pair;
-
-		if (pair && pair->start == sym->start) {
-next_pair:
-			if (strcmp(sym->name, pair->name) == 0) {
-				/*
-				 * kallsyms don't have the symbol end, so we
-				 * set that by using the next symbol start - 1,
-				 * in some cases we get this up to a page
-				 * wrong, trace_kmalloc when I was developing
-				 * this code was one such example, 2106 bytes
-				 * off the real size. More than that and we
-				 * _really_ have a problem.
-				 */
-				s64 skew = sym->end - pair->end;
-				if (llabs(skew) < page_size)
-					continue;
-
-				pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
-					 sym->start, sym->name, sym->end, pair->end);
-			} else {
-				struct rb_node *nnd;
-detour:
-				nnd = backwards ? rb_prev(&pair->rb_node) :
-						  rb_next(&pair->rb_node);
-				if (nnd) {
-					struct symbol *next = rb_entry(nnd, struct symbol, rb_node);
-
-					if (next->start == sym->start) {
-						pair = next;
-						goto next_pair;
-					}
-				}
-
-				if (backwards) {
-					backwards = false;
-					pair = first_pair;
-					goto detour;
-				}
-
-				pr_debug("%#" PRIx64 ": diff name v: %s k: %s\n",
-					 sym->start, sym->name, pair->name);
-			}
-		} else
-			pr_debug("%#" PRIx64 ": %s not on kallsyms\n", sym->start, sym->name);
-
-		err = -1;
-	}
-
-	if (!verbose)
-		goto out;
-
-	pr_info("Maps only in vmlinux:\n");
-
-	for (nd = rb_first(&vmlinux.kmaps.maps[type]); nd; nd = rb_next(nd)) {
-		struct map *pos = rb_entry(nd, struct map, rb_node), *pair;
-		/*
-		 * If it is the kernel, kallsyms is always "[kernel.kallsyms]", while
-		 * the kernel will have the path for the vmlinux file being used,
-		 * so use the short name, less descriptive but the same ("[kernel]" in
-		 * both cases.
-		 */
-		pair = map_groups__find_by_name(&kallsyms.kmaps, type,
-						(pos->dso->kernel ?
-							pos->dso->short_name :
-							pos->dso->name));
-		if (pair)
-			pair->priv = 1;
-		else
-			map__fprintf(pos, stderr);
-	}
-
-	pr_info("Maps in vmlinux with a different name in kallsyms:\n");
-
-	for (nd = rb_first(&vmlinux.kmaps.maps[type]); nd; nd = rb_next(nd)) {
-		struct map *pos = rb_entry(nd, struct map, rb_node), *pair;
-
-		pair = map_groups__find(&kallsyms.kmaps, type, pos->start);
-		if (pair == NULL || pair->priv)
-			continue;
-
-		if (pair->start == pos->start) {
-			pair->priv = 1;
-			pr_info(" %" PRIx64 "-%" PRIx64 " %" PRIx64 " %s in kallsyms as",
-				pos->start, pos->end, pos->pgoff, pos->dso->name);
-			if (pos->pgoff != pair->pgoff || pos->end != pair->end)
-				pr_info(": \n*%" PRIx64 "-%" PRIx64 " %" PRIx64 "",
-					pair->start, pair->end, pair->pgoff);
-			pr_info(" %s\n", pair->dso->name);
-			pair->priv = 1;
-		}
-	}
-
-	pr_info("Maps only in kallsyms:\n");
-
-	for (nd = rb_first(&kallsyms.kmaps.maps[type]);
-	     nd; nd = rb_next(nd)) {
-		struct map *pos = rb_entry(nd, struct map, rb_node);
-
-		if (!pos->priv)
-			map__fprintf(pos, stderr);
-	}
-out:
-	return err;
-}
-
-#include "util/cpumap.h"
-#include "util/evsel.h"
-#include <sys/types.h>
-
-static int trace_event__id(const char *evname)
-{
-	char *filename;
-	int err = -1, fd;
-
-	if (asprintf(&filename,
-		     "%s/syscalls/%s/id",
-		     tracing_events_path, evname) < 0)
-		return -1;
-
-	fd = open(filename, O_RDONLY);
-	if (fd >= 0) {
-		char id[16];
-		if (read(fd, id, sizeof(id)) > 0)
-			err = atoi(id);
-		close(fd);
-	}
-
-	free(filename);
-	return err;
-}
-
-static int test__open_syscall_event(void)
-{
-	int err = -1, fd;
-	struct thread_map *threads;
-	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
-	unsigned int nr_open_calls = 111, i;
-	int id = trace_event__id("sys_enter_open");
-
-	if (id < 0) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
-		return -1;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
-	}
-
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.config = id;
-	evsel = perf_evsel__new(&attr, 0);
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		goto out_thread_map_delete;
-	}
-
-	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
-		pr_debug("failed to open counter: %s, "
-			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-			 strerror(errno));
-		goto out_evsel_delete;
-	}
-
-	for (i = 0; i < nr_open_calls; ++i) {
-		fd = open("/etc/passwd", O_RDONLY);
-		close(fd);
-	}
-
-	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
-		pr_debug("perf_evsel__read_on_cpu\n");
-		goto out_close_fd;
-	}
-
-	if (evsel->counts->cpu[0].val != nr_open_calls) {
-		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %" PRIu64 "\n",
-			 nr_open_calls, evsel->counts->cpu[0].val);
-		goto out_close_fd;
-	}
-	
-	err = 0;
-out_close_fd:
-	perf_evsel__close_fd(evsel, 1, threads->nr);
-out_evsel_delete:
-	perf_evsel__delete(evsel);
-out_thread_map_delete:
-	thread_map__delete(threads);
-	return err;
-}
-
-#include <sched.h>
-
-static int test__open_syscall_event_on_all_cpus(void)
-{
-	int err = -1, fd, cpu;
-	struct thread_map *threads;
-	struct cpu_map *cpus;
-	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
-	unsigned int nr_open_calls = 111, i;
-	cpu_set_t cpu_set;
-	int id = trace_event__id("sys_enter_open");
-
-	if (id < 0) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
-		return -1;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
-	}
-
-	cpus = cpu_map__new(NULL);
-	if (cpus == NULL) {
-		pr_debug("cpu_map__new\n");
-		goto out_thread_map_delete;
-	}
-
-
-	CPU_ZERO(&cpu_set);
-
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.config = id;
-	evsel = perf_evsel__new(&attr, 0);
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		goto out_thread_map_delete;
-	}
-
-	if (perf_evsel__open(evsel, cpus, threads) < 0) {
-		pr_debug("failed to open counter: %s, "
-			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-			 strerror(errno));
-		goto out_evsel_delete;
-	}
-
-	for (cpu = 0; cpu < cpus->nr; ++cpu) {
-		unsigned int ncalls = nr_open_calls + cpu;
-		/*
-		 * XXX eventually lift this restriction in a way that
-		 * keeps perf building on older glibc installations
-		 * without CPU_ALLOC. 1024 cpus in 2010 still seems
-		 * a reasonable upper limit tho :-)
-		 */
-		if (cpus->map[cpu] >= CPU_SETSIZE) {
-			pr_debug("Ignoring CPU %d\n", cpus->map[cpu]);
-			continue;
-		}
-
-		CPU_SET(cpus->map[cpu], &cpu_set);
-		if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
-			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
-				 cpus->map[cpu],
-				 strerror(errno));
-			goto out_close_fd;
-		}
-		for (i = 0; i < ncalls; ++i) {
-			fd = open("/etc/passwd", O_RDONLY);
-			close(fd);
-		}
-		CPU_CLR(cpus->map[cpu], &cpu_set);
-	}
-
-	/*
-	 * Here we need to explicitely preallocate the counts, as if
-	 * we use the auto allocation it will allocate just for 1 cpu,
-	 * as we start by cpu 0.
-	 */
-	if (perf_evsel__alloc_counts(evsel, cpus->nr) < 0) {
-		pr_debug("perf_evsel__alloc_counts(ncpus=%d)\n", cpus->nr);
-		goto out_close_fd;
-	}
-
-	err = 0;
-
-	for (cpu = 0; cpu < cpus->nr; ++cpu) {
-		unsigned int expected;
-
-		if (cpus->map[cpu] >= CPU_SETSIZE)
-			continue;
-
-		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
-			pr_debug("perf_evsel__read_on_cpu\n");
-			err = -1;
-			break;
-		}
-
-		expected = nr_open_calls + cpu;
-		if (evsel->counts->cpu[cpu].val != expected) {
-			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %" PRIu64 "\n",
-				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
-			err = -1;
-		}
-	}
-
-out_close_fd:
-	perf_evsel__close_fd(evsel, 1, threads->nr);
-out_evsel_delete:
-	perf_evsel__delete(evsel);
-out_thread_map_delete:
-	thread_map__delete(threads);
-	return err;
-}
-
-/*
- * This test will generate random numbers of calls to some getpid syscalls,
- * then establish an mmap for a group of events that are created to monitor
- * the syscalls.
- *
- * It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
- * sample.id field to map back to its respective perf_evsel instance.
- *
- * Then it checks if the number of syscalls reported as perf events by
- * the kernel corresponds to the number of syscalls made.
- */
-static int test__basic_mmap(void)
-{
-	int err = -1;
-	union perf_event *event;
-	struct thread_map *threads;
-	struct cpu_map *cpus;
-	struct perf_evlist *evlist;
-	struct perf_event_attr attr = {
-		.type		= PERF_TYPE_TRACEPOINT,
-		.read_format	= PERF_FORMAT_ID,
-		.sample_type	= PERF_SAMPLE_ID,
-		.watermark	= 0,
-	};
-	cpu_set_t cpu_set;
-	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
-					"getpgid", };
-	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
-				      (void*)getpgid };
-#define nsyscalls ARRAY_SIZE(syscall_names)
-	int ids[nsyscalls];
-	unsigned int nr_events[nsyscalls],
-		     expected_nr_events[nsyscalls], i, j;
-	struct perf_evsel *evsels[nsyscalls], *evsel;
-
-	for (i = 0; i < nsyscalls; ++i) {
-		char name[64];
-
-		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
-		ids[i] = trace_event__id(name);
-		if (ids[i] < 0) {
-			pr_debug("Is debugfs mounted on /sys/kernel/debug?\n");
-			return -1;
-		}
-		nr_events[i] = 0;
-		expected_nr_events[i] = random() % 257;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
-	}
-
-	cpus = cpu_map__new(NULL);
-	if (cpus == NULL) {
-		pr_debug("cpu_map__new\n");
-		goto out_free_threads;
-	}
-
-	CPU_ZERO(&cpu_set);
-	CPU_SET(cpus->map[0], &cpu_set);
-	sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
-	if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
-		pr_debug("sched_setaffinity() failed on CPU %d: %s ",
-			 cpus->map[0], strerror(errno));
-		goto out_free_cpus;
-	}
-
-	evlist = perf_evlist__new(cpus, threads);
-	if (evlist == NULL) {
-		pr_debug("perf_evlist__new\n");
-		goto out_free_cpus;
-	}
-
-	/* anonymous union fields, can't be initialized above */
-	attr.wakeup_events = 1;
-	attr.sample_period = 1;
-
-	for (i = 0; i < nsyscalls; ++i) {
-		attr.config = ids[i];
-		evsels[i] = perf_evsel__new(&attr, i);
-		if (evsels[i] == NULL) {
-			pr_debug("perf_evsel__new\n");
-			goto out_free_evlist;
-		}
-
-		perf_evlist__add(evlist, evsels[i]);
-
-		if (perf_evsel__open(evsels[i], cpus, threads) < 0) {
-			pr_debug("failed to open counter: %s, "
-				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-				 strerror(errno));
-			goto out_close_fd;
-		}
-	}
-
-	if (perf_evlist__mmap(evlist, 128, true) < 0) {
-		pr_debug("failed to mmap events: %d (%s)\n", errno,
-			 strerror(errno));
-		goto out_close_fd;
-	}
-
-	for (i = 0; i < nsyscalls; ++i)
-		for (j = 0; j < expected_nr_events[i]; ++j) {
-			int foo = syscalls[i]();
-			++foo;
-		}
-
-	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
-		struct perf_sample sample;
-
-		if (event->header.type != PERF_RECORD_SAMPLE) {
-			pr_debug("unexpected %s event\n",
-				 perf_event__name(event->header.type));
-			goto out_munmap;
-		}
-
-		err = perf_evlist__parse_sample(evlist, event, &sample);
-		if (err) {
-			pr_err("Can't parse sample, err = %d\n", err);
-			goto out_munmap;
-		}
-
-		evsel = perf_evlist__id2evsel(evlist, sample.id);
-		if (evsel == NULL) {
-			pr_debug("event with id %" PRIu64
-				 " doesn't map to an evsel\n", sample.id);
-			goto out_munmap;
-		}
-		nr_events[evsel->idx]++;
-	}
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
-			pr_debug("expected %d %s events, got %d\n",
-				 expected_nr_events[evsel->idx],
-				 perf_evsel__name(evsel), nr_events[evsel->idx]);
-			goto out_munmap;
-		}
-	}
-
-	err = 0;
-out_munmap:
-	perf_evlist__munmap(evlist);
-out_close_fd:
-	for (i = 0; i < nsyscalls; ++i)
-		perf_evsel__close_fd(evsels[i], 1, threads->nr);
-out_free_evlist:
-	perf_evlist__delete(evlist);
-out_free_cpus:
-	cpu_map__delete(cpus);
-out_free_threads:
-	thread_map__delete(threads);
-	return err;
-#undef nsyscalls
-}
-
-static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t **maskp,
-					 size_t *sizep)
-{
-	cpu_set_t *mask;
-	size_t size;
-	int i, cpu = -1, nrcpus = 1024;
-realloc:
-	mask = CPU_ALLOC(nrcpus);
-	size = CPU_ALLOC_SIZE(nrcpus);
-	CPU_ZERO_S(size, mask);
-
-	if (sched_getaffinity(pid, size, mask) == -1) {
-		CPU_FREE(mask);
-		if (errno == EINVAL && nrcpus < (1024 << 8)) {
-			nrcpus = nrcpus << 2;
-			goto realloc;
-		}
-		perror("sched_getaffinity");
-			return -1;
-	}
-
-	for (i = 0; i < nrcpus; i++) {
-		if (CPU_ISSET_S(i, size, mask)) {
-			if (cpu == -1) {
-				cpu = i;
-				*maskp = mask;
-				*sizep = size;
-			} else
-				CPU_CLR_S(i, size, mask);
-		}
-	}
-
-	if (cpu == -1)
-		CPU_FREE(mask);
-
-	return cpu;
-}
-
-static int test__PERF_RECORD(void)
-{
-	struct perf_record_opts opts = {
-		.target = {
-			.uid = UINT_MAX,
-			.uses_mmap = true,
-		},
-		.no_delay   = true,
-		.freq	    = 10,
-		.mmap_pages = 256,
-	};
-	cpu_set_t *cpu_mask = NULL;
-	size_t cpu_mask_size = 0;
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-	struct perf_evsel *evsel;
-	struct perf_sample sample;
-	const char *cmd = "sleep";
-	const char *argv[] = { cmd, "1", NULL, };
-	char *bname;
-	u64 prev_time = 0;
-	bool found_cmd_mmap = false,
-	     found_libc_mmap = false,
-	     found_vdso_mmap = false,
-	     found_ld_mmap = false;
-	int err = -1, errs = 0, i, wakeups = 0;
-	u32 cpu;
-	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
-
-	if (evlist == NULL || argv == NULL) {
-		pr_debug("Not enough memory to create evlist\n");
-		goto out;
-	}
-
-	/*
-	 * We need at least one evsel in the evlist, use the default
-	 * one: "cycles".
-	 */
-	err = perf_evlist__add_default(evlist);
-	if (err < 0) {
-		pr_debug("Not enough memory to create evsel\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Create maps of threads and cpus to monitor. In this case
-	 * we start with all threads and cpus (-1, -1) but then in
-	 * perf_evlist__prepare_workload we'll fill in the only thread
-	 * we're monitoring, the one forked there.
-	 */
-	err = perf_evlist__create_maps(evlist, &opts.target);
-	if (err < 0) {
-		pr_debug("Not enough memory to create thread/cpu maps\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Prepare the workload in argv[] to run, it'll fork it, and then wait
-	 * for perf_evlist__start_workload() to exec it. This is done this way
-	 * so that we have time to open the evlist (calling sys_perf_event_open
-	 * on all the fds) and then mmap them.
-	 */
-	err = perf_evlist__prepare_workload(evlist, &opts, argv);
-	if (err < 0) {
-		pr_debug("Couldn't run the workload!\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Config the evsels, setting attr->comm on the first one, etc.
-	 */
-	evsel = perf_evlist__first(evlist);
-	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
-	evsel->attr.sample_type |= PERF_SAMPLE_TID;
-	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
-	perf_evlist__config_attrs(evlist, &opts);
-
-	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask,
-					    &cpu_mask_size);
-	if (err < 0) {
-		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	cpu = err;
-
-	/*
-	 * So that we can check perf_sample.cpu on all the samples.
-	 */
-	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, cpu_mask) < 0) {
-		pr_debug("sched_setaffinity: %s\n", strerror(errno));
-		goto out_free_cpu_mask;
-	}
-
-	/*
-	 * Call sys_perf_event_open on all the fds on all the evsels,
-	 * grouping them if asked to.
-	 */
-	err = perf_evlist__open(evlist);
-	if (err < 0) {
-		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * mmap the first fd on a given CPU and ask for events for the other
-	 * fds in the same CPU to be injected in the same mmap ring buffer
-	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
-	 */
-	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
-	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Now that all is properly set up, enable the events, they will
-	 * count just on workload.pid, which will start...
-	 */
-	perf_evlist__enable(evlist);
-
-	/*
-	 * Now!
-	 */
-	perf_evlist__start_workload(evlist);
-
-	while (1) {
-		int before = total_events;
-
-		for (i = 0; i < evlist->nr_mmaps; i++) {
-			union perf_event *event;
-
-			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
-				const u32 type = event->header.type;
-				const char *name = perf_event__name(type);
-
-				++total_events;
-				if (type < PERF_RECORD_MAX)
-					nr_events[type]++;
-
-				err = perf_evlist__parse_sample(evlist, event, &sample);
-				if (err < 0) {
-					if (verbose)
-						perf_event__fprintf(event, stderr);
-					pr_debug("Couldn't parse sample\n");
-					goto out_err;
-				}
-
-				if (verbose) {
-					pr_info("%" PRIu64" %d ", sample.time, sample.cpu);
-					perf_event__fprintf(event, stderr);
-				}
-
-				if (prev_time > sample.time) {
-					pr_debug("%s going backwards in time, prev=%" PRIu64 ", curr=%" PRIu64 "\n",
-						 name, prev_time, sample.time);
-					++errs;
-				}
-
-				prev_time = sample.time;
-
-				if (sample.cpu != cpu) {
-					pr_debug("%s with unexpected cpu, expected %d, got %d\n",
-						 name, cpu, sample.cpu);
-					++errs;
-				}
-
-				if ((pid_t)sample.pid != evlist->workload.pid) {
-					pr_debug("%s with unexpected pid, expected %d, got %d\n",
-						 name, evlist->workload.pid, sample.pid);
-					++errs;
-				}
-
-				if ((pid_t)sample.tid != evlist->workload.pid) {
-					pr_debug("%s with unexpected tid, expected %d, got %d\n",
-						 name, evlist->workload.pid, sample.tid);
-					++errs;
-				}
-
-				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP ||
-				     type == PERF_RECORD_FORK ||
-				     type == PERF_RECORD_EXIT) &&
-				     (pid_t)event->comm.pid != evlist->workload.pid) {
-					pr_debug("%s with unexpected pid/tid\n", name);
-					++errs;
-				}
-
-				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP) &&
-				     event->comm.pid != event->comm.tid) {
-					pr_debug("%s with different pid/tid!\n", name);
-					++errs;
-				}
-
-				switch (type) {
-				case PERF_RECORD_COMM:
-					if (strcmp(event->comm.comm, cmd)) {
-						pr_debug("%s with unexpected comm!\n", name);
-						++errs;
-					}
-					break;
-				case PERF_RECORD_EXIT:
-					goto found_exit;
-				case PERF_RECORD_MMAP:
-					bname = strrchr(event->mmap.filename, '/');
-					if (bname != NULL) {
-						if (!found_cmd_mmap)
-							found_cmd_mmap = !strcmp(bname + 1, cmd);
-						if (!found_libc_mmap)
-							found_libc_mmap = !strncmp(bname + 1, "libc", 4);
-						if (!found_ld_mmap)
-							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
-					} else if (!found_vdso_mmap)
-						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
-					break;
-
-				case PERF_RECORD_SAMPLE:
-					/* Just ignore samples for now */
-					break;
-				default:
-					pr_debug("Unexpected perf_event->header.type %d!\n",
-						 type);
-					++errs;
-				}
-			}
-		}
-
-		/*
-		 * We don't use poll here because at least at 3.1 times the
-		 * PERF_RECORD_{!SAMPLE} events don't honour
-		 * perf_event_attr.wakeup_events, just PERF_EVENT_SAMPLE does.
-		 */
-		if (total_events == before && false)
-			poll(evlist->pollfd, evlist->nr_fds, -1);
-
-		sleep(1);
-		if (++wakeups > 5) {
-			pr_debug("No PERF_RECORD_EXIT event!\n");
-			break;
-		}
-	}
-
-found_exit:
-	if (nr_events[PERF_RECORD_COMM] > 1) {
-		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
-		++errs;
-	}
-
-	if (nr_events[PERF_RECORD_COMM] == 0) {
-		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
-		++errs;
-	}
-
-	if (!found_cmd_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", cmd);
-		++errs;
-	}
-
-	if (!found_libc_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "libc");
-		++errs;
-	}
-
-	if (!found_ld_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "ld");
-		++errs;
-	}
-
-	if (!found_vdso_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
-		++errs;
-	}
-out_err:
-	perf_evlist__munmap(evlist);
-out_free_cpu_mask:
-	CPU_FREE(cpu_mask);
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-out:
-	return (err < 0 || errs > 0) ? -1 : 0;
-}
-
-
-#if defined(__x86_64__) || defined(__i386__)
-
-#define barrier() asm volatile("" ::: "memory")
-
-static u64 rdpmc(unsigned int counter)
-{
-	unsigned int low, high;
-
-	asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));
-
-	return low | ((u64)high) << 32;
-}
-
-static u64 rdtsc(void)
-{
-	unsigned int low, high;
-
-	asm volatile("rdtsc" : "=a" (low), "=d" (high));
-
-	return low | ((u64)high) << 32;
-}
-
-static u64 mmap_read_self(void *addr)
-{
-	struct perf_event_mmap_page *pc = addr;
-	u32 seq, idx, time_mult = 0, time_shift = 0;
-	u64 count, cyc = 0, time_offset = 0, enabled, running, delta;
-
-	do {
-		seq = pc->lock;
-		barrier();
-
-		enabled = pc->time_enabled;
-		running = pc->time_running;
-
-		if (enabled != running) {
-			cyc = rdtsc();
-			time_mult = pc->time_mult;
-			time_shift = pc->time_shift;
-			time_offset = pc->time_offset;
-		}
-
-		idx = pc->index;
-		count = pc->offset;
-		if (idx)
-			count += rdpmc(idx - 1);
-
-		barrier();
-	} while (pc->lock != seq);
-
-	if (enabled != running) {
-		u64 quot, rem;
-
-		quot = (cyc >> time_shift);
-		rem = cyc & ((1 << time_shift) - 1);
-		delta = time_offset + quot * time_mult +
-			((rem * time_mult) >> time_shift);
-
-		enabled += delta;
-		if (idx)
-			running += delta;
-
-		quot = count / running;
-		rem = count % running;
-		count = quot * enabled + (rem * enabled) / running;
-	}
-
-	return count;
-}
-
-/*
- * If the RDPMC instruction faults then signal this back to the test parent task:
- */
-static void segfault_handler(int sig __maybe_unused,
-			     siginfo_t *info __maybe_unused,
-			     void *uc __maybe_unused)
-{
-	exit(-1);
-}
-
-static int __test__rdpmc(void)
-{
-	volatile int tmp = 0;
-	u64 i, loops = 1000;
-	int n;
-	int fd;
-	void *addr;
-	struct perf_event_attr attr = {
-		.type = PERF_TYPE_HARDWARE,
-		.config = PERF_COUNT_HW_INSTRUCTIONS,
-		.exclude_kernel = 1,
-	};
-	u64 delta_sum = 0;
-        struct sigaction sa;
-
-	sigfillset(&sa.sa_mask);
-	sa.sa_sigaction = segfault_handler;
-	sigaction(SIGSEGV, &sa, NULL);
-
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
-	if (fd < 0) {
-		pr_err("Error: sys_perf_event_open() syscall returned "
-		       "with %d (%s)\n", fd, strerror(errno));
-		return -1;
-	}
-
-	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
-	if (addr == (void *)(-1)) {
-		pr_err("Error: mmap() syscall returned with (%s)\n",
-		       strerror(errno));
-		goto out_close;
-	}
-
-	for (n = 0; n < 6; n++) {
-		u64 stamp, now, delta;
-
-		stamp = mmap_read_self(addr);
-
-		for (i = 0; i < loops; i++)
-			tmp++;
-
-		now = mmap_read_self(addr);
-		loops *= 10;
-
-		delta = now - stamp;
-		pr_debug("%14d: %14Lu\n", n, (long long)delta);
-
-		delta_sum += delta;
-	}
-
-	munmap(addr, page_size);
-	pr_debug("   ");
-out_close:
-	close(fd);
-
-	if (!delta_sum)
-		return -1;
-
-	return 0;
-}
-
-static int test__rdpmc(void)
-{
-	int status = 0;
-	int wret = 0;
-	int ret;
-	int pid;
-
-	pid = fork();
-	if (pid < 0)
-		return -1;
-
-	if (!pid) {
-		ret = __test__rdpmc();
-
-		exit(ret);
-	}
-
-	wret = waitpid(pid, &status, 0);
-	if (wret < 0 || status)
-		return -1;
-
-	return 0;
-}
-
-#endif
-
-static int test__perf_pmu(void)
-{
-	return perf_pmu__test();
-}
-
-static int perf_evsel__roundtrip_cache_name_test(void)
-{
-	char name[128];
-	int type, op, err = 0, ret = 0, i, idx;
-	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-
-        if (evlist == NULL)
-                return -ENOMEM;
-
-	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
-		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
-			/* skip invalid cache type */
-			if (!perf_evsel__is_cache_op_valid(type, op))
-				continue;
-
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
-									name, sizeof(name));
-				err = parse_events(evlist, name, 0);
-				if (err)
-					ret = err;
-			}
-		}
-	}
-
-	idx = 0;
-	evsel = perf_evlist__first(evlist);
-
-	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
-		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
-			/* skip invalid cache type */
-			if (!perf_evsel__is_cache_op_valid(type, op))
-				continue;
-
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
-									name, sizeof(name));
-				if (evsel->idx != idx)
-					continue;
-
-				++idx;
-
-				if (strcmp(perf_evsel__name(evsel), name)) {
-					pr_debug("%s != %s\n", perf_evsel__name(evsel), name);
-					ret = -1;
-				}
-
-				evsel = perf_evsel__next(evsel);
-			}
-		}
-	}
-
-	perf_evlist__delete(evlist);
-	return ret;
-}
-
-static int __perf_evsel__name_array_test(const char *names[], int nr_names)
-{
-	int i, err;
-	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-
-        if (evlist == NULL)
-                return -ENOMEM;
-
-	for (i = 0; i < nr_names; ++i) {
-		err = parse_events(evlist, names[i], 0);
-		if (err) {
-			pr_debug("failed to parse event '%s', err %d\n",
-				 names[i], err);
-			goto out_delete_evlist;
-		}
-	}
-
-	err = 0;
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		if (strcmp(perf_evsel__name(evsel), names[evsel->idx])) {
-			--err;
-			pr_debug("%s != %s\n", perf_evsel__name(evsel), names[evsel->idx]);
-		}
-	}
-
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-	return err;
-}
-
-#define perf_evsel__name_array_test(names) \
-	__perf_evsel__name_array_test(names, ARRAY_SIZE(names))
-
-static int perf_evsel__roundtrip_name_test(void)
-{
-	int err = 0, ret = 0;
-
-	err = perf_evsel__name_array_test(perf_evsel__hw_names);
-	if (err)
-		ret = err;
-
-	err = perf_evsel__name_array_test(perf_evsel__sw_names);
-	if (err)
-		ret = err;
-
-	err = perf_evsel__roundtrip_cache_name_test();
-	if (err)
-		ret = err;
-
-	return ret;
-}
-
-static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
-				  int size, bool should_be_signed)
-{
-	struct format_field *field = perf_evsel__field(evsel, name);
-	int is_signed;
-	int ret = 0;
-
-	if (field == NULL) {
-		pr_debug("%s: \"%s\" field not found!\n", evsel->name, name);
-		return -1;
-	}
-
-	is_signed = !!(field->flags | FIELD_IS_SIGNED);
-	if (should_be_signed && !is_signed) {
-		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
-			 evsel->name, name, is_signed, should_be_signed);
-		ret = -1;
-	}
-
-	if (field->size != size) {
-		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
-			 evsel->name, name, field->size, size);
-		ret = -1;
-	}
-
-	return ret;
-}
-
-static int perf_evsel__tp_sched_test(void)
-{
-	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
-	int ret = 0;
-
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		return -1;
-	}
-
-	if (perf_evsel__test_field(evsel, "prev_comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_prio", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_state", 8, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_prio", 4, true))
-		ret = -1;
-
-	perf_evsel__delete(evsel);
-
-	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
-
-	if (perf_evsel__test_field(evsel, "comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prio", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "success", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
-		ret = -1;
-
-	return ret;
-}
-
-static int test__syscall_open_tp_fields(void)
-{
-	struct perf_record_opts opts = {
-		.target = {
-			.uid = UINT_MAX,
-			.uses_mmap = true,
-		},
-		.no_delay   = true,
-		.freq	    = 1,
-		.mmap_pages = 256,
-		.raw_samples = true,
-	};
-	const char *filename = "/etc/passwd";
-	int flags = O_RDONLY | O_DIRECTORY;
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-	struct perf_evsel *evsel;
-	int err = -1, i, nr_events = 0, nr_polls = 0;
-
-	if (evlist == NULL) {
-		pr_debug("%s: perf_evlist__new\n", __func__);
-		goto out;
-	}
-
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
-	if (evsel == NULL) {
-		pr_debug("%s: perf_evsel__newtp\n", __func__);
-		goto out_delete_evlist;
-	}
-
-	perf_evlist__add(evlist, evsel);
-
-	err = perf_evlist__create_maps(evlist, &opts.target);
-	if (err < 0) {
-		pr_debug("%s: perf_evlist__create_maps\n", __func__);
-		goto out_delete_evlist;
-	}
-
-	perf_evsel__config(evsel, &opts, evsel);
-
-	evlist->threads->map[0] = getpid();
-
-	err = perf_evlist__open(evlist);
-	if (err < 0) {
-		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	err = perf_evlist__mmap(evlist, UINT_MAX, false);
-	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	perf_evlist__enable(evlist);
-
-	/*
- 	 * Generate the event:
- 	 */
-	open(filename, flags);
-
-	while (1) {
-		int before = nr_events;
-
-		for (i = 0; i < evlist->nr_mmaps; i++) {
-			union perf_event *event;
-
-			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
-				const u32 type = event->header.type;
-				int tp_flags;
-				struct perf_sample sample;
-
-				++nr_events;
-
-				if (type != PERF_RECORD_SAMPLE)
-					continue;
-
-				err = perf_evsel__parse_sample(evsel, event, &sample);
-				if (err) {
-					pr_err("Can't parse sample, err = %d\n", err);
-					goto out_munmap;
-				}
-
-				tp_flags = perf_evsel__intval(evsel, &sample, "flags");
-
-				if (flags != tp_flags) {
-					pr_debug("%s: Expected flags=%#x, got %#x\n",
-						 __func__, flags, tp_flags);
-					goto out_munmap;
-				}
-
-				goto out_ok;
-			}
-		}
-
-		if (nr_events == before)
-			poll(evlist->pollfd, evlist->nr_fds, 10);
-
-		if (++nr_polls > 5) {
-			pr_debug("%s: no events!\n", __func__);
-			goto out_munmap;
-		}
-	}
-out_ok:
-	err = 0;
-out_munmap:
-	perf_evlist__munmap(evlist);
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-out:
-	return err;
-}
-
-static struct test {
-	const char *desc;
-	int (*func)(void);
-} tests[] = {
-	{
-		.desc = "vmlinux symtab matches kallsyms",
-		.func = test__vmlinux_matches_kallsyms,
-	},
-	{
-		.desc = "detect open syscall event",
-		.func = test__open_syscall_event,
-	},
-	{
-		.desc = "detect open syscall event on all cpus",
-		.func = test__open_syscall_event_on_all_cpus,
-	},
-	{
-		.desc = "read samples using the mmap interface",
-		.func = test__basic_mmap,
-	},
-	{
-		.desc = "parse events tests",
-		.func = parse_events__test,
-	},
-#if defined(__x86_64__) || defined(__i386__)
-	{
-		.desc = "x86 rdpmc test",
-		.func = test__rdpmc,
-	},
-#endif
-	{
-		.desc = "Validate PERF_RECORD_* events & perf_sample fields",
-		.func = test__PERF_RECORD,
-	},
-	{
-		.desc = "Test perf pmu format parsing",
-		.func = test__perf_pmu,
-	},
-	{
-		.desc = "Test dso data interface",
-		.func = dso__test_data,
-	},
-	{
-		.desc = "roundtrip evsel->name check",
-		.func = perf_evsel__roundtrip_name_test,
-	},
-	{
-		.desc = "Check parsing of sched tracepoints fields",
-		.func = perf_evsel__tp_sched_test,
-	},
-	{
-		.desc = "Generate and check syscalls:sys_enter_open event fields",
-		.func = test__syscall_open_tp_fields,
-	},
-	{
-		.func = NULL,
-	},
-};
-
-static bool perf_test__matches(int curr, int argc, const char *argv[])
-{
-	int i;
-
-	if (argc == 0)
-		return true;
-
-	for (i = 0; i < argc; ++i) {
-		char *end;
-		long nr = strtoul(argv[i], &end, 10);
-
-		if (*end == '\0') {
-			if (nr == curr + 1)
-				return true;
-			continue;
-		}
-
-		if (strstr(tests[curr].desc, argv[i]))
-			return true;
-	}
-
-	return false;
-}
-
-static int __cmd_test(int argc, const char *argv[])
-{
-	int i = 0;
-	int width = 0;
-
-	while (tests[i].func) {
-		int len = strlen(tests[i].desc);
-
-		if (width < len)
-			width = len;
-		++i;
-	}
-		
-	i = 0;
-	while (tests[i].func) {
-		int curr = i++, err;
-
-		if (!perf_test__matches(curr, argc, argv))
-			continue;
-
-		pr_info("%2d: %-*s:", i, width, tests[curr].desc);
-		pr_debug("\n--- start ---\n");
-		err = tests[curr].func();
-		pr_debug("---- end ----\n%s:", tests[curr].desc);
-		if (err)
-			color_fprintf(stderr, PERF_COLOR_RED, " FAILED!\n");
-		else
-			pr_info(" Ok\n");
-	}
-
-	return 0;
-}
-
-static int perf_test__list(int argc, const char **argv)
-{
-	int i = 0;
-
-	while (tests[i].func) {
-		int curr = i++;
-
-		if (argc > 1 && !strstr(tests[curr].desc, argv[1]))
-			continue;
-
-		pr_info("%2d: %s\n", i, tests[curr].desc);
-	}
-
-	return 0;
-}
-
-int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
-{
-	const char * const test_usage[] = {
-	"perf test [<options>] [{list <test-name-fragment>|[<test-name-fragments>|<test-numbers>]}]",
-	NULL,
-	};
-	const struct option test_options[] = {
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show symbol address, etc)"),
-	OPT_END()
-	};
-
-	argc = parse_options(argc, argv, test_options, test_usage, 0);
-	if (argc >= 1 && !strcmp(argv[0], "list"))
-		return perf_test__list(argc, argv);
-
-	symbol_conf.priv_size = sizeof(int);
-	symbol_conf.sort_by_name = true;
-	symbol_conf.try_vmlinux_path = true;
-
-	if (symbol__init() < 0)
-		return -1;
-
-	return __cmd_test(argc, argv);
-}
diff --git a/tools/perf/util/dso-test-data.c b/tools/perf/util/dso-test-data.c
deleted file mode 100644
index c6caede..0000000
--- a/tools/perf/util/dso-test-data.c
+++ /dev/null
@@ -1,153 +0,0 @@
-#include "util.h"
-
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <string.h>
-
-#include "symbol.h"
-
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
-static char *test_file(int size)
-{
-	static char buf_templ[] = "/tmp/test-XXXXXX";
-	char *templ = buf_templ;
-	int fd, i;
-	unsigned char *buf;
-
-	fd = mkstemp(templ);
-
-	buf = malloc(size);
-	if (!buf) {
-		close(fd);
-		return NULL;
-	}
-
-	for (i = 0; i < size; i++)
-		buf[i] = (unsigned char) ((int) i % 10);
-
-	if (size != write(fd, buf, size))
-		templ = NULL;
-
-	close(fd);
-	return templ;
-}
-
-#define TEST_FILE_SIZE (DSO__DATA_CACHE_SIZE * 20)
-
-struct test_data_offset {
-	off_t offset;
-	u8 data[10];
-	int size;
-};
-
-struct test_data_offset offsets[] = {
-	/* Fill first cache page. */
-	{
-		.offset = 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Read first cache page. */
-	{
-		.offset = 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Fill cache boundary pages. */
-	{
-		.offset = DSO__DATA_CACHE_SIZE - DSO__DATA_CACHE_SIZE % 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Read cache boundary pages. */
-	{
-		.offset = DSO__DATA_CACHE_SIZE - DSO__DATA_CACHE_SIZE % 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Fill final cache page. */
-	{
-		.offset = TEST_FILE_SIZE - 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Read final cache page. */
-	{
-		.offset = TEST_FILE_SIZE - 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Read final cache page. */
-	{
-		.offset = TEST_FILE_SIZE - 3,
-		.data   = { 7, 8, 9, 0, 0, 0, 0, 0, 0, 0 },
-		.size   = 3,
-	},
-};
-
-int dso__test_data(void)
-{
-	struct machine machine;
-	struct dso *dso;
-	char *file = test_file(TEST_FILE_SIZE);
-	size_t i;
-
-	TEST_ASSERT_VAL("No test file", file);
-
-	memset(&machine, 0, sizeof(machine));
-
-	dso = dso__new((const char *)file);
-
-	/* Basic 10 bytes tests. */
-	for (i = 0; i < ARRAY_SIZE(offsets); i++) {
-		struct test_data_offset *data = &offsets[i];
-		ssize_t size;
-		u8 buf[10];
-
-		memset(buf, 0, 10);
-		size = dso__data_read_offset(dso, &machine, data->offset,
-				     buf, 10);
-
-		TEST_ASSERT_VAL("Wrong size", size == data->size);
-		TEST_ASSERT_VAL("Wrong data", !memcmp(buf, data->data, 10));
-	}
-
-	/* Read cross multiple cache pages. */
-	{
-		ssize_t size;
-		int c;
-		u8 *buf;
-
-		buf = malloc(TEST_FILE_SIZE);
-		TEST_ASSERT_VAL("ENOMEM\n", buf);
-
-		/* First iteration to fill caches, second one to read them. */
-		for (c = 0; c < 2; c++) {
-			memset(buf, 0, TEST_FILE_SIZE);
-			size = dso__data_read_offset(dso, &machine, 10,
-						     buf, TEST_FILE_SIZE);
-
-			TEST_ASSERT_VAL("Wrong size",
-				size == (TEST_FILE_SIZE - 10));
-
-			for (i = 0; i < (size_t)size; i++)
-				TEST_ASSERT_VAL("Wrong data",
-					buf[i] == (i % 10));
-		}
-
-		free(buf);
-	}
-
-	dso__delete(dso);
-	unlink(file);
-	return 0;
-}
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
deleted file mode 100644
index b49c2ee..0000000
--- a/tools/perf/util/parse-events-test.c
+++ /dev/null
@@ -1,1116 +0,0 @@
-
-#include "parse-events.h"
-#include "evsel.h"
-#include "evlist.h"
-#include "sysfs.h"
-#include "../../../include/linux/hw_breakpoint.h"
-
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
-#define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
-			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
-
-static int test__checkevent_tracepoint(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	return 0;
-}
-
-static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_TRACEPOINT == evsel->attr.type);
-		TEST_ASSERT_VAL("wrong sample_type",
-			PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
-		TEST_ASSERT_VAL("wrong sample_period",
-			1 == evsel->attr.sample_period);
-	}
-	return 0;
-}
-
-static int test__checkevent_raw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_numeric(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong period",
-			100000 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong config1",
-			0 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2",
-			1 == evsel->attr.config2);
-	return 0;
-}
-
-static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_genhw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", (1 << 16) == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_breakpoint(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
-					 evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
-					evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_X == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len", sizeof(long) == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_R == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_W == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_rw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-		(HW_BREAKPOINT_R|HW_BREAKPOINT_W) == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_tracepoint(evlist);
-}
-
-static int
-test__checkevent_tracepoint_multi_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		TEST_ASSERT_VAL("wrong exclude_user",
-				!evsel->attr.exclude_user);
-		TEST_ASSERT_VAL("wrong exclude_kernel",
-				evsel->attr.exclude_kernel);
-		TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-		TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	}
-
-	return test__checkevent_tracepoint_multi(evlist);
-}
-
-static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_raw(evlist);
-}
-
-static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_numeric(evlist);
-}
-
-static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_symbolic_alias(evlist);
-}
-
-static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_genhw(evlist);
-}
-
-static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:u"));
-
-	return test__checkevent_breakpoint(evlist);
-}
-
-static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:x:k"));
-
-	return test__checkevent_breakpoint_x(evlist);
-}
-
-static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:r:hp"));
-
-	return test__checkevent_breakpoint_r(evlist);
-}
-
-static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:w:up"));
-
-	return test__checkevent_breakpoint_w(evlist);
-}
-
-static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:rw:kp"));
-
-	return test__checkevent_breakpoint_rw(evlist);
-}
-
-static int test__checkevent_pmu(struct perf_evlist *evlist)
-{
-
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",    10 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong config1",    1 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2",    3 == evsel->attr.config2);
-	TEST_ASSERT_VAL("wrong period",  1000 == evsel->attr.sample_period);
-
-	return 0;
-}
-
-static int test__checkevent_list(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
-
-	/* r1 */
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2", 0 == evsel->attr.config2);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	/* syscalls:sys_enter_open:k */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	/* 1:1:hp */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return 0;
-}
-
-static int test__checkevent_pmu_name(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	/* cpu/config=1,name=krava/u */
-	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "krava"));
-
-	/* cpu/config=2/u" */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "cpu/config=2/u"));
-
-	return 0;
-}
-
-static int test__checkevent_pmu_events(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong exclude_user",
-			!evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel",
-			evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return 0;
-}
-
-static int test__checkterms_simple(struct list_head *terms)
-{
-	struct parse_events__term *term;
-
-	/* config=10 */
-	term = list_entry(terms->next, struct parse_events__term, list);
-	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG);
-	TEST_ASSERT_VAL("wrong type val",
-			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
-	TEST_ASSERT_VAL("wrong val", term->val.num == 10);
-	TEST_ASSERT_VAL("wrong config", !term->config);
-
-	/* config1 */
-	term = list_entry(term->list.next, struct parse_events__term, list);
-	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG1);
-	TEST_ASSERT_VAL("wrong type val",
-			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
-	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
-	TEST_ASSERT_VAL("wrong config", !term->config);
-
-	/* config2=3 */
-	term = list_entry(term->list.next, struct parse_events__term, list);
-	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG2);
-	TEST_ASSERT_VAL("wrong type val",
-			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
-	TEST_ASSERT_VAL("wrong val", term->val.num == 3);
-	TEST_ASSERT_VAL("wrong config", !term->config);
-
-	/* umask=1*/
-	term = list_entry(term->list.next, struct parse_events__term, list);
-	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_USER);
-	TEST_ASSERT_VAL("wrong type val",
-			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
-	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
-	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "umask"));
-
-	return 0;
-}
-
-static int test__group1(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
-
-	/* instructions:k */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* cycles:upp */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	/* use of precise requires exclude_guest */
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	return 0;
-}
-
-static int test__group2(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
-
-	/* faults + :ku modifier */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* cache-references + :u modifier */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CACHE_REFERENCES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	/* cycles:k */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	return 0;
-}
-
-static int test__group3(struct perf_evlist *evlist __maybe_unused)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
-
-	/* group1 syscalls:sys_enter_open:H */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-	TEST_ASSERT_VAL("wrong group name",
-		!strcmp(leader->group_name, "group1"));
-
-	/* group1 cycles:kppp */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	/* use of precise requires exclude_guest */
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 3);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-
-	/* group2 cycles + G modifier */
-	evsel = leader = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-	TEST_ASSERT_VAL("wrong group name",
-		!strcmp(leader->group_name, "group2"));
-
-	/* group2 1:3 + G modifier */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 3 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	/* instructions:u */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	return 0;
-}
-
-static int test__group4(struct perf_evlist *evlist __maybe_unused)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
-
-	/* cycles:u + p */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	/* use of precise requires exclude_guest */
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
-	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* instructions:kp + p */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	/* use of precise requires exclude_guest */
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	return 0;
-}
-
-static int test__group5(struct perf_evlist *evlist __maybe_unused)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
-
-	/* cycles + G */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* instructions + G */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	/* cycles:G */
-	evsel = leader = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* instructions:G */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	/* cycles */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	return 0;
-}
-
-struct test__event_st {
-	const char *name;
-	__u32 type;
-	int (*check)(struct perf_evlist *evlist);
-};
-
-static struct test__event_st test__events[] = {
-	[0] = {
-		.name  = "syscalls:sys_enter_open",
-		.check = test__checkevent_tracepoint,
-	},
-	[1] = {
-		.name  = "syscalls:*",
-		.check = test__checkevent_tracepoint_multi,
-	},
-	[2] = {
-		.name  = "r1a",
-		.check = test__checkevent_raw,
-	},
-	[3] = {
-		.name  = "1:1",
-		.check = test__checkevent_numeric,
-	},
-	[4] = {
-		.name  = "instructions",
-		.check = test__checkevent_symbolic_name,
-	},
-	[5] = {
-		.name  = "cycles/period=100000,config2/",
-		.check = test__checkevent_symbolic_name_config,
-	},
-	[6] = {
-		.name  = "faults",
-		.check = test__checkevent_symbolic_alias,
-	},
-	[7] = {
-		.name  = "L1-dcache-load-miss",
-		.check = test__checkevent_genhw,
-	},
-	[8] = {
-		.name  = "mem:0",
-		.check = test__checkevent_breakpoint,
-	},
-	[9] = {
-		.name  = "mem:0:x",
-		.check = test__checkevent_breakpoint_x,
-	},
-	[10] = {
-		.name  = "mem:0:r",
-		.check = test__checkevent_breakpoint_r,
-	},
-	[11] = {
-		.name  = "mem:0:w",
-		.check = test__checkevent_breakpoint_w,
-	},
-	[12] = {
-		.name  = "syscalls:sys_enter_open:k",
-		.check = test__checkevent_tracepoint_modifier,
-	},
-	[13] = {
-		.name  = "syscalls:*:u",
-		.check = test__checkevent_tracepoint_multi_modifier,
-	},
-	[14] = {
-		.name  = "r1a:kp",
-		.check = test__checkevent_raw_modifier,
-	},
-	[15] = {
-		.name  = "1:1:hp",
-		.check = test__checkevent_numeric_modifier,
-	},
-	[16] = {
-		.name  = "instructions:h",
-		.check = test__checkevent_symbolic_name_modifier,
-	},
-	[17] = {
-		.name  = "faults:u",
-		.check = test__checkevent_symbolic_alias_modifier,
-	},
-	[18] = {
-		.name  = "L1-dcache-load-miss:kp",
-		.check = test__checkevent_genhw_modifier,
-	},
-	[19] = {
-		.name  = "mem:0:u",
-		.check = test__checkevent_breakpoint_modifier,
-	},
-	[20] = {
-		.name  = "mem:0:x:k",
-		.check = test__checkevent_breakpoint_x_modifier,
-	},
-	[21] = {
-		.name  = "mem:0:r:hp",
-		.check = test__checkevent_breakpoint_r_modifier,
-	},
-	[22] = {
-		.name  = "mem:0:w:up",
-		.check = test__checkevent_breakpoint_w_modifier,
-	},
-	[23] = {
-		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
-		.check = test__checkevent_list,
-	},
-	[24] = {
-		.name  = "instructions:G",
-		.check = test__checkevent_exclude_host_modifier,
-	},
-	[25] = {
-		.name  = "instructions:H",
-		.check = test__checkevent_exclude_guest_modifier,
-	},
-	[26] = {
-		.name  = "mem:0:rw",
-		.check = test__checkevent_breakpoint_rw,
-	},
-	[27] = {
-		.name  = "mem:0:rw:kp",
-		.check = test__checkevent_breakpoint_rw_modifier,
-	},
-	[28] = {
-		.name  = "{instructions:k,cycles:upp}",
-		.check = test__group1,
-	},
-	[29] = {
-		.name  = "{faults:k,cache-references}:u,cycles:k",
-		.check = test__group2,
-	},
-	[30] = {
-		.name  = "group1{syscalls:sys_enter_open:H,cycles:kppp},group2{cycles,1:3}:G,instructions:u",
-		.check = test__group3,
-	},
-	[31] = {
-		.name  = "{cycles:u,instructions:kp}:p",
-		.check = test__group4,
-	},
-	[32] = {
-		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
-		.check = test__group5,
-	},
-};
-
-static struct test__event_st test__events_pmu[] = {
-	[0] = {
-		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
-		.check = test__checkevent_pmu,
-	},
-	[1] = {
-		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
-		.check = test__checkevent_pmu_name,
-	},
-};
-
-struct test__term {
-	const char *str;
-	__u32 type;
-	int (*check)(struct list_head *terms);
-};
-
-static struct test__term test__terms[] = {
-	[0] = {
-		.str   = "config=10,config1,config2=3,umask=1",
-		.check = test__checkterms_simple,
-	},
-};
-
-static int test_event(struct test__event_st *e)
-{
-	struct perf_evlist *evlist;
-	int ret;
-
-	evlist = perf_evlist__new(NULL, NULL);
-	if (evlist == NULL)
-		return -ENOMEM;
-
-	ret = parse_events(evlist, e->name, 0);
-	if (ret) {
-		pr_debug("failed to parse event '%s', err %d\n",
-			 e->name, ret);
-		return ret;
-	}
-
-	ret = e->check(evlist);
-	perf_evlist__delete(evlist);
-
-	return ret;
-}
-
-static int test_events(struct test__event_st *events, unsigned cnt)
-{
-	int ret1, ret2 = 0;
-	unsigned i;
-
-	for (i = 0; i < cnt; i++) {
-		struct test__event_st *e = &events[i];
-
-		pr_debug("running test %d '%s'\n", i, e->name);
-		ret1 = test_event(e);
-		if (ret1)
-			ret2 = ret1;
-	}
-
-	return ret2;
-}
-
-static int test_term(struct test__term *t)
-{
-	struct list_head *terms;
-	int ret;
-
-	terms = malloc(sizeof(*terms));
-	if (!terms)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(terms);
-
-	ret = parse_events_terms(terms, t->str);
-	if (ret) {
-		pr_debug("failed to parse terms '%s', err %d\n",
-			 t->str , ret);
-		return ret;
-	}
-
-	ret = t->check(terms);
-	parse_events__free_terms(terms);
-
-	return ret;
-}
-
-static int test_terms(struct test__term *terms, unsigned cnt)
-{
-	int ret = 0;
-	unsigned i;
-
-	for (i = 0; i < cnt; i++) {
-		struct test__term *t = &terms[i];
-
-		pr_debug("running test %d '%s'\n", i, t->str);
-		ret = test_term(t);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
-static int test_pmu(void)
-{
-	struct stat st;
-	char path[PATH_MAX];
-	int ret;
-
-	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/format/",
-		 sysfs_find_mountpoint());
-
-	ret = stat(path, &st);
-	if (ret)
-		pr_debug("omitting PMU cpu tests\n");
-	return !ret;
-}
-
-static int test_pmu_events(void)
-{
-	struct stat st;
-	char path[PATH_MAX];
-	struct dirent *ent;
-	DIR *dir;
-	int ret;
-
-	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/",
-		 sysfs_find_mountpoint());
-
-	ret = stat(path, &st);
-	if (ret) {
-		pr_debug("ommiting PMU cpu events tests\n");
-		return 0;
-	}
-
-	dir = opendir(path);
-	if (!dir) {
-		pr_debug("can't open pmu event dir");
-		return -1;
-	}
-
-	while (!ret && (ent = readdir(dir))) {
-#define MAX_NAME 100
-		struct test__event_st e;
-		char name[MAX_NAME];
-
-		if (!strcmp(ent->d_name, ".") ||
-		    !strcmp(ent->d_name, ".."))
-			continue;
-
-		snprintf(name, MAX_NAME, "cpu/event=%s/u", ent->d_name);
-
-		e.name  = name;
-		e.check = test__checkevent_pmu_events;
-
-		ret = test_event(&e);
-#undef MAX_NAME
-	}
-
-	closedir(dir);
-	return ret;
-}
-
-int parse_events__test(void)
-{
-	int ret1, ret2 = 0;
-
-#define TEST_EVENTS(tests)				\
-do {							\
-	ret1 = test_events(tests, ARRAY_SIZE(tests));	\
-	if (!ret2)					\
-		ret2 = ret1;				\
-} while (0)
-
-	TEST_EVENTS(test__events);
-
-	if (test_pmu())
-		TEST_EVENTS(test__events_pmu);
-
-	if (test_pmu()) {
-		int ret = test_pmu_events();
-		if (ret)
-			return ret;
-	}
-
-	ret1 = test_terms(test__terms, ARRAY_SIZE(test__terms));
-	if (!ret2)
-		ret2 = ret1;
-
-	return ret2;
-}
diff --git a/tools/testing/selftests/epoll/Makefile b/tools/testing/selftests/epoll/Makefile
deleted file mode 100644
index 19806ed..0000000
--- a/tools/testing/selftests/epoll/Makefile
+++ /dev/null
@@ -1,11 +0,0 @@
-# Makefile for epoll selftests
-
-all: test_epoll
-%: %.c
-	gcc -pthread -g -o $@ $^
-
-run_tests: all
-	./test_epoll
-
-clean:
-	$(RM) test_epoll
diff --git a/tools/testing/selftests/epoll/test_epoll.c b/tools/testing/selftests/epoll/test_epoll.c
deleted file mode 100644
index f752539..0000000
--- a/tools/testing/selftests/epoll/test_epoll.c
+++ /dev/null
@@ -1,344 +0,0 @@
-/*
- *  tools/testing/selftests/epoll/test_epoll.c
- *
- *  Copyright 2012 Adobe Systems Incorporated
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  Paton J. Lewis <palewis@adobe.com>
- *
- */
-
-#include <errno.h>
-#include <fcntl.h>
-#include <pthread.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <sys/epoll.h>
-#include <sys/socket.h>
-
-/*
- * A pointer to an epoll_item_private structure will be stored in the epoll
- * item's event structure so that we can get access to the epoll_item_private
- * data after calling epoll_wait:
- */
-struct epoll_item_private {
-	int index;  /* Position of this struct within the epoll_items array. */
-	int fd;
-	uint32_t events;
-	pthread_mutex_t mutex;  /* Guards the following variables... */
-	int stop;
-	int status;  /* Stores any error encountered while handling item. */
-	/* The following variable allows us to test whether we have encountered
-	   a problem while attempting to cancel and delete the associated
-	   event. When the test program exits, 'deleted' should be exactly
-	   one. If it is greater than one, then the failed test reflects a real
-	   world situation where we would have tried to access the epoll item's
-	   private data after deleting it: */
-	int deleted;
-};
-
-struct epoll_item_private *epoll_items;
-
-/*
- * Delete the specified item from the epoll set. In a real-world secneario this
- * is where we would free the associated data structure, but in this testing
- * environment we retain the structure so that we can test for double-deletion:
- */
-void delete_item(int index)
-{
-	__sync_fetch_and_add(&epoll_items[index].deleted, 1);
-}
-
-/*
- * A pointer to a read_thread_data structure will be passed as the argument to
- * each read thread:
- */
-struct read_thread_data {
-	int stop;
-	int status;  /* Indicates any error encountered by the read thread. */
-	int epoll_set;
-};
-
-/*
- * The function executed by the read threads:
- */
-void *read_thread_function(void *function_data)
-{
-	struct read_thread_data *thread_data =
-		(struct read_thread_data *)function_data;
-	struct epoll_event event_data;
-	struct epoll_item_private *item_data;
-	char socket_data;
-
-	/* Handle events until we encounter an error or this thread's 'stop'
-	   condition is set: */
-	while (1) {
-		int result = epoll_wait(thread_data->epoll_set,
-					&event_data,
-					1,	/* Number of desired events */
-					1000);  /* Timeout in ms */
-		if (result < 0) {
-			/* Breakpoints signal all threads. Ignore that while
-			   debugging: */
-			if (errno == EINTR)
-				continue;
-			thread_data->status = errno;
-			return 0;
-		} else if (thread_data->stop)
-			return 0;
-		else if (result == 0)  /* Timeout */
-			continue;
-
-		/* We need the mutex here because checking for the stop
-		   condition and re-enabling the epoll item need to be done
-		   together as one atomic operation when EPOLL_CTL_DISABLE is
-		   available: */
-		item_data = (struct epoll_item_private *)event_data.data.ptr;
-		pthread_mutex_lock(&item_data->mutex);
-
-		/* Remove the item from the epoll set if we want to stop
-		   handling that event: */
-		if (item_data->stop)
-			delete_item(item_data->index);
-		else {
-			/* Clear the data that was written to the other end of
-			   our non-blocking socket: */
-			do {
-				if (read(item_data->fd, &socket_data, 1) < 1) {
-					if ((errno == EAGAIN) ||
-					    (errno == EWOULDBLOCK))
-						break;
-					else
-						goto error_unlock;
-				}
-			} while (item_data->events & EPOLLET);
-
-			/* The item was one-shot, so re-enable it: */
-			event_data.events = item_data->events;
-			if (epoll_ctl(thread_data->epoll_set,
-						  EPOLL_CTL_MOD,
-						  item_data->fd,
-						  &event_data) < 0)
-				goto error_unlock;
-		}
-
-		pthread_mutex_unlock(&item_data->mutex);
-	}
-
-error_unlock:
-	thread_data->status = item_data->status = errno;
-	pthread_mutex_unlock(&item_data->mutex);
-	return 0;
-}
-
-/*
- * A pointer to a write_thread_data structure will be passed as the argument to
- * the write thread:
- */
-struct write_thread_data {
-	int stop;
-	int status;  /* Indicates any error encountered by the write thread. */
-	int n_fds;
-	int *fds;
-};
-
-/*
- * The function executed by the write thread. It writes a single byte to each
- * socket in turn until the stop condition for this thread is set. If writing to
- * a socket would block (i.e. errno was EAGAIN), we leave that socket alone for
- * the moment and just move on to the next socket in the list. We don't care
- * about the order in which we deliver events to the epoll set. In fact we don't
- * care about the data we're writing to the pipes at all; we just want to
- * trigger epoll events:
- */
-void *write_thread_function(void *function_data)
-{
-	const char data = 'X';
-	int index;
-	struct write_thread_data *thread_data =
-		(struct write_thread_data *)function_data;
-	while (!thread_data->stop)
-		for (index = 0;
-		     !thread_data->stop && (index < thread_data->n_fds);
-		     ++index)
-			if ((write(thread_data->fds[index], &data, 1) < 1) &&
-				(errno != EAGAIN) &&
-				(errno != EWOULDBLOCK)) {
-				thread_data->status = errno;
-				return;
-			}
-}
-
-/*
- * Arguments are currently ignored:
- */
-int main(int argc, char **argv)
-{
-	const int n_read_threads = 100;
-	const int n_epoll_items = 500;
-	int index;
-	int epoll_set = epoll_create1(0);
-	struct write_thread_data write_thread_data = {
-		0, 0, n_epoll_items, malloc(n_epoll_items * sizeof(int))
-	};
-	struct read_thread_data *read_thread_data =
-		malloc(n_read_threads * sizeof(struct read_thread_data));
-	pthread_t *read_threads = malloc(n_read_threads * sizeof(pthread_t));
-	pthread_t write_thread;
-
-	printf("-----------------\n");
-	printf("Runing test_epoll\n");
-	printf("-----------------\n");
-
-	epoll_items = malloc(n_epoll_items * sizeof(struct epoll_item_private));
-
-	if (epoll_set < 0 || epoll_items == 0 || write_thread_data.fds == 0 ||
-		read_thread_data == 0 || read_threads == 0)
-		goto error;
-
-	if (sysconf(_SC_NPROCESSORS_ONLN) < 2) {
-		printf("Error: please run this test on a multi-core system.\n");
-		goto error;
-	}
-
-	/* Create the socket pairs and epoll items: */
-	for (index = 0; index < n_epoll_items; ++index) {
-		int socket_pair[2];
-		struct epoll_event event_data;
-		if (socketpair(AF_UNIX,
-			       SOCK_STREAM | SOCK_NONBLOCK,
-			       0,
-			       socket_pair) < 0)
-			goto error;
-		write_thread_data.fds[index] = socket_pair[0];
-		epoll_items[index].index = index;
-		epoll_items[index].fd = socket_pair[1];
-		if (pthread_mutex_init(&epoll_items[index].mutex, NULL) != 0)
-			goto error;
-		/* We always use EPOLLONESHOT because this test is currently
-		   structured to demonstrate the need for EPOLL_CTL_DISABLE,
-		   which only produces useful information in the EPOLLONESHOT
-		   case (without EPOLLONESHOT, calling epoll_ctl with
-		   EPOLL_CTL_DISABLE will never return EBUSY). If support for
-		   testing events without EPOLLONESHOT is desired, it should
-		   probably be implemented in a separate unit test. */
-		epoll_items[index].events = EPOLLIN | EPOLLONESHOT;
-		if (index < n_epoll_items / 2)
-			epoll_items[index].events |= EPOLLET;
-		epoll_items[index].stop = 0;
-		epoll_items[index].status = 0;
-		epoll_items[index].deleted = 0;
-		event_data.events = epoll_items[index].events;
-		event_data.data.ptr = &epoll_items[index];
-		if (epoll_ctl(epoll_set,
-			      EPOLL_CTL_ADD,
-			      epoll_items[index].fd,
-			      &event_data) < 0)
-			goto error;
-	}
-
-	/* Create and start the read threads: */
-	for (index = 0; index < n_read_threads; ++index) {
-		read_thread_data[index].stop = 0;
-		read_thread_data[index].status = 0;
-		read_thread_data[index].epoll_set = epoll_set;
-		if (pthread_create(&read_threads[index],
-				   NULL,
-				   read_thread_function,
-				   &read_thread_data[index]) != 0)
-			goto error;
-	}
-
-	if (pthread_create(&write_thread,
-			   NULL,
-			   write_thread_function,
-			   &write_thread_data) != 0)
-		goto error;
-
-	/* Cancel all event pollers: */
-#ifdef EPOLL_CTL_DISABLE
-	for (index = 0; index < n_epoll_items; ++index) {
-		pthread_mutex_lock(&epoll_items[index].mutex);
-		++epoll_items[index].stop;
-		if (epoll_ctl(epoll_set,
-			      EPOLL_CTL_DISABLE,
-			      epoll_items[index].fd,
-			      NULL) == 0)
-			delete_item(index);
-		else if (errno != EBUSY) {
-			pthread_mutex_unlock(&epoll_items[index].mutex);
-			goto error;
-		}
-		/* EBUSY means events were being handled; allow the other thread
-		   to delete the item. */
-		pthread_mutex_unlock(&epoll_items[index].mutex);
-	}
-#else
-	for (index = 0; index < n_epoll_items; ++index) {
-		pthread_mutex_lock(&epoll_items[index].mutex);
-		++epoll_items[index].stop;
-		pthread_mutex_unlock(&epoll_items[index].mutex);
-		/* Wait in case a thread running read_thread_function is
-		   currently executing code between epoll_wait and
-		   pthread_mutex_lock with this item. Note that a longer delay
-		   would make double-deletion less likely (at the expense of
-		   performance), but there is no guarantee that any delay would
-		   ever be sufficient. Note also that we delete all event
-		   pollers at once for testing purposes, but in a real-world
-		   environment we are likely to want to be able to cancel event
-		   pollers at arbitrary times. Therefore we can't improve this
-		   situation by just splitting this loop into two loops
-		   (i.e. signal 'stop' for all items, sleep, and then delete all
-		   items). We also can't fix the problem via EPOLL_CTL_DEL
-		   because that command can't prevent the case where some other
-		   thread is executing read_thread_function within the region
-		   mentioned above: */
-		usleep(1);
-		pthread_mutex_lock(&epoll_items[index].mutex);
-		if (!epoll_items[index].deleted)
-			delete_item(index);
-		pthread_mutex_unlock(&epoll_items[index].mutex);
-	}
-#endif
-
-	/* Shut down the read threads: */
-	for (index = 0; index < n_read_threads; ++index)
-		__sync_fetch_and_add(&read_thread_data[index].stop, 1);
-	for (index = 0; index < n_read_threads; ++index) {
-		if (pthread_join(read_threads[index], NULL) != 0)
-			goto error;
-		if (read_thread_data[index].status)
-			goto error;
-	}
-
-	/* Shut down the write thread: */
-	__sync_fetch_and_add(&write_thread_data.stop, 1);
-	if ((pthread_join(write_thread, NULL) != 0) || write_thread_data.status)
-		goto error;
-
-	/* Check for final error conditions: */
-	for (index = 0; index < n_epoll_items; ++index) {
-		if (epoll_items[index].status != 0)
-			goto error;
-		if (pthread_mutex_destroy(&epoll_items[index].mutex) < 0)
-			goto error;
-	}
-	for (index = 0; index < n_epoll_items; ++index)
-		if (epoll_items[index].deleted != 1) {
-			printf("Error: item data deleted %1d times.\n",
-				   epoll_items[index].deleted);
-			goto error;
-		}
-
-	printf("[PASS]\n");
-	return 0;
-
- error:
-	printf("[FAIL]\n");
-	return errno;
-}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be70035..c712fe5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2062,6 +2062,13 @@ out_free2:
 		r = 0;
 		break;
 	}
+	case KVM_SET_ENTITLEMENT: {
+		r = kvm_arch_vcpu_ioctl_set_entitlement(vcpu, arg);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}

