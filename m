Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2DUWn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 18:43:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34671 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2DUWnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 18:43:25 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Apr 2012 15:43:04 -0700
X-Google-Sender-Auth: CeYV4EPe9PjL52iKZhfrodXJHiw
Message-ID: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
Subject: Linux 3.4-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things looked fairly calm for a while, but that certainly changed
yesterday. I think either people time their pulls for the -rc releases
too, or it's just a matter of many developers actually having a
somewhat normal Mon-Fri workweek these days and they close the week by
sending my their pull request. Regardless of why, it meant that my
"oh, things are really calming down nicely" state on Thursday changed
to "Uhhuh, not quite yet" on Friday - when more than half the commits
for this whole -rc release came in.

Oh well.

That said, even with the uptick on Friday, I do think things have been
fairly calm. We've got a few reverts and a few cleanups, but the bulk
of it is trivial small fixes. Almost all of it in drivers with a few
filesystem updates (many of them endianness fixes from Al) thrown in
too. The traditional (non-rename) diff is dominated by a m68k bootlogo
movement, but we all use those nice git diffs these days, don't we?
Then it's 50% drivers (usb, mfd, xen, mmc, gpu, media..), 20% arch,
15+% fs, and a smattering of random stuff.

But none of it really looks all that scary. It looks like the 3.4
release is all on track, but please do holler if you see regressions.

I'll be mostly off-line for a couple of days (scuba cylinder
inspection class etc), but if this pattern of "people send me stuff on
Friday" holds true, I guess nobody will actually care. Plus I will
have my laptop and work environment, so if something *does* come up,
we're fine anyway, I'm just not quite as on-line as I normally am.

                     Linus

---

Aaro Koskinen (1):
      ARM: OMAP1: mux: add missing include

Adrian Hunter (2):
      mmc: fixes for eMMC v4.5 discard operation
      mmc: fixes for eMMC v4.5 sanitize operation

Ajay Kumar Gupta (1):
      usb: musb: fix bug in musb_cleanup_urb

Al Viro (15):
      nfsd: fix b0rken error value for setattr on read-only mount
      nfsd: fix error values returned by nfsd4_lockt() when nfsd_open() fails
      nfsd: fix endianness breakage in TEST_STATEID handling
      nfsd: fix error value on allocation failure in nfsd4_decode_test_stateid()
      nfsd: fix compose_entry_fh() failure exits
      ext4: fix endianness breakage in ext4_split_extent_at()
      btrfs: btrfs_root_readonly() broken on big-endian
      ocfs2: ->l_next_free_req breakage on big-endian
      ocfs: ->rl_used breakage on big-endian
      ocfs2: ->rl_count endianness breakage
      ocfs2: ->e_leaf_clusters endianness breakage
      lockd: fix the endianness bug
      aio: don't bother with unmapping when aio_free_ring() is coming
from exit_aio()
      perfmon: kill some helpers and arguments
      kill mm argument of vm_munmap()

Alan Stern (3):
      USB: fix deadlock in bConfigurationValue attribute method
      EHCI: fix criterion for resuming the root hub
      EHCI: always clear the STS_FLR status bit

Alex Deucher (1):
      drm/radeon/si: add missing radeon_bo_unreserve in si_rlc_init() v2

Alex Williamson (2):
      KVM: unmap pages from the iommu when slots are removed
      KVM: lock slots_lock around device assignment

Alexander Shiyan (1):
      ARM: clps711x: serial driver hungs are a result of call
disable_irq within ISR

Alexey Khoroshilov (1):
      [media] drxk: Does not unlock mutex if sanity check failed in
scu_command()

Anand Avati (1):
      fuse: O_DIRECT support for files

Anatolij Gustschin (1):
      USB: ehci-fsl: Fix kernel crash on mpc5121e

Andre Przywara (1):
      hwmon: fam15h_power: fix bogus values with current BIOSes

Andrzej Pietrasiewicz (3):
      usb: gadget: FunctionFS: clear FFS_FL_BOUND flag on unbind (bugfix)
      usb: gadget: FunctionFS: make module init & exit __init & __exit
      usb: gadget: eliminate NULL pointer dereference (bugfix)

Anton Tikhomirov (5):
      usb: s3c-hsotg: Fix TX FIFOs allocation
      usb: s3c-hsotg: Fix maximum patcket size setting for EP0
      usb: s3c-hsotg: Avoid TxFIFO corruption in DMA mode
      usb: s3c-hsotg: Fix big buffers transfer in DMA mode
      usb: dwc3: Free event buffers array

Archit Taneja (1):
      ARM: OMAP2/3: VENC hwmods: Remove OCPIF_SWSUP_IDLE flag from
VENC slave interface

Avi Kivity (1):
      KVM: VMX: Fix kvm_set_shared_msr() called in preemptible context

Bhupesh Sharma (1):
      usb: gadget: uvc: Remove non-required locking from
'uvc_queue_next_buffer' routine

Bjørn Mork (1):
      USB: sierra: avoid QMI/wwan interface on MC77xx

Casey Schaufler (1):
      Smack: move label list initialization

Chanho Park (1):
      perf archive: Correct cutting of symbolic link

Chris Ball (1):
      mmc: omap_hsmmc: build fix for CONFIG_OF=y and CONFIG_MMC_OMAP_HS=m

Chris Wilson (2):
      drm/i915: Hold mode_config lock whilst changing mode for lastclose()
      drm/i915: Do not set "Enable Panel Fitter" on SNB pageflips

Chuanxiao Dong (1):
      mmc: remove MMC bus legacy suspend/resume method

Dan Carpenter (1):
      sata_mv: silence an uninitialized variable warning

Dan Williams (1):
      libata: make ata_print_id atomic

Daniel Drake (1):
      mmc: sdhci: refine non-removable card checking for card detection

Daniel Lezcano (1):
      mfd : Fix dbx500 compilation error

Daniel Vetter (1):
      drm/i915: don't clobber the special upscaling lvds timings

Dave Airlie (3):
      drm/radeon: disable MSI on RV515
      drm/usb: fix module license on drm/usb layer.
      drm/radeon: fix load detect on rn50 with hardcoded EDIDs.

David Gibson (1):
      virtio_balloon: Fix endian bug

David Härdeman (1):
      [media] rc-core: set mode for winbond-cir

Dennis Chen (1):
      [S390] s390/char/vmur.c: fix memory leak

Dmitry Artamonow (1):
      mfd: Fix asic3_gpio_to_irq

Dong Aisheng (1):
      pinctrl: fix compile error if not select PINMUX support

Eric Bénard (1):
      mmc: unbreak sdhci-esdhc-imx on i.MX25

Eric Paris (1):
      fcaps: clear the same personality flags as suid when fcaps are used

Fabio Estevam (2):
      ARM: imx_v4_v5_defconfig: Add support for CONFIG_REGULATOR_FIXED_VOLTAGE
      ARM: imx27-dt: Fix build due to removal of irq_domain_add_simple()

Felipe Balbi (2):
      usb: gadget: udc-core: stop UDC on device-initiated disconnect
      usb: dwc3: ep0: increment "actual" on bounced ep0 case

Fernando Guzman Lugo (1):
      ARM: OMAP2+: hwmod: add softreset delay field and OMAP4 data

Gerard Cauvy (1):
      usb: dwc3: ep0: add a default case for SetFeature command

Gleb Natapov (1):
      KVM: PMU emulation: GLOBAL_CTRL MSR should be enabled on reset

Govindraj.R (1):
      ARM: OMAP2+: UART: Fix incorrect population of default uart pads

Grazvydas Ignotas (3):
      usb: musb: fix some runtime_pm issues
      usb: musb: wake the device before ulpi transfers
      ARM: OMAP: sram: fix BUG in dpll code for !PM case

Greg Ungerer (4):
      m68knommu: remove the unused bootlogo.h processing for 68EZ328 and 68VZ328
      m68knommu: move and fix the 68VZ328 platform bootlogo.h
      m68knommu: fix id number for second eth device on 5275 ColdFire
      m68knommu: make sure 2nd FEC eth interface pins are enabled on
5275 ColdFire

Guennadi Liakhovetski (2):
      [media] V4L: mt9m032: fix two dead-locks
      [media] V4L: mt9m032: fix compilation breakage

Guenter Roeck (1):
      hwmon: (ads1015) Fix build warning

H Hartley Sweeten (1):
      mmc: cd-gpio: Include header to pickup exported symbol prototypes

Heiko Carstens (2):
      [S390] irq: simple coding style change
      [S390] cpum_cf: get rid of compile warnings

Henrik Rydberg (1):
      nouveau: Set special lane map for the right chipset

Horia Geanta (1):
      crypto: talitos - properly lock access to global talitos registers

Hugh Dickins (1):
      memcg: fix Bad page state after replace_page_cache

J. Bruce Fields (1):
      nfsd: don't fail unchecked creates of non-special files

Jaehoon Chung (1):
      mmc: dw_mmc: prevent NULL dereference for dma_ops

Jean-Christophe PLAGNIOL-VILLARD (2):
      ARM: at91: fix rm9200ek flash size
      ARM: at91: fix at91sam9261ek Ethernet dm9000 irq

Jeff Layton (1):
      nfsd: include cld.h in the headers_install target

Jerome Glisse (1):
      radeon: fix r600/agp when vram is after AGP (v3)

Jesper Juhl (1):
      mpi: Avoid using freed pointer in mpi_lshift_limbs()

Jim Meyering (1):
      drm/nouveau/pm: don't read/write beyond end of stack buffer

Jiri Kosina (1):
      HID: tivo: fix support for bluetooth version of tivo Slide

Jiri Olsa (2):
      perf session: Skip event correctly for unknown id/machine
      perf tools: Fix parsers' rules to dependencies

Joachim Eastwood (5):
      ARM: at91: Export at91_st_base
      ARM: at91: Export at91_ramc_base
      ARM: at91: Export at91_pmc_base
      ARM: at91: Export at91_matrix_base
      ARM: at91: remove empty at91_init_serial function

Joe Perches (1):
      checkpatch: revert --strict test for net/ and drivers/net block
comment style

Jonas Aaberg (1):
      ARM: ux500: wake secondary cpu via resched

Jonghwan Choi (1):
      security: fix compile error in commoncap.c

Joonyoung Shim (1):
      drm: fix page_flip error handling

Josh Boyer (1):
      HID: default HID_BATTERY_STRENGTH to no

Julia Lawall (4):
      [S390] drivers/s390/block/dasd_eckd.c: add missing dasd_sfree_request
      xen/grant-table: add error-handling code on failure of gnttab_resume
      drivers/usb/misc/usbtest.c: add kfrees
      drivers/tty/amiserial.c: add missing tty_unlock

Kent Yoder (1):
      crypto: sha512 - Fix byte counter overflow in SHA-512

Keshava Munegowda (1):
      ARM: OMAP3: USB: Fix the EHCI ULPI PHY reset issue

Kishon Vijay Abraham I (2):
      usb: musb: omap: fix crash when musb glue (omap) gets initialized
      usb: gadget: udc-core: fix asymmetric calls in remove_driver

Konrad Rzeszutek Wilk (4):
      xen/blkback: Fix warning error.
      xen/xenbus: Add quirk to deal with misconfigured backends.
      xen/resume: Fix compile warnings.
      Revert "xen/p2m: m2p_find_override: use list_for_each_entry_safe"

Kuninori Morimoto (1):
      ALSA: workaround: change the timing of alsa_sound_last_init()

Lasse Collin (1):
      xz: Enable BCJ filters on SPARC and 32-bit x86

Lee Jones (1):
      ARM: ux500: Fix unmet direct dependency

Lin Ming (1):
      libata: forbid port runtime pm by default, fixing regression

Linus Torvalds (5):
      Revert "ACPI: ignore FADT reset-reg-sup flag"
      VM: add "vm_brk()" helper function
      VM: add "vm_munmap()" helper function
      VM: add "vm_mmap()" helper function
      Linux 3.4-rc4

Linus Walleij (1):
      ARM: ux500: update defconfig

Lukasz Majewski (1):
      usb: gadget: rndis: fix Missing req->context assignment

Marcos Paulo de Souza (1):
      drivers: gpu: drm: gma500: mdfld_dsi_output.h: Remove not
unneeded include of version.h

Martin Schwidefsky (2):
      [S390] fix tlb flushing for page table pages
      [S390] Fix compile error in swab.h

Masami Hiramatsu (1):
      x86: Handle failures of parsing immediate operands in the
instruction decoder

Mauro Carvalho Chehab (1):
      [media] dvb_frontend: Fix a regression when switching back to DVB-S

Michael Holzheu (3):
      [S390] kernel: Use local_irq_save() for memcpy_real()
      [S390] update default configuration
      [S390] Fix stfle() lowcore protection problem

Michael Krufky (1):
      [media] xc5000: support 32MHz & 31.875MHz xtal using the 41.024.5 firmware

Michael S. Tsirkin (1):
      virtio_balloon: fix handling of PAGE_SIZE != 4k

Michał Wróbel (1):
      crypto: ixp4xx - include fix

Miklos Szeredi (3):
      fuse: fix nlink after unlink
      fuse: allow nanosecond granularity
      fuse: use flexible array in fuse.h

Moiz Sonasath (1):
      usb: dwc3: ep0: Handle requests greater than wMaxPacketSize

Namhyung Kim (1):
      perf tools: Ignore auto-generated bison/flex files

Nicolas Ferre (5):
      ARM: at91: fix typo in at91_pmc_base assembly declaration
      leds-atmel-pwm.c: Make pwmled_probe() __devinit
      USB: ohci-at91: change annotations for probe/remove functions
      USB: gadget/at91_udc: add gpio_to_irq() function to vbus interrupt
      dmaengine: Kconfig: fix Atmel at_hdmac entry

Oliver Neukum (2):
      uwb: fix use of del_timer_sync() in interrupt
      uwb: fix error handling

Paul Gortmaker (2):
      mfd: Fix modular builds of rc5t583 regulator support
      ARM: bcmring: fix UART declarations

Paul Walmsley (2):
      ARM: OMAP2+: hwmod: Revert "ARM: OMAP2+: hwmod: Make
omap_hwmod_softreset wait for reset status"
      ARM: OMAP1: DMTIMER: fix broken timer clock source selection

Peter Chen (1):
      usb: fsl_udc_core: prime status stage once data stage has primed

Peter Ujfalusi (1):
      mfd: Convert twl6040 to i2c driver, and separate it from twl core

Prathyush (1):
      drm: Releasing FBs before releasing GEM objects during drm_release

Rafael J. Wysocki (1):
      PCI: Retry BARs restoration for Type 0 headers only

Rajendra Nayak (1):
      mmc: omap_hsmmc: Get rid of of_have_populated_dt() usage

Randy Dunlap (2):
      Documentation: maintainer change
      ALSA: fix core/vmaster.c kernel-doc warning

Ren Mingxin (1):
      virtio_blk: helper function to format disk names

Robert Lee (1):
      ARM: imx: Fix imx5 idle logic bug

Sachin Prabhu (2):
      Cleanup handling of NULL value passed for a mount option
      Fix number parsing in cifs_parse_mount_options

Santosh Shilimkar (1):
      ARM: OMAP: serial: Fix the ocp smart idlemode handling bug

Seth Heasley (1):
      ata_piix: IDE-mode SATA patch for Intel DH89xxCC DeviceIDs

Seungwon Jeon (1):
      mmc: dw_mmc: Fix switch from DMA to PIO

Shubhrajyoti D (1):
      usb: musb: omap: fix the error check for pm_runtime_get_sync

Stefano Stabellini (2):
      xen/gntdev: do not set VM_PFNMAP
      xen/p2m: m2p_find_override: use list_for_each_entry_safe

Stephane Eranian (1):
      perf tools: fix NO_GTK2 Makefile config error

Stephen Warren (3):
      pinctrl: include <linux/bug.h> to prevent compile errors
      pinctrl: implement pinctrl_check_ops
      USB: ehci-tegra: don't call set_irq_flags(IRQF_VALID)

Sylwester Nawrocki (1):
      [media] V4L: DocBook: Fix typos in the multi-plane formats description

Takashi Iwai (5):
      ALSA: hda/realtek - Fix regression on Quanta/Gericom KN1
      ALSA: hda/sigmatel - Fix inverted mute LED
      drm/radeon/kms: fix the regression of DVI connector check
      ALSA: hda/conexant - Don't set HP pin-control bit unconditionally
      ALSA: hda/conexant - Set up the missing docking-station pins

Tejun Heo (1):
      memblock: memblock should be able to handle zero length operations

Theodore Ts'o (2):
      ext4: address scalability issue by removing extent cache statistics
      ext4: fix handling of journalled quota options

Thomas Gleixner (1):
      Revert "ACPI: Make ACPI interrupt threaded"

Tomoki Sekiyama (2):
      USB: yurex: Remove allocation of coherent buffer for setup-packet buffer
      USB: yurex: Fix missing URB_NO_TRANSFER_DMA_MAP flag in urb

Tomoya MORINAGA (1):
      pch_uart: Fix dma channel unallocated issue

Tony Luck (1):
      ia64: fix futex_atomic_cmpxchg_inatomic()

Ulf Hansson (1):
      mmc: core: Do not pre-claim host in suspend

Vladimir Zapolskiy (1):
      usb: musb: fix oops on omap2430 module unload

Xi Wang (2):
      usb: usbtest: avoid integer overflow in test_ctrl_queue()
      usb: usbtest: avoid integer overflow in alloc_sglist()

Yong Zhang (1):
      sparc32,leon: add notify_cpu_starting()

Yuri Matylitski (1):
      USB: serial: cp210x: Fixed usb_control_msg timeout values

Zhi Yong Wu (1):
      tools/virtio: fix up vhost/test module build
