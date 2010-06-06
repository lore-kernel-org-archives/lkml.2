Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab0FFEUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 00:20:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab0FFEUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 00:20:38 -0400
Date: Sat, 5 Jun 2010 21:15:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.35-rc2
Message-ID: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So -rc2 is out there, and hopefully fixes way more problems than it 
introduces.

I'm slightly unhappy with its size - admittedly it's not nearly as big as 
rc2 was the last release cycle, but that was an unusually big -rc2. And I 
really hoped for a calmer release cycle this time.

In fact, for once I'm going to enforce -rc3 being sane, because the 
upcoming week is the last week of school for my kids. And when the kids 
get out of school, I'm going be offline for a while. And as a result, I 
_really_ don't want to pull anything even half-way scary in the next week 
for -rc3.

So any pull requests had better be obvious fixes only, and this time I'm 
not going to let things slide.

Anyway, the biggest patches in -rc2 are some staging drivers (70% of the 
patch is just that), so while it's still biggish, at least most of it is 
clearly staging.

Of the remaining non-staging 30%, half of _that_ is just the regular 
drivers (drm: i915 and radeon, along with some dvb updates is a noticeable 
chunk), with a new Core i7 EDAC driver that I had gotten a pull request 
for before -rc1, but just hadn't had the energy to pull until -rc2 (same 
goes for a build system update - the pull request predated -rc1).

And some late powerpc changes that I do _not_ think predated -rc1. Tssk. 
I'm really not going to let things like that slide next -rc, as mentioned.

But the most important part is obviously the regression fixes, which tend 
to be small and not show up much in the patch statistics. A number of 
reverts, a number of fixes, hopefully things are all rosy.

And it really isn't _that_ bad - the -rc2 shortlog is almost never small 
enough to be worth posting on the mailing list, but I think it's doable 
this time, even if it's borderline. So ShortLog appended if people care 
about the (summary of) details.

			Linus
---
Abhijeet Dharmapurikar (1):
      msm_serial: fix serial on trout

Abylay Ospan (1):
      V4L/DVB: cx23885: Check register errors

Adam Jackson (4):
      drm/i915/gen4: Extra CRT hotplug paranoia
      drm/i915/dp: Only enable enhanced framing if the sink supports it
      drm/i915/dp: Add DPCD data to debug output
      drm/i915: Honor sync polarity from VBT panel timing descriptors

Akinobu Mita (2):
      x86/mm: Remove unused DBG() macro
      kernel/: fix BUG_ON checks for cpu notifier callbacks direct call

Al Viro (2):
      mqueue doesn't need make_bad_inode()
      fix the deadlock in qib_fs

Alan Cox (2):
      edac: i7core_edac produces undefined behaviour on 32bit
      intel_scu_ipc: Length fix

Alan Stern (1):
      USB: unbind all interfaces before rebinding them

Albert Herranz (2):
      Revert "fb_defio: fix for non-dirty ptes"
      fb_defio: redo fix for non-dirty ptes

Alex Deucher (7):
      drm/radeon/kms/evergreen: add initial CS parser
      drm/radeon/kms/pm: add support for SetVoltage cmd table (V2)
      drm/radeon/kms/pm: enable SetVoltage on r7xx/evergreen
      drm/radeon/kms/pm: patch default power state with default clocks/voltages on r6xx+
      drm/radeon/kms/pm: radeon_set_power_state fixes
      drm/radeon/kms/pm: voltage fixes
      drm/radeon/kms: make sure display hw is disabled when suspending

Alexander Beregalov (2):
      genksyms: close ref_file after use
      i7core_edac: fix memory leak of i7core_dev

Alexander Kurz (4):
      serial_cs: add and sort IDs for serial and modem cards
      Staging: comedi: fix 8255 and DAS08 Kconfig dependancies.
      Staging: comedi: fixing ni_tio to mite PCI dependancy
      Staging: comedi: fixing ni_labpc to mite dependancy

Alexandre Bounine (1):
      of/powerpc: fix 85xx RapidIO device node pointer

Amit K. Arora (1):
      sched: Make sure timers have migrated before killing the migration_thread

Amit Shah (2):
      virtio: console: Fix crash when hot-unplugging a port and read is blocked
      virtio: console: Fix crash when port is unplugged and blocked for write

Ananth N Mavinakayanahalli (1):
      powerpc/kprobes: Remove resume_execution() in kprobes

Anatolij Gustschin (15):
      powerpc/44x: icon: select SM502 and frame buffer console support
      can: mpc5xxx_can.c: Fix build failure
      of/spi: mpc512x_psc_spi.c: Fix build failures
      of/mtd/nand: mpc5121_nfc.c: Fix build failures
      of/dma: mpc512x_dma.c: Fix build failures
      of/pcmcia: m8xx_pcmcia.c: Fix build failures
      of/video: fix build breakage in FB drivers
      of/mtd: nand: fix build breakage in drivers
      of/dma: fix build breakage in ppc4xx adma driver
      of/crypto: crypto4xx_core.c: fix build breakage
      of/usb: fsl_qe_udc.c: fix build breakage
      of/net: fs_enet/mii-bitbang.c: fix build breakage
      of/edac: fix build breakage in drivers
      of/watchdog: gef_wdt.c: fix build breakage
      crypto: crypto4xx - Fix build breakage

Andi Kleen (2):
      Improve kconfig symbol hashing
      kbuild: move -fno-dwarf2-cfi-asm to powerpc only

Andrea Gelmini (2):
      drbd: removed duplicated #includes
      Documentation/i2c: Checkpatch cleanup

Andreas Schwab (1):
      powerpc/macio: Don't dereference pointer before null check

Andrew Hendry (1):
      Minix: Clean up left over label

Andrew Morton (1):
      lib/kobject_uevent.c: fix CONIG_NET=n warning

Andy Fleming (1):
      powerpc/85xx: Enable support for ports 3 and 4 on 8548 CDS

Andy Walls (1):
      V4L/DVB: cx18, cx23885, v4l2 doc, MAINTAINERS: Update Andy Walls' email address

Ang Way Chuang (1):
      V4L/DVB: dvb-core: Fix ULE decapsulation bug

Anton Vorontsov (1):
      powerpc/fsl-booke: Add hibernation support for FSL BookE processors

Aristeu Rozanski (1):
      pci: Add a probing code that seeks for an specific bus

Arnaldo Carvalho de Melo (1):
      perf buildid-list: Fix --with-hits event processing

Arnd Bergmann (1):
      cris: push down BKL into some device drivers

Aurelien Jarno (1):
      clocksource: sh_tmu: compute mult and shift before registration

Axel Lin (1):
      USB: cdc-acm: fix resource reclaim in error path of acm_probe

Barry Song (1):
      Staging: iio-utils: fix memory overflow for dynamically allocateded memory to hold filename

Ben Dooks (3):
      USB: s3c-hsotg: Ensure TX FIFO addresses setup when initialising FIFOs
      USB: s3c-hsotg: SoftDisconnect minimum 3ms
      USB: s3c-hsotg: Ensure FIFOs are fully flushed after layout

Ben Hutchings (6):
      V4L/DVB: dw2102: Select tda10023 frontend, not tda10021
      V4L/DVB: budget: Select correct frontends
      V4L/DVB: dib0700: Select dib0090 frontend
      V4L/DVB: m920x: Select simple tuner
      sfc: Get port number from CS_PORT_NUM, not PCI function number
      sfc: Store port number in net_device::dev_id

Ben McKeegan (1):
      ppp_generic: fix multilink fragment sizes

Ben Skeggs (8):
      drm/nouveau: fix POST detection for certain chipsets
      drm/nv40: allow cold-booting of nv4x chipsets
      drm/nouveau: don't execute INIT_GPIO unless we're really running the table
      drm/nv50: fix duallink_possible calculation for DCB 4.0 cards
      drm/nv50: obey dcb->duallink_possible
      drm/nouveau: fix dual-link displays when plugged into single-link outputs
      drm/nv50: use alternate source of SOR_MODE_CTRL for DP hack
      drm/nv50: cast IGP memory location to u64 before shifting

Benjamin Herrenschmidt (3):
      powerpc/44x: Fix UART clocks on 440SPe
      powerpc: Don't export cvt_fd & _df when CONFIG_PPC_FPU is not set
      powerpc/macio: Fix probing of macio devices by using the right of match table

Borislav Petkov (2):
      perf-record: Check correct pid when forking
      x86, smpboot: Fix cores per node printing on boot

Brian Haley (1):
      IPv6: fix Mobile IPv6 regression

Bruno Randolf (1):
      ath5k: wake queues on reset

Cesar Eduardo Barros (1):
      arch/um: fix kunmap_atomic() call in skas/uaccess.c

Changli Gao (4):
      skb: make skb_recycle_check() return a bool value
      act_nat: fix the wrong checksum when addr isn't in old_addr/mask
      cls_u32: use skb_header_pointer() to dereference data safely
      act_pedit: access skb->data safely

Chris Wilson (18):
      drm/i915: Fail to load driver if KMS request without GEM
      agp/intel: Restrict GTT mapping to valid range on i915 and i945
      drm/i915: Kill dangerous pending-flip debugging
      drm/i915: Only print an message if there was an error
      drm/i915: Hold the spinlock whilst resetting unpin_work along error path
      drm/i915: Avoid nesting of domain changes when setting display plane
      drm/i915: Propagate error from unbinding an unfenceable object.
      drm/i915: Only print "nothing to do" debug message as required.
      drm/i915: Include pitch in set_base debug statement.
      drm/i915: Rebind bo if currently bound with incorrect alignment.
      drm/i915: Remove spurious warning "Failure to install fence"
      drm/i915: Check error code whilst moving buffer to GTT domain.
      drm/i915: Reject bind_to_gtt() early if object > aperture
      drm/i915: Cleanup after failed initialization of ringbuffers
      drm/i915: Avoid moving from CPU domain during pwrite
      drm/i915: Use non-atomic kmap for slow copy paths
      drm/i915: Fix up address spaces in slow_kernel_write()
      drm/i915: Move non-phys cursors into the GTT

Christian Lamparter (1):
      ar9170usb: fix read from freed driver context

Christoph Fritz (1):
      ssb: fix NULL ptr deref when pcihost_wrapper is used

Christoph Hellwig (7):
      xfs: cleanup log reservation calculactions
      xfs: clean up xlog_align
      xfs: fix access to upper inodes without inode64
      xfs: remove done roadmap item from xfs-delayed-logging-design.txt
      xfs: skip writeback from reclaim context
      xfs: improve xfs_isilocked
      virtio-blk: fix minimum number of S/G elements

Cory Maccarrone (1):
      omap: remove BUG_ON for disabled interrupts

Dan Carpenter (21):
      i915/intel_sdvo: remove unneeded null check
      i915: remove unneeded null checks
      be2net: add unlock on error path
      be2net: remove superfluous externs
      caif: unlock on error path in cfserl_receive()
      V4L/DVB: em28xx: remove unneeded null checks
      V4L/DVB: video/saa7134: remove duplicate break
      V4L/DVB: video/saa7134: change dprintk() to i2cdprintk()
      cciss: call BUG() earlier
      SFI: do not return freed pointer
      FS-Cache: Remove unneeded null checks
      Input: tps6507x-ts - a couple work queue cleanups
      e1000e: change logical negate to bitwise
      isdn/kcapi: return -EFAULT on copy_from_user errors
      tehuti: return -EFAULT on copy_to_user errors
      kobject: free memory if netlink_kernel_create() fails
      TTY/n_gsm: potential double lock
      vt_ioctl: return -EFAULT on copy_from_user errors
      Staging: rc2860: return -EFAULT on copy_to_user errors
      Staging: sep: return -EFAULT on copy_to_user errors
      fcntl: return -EFAULT if copy_to_user fails

Daniel J Blueman (2):
      i915: fix lock imbalance on error path...
      fix cpu_chain section mismatch...

Daniel Mack (10):
      ALSA: usb-audio: UAC2: clean up parsing of bmaControls
      ALSA: usb-audio: support partially write-protected UAC2 controls
      include/linux/usb/audio-v2.h: add more UAC2 details
      ALSA: usb-audio: fix selector unit string index accessor
      ALSA: usb-audio: parse clock topology of UAC2 devices
      ALSA: usb-audio: unify constants from specification
      ALSA: usb-audio: add UAC2 sepecific Feature Unit controls
      ALSA: usb-audio: clean up find_audio_control_unit()
      ALSA: usb-audio: export UAC2 clock selectors as mixer controls
      USB: ftdi_sio: fix DTR/RTS line modes

Daniel T Chen (4):
      ALSA: hda: Use LPIB for an ASUS device
      ALSA: hda: Use mb31 quirk for an iMac model
      ALSA: hda: Use LPIB for another mainboard
      ALSA: hda: Use LPIB for ASUS M2V

Daniel Vetter (1):
      drm/i915: combine all small integers into one single bitfield

Daniele Lacamera (1):
      TCP: tcp_hybla: Fix integer overflow in slow start increment

Dave Airlie (3):
      drm/nouveau: attempt to get bios from ACPI v3
      drm/nouveau: fixup confusion over which handle the DSM is hanging off.
      drm/kms: disable/enable poll around switcheroo on/off

Dave Chinner (3):
      xfs: Check new inode size is OK before preallocating
      xfs: fix might_sleep() warning when initialising per-ag tree
      xfs: fix race in inode cluster freeing failing to stale inodes

David Rientjes (1):
      kbuild: improve version string logic

David S. Miller (4):
      n2_crypto: Fix build after of_device/of_platform_driver changes.
      n2_crypto: Fix MAU kmem_cache name.
      n2_crypto: Plumb fallback ahash requests properly.
      greth: Fix build after OF device conversions.

Denis Kirjanov (4):
      ksz884x: convert to netdev_tx_t
      ksz884x: Add missing validate_addr hook
      AFS: Fix possible null pointer dereference in afs_alloc_server()
      powerpc/cell: Fix integer constant warning

Denys Vlasenko (18):
      Rename .bss.stack to .bss..stack.
      Rename .data.gate to .data..gate.
      Rename .data.init_irqstack to .data..init_irqstack.
      Rename .data..patch.XXX to .data..patch.XXX.
      Rename .data[.percpu][.XXX] to .data[..percpu][..XXX].
      Rename .data.read_mostly to .data..read_mostly.
      Rename .data.vmpages and .data.vm0.XXX to .data..vmpages and .data..vm0.XXX.
      Rename .rodata.compressed to .rodata..compressed.
      Rename .text.ivt to .text..ivt.
      Rename .text.lock to .text..lock.
      Rename .text.page_aligned to .text..page_aligned.
      Rename .text.startup to .text..startup.
      Rename .data.nosave to .data..nosave.
      Rename .data.init to .data..init.
      Rename .data.initvect to .data..initvect.
      Rename .data.lock_aligned to .data..lock_aligned.
      Rename special text sections in arch/frv from .text.XXX to .text..XXX.
      Rename .text.start to .text..start.

Dmitri Belimov (1):
      V4L/DVB: tm6000, reset I2C bus function

Dmitry Monakhov (1):
      ext4: Fix remaining racy updates of EXT4_I(inode)->i_flags

Dmitry Torokhov (2):
      Input: ads7846 - fix compiler warning in ads7846_probe()
      vmware balloon: clamp number of collected non-balloonable pages

Don Zickus (1):
      scripts: change scripts to use system python instead of env

Eric Anholt (3):
      drm/i915: Move ringbuffer-related code to intel_ringbuffer.c.
      drm/i915: Rename dev_priv->ring to dev_priv->render_ring.
      drm/i915: Clean up leftover bits from hws move to ring structure.

Eric Bénard (1):
      net/fec: fix pm to survive to suspend/resume

Eric Dumazet (6):
      net: fix sk_forward_alloc corruptions
      netfilter: xtables: stackptr should be percpu
      net: sock_queue_err_skb() dont mess with sk_forward_alloc
      xfrm: force a dst reference in __xfrm_route_forward()
      rps: tcp: fix rps_sock_flow_table table updates
      tcp: use correct net ns in cookie_v4_check()

Eric Sandeen (2):
      xfs: replace E2BIG with EFBIG where appropriate
      xfs: be more explicit if RT mount fails due to config

FEJES Jozsef (1):
      kbuild: deb-pkg md5sums

Florian Westphal (1):
      syncookies: remove Kconfig text line about disabled-by-default

Frank Pan (1):
      tty: fix a little bug in scrup, vt.c

Frederic Weisbecker (4):
      perf_events: Fix unincremented buffer base on partial copy
      perf: Process comm events by tid
      perf: Use event__process_task from perf sched
      perf: Do the comm inheritance per thread in event__process_task

Graf Yang (1):
      serial: bfin_5xx: IRDA is not affected by anomaly 05000230

Grant Likely (4):
      of/usb: fix build error due to of_node pointer move
      of/spi: Fix build failure on spi_ppc4xx.c
      of/rtc: rtc-mpc5121.c: Fix build failures
      usb: fix ehci_hcd build failure when both generic-OF and xilinx is selected

Greg Thelen (2):
      kbuild: Fix checking of scm-identifier variable
      cgroups: alloc_css_id() increments hierarchy depth

Guennadi Liakhovetski (2):
      tags: include headers before source files
      fbdev: fix erroneous index in drivers/video/sh_mobile_lcdcfb.c

Guy Martin (2):
      V4L/DVB: TT CT-3650 DVB-C support
      V4L/DVB: stv6110x: Fix kernel null pointer deref

Haiying Wang (1):
      powerpc/85xx: Add P1021MDS board support

Hans Verkuil (30):
      V4L/DVB: bw-qcam: convert to V4L2
      V4L/DVB: c-qcam: convert to V4L2
      V4L/DVB: V4L2 Spec: Improve the VIDIOC_QUERY_DV_PRESET description
      V4L/DVB: saa7115: add s_mbus_fmt op
      V4L/DVB: cx25840: add support for s_mbus_fmt
      V4L/DVB: saa717x: add support for s_mbus_fmt
      V4L/DVB: ivtv: convert to use s_mbus_fmt
      V4L/DVB: cx18: add s_mbus_fmt support
      V4L/DVB: cx18: remove old g/s_fmt from the cx18_av subdev
      V4L/DVB: saa7127: remove obsolete g_fmt support
      V4L/DVB: saa717x: remove obsolete s_fmt op
      V4L/DVB: v4l2-mediabus.h: add two helper functions
      V4L/DVB: saa6752hs: add g/s_mbus_fmt support
      V4L/DVB: saa7134: convert to use the new mbus API
      V4L/DVB: pvrusb2: convert to s_mbus_fmt
      V4L/DVB: cx23885: convert to s_mbus_fmt
      V4L/DVB: cx231xx: convert to s_mbus_fmt
      V4L/DVB: cx24850: remove obsolete g/s_fmt ops
      V4L/DVB: saa7115: remove obsolete g/s_fmt ops
      V4L/DVB: v4l2-mediabus.h: added V4L2_MBUS_FMT_SGRBG8_1X8
      V4L/DVB: mt9v011: add enum/try/s_mbus_fmt support
      V4L/DVB: tvp5150: remove obsolete g/s_fmt ops
      V4L/DVB: au8522_decoder: g/s_fmt doesn't do anything: remove
      V4L/DVB: v4l2-subdev.h: fix enum_mbus_fmt prototype
      V4L/DVB: tvp514x: do NOT change the std as a side effect
      V4L/DVB: tvp514x: make std_list const
      V4L/DVB: tvp514x: there is only one supported format, so simplify the code
      V4L/DVB: tvp514x: add missing newlines
      V4L/DVB: tvp514x: remove obsolete fmt_list
      V4L/DVB: tvp514x: simplify try/g/s_fmt handling

Heiko Carstens (3):
      fs/compat_rw_copy_check_uvector: add missing compat_ptr call
      ramoops: add HAS_IOMEM dependency
      lib: add s390 to atomic64_dec_if_positive archs

Henk de Groot (1):
      Staging: wlags49_h2, wlags49_h25: fixed Kconfig dependencies

Hermann Gausterer (1):
      V4L/DVB: Technotrend S2-3200 ships with a TT 1500 remote

Herton Ronaldo Krzesinski (2):
      V4L/DVB: saa7134: add support for Avermedia M733A
      V4L/DVB: saa7134: add RM-K6 remote control support for Avermedia M135A

Himanshu Chauhan (1):
      scripts/kallsyms: suppress build warning

Huang Weiyi (5):
      sh: remove duplicated #include
      xfs: xfs_trace.c: remove duplicated #include
      xfs: remove duplicated #include
      V4L/DVB: ngene: remove unused #include <linux/version.h>
      X25: remove duplicated #include

Hui Zhu (3):
      markup_oops.pl: fix for faulting instruction in the first line of a range
      markup_oops.pl: add options to improve cross-sompilation environments
      markup_oops.pl: minor fixes

Ian Abbott (7):
      Staging: comedi: Give the addi_apci_* drivers different driver names
      Staging: comedi: addi-data: don't overwrite name for request_irq()
      Staging: comedi: adv_pci_dio: Support Advantech PCI-1735U
      Staging: comedi: amplc_dio200: Protect counter subdevice with spinlock
      Staging: comedi: don't write to buffer if command finished
      Staging: comedi: COMEDI_BUFINFO with no async - report no bytes read or written
      Staging: comedi: For COMEDI_BUFINFO, check access to command

Ian Armstrong (4):
      V4L/DVB: cx2341x: Report correct temporal setting for log-status
      V4L/DVB: ivtvfb : Module load / unload fixes
      V4L/DVB: ivtv: Avoid accidental video standard change
      V4L/DVB: ivtv: Timing tweaks and code re-order to try and improve stability

Ian Campbell (2):
      xen: ensure timer tick is resumed even on CPU driving the resume
      xen: avoid allocation causing potential swap activity on the resume path

Igor M. Liplianin (1):
      V4L/DVB: Bug fix: make IR work again for dm1105

Jakob Bornecrantz (12):
      drm/vmwgfx: Assume larger framebuffer max size.
      drm/vmwgfx: Fix single framebuffer detection.
      drm/vmwgfx: Make sure to unpin old and pin new framebuffer.
      drm/vmwgfx: Get connector status from detection function.
      drm/vmwgfx: Support older hardware.
      drm/vmwgfx: Remove duplicate member from struct vmw_legacy_display_unit.
      drm/vmwgfx: Don't use SVGA_REG_ENABLE in modesetting code.
      drm/vmwgfx: Some modesetting cleanups and fixes.
      drm/vmwgfx: Unpause overlay on update.
      drm/vmwgfx: Print warnings in kernel log about bo pinning that fails.
      drm/vmwgfx: Fix framebuffer modesetting
      drm/vmwgfx: Allow userspace to change default layout. Bump minor.

Jan III Sobieski (1):
      add random binaries to .gitignore

Jarod Wilson (2):
      V4L/DVB: IR/imon: clean up usage of bools
      V4L/DVB: IR/imon: add auto-config for 0xffdc rf device

Jaroslav Kysela (1):
      ALSA: hda-intel - fix wallclk variable update and condition

Jason Gunthorpe (1):
      kbuild: Include gen_initramfs_list.sh and the file list in the .d file

Jean Delvare (5):
      V4L/DVB: FusionHDTV: Use quick reads for I2C IR device probing
      i2c: Share the I2C device presence detection code
      i2c: Check for address validity on client registration
      i2c: Document reserved I2C addresses
      i2c: Rename i2c_check_addr to i2c_check_addr_busy

Jean-François Moine (2):
      V4L/DVB: gspca - sonixb: Have 0c45:602e handled by sonixb instead of sn9c102
      V4L/DVB: gspca - sonixj: Add information about some potential JPEG webcams

Jeff Kirsher (1):
      ixgbe: return IXGBE_ERR_RAR_INDEX when out of range

Jeff Layton (1):
      cifs: fix page refcount leak

Jens Axboe (8):
      pipe: F_SETPIPE_SZ should return -EPERM for non-root
      pipe: make F_{GET,SET}PIPE_SZ deal with byte sizes
      Revert "writeback: ensure that WB_SYNC_NONE writeback with sb pinned is sync"
      Revert "writeback: fix WB_SYNC_NONE writeback from umount"
      block: disable preemption before using sched_clock()
      pipe: adjust minimum pipe size to 1 page
      pipe: change the privilege required for growing a pipe beyond system max
      pipe: change /proc/sys/fs/pipe-max-pages to byte sized interface

Jesper Nilsson (6):
      CRISv32: Remove duplicated Kconfig items.
      CRISv32: Fix RS485 port 4 CD Kconfig item.
      CRISv10: Trivial fixes.
      CRISv10: Whitespace fixes for hw_settings.S
      CRIS: Simplify param.h by simply including <asm-generic/param.h>
      CRIS: Don't use mask_irq as symbol name

Jesse Barnes (2):
      drm/i915: add timeout to FBC disable waits
      drm/i915: add power monitoring support

Jiafu He (1):
      kbuild: Fix linking error built-in.o no such file or directory

Jiri Slaby (1):
      EDAC: add __init to i7core_xeon_pci_fixup

Joe Perches (2):
      Makefile: Document ability to make file.lst and file.S
      net/ipv4/tcp_input.c: fix compilation breakage when FASTRETRANS_DEBUG > 1

Joerg Roedel (2):
      x86/amd-iommu: Fix crash when request_mem_region fails
      x86/amd-iommu: Fall back to GART if initialization fails

Johan Hovold (1):
      USB: mos7840: fix null-pointer dereference

Johannes Berg (3):
      mac80211: make a function static
      mac80211: fix blockack-req processing
      mac80211: fix dialog token allocator

John Fastabend (3):
      net: init_vlan should not copy slave or master flags
      net: fix conflict between null_or_orig and null_or_bond
      ixgbe: only check pfc bits in hang logic if pfc is enabled

John Kacur (2):
      tags: Fix spelling error in comment (is->if)
      tags: Add the ability to make tags for all archs using "all"

John Saalwaechter (1):
      scripts: use %_tmppath in "make rpm-pkg"

John W. Linville (1):
      Revert "rt2x00: Fix rt2800usb TX descriptor writing."

Julia Lawall (10):
      arch/x86/kernel: Add missing spin_unlock
      fs/xfs/quota: Add missing mutex_unlock
      drivers/isdn/hardware/mISDN: Add missing spin_unlock
      net/rds: Add missing mutex_unlock
      V4L/DVB: drivers/media: Use kzalloc
      V4L/DVB: drivers/media: Eliminate a NULL pointer dereference
      drivers/isdn/hardware/mISDN: Use GFP_ATOMIC when a lock is held
      USB: serial: digi_acceleport: Eliminate a NULL pointer dereference
      staging: Use GFP_ATOMIC when a lock is held
      Staging: Eliminate a NULL pointer dereference

Justin P. Mattock (1):
      ath9k: Fix ath_print in xmit for hardware reset.

KOSAKI Motohiro (1):
      vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure

Keith Mannthey (2):
      i7core_edac: Fix ecc enable shift
      i7core_edac: Probe on Xeons eariler

Kirill Smelkov (1):
      kbuild: fix a couple of typos in Documentation

Konstantin Khlebnikov (2):
      cfq-iosched: remove dead_key from cfq_io_context
      cfq-iosched: compact io_context radix_tree

Konstantin Stepanyuk (1):
      perf hist: fix objdump output parsing

Krzysztof Halasa (1):
      drm/i915: Add support for interlaced display.

Kuninori Morimoto (4):
      sh: make sure static declaration on mach-ap325rxa
      sh: make sure static declaration on mach-ecovec24
      sh: make sure static declaration on mach-migor
      sh: make sure static declaration on ms7724se

Lan Chunhe-B25806 (1):
      powerpc/fsl_msi: Add multiple MSI bank support

Lars Ellenberg (5):
      drbd: improve network latency, TCP_QUICKACK
      drbd: need to set socket bufsize early to take effect
      drbd: improve usage of MSG_MORE
      drbd: fix hang on local read errors while disconnected
      drbd: use drbd specific ratelimit instead of global printk_ratelimit

Len Brown (1):
      ACPI: update feature-removal.txt to reflect deleted acpi=ht option

Li Peng (1):
      drm/i915: Add CxSR support on Pineview DDR3

Li Yang (5):
      powerpc/fsl_msi: fix the conflict of virt_msir's chip_data
      powerpc/fsl_msi: enable msi allocation in all banks
      powerpc/fsl_msi: enable msi sharing through AMP OSes
      powerpc/fsl_msi: add removal path and probe failing path
      powerpc/85xx: Change MPC8572DS camp dtses for MSI sharing

Li Zefan (9):
      kconfig: recalc symbol value before showing search results
      kconfig: some small fixes
      kconfig: fix zconfdump()
      gconfig: remove dbg_print_ptype() and dbg_print_stype()
      gconfig: remove show_debug option
      menuconfig: add support to show hidden options which have prompts
      gconfig: add support to show hidden options that have prompts
      drm/i915: Convert more trace events to DEFINE_EVENT
      xfs: convert more trace events to DEFINE_EVENT

Linus Torvalds (3):
      module: Make the 'usage' lists be two-way
      module: move find_module check to end
      Linux 2.6.35-rc2

Maarten Maathuis (1):
      drm/nouveau: allow cursor image and position to survive suspend

Magnus Damm (4):
      sh: allow romImage data between head.S and the zero page
      sh: prepare MMCIF driver header file
      sh: add boot code to MMCIF driver header
      sh: add romImage MMCIF boot for sh7724 and Ecovec V2

Marcin Kościelnicki (1):
      drm/nouveau: Add getparam for current PTIMER time.

Marek Lindner (1):
      Staging: batman-adv: fix rogue packets on shutdown

Mark Brown (2):
      Input: s3c2410_ts - fix build error due to ADC Kconfig rename
      Input: s3c2410_ts - tone down logging

Mark Ware (1):
      fs_enet: Adjust BDs after tx error

Martin Homuth-Rosemann (1):
      Staging: comedi - correct parameter gainlkup for DAQCard-6024E in driver ni_mio_cs.c

Mauro Carvalho Chehab (72):
      i7core_edac: Add an EDAC memory controller driver for Nehalem chipsets
      i7core_edac: Add error insertion code for Nehalem
      i7core_edac: Add more status functions to EDAC driver
      i7core_edac: Registers all supported MC functions
      i7core_edac: Show read/write virtual/physical channel association
      i7core_edac: A few fixes at error injection code
      i7core_edac: need mci->edac_check, otherwise module removal doesn't work
      i7core_edac: Add a memory check routine, based on device 3 function 4
      i7core_edac: Add additional tests for error detection
      i7core_edac: Properly fill struct csrow_info
      i7core_edac: Improve error handling
      i7core_edac: Add more information about each active dimm
      i7core_edac: Get more info about the memory DIMMs
      i7core_edac: Memory info fixes and preparation for properly filling cswrow data
      i7core_edac: fill csrows edac sysfs info
      i7core_edac: CodingStyle fixes
      edac_mce: Add an interface driver to report mce errors via edac
      edac/Kconfig: edac_mce can't be module
      i7core_edac: Add edac_mce glue
      i7core_edac: Adds write unlock to MC registers
      i7core_edac: Add a code to probe Xeon 55xx bus
      i7core_edac: add support for more than one MC socket
      i7core_edac: maps all sockets as if ther are one MC controller
      i7core_edac: decode mcelog error and send it via edac interface
      i7core_edac: some fixes at memory error parser
      i7core: fix probing on Xeon55xx
      i7core: check if the memory error is fatal or non-fatal
      i7core: enrich error information based on memory transaction type
      i7core: fix get_devices routine for Xeon55xx
      i7core: better document i7core_get_active_channels()
      i7core: add socket info at the debug msg
      i7core: remove some uneeded noisy debug messages
      i7core_edac: Some cleanups at displayed info
      i7core_edac: some fixes at error injection code
      i7core_edac: fix error codes for sysfs error injection interface
      i7core_edac: fix error injection
      Documentation/edac.txt: Add Nehalem specific EDAC characteristics
      i7core_edac: CodingSyle fixes/cleanups
      i7core_edac: Print an error message if pci register fails
      i7core_edac: Use Device 3 function 2 to report errors with RDIMM's
      i7core: Use registered memories per processor
      i7core_edac: Improve corrected_error_counts output for RDIMM
      i7core: temporary workaround to allow it to compile against 2.6.30
      Dynamically allocate memory for PCI devices
      i7core_edac: create one mc per socket/QPI
      i7core_edac: sanity check: print a warning if a mcelog is ignored
      i7core_edac: a few fixes for multiple mc's
      Documentation/edac.txt: Improve it to reflect the latest changes at the driver
      i7core_edac: Fix a bug when printing error counts with RDIMMs
      i7core_edac: at remove, don't remove all pci devices at once
      i7core_edac: remove static counter for max sockets
      i7core_edac: change remove module strategy
      i7core_edac: We need to use list_for_each_entry_safe to avoid errors
      i7core_edac: Avoid printing a warning when debug is disabled
      edac_core: Allow the creation of sysfs groups
      i7core_edac: Add support for sysfs addrmatch group
      edac: store/show methods for device groups weren't working
      edac: Don't create csrow entries on instance groups
      i7core_edac: Convert UDIMM error counters into a proper sysfs group
      Documentation/edac.txt: Reflect the sysfs changes at the document
      edac: Create an unique instance for each kobj
      i7core_edac: Use a lockless ringbuffer
      i7core_edac: Better parse "any" addrmask
      i7core_edac: First store, then increment
      i7core_edac: Fix ringbuffer maxsize
      i7core_edac: PCI device is called NONCORE, instead of NOCORE
      i7core_edac: Use a more generic approach for probing PCI devices
      i7core_edac: Add initial support for Lynnfield
      i7core: add support for Lynnfield alternate address
      i7core_edac: Fix wrong device id for channel 1 devices
      i7core_edac: Add support for X5670
      i7core_edac: Better describe the supported devices

Maurus Cuelenaere (3):
      USB: s3c_hsotg: define USB_GADGET_DUALSPEED in Kconfig
      rtc: s3c: initialize driver data before using it
      rtc: s3c: initialize s3c_rtc_cpu_type before using it

Michael Chan (1):
      bnx2: Fix hang during rmmod bnx2.

Michael Guntsche (1):
      watchdog: Fix build failure with OF changes

Michael S. Tsirkin (1):
      virtio-net: pass gfp to add_buf

Michal Marek (8):
      nconfig: mark local functions as such
      scripts/mkcompile_h: don't test for hardcoded paths
      MAINTAINERS: add a few more patterns to kbuild
      tags: Use $SRCARCH
      kbuild: Do not unnecessarily regenerate modules.builtin
      Revert "kbuild: specify absolute paths for cscope"
      kbuild: Generate modules.builtin in make modules_install
      kbuild: Revert part of e8d400a to resolve a conflict

Mike Frysinger (5):
      USB: isp1362: fix inw warning on Blackfin systems
      Staging: adis16255: fix typo in Kconfig
      Staging: adis16255: add proper section markings to hotplug funcs
      fs/binfmt_flat.c: split the stack & data alignments
      flat: fix unmap len in load error path

Mike Isely (7):
      V4L/DVB: pvrusb2: Fix Gotview hardware support
      V4L/DVB: pvrusb2: Avoid using stack allocated buffers when performing USB I/O
      V4L/DVB: pvrusb2: New feature to mark specific hardware support as experimental
      V4L/DVB: pvrusb2: Fix kernel oops at device unregistration
      V4L/DVB: pvrusb2: Fix USB parent device reference count
      V4L/DVB: pvrusb2: Fix minor internal array allocation
      V4L/DVB: pvrusb2: Fix kernel oops on device tear-down

Mike Snitzer (3):
      block: Adjust elv_iosched_show to return "none" for bio-based DM
      block: avoid unconditionally freeing previously allocated request_queue
      block: make blk_init_free_list and elevator_init idempotent

Mikulas Patocka (1):
      Fix colors for Mach64

Nick Piggin (9):
      fs/splice.c: fix mapping_gfp_mask usage
      brd: support discard
      fix setattr error handling in sysfs, configfs
      fix setattr error handling in sysfs, configfs
      fix truncate inode time modification breakage
      frv: invoke oom-killer from page fault
      m32r: invoke oom-killer from page fault
      mn10300: invoke oom-killer from page fault
      xtensa: invoke oom-killer from page fault

Nicolas Kaiser (1):
      drm: fix typos in Linux DRM Developer's Guide

Nir Tzachar (1):
      nconfig: minor fix

Oleg Nesterov (1):
      sys_personality: change sys_personality() to accept "unsigned int" instead of u_long

Oliver Endriss (6):
      V4L/DVB: ngene: Support new device 'Digital Devices DuoFlex S2 miniPCIe'
      V4L/DVB: ngene: Do not call demuxer with interrupts disabled
      V4L/DVB: ngene: Implement support for MSI
      V4L/DVB: ngene: Make command timeout workaround configurable
      V4L/DVB: ngene: MSI cleanup
      V4L/DVB: ngene: Remove debug message

Olof Johansson (1):
      powerpc/pasemi: Update MAINTAINERS file

Paul Mackerras (1):
      agp/uninorth: Fix oops caused by flushing too much

Paul Mundt (11):
      serial: sh-sci: fix up serial DMA build.
      sh: handle early calls to return_address() when using dwarf unwinder.
      input: serio: disable i8042 for non-cayman sh platforms.
      usb: gadget: m66592-udc pio to mmio accessor conversion.
      usb: gadget: r8a66597-udc pio to mmio accessor conversion.
      usb: r8a66597-hcd pio to mmio accessor conversion.
      sh: support for platforms without PIO.
      sh: mach-sdk7786: conditionally disable PIO support.
      sh: PIO disabling for x3proto and urquell.
      clocksource: sh_cmt: compute mult and shift before registration
      sh: Make intc messages consistent via pr_fmt.

Peter Zijlstra (7):
      perf_events: Fix races and clean up perf_event and perf_mmap_data interaction
      perf_events: Fix races in group composition
      perf_events, trace: Fix probe unregister race
      perf_events, trace: Fix perf_trace_destroy(), mutex went missing
      sched: Fix wake_affine() vs RT tasks
      sched, trace: Fix sched_switch() prev_state argument
      perf: Fix crash in swevents

Phil Sutter (3):
      korina: fix deadlock on RX FIFO overrun
      korina: use netdev_alloc_skb_ip_align() here, too
      korina: count RX DMA OVR as rx_fifo_error

Philipp Kohlbecher (1):
      .gitignore: ignore *.lzo files

Philipp Reisner (4):
      drbd: Revert "drbd: Create new current UUID as late as possible"
      drbd: Removed the now empty w_io_error() function
      drbd: Reduce verbosity
      Preparing 8.3.8rc2

Pierre Tardy (1):
      perf scripts python: Give field dict to unhandled callback

Ping Cheng (1):
      Input: wacom - add Cintiq 21UX2 and Intuos4 WL

Prarit Bhargava (2):
      libertas: fix uninitialized variable warning
      V4L/DVB: Add notification to cxusb_dualdig4_rev2_frontend_attach() error 	handling

Rabin Vincent (1):
      scripts: add ARM support to decodecode

Rafael J. Wysocki (2):
      ACPI / EC / PM: Fix race between EC transactions and system suspend
      ACPI / EC / PM: Fix names of functions that block/unblock EC transactions

Randy Dunlap (7):
      edac: fix i7core build
      blktrace: Fix new kernel-doc warnings
      V4L/DVB: [-next] IR: fix ir-nec-decoder build, select BITREVERSE
      V4L/DVB: ak881x needs slab.h
      V4L/DVB: media/IR: nec-decoder needs to select BITREV
      Documentation/timers/hpet_example.c: only build on X86
      Staging: phison: depends on ATA_BMDMA

Richard Kennedy (1):
      gconfig: fix build failure on fedora 13

Roberto Sassu (1):
      wrong type for 'magic' argument in simple_fill_super()

Roland Dreier (1):
      epic100: Test __BIG_ENDIAN instead of (non-existent) CONFIG_BIG_ENDIAN

Roland McGrath (1):
      kconfig CROSS_COMPILE option

Rusty Russell (7):
      module: fix reference to mod->percpu after freeing module.
      module: fix kdb's illicit use of struct module_use.
      module: move sysfs exposure to end of load_module
      module: Make module sysfs functions private.
      module: make locking more fine-grained.
      module: verify_export_symbols under the lock
      module: fix bne2 "gave up waiting for init of module libcrc32c"

Ryusuke Konishi (2):
      nilfs2: fix style issue in nilfs_destroy_cachep
      nilfs2: remove obsolete declarations of cache constructor and destructor

Rémi Denis-Courmont (1):
      Phonet: listening socket lock protects the connected socket list

Sarah Sharp (3):
      USB: xhci: Wait for controller to be ready after reset.
      USB: xhci: Wait for host to start running.
      USB: xhci: Print NEC firmware version.

Sascha Hauer (2):
      ASoC: Add missing Kconfig entry for Phytec boards
      ASoC: MX31ads sound support should depend on MACH_MX31ADS_WM1133_EV1

Sathya Perla (1):
      be2net: convert hdr.timeout in be_cmd_loopback_test() to le32

Scott Feldman (1):
      enic: bug fix: make the set/get netlink VF_PORT support symmetrical

Scott Wood (1):
      powerpc/e500mc: Implement machine check handler.

Sebastian Andrzej Siewior (3):
      powerpc/fsl-booke: fix the case where we are not in the first page
      powerpc/fsl-booke: Move the entry setup code into a seperate file
      powerpc/kexec: Add support for FSL-BookE

Shaohua Li (1):
      cfq-iosched: fix an oops caused by slab leak

Sonic Zhang (1):
      serial: bfin_5xx: fix typo in IER check

Sreedhara DS (1):
      Staging: mid: Intel MID touch screen driver

Stefan Richter (1):
      libata-sff: trivial corrections to Kconfig help text

Stefan Ringel (10):
      V4L/DVB: tm6000: add extension module support
      V4L/DVB: tm6000: Remove an extra ; symbol
      V4L/DVB: tm6000: bugfix incorrect size
      V4L/DVB: tm6000: add vbi message inside the type switch
      V4L/DVB: tm6000: bugfix video image
      V4L/DVB: tm6000: bugfix stabilizing urb data
      V4L/DVB: tm6000: Add control to the power led
      V4L/DVB: tm6000: Properly select the tuners
      V4L/DVB: tm6000: set variable dev_mode in function tm6000_start_stream
      V4L/DVB: tm6000: add DVB support for tuner xc5000

Stefan Roese (2):
      powerpc/44x: Add reset-type to katmai.dts
      powerpc/44x: Add basic ICON PPC440SPe board support

Steffen Klassert (1):
      net: check for refcount if pop a stacked dst_entry

Stepan Moskovchenko (1):
      Staging: add MSM framebuffer driver

Stephane Eranian (1):
      perf_events: Fix event scheduling issues introduced by transactional API

Stephen Hemminger (9):
      scripts: improve checkstack
      checkincludes: fix perlcritic warnings
      checkversion: perl cleanup
      namespace: perlcritic warnings
      profile2linkerlist: fix perl warnings
      export_report: fix perl warnings
      headers_check: fix perl warnings
      headers_install: use local file handles
      headerdep: perlcritic warning

Stephen Rothwell (1):
      i7core_edac: do not export static functions

Sven Eckelmann (3):
      Staging: batman-adv: Call unregister_netdev on failures to get rtnl lock
      Staging: batman-adv: Don't call free_netdev twice
      Staging: batman-adv: Don't allocate icmp packet with GFP_KERNEL

Takashi Iwai (2):
      usb/gadget: Replace the old USB audio FU definitions in f_audio.c
      ALSA: asihpi - Fix uninitialized variable

Takuya Yoshikawa (1):
      binfmt_elf_fdpic: Fix clear_user() error handling

Tejun Heo (5):
      sata_via: magic vt6421 fix for transmission problems w/ WD drives
      sata_nv: don't diddle with nIEN on mcp55
      SCSI: implement sd_unlock_native_capacity()
      libata: use the enlarged capacity after late HPA unlock
      libata: implement on-demand HPA unlocking

Thadeu Lima de Souza Cascardo (1):
      fbdev: fix frame buffer devices menu

Theodore Ts'o (1):
      ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files

Thomas Abraham (1):
      USB: s3c: Enable soft disconnect during initialization

Thomas Hellstrom (6):
      drm/vmwgfx: Add kernel throttling support. Bump minor.
      drm/vmwgfx: Reserve first part of VRAM for framebuffer.
      drm/vmwgfx: Remove some leftover debug messages.
      drm/ttm: Fix cached TTM page allocation.
      drm/ttm: Fix ttm_page_alloc.c
      drm/vmwgfx: Fix vga save / restore with display topology.

Tiago Vignatti (2):
      vgaarb: convert pr_devel() to pr_debug()
      vgaarb: use MIT license

Tim Abbott (5):
      Rename .data.cacheline_aligned to .data..cacheline_aligned.
      Rename .data.init_task to .data..init_task.
      powerpc: remove unused __page_aligned definition.
      Rename .data.page_aligned to .data..page_aligned.
      Rename .bss.page_aligned to .bss..page_aligned.

Tirumala Marri (1):
      powerpc/44x: Adding PCI-E support for PowerPC 460SX based SOC.

Tobias Klauser (4):
      drm/i915: Storage class should be before const qualifier
      altera_uart: Don't take spinlock in already protected functions
      altera_uart: Simplify altera_uart_console_putc
      serial: altera_uart: Proper section for altera_uart_remove

Tony Luck (1):
      i7core_edac: don't free on success

Uwe Kleine-König (7):
      modpost: members of *driver structs should not point to __init functions
      modpost: define ALL_XXX{IN,EX}IT_SECTIONS
      modpost: give most mismatch constants a better name
      modpost: pass around const struct sectioncheck * instead of enum mismatch
      modpost: remove now unused NO_MISMATCH constant
      modpost: make symbol white list a per mismatch type variable
      modpost: don't allow *driver to reference .init.*

Vadim Bendebury (вб) (1):
      menuconfig: wrap long help lines

Vasanthakumar Thiagarajan (1):
      ath9k: Fix bug in the way "bf_tx_aborted" of struct ath_buf is used

Venkatesh Pallipadi (1):
      ACPI: Eliminate us to pm ticks conversion in common path

Vernon Mauery (2):
      Always call i7core_[ur]dimm_check_mc_ecc_err
      Add support for Westmere to i7core_edac driver

Warren Bosworth Focke (1):
      V4L/DVB: gspca - sonixj: Add webcam 0c45:60ce

Wolfram Sang (3):
      of/powerpc: fix fsl_msi device node pointer
      i2c/busses: Move two drivers to embedded section
      i2c: Remove all i2c_set_clientdata(client, NULL) in drivers

Wu Zhangjin (1):
      scripts/Makefile.lib: Align the output of LZO

Xiaotian Feng (1):
      netfilter: don't xt_jumpstack_alloc twice in xt_register_table

Yegor Yefremov (1):
      serial: add support for various Titan PCI cards

Yusuke Goda (1):
      sh: Add support MMCIF for ecovec

Zhao Yakui (1):
      ACPI: Fix the incorrect calculation about C-state idle time

Zhenyu Wang (3):
      drm/i915: Fix HDMI mode select for Cougarpoint PCH
      drm/i915: Fix PIPE_CONTROL command on Sandybridge
      drm/i915: Unmask interrupt for render engine on Sandybridge

Zou Nan hai (4):
      drm/i915: introduce intel_ring_buffer structure (V2)
      drm/i915: convert some gem structures to per-ring V2
      drm/i915: implement BSD ring buffer V2
      drm/i915: add HAS_BSD check to i915_getparam

apatard@mandriva.com (1):
      staging: Add framebuffer driver for XGI chipsets

nir.tzachar@gmail.com (1):
      kconfig: new configuration interface (nconfig)
