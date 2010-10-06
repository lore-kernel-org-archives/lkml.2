Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab0JFVqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:46:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932904Ab0JFVqH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:46:07 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Oct 2010 14:45:13 -0700
Message-ID: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
Subject: Linux 2.6.36-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I decided to break my a-week-is-eight-days rut, and actually
release -rc7 after a proper seven-day week instead. Wo-oo!

And yes, that's probably as exciting as it gets, which is just fine by
me. This should be the last -rc, I'm not seeing any reason to keep
delaying a real release. There was still more changes to
drivers/gpu/drm than I really would have hoped for, but they all look
harmless and good. Famous last words.

Apart from that, there's some mips updates, some late ACPI fixes, and
lots of small random noise. I was looking at the dirstat, and noticed
that xfs shows up at 6%, but even that is just a single commit that is
mainly comment fixups. Which just goes to show that there's really a
lot of small trivial one-liners:  167 files changed, 992
insertions(+), 562 deletions(-) in 137 non-merge commits really does
end up being about a lot of very small changes.

[ Git hint of the day: do

    git log --stat --oneline --no-merges v2.6.36-rc6..v2.6.36-rc7

  to get a dense view of the commits and visually pick out the ones
that aren't trivial one-liners)



---
Akinobu Mita (1):
      powerpc/512x: fix clk_get() return value

Alex Deucher (3):
      drm/radeon/kms: fix up encoder info messages for DFP6
      drm/radeon/kms: fix potential segfault in r600_ioctl_wait_idle
      drm/radeon/kms: add quirk for MSI K9A2GM motherboard

Andrea Gelmini (2):
      ACPI: Kconfig: fix typo.
      MIPS: Fix a typo.

Andreas Bießmann (1):
      MIPS: Octeon: Determine if helper needs to be built

Andrew Morton (3):
      drivers/serial/mfd.c needs slab.h
      arch/m68k/mac/macboing.c: use unsigned long for irqflags
      drivers/serial/mrst_max3110.c needs linux/irq.h

Arnd Bergmann (1):
      drm: i810/i830: fix locked ioctl variant

Axel Lin (1):
      regulator: max8649 - fix setting extclk_freq

Bernhard Walle (2):
      i2c-octeon: Return -ETIMEDOUT in octeon_i2c_wait() on timeout
      MIPS: N32: Fix getdents64 syscall for n32

Boaz Harrosh (1):
      um: Proper Fix for f25c80a4: remove duplicate structure field
initialization

Chris Wilson (5):
      drm: Prune GEM vma entries
      drm/i915: Fix refleak during eviction.
      drm: Hold the mutex when dropping the last GEM reference (v2)
      drm/i915: Sanity check pread/pwrite
      drm/i915: Rephrase pwrite bounds checking to avoid any potential overflow

Christoph Hellwig (1):
      writeback: always use sb->s_bdi for writeback purposes

Colin Ian King (1):
      ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume

Cyril Chemparathy (1):
      regulator: fix typo in current units

Cyrill Gorcunov (1):
      perf, x86: Handle in flight NMIs on P4 platform

Damian Lukowski (1):
      net-2.6: SYN retransmits: Add new parameter to retransmits_timed_out()

Dan Carpenter (1):
      dma/shdma: move dereference below the NULL check

Dan Rosenberg (2):
      ALSA: prevent heap corruption in snd_ctl_new()
      sys_semctl: fix kernel stack leakage

Daniel J Blueman (1):
      fix OMAP2 MTD build failure

Dave Airlie (2):
      drm/radeon: fix PCI ID 5657 to be an RV410
      drm/gem: handlecount isn't really a kref so don't make it one.

Dave Chinner (1):
      xfs: force background CIL push under sustained load

David Daney (3):
      MIPS: Hookup fanotify_init, fanotify_mark, and prlimit64 syscalls.
      MIPS: Don't place cu2 notifiers in __cpuinitdata
      MIPS: Octeon: Place cnmips_cu2_setup in __init memory.

David Howells (1):
      MN10300: Fix flush_icache_range()

David S. Miller (1):
      ip_gre: Fix dependencies wrt. ipv6.

Deng-Cheng Zhu (1):
      MIPS: Use generic atomic64 for 32-bit kernels

Don Mullis (1):
      lib/list_sort: do not pass bad pointers to cmp callback

Eric Dumazet (2):
      rcu: rcu_read_lock_bh_held(): disabling irqs also disables bh
      vlan: dont drop packets from unknown vlans in promiscuous mode

Eric Millbrandt (1):
      powerpc/5200: tighten up ac97 reset timing

Evgeny Kuznetsov (1):
      wait: using uninitialized member of wait queue

FUJITA Tomonori (1):
      MIPS: TX49xx: Rename ARCH_KMALLOC_MINALIGN to ARCH_DMA_MINALIGN

Florian Mickler (1):
      iwl3945: queue the right work if the scan needs to be aborted

Frederic Weisbecker (2):
      reiserfs: fix dependency inversion between inode and reiserfs mutexes
      reiserfs: fix unwanted reiserfs lock recursion

Frederik Deweerdt (1):
      perf ui hist browser: Fix segfault on 'a' for annotate

Geert Uytterhoeven (1):
      fuse: Initialize total_len in fuse_retrieve()

Giel van Schijndel (1):
      hwmon: f71882fg: use a muxed resource lock for the Super I/O port

H. Peter Anvin (1):
      x86, cpu: After uncapping CPUID, re-run CPU feature detection

Heiko Carstens (1):
      generic-ipi: Fix deadlock in __smp_call_function_single

Huang Ying (3):
      ACPI, APEI, Fix APEI related table size checking
      ACPI, APEI, Fix error path for memory allocation
      ACPI, APEI, Fix ERST MOVE_DATA instruction implementation

Hugh Dickins (2):
      ksm: fix page_address_in_vma anon_vma oops
      ksm: fix bad user data when swapping

Ira W. Snyder (1):
      kfifo: fix scatterlist usage

Jeff Layton (2):
      cifs: set backing_dev_info on new S_ISREG inodes
      cifs: prevent infinite recursion in cifs_reconnect_tcon

Jesse Barnes (1):
      drm/i915: fix GMCH power reporting

Jin Dongming (2):
      ACPI, APEI, Fix acpi_pre_map() return value
      ACPI, APEI, HEST Fix the unsuitable usage of platform_data

Jiri Olsa (2):
      oprofile: Add Support for Intel CPU Family 6 / Model 29
      proc: make /proc/pid/limits world readable

Joe Perches (1):
      MIPS: Remove pr_<level> uses of KERN_<level>

Joel Becker (1):
      ocfs2: Don't walk off the end of fast symlinks.

Johannes Berg (1):
      mac80211: fix use-after-free

Jon Povey (1):
      i2c-davinci: Fix race when setting up for TX

Julia Lawall (3):
      powerpc/5200: efika.c: Add of_node_put to avoid memory leak
      drivers/gpu/drm/i915/i915_gem.c: Add missing error handling code
      MIPS: kspd: Adjust confusing if indentation

Keith Packard (2):
      drm/i915: vblank status not valid while training display port
      drm/i915: Use pipe state to tell when pipe is off

Kevin Liu (1):
      mfd: Fix max8925 irq control bit incorrect setting

Kukjin Kim (1):
      MAINTAINERS: update maintainer for S5P ARM ARCHITECTURES

Kumar Sanghvi (1):
      Phonet: Correct header retrieval after pskb_may_pull

Kusanagi Kouichi (1):
      perf tools: Fix build breakage

Len Brown (7):
      intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
      ACPI: delete ZEPTO idle=nomwait DMI quirk
      ACPI: expand Vista blacklist to include SP1 and SP2
      ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
      acpi_idle: add missing \n to printk
      ACPI: acpi_pad: simplify code to avoid false gcc build warning
      ACPI: invoke DSDT corruption workaround on all Toshiba Satellite

Linus Torvalds (3):
      Fix up more fallout form alpha signal cleanups
      modules: Fix module_bug_list list corruption race
      Linux 2.6.36-rc7

Lucas De Marchi (2):
      ACPI: Fix typos
      cpuidle: Fix typos

Luis Henriques (1):
      ACPI: fan: Fix more unbalanced code block

Manuel Lauss (1):
      MIPS: Alchemy: Resolve prom section mismatches

Marcin Slusarz (1):
      i7core_edac: fix panic in udimm sysfs attributes registration

Mark Brown (1):
      mfd: Ignore non-GPIO IRQs when setting wm831x IRQ types

Mathieu Lacage (1):
      missing inline keyword for static function in linux/dmaengine.h

Matthew Garrett (1):
      ACPI: Don't report current_now if battery reports in mWh

MyungJoo Ham (1):
      i2c-s3c2410: fix calculation of SDA line delay

Namhyung Kim (3):
      ACPI: add missing __percpu markup in arch/x86/kernel/acpi/cstate.c
      intel_idle: add missing __percpu markup
      [CPUFREQ] acpi-cpufreq: add missing __percpu markup

Pekka Enberg (1):
      [CPUFREQ] Fix memory leaks in pcc_cpufreq_do_osc

Petr Vandrovec (1):
      MAINTAINERS: update matroxfb & ncpfs status

Rafael J. Wysocki (1):
      PM / ACPI: Blacklist systems known to require acpi_sleep=nonvs

Ralf Baechle (7):
      MIPS: Document why RELOC_HIDE is there.
      MIPS: Audit: Fix hang in entry.S.
      MIPS: DMA: Fix computation of DMA flags from device's coherent_dma_mask.
      MIPS: Kconfig: Fix and clarify kconfig help text for VSMP and SMTC.
      MIPS: GIC: Remove dependencies from Malta files.
      MIPS: PNX8550: Sort out machine halt, restart and powerdown functions.
      MIPS: Fix syscall 64 bit number comments.

Ricardo Mendoza (1):
      MIPS: RM7000: Symbol should be static

Robert Richter (1):
      oprofile, ARM: Release resources on failure

Roel Kluin (1):
      spi: spi-gpio.c tests SPI_MASTER_NO_RX bit twice, but not SPI_MASTER_NO_TX

Scott Ellis (1):
      omap: McBSP: tx_irq_completion used in rx_irq_handler

Shmulik Ladkani (1):
      MIPS: Calculate VMLINUZ_LOAD_ADDRESS based on the length of vmlinux.bin

Simon Guinot (1):
      dmaengine: fix interrupt clearing for mv_xor

Sinan Akman (1):
      of/spi: Fix OF-style driver binding of spi devices

Stefano Stabellini (2):
      xen: do not set xenstored_ready before xenbus_probe on hvm
      xen: do not initialize PV timers on HVM if !xen_have_vector_callback

Stephane Eranian (1):
      perf trace scripting: Fix extern struct definitions

Stephen Rothwell (1):
      powerpc: remove unused variable

Suresh Siddha (1):
      intel_idle: Voluntary leave_mm before entering deeper

Takashi Iwai (1):
      ALSA: i2c/other/ak4xx-adda: Fix a compile warning with CONFIG_PROCFS=n

Thomas Gleixner (2):
      x86, irq: Plug memory leak in sparse irq
      x86, hpet: Fix bogus error check in hpet_assign_irq()

Thomas Hellstrom (5):
      drm/vmwgfx: Fix breakage introduced by commit "drm: block
userspace under allocating buffer and having drivers overwrite it
(v2)"
      vmwgfx: vt-switch (master drop) fixes
      vmwgfx: Enable use of the vblank system
      vmwgfx: Remove initialisation of dev::devname
      vmwgfx: Fix fb VRAM pinning failure due to fragmentation

Thomas Weber (1):
      intel_idle: Change mode 755 => 644

Tony Lindgren (1):
      omap: Fix compile dependency to LEDS_CLASS

Vasiliy Kulikov (1):
      regulator: fix device_register() error handling

Zhang Rui (3):
      ACPI: fix build warnings resulting from merge window conflict
      ACPI video: fix a poor warning message
      ACPI: Disable Windows Vista compatibility for Toshiba P305D

christophe leroy (1):
      spi/mpc8xxx: fix buffer overrun on large transfers
