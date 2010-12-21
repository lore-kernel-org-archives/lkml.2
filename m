Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0LUTwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 14:52:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042Ab0LUTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:52:39 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Dec 2010 11:52:17 -0800
Message-ID: <AANLkTi=H7PHrLthxsM6x7bKPVHcn7bmH--7ehwJo1wLB@mail.gmail.com>
Subject: Linux 2.6.37-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

Nothing really earth-shattering in here, but the most notable part is
likely the PCI resource allocation changes, which revert back to
allocating things bottom-up, and then add some logic to avoid random
ACPI regions. That should fix the regressions in that area that we saw
after -rc1.

There's also a v4l update to fix some fallout from the BKL removal,
and fix up a few other regressions.

And a slightly uncomfortably large scheduler patch that should finally
fix the "report too high load average" problem that has been plaguing
the NOHZ case.

Other than that, there's all the normal random patches spread out. ARM
and MIPS updates, some lguest fixes, some fanotify stuff.. The
shortlog gives a reasonable view.

I'm still nervous about some of the regression reports for intel
graphics, so please keep testing and reporting. This is the last -rc
before xmas (or whatever your holiday may be), so now you all have a
few free days when you have nothing better to do than test out an -rc
release, right?

                             Linus

---

Al Viro (2):
      MIPS: Don't stomp on caller's ->regs[2] in copy_thread()
      Fix btrfs b0rkage

Alexey Zaytsev (1):
      fanotify: split version into version and metadata_len

Andre Przywara (1):
      KVM: enlarge number of possible CPUID leaves

Avi Kivity (1):
      KVM: Fix preemption counter leak in kvm_timer_init()

Bjorn Helgaas (9):
      Revert "PCI: fix pci_bus_alloc_resource() hang, prefer positive decode"
      Revert "x86: allocate space within a region top-down"
      Revert "x86/PCI: allocate space from the end of a region, not
the beginning"
      Revert "PCI: allocate bus resources from the top down"
      Revert "resources: support allocating space within a region from
the top down"
      resources: add arch hook for preventing allocation in reserved areas
      x86: avoid low BIOS area when allocating address space
      x86: avoid E820 regions when allocating address space
      x86: avoid high BIOS area when allocating address space

Brandon Philips (1):
      [media] bttv: remove unneeded locking comments

Chris Metcalf (2):
      arch/tile: handle CLONE_SETTLS in copy_thread(), not user space
      arch/tile: handle rt_sigreturn() more cleanly

Christian Glindkamp (1):
      at91: Refactor Stamp9G20 and PControl G20 board file

Dan Carpenter (1):
      perf: Fix off by one in perf_swevent_init()

David Daney (5):
      MIPS: Don't clobber personality high bits.
      MIPS: compat: Don't clobber personality bits in 32-bit sys_personality().
      MIPS: Rework GENERIC_HARDIRQS Kconfig.
      MIPS: Send proper signal and siginfo on FP emulator faults.
      MIPS: Add a CONFIG_FORCE_MAX_ZONEORDER Kconfig option.

David Henningsson (2):
      ALSA: HDA: Fix auto-mute on Lenovo Edge 14
      ALSA: HDA: Enable subwoofer on Asus G73Jw

Dmitry Artamonow (1):
      ASoC: fix deemphasis control in wm8904/55/60 codecs

Dmitry Torokhov (1):
      Input: define separate EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2

Eric Paris (5):
      fanotify: deny permissions when no event was sent
      fanotify: remove packed from access response message
      inotify: stop kernel memory leak on file creation failure
      fanotify: do not leak user reference on allocation failure
      fanotify: fill in the metadata_len field on struct fanotify_event_metadata

Florian Faber (1):
      USB: ftdi_sio: Add D.O.Tec PID

Florian Fainelli (2):
      MIPS: AR7: Fix double ar7_gpio_init declaration
      MIPS: AR7: Fix loops per jiffies on TNETD7200 devices

Greg Kroah-Hartman (1):
      Revert "USB: gadget: Allow function access to device ID data
during bind()"

H. Peter Anvin (2):
      x86, gcc-4.6: Use gcc -m options when building vdso
      x86-32: Make sure we can map all of lowmem if we need to

Hans Verkuil (15):
      [media] BKL: trivial BKL removal from V4L2 radio drivers
      [media] cadet: use unlocked_ioctl
      [media] tea5764: convert to unlocked_ioctl
      [media] si4713: convert to unlocked_ioctl
      [media] typhoon: convert to unlocked_ioctl
      [media] BKL: trivial ioctl -> unlocked_ioctl video driver conversions
      [media] sn9c102: convert to unlocked_ioctl
      [media] et61x251_core: trivial conversion to unlocked_ioctl
      [media] cafe_ccic: replace ioctl by unlocked_ioctl
      [media] sh_vou: convert to unlocked_ioctl
      [media] radio-timb: convert to unlocked_ioctl
      [media] cx18: convert to unlocked_ioctl
      [media] v4l2-dev: use mutex_lock_interruptible instead of plain mutex_lock
      [media] V4L: improve the BKL replacement heuristic
      [media] v4l2-dev: fix race condition

Hauke Mehrtens (5):
      MIPS: BCM47xx: Do not read config from CFE
      MIPS: BCM47xx: Fill values for b43 into SSB sprom
      MIPS: BCM47xx: Use sscanf for parsing mac address
      MIPS: BCM47xx: Swap serial console if ttyS1 was specified.
      SSB: Fix nvram_get on BCM47xx platform

Heiko Carstens (1):
      nohz: Fix get_next_timer_interrupt() vs cpu hotplug

Henry C Chang (3):
      ceph: fix direct-io on non-page-aligned buffers
      ceph: mark user pages dirty on direct-io reads
      ceph: handle partial result from get_user_pages

Ingo Molnar (1):
      sched: Remove debugging check

Jarkko Nikula (1):
      ASoC: Fix bias power down of non-DAPM codec

Jean-Francois Moine (6):
      [media] gspca - sonixj: Move bridge init to sd start
      [media] gspca - sonixj: Fix a bad probe exchange
      [media] gspca - sonixj: Add a flag in the driver_info table
      [media] gspca - sonixj: Set the flag for some devices
      [media] gspca - sonixj: Add the bit definitions of the bridge
reg 0x01 and 0x17
      [media] gspca - sonixj: Better handling of the bridge registers
0x01 and 0x17

Jesper Juhl (1):
      MIPS: VPE loader: Check vmalloc return value in vpe_open

Joerg Roedel (1):
      KVM: SVM: Do not report xsave in supported cpuid

John Reiser (1):
      ftrace: Have recordmcount honor endianness in fn_ELF_R_INFO

Ken Mills (2):
      n_gsm: Fix message length handling when building header
      n_gsm: gsm_data_alloc buffer allocation could fail and it is not
being checked

Kenji Kaneshige (2):
      x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode
      x86: Enable the intr-remap fault handling after local APIC setup

Kevin Cernekee (3):
      MIPS: Fix regression on BCM4710 processor detection
      MIPS: Fix CP0 COUNTER clockevent race
      MIPS: Fix build errors in sc-mips.c

Kevin Granade (1):
      Input: wacom - add another Bamboo Pen ID (0xd4)

Kukjin Kim (1):
      ARM: S3C24XX: Fix CONFIG_S3C_DEV_NAND Kconfig entry

Lars Ellenberg (2):
      drbd: don't recvmsg with zero length
      drbd: fix for spin_lock_irqsave in endio callback

Lars-Peter Clausen (3):
      MIPS: jz4740: qi_lb60: Fix gpio for the 6th row of the keyboard matrix
      MIPS: jz4740: Fix section mismatch in prom.c
      MIPS: JZ4740: Fix pcm device name

Laurent Pinchart (5):
      [media] uvcvideo: Lock controls mutex when querying menus
      [media] uvcvideo: Move mutex lock/unlock inside uvc_free_buffers
      [media] uvcvideo: Move mmap() handler to uvc_queue.c
      [media] uvcvideo: Lock stream mutex when accessing
format-related information
      [media] uvcvideo: Convert to unlocked_ioctl

Lino Sanfilippo (6):
      fanotify: if set by user unset FMODE_NONOTIFY before
fsnotify_perm() is called
      fanotify: correct broken ref counting in case adding a mark failed
      fanotify: Dont allow a mask of 0 if setting or removing a mark
      fanotify: on group destroy allow all waiters to bypass permission check
      fanotify: Introduce FAN_NOFD
      fanotify: Dont try to open a file descriptor for the overflow event

Linus Torvalds (2):
      Fix build error in drivers/block/cciss.c
      Linux 2.6.37-rc7

Maciej W. Rozycki (1):
      MIPS: LD/SD o32 macro GAS fix update

Magnus Damm (2):
      ARM: mach-shmobile: fix compile warning in mm/init.c
      ARM: mach-shmobile: INTC interrupt priority level demux fix

Manuel Lauss (1):
      MIPS: Alchemy: fix build with SERIAL_8250=n

Marek Szyprowski (1):
      ARM: S5PV210: update MAX8998 platform data to get rid of WARN()

Martin K. Petersen (1):
      block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead

Mauro Carvalho Chehab (2):
      [media] Don't export format_by_forcc on two different drivers
      [media] bttv: fix mutex use before init (BZ#24602)

Mike Galbraith (1):
      Sched: fix skip_clock_update optimization

Mike Snitzer (1):
      block: max hardware sectors limit wrapper

Neil Horman (1):
      PCI: Update MCP55 quirk to not affect non HyperTransport variants

Nicolas Pitre (1):
      clarify a usage constraint for cnt32_to_63()

Pavankumar Kondeti (2):
      USB: core: Add input prompt and help text for USB_OTG config
      USB: gadget: Remove suspended sysfs file before freeing cdev

Peter Zijlstra (5):
      scripts/tags.sh: Add magic for trace-events
      perf: Fix duplicate events with multiple-pmu vs software events
      sched: Cure more NO_HZ load average woes
      sched: Fix the irqtime code to deal with u64 wraps
      sched: Fix the irqtime code for 32bit

Rafael J. Wysocki (2):
      PM / Hibernate: Restore old swap signature to avoid user space breakage
      PM / Runtime: Fix pm_runtime_suspended()

Ralf Baechle (3):
      MIPS: Swarm: Fix typo in symbol name: RTC_M4LT81 -> RTC_M41T81
      MIPS: MT: Fix typo in comment.
      MIPS: Rename mips_dma_cache_sync back to dma_cache_sync

Rusty Russell (3):
      lguest: fix crash lguest_time_init
      lguest: restore boot speed
      lguest: populate initial_page_table

Ryan Mallon (1):
      at91: Fix uhpck clock rate in upll case

Ryusuke Konishi (1):
      nilfs2: fix regression of garbage collection ioctl

Sage Weil (2):
      ceph: fix msgr_init error path
      ceph: fix null pointer dereference in ceph_init_dentry for nfs reexport

Sarah Sharp (1):
      xhci: Fix issue with port array setup and buggy hosts.

Seungwhan Youn (1):
      ASoC: WM8580: Fix R8 initial value

Sheng Yang (1):
      KVM: Fix OSXSAVE after migration

Slava Pestov (1):
      tracing: Fix panic when lseek() called on "trace" opened for writing

Stephen M. Cameron (1):
      cciss: fix cciss_revalidate panic

Suresh Siddha (4):
      bootmem: Add alloc_bootmem_align()
      x86, xsave: Use alloc_bootmem_align() instead of alloc_bootmem()
      x86, vt-d: Quirk for masking vtd spec errors to platform error
handling logic
      x86, vt-d: Handle previous faults after enabling fault handling

Takashi Iwai (2):
      PM / Hibernate: Fix PM_POST_* notification with user-space suspend
      ALSA: hda - Fix conflict of Mic Boot controls

Takashi YOSHII (1):
      clocksource: sh_cmt: Remove nested spinlock fix

Thomas Chou (1):
      MIPS: FDT size is a be32

Thomas Gleixner (2):
      x86: io_apic: Avoid unused variable warning when
CONFIG_GENERIC_PENDING_IRQ=n
      x86: HPET: Chose a paranoid safe value for the ETIME check

Thomas Sailer (1):
      USB: misc: uss720.c: add another vendor/product ID

Tomi Valkeinen (2):
      OMAP: DSS: VRAM: Align start & size of vram to 2M
      OMAP: OMAPFB: disable old omapfb for OMAP4 builds

Tony Wu (1):
      MIPS: Separate two consecutive loads in memset.S

Vitaly Kuznetsov (1):
      USB: usb-storage: unusual_devs entry for the Samsung YP-CP3

Vivek Goyal (2):
      blk-throttle: Trim/adjust slice_end once a bio has been dispatched
      blk-throttle: Correct the placement of smp_rmb()

Wu Zhangjin (1):
      MIPS: Loongson: Add return value check for strict_strtoul()

Xiaotian Feng (1):
      block: check for proper length of iov entries earlier in
blk_rq_map_user_iov()

Yauhen Kharuzhy (1):
      ARM S3C24XX: Fix compilation of PM code for S3C2416

Yoichi Yuasa (1):
      MIPS: Alchemy: Add return value check for strict_strtoul()
