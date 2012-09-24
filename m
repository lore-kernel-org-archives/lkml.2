Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2IXBv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 21:51:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34735 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab2IXBvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 21:51:25 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Sep 2012 18:51:04 -0700
X-Google-Sender-Auth: 30TAYhz3KwGxWt8Joj6iNsMqyFQ
Message-ID: <CA+55aFxjQPenH=90y2CzQQB_7qV8gj53AJxbhupPrB5X8hs7+w@mail.gmail.com>
Subject: Linux 3.6-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ho humm. I really *really* want to say that this is the last -rc, but
we do have a few small things pending still. So who knows. There may
be a -rc8, we'll just have to see.

That said, nothing here looks really bad. You can get a fairly good
feel for the flavor of fixes form the appended shortlog, and most of
it really is very tiny - oneliners and "fewliners". Nothing really
looks scary, although the powernow-k8/workqueue changes are pretty
core (but fix a bug and actually clean stuff up). I think the biggest
patch is there is an s390 page table walking fix, and even that isn't
really all that big.

So if everything works out well, and the upcoming week is calmer
still, I suspect I can avoid another -rc. Fingers crossed.

Anyway, see below. Most of this is in drivers (net, gpu, infiniband,
block..), architecture code (s390 and x86) and misc (xfs, workqueue,
networking).

It should all be pretty safe to test, so if you have held off because
you're nervous about rc's, please don't. The more testing we get, the
better,

            Linus

---

Al Viro (1):
      sh: Fix up TIF_NOTIFY_RESUME sans TIF_SIGPENDING handling.

Alan Cox (1):
      blk: add an upper sanity check on partition adding

Alex Deucher (1):
      Revert "drm/radeon: rework pll selection (v3)"

Andi Kleen (1):
      compiler.h: add __visible

Andreas Herrmann (1):
      hwmon: (fam15h_power) Tweak runavg_range on resume

Andreas Larsson (1):
      sparc32: Enable the relocation target R_SPARC_DISP32 for sparc32

Andrew Vagin (1):
      pid-namespace: limit value of ns_last_pid to (0, max_pid)

Andrey Vagin (1):
      tcp: restore rcv_wscale in a repair mode (v2)

Anisse Astier (1):
      Input: i8042 - disable mux on Toshiba C850D

Arend van Spriel (1):
      brcmsmac: fix mismatch in number of custom regulatory rules

Ariel Elior (1):
      bnx2x: remove false warning regarding interrupt number

Asai Thambi S P (6):
      mtip32xx: Add support for new devices
      mtip32xx: Handle NCQ commands during the security locked state
      mtip32xx: Increase timeout for standby command
      mtip32xx: Proper reporting of write protect status on big-endian
      mtip32xx: Change printk to pr_xxxx
      mtip32xx: Remove dead code

Axel Lin (2):
      Input: edt-ft5x06 - return -EFAULT on copy_to_user() error
      HID: lenovo-tpkbd: Fix memory leak in tpkbd_remove_tp()

Ben Myers (1):
      xfs: stop the sync worker before xfs_unmountfs

Bjørn Mork (1):
      net: qmi_wwan: adding Huawei E367, ZTE MF683 and Pantech P4200

Carlos Maiolino (1):
      xfs: fix race while discarding buffers [V4]

Chris Wilson (1):
      drm/i915: Reduce a pin-leak BUG into a WARN

Chuck Lever (1):
      include/net/sock.h: squelch compiler warning in sk_rmem_schedule()

Colin Ian King (1):
      brcm80211: fix missing allocation failure check

Daniel Vetter (1):
      drm/i915: enable lvds pin pairs before dpll on gen2

Dave Airlie (2):
      Revert "drm/nv50-/gpio: initialise to vbios defaults during init"
      drm/nouveau: add dmi quirk for gpio reset

David Milburn (1):
      mtip32xx: fix user_buffer check in exec_drive_command

David Rientjes (1):
      debugfs: fix race in u32_array_read and allocate array at open

Devendra Naga (1):
      at91ether: return PTR_ERR if call to clk_get fails

Dmitry Torokhov (1):
      Revert "input: ab8500-ponkey: Create AB8500 domain IRQ mapping"

Ed L. Cashin (2):
      aoe: assert AoE packets marked as requiring no checksum
      net: do not disable sg for packets requiring no checksum

Eddie Wai (1):
      [SCSI] bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

Eric Dumazet (2):
      net: rt_cache_flush() cleanup
      tcp: fix regression in urgent data handling

Fabio Estevam (2):
      Input: imx_keypad - fix missing clk conversions
      ARM: imx: armadillo5x0: Fix illegal register access

Felix Fietkau (1):
      ath9k: make PA linearization optional, disabled by default and fix checks

Fengguang Wu (1):
      edac_mc: fix messy kfree calls in the error path

Fernando Guzman Lugo (1):
      rpmsg: fix dma_free_coherent dev parameter

Forest Bond (1):
      Input: usbtouchscreen - initialize eGalax devices

Francesco Ruggeri (1):
      fs/proc: fix potential unregister_sysctl_table hang

Gang Wei (1):
      MAINTAINERS: fix TXT maintainer list and source repo path

Gerald Schaefer (3):
      s390/mm: fix deadlock in unmap_hugepage_range()
      s390/hugetlb: use direct TLB flushing for hugetlbfs pages
      s390/mm: fix user access page-table walk code

Guenter Roeck (3):
      hwmon: (ads7871) Add 'name' sysfs attribute
      hwmon: (ad7314) Add 'name' sysfs attribute
      linux/kernel.h: Fix warning seen with W=1 due to change in
DIV_ROUND_CLOSEST

Hante Meuleman (2):
      brcmfmac: fix big endian bug in i-scan.
      brcmfmac: Fix big endian host configuration data.

Ira W. Snyder (1):
      can: janz-ican3: fix support for older hardware revisions

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix missing #interrupt-cells on gpio-controller

Jeff Layton (1):
      cifs: fix return value in cifsConvertToUTF16

Jeff Mahoney (1):
      x86/kbuild: archscripts depends on scripts_basic

Jianguo Wu (1):
      mm/ia64: fix a memory block size bug

Joe Millenbach (1):
      x86/kconfig: Remove outdated reference to Intel CPUs in CONFIG_SWIOTLB

John Stultz (1):
      time: Fix timeekeping_get_ns overflow on 32bit systems

Joonsoo Kim (2):
      slab: fix starting index for finding another object
      slub: consider pfmemalloc_match() in get_partial_node()

Jovi Zhang (1):
      MIPS: mm: Add compound tail page _mapcount when mapped

Kevin Hilman (1):
      drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe

Konrad Rzeszutek Wilk (1):
      xen/boot: Disable BIOS SMP MP table search.

Lai Jiangshan (1):
      workqueue: always clear WORKER_REBIND in busy_worker_rebind_fn()

Larry Finger (1):
      rtlwifi: rtl8192ce: Log message that B_CUT device may not work

Lars-Peter Clausen (1):
      ARM: 7534/1: clk: Make the managed clk functions generically available

Laurent Pinchart (1):
      sh: pfc: Release spinlock in sh_pfc_gpio_request_enable() error path

Li Haifeng (1):
      mm/page_alloc: fix the page address of higher page's buddy calculation

Li RongQing (2):
      xfrm: fix a read lock imbalance in make_blackhole
      net/core: fix comment in skb_try_coalesce

Linus Lüssing (1):
      batman-adv: make batadv_test_bit() return 0 or 1 only

Linus Torvalds (2):
      debugfs: fix u32_array race in format_array_alloc
      Linux 3.6-rc7

Maciej W. Rozycki (1):
      MIPS: Malta: Remove RTC Data Mode bootstrap breakage

Mandeep Singh Baines (1):
      ARM: SAMSUNG: use spin_lock_irqsave() in clk_set_parent

Marc Kleine-Budde (1):
      can: ti_hecc: fix oops during rmmod

Mark Asselstine (1):
      firmware: fix directory creation rule matching with make 3.80

Mark Brown (1):
      ARM: 7537/1: clk: Fix release in devm_clk_put()

Martin Schwidefsky (1):
      s390/hwcaps: do not report high gprs for 31 bit kernel

Mathias Krause (8):
      xfrm_user: return error pointer instead of NULL
      xfrm_user: return error pointer instead of NULL #2
      xfrm_user: fix info leak in copy_to_user_auth()
      xfrm_user: fix info leak in copy_to_user_state()
      xfrm_user: fix info leak in copy_to_user_policy()
      xfrm_user: fix info leak in copy_to_user_tmpl()
      xfrm_user: ensure user supplied esn replay window is valid
      xfrm_user: don't copy esn replay window twice for new states

Matthew Leach (1):
      ARM: 7532/1: decompressor: reset SCTLR.TRE for VMSA ARMv7 cores

Mel Gorman (1):
      slab: do ClearSlabPfmemalloc() for all pages of slab

Michael S. Tsirkin (1):
      net: fix memory leak on oom with zerocopy

Michal Kubeček (1):
      tcp: flush DMA queue before sk_wait_data if rcv_wnd is zero

Michal Schmidt (1):
      bnx2x: fix rx checksum validation for IPv6

Mike Marciniszyn (1):
      IB/qib: Fix failure of compliance test C14-024#06_LocalPortNum

Mike Turquette (1):
      ARM: 7535/1: Reprogram smp_twd based on new common clk framework notifiers

Miklos Szeredi (1):
      vfs: dcache: use DCACHE_DENTRY_KILLED instead of
DCACHE_DISCONNECTED in d_kill()

NeilBrown (3):
      Revert "md/raid5: For odirect-write performance, do not set
STRIPE_PREREAD_ACTIVE."
      md/raid5: fix calculate of 'degraded' when a replacement becomes active.
      md: make sure metadata is updated when spares are activated or removed.

Nestor Lopez Casado (1):
      HID: Fix logitech-dj: missing Unifying device issue

Nicolas Dichtel (5):
      ipv4/route: arg delay is useless in rt_cache_flush()
      netns: move net->ipv4.rt_genid to net->rt_genid
      xfrm: invalidate dst on policy insertion/deletion
      ipv6: use net->rt_genid to check dst validity
      ipv6: use DST_* macro to set obselete field

Nicolas Ferre (2):
      dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()
      dmaengine: at_hdmac: check that each sg data length is non-null

Nikolay Aleksandrov (1):
      netxen: check for root bus in netxen_mask_aer_correctable

Paolo Valente (1):
      pkt_sched: fix virtual-start-time update in QFQ

Parag Warudkar (1):
      hwmon: (applesmc) Bump max wait

Parav Pandit (1):
      RDMA/ocrdma: Fix CQE expansion of unsignaled WQE

Paul Clements (1):
      nbd: clear waiting_queue on shutdown

Paul Mundt (1):
      sh: intc: Fix up multi-evt irq association.

Pawel Moll (1):
      Input: ambakmi - [un]prepare clocks when enabling amd disabling

Ralf Baechle (1):
      MIPS: Malta: Don't crash on spurious interrupt.

Richard Cochran (1):
      gianfar: fix phc index build failure

Robert Richter (1):
      perf/x86/ibs: Check syscall attribute flags

RongQing.Li (1):
      MIPS: CMP/SMTC: Fix tc_id calculation

Russell King (1):
      ARM: reserve syscall 378 for kcmp

Sachin Kamat (2):
      DMA: PL330: Fix potential NULL pointer dereference in pl330_submit_req()
      DMA: PL330: Check the pointer returned by kzalloc

Sascha Hauer (1):
      ARM i.MX25: Make timer irq work again

Sebastian Ott (3):
      s390/dasd: move wake_up call
      s390/cio: fix IO subchannel event race
      s390/cio: invalidate cdev pointer before deregistration

Shaun Ruffell (1):
      edac_mc: edac_mc_free() cannot assume mem_ctl_info is registered in sysfs.

Shlomo Pongratz (2):
      IPoIB: Fix memory leak in the neigh table deletion flow
      IPoIB: Fix AB-BA deadlock when deleting neighbours

Silas Boyd-Wickizer (2):
      hwmon: (via-cputemp) Use get_online_cpus to avoid races
involving CPU hotplug
      hwmon: (coretemp) Use get_online_cpus to avoid races involving CPU hotplug

Simon Kitching (1):
      drm/radeon: Prevent leak of scratch register on resume from suspend

Stefan Haberland (2):
      s390/dasd: fix pathgroup race
      s390/dasd: fix read unit address configuration loop

Stefan Roese (1):
      net/stmmac: Use clk_prepare_enable and clk_disable_unprepare

Stefano Stabellini (1):
      xen/m2p: do not reuse kmap_op->dev_bus_addr

Stephane Eranian (2):
      perf/x86: Export Sandy Bridge uncore clockticks event in sysfs
      perf/x86: Fix Intel Ivy Bridge support

Stephen M. Cameron (2):
      cciss: fix handling of protocol error
      [SCSI] hpsa: fix handling of protocol error

Søren holm (1):
      asix: Support DLink DUB-E100 H/W Ver C1

T Makphaibulchoke (1):
      x86/mm/init.c: Fix devmem_is_allowed() off by one

Tai-hwa Liang (1):
      Input: sentelic - filter out erratic movement when lifting finger

Tejun Heo (2):
      workqueue: reimplement work_on_cpu() using system_wq
      cpufreq/powernow-k8: workqueue user shouldn't migrate the
kworker to another CPU

Tetsuyuki Kobayashi (1):
      ARM: shmobile: kzm9g: bugfix: correct mmcif interrupt settings

Toshi Kani (1):
      hpwdt: Fix kdump issue in hpwdt

Tushar Behera (1):
      ARM: SAMSUNG: Use spin_lock_{irqsave,irqrestore} in clk_set_rate

Tushar Dave (1):
      e1000: Small packets may get corrupted during padding by HW

Wang Sen (1):
      [SCSI] scsi: virtio-scsi: Fix address translation failure of
HighMem pages used by sg list

Wang Xingchao (1):
      drm/i915: HDMI - Clear Audio Enable bit for Hot Plug

Wei Yongjun (7):
      RDMA/cxgb4: Move dereference below NULL test
      hwspinlock/core: move the dereference below the NULL test
      watchdog: move the dereference below the NULL test
      ipv6: fix return value check in fib6_add()
      stmmac: fix return value check in stmmac_open_ext_timer()
      net/irda: sh_sir: fix return value check in sh_sir_set_baudrate()
      sparc: fix the return value of module_alloc()

Wen Congyang (2):
      memory hotplug: reset pgdat->kswapd to NULL if creating kernel
thread fails
      tracing: Don't call page_to_pfn() if page is NULL

Yi Zou (1):
      block: rate-limit the error message from failing commands

Yishai Hadas (1):
      mlx4_core: Fix integer overflows so 8TBs of memory registration works

Zhao Hongjiang (1):
      net: change return values from -EACCES to -EPERM

qiuxishi (1):
      memory hotplug: fix section info double registration bug

sreekanth.reddy@lsi.com (1):
      [SCSI] mpt2sas: Fix for issue - Unable to boot from the drive
connected to HBA
