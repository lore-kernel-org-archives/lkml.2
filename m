Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0LGFmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:42:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911Ab0LGFmK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:42:10 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Dec 2010 21:41:47 -0800
Message-ID: <AANLkTinNBVkYRJN+5ne9N4V4oC06Q85FNCZsfw2ZH=Ca@mail.gmail.com>
Subject: Linux 2.6.37-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, no surprises this week. I think the bulk patch-wise are config
patches (both ARM defconfig cleanups and some kconfig updates). And
the rbd sysfs interface change stands out, but other than that it's
mostly fairly small fixes all over.

The drm code (both radeon and intel) is still seeing more flux than
I'd like, and several of the current regressions are also related to
that area, so it's not done yet. But other than that things seem to be
pretty calm.

The NFS readdir regression that I thought was fixed back in -rc4
wasn't, and it's not fixed here either. But we have patches now that
are known to fix it, so it is pending and will happen RSN.

Anything else? I think the appended ShortLog pretty much describes it.
Go forth and compile,

                    Linus

---
Ajay Kumar Gupta (1):
      usb: musb: gadget: fix compilation warning

Alan Stern (1):
      USB: fix autosuspend bug in usb-serial

Alex Deucher (6):
      drm/radeon/kms: fix regression in rs4xx i2c setup
      drm/radeon/kms: fix resume regression for some r5xx laptops
      Revert "drm/radeon/kms: fix typo in r600 cs checker"
      drm/radeon/kms: fix typos in disabled vbios code
      drm/radeon/kms: fix interlaced and doublescan handling
      drm/radeon/kms: add workaround for dce3 ddc line vbios bug

Anand Gadiyar (1):
      usb: musb: do not use dma for control transfers

Andres Salomon (1):
      cs5535-gpio: apply CS5536 errata workaround for GPIOs

Andrew Morton (1):
      Documentation/filesystems/vfs.txt: fix ->repeasepage() description

Anton Vorontsov (1):
      ARM: cns3xxx: Fix build with CONFIG_PCI=y

Arend van Spriel (1):
      staging: brcm80211: updated maintainers contact information

Arnaud Lacombe (5):
      kconfig: add an option to determine a menu's visibility
      kconfig: regen parser
      Revert "i2c: Fix Kconfig dependencies"
      media/video: convert Kconfig to use the menu's `visible' keyword
      i2c/algos: convert Kconfig to use the menu's `visible' keyword

Artem Bityutskiy (1):
      UBI: fix corrupted PEB detection for NOR flash

Axel Lin (11):
      ASoC: Fix compile error for nuc900-ac97.c
      ASoC: Fix prototype for nuc900_ac97_probe and nuc900_ac97_remove
      ASoC: Fix compile error for nuc900-pcm.c
      ASoC: Remove unneeded !! operations while checking return value
of nuc900_checkready
      ASoC: Add missing dev_set_drvdata in mpc8610_hpcd_probe
      ASoC: Add missing dev_set_drvdata in p1022_ds_probe
      ASoC: Fix missing spin_unlock_irqrestore
      regulator: Remove a redundant device_remove_file call in create_regulator
      regulator: Ensure enough delay time for enabling regulator
      regulator: Return proper error for regulator_register()
      regulator: twl-regulator - fix twlreg_set_mode

Bengt Jonsson (1):
      regulator: enable supply regulator only when use count is zero

Bojan Smojver (1):
      PM / Hibernate: Use async I/O when reading compressed hibernation image

Brandon Philips (1):
      driver core: prune docs about device_interface

Brian J. Tarricone (1):
      USB: ehci: disable LPM and PPCD for nVidia MCP89 chips

Caglar Akyuz (1):
      video: da8xx: Register IRQ as last thing in driver probing.

Chao Xie (1):
      ARM: 6524/1: GIC irq desciptor bug fix

Chien Tung (1):
      MAINTAINERS: Update NetEffect entry

Chris Wilson (8):
      drm/i915: Prevent integer overflow when validating the execbuffer
      drm/i915: Only save/restore cursor regs if !KMS
      drm/i915/sdvo: Only enable HDMI encodings only if the commandset
is supported
      drm/i915: Handle pagefaults in execbuffer user relocations
      drm/i915/sdvo: Always fallback to querying the shared DDC line
      drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable
      drm/i915: Clear pfit registers when not used by any outputs
      Revert "drm/i915/dp: use VBT provided eDP params if available"

Dan Carpenter (4):
      Staging: speakup: free after input_unregister_device()
      Staging: quickstart: free after input_unregister_device()
      Staging: rtl8712: signedness bug in init
      Staging: intel_sst: fix memory leak

Daniel Drake (1):
      lxfb: Maintain video processor palette through suspend/resume

Daniel Glöckner (3):
      s6000-i2s: fix compilation
      s6000-pcm: fix compilation
      s6105-ipcam: fix compilation

Daniel T Chen (2):
      ALSA: hda: Use BIOS auto-parsing instead of existing model quirk
for MEDION MD2
      ALSA: hda: Use "alienware" model quirk for another SSID

Daniel Vetter (1):
      drm/i915: fix regression due to ba3d8d749b01548b9

Dave Chinner (5):
      xfs: fix failed write truncation handling.
      xfs: push stale, pinned buffers on trylock failures
      xfs: delayed alloc blocks beyond EOF are valid after writeback
      xfs: avoid moving stale inodes in the AIL
      xfs: only run xfs_error_test if error injection is active

Dave Martin (12):
      ARM: 6497/1: kexec: Correct data alignment for CONFIG_THUMB2_KERNEL
      ARM: 6498/1: vfp: Correct data alignment for CONFIG_THUMB2_KERNEL
      ARM: 6499/1: Thumb-2: Correct data alignment for
CONFIG_THUMB2_KERNEL in bootp/init.S
      ARM: 6500/1: Thumb-2: Correct data alignment for
CONFIG_THUMB2_KERNEL in kernel/head.S
      ARM: 6501/1: Thumb-2: Correct data alignment for
CONFIG_THUMB2_KERNEL in mm/proc-v7.S
      ARM: 6502/1: Thumb-2: Fix CONFIG_THUMB2_KERNEL breakage in
compressed/head.S
      ARM: 6503/1: Thumb-2: Restore sensible zImage header layout for
CONFIG_THUMB2_KERNEL
      ARM: 6504/1: Thumb-2: Fix long-distance conditional branches in
head.S for Thumb-2.
      ARM: 6507/1: RealView: Correct data alignment in headsmp.S for
CONFIG_THUMB2_KERNEL
      ARM: 6508/1: vexpress: Correct data alignment in headsmp.S for
CONFIG_THUMB2_KERNEL
      ARM: 6505/1: kprobes: Don't HAVE_KPROBES when
CONFIG_THUMB2_KERNEL is selected
      ARM: 6519/1: kuser: Fix incorrect cmpxchg syscall in kuser helpers

David Howells (1):
      MN10300: Implement asm/syscall.h

David Sterba (1):
      fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock

Dean Nelson (1):
      mm/hugetlb.c: avoid double unlock_page() in hugetlb_fault()

Dimitris Papastamos (1):
      ASoC: WM8731: Fix incorrect mask for bypass path disable

Dmitry Torokhov (1):
      HID: length resolution should be reported units/mm

Eli Cohen (4):
      IB/mlx4: Fix memory ordering of VLAN insertion control bits
      mlx4_core: Workaround firmware bug in query dev cap
      IB/mlx4: Fix IBoE reported link rate
      IB/mlx4: Fix IBoE link state

Eric Benard (1):
      at91: merge all at91rm9200 defconfig in one single file

Eric W. Biederman (1):
      Revert "vfs: show unreachable paths in getcwd and proc"

Feng Tang (1):
      serial: mfd: adjust the baud rate setting

Frederic Weisbecker (1):
      reiserfs: don't acquire lock recursively in reiserfs_acl_chmod

Greg Kroah-Hartman (15):
      driver core: the development tree has switched to git
      Staging: asus_oled: fix up some sysfs attribute permissions
      Staging: frontier: fix up some sysfs attribute permissions
      Staging: iio: adis16220: fix up some sysfs attribute permissions
      Staging: samsung-laptop: fix up some sysfs attribute permissions
      Staging: udlfb: fix up some sysfs attribute permissions
      Staging: zram: fix up some sysfs attribute permissions
      Staging: line6: fix up some sysfs attribute permissions
      Staging: asus_oled: fix up my fixup for some sysfs attribute permissions
      Staging: frontier: fix up my fixup for some sysfs attribute permissions
      Staging: iio: adis16220: fix up my fixup for some sysfs
attribute permissions
      Staging: samsung-laptop: fix up my fixup for some sysfs
attribute permissions
      Staging: udlfb: fix up my fixup for some sysfs attribute permissions
      Staging: zram: fix up my fixup for some sysfs attribute permissions
      Staging: line6: fix up my fixup for some sysfs attribute permissions

Guennadi Liakhovetski (1):
      dma: shdma: add a MODULE_ALIAS() to allow module autoloading

Guy Martin (2):
      parisc: KittyHawk LCD fix
      parisc: Fix GSC PS/2 driver name for keyboard and mouse

Hans J. Koch (1):
      uio: Change mail address of Hans J. Koch

Hema Kalliguddi (1):
      usb: musb: unmap dma buffer when switching to PIO

Hendrik Brueckner (1):
      initramfs: Really fix build break on symbol-prefixed archs

Henrik Rydberg (1):
      HID: egalax: Use kzalloc

Ian Campbell (1):
      xen: x86/32: perform initial startup on initial_page_table

Jacques Viviers (1):
      USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added

James Bottomley (2):
      parisc: fix dino/gsc interrupts
      parisc: convert the rest of the irq handlers to simple/percpu

Jarkko Nikula (1):
      ASoC: omap: N810: Don't select CONFIG_OMAP_MUX but make it as dependency

Jean-Christophe PLAGNIOL-VILLARD (7):
      at91: Convert remaining boards to new-style UART initialization
      at91rm9200dk: fix warning: 'dk_mmc_data' defined but not used
      at91rm9200ek: fix warning: 'ek_mmc_data' defined but not used
      at91: rename rm9200ek and rm9200dk board file name
      at91/picotux200: remove commenting usb device and dataflash support
      atmel_spi: fix warning In function 'atmel_spi_dma_map_xfer'
      at91/board-yl-9200: fix typo in video support

Jeff Layton (3):
      cifs: fix potential use-after-free in cifs_oplock_break_put
      cifs: don't take extra tlink reference in initiate_cifs_search
      cifs: fix parsing of hostname in dfs referrals

Jeremy Fitzhardinge (6):
      xen: clean up "extra" memory handling some more
      xen: use default_idle
      xen: don't bother to stop other cpus on shutdown/reboot
      vmalloc: eagerly clear ptes on vunmap
      xen: prevent crashes with non-HIGHMEM 32-bit kernels with largeish memory
      xen: allocate irq descs on any NUMA node

Jiri Slaby (5):
      ocfs2: fix memory leak
      TTY: ldisc, fix open flag handling
      NET: wan/x25, fix ldisc->open retval
      TTY: don't allow reopen when ldisc is changing
      TTY: open/hangup race fixup

Joe Perches (2):
      HID: Remove KERN_DEBUG from dbg_hid use
      MAINTAINERS: INTEL DRM DRIVERS list (intel-gfx) is subscribers-only

Johannes Berg (1):
      leds: fix up dependencies

John Tapsell (1):
      Staging: rt2870: Add USB ID for Buffalo Airstation WLI-UC-GN

KOSAKI Motohiro (2):
      mem-hotplug: introduce {un}lock_memory_hotplug()
      ksm: annotate ksm_thread_mutex is no deadlock source

Keith Packard (2):
      drm: Set connector DPMS status to ON in drm_crtc_helper_set_config
      drm: record monitor status in output_poll_execute

Kuninori Morimoto (1):
      sh: Add div6_reparent_clks to clock framework for FSI

Kyle McMartin (1):
      parisc: remove redundant initialization in sigsegv path of
sys_rt_sigreturn

Larry Finger (1):
      staging: rtl8187se: Change panic to warn when RF switch turned off

Laurent Pinchart (2):
      [media] v4l: Remove hardcoded module names passed to
v4l2_i2c_new_subdev* (2)
      [media] v4l: Remove module_name argument to the
v4l2_i2c_new_subdev* functions

Linus Torvalds (1):
      Linux 2.6.37-rc5

Marcelo Roberto Jimenez (1):
      ARM: 6456/1: Fix for building DEBUG with sa11xx_base.c as a module.

Marek Lindner (1):
      Staging: batman-adv: ensure that eth_type_trans gets linear memory

Mark Brown (1):
      regulator: Staticise mc13783_powermisc_rmw()

Mattias Wallin (2):
      regulator: regulator disable supply fix
      regulator: lock supply in regulator enable

Mauro Carvalho Chehab (1):
      [media] Fix Kconfig errors due to two visible menus

Michael Stuermer (1):
      USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable

Milton Miller (1):
      ocfs2: char is not always signed

Ming Lei (1):
      usb: musb: clear RXCSR_AUTOCLEAR before PIO read

Nelson Elhage (1):
      do_exit(): make sure that we run with get_fs() == USER_DS

Nicolas Kaiser (1):
      staging: comedi: fix memory leak

Nobuhiro Iwamatsu (2):
      sh: se/7724: Update clock framework of FSI clock to non-legacy
      sh: se/7724: Remove FSI/B of GPIO init code

Oleg Nesterov (2):
      exec: make argv/envp memory visible to oom-killer
      exec: copy-and-paste the fixes into compat_do_execve() paths

Olof Johansson (1):
      ARM: tegra: fix regression from addruart rewrite

Or Gerlitz (1):
      IB/pack: Remove some unused code added by the IBoE patches

Oskar Schirmer (1):
      cifs: fix another memleak, in cifs_root_iget

Paul Mundt (1):
      sh: Assume new page cache pages have dirty dcache lines.

Paul Zimmerman (1):
      xhci: Fix reset-device and configure-endpoint commands

Pawel Moll (1):
      ARM: 6496/1: GIC: Do not try to register more then NR_IRQS interrupts

Peter Zijlstra (1):
      serial8250: Mark console as CON_ANYTIME

Rabin Vincent (1):
      ARM: 6523/1: iop: ensure sched_clock() is notrace

Rafael J. Wysocki (1):
      PM / Hibernate: Fix memory corruption related to swap

Randy Dunlap (4):
      staging: fix winbond build, needs delay.h
      framebuffer: fix fbcmap.c kernel-doc warning
      staging: easycap needs smp_lock.h, fixes build error
      regulator: fix kernel-doc for set_consumer_device_supply

Sarah Sharp (2):
      xhci: Setup array of USB 2.0 and USB 3.0 ports.
      xhci: Don't let the USB core disable SuperSpeed ports.

Seth Heasley (1):
      watchdog: iTCO_wdt: TCO Watchdog patch for Intel Patsburg PCH

Shirish Pargaonkar (3):
      cifs: Percolate error up to the caller during get/set acls [try #4]
      cifs: Misc. cleanup in cifsacl handling [try #4]
      cifs: Handle extended attribute name cifs_acl to generate cifs
acl blob (try #4)

Simon Wood (1):
      HID: add support for F430 Force Feedback Wheel

Stefano Stabellini (5):
      xen: use PHYSDEVOP_get_free_pirq to implement find_unbound_pirq
      xen: fix MSI setup and teardown for PV on HVM guests
      xen: resume the pv console for hvm guests too
      xen: fix save/restore for PV on HVM guests with pirq remapping
      xen: unplug the emulated devices at resume time

Steve French (1):
      [CIFS] fs/cifs/Kconfig: CIFS depends on CRYPTO_HMAC

Suresh Jayaraman (4):
      cifs: trivial comment fix for cifs_invalidate_mapping
      cifs: allow fsc mount option only if CONFIG_CIFS_FSCACHE is set
      cifs: enable fscache iff fsc mount option is used explicitly
      cifs: display fsc in /proc/mounts

Sven Eckelmann (1):
      Staging: batman-adv: Don't remove interface with spinlock held

Takashi Iwai (1):
      ALSA: Fix SNDCTL_DSP_RESET ioctl for OSS emulation

Tero Roponen (1):
      slub: Fix a crash during slabinfo -v

Tomoki Sekiyama (1):
      USB: yurex: add .llseek fop to file_operations

Tristan Ye (1):
      Ocfs2: Stop tracking a negative dentry after dentry_iput().

Trond Myklebust (1):
      NFS: Fix a readdirplus bug

Vasiliy Kulikov (2):
      sh: boards: mach-se: use IS_ERR() instead of NULL check
      IB: Fix information leak in marshalling code

Wim Van Sebroeck (2):
      watchdog: bcm63xx_wdt: improve platform part.
      watchdog: it8712f_wdt: add note to Kconfig

Wolfram Sang & Martyn Welch (1):
      watchdog: gef_wdt: include fs.h

Wu Fengguang (1):
      vmstat: fix dirty threshold ordering

Yehuda Sadeh (1):
      rbd: replace the rbd sysfs interface

Yong Wang (1):
      staging: spectra: fix build error

Zeng Zhaoming (1):
      mm/mempolicy.c: add rcu read lock to protect pid structure

dann frazier (1):
      ocfs2_connection_find() returns pointer to bad structure
