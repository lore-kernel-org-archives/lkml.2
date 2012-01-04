Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2ADKAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 05:00:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41781 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2ADKAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 05:00:45 -0500
Date: Wed, 4 Jan 2012 10:00:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: Status of arm-soc.git for 3.2
Message-ID: <20120104100016.GK2914@n2100.arm.linux.org.uk>
References: <201201032243.06440.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201032243.06440.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 10:43:06PM +0000, Arnd Bergmann wrote:
> The merge window is almost there, so it's time to look at what we've queued
> up in the arm-soc tree. There is a total of 55 branches with 386 non-merge
> changesets on top of mainline and the dependencies (linux-arm, v4l and
> dmaengine). The total diffstat is:
> 
>  676 files changed, 19694 insertions(+), 12633 deletions(-)

Well, my tree looks like this:
  937 files changed, 8150 insertions(+), 10774 deletions(-)

> I would like to stop adding non-bugfix patches into the branches above now
> for 3.2, and instead merge everything that I receive from now on into
> late/* branches, so we don't destabilize the patches that are already there
> and so I can feel more comfortable about sending everything in the next/*
> branches upstream ASAP.

I think that's a must - for both our trees.  We have quite a number of
conflicts in linux-next between our trees and other trees - some of them
due to duplicated commits being applied.

I'm feeling less than confident about my tree for this upcoming merge
window than I've ever felt before - I think we're in for quite a bit
of stick, possibly from Linus, over the about of silly conflicts and
duplicates which we have with other trees.

It's proven to be _impossible_ to sanely do an architecture wide change
to the way the restart stuff is handled - because SoC maintainers have
taken to adding their own individual patches for it to their git trees.
What I had hoped was to get that all sorted by the end of November, and
publish the whole thing as a stable branch, but that was utterly thwarted
by non-responsive maintainers - for example, some of this stuff only
getting finally fixed _yesterday_.

To some extent, it still is being thwarted by non-responsive maintainers:
the "Temporary #error" commit is still there.  I'm in two minds about
whether to push that up to Linus or not - they've had sufficient warning
both on this mailing list, by personal email, and a #error being in
linux-next making their platform(s) unbuildable for about a month.

Therefore, I have no issues what so ever breaking the three platforms
(gemini, shmobile, vt8500) which remain unconverted at the next merge
window, and I don't care what they say about that happening.  (If they
cared, they should respond to email.)

However, one thing that really concerns me is that we're going to have
to go through all this again over the next three months, because of the
arch_idle changes which Nicolas has.  I am not looking forward to that.

So, consider the below to be it for the next merge window (unless we
end up with -rc8 instead of -final.)

Now... as for ZenIV (the machine which publically hosts my git tree).  It's
developed a new problem over Christmas: apache has started regularly dying
in a way that's not been seen before:
[alert] (11)Resource temporarily unavailable: setuid: unable to change to uid: xx
[error] server reached MaxClients setting, consider raising the MaxClients setting
[alert] Child 17666 returned a Fatal error... Apache is exiting!
[emerg] (43)Identifier removed: couldn't grab the accept mutex
[emerg] (22)Invalid argument: couldn't grab the accept mutex
...
I don't see any updates which would have caused this, so I'm going to put
it down to increased server load over the Christmas period, possibly again
caused by git's smart protocol being excessively resource intensive on the
machine.

Now... I'm not sure what that will mean as far as getting stuff merged
into mainline: I'm fully expecting that I might have to miss this merge
window as a result of this instability.  (And no, I didn't get around
to upgrading stuff over Christmas so I can run a version of gnupg which
will generate the correct sign+encrypt DSA keys necessary for
kernel.org...)  So the tree remains stuck on ZenIV for the time being.

Axel Lin (2):
      ARM: exynos4: Fix build error due to 'gic_bank_offset' undeclared
      ARM: exynos4: Fix build error

Catalin Marinas (12):
      ARM: pgtable: Fix compiler warning in ioremap.c introduced by nopud
      ARM: LPAE: Move page table maintenance macros to pgtable-2level.h
      ARM: LPAE: Move the FSR definitions to separate files
      ARM: LPAE: Factor out classic-MMU specific code into proc-v7-2level.S
      ARM: LPAE: Introduce the 3-level page table format definitions
      ARM: LPAE: Page table maintenance for the 3-level format
      ARM: LPAE: MMU setup for the 3-level page table format
      ARM: LPAE: Invalidate the TLB before freeing the PMD
      ARM: LPAE: Add fault handling support
      ARM: LPAE: Add context switching support
      ARM: LPAE: Add identity mapping support for the 3-level page table format
      ARM: LPAE: Add the Kconfig entries

Dave Martin (22):
      ARM: amba: Move definition of struct amba_id to mod_devicetable.h
      ARM: amba: Auto-generate AMBA driver module aliases during modpost
      hwrng: nomadik: Enable module alias autogeneration for AMBA drivers
      dmaengine: pl08x: Enable module alias autogeneration for AMBA drivers
      dmaengine: pl330: Enable module alias autogeneration for AMBA drivers
      gpio: pl061: Enable module alias autogeneration for AMBA drivers
      input: ambakmi: Enable module alias autogeneration for AMBA drivers
      mmc: mmci: Enable module alias autogeneration for AMBA drivers
      rtc: pl030: Enable module alias autogeneration for AMBA drivers
      rtc: pl031: Enable module alias autogeneration for AMBA drivers
      spi: pl022: Enable module alias autogeneration for AMBA drivers
      serial: pl010: Enable module alias autogeneration for AMBA drivers
      serial: pl011: Enable module alias autogeneration for AMBA drivers
      fbdev: amba: Enable module alias autogeneration for AMBA drivers
      watchdog: sp805: Enable module alias autogeneration for AMBA drivers
      sound: aaci: Enable module alias autogeneration for AMBA drivers
      ARM: 7173/1: Add optimised swahb32() byteswap helper for v6 and above
      ARM: l2x0/pl310: Refactor Kconfig to be more maintainable
      ARM: SMP: Refactor Kconfig to be more maintainable
      omap4: Unconditionally require l2x0 L2 cache controller support
      highbank: Unconditionally require l2x0 L2 cache controller support
      imx6q: Remove unconditional dependency on l2x0 L2 cache support

Hans J. Koch (4):
      Remove Telechips ARM subarch from MAINTAINERS
      arm: Remove TCC subarch from Kconfig/Makefile
      arm: Remove mach-tcc8k directory
      arm: Remove plat-tcc directory

Heiko Stuebner (1):
      ARM: 7254/1: restart: S3C24XX: move SWRST based S3C platforms to

Jamie Iles (15):
      ARM: vic: device tree binding
      ARM: vic: MULTI_IRQ_HANDLER handler
      ARM: ep93xx: convert to MULTI_IRQ_HANDLER
      ARM: netx: convert to MULTI_IRQ_HANDLER
      ARM: nomadik: convert to MULTI_IRQ_HANDLER
      ARM: s3c64xx: convert to MULTI_IRQ_HANDLER
      ARM: spear: convert to MULTI_IRQ_HANDLER
      ARM: u300: convert to MULTI_IRQ_HANDLER
      ARM: versatile: convert to MULTI_IRQ_HANDLER
      ARM: samsung: convert to MULTI_IRQ_HANDLER
      ARM: picoxcell: convert to MULTI_IRQ_HANDLER
      ARM: VIC: remove non MULTI_IRQ_HANDLER support
      ARM: 7183/1: vic: register the VIC for ST-modified VIC's
      ARM: 7235/1: irqdomain: export irq_domain_simple_ops for !CONFIG_OF
      ARM: 7236/1: vic: always use simple ops

Janusz Krzysztofik (1):
      ARM: 7184/1: fix $(CROSS_COMPILE) prefix missing from size invocation

Javi Merino (1):
      ARM: 7242/1: PL330: Detach the request from the pl330_thread when it finishes successful

Jon Medhurst (Tixy) (1):
      ARM: 7193/1: Fix machine_is_xxx() naming for eSata SheevaPlug and QNAP TS-209

Kautuk Consul (1):
      ARM: 7178/1: fault.c: Port OOM changes into do_page_fault

Kevin Hilman (1):
      ARM: 7140/1: remove NR_IRQS dependency for ARM-specific HARDIRQ_BITS definition

Kukjin Kim (9):
      ARM: 7245/1: S3C64XX: introduce arch/arm/mach-s3c64xx/common.[ch]
      ARM: 7246/1: S5P64X0: introduce arch/arm/mach-s5p64x0/common.[ch]
      ARM: 7247/1: S5PC100: introduce arch/arm/mach-s5pc100/common.[ch]
      ARM: 7248/1: S5PV210: introduce arch/arm/mach-s5pv210/common.[ch]
      ARM: 7257/1: EXYNOS: introduce arch/arm/mach-exynos/common.[ch]
      ARM: 7265/1: restart: S3C24XX: use new restart hook
      ARM: 7266/1: restart: S3C64XX: use new restart hook
      ARM: 7250/1: restart: S5P64X0: use new restart hook
      ARM: 7251/1: restart: S5PC100: use new restart hook

Leif Lindholm (4):
      ARM: 7206/1: Add generic ARM instruction set condition code checks.
      ARM: 7207/1: Use generic ARM instruction set condition code checks for nwfpe.
      ARM: 7208/1: Add condition code checking to SWP emulation handler.
      ARM: 7209/1: Use generic ARM instruction set condition code checks for kprobes.

Linus Walleij (11):
      ARM: 7179/1: nomadik: localize cpu-8815 header
      ARM: 7199/2: only look for TCM on ARMv5 and later
      ARM: 7200/1: activate TCM on the Integrator
      ARM: 7233/1: ux500: remove overlapping iotable entries
      ARM: 7210/1: smp_twd: modernize clock event registration
      ARM: 7211/1: smp_twd: get the rate from a clock
      ARM: 7212/1: smp_twd: reconfigure clockevents after cpufreq change
      ARM: 7243/1: sp804: modernize clock event registration
      ARM: 7238/1: integrator: only hardcode AP PrimeCell IDs
      ARM: 7239/1: integrator: explicitly select the serial drivers
      ARM: 7261/1: clocksource/ux500-prcmu: fix sched_clock breakage

Magnus Damm (1):
      ARM: mach-shmobile: use standard 2MiB coherent DMA memory size

Marc Zyngier (20):
      ARM: gic: allow GIC to support non-banked setups
      ARM: Make global handler and CONFIG_MULTI_IRQ_HANDLER mutually exclusive
      ARM: mxc: rename gic_handle_irq to avoid name clash
      ARM: GIC: Add global gic_handle_irq() function
      ARM: imx: convert smp platforms to global gic_handle_irq()
      ARM: highbank: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: RealView: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: VExpress: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: msm: convert SMP platforms to CONFIG_MULTI_IRQ_HANDLER
      ARM: exynos4: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: tegra2: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: ux500: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: shmobile: convert smp platforms to gic_handle_irq()
      ARM: cns3xxx: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: zynq: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: omap2/3: Add global omap2/3_intc_handle_irq() functions
      ARM: omap2plus: convert to CONFIG_MULTI_IRQ_HANDLER
      ARM: omap2plus: remove irq-related global base addresses
      ARM: GIC: Make MULTI_IRQ_HANDLER mandatory
      ARM: 7205/2: sched_clock: allow sched_clock to be selected at runtime

Ming Lei (2):
      arm: introduce cross trigger interface helpers
      arm: pmu: allow platform specific irq enable/disable handling

Nicolas Pitre (21):
      ARM: mach-dove: remove inclusion of <mach/vmalloc.h>
      ARM: mach-prima2: don't define SIRFSOC_VA in terms of VMALLOC_END
      ARM: plat-mxc: remove inclusion of <mach/vmalloc.h>
      ARM: mach-at91: remove arch specific special handling for ioremap
      ARM: mach-davinci: remove arch specific special handling for ioremap
      ARM: mach-tegra: remove arch specific special handling for ioremap
      ARM: plat-omap: remove arch specific special handling for ioremap
      ARM: mach-bcmring: use proper constant to identify DMA memory area
      ARM: mach-orion5x: remove arch specific special handling for ioremap
      ARM: mach-kirkwood: remove arch specific special handling for ioremap
      ARM: mach-ixp23xx: remove arch specific special handling for ioremap
      ARM: plat-iop: remove arch specific special handling for ioremap
      ARM: sort the meminfo array earlier
      ARM: move initialization of the high_memory variable earlier
      mm: add vm_area_add_early()
      ARM: move iotable mappings within the vmalloc region
      ARM: simplify __iounmap() when dealing with section based mapping
      ARM: add generic ioremap optimization by reusing static mappings
      ARM: big removal of now unused vmalloc.h files
      ARM: move VMALLOC_END down temporarily for shmobile
      Revert "ARM: move VMALLOC_END down temporarily for shmobile"

Pawel Moll (1):
      ARM: 7202/1: Add Cortex-A7 proc info

Peter De Schrijver (NVIDIA) (3):
      ARM: 7240/1: Make ARCH_NR_GPIO a Kconfig variable
      ARM: 7244/1: mach-shmobile: Use CONFIG_ARCH_NR_GPIO
      ARM: 7241/1: mach-ux500 Use CONFIG_ARCH_NR_GPIO

Rob Herring (5):
      ARM: versatile: remove overlapping map_desc entry
      ARM: realview: fix map_desc alignment
      ARM: realview-eb11mp: fix map_desc alignment
      ARM: 7169/1: topdown mmap support
      ARM: 7201/1: add EDAC atomic_scrub function

Russell King (75):
      ARM: restart: add restart hook to machine_desc record
      ARM: restart: allow platforms more flexibility specifying restart mode
      ARM: restart: add default restart modes for PXA mioa701, spitz and tosa
      ARM: restart: move reboot failure handing into machine_restart()
      ARM: restart: remove argument to setup_mm_for_reboot()
      ARM: restart: remove local_irq_disable() from within arch_reset()
      ARM: clps711x: consolidate irq/mm/time code into a single file
      ARM: restart: only perform setup for restart when soft-restarting
      ARM: w90x900: add common nuc9xx.h
      ARM: restart: remove poodle restart handler
      Merge branch 'restart-cleanup' into restart
      Merge branch 'irqchip-consolidation' of git://git.kernel.org/.../maz/arm-platforms into devel-stable
      Merge branch 'irqchip-consolidation' of git://git.kernel.org/.../maz/arm-platforms into devel-stable
      Merge branch 'for-rmk' of git://git.kernel.org/.../will/linux into devel-stable
      Merge branch 'vmalloc' of git://git.linaro.org/people/nico/linux into devel-stable
      Merge branch 'kexec/idmap' of git://git.kernel.org/.../will/linux into devel-stable
      ARM: pgtable: switch to use pgtable-nopud.h
      Merge branch 'for-rmk' of git://git.kernel.org/.../cmarinas/linux into devel-stable
      ARM: Allow Kconfig to control the definition of NR_BANKS
      Merge branch 'arm/common-kconfig-refactor+for-rmk' of git://git.linaro.org/people/dmart/linux-2.6-arm into devel-stable
      ARM: Update mach-types
      Merge branches 'amba-modalias', 'fixes' and 'misc' into for-next
      Merge branch 'for-russell' of git://hansjkoch.de/git/linux-tcc into restart-cleanup
      Merge branch 'restart-cleanup' into HEAD
      ARM: restart: remove s3c24xx restart handler
      ARM: restart: at91: use new restart hook
      ARM: restart: bcmring: use new restart hook
      ARM: restart: clps711x: use new restart hook
      ARM: restart: cns3xxx: use new restart hook
      ARM: restart: dove: use new restart hook
      ARM: restart: ebsa110: use new restart hook
      ARM: restart: ep93xx: use new restart hook
      ARM: 7262/1: restart: EXYNOS: use new restart hook
      ARM: restart: footbridge: use new restart hook
      ARM: restart: h720x: use new restart hook
      ARM: restart: highbank: use new restart hook
      ARM: restart: integrator: use new restart hook
      ARM: restart: iop3xx: use new restart hook
      ARM: restart: iop13xx: use new restart hook
      ARM: restart: ixp2000: use new restart hook
      ARM: restart: ixp23xx: use new restart hook
      ARM: restart: ixp4xx: use new restart hook
      ARM: restart: kirkwood: use new restart hook
      ARM: restart: ks8695: use new restart hook
      ARM: restart: lpc32xx: use new restart hook
      ARM: restart: mmp: use new restart hook
      ARM: restart: mv78xx0: use new restart hook
      ARM: restart: mxc: use new restart hook
      ARM: restart: mxs: use new restart hook
      ARM: restart: netx: use new restart hook
      ARM: restart: nomadik: use new restart hook
      ARM: restart: omap: use new restart hook
      ARM: restart: orion5x: use new restart hook
      ARM: restart: pnx4008: use new restart hook
      ARM: restart: prima2: use new restart hook
      ARM: restart: pxa: use new restart hook
      ARM: restart: realview: use new restart hook
      ARM: restart: riscpc: use new restart hook
      ARM: 7252/1: restart: S5PV210: use new restart hook
      ARM: restart: sa1100: use new restart hook
      ARM: restart: shark: use new restart hook
      ARM: restart: spear: use new restart hook
      ARM: restart: tegra: use new restart hook
      ARM: restart: u300: use new restart hook
      ARM: restart: versatile: use new restart hook
      ARM: restart: Versatile Express: use new restart hook
      ARM: restart: w90x900: use new restart hook
      ARM: restart: plat-samsung: remove plat/reset.h and s5p_reset_hook
      ARM: restart: lpc32xx & u300: remove unnecessary printk
      ARM: restart: remove comments about adding code to arch_reset()
      ARM: restart: remove the now empty arch_reset()
      ARM: restart: Temporary #error to persuade platform maintainers to take the restart changes seriously
      Merge branch 'vmalloc' of git://git.linaro.org/people/nico/linux into devel-stable
      Merge branch 'devel-stable' into for-next
      Merge branch 'restart' into for-next

Santosh Shilimkar (2):
      ARM: 7188/1: OMAP2PLUS: Fix build error: 'omap2/omap3_intc_handle_irq' undeclared.
      ARM: 7189/1: OMAP3: Fix build break in cpuidle34xx.c because of irq function

Sekhar Nori (1):
      ARM: 7190/1: restart: davinci: use new restart hook

Shawn Guo (1):
      ARM: 7198/1: arm/imx6: add restart support for imx6q

Tony Lindgren (3):
      ARM: 7159/1: OMAP: Introduce local common.h files
      ARM: 7192/1: OMAP: Fix build error for omap1_defconfig
      ARM: 7194/1: OMAP: Fix build after a merge between v3.2-rc4 and ARM restart changes

Will Deacon (16):
      ARM: perf: clean and update ARMv7 event numbers
      ARM: perf: add support for stalled cycle ABI events
      ARM: perf: remove unused armpmu_get_max_events
      Merge branches 'perf/event-nos', 'perf/updates' and 'perf/omap4' into for-rmk
      ARM: idmap: populate identity map pgd at init time using .init.text
      ARM: suspend: use idmap_pgd instead of suspend_pgd
      ARM: proc-*.S: place cpu_reset functions into .idmap.text section
      ARM: idmap: use idmap_pgd when setting up mm for reboot
      ARM: head.S: only include __turn_mmu_on in the initial identity mapping
      ARM: SMP: use idmap_pgd for mapping MMU enable during secondary booting
      ARM: LPAE: add ISBs around MMU enabling code
      ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
      ARM: lib: add call_with_stack function for safely changing stack
      ARM: reset: implement soft_restart for jumping to a physical address
      ARM: stop: execute platform callback from cpu_stop code
      ARM: kexec: use soft_restart for branching to the reboot buffer

 Documentation/arm/memory.txt                       |   11 +-
 Documentation/devicetree/bindings/arm/gic.txt      |    4 +
 Documentation/devicetree/bindings/arm/vic.txt      |   29 +
 MAINTAINERS                                        |    7 -
 arch/arm/Kconfig                                   |   56 +-
 arch/arm/Makefile                                  |    2 -
 arch/arm/boot/compressed/Makefile                  |    3 +-
 arch/arm/boot/compressed/head.S                    |    1 +
 arch/arm/common/Kconfig                            |    6 +
 arch/arm/common/gic.c                              |  165 ++++-
 arch/arm/common/pl330.c                            |    8 +-
 arch/arm/common/timer-sp.c                         |    7 +-
 arch/arm/common/vic.c                              |  148 +++-
 arch/arm/include/asm/assembler.h                   |   11 +
 arch/arm/include/asm/cti.h                         |  179 +++++
 arch/arm/include/asm/edac.h                        |   48 ++
 arch/arm/include/asm/entry-macro-vic2.S            |   57 --
 arch/arm/include/asm/gpio.h                        |    4 +
 arch/arm/include/asm/hardirq.h                     |   17 -
 arch/arm/include/asm/hardware/entry-macro-gic.S    |   60 --
 arch/arm/include/asm/hardware/gic.h                |   26 +-
 arch/arm/include/asm/hardware/iop3xx.h             |    1 +
 arch/arm/include/asm/hardware/vic.h                |   10 +-
 arch/arm/include/asm/idmap.h                       |   14 +
 arch/arm/include/asm/mach/arch.h                   |    9 +-
 arch/arm/include/asm/opcodes.h                     |   20 +
 arch/arm/include/asm/page.h                        |    4 +
 arch/arm/include/asm/perf_event.h                  |    3 -
 arch/arm/include/asm/pgalloc.h                     |   26 +-
 arch/arm/include/asm/pgtable-2level.h              |   41 +
 arch/arm/include/asm/pgtable-3level-hwdef.h        |   77 ++
 arch/arm/include/asm/pgtable-3level-types.h        |   70 ++
 arch/arm/include/asm/pgtable-3level.h              |  155 ++++
 arch/arm/include/asm/pgtable-hwdef.h               |    4 +
 arch/arm/include/asm/pgtable.h                     |   55 +--
 arch/arm/include/asm/pmu.h                         |   15 +-
 arch/arm/include/asm/proc-fns.h                    |   21 +
 arch/arm/include/asm/processor.h                   |    2 +
 arch/arm/include/asm/sched_clock.h                 |  108 +---
 arch/arm/include/asm/setup.h                       |    6 +-
 arch/arm/include/asm/swab.h                        |    5 +-
 arch/arm/include/asm/system.h                      |   10 +-
 arch/arm/include/asm/tlb.h                         |   12 +-
 arch/arm/kernel/Makefile                           |    2 +-
 arch/arm/kernel/entry-armv.S                       |    7 +-
 arch/arm/kernel/head.S                             |   65 ++-
 arch/arm/kernel/hw_breakpoint.c                    |    8 +-
 arch/arm/kernel/kprobes-test.c                     |   66 +--
 arch/arm/kernel/machine_kexec.c                    |   15 +-
 arch/arm/kernel/opcodes.c                          |   72 ++
 arch/arm/kernel/perf_event.c                       |   19 +-
 arch/arm/kernel/perf_event_v6.c                    |   32 +-
 arch/arm/kernel/perf_event_v7.c                    |  401 ++++------
 arch/arm/kernel/perf_event_xscale.c                |   16 +-
 arch/arm/kernel/process.c                          |   77 ++-
 arch/arm/kernel/sched_clock.c                      |  118 +++-
 arch/arm/kernel/setup.c                            |   15 +-
 arch/arm/kernel/sleep.S                            |    4 +
 arch/arm/kernel/smp.c                              |   36 +-
 arch/arm/kernel/smp_twd.c                          |   95 +++-
 arch/arm/kernel/suspend.c                          |   18 +-
 arch/arm/kernel/swp_emulate.c                      |   16 +
 arch/arm/kernel/tcm.c                              |   22 +-
 arch/arm/kernel/vmlinux.lds.S                      |    7 +
 arch/arm/lib/Makefile                              |    3 +-
 arch/arm/lib/call_with_stack.S                     |   44 ++
 arch/arm/mach-at91/at91cap9.c                      |    4 +-
 arch/arm/mach-at91/at91rm9200.c                    |    4 +-
 arch/arm/mach-at91/at91sam9260.c                   |    2 +-
 arch/arm/mach-at91/at91sam9261.c                   |    2 +-
 arch/arm/mach-at91/at91sam9263.c                   |    2 +-
 arch/arm/mach-at91/at91sam9_alt_reset.S            |    9 +-
 arch/arm/mach-at91/at91sam9g45.c                   |    4 +-
 arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
 arch/arm/mach-at91/generic.h                       |    3 +-
 arch/arm/mach-at91/include/mach/io.h               |    8 -
 arch/arm/mach-at91/include/mach/system.h           |    9 -
 arch/arm/mach-at91/include/mach/vmalloc.h          |   28 -
 arch/arm/mach-at91/setup.c                         |   18 -
 arch/arm/mach-bcmring/arch.c                       |   25 +-
 arch/arm/mach-bcmring/dma.c                        |    2 +-
 arch/arm/mach-bcmring/include/mach/system.h        |   26 -
 arch/arm/mach-bcmring/include/mach/vmalloc.h       |   25 -
 arch/arm/mach-clps711x/Makefile                    |    2 +-
 arch/arm/mach-clps711x/autcpu12.c                  |    1 +
 arch/arm/mach-clps711x/cdb89712.c                  |    1 +
 arch/arm/mach-clps711x/ceiva.c                     |    1 +
 arch/arm/mach-clps711x/clep7312.c                  |    1 +
 arch/arm/mach-clps711x/{irq.c => common.c}         |  100 +++-
 arch/arm/mach-clps711x/edb7211-arch.c              |    1 +
 arch/arm/mach-clps711x/fortunet.c                  |    1 +
 arch/arm/mach-clps711x/include/mach/system.h       |    5 -
 arch/arm/mach-clps711x/include/mach/vmalloc.h      |   20 -
 arch/arm/mach-clps711x/mm.c                        |   48 --
 arch/arm/mach-clps711x/p720t.c                     |    1 +
 arch/arm/mach-clps711x/time.c                      |   84 --
 arch/arm/mach-cns3xxx/cns3420vb.c                  |    3 +
 arch/arm/mach-cns3xxx/core.h                       |    1 +
 arch/arm/mach-cns3xxx/include/mach/entry-macro.S   |    2 -
 arch/arm/mach-cns3xxx/include/mach/system.h        |    3 -
 arch/arm/mach-cns3xxx/include/mach/vmalloc.h       |   11 -
 arch/arm/mach-cns3xxx/pm.c                         |    4 +-
 arch/arm/mach-davinci/Makefile                     |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c            |    1 +
 arch/arm/mach-davinci/board-da850-evm.c            |    1 +
 arch/arm/mach-davinci/board-dm355-evm.c            |    1 +
 arch/arm/mach-davinci/board-dm355-leopard.c        |    1 +
 arch/arm/mach-davinci/board-dm365-evm.c            |    1 +
 arch/arm/mach-davinci/board-dm644x-evm.c           |    1 +
 arch/arm/mach-davinci/board-dm646x-evm.c           |    2 +
 arch/arm/mach-davinci/board-mityomapl138.c         |    1 +
 arch/arm/mach-davinci/board-neuros-osd2.c          |    1 +
 arch/arm/mach-davinci/board-omapl138-hawk.c        |    1 +
 arch/arm/mach-davinci/board-sffsdr.c               |    1 +
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |    1 +
 arch/arm/mach-davinci/common.c                     |    3 -
 arch/arm/mach-davinci/da830.c                      |    1 -
 arch/arm/mach-davinci/da850.c                      |    1 -
 arch/arm/mach-davinci/devices-da8xx.c              |    5 +
 arch/arm/mach-davinci/devices.c                    |    5 +
 arch/arm/mach-davinci/dm355.c                      |    1 -
 arch/arm/mach-davinci/dm365.c                      |    1 -
 arch/arm/mach-davinci/dm644x.c                     |    1 -
 arch/arm/mach-davinci/dm646x.c                     |    1 -
 arch/arm/mach-davinci/include/mach/common.h        |    3 +-
 arch/arm/mach-davinci/include/mach/da8xx.h         |    1 +
 arch/arm/mach-davinci/include/mach/io.h            |    8 -
 arch/arm/mach-davinci/include/mach/system.h        |    6 -
 arch/arm/mach-davinci/include/mach/tnetv107x.h     |    1 +
 arch/arm/mach-davinci/include/mach/vmalloc.h       |   14 -
 arch/arm/mach-davinci/io.c                         |   48 --
 arch/arm/mach-davinci/tnetv107x.c                  |    7 +-
 arch/arm/mach-dove/cm-a510.c                       |    1 +
 arch/arm/mach-dove/common.c                        |   16 +
 arch/arm/mach-dove/common.h                        |    1 +
 arch/arm/mach-dove/dove-db-setup.c                 |    1 +
 arch/arm/mach-dove/include/mach/dove.h             |    2 -
 arch/arm/mach-dove/include/mach/system.h           |   19 -
 arch/arm/mach-dove/include/mach/vmalloc.h          |    5 -
 arch/arm/mach-ebsa110/core.c                       |    8 +-
 arch/arm/mach-ebsa110/include/mach/system.h        |    2 -
 arch/arm/mach-ebsa110/include/mach/vmalloc.h       |   10 -
 arch/arm/mach-ep93xx/adssphere.c                   |    3 +
 arch/arm/mach-ep93xx/core.c                        |   12 +
 arch/arm/mach-ep93xx/edb93xx.c                     |   17 +
 arch/arm/mach-ep93xx/gesbc9312.c                   |    3 +
 arch/arm/mach-ep93xx/include/mach/entry-macro.S    |   42 -
 arch/arm/mach-ep93xx/include/mach/platform.h       |    2 +
 arch/arm/mach-ep93xx/include/mach/system.h         |   17 -
 arch/arm/mach-ep93xx/include/mach/vmalloc.h        |    5 -
 arch/arm/mach-ep93xx/micro9.c                      |    9 +
 arch/arm/mach-ep93xx/simone.c                      |    3 +
 arch/arm/mach-ep93xx/snappercl15.c                 |    3 +
 arch/arm/mach-ep93xx/ts72xx.c                      |    3 +
 arch/arm/mach-ep93xx/vision_ep9307.c               |    1 +
 arch/arm/mach-exynos/Kconfig                       |    2 +
 arch/arm/mach-exynos/Makefile                      |    9 +-
 arch/arm/mach-exynos/clock-exynos4210.c            |    3 +-
 arch/arm/mach-exynos/clock-exynos4212.c            |    3 +-
 arch/arm/mach-exynos/clock.c                       |    3 +-
 arch/arm/mach-exynos/common.c                      |  713 +++++++++++++++++
 arch/arm/mach-exynos/common.h                      |   41 +
 arch/arm/mach-exynos/cpu.c                         |  293 -------
 arch/arm/mach-exynos/include/mach/entry-macro.S    |   75 --
 arch/arm/mach-exynos/include/mach/map.h            |   12 +-
 arch/arm/mach-exynos/include/mach/system.h         |    2 -
 arch/arm/mach-exynos/include/mach/vmalloc.h        |   22 -
 arch/arm/mach-exynos/init.c                        |   42 -
 arch/arm/mach-exynos/irq-combiner.c                |  124 ---
 arch/arm/mach-exynos/irq-eint.c                    |  237 ------
 arch/arm/mach-exynos/mach-armlex4210.c             |    8 +-
 arch/arm/mach-exynos/mach-nuri.c                   |    8 +-
 arch/arm/mach-exynos/mach-origen.c                 |    8 +-
 arch/arm/mach-exynos/mach-smdk4x12.c               |   10 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |   10 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |    8 +-
 arch/arm/mach-exynos/platsmp.c                     |   28 +-
 arch/arm/mach-footbridge/cats-hw.c                 |    3 +-
 arch/arm/mach-footbridge/common.c                  |   27 +
 arch/arm/mach-footbridge/common.h                  |    1 +
 arch/arm/mach-footbridge/ebsa285.c                 |    1 +
 arch/arm/mach-footbridge/include/mach/system.h     |   56 --
 arch/arm/mach-footbridge/include/mach/vmalloc.h    |   10 -
 arch/arm/mach-footbridge/netwinder-hw.c            |   27 +
 arch/arm/mach-footbridge/personal.c                |    1 +
 arch/arm/mach-gemini/include/mach/system.h         |    1 +
 arch/arm/mach-gemini/include/mach/vmalloc.h        |   10 -
 arch/arm/mach-h720x/common.c                       |    5 +
 arch/arm/mach-h720x/common.h                       |    1 +
 arch/arm/mach-h720x/h7201-eval.c                   |    1 +
 arch/arm/mach-h720x/h7202-eval.c                   |    1 +
 arch/arm/mach-h720x/include/mach/system.h          |    6 -
 arch/arm/mach-h720x/include/mach/vmalloc.h         |   10 -
 arch/arm/mach-highbank/core.h                      |    1 +
 arch/arm/mach-highbank/highbank.c                  |    2 +
 arch/arm/mach-highbank/include/mach/entry-macro.S  |    2 -
 arch/arm/mach-highbank/include/mach/system.h       |    2 -
 arch/arm/mach-highbank/include/mach/vmalloc.h      |    1 -
 arch/arm/mach-highbank/system.c                    |    2 +-
 arch/arm/mach-imx/Kconfig                          |    2 +-
 arch/arm/mach-imx/clock-imx6q.c                    |    2 -
 arch/arm/mach-imx/mach-apf9328.c                   |    1 +
 arch/arm/mach-imx/mach-armadillo5x0.c              |    1 +
 arch/arm/mach-imx/mach-bug.c                       |    1 +
 arch/arm/mach-imx/mach-cpuimx27.c                  |    1 +
 arch/arm/mach-imx/mach-cpuimx35.c                  |    1 +
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |    1 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    1 +
 arch/arm/mach-imx/mach-imx27ipcam.c                |    1 +
 arch/arm/mach-imx/mach-imx27lite.c                 |    1 +
 arch/arm/mach-imx/mach-imx6q.c                     |   34 +
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    1 +
 arch/arm/mach-imx/mach-mx1ads.c                    |    2 +
 arch/arm/mach-imx/mach-mx21ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx25_3ds.c                  |    1 +
 arch/arm/mach-imx/mach-mx27_3ds.c                  |    1 +
 arch/arm/mach-imx/mach-mx27ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx31_3ds.c                  |    1 +
 arch/arm/mach-imx/mach-mx31ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx31lilly.c                 |    1 +
 arch/arm/mach-imx/mach-mx31lite.c                  |    1 +
 arch/arm/mach-imx/mach-mx31moboard.c               |    1 +
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    1 +
 arch/arm/mach-imx/mach-mxt_td60.c                  |    1 +
 arch/arm/mach-imx/mach-pca100.c                    |    1 +
 arch/arm/mach-imx/mach-pcm037.c                    |    1 +
 arch/arm/mach-imx/mach-pcm038.c                    |    1 +
 arch/arm/mach-imx/mach-pcm043.c                    |    1 +
 arch/arm/mach-imx/mach-qong.c                      |    1 +
 arch/arm/mach-imx/mach-scb9328.c                   |    1 +
 arch/arm/mach-imx/mach-vpr200.c                    |    1 +
 arch/arm/mach-imx/src.c                            |   23 +
 arch/arm/mach-integrator/Kconfig                   |    4 +
 arch/arm/mach-integrator/common.h                  |    1 +
 arch/arm/mach-integrator/core.c                    |   27 +-
 arch/arm/mach-integrator/include/mach/system.h     |   11 -
 arch/arm/mach-integrator/include/mach/vmalloc.h    |   20 -
 arch/arm/mach-integrator/integrator_ap.c           |    1 +
 arch/arm/mach-integrator/integrator_cp.c           |    1 +
 arch/arm/mach-iop13xx/include/mach/iop13xx.h       |    1 +
 arch/arm/mach-iop13xx/include/mach/system.h        |   14 -
 arch/arm/mach-iop13xx/include/mach/vmalloc.h       |    4 -
 arch/arm/mach-iop13xx/iq81340mc.c                  |    1 +
 arch/arm/mach-iop13xx/iq81340sc.c                  |    1 +
 arch/arm/mach-iop13xx/setup.c                      |   11 +
 arch/arm/mach-iop32x/em7210.c                      |    1 +
 arch/arm/mach-iop32x/glantank.c                    |    1 +
 arch/arm/mach-iop32x/include/mach/io.h             |    7 -
 arch/arm/mach-iop32x/include/mach/system.h         |   21 -
 arch/arm/mach-iop32x/include/mach/vmalloc.h        |    5 -
 arch/arm/mach-iop32x/iq31244.c                     |    2 +
 arch/arm/mach-iop32x/iq80321.c                     |    1 +
 arch/arm/mach-iop32x/n2100.c                       |    9 +
 arch/arm/mach-iop33x/include/mach/io.h             |    7 -
 arch/arm/mach-iop33x/include/mach/system.h         |   10 -
 arch/arm/mach-iop33x/include/mach/vmalloc.h        |    5 -
 arch/arm/mach-iop33x/iq80331.c                     |    1 +
 arch/arm/mach-iop33x/iq80332.c                     |    1 +
 arch/arm/mach-ixp2000/core.c                       |    4 +
 arch/arm/mach-ixp2000/enp2611.c                    |    1 +
 arch/arm/mach-ixp2000/include/mach/platform.h      |    1 +
 arch/arm/mach-ixp2000/include/mach/system.h        |   35 -
 arch/arm/mach-ixp2000/include/mach/vmalloc.h       |   20 -
 arch/arm/mach-ixp2000/ixdp2400.c                   |    1 +
 arch/arm/mach-ixp2000/ixdp2800.c                   |    1 +
 arch/arm/mach-ixp2000/ixdp2x01.c                   |   32 +
 arch/arm/mach-ixp23xx/core.c                       |    6 +
 arch/arm/mach-ixp23xx/espresso.c                   |    1 +
 arch/arm/mach-ixp23xx/include/mach/io.h            |   29 -
 arch/arm/mach-ixp23xx/include/mach/platform.h      |    1 +
 arch/arm/mach-ixp23xx/include/mach/system.h        |   17 -
 arch/arm/mach-ixp23xx/include/mach/vmalloc.h       |   10 -
 arch/arm/mach-ixp23xx/ixdp2351.c                   |   12 +
 arch/arm/mach-ixp23xx/roadrunner.c                 |    1 +
 arch/arm/mach-ixp4xx/avila-setup.c                 |    2 +
 arch/arm/mach-ixp4xx/common.c                      |   36 +-
 arch/arm/mach-ixp4xx/coyote-setup.c                |    2 +
 arch/arm/mach-ixp4xx/dsmg600-setup.c               |    1 +
 arch/arm/mach-ixp4xx/fsg-setup.c                   |    1 +
 arch/arm/mach-ixp4xx/gateway7001-setup.c           |    1 +
 arch/arm/mach-ixp4xx/goramo_mlr.c                  |    1 +
 arch/arm/mach-ixp4xx/gtwx5715-setup.c              |    1 +
 arch/arm/mach-ixp4xx/include/mach/platform.h       |    1 +
 arch/arm/mach-ixp4xx/include/mach/system.h         |   25 -
 arch/arm/mach-ixp4xx/include/mach/vmalloc.h        |    5 -
 arch/arm/mach-ixp4xx/ixdp425-setup.c               |    1 +
 arch/arm/mach-ixp4xx/nas100d-setup.c               |    1 +
 arch/arm/mach-ixp4xx/nslu2-setup.c                 |    1 +
 arch/arm/mach-ixp4xx/omixp-setup.c                 |    3 +
 arch/arm/mach-ixp4xx/vulcan-setup.c                |    1 +
 arch/arm/mach-ixp4xx/wg302v2-setup.c               |    1 +
 arch/arm/mach-kirkwood/common.c                    |   16 +
 arch/arm/mach-kirkwood/common.h                    |    1 +
 arch/arm/mach-kirkwood/d2net_v2-setup.c            |    1 +
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c        |    1 +
 arch/arm/mach-kirkwood/dockstar-setup.c            |    1 +
 arch/arm/mach-kirkwood/guruplug-setup.c            |    1 +
 arch/arm/mach-kirkwood/include/mach/io.h           |   25 -
 arch/arm/mach-kirkwood/include/mach/system.h       |   19 -
 arch/arm/mach-kirkwood/include/mach/vmalloc.h      |    5 -
 arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c     |    1 +
 arch/arm/mach-kirkwood/netspace_v2-setup.c         |    3 +
 arch/arm/mach-kirkwood/netxbig_v2-setup.c          |    2 +
 arch/arm/mach-kirkwood/openrd-setup.c              |    3 +
 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c       |    1 +
 arch/arm/mach-kirkwood/rd88f6281-setup.c           |    1 +
 arch/arm/mach-kirkwood/sheevaplug-setup.c          |    8 +-
 arch/arm/mach-kirkwood/t5325-setup.c               |    1 +
 arch/arm/mach-kirkwood/ts219-setup.c               |    1 +
 arch/arm/mach-kirkwood/ts41x-setup.c               |    1 +
 arch/arm/mach-ks8695/board-acs5k.c                 |    1 +
 arch/arm/mach-ks8695/board-dsm320.c                |    1 +
 arch/arm/mach-ks8695/board-micrel.c                |    1 +
 arch/arm/mach-ks8695/generic.h                     |    1 +
 arch/arm/mach-ks8695/include/mach/system.h         |   21 -
 arch/arm/mach-ks8695/include/mach/vmalloc.h        |   19 -
 arch/arm/mach-ks8695/time.c                        |   18 +
 arch/arm/mach-lpc32xx/common.c                     |   20 +-
 arch/arm/mach-lpc32xx/common.h                     |    2 +
 arch/arm/mach-lpc32xx/include/mach/system.h        |   25 -
 arch/arm/mach-lpc32xx/include/mach/vmalloc.h       |   24 -
 arch/arm/mach-lpc32xx/phy3250.c                    |    1 +
 arch/arm/mach-mmp/aspenite.c                       |    2 +
 arch/arm/mach-mmp/avengers_lite.c                  |    1 +
 arch/arm/mach-mmp/brownstone.c                     |    1 +
 arch/arm/mach-mmp/common.c                         |    5 +
 arch/arm/mach-mmp/common.h                         |    1 +
 arch/arm/mach-mmp/flint.c                          |    1 +
 arch/arm/mach-mmp/gplugd.c                         |    1 +
 arch/arm/mach-mmp/include/mach/pxa168.h            |    1 +
 arch/arm/mach-mmp/include/mach/system.h            |   10 -
 arch/arm/mach-mmp/include/mach/vmalloc.h           |    5 -
 arch/arm/mach-mmp/jasper.c                         |    1 +
 arch/arm/mach-mmp/pxa168.c                         |    5 +
 arch/arm/mach-mmp/tavorevb.c                       |    1 +
 arch/arm/mach-mmp/teton_bga.c                      |    1 +
 arch/arm/mach-mmp/time.c                           |   16 +-
 arch/arm/mach-mmp/ttc_dkb.c                        |    1 +
 arch/arm/mach-msm/Kconfig                          |    1 +
 arch/arm/mach-msm/board-msm8960.c                  |    2 +
 arch/arm/mach-msm/board-msm8x60.c                  |    4 +
 arch/arm/mach-msm/include/mach/entry-macro-qgic.S  |   17 -
 arch/arm/mach-msm/include/mach/entry-macro-vic.S   |   37 -
 arch/arm/mach-msm/include/mach/entry-macro.S       |   27 +-
 arch/arm/mach-msm/include/mach/system.h            |    8 -
 arch/arm/mach-msm/include/mach/vmalloc.h           |   22 -
 arch/arm/mach-mv78xx0/buffalo-wxl-setup.c          |    1 +
 arch/arm/mach-mv78xx0/common.c                     |   16 +
 arch/arm/mach-mv78xx0/common.h                     |    1 +
 arch/arm/mach-mv78xx0/db78x00-bp-setup.c           |    1 +
 arch/arm/mach-mv78xx0/include/mach/system.h        |   19 -
 arch/arm/mach-mv78xx0/include/mach/vmalloc.h       |    5 -
 arch/arm/mach-mv78xx0/rd78x00-masa-setup.c         |    1 +
 arch/arm/mach-mx5/board-cpuimx51.c                 |    1 +
 arch/arm/mach-mx5/board-cpuimx51sd.c               |    1 +
 arch/arm/mach-mx5/board-mx50_rdp.c                 |    1 +
 arch/arm/mach-mx5/board-mx51_3ds.c                 |    1 +
 arch/arm/mach-mx5/board-mx51_babbage.c             |    1 +
 arch/arm/mach-mx5/board-mx51_efikamx.c             |    3 +-
 arch/arm/mach-mx5/board-mx51_efikasb.c             |    1 +
 arch/arm/mach-mx5/board-mx53_ard.c                 |    1 +
 arch/arm/mach-mx5/board-mx53_evk.c                 |    1 +
 arch/arm/mach-mx5/board-mx53_loco.c                |    1 +
 arch/arm/mach-mx5/board-mx53_smd.c                 |    1 +
 arch/arm/mach-mx5/imx51-dt.c                       |    1 +
 arch/arm/mach-mx5/imx53-dt.c                       |    1 +
 arch/arm/mach-mxs/include/mach/common.h            |    1 +
 arch/arm/mach-mxs/include/mach/system.h            |    2 -
 arch/arm/mach-mxs/include/mach/vmalloc.h           |   22 -
 arch/arm/mach-mxs/mach-m28evk.c                    |    1 +
 arch/arm/mach-mxs/mach-mx23evk.c                   |    1 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |    1 +
 arch/arm/mach-mxs/mach-stmp378x_devb.c             |    1 +
 arch/arm/mach-mxs/mach-tx28.c                      |    1 +
 arch/arm/mach-mxs/system.c                         |    4 +-
 arch/arm/mach-netx/generic.c                       |    5 +
 arch/arm/mach-netx/generic.h                       |    1 +
 arch/arm/mach-netx/include/mach/entry-macro.S      |   13 -
 arch/arm/mach-netx/include/mach/system.h           |   10 -
 arch/arm/mach-netx/include/mach/vmalloc.h          |   19 -
 arch/arm/mach-netx/nxdb500.c                       |    3 +
 arch/arm/mach-netx/nxdkn.c                         |    3 +
 arch/arm/mach-netx/nxeb500hmi.c                    |    3 +
 arch/arm/mach-nomadik/board-nhk8815.c              |    5 +
 arch/arm/mach-nomadik/cpu-8815.c                   |   12 +
 arch/arm/mach-nomadik/cpu-8815.h                   |    4 +
 arch/arm/mach-nomadik/include/mach/entry-macro.S   |   30 -
 arch/arm/mach-nomadik/include/mach/setup.h         |    3 -
 arch/arm/mach-nomadik/include/mach/system.h        |   13 -
 arch/arm/mach-nomadik/include/mach/vmalloc.h       |    2 -
 arch/arm/mach-omap1/board-ams-delta.c              |    3 +-
 arch/arm/mach-omap1/board-fsample.c                |    3 +-
 arch/arm/mach-omap1/board-generic.c                |    3 +-
 arch/arm/mach-omap1/board-h2.c                     |    3 +-
 arch/arm/mach-omap1/board-h3.c                     |    3 +-
 arch/arm/mach-omap1/board-htcherald.c              |    3 +-
 arch/arm/mach-omap1/board-innovator.c              |    3 +-
 arch/arm/mach-omap1/board-nokia770.c               |    3 +-
 arch/arm/mach-omap1/board-osk.c                    |    3 +-
 arch/arm/mach-omap1/board-palmte.c                 |    3 +-
 arch/arm/mach-omap1/board-palmtt.c                 |    3 +-
 arch/arm/mach-omap1/board-palmz71.c                |    3 +-
 arch/arm/mach-omap1/board-perseus2.c               |    3 +-
 arch/arm/mach-omap1/board-sx1.c                    |    3 +-
 arch/arm/mach-omap1/board-voiceblue.c              |    8 +-
 arch/arm/mach-omap1/common.h                       |   62 ++
 arch/arm/mach-omap1/devices.c                      |    2 +-
 arch/arm/mach-omap1/include/mach/vmalloc.h         |   20 -
 arch/arm/mach-omap1/io.c                           |    1 -
 arch/arm/mach-omap1/reset.c                        |    5 +-
 arch/arm/mach-omap1/time.c                         |   60 +--
 arch/arm/mach-omap1/timer32k.c                     |    2 +-
 arch/arm/mach-omap2/Kconfig                        |    4 +
 arch/arm/mach-omap2/board-2430sdp.c                |    4 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    4 +-
 arch/arm/mach-omap2/board-3630sdp.c                |    4 +-
 arch/arm/mach-omap2/board-4430sdp.c                |    6 +-
 arch/arm/mach-omap2/board-am3517crane.c            |    4 +-
 arch/arm/mach-omap2/board-am3517evm.c              |    4 +-
 arch/arm/mach-omap2/board-apollon.c                |    4 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    6 +-
 arch/arm/mach-omap2/board-cm-t3517.c               |    4 +-
 arch/arm/mach-omap2/board-devkit8000.c             |    4 +-
 arch/arm/mach-omap2/board-generic.c                |    8 +-
 arch/arm/mach-omap2/board-h4.c                     |    4 +-
 arch/arm/mach-omap2/board-igep0020.c               |    6 +-
 arch/arm/mach-omap2/board-ldp.c                    |    4 +-
 arch/arm/mach-omap2/board-n8x0.c                   |    8 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    4 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    4 +-
 arch/arm/mach-omap2/board-omap3logic.c             |    6 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    4 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |    4 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |    4 +-
 arch/arm/mach-omap2/board-omap4panda.c             |    6 +-
 arch/arm/mach-omap2/board-overo.c                  |    4 +-
 arch/arm/mach-omap2/board-rm680.c                  |    4 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    2 +-
 arch/arm/mach-omap2/board-rx51.c                   |    4 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |    3 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |    2 +-
 arch/arm/mach-omap2/board-zoom.c                   |    6 +-
 arch/arm/mach-omap2/cm2xxx_3xxx.c                  |    2 +-
 arch/arm/mach-omap2/cm44xx.c                       |    2 +-
 arch/arm/mach-omap2/cminst44xx.c                   |    2 +-
 arch/arm/mach-omap2/common.c                       |    2 +-
 .../include/plat => mach-omap2}/common.h           |  109 +++-
 arch/arm/mach-omap2/control.c                      |    2 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |    1 +
 arch/arm/mach-omap2/display.c                      |    3 +-
 arch/arm/mach-omap2/i2c.c                          |    2 +-
 arch/arm/mach-omap2/id.c                           |    2 +-
 arch/arm/mach-omap2/include/mach/entry-macro.S     |  137 ----
 arch/arm/mach-omap2/include/mach/omap4-common.h    |   43 -
 arch/arm/mach-omap2/include/mach/vmalloc.h         |   20 -
 arch/arm/mach-omap2/io.c                           |    8 +-
 arch/arm/mach-omap2/irq.c                          |   51 ++
 arch/arm/mach-omap2/omap-hotplug.c                 |    3 +-
 arch/arm/mach-omap2/omap-smp.c                     |    3 +-
 arch/arm/mach-omap2/omap4-common.c                 |    9 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |    2 +-
 arch/arm/mach-omap2/pm.c                           |    2 +-
 arch/arm/mach-omap2/pm24xx.c                       |    1 +
 arch/arm/mach-omap2/pm34xx.c                       |    1 +
 arch/arm/mach-omap2/pm44xx.c                       |    2 +-
 arch/arm/mach-omap2/prcm.c                         |    7 +-
 arch/arm/mach-omap2/prcm_mpu44xx.c                 |    2 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |    2 +-
 arch/arm/mach-omap2/prm44xx.c                      |    2 +-
 arch/arm/mach-omap2/prminst44xx.c                  |    2 +-
 arch/arm/mach-omap2/sdram-nokia.c                  |    2 +-
 arch/arm/mach-omap2/sdrc.c                         |    2 +-
 arch/arm/mach-omap2/sdrc2xxx.c                     |    2 +-
 arch/arm/mach-omap2/serial.c                       |    2 +-
 arch/arm/mach-omap2/smartreflex.c                  |    2 +-
 arch/arm/mach-omap2/timer.c                        |   22 +-
 arch/arm/mach-omap2/vc3xxx_data.c                  |    2 +-
 arch/arm/mach-omap2/vc44xx_data.c                  |    2 +-
 arch/arm/mach-omap2/voltage.c                      |    2 +-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c      |    2 +-
 arch/arm/mach-omap2/voltagedomains44xx_data.c      |    2 +-
 arch/arm/mach-omap2/vp.c                           |    2 +-
 arch/arm/mach-omap2/vp3xxx_data.c                  |    2 +-
 arch/arm/mach-omap2/vp44xx_data.c                  |    2 +-
 arch/arm/mach-orion5x/common.c                     |   12 +
 arch/arm/mach-orion5x/common.h                     |    1 +
 arch/arm/mach-orion5x/d2net-setup.c                |    2 +
 arch/arm/mach-orion5x/db88f5281-setup.c            |    1 +
 arch/arm/mach-orion5x/dns323-setup.c               |    1 +
 arch/arm/mach-orion5x/edmini_v2-setup.c            |    1 +
 arch/arm/mach-orion5x/include/mach/io.h            |   25 -
 arch/arm/mach-orion5x/include/mach/system.h        |   14 -
 arch/arm/mach-orion5x/include/mach/vmalloc.h       |    5 -
 arch/arm/mach-orion5x/kurobox_pro-setup.c          |    2 +
 arch/arm/mach-orion5x/ls-chl-setup.c               |    3 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c               |    3 +-
 arch/arm/mach-orion5x/lsmini-setup.c               |    3 +-
 arch/arm/mach-orion5x/mss2-setup.c                 |    3 +-
 arch/arm/mach-orion5x/mv2120-setup.c               |    3 +-
 arch/arm/mach-orion5x/net2big-setup.c              |    1 +
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c       |    1 +
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c        |    1 +
 arch/arm/mach-orion5x/rd88f5182-setup.c            |    1 +
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c       |    1 +
 arch/arm/mach-orion5x/terastation_pro2-setup.c     |    1 +
 arch/arm/mach-orion5x/ts209-setup.c                |    3 +-
 arch/arm/mach-orion5x/ts409-setup.c                |    1 +
 arch/arm/mach-orion5x/ts78xx-setup.c               |    1 +
 arch/arm/mach-orion5x/wnr854t-setup.c              |    1 +
 arch/arm/mach-orion5x/wrt350n-v2-setup.c           |    1 +
 arch/arm/mach-picoxcell/common.c                   |    9 +-
 arch/arm/mach-picoxcell/include/mach/entry-macro.S |   11 +-
 arch/arm/mach-picoxcell/include/mach/system.h      |    5 -
 arch/arm/mach-picoxcell/include/mach/vmalloc.h     |   14 -
 arch/arm/mach-picoxcell/time.c                     |   17 +-
 arch/arm/mach-pnx4008/core.c                       |    6 +
 arch/arm/mach-pnx4008/include/mach/system.h        |    9 -
 arch/arm/mach-pnx4008/include/mach/vmalloc.h       |   20 -
 arch/arm/mach-prima2/common.h                      |    1 +
 arch/arm/mach-prima2/include/mach/map.h            |    6 +-
 arch/arm/mach-prima2/include/mach/system.h         |   12 -
 arch/arm/mach-prima2/include/mach/vmalloc.h        |   16 -
 arch/arm/mach-prima2/prima2.c                      |    1 +
 arch/arm/mach-prima2/rstc.c                        |    7 +
 arch/arm/mach-pxa/balloon3.c                       |    1 +
 arch/arm/mach-pxa/capc7117.c                       |    3 +-
 arch/arm/mach-pxa/cm-x2xx.c                        |    1 +
 arch/arm/mach-pxa/cm-x300.c                        |    1 +
 arch/arm/mach-pxa/colibri-pxa270.c                 |    2 +
 arch/arm/mach-pxa/colibri-pxa300.c                 |    1 +
 arch/arm/mach-pxa/colibri-pxa320.c                 |    1 +
 arch/arm/mach-pxa/corgi.c                          |    8 +-
 arch/arm/mach-pxa/csb726.c                         |    1 +
 arch/arm/mach-pxa/em-x270.c                        |    2 +
 arch/arm/mach-pxa/eseries.c                        |    6 +
 arch/arm/mach-pxa/ezx.c                            |    6 +
 arch/arm/mach-pxa/generic.h                        |    2 +
 arch/arm/mach-pxa/gumstix.c                        |    1 +
 arch/arm/mach-pxa/h5000.c                          |    1 +
 arch/arm/mach-pxa/himalaya.c                       |    1 +
 arch/arm/mach-pxa/hx4700.c                         |    1 +
 arch/arm/mach-pxa/icontrol.c                       |    3 +-
 arch/arm/mach-pxa/idp.c                            |    1 +
 arch/arm/mach-pxa/include/mach/entry-macro.S       |   36 -
 arch/arm/mach-pxa/include/mach/system.h            |    8 -
 arch/arm/mach-pxa/include/mach/vmalloc.h           |   11 -
 arch/arm/mach-pxa/littleton.c                      |    1 +
 arch/arm/mach-pxa/lpd270.c                         |    1 +
 arch/arm/mach-pxa/lubbock.c                        |    1 +
 arch/arm/mach-pxa/magician.c                       |    1 +
 arch/arm/mach-pxa/mainstone.c                      |    1 +
 arch/arm/mach-pxa/mioa701.c                        |    7 +-
 arch/arm/mach-pxa/mp900.c                          |    1 +
 arch/arm/mach-pxa/palmld.c                         |    3 +-
 arch/arm/mach-pxa/palmt5.c                         |    3 +-
 arch/arm/mach-pxa/palmtc.c                         |    3 +-
 arch/arm/mach-pxa/palmte2.c                        |    3 +-
 arch/arm/mach-pxa/palmtreo.c                       |    2 +
 arch/arm/mach-pxa/palmtx.c                         |    3 +-
 arch/arm/mach-pxa/palmz72.c                        |    3 +-
 arch/arm/mach-pxa/pcm027.c                         |    1 +
 arch/arm/mach-pxa/poodle.c                         |    9 +-
 arch/arm/mach-pxa/raumfeld.c                       |    3 +
 arch/arm/mach-pxa/reset.c                          |    7 +-
 arch/arm/mach-pxa/saar.c                           |    1 +
 arch/arm/mach-pxa/saarb.c                          |    1 +
 arch/arm/mach-pxa/spitz.c                          |    9 +-
 arch/arm/mach-pxa/stargate2.c                      |    2 +
 arch/arm/mach-pxa/tavorevb.c                       |    1 +
 arch/arm/mach-pxa/tavorevb3.c                      |    1 +
 arch/arm/mach-pxa/time.c                           |   15 +-
 arch/arm/mach-pxa/tosa.c                           |    5 +-
 arch/arm/mach-pxa/trizeps4.c                       |    2 +
 arch/arm/mach-pxa/viper.c                          |    1 +
 arch/arm/mach-pxa/vpac270.c                        |    3 +-
 arch/arm/mach-pxa/xcep.c                           |    1 +
 arch/arm/mach-pxa/z2.c                             |    1 +
 arch/arm/mach-pxa/zeus.c                           |    1 +
 arch/arm/mach-pxa/zylonite.c                       |    1 +
 arch/arm/mach-realview/Kconfig                     |    9 +
 arch/arm/mach-realview/core.h                      |    1 -
 arch/arm/mach-realview/include/mach/entry-macro.S  |    2 -
 arch/arm/mach-realview/include/mach/system.h       |   17 -
 arch/arm/mach-realview/include/mach/vmalloc.h      |   21 -
 arch/arm/mach-realview/realview_eb.c               |   10 +-
 arch/arm/mach-realview/realview_pb1176.c           |    6 +-
 arch/arm/mach-realview/realview_pb11mp.c           |    6 +-
 arch/arm/mach-realview/realview_pba8.c             |    6 +-
 arch/arm/mach-realview/realview_pbx.c              |   10 +-
 arch/arm/mach-rpc/include/mach/system.h            |   14 -
 arch/arm/mach-rpc/include/mach/vmalloc.h           |   10 -
 arch/arm/mach-rpc/riscpc.c                         |   12 +
 arch/arm/mach-s3c2410/common.h                     |   17 +
 arch/arm/mach-s3c2410/include/mach/reset.h         |   22 -
 arch/arm/mach-s3c2410/include/mach/system-reset.h  |   32 -
 arch/arm/mach-s3c2410/include/mach/system.h        |    4 -
 arch/arm/mach-s3c2410/include/mach/vmalloc.h       |   20 -
 arch/arm/mach-s3c2410/mach-amlm5900.c              |    3 +
 arch/arm/mach-s3c2410/mach-bast.c                  |    2 +
 arch/arm/mach-s3c2410/mach-h1940.c                 |    3 +
 arch/arm/mach-s3c2410/mach-n30.c                   |    4 +
 arch/arm/mach-s3c2410/mach-otom.c                  |    3 +
 arch/arm/mach-s3c2410/mach-qt2410.c                |    5 +-
 arch/arm/mach-s3c2410/mach-smdk2410.c              |    5 +-
 arch/arm/mach-s3c2410/mach-tct_hammer.c            |    3 +
 arch/arm/mach-s3c2410/mach-vr1000.c                |    2 +
 arch/arm/mach-s3c2410/s3c2410.c                    |   13 +
 arch/arm/mach-s3c2412/mach-jive.c                  |    2 +
 arch/arm/mach-s3c2412/mach-smdk2413.c              |    3 +
 arch/arm/mach-s3c2412/mach-vstms.c                 |    1 +
 arch/arm/mach-s3c2412/s3c2412.c                    |   10 +-
 arch/arm/mach-s3c2416/mach-smdk2416.c              |    1 +
 arch/arm/mach-s3c2416/s3c2416.c                    |    7 +-
 arch/arm/mach-s3c2440/common.h                     |   17 +
 arch/arm/mach-s3c2440/mach-anubis.c                |    3 +
 arch/arm/mach-s3c2440/mach-at2440evb.c             |    3 +
 arch/arm/mach-s3c2440/mach-gta02.c                 |    2 +
 arch/arm/mach-s3c2440/mach-mini2440.c              |    3 +
 arch/arm/mach-s3c2440/mach-nexcoder.c              |    3 +
 arch/arm/mach-s3c2440/mach-osiris.c                |    3 +
 arch/arm/mach-s3c2440/mach-rx1950.c                |    3 +
 arch/arm/mach-s3c2440/mach-rx3715.c                |    3 +
 arch/arm/mach-s3c2440/mach-smdk2440.c              |    3 +
 arch/arm/mach-s3c2440/s3c2440.c                    |   13 +
 arch/arm/mach-s3c2443/mach-smdk2443.c              |    1 +
 arch/arm/mach-s3c2443/s3c2443.c                    |    8 +-
 arch/arm/mach-s3c64xx/Makefile                     |   65 +-
 arch/arm/mach-s3c64xx/clock.c                      |    4 +-
 arch/arm/mach-s3c64xx/{irq-eint.c => common.c}     |  192 +++++-
 arch/arm/mach-s3c64xx/common.h                     |   57 ++
 arch/arm/mach-s3c64xx/cpu.c                        |  161 ----
 arch/arm/mach-s3c64xx/include/mach/entry-macro.S   |    7 +-
 arch/arm/mach-s3c64xx/include/mach/system.h        |   11 -
 arch/arm/mach-s3c64xx/include/mach/vmalloc.h       |   20 -
 arch/arm/mach-s3c64xx/irq.c                        |   47 --
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    6 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    6 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    6 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    6 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    6 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |    6 +-
 arch/arm/mach-s3c64xx/mach-smartq.c                |    2 +
 arch/arm/mach-s3c64xx/mach-smartq5.c               |    5 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c               |    5 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |    6 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    6 +-
 arch/arm/mach-s3c64xx/s3c6400.c                    |    5 +-
 arch/arm/mach-s3c64xx/s3c6410.c                    |    6 +-
 arch/arm/mach-s5p64x0/Makefile                     |    9 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |    3 +-
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |    3 +-
 arch/arm/mach-s5p64x0/clock.c                      |    4 +-
 arch/arm/mach-s5p64x0/common.c                     |  468 ++++++++++++
 arch/arm/mach-s5p64x0/common.h                     |   57 ++
 arch/arm/mach-s5p64x0/cpu.c                        |  215 ------
 arch/arm/mach-s5p64x0/include/mach/entry-macro.S   |    7 +-
 arch/arm/mach-s5p64x0/include/mach/system.h        |    2 -
 arch/arm/mach-s5p64x0/include/mach/vmalloc.h       |   20 -
 arch/arm/mach-s5p64x0/init.c                       |   73 --
 arch/arm/mach-s5p64x0/irq-eint.c                   |  155 ----
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |    8 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |    8 +-
 arch/arm/mach-s5pc100/Makefile                     |   29 +-
 arch/arm/mach-s5pc100/clock.c                      |    3 +-
 arch/arm/mach-s5pc100/{cpu.c => common.c}          |  103 ++-
 arch/arm/mach-s5pc100/common.h                     |   37 +
 arch/arm/mach-s5pc100/include/mach/entry-macro.S   |   25 -
 arch/arm/mach-s5pc100/include/mach/system.h        |    2 -
 arch/arm/mach-s5pc100/include/mach/vmalloc.h       |   17 -
 arch/arm/mach-s5pc100/init.c                       |   24 -
 arch/arm/mach-s5pc100/mach-smdkc100.c              |    8 +-
 arch/arm/mach-s5pv210/Makefile                     |   19 +-
 arch/arm/mach-s5pv210/clock.c                      |    3 +-
 arch/arm/mach-s5pv210/{cpu.c => common.c}          |  113 +++-
 arch/arm/mach-s5pv210/common.h                     |   37 +
 arch/arm/mach-s5pv210/include/mach/entry-macro.S   |   37 -
 arch/arm/mach-s5pv210/include/mach/system.h        |    2 -
 arch/arm/mach-s5pv210/include/mach/vmalloc.h       |   22 -
 arch/arm/mach-s5pv210/init.c                       |   44 --
 arch/arm/mach-s5pv210/mach-aquila.c                |    8 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    8 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |    8 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    8 +-
 arch/arm/mach-s5pv210/mach-torbreck.c              |    8 +-
 arch/arm/mach-sa1100/assabet.c                     |    1 +
 arch/arm/mach-sa1100/badge4.c                      |    1 +
 arch/arm/mach-sa1100/cerf.c                        |    1 +
 arch/arm/mach-sa1100/collie.c                      |    1 +
 arch/arm/mach-sa1100/generic.c                     |   11 +
 arch/arm/mach-sa1100/generic.h                     |    1 +
 arch/arm/mach-sa1100/h3100.c                       |    1 +
 arch/arm/mach-sa1100/h3600.c                       |    1 +
 arch/arm/mach-sa1100/hackkit.c                     |    1 +
 arch/arm/mach-sa1100/include/mach/system.h         |   13 -
 arch/arm/mach-sa1100/include/mach/vmalloc.h        |    4 -
 arch/arm/mach-sa1100/jornada720.c                  |    1 +
 arch/arm/mach-sa1100/lart.c                        |    1 +
 arch/arm/mach-sa1100/nanoengine.c                  |    1 +
 arch/arm/mach-sa1100/pleb.c                        |    1 +
 arch/arm/mach-sa1100/shannon.c                     |    1 +
 arch/arm/mach-sa1100/simpad.c                      |    1 +
 arch/arm/mach-sa1100/time.c                        |   28 +-
 arch/arm/mach-shark/core.c                         |    4 +-
 arch/arm/mach-shark/include/mach/system.h          |    3 -
 arch/arm/mach-shark/include/mach/vmalloc.h         |    4 -
 arch/arm/mach-shmobile/Makefile                    |    1 -
 arch/arm/mach-shmobile/board-ag5evm.c              |    4 +-
 arch/arm/mach-shmobile/board-ap4evb.c              |    2 -
 arch/arm/mach-shmobile/board-g3evm.c               |    2 -
 arch/arm/mach-shmobile/board-g4evm.c               |    2 -
 arch/arm/mach-shmobile/board-kota2.c               |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    2 -
 arch/arm/mach-shmobile/entry-gic.S                 |   18 -
 arch/arm/mach-shmobile/include/mach/common.h       |    1 -
 arch/arm/mach-shmobile/include/mach/entry-macro.S  |    9 -
 arch/arm/mach-shmobile/include/mach/gpio.h         |    2 -
 arch/arm/mach-shmobile/include/mach/system.h       |    3 +-
 arch/arm/mach-shmobile/include/mach/vmalloc.h      |    7 -
 arch/arm/mach-spear3xx/include/mach/entry-macro.S  |   27 -
 arch/arm/mach-spear3xx/include/mach/generic.h      |    2 +
 arch/arm/mach-spear3xx/include/mach/vmalloc.h      |   19 -
 arch/arm/mach-spear3xx/spear300_evb.c              |    3 +
 arch/arm/mach-spear3xx/spear310_evb.c              |    3 +
 arch/arm/mach-spear3xx/spear320_evb.c              |    3 +
 arch/arm/mach-spear6xx/include/mach/entry-macro.S  |   36 -
 arch/arm/mach-spear6xx/include/mach/generic.h      |    2 +
 arch/arm/mach-spear6xx/include/mach/vmalloc.h      |   19 -
 arch/arm/mach-spear6xx/spear600_evb.c              |    3 +
 arch/arm/mach-tcc8k/Kconfig                        |   11 -
 arch/arm/mach-tcc8k/Makefile                       |    9 -
 arch/arm/mach-tcc8k/Makefile.boot                  |    3 -
 arch/arm/mach-tcc8k/board-tcc8000-sdk.c            |   81 --
 arch/arm/mach-tcc8k/clock.c                        |  580 --------------
 arch/arm/mach-tcc8k/common.h                       |   15 -
 arch/arm/mach-tcc8k/devices.c                      |  239 ------
 arch/arm/mach-tcc8k/io.c                           |   62 --
 arch/arm/mach-tcc8k/irq.c                          |  111 ---
 arch/arm/mach-tcc8k/time.c                         |  134 ----
 arch/arm/mach-tegra/board-dt.c                     |    3 +
 arch/arm/mach-tegra/board-harmony.c                |    3 +
 arch/arm/mach-tegra/board-paz00.c                  |    3 +
 arch/arm/mach-tegra/board-seaboard.c               |    7 +
 arch/arm/mach-tegra/board-trimslice.c              |    3 +
 arch/arm/mach-tegra/common.c                       |    2 -
 arch/arm/mach-tegra/include/mach/entry-macro.S     |   22 +-
 arch/arm/mach-tegra/include/mach/io.h              |    6 -
 arch/arm/mach-tegra/include/mach/system.h          |    4 -
 arch/arm/mach-tegra/include/mach/vmalloc.h         |   28 -
 arch/arm/mach-tegra/io.c                           |   21 -
 arch/arm/mach-tegra/timer.c                        |   24 +-
 arch/arm/mach-u300/core.c                          |   20 +
 arch/arm/mach-u300/include/mach/entry-macro.S      |   24 -
 arch/arm/mach-u300/include/mach/platform.h         |    1 +
 arch/arm/mach-u300/include/mach/system.h           |   28 -
 arch/arm/mach-u300/include/mach/vmalloc.h          |   12 -
 arch/arm/mach-u300/timer.c                         |   15 +-
 arch/arm/mach-u300/u300.c                          |    3 +
 arch/arm/mach-ux500/board-mop500.c                 |    4 +
 arch/arm/mach-ux500/board-u5500.c                  |    2 +
 arch/arm/mach-ux500/cpu-db5500.c                   |    5 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |    5 +-
 arch/arm/mach-ux500/include/mach/entry-macro.S     |    2 -
 arch/arm/mach-ux500/include/mach/gpio.h            |    5 -
 arch/arm/mach-ux500/include/mach/system.h          |    5 -
 arch/arm/mach-ux500/include/mach/vmalloc.h         |   18 -
 arch/arm/mach-versatile/core.c                     |   18 +-
 arch/arm/mach-versatile/core.h                     |    1 +
 arch/arm/mach-versatile/include/mach/entry-macro.S |   30 -
 arch/arm/mach-versatile/include/mach/system.h      |   16 -
 arch/arm/mach-versatile/include/mach/vmalloc.h     |   21 -
 arch/arm/mach-versatile/versatile_ab.c             |    3 +
 arch/arm/mach-versatile/versatile_dt.c             |    3 +
 arch/arm/mach-versatile/versatile_pb.c             |    3 +
 arch/arm/mach-vexpress/Kconfig                     |    2 +
 arch/arm/mach-vexpress/include/mach/entry-macro.S  |    2 -
 arch/arm/mach-vexpress/include/mach/system.h       |    4 -
 arch/arm/mach-vexpress/include/mach/vmalloc.h      |   21 -
 arch/arm/mach-vexpress/v2m.c                       |    4 +-
 arch/arm/mach-vt8500/include/mach/system.h         |    1 +
 arch/arm/mach-vt8500/include/mach/vmalloc.h        |   20 -
 arch/arm/mach-w90x900/cpu.c                        |   16 +
 arch/arm/mach-w90x900/include/mach/system.h        |   22 -
 arch/arm/mach-w90x900/include/mach/vmalloc.h       |   23 -
 arch/arm/mach-w90x900/irq.c                        |    2 +
 arch/arm/mach-w90x900/mach-nuc910evb.c             |    1 +
 arch/arm/mach-w90x900/mach-nuc950evb.c             |    1 +
 arch/arm/mach-w90x900/mach-nuc960evb.c             |    1 +
 arch/arm/mach-w90x900/nuc910.h                     |    9 +-
 arch/arm/mach-w90x900/nuc950.h                     |    9 +-
 arch/arm/mach-w90x900/nuc960.h                     |    9 +-
 arch/arm/mach-w90x900/{nuc910.h => nuc9xx.h}       |   12 +-
 arch/arm/mach-w90x900/time.c                       |    2 +
 arch/arm/mach-zynq/common.c                        |    1 +
 arch/arm/mach-zynq/include/mach/entry-macro.S      |    3 -
 arch/arm/mach-zynq/include/mach/system.h           |    5 -
 arch/arm/mach-zynq/include/mach/vmalloc.h          |   20 -
 arch/arm/mm/Kconfig                                |   40 +-
 arch/arm/mm/alignment.c                            |    2 +-
 arch/arm/mm/context.c                              |   19 +-
 arch/arm/mm/fault.c                                |  169 ++---
 arch/arm/mm/fault.h                                |   27 +-
 arch/arm/mm/fsr-2level.c                           |   78 ++
 arch/arm/mm/fsr-3level.c                           |   68 ++
 arch/arm/mm/idmap.c                                |   93 ++-
 arch/arm/mm/init.c                                 |   40 +-
 arch/arm/mm/ioremap.c                              |  119 ++--
 arch/arm/mm/mm.h                                   |   14 +
 arch/arm/mm/mmap.c                                 |  173 ++++-
 arch/arm/mm/mmu.c                                  |   97 ++-
 arch/arm/mm/nommu.c                                |    4 +-
 arch/arm/mm/pgd.c                                  |   51 ++-
 arch/arm/mm/proc-arm1020.S                         |    3 +
 arch/arm/mm/proc-arm1020e.S                        |    3 +
 arch/arm/mm/proc-arm1022.S                         |    3 +
 arch/arm/mm/proc-arm1026.S                         |    3 +
 arch/arm/mm/proc-arm6_7.S                          |    4 +
 arch/arm/mm/proc-arm720.S                          |    3 +
 arch/arm/mm/proc-arm740.S                          |    3 +
 arch/arm/mm/proc-arm7tdmi.S                        |    3 +
 arch/arm/mm/proc-arm920.S                          |    3 +
 arch/arm/mm/proc-arm922.S                          |    3 +
 arch/arm/mm/proc-arm925.S                          |    3 +
 arch/arm/mm/proc-arm926.S                          |    3 +
 arch/arm/mm/proc-arm940.S                          |    3 +
 arch/arm/mm/proc-arm946.S                          |    3 +
 arch/arm/mm/proc-arm9tdmi.S                        |    3 +
 arch/arm/mm/proc-fa526.S                           |    3 +
 arch/arm/mm/proc-feroceon.S                        |    3 +
 arch/arm/mm/proc-macros.S                          |    5 +-
 arch/arm/mm/proc-mohawk.S                          |    3 +
 arch/arm/mm/proc-sa110.S                           |    3 +
 arch/arm/mm/proc-sa1100.S                          |    3 +
 arch/arm/mm/proc-v6.S                              |    3 +
 arch/arm/mm/proc-v7-2level.S                       |  171 +++++
 arch/arm/mm/proc-v7-3level.S                       |  150 ++++
 arch/arm/mm/proc-v7.S                              |  190 +----
 arch/arm/mm/proc-xsc3.S                            |    3 +
 arch/arm/mm/proc-xscale.S                          |    3 +
 arch/arm/nwfpe/entry.S                             |    8 +-
 arch/arm/nwfpe/fpopcode.c                          |   26 -
 arch/arm/nwfpe/fpopcode.h                          |    3 -
 arch/arm/plat-iop/Makefile                         |    4 +-
 arch/arm/plat-iop/io.c                             |   59 --
 .../include/mach/system.h => plat-iop/restart.c}   |   12 +-
 arch/arm/plat-iop/time.c                           |   16 +-
 arch/arm/plat-mxc/Kconfig                          |    1 +
 arch/arm/plat-mxc/Makefile                         |    1 -
 arch/arm/plat-mxc/gic.c                            |   41 -
 arch/arm/plat-mxc/include/mach/common.h            |    4 +-
 arch/arm/plat-mxc/include/mach/entry-macro.S       |   11 -
 arch/arm/plat-mxc/include/mach/mx1.h               |    2 -
 arch/arm/plat-mxc/include/mach/system.h            |    2 -
 arch/arm/plat-mxc/include/mach/vmalloc.h           |   22 -
 arch/arm/plat-mxc/system.c                         |   11 +-
 arch/arm/plat-mxc/time.c                           |   15 +-
 arch/arm/plat-nomadik/timer.c                      |   20 +-
 arch/arm/plat-omap/Makefile                        |    2 +-
 arch/arm/plat-omap/common.c                        |    8 +
 arch/arm/plat-omap/counter_32k.c                   |   40 +-
 arch/arm/plat-omap/include/plat/common.h           |   83 --
 arch/arm/plat-omap/include/plat/io.h               |   76 --
 arch/arm/plat-omap/include/plat/irqs.h             |   14 -
 arch/arm/plat-omap/include/plat/system.h           |    2 -
 arch/arm/plat-omap/io.c                            |  159 ----
 arch/arm/plat-orion/time.c                         |   21 +-
 arch/arm/plat-s3c24xx/cpu.c                        |   23 -
 arch/arm/plat-s5p/Kconfig                          |    1 +
 arch/arm/plat-s5p/Makefile                         |    1 -
 arch/arm/plat-s5p/cpu.c                            |  144 ----
 arch/arm/plat-s5p/s5p-time.c                       |   19 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |    6 -
 arch/arm/plat-samsung/include/plat/exynos4.h       |   35 -
 arch/arm/plat-samsung/include/plat/reset.h         |   16 -
 arch/arm/plat-samsung/include/plat/s3c2412.h       |    3 +
 arch/arm/plat-samsung/include/plat/s3c2416.h       |    2 +
 arch/arm/plat-samsung/include/plat/s3c2443.h       |    2 +
 arch/arm/plat-samsung/include/plat/s3c6400.h       |   36 -
 arch/arm/plat-samsung/include/plat/s3c6410.h       |   29 -
 arch/arm/plat-samsung/include/plat/s5p6440.h       |   36 -
 arch/arm/plat-samsung/include/plat/s5p6450.h       |   36 -
 arch/arm/plat-samsung/include/plat/s5pc100.h       |   33 -
 arch/arm/plat-samsung/include/plat/s5pv210.h       |   33 -
 arch/arm/plat-samsung/include/plat/system-reset.h  |   31 -
 .../arm/plat-samsung/include/plat/watchdog-reset.h |    1 +
 arch/arm/plat-spear/Makefile                       |    2 +-
 arch/arm/plat-spear/include/plat/system.h          |   15 -
 arch/arm/plat-spear/include/plat/vmalloc.h         |   19 -
 .../{include/plat/system.h => restart.c}           |   24 +-
 arch/arm/plat-tcc/Kconfig                          |   20 -
 arch/arm/plat-tcc/Makefile                         |    3 -
 arch/arm/plat-tcc/clock.c                          |  179 -----
 arch/arm/plat-tcc/include/mach/clock.h             |   48 --
 arch/arm/plat-tcc/include/mach/debug-macro.S       |   32 -
 arch/arm/plat-tcc/include/mach/entry-macro.S       |   68 --
 arch/arm/plat-tcc/include/mach/hardware.h          |   43 -
 arch/arm/plat-tcc/include/mach/io.h                |   23 -
 arch/arm/plat-tcc/include/mach/irqs.h              |   83 --
 arch/arm/plat-tcc/include/mach/system.h            |   31 -
 arch/arm/plat-tcc/include/mach/tcc8k-regs.h        |  807 --------------------
 arch/arm/plat-tcc/include/mach/timex.h             |    5 -
 arch/arm/plat-tcc/include/mach/uncompress.h        |   34 -
 arch/arm/plat-tcc/include/mach/vmalloc.h           |   10 -
 arch/arm/plat-tcc/system.c                         |   25 -
 arch/arm/plat-versatile/sched-clock.c              |   29 +-
 arch/arm/tools/mach-types                          |  713 +++++++++--------
 drivers/amba/bus.c                                 |    4 +
 drivers/char/hw_random/nomadik-rng.c               |    2 +
 drivers/clocksource/clksrc-dbx500-prcmu.c          |   16 +-
 drivers/dma/amba-pl08x.c                           |    2 +
 drivers/dma/pl330.c                                |    2 +
 drivers/gpio/gpio-pl061.c                          |    2 +
 drivers/input/serio/ambakmi.c                      |    2 +
 drivers/mmc/host/mmci.c                            |    2 +
 drivers/rtc/rtc-pl030.c                            |    2 +
 drivers/rtc/rtc-pl031.c                            |    2 +
 drivers/spi/spi-pl022.c                            |    2 +
 drivers/tty/serial/amba-pl010.c                    |    2 +
 drivers/tty/serial/amba-pl011.c                    |    2 +
 drivers/video/amba-clcd.c                          |    2 +
 drivers/watchdog/sp805_wdt.c                       |    2 +
 include/linux/amba/bus.h                           |    7 +-
 include/linux/irqdomain.h                          |    3 +-
 include/linux/mod_devicetable.h                    |   18 +
 include/linux/vmalloc.h                            |    1 +
 kernel/irq/irqdomain.c                             |   12 +-
 mm/vmalloc.c                                       |   29 +-
 scripts/mod/file2alias.c                           |   72 ++
 sound/arm/aaci.c                                   |    2 +
 928 files changed, 7280 insertions(+), 10133 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/vic.txt
 create mode 100644 arch/arm/include/asm/cti.h
 create mode 100644 arch/arm/include/asm/edac.h
 delete mode 100644 arch/arm/include/asm/entry-macro-vic2.S
 delete mode 100644 arch/arm/include/asm/hardware/entry-macro-gic.S
 create mode 100644 arch/arm/include/asm/idmap.h
 create mode 100644 arch/arm/include/asm/opcodes.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-3level.h
 create mode 100644 arch/arm/kernel/opcodes.c
 create mode 100644 arch/arm/lib/call_with_stack.S
 delete mode 100644 arch/arm/mach-at91/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/vmalloc.h
 rename arch/arm/mach-clps711x/{irq.c => common.c} (58%)
 delete mode 100644 arch/arm/mach-clps711x/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-clps711x/mm.c
 delete mode 100644 arch/arm/mach-clps711x/time.c
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-davinci/io.c
 delete mode 100644 arch/arm/mach-dove/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-exynos/common.c
 create mode 100644 arch/arm/mach-exynos/common.h
 delete mode 100644 arch/arm/mach-exynos/cpu.c
 delete mode 100644 arch/arm/mach-exynos/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-exynos/init.c
 delete mode 100644 arch/arm/mach-exynos/irq-combiner.c
 delete mode 100644 arch/arm/mach-exynos/irq-eint.c
 delete mode 100644 arch/arm/mach-footbridge/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-highbank/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-integrator/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-iop13xx/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-iop32x/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-iop33x/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-ks8695/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-msm/include/mach/entry-macro-qgic.S
 delete mode 100644 arch/arm/mach-msm/include/mach/entry-macro-vic.S
 delete mode 100644 arch/arm/mach-msm/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-netx/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-nomadik/cpu-8815.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-omap1/common.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/vmalloc.h
 copy arch/arm/{plat-omap/include/plat => mach-omap2}/common.h (63%)
 delete mode 100644 arch/arm/mach-omap2/include/mach/omap4-common.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-realview/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-rpc/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-s3c2410/common.h
 delete mode 100644 arch/arm/mach-s3c2410/include/mach/reset.h
 delete mode 100644 arch/arm/mach-s3c2410/include/mach/system-reset.h
 delete mode 100644 arch/arm/mach-s3c2410/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-s3c2440/common.h
 rename arch/arm/mach-s3c64xx/{irq-eint.c => common.c} (50%)
 create mode 100644 arch/arm/mach-s3c64xx/common.h
 delete mode 100644 arch/arm/mach-s3c64xx/cpu.c
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-s3c64xx/irq.c
 create mode 100644 arch/arm/mach-s5p64x0/common.c
 create mode 100644 arch/arm/mach-s5p64x0/common.h
 delete mode 100644 arch/arm/mach-s5p64x0/cpu.c
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-s5p64x0/init.c
 delete mode 100644 arch/arm/mach-s5p64x0/irq-eint.c
 rename arch/arm/mach-s5pc100/{cpu.c => common.c} (66%)
 create mode 100644 arch/arm/mach-s5pc100/common.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-s5pc100/init.c
 rename arch/arm/mach-s5pv210/{cpu.c => common.c} (67%)
 create mode 100644 arch/arm/mach-s5pv210/common.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-s5pv210/init.c
 delete mode 100644 arch/arm/mach-sa1100/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-shark/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-shmobile/entry-gic.S
 delete mode 100644 arch/arm/mach-shmobile/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-tcc8k/Kconfig
 delete mode 100644 arch/arm/mach-tcc8k/Makefile
 delete mode 100644 arch/arm/mach-tcc8k/Makefile.boot
 delete mode 100644 arch/arm/mach-tcc8k/board-tcc8000-sdk.c
 delete mode 100644 arch/arm/mach-tcc8k/clock.c
 delete mode 100644 arch/arm/mach-tcc8k/common.h
 delete mode 100644 arch/arm/mach-tcc8k/devices.c
 delete mode 100644 arch/arm/mach-tcc8k/io.c
 delete mode 100644 arch/arm/mach-tcc8k/irq.c
 delete mode 100644 arch/arm/mach-tcc8k/time.c
 delete mode 100644 arch/arm/mach-tegra/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-u300/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-versatile/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-vexpress/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-w90x900/include/mach/vmalloc.h
 copy arch/arm/mach-w90x900/{nuc910.h => nuc9xx.h} (72%)
 delete mode 100644 arch/arm/mach-zynq/include/mach/vmalloc.h
 create mode 100644 arch/arm/mm/fsr-2level.c
 create mode 100644 arch/arm/mm/fsr-3level.c
 create mode 100644 arch/arm/mm/proc-v7-2level.S
 create mode 100644 arch/arm/mm/proc-v7-3level.S
 delete mode 100644 arch/arm/plat-iop/io.c
 copy arch/arm/{mach-iop33x/include/mach/system.h => plat-iop/restart.c} (66%)
 delete mode 100644 arch/arm/plat-mxc/gic.c
 delete mode 100644 arch/arm/plat-mxc/include/mach/vmalloc.h
 delete mode 100644 arch/arm/plat-omap/io.c
 delete mode 100644 arch/arm/plat-s5p/cpu.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/exynos4.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/reset.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c6400.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c6410.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s5p6440.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s5p6450.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s5pc100.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s5pv210.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/system-reset.h
 delete mode 100644 arch/arm/plat-spear/include/plat/vmalloc.h
 copy arch/arm/plat-spear/{include/plat/system.h => restart.c} (59%)
 delete mode 100644 arch/arm/plat-tcc/Kconfig
 delete mode 100644 arch/arm/plat-tcc/Makefile
 delete mode 100644 arch/arm/plat-tcc/clock.c
 delete mode 100644 arch/arm/plat-tcc/include/mach/clock.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/debug-macro.S
 delete mode 100644 arch/arm/plat-tcc/include/mach/entry-macro.S
 delete mode 100644 arch/arm/plat-tcc/include/mach/hardware.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/io.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/irqs.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/system.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/tcc8k-regs.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/timex.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/uncompress.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/vmalloc.h
 delete mode 100644 arch/arm/plat-tcc/system.c
