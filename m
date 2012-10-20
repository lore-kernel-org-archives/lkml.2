Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab2JTTld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 15:41:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57614 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab2JTTl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 15:41:29 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Oct 2012 12:41:06 -0700
X-Google-Sender-Auth: r6274f0ozR7CXsAA9Rk71ApJ7U4
Message-ID: <CA+55aFxYbBpozpWZ0e1xyOjGFcNnA0nbV9jLvSe5cLpzvG1hgQ@mail.gmail.com>
Subject: Linux 3.7-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the last few months, it's almost become a habit of mine to make
the occasional release from the airport while flying out somewhere.
And this is another such one. Go free PDX airport wireless!

Anyway, it's been roughly a week, and -rc2 is out. The most noticeable
thing tends to be fixing various fallout issues - there's lots of
patches to finish up (and fix the fallout) from the UAPI include file
reorganization, for example, but there's also some changes to how
module signing is done etc etc.

In pure lines, the uapi stuff (even with rename detection) dwarfs
everything else, and the diffstat of -rc2 is very unusual. Instead of
the normal "65% drivers, random everything else", it's "50% arch
patches (largely uapi header files), 30% include (more uapi header
file changes, and 20% everything else".

But the appended shortlog is fairly readable, because the uapi changes
don't dominate there. Nothing really particular stands out. DRM and
USB driver changes, and various random fixes all over..

Have fun, and go forth and test,

                    Linus

---

Al Viro (2):
      fix a leak in replace_fd() users
      bury SEL_{IN,OUT,EX}

Alan Stern (1):
      USB: fix port probing and removal in garmin_gps

Alex Deucher (5):
      drm/radeon: fix compilation with backlight disabled
      drm/radeon: allocate PPLLs from low to high
      drm/radeon: update comments to clarify VM setup (v2)
      drm/radeon/cayman: set VM max pfn at MC init
      drm/radeon: check if pcie gen 2 is already enabled (v2)

Alexander Shiyan (1):
      serial: sccnxp: Allows the driver to be compiled as a module

Alexandre Pereira da Silva (1):
      usb: gadget: lpc32xx_udc: Fix compatibility with STOTG04

Alexis R. Cortes (1):
      usb: host: xhci: New system added for Compliance Mode Patch on
SN65LVPE502CP

Andi Kleen (1):
      FRV: Fix const sections change

Aneesh Kumar K.V (1):
      powerpc: Build fix for powerpc KVM

Antony Pavlov (1):
      MIPS: JZ4740: Fix '#include guard' in serial.h

Arnaldo Carvalho de Melo (4):
      perf python: Initialize 'page_size' variable
      perf python: Link with libtraceevent
      perf hists browser: Add back callchain folding symbol
      perf python: Properly link with libtraceevent

Arnd Bergmann (9):
      SCSI: ARM: ncr5380/oak uses no interrupts
      SCSI: ARM: make fas216_dumpinfo function conditional
      mm/slob: use min_t() to compare ARCH_SLAB_MINALIGN
      USB: EHCI: mark ehci_orion_conf_mbus_windows __devinit
      pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops
      pinctrl: samsung: use __devinit section for init code
      pinctrl: sirf: remove sirfsoc_gpio_set_pull function
      spi/s3c64xx: use correct dma_transfer_direction type
      ARM: s3c: mark s3c2440_clk_add as __init_refok

Ashish Chavan (1):
      ASoC: codecs: da9055: Minor improvement in ALC calibration process

Axel Lin (2):
      gpio: mvebu: Add missing breaks in mvebu_gpio_irq_set_type
      drivers/video/backlight/lm3639_bl.c: return proper error in
lm3639_bled_mode_store() error paths

Ben Collins (1):
      USB: ehci-fsl: Return valid error in ehci_fsl_setup_phy

Ben Skeggs (1):
      drm/nouveau/bios: fix typo in error message

Benjamin Herrenschmidt (1):
      Revert "powerpc/perf: Use pmc_overflow() to detect rolled back events"

Benoit Cousson (1):
      ARM: OMAP2+: clock data: Add dev-id for the omap-gpmc dummy fck

Bill Pemberton (2):
      staging: dgrp: check for NULL pointer in (un)register_proc_table
      staging: dgrp: check return value of alloc_tty_driver

Bjørn Mork (2):
      USB: option: blacklist net interface on ZTE devices
      USB: option: add more ZTE devices

Borislav Petkov (1):
      x86, MCE: Remove bios_cmci_threshold sysfs attribute

Bryan Wu (1):
      MAINTAINERS: change email after moving for LED subsystem maintaining

Carlos Maiolino (2):
      ext3: fix possible non-initialized variable on htree_dirblock_to_tree()
      ext3: ext3_bread usage audit

Catalin Marinas (5):
      uapi: Allow automatic generation of uapi/asm/ header files
      arm64: Select MODULES_USE_ELF_RELA
      arm64: Fix the update_vsyscall() prototype
      arm64: Ignore memory blocks below PHYS_OFFSET
      arm64: No need to set the x0-x2 registers in start_thread()

Chris Ball (1):
      ARM: pxa: Fix build error caused by sram.h rename

Chris Wilson (2):
      drm/i915: Disallow preallocation of requests
      drm/i915: fixup i915_gem_object_get_page inline helper

Chris Zankel (3):
      xtensa: fix memmove(), bcopy(), and memcpy().
      xtensa: minor compiler warning fix
      xtensa: add missing system calls to the syscall table

Christian König (3):
      drm/radeon: allocate page tables on demand v4
      drm/radeon: don't add the IB pool to all VMs v2
      drm/radeon: separate pt alloc from lru add

Corey Minyard (3):
      IPMI: Remove SMBus driver info from the docs
      IPMI: Fix some uninitialized warning
      IPMI: Detect register spacing on PCI interfaces

Cyrill Gorcunov (1):
      pidns: remove recursion from free_pid_ns()

Dan Carpenter (1):
      x86/cache_info: Use ARRAY_SIZE() in amd_l3_attrs()

Daniel J Blueman (1):
      x86, amd, mce: Avoid NULL pointer reference on CPU northbridge lookup

Daniel Vetter (5):
      drm/i915: paper over a pipe-enable vs pageflip race
      drm/i915: disable wc gtt pte mappings on gen2
      drm/i915: rip out the pipe A quirk for i855gm
      drm/i915: fixup the plane->pipe fixup code
      drm/i915/dvo-ch7xxx: fix get_hw_state

Dave Airlie (2):
      drm: fix warning on 32-bit.
      nouveau: fix warning on 32-bit build.

David Ahern (1):
      perf tool: Precise mode requires exclude_guest

David Daney (1):
      MIPS: Make __{,n,u}delay declarations match definitions and
generic delay.h

David Henningsson (1):
      ALSA: hda - Always check array bounds in alc_get_line_out_pfx

David Hooper (1):
      x86/reboot: Remove quirk entry for SBC FITPC

David Howells (23):
      UAPI: (Scripted) Disintegrate arch/sh/include/asm
      UAPI: (Scripted) Disintegrate include/linux/hsi
      UAPI: (Scripted) Disintegrate include/linux/usb
      UAPI: (Scripted) Disintegrate arch/xtensa/include/asm
      Unexport some bits of linux/fs.h
      UAPI: (Scripted) Disintegrate arch/parisc/include/asm
      FRV: Fix VLIW packing constraint violation in entry.S
      FRV: Fix incorrect symbol in copy_thread()
      FRV: Fix linux/elf-fdpic.h
      UAPI: Make uapi/linux/irqnr.h non-empty
      UAPI: Remove empty conditionals from include/linux/Kbuild
      UAPI: Remove empty non-UAPI Kbuild files
      UAPI: Place comments in empty arch Kbuilds to make them non-empty
      UAPI: The tile arch uses the generic ucontext.h file
      UAPI: Put a comment into uapi/asm-generic/kvm_para.h and use it
from arches
      UAPI: Make arch/mn10300/include/uapi/asm/setup.h non-empty
      UAPI: Make arch/sh/include/uapi/asm/hw_breakpoint.h non-empty
      UAPI: Make arch/sparc/include/uapi/asm/sigcontext.h non-empty
      UAPI: (Scripted) Disintegrate include/linux/dvb
      UAPI: (Scripted) Disintegrate arch/hexagon/include/asm
      MODSIGN: perlify sign-file and merge in x509keyid
      MODSIGN: Cleanup .gitignore
      MODSIGN: Move the magic string to the end of a module and
eliminate the search

David Miller (1):
      perf tools: Fix build on sparc.

David Rientjes (3):
      thermal, cpufreq: Fix build when CPU_FREQ_TABLE isn't configured
      mm, mempolicy: fix printing stack contents in numa_maps
      fs, xattr: fix bug when removing a name not in xattr list

David S. Miller (4):
      sparc64: Like x86 we should check current->mm during perf
backtrace generation.
      sparc64: Add global PMU register dumping via sysrq.
      MAINTAINERS: Add explicit section for IPSEC networking.
      sparc64: Fix bit twiddling in sparc_pmu_enable_event().

Deepthi Dharwar (3):
      cpuidle/powerpc: Fix target residency initialisation in pseries cpuidle
      cpuidle/powerpc: Fix smt_snooze_delay functionality.
      cpuidle/powerpc: Fix snooze state problem in the cpuidle design
on pseries.

Dmitry Kravkov (1):
      bnx2x: fix handling mf storage modes

Egbert Eich (1):
      drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().

Eric Dumazet (1):
      ipv6: addrconf: fix /proc/net/if_inet6

Felipe Balbi (1):
      usb: dwc3: gadget: fix 'endpoint always busy' bug

Fengguang Wu (1):
      firmware/memmap: avoid type conflicts with the generic memmap_init()

Geert Uytterhoeven (2):
      staging: serial: dgrp: Add missing #include <linux/uaccess.h>
      serial/8250_hp300: Missing 8250 register interface conversion bits

Greg Kroah-Hartman (2):
      tty: serial: sccnxp: Fix bug with unterminated platform_id list
      USB: usb.h: remove dbg() macro

Guennadi Liakhovetski (1):
      ASoC: fsi: don't reschedule DMA from an atomic context

Guenter Roeck (1):
      hwmon: (coretemp) Add support for Atom CE4110/4150/4170

H. Peter Anvin (1):
      x86, suspend: Correct the restore of CR4, EFER; skip computing EFLAGS.ID

Hendrik Brueckner (1):
      smsgiucv: reestablish IUCV path after resume

Henrik Rydberg (1):
      usbdevfs: Fix broken scatter-gather transfer

Jacob Shin (1):
      x86: Exclude E820_RESERVED regions and memory holes above 4 GB
from direct mapping.

James Bottomley (1):
      [PARISC] asm: redo generic includes

Jan Kara (1):
      quota: Silence warning about PRJQUOTA not being handled in
need_print_warning()

Jani Nikula (1):
      drm/i915: fix non-DP-D eDP backlight cleanup and module reload

Janusz Krzysztofik (1):
      ASoC: ams-delta: Convert to use snd_soc_register_card()

Jason Gunthorpe (1):
      ARM: Kirkwood: fix disabling CACHE_FEROCEON_L2

Jiri Pirko (1):
      vlan: fix bond/team enslave of vlan challenged slave/port

Johan Hovold (19):
      USB: ark3116: fix NULL-pointer dereference
      USB: cyberjack: fix port-data memory leak
      USB: belkin_sa: fix port-data memory leak
      USB: cp210x: fix port-data memory leak
      USB: pl2303: fix port-data memory leak
      USB: cypress_m8: fix port-data memory leak
      USB: kobil_sct: fix port-data memory leak
      USB: io_edgeport: fix port-data memory leak
      USB: f81232: fix port-data memory leak
      USB: keyspan_pda: fix port-data memory leak
      USB: io_ti: fix port-data memory leak
      USB: kl5kusb105: fix port-data memory leak
      USB: iuu_phoenix: fix port-data memory leak
      USB: oti6858: fix port-data memory leak
      USB: ti_usb_3410_5052: fix port-data memory leak
      USB: ssu100: fix port-data memory leak
      USB: spcp8x5: fix port-data memory leak
      USB: iuu_phoenix: fix sysfs-attribute creation
      USB: io_ti: fix sysfs-attribute creation

John Johansen (1):
      apparmor: fix apparmor OOPS in audit_log_untrustedstring+0x1c/0x40

Jon Hunter (1):
      ARM: OMAP2+: Allow kernel to boot even if GPMC fails to reserve memory

Jussi Kivilinna (1):
      crypto: aesni - fix XTS mode on x86-32, add wrapper function for
asmlinkage aesni_enc()

KAMEZAWA Hiroyuki (1):
      hold task->mempolicy while numa_maps scans.

Kees Cook (4):
      hwmon: (pmbus) remove CONFIG_EXPERIMENTAL
      Documentation/hwmon: remove CONFIG_EXPERIMENTAL
      kernel/sys.c: fix stack memory content leak via UNAME26
      use clamp_t in UNAME26 fix

Kenneth Graunke (1):
      drm/i915: Set guardband clipping workaround bit in the right register.

Kim Phillips (3):
      of/address: sparse fixes
      of/irq: sparse fixes
      of/platform: sparse fix

Kuninori Morimoto (4):
      ARM: shmobile: armadillo800eva: __io abuse cleanup
      ARM: shmobile: r8a7779: use __iomem pointers for MMIO
      usb: renesas_usbhs: fixup __usbhs_for_each_pipe 1st pos
      usb: renesas_usbhs: fixup interrupt status clear method

Laurent Pinchart (2):
      usb: gadget: Make webcam gadget select USB_LIBCOMPOSITE
      MAINTAINERS: Add maintainer entry for the USB webcam gadget

Linus Torvalds (4):
      xen: Fix annoying compile-time warning
      kbuild: Fix module signature generation
      remap_file_pages: correctly handle the case of a NULL vm_ops pointer
      Linux 3.7-rc2

Linus Walleij (3):
      pinctrl/nomadik: provide stubs for legacy Nomadik
      pinctrl/nomadik: always use the simple irqdomain
      ARM: dts: compile Integrator device trees

Luca Tettamanti (1):
      drm/radeon: use %zu for formatting size_t

Marc Gauthier (2):
      xtensa: copy_thread with CLONE_VM must not copy live parent AR windows
      xtensa: fix missing return in do_page_fault for SIGBUS case

Marc Zyngier (1):
      arm64: fix alignment padding in assembly code

Marcin Slusarz (1):
      drm/nv50/fb: fix double free of vram mm

Mark Brown (4):
      ASoC: bells: Correct typo in sub speaker DAI name for WM5110
      ASoC: wm2200: Use rev A register patches on rev B
      ASoC: wm2200: Fix non-inverted OUT2 mute control
      ASoC: bells: Correct typo in sub speaker DAI name for WM5110

Mark Zhang (1):
      ARM: tegra30: clk: Fix output_rate overflow

Markus Trippelsdorf (1):
      tty: Fix bogus "callbacks suppressed" messages

Martin Peres (3):
      drm/nouveau/hwmon: fix the initialization condition
      drm/nouveau/pm: fix a typo related to the move to the therm subdev
      drm/nouveau/pm: do not stop reclocking if failing to set the fan speed

Matthew Garrett (2):
      ACPI: Reorder IPMI driver before any other ACPI drivers
      IPMI: Change link order

Mauro Carvalho Chehab (2):
      DocBook/media/Makefile: Fix build due to uapi breakage
      [media] Kconfig: Fix dependencies for driver autoselect options

Max Filippov (7):
      xtensa: ISS: fix specific simcalls
      xtensa: ISS: fix rs_put_char
      xtensa: fix boot parameters parsing
      xtensa: reorganize SR referencing
      xtensa: fix unaligned usermode access
      xtensa: Use Kbuild infrastructure to handle asm-generic headers
      drm/nouveau: only call ttm_agp_tt_create when __OS_HAS_AGP

Maxim Kachur (1):
      ALSA: emu10k1: add chip details for E-mu 1010 PCIe card

Mel Gorman (1):
      mm: compaction: correct the nr_strict va isolated check for CMA

Michael Walle (2):
      ARM: kirkwood: fix LEDs names for lsxl boards
      ARM: kirkwood: fix buttons on lsxl boards

Michal Marek (1):
      kbuild: Fix accidental revert in commit fe04ddf

Ming Lei (2):
      USB: cdc-acm: fix pipe type of write endpoint
      lib/dma-debug.c: fix __hash_bucket_find()

Namhyung Kim (3):
      perf tools: Fix segfault when using srcline sort key
      perf tools: Remove warnings on JIT samples for srcline sort key
      perf hists browser: Fix off-by-two bug on the first column

Nicolas Boullis (1):
      usb: acm: fix the computation of the number of data bits

Olof Johansson (1):
      of: add stub of_get_child_by_name for non-OF builds

Paul E. McKenney (1):
      printk: Fix scheduling-while-atomic problem in console_cpu_notify()

Paul Mundt (2):
      sh: Wire up kcmp syscall.
      sh: Fix up more fallout from pointless ARM __iomem churn.

Paul Walmsley (1):
      ARM: OMAP: resolve sparse warning concerning debug_card_init()

Peter Meerwald (1):
      ASoC: fix documentation in soc-jack

Peter Ujfalusi (4):
      ASoC: twl6040: Fix Stream DAPM mapping
      ASoC: omap-abe-twl6040: Fix typo of Vibrator
      ASoC: omap-mcpdm: Remove OMAP revision check
      ASoC: dmaengine: Correct Makefile when sound is built as module

Peter Zijlstra (1):
      perf: Require exclude_guest to use PEBS - kernel side enforcement

Rafael J. Wysocki (1):
      MAINTAINERS: Add Rafael's address to ACPI maintainers

Ralf Baechle (7):
      mm: huge_memory: Fix build error.
      MIPS: tlbex: Deal with re-definition of label
      MIPS: R5000: Fix TLB hazard handling.
      MIPS: Hugetlbfs: Handle huge pages correctly in pmd_bad()
      MIPS: Restore pagemask after dumping the TLB.
      MIPS: hugetlbfs: Fix hazard between tlb write and pagemask restoration.
      MIPS: JZ4740: Forward declare struct uart_port in header.

Randy Dunlap (2):
      docbook: networking: fix file paths for uapi headers
      drm: radeon: fix printk format warning

Richard Kuo (1):
      Hexagon: Copyright marking changes

Richard Weinberger (1):
      linux/coredump.h needs asm/siginfo.h

Rodrigo Vivi (1):
      drm/i915: HSW CRW stability magic

Russell King (1):
      ARM: fix oops on initial entry to userspace with Thumb2 kernels

Rusty Russell (1):
      kbuild: sign the modules at install time

Sachin Kamat (1):
      arm64: Remove duplicate inclusion of mmu_context.h in smp.c

Sarah Sharp (4):
      USB: Enable LPM after a failed probe.
      usb: Don't enable LPM if the exit latency is zero.
      usb: Send Set SEL before enabling parent U1/U2 timeout.
      usb: trival: Fix debugging units mistake.

Sasha Levin (2):
      net, TTY: initialize tty->driver_data before usage
      SUNRPC: Prevent kernel stack corruption on long values of flush

Sebastian Hesselbarth (6):
      ARM: dove: Add pcie clock support
      ARM: dove: Fix tauros2 device tree init
      ARM: dove: Fix clock names of sata and gbe
      ARM: dove: Restructure SoC device tree descriptor
      ARM: dove: Remove watchdog from DT
      ARM: dove: Add crypto engine to DT

Sebastien Guiriec (1):
      ARM: OMAP4: devices: fixup OMAP4 DMIC platform device error message

Shawn Guo (1):
      ARM: dts: imx6q-arm2: move NANDF_CS pins out of 'hog'

Sivaram Nair (2):
      ARM: tegra: rename tegra system timer
      ARM: tegra: add tegra_timer clock

Stefan Raspl (1):
      qeth: fix deadlock between recovery and bonding driver

Stefano Babic (1):
      usb: musb: am35xx: drop spurious unplugging a device

Stephen Warren (1):
      dtc: fix for_each_*() to skip first object if deleted

Steven Rostedt (2):
      lib tools traceevent: Add back pevent assignment in
__pevent_parse_format()
      tools lib traceevent: Fix missed freeing of subargs in
free_arg() in filter

Takashi Iwai (4):
      ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()
      ALSA: hda - Clean up superfluous position_fix list entries
      ALSA: hda - Fix registration race of VGA switcheroo
      ALSA: hda - Stop LPIB delay counting on broken hardware

Tero Kristo (1):
      ARM: OMAP: clockdomain: Fix locking on _clkdm_clk_hwmod_enable / disable

Thomas Friebel (1):
      drm/radeon: fix spelling typos in debugging output

Tobias Klauser (1):
      pinctrl: bcm2835: Use existing pointer to struct device

Tony Lindgren (2):
      ASoC: Fix wrong include for McPDM
      ARM: OMAP4: Fix twd_local_timer_register regression

Tony Prisk (3):
      dtb: fix interrupt assignment for ehci/uhci on wm8505
      usb: Missing dma_mask in uhci-platform.c when probed from device-tree
      usb: Missing dma_mask in ehci-vt8500.c when probed from device-tree

Trond Myklebust (1):
      NLM: nlm_lookup_file() may return NLMv4-specific error codes

Vivek Gautam (1):
      usb: dwc3: shutdown usb_phy when removing the device

Wei Yongjun (3):
      pinctrl: remove duplicated include from pinctrl-bcm2835.c
      pinctrl: fix return value in bcm2835_pinctrl_probe()
      pinctrl: remove duplicated include from pinctrl-xway.c

Will Deacon (2):
      arm64: ptrace: make structure padding explicit for debug registers
      arm64: ptrace: use HW_BREAKPOINT_EMPTY type for disabled breakpoints

Willy Tarreau (1):
      drm/i915: remove useless BUG_ON which caused a regression in 3.5.

Zhao Hongjiang (2):
      ext2: fix return values on parse_options() failure
      ext3: fix return values on parse_options() failure

Zijie Pan (1):
      sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()

jerin jacob (1):
      MIPS: CMP: Fix physical core number calculation logic
