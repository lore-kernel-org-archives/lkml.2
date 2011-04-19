Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1DSE6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 00:58:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab1DSE6H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 00:58:07 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Apr 2011 21:57:26 -0700
Message-ID: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com>
Subject: Linux 2.6.39-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So things have sadly not continued to calm down even further. We had
more commits in -rc4 than we had in -rc3, and I sincerely hope that
upward trend doesn't continue.

That said, so far the only thing that has really caused problems this
release cycle has been the block layer plugging changes, and as of
-rc4 the issues we had with MD should hopefully now be behind us. So
we're making progress on that front too.

The plugging code still seems to trigger some issue with what looks
like an infinite stream of disk-change notifications on CD-ROMs - but
Jens is hopefully going to squish that problem soon. In the meantime,
you can avoid the problem by either running SMP or having preemption
enabled.

Other than that? We may have a bit more commits than in -rc3, but it
hasn't been _too_ bad. There's certainly nothing overly exciting:
aside from the block/MD fixups, we've got some filesystem updates
(btrfs, cifs and ubifs) and some driver updates (the largest chunk of
which is actually a duplicate driver removal). USB, some KMS, nothing
really earthshaking.

Shortlog appended for the curious.

                 Linus

---
Abhilash Kesavan (2):
      ARM: S5P: Remove unused s3c_pm_check_resume_pin
      ARM: SAMSUNG: Fix build failure in PM CRC check code

Alan Stern (1):
      USB: EHCI: unlink unused QHs when the controller is stopped

Alberto Mardegan (1):
      samsung-laptop: Samsung R410P backlight driver

Alex Deucher (8):
      drm/radeon/kms: pll tweaks for rv6xx
      drm/radeon/kms: make radeon i2c put/get bytes less noisy
      drm/radeon/kms: clean up gart dummy page handling
      drm/radeon/kms: fix suspend on rv530 asics
      drm/radeon/kms: fix pcie_p callbacks on btc and cayman
      drm/radeon/kms: add voltage type to atom set voltage function
      drm/radeon/kms: properly program vddci on evergreen+
      i2c-algo-bit: Call pre/post_xfer for bit_test

Alexander Clouter (1):
      MAINTAINERS: add ARM/ts78xx-setup platform maintainer

Alexandre Bounine (2):
      RapidIO: add IDT CPS-1432 switch definitions
      RapidIO/mpc85xx: fix possible mport registration problems

Alexey Dobriyan (2):
      kstrtox: fix compile warnings in test
      kstrtox: simpler code in _kstrtoull()

Alexey Khoroshilov (1):
      USB: usb-gadget: unlock data->lock mutex on error path in ep_read()

Andi Kleen (1):
      mm: add VM counters for transparent hugepages

Andiry Xu (2):
      usbcore: Bug fix: system can't suspend with USB3.0 device
connected to USB3.0 hub
      xHCI: Implement AMD PLL quirk

Andreas Bießmann (1):
      avr32: add ATAG_BOARDINFO

Aneesh Kumar K.V (5):
      fs/9p: Fix revalidate to return correct value
      fs/9p: Use write_inode for data sync on server
      9p: revert tsyncfs related changes
      fs/9p: Fix error reported by coccicheck
      9p: Fix sparse error

Anton Blanchard (1):
      powerpc: Fix oops if scan_dispatch_log is called too early

Antonio Ospite (1):
      leds/leds-regulator.c: fix handling of already enabled regulators

Arne Jansen (1):
      btrfs: using cached extent_state in set/unlock combinations

Artem Bityutskiy (1):
      UBIFS: fix oops when R/O file-system is fsync'ed

Axel Lin (2):
      Input: twl4030_keypad - fix potential NULL dereference in
twl4030_kp_probe()
      drivers/rtc/rtc-mc13xxx.c: fix unterminated platform_device_id table

Ben Hutchings (2):
      avr32: Fix .size directive for cpu_enter_idle
      mm/thp: use conventional format for boolean attributes

Ben Skeggs (5):
      drm/nouveau: implement init table opcode 0x5c
      drm/nouveau: quirk for XFX GT-240X-YA
      drm/nv50: use "nv86" tlb flush method on everything except 0x50/0xac
      drm/nv50-nvc0: remove some code that doesn't belong here
      drm/nvc0: improve vm flush function

Benjamin Herrenschmidt (1):
      powerpc/powermac: Build fix with SMP and CPU hotplug

Bob Liu (1):
      ramfs: fix memleak on no-mmu arch

Catalin Marinas (3):
      ARM: 6866/1: Do not restrict HIGHPTE to !OUTER_CACHE
      ARM: 6867/1: Introduce THREAD_NOTIFY_COPY for copy_thread() hooks
      ARM: 6868/1: Preserve the VFP state during fork

Chase Douglas (1):
      Input: document event types and codes and their intended use

Chris Mason (4):
      Btrfs: make uncache_state unconditional
      Btrfs: don't force chunk allocation in find_free_extent
      Btrfs end_bio_extent_readpage should look for locked bits
      Btrfs: fix free space cache leak

Christian Simon (1):
      USB: ftdi_sio: Added IDs for CTI USB Serial Devices

Christoph Fritz (1):
      Input: h3600_ts - fix error handling at connect

Christoph Hellwig (2):
      block: cleanup the block plug helper functions
      block: add blk_run_queue_async

Christoph Lameter (1):
      vmstat: update comment regarding stat_threshold

Colin Cross (1):
      ARM: tegra: gpio: Fix unused variable warnings

Corentin Chary (3):
      asus-laptop: remove removed features from feature-removal-schedule.txt
      asus-wmi: swap input name and phys
      eeepc-wmi: add keys found on EeePC 1215T

Dan Carpenter (6):
      USB: musb: add missing unlock in cppi_interrupt()
      USB: musb: using 0 instead of NULL
      USB: musb: silence printk format warning
      USB: musb: dereferencing an iomem pointer
      usb: pch_udc: unlock on allocation failure
      USB: xhci: unsigned char never equals -1

Daniel J Blueman (1):
      fix user annotation in ioctl.c

Daniel Kiper (1):
      mm: optimize pfn calculation in online_page()

Darren Hart (1):
      futex: Set FLAGS_HAS_TIMEOUT during futex_wait restart setup

Dave Airlie (3):
      i915: restore only the mode of this driver on lastclose
      Revert "ttm: Utilize the DMA API for pages that have
TTM_PAGE_FLAG_DMA32 set."
      Revert "i915: restore only the mode of this driver on lastclose"

Dave Chinner (1):
      nfs: don't call __mark_inode_dirty while holding i_lock

David Brown (2):
      msm: Remove extraneous ffa device check
      msm: timer: fix missing return value

David Dillow (1):
      drm/nv50-nvc0: work around an evo channel hang that some people see

Dmitry Eremin-Solenikov (2):
      pcmcia: limit pxa2xx_balloon3 subdriver to balloon3 platform
      pcmcia: limit pxa2xx_trizeps4 subdriver to trizeps4 platform

Dmitry Torokhov (6):
      USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
      USB: xhci - fix unsafe macro definitions
      USB: xhci - remove excessive 'inline' markings
      USB: xhci: simplify logic of skipping missed isoc TDs
      USB: xhci - fix math in xhci_get_endpoint_interval()
      USB: xhci - also free streams when resetting devices

Emil Velikov (1):
      nv30: Fix parsing of perf table

Eric B Munson (1):
      powerpc/perf_event: Skip updating kernel counters if register
value shrinks

Eric Dumazet (2):
      perf: Fix a build error with some GCC versions
      memcg: fix mem_cgroup_rotate_reclaimable_page()

Eric Miao (1):
      ARM: pxa: convert incorrect IRQ_TO_IRQ() to irq_to_gpio()

Felipe Balbi (2):
      usb: musb: temporarily make it bool
      usb: musb: gadget: check the correct list_head

Feng Tang (1):
      RTC: rtc-mrst: follow on to the change of rtc_device_register()

Geert Uytterhoeven (1):
      m68k,m68knommu: Wire up name_to_handle_at, open_by_handle_at,
clock_adjtime, syncfs

Graf Yang (1):
      Blackfin: SMP: make all barriers handle cache issues

Greg Kroah-Hartman (2):
      samsung-laptop: add support for N230 model
      Revert "USB: isp1760-hcd: move imask clear after pending work is done"

Hans J. Koch (1):
      MAINTAINERS: change mail adress of Hans J. Koch

Haojian Zhuang (3):
      ARM: pxa: always clear LPM bits for PXA168 MFPR
      ARM: pxa: align NR_BUILTIN_GPIO with GPIO interrupt number
      ARM: mmp: align NR_BUILTIN_GPIO with gpio interrupt number

Harsh Prateek Bora (1):
      net/9p: nwname should be an unsigned int

Hema HK (1):
      usb: musb: Fix the crash issue during reboot

Hugh Dickins (1):
      tmpfs: fix off-by-one in max_blocks checks

Igor Mammedov (1):
      Input: xen-kbdfront - fix mouse getting stuck after save/restore

Jacob Pan (1):
      x86/mrst: Fix boot crash caused by incorrect pin to irq mapping

Jarod Wilson (1):
      Input: add KEY_IMAGES specifically for AL Image Browser

Jean Delvare (1):
      i2c: Improve deprecation warnings

Jean-Christophe PLAGNIOL-VILLARD (1):
      avr32: At32ap: pio fix typo "))" on gpio_irq_unmask prototype

Jeff Brown (2):
      Input: evdev - indicate buffer overrun with SYN_DROPPED
      Input: estimate number of events per packet

Jeff Layton (9):
      cifs: check for private_data before trying to put it
      cifs: replace /proc/fs/cifs/Experimental with a module parm
      cifs: always do is_path_accessible check in cifs_mount
      cifs: fix broken BCC check in is_valid_oplock_break
      cifs: set ra_pages in backing_dev_info
      cifs: clean up length checks in check2ndT2
      cifs: clean up various nits in unicode routines (try #2)
      cifs: wrap received signature check in srv_mutex
      cifs: don't allow mmap'ed pages to be dirtied while under
writeback (try #3)

Jeff Mahoney (1):
      fs/fhandle.c: add <linux/personality.h> for ia64

Jens Axboe (13):
      block: remove block_unplug_timer() trace point
      block: fixup block IO unplug trace call
      block: add comment on why we save and disable interrupts in
flush_plug_list()
      block: add callback function for unplug notification
      block: readd plug trace event
      block: kill queue_sync_plugs()
      block: move queue run on unplug to kblockd
      block: only force kblockd unplugging from the schedule() path
      block: let io_schedule() flush the plug inline
      block: make unplug timer trace event correspond to the schedule() unplug
      Revert "block: add callback function for unplug notification"
      block: drop queue lock before calling __blk_run_queue() for kblockd punt
      block: blk_delay_queue() should use kblockd workqueue

Jeremy Fitzhardinge (1):
      xen: just completely disable XSAVE

Jiri Kosina (1):
      brk: COMPAT_BRK: fix detection of randomized brk

Joe Perches (2):
      MAINTAINERS: update m68knommu patterns
      MAINTAINERS: update various tty patterns

Joerg Roedel (2):
      USB host: Fix lockdep warning in AMD PLL quirk
      x86, amd: Disable GartTlbWlkErr when BIOS forgets it

Johan Hovold (2):
      usb: musb: omap2430: fix build failure
      USB: ftdi_sio: add PID for OCT DK201 docking station

John Stultz (1):
      RTC: Fix early irqs caused by calling rtc_set_alarm too early

Josef Bacik (11):
      Btrfs: deal with the case that we run out of space in the cache
      Btrfs: only retry transaction reservation once
      Btrfs: map the inode item when doing fill_inode_item
      Btrfs: do not call btrfs_update_inode in endio if nothing changed
      Btrfs: don't split dio bios if we don't have to
      Btrfs: do not use async submit for small DIO io's
      Btrfs: reuse the extent_map we found when calling btrfs_get_extent
      Btrfs: check for duplicate iov_base's when doing dio reads
      Btrfs: check for duplicate iov_base's when doing dio reads
      Btrfs: avoid taking the trans_mutex in btrfs_end_transaction
      Btrfs: avoid taking the chunk_mutex in do_chunk_alloc

Justin P. Mattock (1):
      ARM: 6872/1: arch:common:Makefile Remove unused config in the Makefile.

KOSAKI Motohiro (3):
      vmscan: all_unreclaimable() use zone->all_unreclaimable as a name
      oom-kill: remove boost_dying_task_prio()
      x86, NUMA: Fix fakenuma boot failure

Keith Packard (1):
      thinkpad-acpi fails to load with newer Thinkpad X201s BIOS

Ken Chen (2):
      sched: Fix sched-domain avg_load calculation
      sched: Fix erroneous all_pinned logic

Konrad Rzeszutek Wilk (1):
      xen/debug: Don't be so verbose with WARN on 1-1 mapping errors.

Konstantin Khlebnikov (1):
      i915: select VIDEO_OUTPUT_CONTROL for ACPI_VIDEO

Kumar Gala (2):
      powerpc/book3e: Fix CPU feature handling on 64-bit e5500
      powerpc/85xx: disable Suspend support if SMP enabled

Lee, Chun-Yi (1):
      acer-wmi: Fix capitalisation of GUID in module alias

Li Zefan (2):
      Btrfs: Check if btrfs_next_leaf() returns error in btrfs_listxattr()
      Btrfs: Check if btrfs_next_leaf() returns error in btrfs_real_readdir()

Linus Torvalds (9):
      Revert "vfs: Export file system uuid via /proc/<pid>/mountinfo"
      vm: fix mlock() on stack guard page
      vfs: Re-introduce s_uuid in the superblock
      vm: fix vm_pgoff wrap in stack expansion
      block: don't flush plugged IO on forced preemtion scheduling
      vfs: fix incorrect dentry_update_name_case() BUG_ON() test
      next_pidmap: fix overflow condition
      proc: do proper range check on readdir offset
      Linux 2.6.39-rc4

Liu Yuan (1):
      block, blk-sysfs: Use the variable directly instead of a function call

Maksim Rayskiy (1):
      UBIFS: fix compilation warnings when compiling with gcc 4.5

Marcin Slusarz (1):
      drm/nouveau: fix oops on unload with disabled LVDS panel

Marco Chiappero (1):
      sony-laptop: keyboard backlight fixes

Marek Vasut (1):
      ARM: pxafb: Fix access to nonexistent member of pxafb_info

Marius B. Kotsbak (1):
      USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB modem.

Matt Fleming (1):
      avr32: init cannot ignore signals sent by force_sig_info()

Matthew Garrett (1):
      x86 platform drivers: Build fix for intel_pmic_gpio

Matthew Wilcox (1):
      USB: Fix unplug of device with active streams

Mattia Dongili (2):
      sony-laptop: fix early NULL pointer dereference
      sony-laptop: only show the handles sysfs file in debug mode

Maurus Cuelenaere (1):
      ARM: SAMSUNG: Fix warning 's3c_pm_show_resume_irqs' defined but not used

Mian Yousaf Kaukab (2):
      usb: musb: clear AUTOSET while clearing DMAENAB
      usb: musb: ux500: copy dma mask from platform device to musb device

Miao Xie (2):
      Btrfs: Fix incorrect inode nlink in btrfs_link()
      Btrfs: Check validity before setting an acl

Michael Ellerman (1):
      mm: check that we have the right vma in __access_remote_vm()

Michal Marek (2):
      staging: samsung-laptop has moved to platform/x86
      samsung-laptop: set backlight type

Michal Simek (1):
      usb: Fix Kconfig unmet dependencies for Microblaze EHCI

Michel Dänzer (2):
      radeon: Fix KMS CP writeback on big endian machines.
      drm/radeon: Fix KMS legacy backlight support if
CONFIG_BACKLIGHT_CLASS_DEVICE=m.

Mike Frysinger (4):
      RTC: add missing "return 0" in new alarm func for rtc-bfin.c
      USB: musb: blackfin: work around anomaly 05000450
      Blackfin: gptimers: fix thinko when disabling timers
      Blackfin: time-ts: ack gptimer sooner to avoid missing short ints

Milton Miller (1):
      fs: synchronize_rcu when unregister_filesystem success not failure

NeilBrown (8):
      block: splice plug list to local context
      block: Enhance new plugging support to support general callbacks
      md: use new plugging interface for RAID IO.
      md/dm - remove remains of plug_fn callback.
      md - remove old plugging code.
      md: provide generic support for handling unplug callbacks.
      md: incorporate new plugging into raid5.
      md: fix up raid1/raid10 unplugging.

Nicolas Kaiser (2):
      xen: events: fix error checks in bind_*_to_irqhandler()
      arm: tegra: fix error check in tegra2_clocks.c

Nicolas Pitre (3):
      ARM: 6877/1: the ADDR_NO_RANDOMIZE personality flag should be
honored with mmap()
      ARM: 6878/1: fix personality flag propagation across an exec
      ARM: 6879/1: fix personality test wrt usage of domain handlers

Nishanth Aravamudan (1):
      powerpc/pseries: Use a kmem cache for DTL buffers

Ole Henrik Jahren (1):
      avr32: fix deadlock when reading clock list in debugfs

Paul Friedrich (1):
      USB: ftdi_sio: add ids for Hameg HO720 and HO730

Paul Gortmaker (1):
      powerpc/kexec: Fix regression causing compile failure on UP

Paul Mundt (1):
      mm/page_alloc.c: silence build_all_zonelists() section mismatch

Prabhakar Kushwaha (2):
      powerpc/85xx: Don't add disabled PCIe devices
      powerpc: Check device status before adding serial device

Rafael J. Wysocki (1):
      PM / Hibernate: Introduce CONFIG_HIBERNATE_CALLBACKS

Randy Dunlap (3):
      msi-laptop: fix config-dependent build error
      usb: fix ips1760-hcd printk format warning
      MAINTAINERS: update STABLE BRANCH info

Richard Henderson (4):
      alpha: Don't force -Werror.
      alpha: Remove set but unused variables.
      alpha: Fix RTC interrupt setup.
      alpha: Fix uninitialized value in read_persistent_clock.

Richard Retanubun (1):
      USB: isp1760-hcd: move imask clear after pending work is done

Richard Weinberger (2):
      um: fix call tracer and bug handler
      um: disable CONFIG_CMPXCHG_LOCAL

Roy Spliet (1):
      drm/nouveau: correct memtiming table parsing for nv4x

Russell King (2):
      ARM: Make consolidated PM sleep code depend on PM_SLEEP
      ARM: Only allow PM_SLEEP with CPUs which support suspend

Sage Weil (1):
      libceph: fix linger request requeueing

Samuel Ortiz (1):
      mfd: Fetch cell pointer from platform_device->mfd_cell

Sarah Sharp (2):
      xhci: Fix NULL pointer deref in handle_port_status()
      xhci: Tell USB core both roothubs lost power.

Scott Wood (1):
      powerpc/e500mc: Remove CPU_FTR_MAYBE_CAN_NAP/CPU_FTR_MAYBE_CAN_DOZE

Sebastian Andrzej Siewior (2):
      x86/ce4100: Add reg property to bridges
      usb/gadget: don't leak hs_descriptors

Sergei Trofimovich (1):
      btrfs: properly handle overlapping areas in memmove_extent_buffer

Shan Haitao (1):
      xen: Allow PV-OPS kernel to detect whether XSAVE is supported

Shriram Rajagopalan (1):
      fix XEN_SAVE_RESTORE Kconfig dependencies

Shubhrajyoti D (1):
      Input: twl4030_keypad - avoid potential NULL-pointer dereference

Sonic Zhang (1):
      Blackfin: SMP: fix cache flush loop

Stefan Roese (1):
      powerpc: Don't write protect kernel text with
CONFIG_DYNAMIC_FTRACE enabled

Stephane Eranian (1):
      perf_event: Fix cgrp event scheduling bug in perf_enable_on_exec()

Stephen Boyd (1):
      ARM: 6876/1: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS

Steve French (6):
      Allow user names longer than 32 bytes
      Max share size is too small
      Elminate sparse __CHECK_ENDIAN__ warnings on port conversion
      various endian fixes to cifs
      [CIFS] cifs: clarify the meaning of tcpStatus == CifsGood
      [CIFS] Warn on requesting default security (ntlm) on mount

Steven Hardy (3):
      usb: Fix qcserial memory leak on rmmod
      usb: qcserial avoid pointing to freed memory
      usb: qcserial add missing errorpath kfrees

Thomas Gleixner (1):
      platform-drivers: x86: pmic: Restore the dropped buslock/unlock

Tim Chen (1):
      vfs: Fix absolute RCU path walk failures due to uninitialized seq number

Timo Warns (1):
      fs/partitions/ldm.c: fix oops caused by corrupted partition table

Uwe Kleine-König (1):
      don't check platform_get_irq's return value against zero

Valentin Longchamp (1):
      USB: fsl_qe_udc: send ZLP when zero flag and length % maxpacket == 0

Vasily Khoruzhick (1):
      RTC: Fix s3c compile error due to missing s3c_rtc_setpie

Wanlong Gao (2):
      fix the wrong argument of the functions definition
      drivers/misc/sgi-gru/grufile.c: fix the wrong members of gru_chip

Will Deacon (2):
      ARM: 6864/1: hw_breakpoint: clear DBGVCR out of reset
      ARM: 6865/1: perf: ensure pass through zero is counted on overflow

Xin Zhong (1):
      Btrfs: fix subvolume mount by name problem when default mount
subvolume is set

Yauheni Kaliuta (1):
      usb: gadget: eem: fix echo command processing

Yoichi Yuasa (1):
      USB: ohci-au1xxx: fix warning "__BIG_ENDIAN" is not defined

Yoshihiro Shimoda (1):
      usb: r8a66597-udc: fix spinlock usage

Yoshinori Sano (1):
      Btrfs: fix memory leaks in btrfs_new_inode()
