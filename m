Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2LCUhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:37:23 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44521 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2LCUgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:36:51 -0500
X-Greylist: delayed 3441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 15:36:50 EST
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Dec 2012 12:36:26 -0800
X-Google-Sender-Auth: mpm-M3jhFlKewonrhDNuSBh_Aao
Message-ID: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
Subject: Linux 3.7-rc8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really didn't want it to come to this, but I was uncomfortable doing
the 3.7 release yesterday due to last-minute issues, and decided to
sleep on it.

And today, I ended up even *less* comfortable about it due to the
resurrection of a kswapd issue, so I decided that I'm going to do
another -rc after all.

Which is not very nice timing-wise, since that means that the next
merge window will run up very close to christmas, but hey, maybe that
will at least convince people to not leave things to the final days of
the merge window, and send me pull requests *early*. That would be
nice.

And because I'm dragging it out for another week, I'm going to be
*very* bitter if anybody sends me pull requests this late in the game
that aren't for major issues. If you send me small irrelevant stuff
that doesn't fix major issues (oopses, security, things like that),
I'm going to curse at you and ignore your pull request. So don't do
it.

The only things I want to see are fixes that people care deeply about.
If it's not critical, or you don't have an actual problem report from
an actual user, just put it in the queue under the christmas tree, and
let it got for 3.8.

(Ok, while writing this I got another pull request that made me go "We
don't really need this". I'll pull that, because technically it came
in before I'd given people this warning, but ...)

                Linus

---

Al Viro (12):
      um: get_safe_registers() should be done in flush_thread(), not
start_thread()
      openrisk: fix altstack switching on sigreturn
      sh64: fix altstack switching on sigreturn
      score: do_sigaltstack() expects a userland pointer...
      microblaze: rt_sigreturn is too trigger-happy about sigaltstack errors
      don't do blind d_drop() in nfs_prime_dcache()
      nfs_lookup_revalidate(): fix a leak
      cifs: get rid of blind d_drop() in readdir
      lookup_one_len: don't accept . and ..
      fix off-by-one in argument passed by iterate_fd() to callbacks
      open*(2) compat fixes (s390, arm64)
      [parisc] open(2) compat bug

Amir Vadai (1):
      net/mlx4_en: Can set maxrate only for TC0

Anatolij Gustschin (1):
      [media] mt9v022: fix the V4L2_CID_EXPOSURE control

Andrew Karpow (1):
      [media] rtl28xxu: 0ccd:00d7 TerraTec Cinergy T Stick+

Andrew Morton (1):
      revert "Revert "mm: remove __GFP_NO_KSWAPD""

Antti Palosaari (3):
      [media] dvb_usb_v2: fix pid_filter callback error logging
      [media] dvb_usb_v2: switch interruptible mutex to normal
      [media] rtl28xxu: 1d19:1102 Dexatek DK mini DVB-T Dongle

Arnd Bergmann (1):
      IXP4xx: use __iomem for MMIO

Arun Kumar K (2):
      [media] s5p-mfc: Bug fix of timestamp/timecode copy mechanism
      [media] s5p-mfc: Handle multi-frame input buffer

Bjørn Mork (1):
      net: qmi_wwan: add Huawei E173

Charles Keepax (3):
      mfd: arizona: Use correct array for ARRAY_SIZE in mfd_add_devices call
      mfd: arizona: Correctly report when AIF2/AIF1 is underclocked
      mfd: arizona: Sync regcache after reset

Chris Wilson (1):
      Revert "drm/i915: enable rc6 on ilk again"

Chuansheng Liu (1):
      watchdog: using u64 in get_sample_period()

Dan Carpenter (1):
      atm: forever loop loading ambassador firmware

Daniel Vetter (1):
      drm/i915: disable cloning on sdvo

Darren Hart (1):
      futex: avoid wake_futex() for a PI futex_q

Dave Martin (1):
      ARM: 7583/1: decompressor: Enable unaligned memory access for v6 and above

David Howells (6):
      x86: Export asm/{svm.h,vmx.h,perf_regs.h}
      tools: Define a Makefile function to do subdir processing
      tools: Honour the O= flag when tool build called from a higher Makefile
      tools: Pass the target in descend
      perf: Make perf build for x86 with UAPI disintegration applied
      UAPI: strip the _UAPI prefix from header guards during header installation

Emmanuel Grumbach (1):
      iwlwifi: fix the basic CCK rates calculation

Eric Dumazet (2):
      net: ipmr: limit MRT_TABLE identifiers
      tcp: fix crashes in do_tcp_sendpages()

Florian Westphal (1):
      netfilter: ipset: fix netiface set name overflow

Frederic Weisbecker (1):
      rcu: Fix unrecovered RCU user mode in syscall_trace_leave()

Guennadi Liakhovetski (7):
      [media] media: sh_vou: fix const cropping related warnings
      [media] media: sh_mobile_ceu_camera: fix const cropping related warnings
      [media] media: pxa_camera: fix const cropping related warnings
      [media] media: mx3_camera: fix const cropping related warnings
      [media] media: mx2_camera: fix const cropping related warnings
      [media] media: mx1_camera: use the default .set_crop() implementation
      [media] media: omap1_camera: fix const cropping related warnings

H. Peter Anvin (2):
      x86, kvm: Remove incorrect redundant assembly constraint
      x86-32: Unbreak booting on some 486 clones

Hans Verkuil (4):
      [media] adv7604: cleanup references
      [media] adv7604: Replace prim_mode by mode
      [media] adv7604: use presets where possible
      [media] adv7604: restart STDI once if format is not found

Inki Dae (3):
      drm/exynos: fix linux framebuffer address setting.
      drm/exynos: remove unnecessary code.
      drm/exynos: fix overlay updating issue

Jan Kara (2):
      jbd: Fix lock ordering bug in journal_unmap_buffer()
      writeback: put unused inodes to LRU after writeback completion

Jani Nikula (1):
      drm/i915: do not default to 18 bpp for eDP if missing from VBT

Jason Gunthorpe (1):
      ARM: Kirkwood: Update PCI-E fixup

Jean Delvare (1):
      i7300_edac: Fix error flag testing

Jean-François Moine (1):
      tty vt: Fix a regression in command line edition

Jeff Layton (1):
      cifs: fix writeback race with file that is growing

Jerome Glisse (1):
      radeon: fix pll/ctrc mapping on dce2 and dce3 hardware

Jesse Gross (1):
      openvswitch: Print device when warning about over MTU packets.

Jianguo Wu (1):
      mm/vmemmap: fix wrong use of virt_to_page

Jiri Pirko (1):
      team: fix hw_features setup

Johannes Berg (1):
      mac80211: fix remain-on-channel (non-)cancelling

Johannes Weiner (1):
      mm: vmscan: fix endless loop in kswapd balancing

Josh Cartwright (1):
      ARM: 7570/1: quiet down the non make -s output

Kalle Jokiniemi (1):
      mfd: twl4030: Fix chained irq handling on resume from suspend

Kim, Milo (1):
      drivers/rtc/rtc-tps65910.c: fix invalid pointer access on _remove()

Krzysztof Hałasa (9):
      IXP4xx: Fix Goramo MultiLink platform compilation.
      IXP4xx: Fix off-by-one bug in Goramo MultiLink platform.
      IXP4xx: HW pseudo-random generator is available on IXP45x/46x only.
      IXP4xx: ixp4xx_crypto driver requires Queue Manager and NPE drivers.
      IXP4xx: Remove time limit for PCI TRDY to enable use of slow devices.
      WAN: Remove redundant HDLC info printed by IXP4xx HSS driver.
      IXP4xx crypto: MOD_AES{128,192,256} already include key size.
      IXP4xx: Always ioremap() Queue Manager MMIO region at boot.
      IXP4xx: map CPU config registers within VMALLOC region.

Laurent Pinchart (2):
      [media] omap3isp: video: Fix warning caused by bad vidioc_s_crop prototype
      [media] omap3isp: Fix warning caused by bad subdev events
operations prototypes

Linus Torvalds (5):
      fs/buffer.c: make block-size be per-page and protected by the page lock
      blockdev: remove bd_block_size_semaphore again
      direct-io: don't read inode->i_blkbits multiple times
      blkdev_max_block: make private to fs/buffer.c
      Linux 3.7-rc8

Mark Brown (2):
      mfd: wm5102: Update register patch for latest evaluation
      mfd: wm5110: Disable control interface error report for WM5110 rev B

Mark Salter (4):
      c6x: run do_notify_resume with interrupts enabled
      c6x: fix misleading comment
      c6x: remove internal kernel symbols from exported setup.h
      c6x: use generic kvm_para.h

Mauro Carvalho Chehab (2):
      i82975x_edac: Fix dimm label initialization
      edac: Fix the dimm filling for csrows-based layouts

Mehak Mahajan (1):
      openvswitch: Store flow key len if ARP opcode is not request or reply.

Mel Gorman (4):
      Revert "mm: remove __GFP_NO_KSWAPD"
      mm: vmscan: check for fatal signals iff the process was throttled
      mm: compaction: fix return value of capture_free_page()
      mm: avoid waking kswapd for THP allocations when compaction is
deferred or contended

Michael Neuling (1):
      perf, powerpc: Fix hw breakpoints returning -ENOSPC

Michael S. Tsirkin (1):
      vhost: fix length for cross region descriptor

Mike Galbraith (2):
      workqueue: exit rescuer_thread() as TASK_RUNNING
      Revert "sched, autogroup: Stop going ahead if autogroup is disabled"

Mikulas Patocka (1):
      percpu-rwsem: use synchronize_sched_expedited

Namhyung Kim (2):
      perf header: Fix numa topology printing
      perf tools: Fix strbuf_addf() when the buffer needs to grow

Naoya Horiguchi (1):
      mm: soft offline: split thp at the beginning of soft_offline_page()

Neal Cardwell (1):
      ipv4: avoid passing NULL to inet_putpeer() in icmpv4_xrlim_allow()

NeilBrown (1):
      md/raid1{,0}: fix deadlock in bitmap_unplug.

Nicolas Pitre (1):
      ARM: 7572/1: proc-v6.S: fix comment

Ohad Ben-Cohen (1):
      remoteproc: fix error path of ->find_vqs

Oliver Hartkopp (2):
      can: peak_usb: fix hwtstamp assignment
      can: bcm: initialize ifindex for timeouts without previous frame reception

Pavel Shilovsky (1):
      CIFS: Fix wrong buffer pointer usage in smb_set_file_info

Peter Ujfalusi (1):
      mfd: twl-core: Fix chip ID for the twl6030-pwm module

Prarit Bhargava (1):
      i7core_edac: fix panic when accessing sysfs files

Roland Dreier (1):
      target: Fix handling of aborted commands

Russell King - ARM Linux (2):
      Dove: Attempt to fix PMU/RTC interrupts
      Dove: Fix irq_to_pmu()

Sachin Kamat (4):
      [media] s5p-fimc: Fix potential NULL pointer dereference
      ARM: S3C24XX: Fix potential NULL pointer dereference error
      drm/exynos: Make exynos4/5_fimd_driver_data static
      drm/exynos: Fix potential NULL pointer dereference in exynos_drm_encoder.c

Schoch Christian (1):
      sctp: Error in calculation of RTTvar

Shaik Ameer Basha (2):
      [media] exynos-gsc: change driver compatible string
      [media] exynos-gsc: Fix settings for input and output image RGB type

Stanislav Kinsbursky (1):
      proc: check vma->vm_file before dereferencing

Sukadev Bhattiprolu (1):
      perf powerpc: Use uapi/unistd.h to fix build error

Sylwester Nawrocki (8):
      [media] s5p-fimc: Don't ignore return value of vb2_queue_init()
      [media] s5p-csis: Select S5P_SETUP_MIPIPHY
      [media] s5p-fimc: Fix platform entities registration
      [media] s5p-fimc: Prevent race conditions during subdevs registration
      [media] s5p-fimc: Don't use mutex_lock_interruptible() in device release()
      [media] fimc-lite: Don't use mutex_lock_interruptible() in
device release()
      [media] exynos-gsc: Don't use mutex_lock_interruptible() in
device release()
      [media] exynos-gsc: Add missing video device vfl_dir flag initialization

Tejun Heo (1):
      workqueue: mod_delayed_work_on() shouldn't queue timer on 0 delay

Tim Gardner (1):
      ixp4xx: Declare MODULE_FIRMWARE usage

Tommi Rantala (3):
      sctp: fix memory leak in sctp_datamsg_from_user() when copy from
user space fails
      sctp: fix -ENOMEM result with invalid user space pointer in
sendto() syscall
      irda: irttp: fix memory leak in irttp_open_tsap() error path

Tushar Behera (1):
      include/linux/bug.h: fix sparse warning related to BUILD_BUG_ON_INVALID

Vincent Palatin (1):
      x86, fpu: Avoid FPU lazy restore after suspend

Wei Yongjun (2):
      [media] dvb-frontends: fix potential NULL pointer dereference in
stv0900_set_mclk()
      [media] mx2_camera: fix missing unlock on error in mx2_start_streaming()

Will Deacon (1):
      ARM: 7586/1: sp804: set cpumask to cpu_possible_mask for clock
event device

Xiao Guangrong (2):
      perf kvm: Rename perf_kvm to perf_kvm_stat
      perf kvm: Fix building perf kvm on non x86 arches

françois romieu (1):
      8139cp: fix coherent mapping leak in error path.

nikolay@redhat.com (3):
      bonding: fix miimon and arp_interval delayed work race conditions
      bonding: make arp_ip_target parameter checks consistent with sysfs
      bonding: fix race condition in bonding_store_slaves_active
