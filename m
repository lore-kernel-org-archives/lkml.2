Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1CHFk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 00:40:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415Ab1CHFk5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 00:40:57 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Mar 2011 21:40:04 -0800
Message-ID: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com>
Subject: Linux 2.6.38-rc8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would have been ok with releasing this as the final 38, but I'm
going to be partially unreachable for several days next week, so I
felt there was no point in opening the merge window yet.

Also, we do have regressions. Some of them hopefully fixed here, but
it won't hurt to give it another week.

Not everything here is strictly a regression: the i_nlink fixes are
long-standing races (very unlikely ones, admittedly), and the alpha
updates just convert the irq chip descriptions so that we can enable
GENERIC_HARDIRQS_NO_DEPRECATED on alpha too. But most everything is
pretty simple, and the diffstat is fairly flat with nothing huge that
stands out.

40% drivers, 35% arch updates (alpha and arm), with the rest being fs,
net and some block layer updates.

So please keep testing,

                                Linus

---

Aaro Koskinen (1):
      arm: mach-omap2: smartreflex: fix another memory leak

Al Viro (8):
      sysv: i_nlink races in rename()
      ufs: i_nlink races in rename()
      minix: i_nlink races in rename()
      nilfs2: i_nlink races in rename()
      exofs: i_nlink races in rename()
      fix reiserfs mkdir() breakage
      udf: fix i_nlink limit
      hfs: fix rename() over non-empty directory

Alex Elder (1):
      xfs: zero proper structure size for geometry calls

Alexandre Bounine (1):
      RapidIO: Update MAINTAINERS

Amit Shah (1):
      virtio: console: Don't access vqs if device was unplugged

Andi Kleen (4):
      mm: change alloc_pages_vma to pass down the policy node for local policy
      mm: add alloc_page_vma_node()
      mm: preserve original node for transparent huge page copies
      mm: use correct numa policy node for transparent hugepages

Andres Salomon (2):
      x86: OLPC: have prom_early_alloc BUG rather than return NULL
      of/promtree: allow DT device matching by fixing 'name' brokenness (v5)

Andrey Vagin (1):
      netlink: handle errors from netlink_dump()

Anton Blanchard (2):
      powerpc/kexec: Restore ppc_md.machine_kexec
      RxRPC: Fix v1 keys

Arnaldo Carvalho de Melo (1):
      dccp: Change maintainer

Axel Lin (5):
      net/fec: fix unterminated platform_device_id table
      davinci: cpufreq: fix section mismatch warning
      drivers/rtc/rtc-s3c.c: fix prototype for s3c_rtc_setaie()
      drivers/misc/bmp085.c: add MODULE_DEVICE_TABLE
      drivers/video/backlight/ltv350qv.c: fix a memory leak

Banajit Goswami (1):
      ARM: S5P64X0: Fix number of GPIO lines in Bank F

Ben Dooks (3):
      ARM: S3C64XX: Fix keypad setup to configure correct number of rows
      ARM: S3C64XX: Add clock for i2c1
      ARM: S3C64XX: Reduce output of s3c64xx_dma_init1()

Ben Hutchings (1):
      block: fix kernel-doc format for blkdev_issue_zeroout

Ben Skeggs (3):
      drm/nouveau: allocate kernel's notifier object at end of block
      drm/nouveau: fix regression causing ttm to not be able to evict vram
      drm/nv50-nvc0: prevent multiple vm/bar flushes occuring simultanenously

Bruce Allan (1):
      e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead

Chih-Wei Huang (1):
      ALSA: hda - Fix unable to record issue on ASUS N82JV

Chris Wilson (4):
      Revert "drm/i915: fix corruptions on i8xx due to relaxed fencing"
      drm/i915: Do not overflow the MMADDR write FIFO
      drm/i915: Disable GPU semaphores by default
      drm/i915: Rebind the buffer if its alignment constraints changes
with tiling

Christian Lamparter (1):
      p54usb: add Senao NUB-350 usbid

Dan Carpenter (1):
      [S390] keyboard: integer underflow bug

Dave Jones (1):
      [CPUFREQ] Fix another notifier leak in powernow-k8.

Dave Kleikamp (1):
      MAINTAINERS: Update shaggy's email address

David Henningsson (1):
      ALSA: HDA: Realtek: Fixup jack detection to input subsystem

David Howells (2):
      AF_RXRPC: Handle receiving ACKALL packets
      DNS: Fix a NULL pointer deref when trying to read an error key
[CVE-2011-1076]

Dimitris Papastamos (2):
      ASoC: WM8994: Don't disable the AIF[1|2]CLK_ENA unconditionaly
      ASoC: WM8994: Ensure late enable events are processed for the ADCs

Dmitry Eremin-Solenikov (4):
      ARM: pxa/tosa: drop setting LED trigger name, as it's unsupported now
      ARM: pxa/colibri: don't register pxa2xx-pcmcia nodes on
non-colibri platforms
      ARM: pxa: enable pxa-pcm-audio on pxa210/pxa25x platform
      ARM: pxa/tosa: register wm9712 codec device

Dmitry Kravkov (5):
      bnx2x: (NPAR mode) Fix FW initialization
      bnx2x: Fix nvram test for single port devices.
      bnx2x: Fix ethtool -t link test for MF (non-pmf) devices.
      bnx2x: properly configure coefficients for MinBW algorithm (NPAR mode).
      bnx2x: update driver version to 1.62.00-6

Dmitry Shmidt (1):
      mmc: sdio: Allow sdio operations in other threads during sdio_add_func()

Francesco Virlinzi (1):
      sh: Change __nosave_XXX symbols to long

Fry, Donald H (1):
      iwlagn: Support new 5000 microcode.

Gerrit Renker (1):
      dccp: fix oops on Reset after close

Hagen Paul Pfeifer (1):
      net: handle addr_type of 0 properly

Hari Kanigeri (1):
      omap: mailbox: resolve hang issue

Hegde, Vinay (1):
      davinci_emac: Add Carrier Link OK check in Davinci RX Handler

Hirosh Dabui (1):
      davinci: tnetv107x: fix register indexing for GPIOs numbers > 31

Ilya Yanok (1):
      dnet: fix wrong use of platform_set_drvdata()

Jamie Iles (1):
      macb: don't use platform_set_drvdata() on a net_device

Jan Engelhardt (1):
      netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

Jan Niehusmann (1):
      drm/i915: fix memory corruption with GM965 and >4GB RAM

Jan Puk (1):
      carl9170: add Airlive X.USB a/b/g/n USBID

Jay Vosburgh (1):
      MAINTAINERS: Add Andy Gospodarek as co-maintainer.

Jeff Kirsher (1):
      igb: fix sparse warning

Jiri Slaby (1):
      [CPUFREQ] fix BUG on cpufreq policy init failure

Jochen Friedrich (1):
      mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

John Fastabend (1):
      net: dcbnl: check correct ops in dcbnl_ieee_set()

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

Julian Anastasov (1):
      ipvs: fix dst_lock locking on dest update

Jussi Kivilinna (1):
      rndis_wlan: use power save only for BCM4320b

Justin Mattock (1):
      drivers:isdn:istream.c Fix typo pice to piece

K.Prasad (1):
      powerpc: Fix call to flush_ptrace_hw_breakpoint()

Ken Kawasaki (1):
      fmvj18x_cs: add new id

Kukjin Kim (2):
      ARM: 6761/1: Update number of VIC for S5PV210
      ARM: 6762/1: Update number of VIC for S5P6442 and S5PC100

Kuninori Morimoto (4):
      ARM: mach-shmobile: ap4evb: fixup memory initialize for zboot
      ARM: mach-shmobile: mackerel: fixup memory initialize for zboot
      ARM: mach-shmobile: ap4evb: modify LCDC clock divider value
      ARM: mach-shmobile: mackerel: modify LCDC clock divider value

Kurt Van Dijck (1):
      CAN: add controller hardware name for Softing cards

Kyungmin Park (1):
      MAINTAINERS: add maintainer of Samsung Mobile Machine support

Lars Ellenberg (1):
      net: fix nla_policy_len to actually _iterate_ over the policy

Lars-Peter Clausen (2):
      ARM: S3C2440: Select missing S3C_DEV_USB_HOST on GTA02
      ARM: S3C2440: Fix usage gpio bank j pin definitions on GTA02

Len Brown (2):
      intel_idle: disable NHM/WSM HW C-state auto-demotion
      intel_idle: disable Atom/Lincroft HW C-state auto-demotion

Lennert Buytenhek (1):
      mfd: Fix ASIC3 build with GENERIC_HARDIRQS_NO_DEPRECATED

Li Zefan (1):
      cpuset: add a missing unlock in cpuset_write_resmask()

Linus Torvalds (2):
      Mark ptrace_{traceme,attach,detach} static
      Linux 2.6.38-rc8

Lucian Adrian Grijincu (1):
      sysctl: ipv6: use correct net in ipv6_sysctl_rtcache_flush

Magnus Damm (2):
      ARM: mach-shmobile: AG5EVM MIPI-DSI LCD reset delay fix
      ARM: mach-shmobile: Add sh73a0 MIPI-CSI and CEU clocks

Manjunathappa, Prakash (1):
      mfd: Fix DaVinci voice codec device name

Mark Brown (7):
      ASoC: Fix WM9081 platform data initialisation
      mfd: Don't suspend WM8994 if the CODEC is not suspended
      ARM: SAMSUNG: Include devs.h in dev-uart.c to prototype devices
      ARM: S3C64XX: Staticise non-exported GPIO to interrupt functions
      ARM: S3C64XX: Tone down SDHCI debugging
      ARM: S3C64XX: Fix build with WM1190 disabled and WM1192 enabled
on SMDK6410
      ARM: S3C64XX: Update regulator names for debugfs compatiblity on SMDK6410

Martin Schwidefsky (2):
      [S390] xpram: remove __initdata attribute from module parameters
      [S390] tape: deadlock on system work queue

Michael Chan (2):
      cnic: Prevent status block race conditions with hardware
      cnic: Fix lost interrupt on bnx2x

Michal Simek (1):
      of: Add missing of_address.h to xilinx ehci driver

Mike Frysinger (2):
      Blackfin: outs[lwb]: make sure count is greater than 0
      Blackfin: iflush: update anomaly 05000491 workaround

Morten Holst Larsen (1):
      Fix typo in call to irq_to_desc()

Naga Chumbalkar (1):
      [CPUFREQ] p4-clockmod: print EST-capable warning message only once

Neil Brown (1):
      [CPUFREQ] Missing "unregister_cpu_notifier" in powernow-k8.c

Neil Horman (1):
      nfs4: Ensure that ACL pages sent over NFS were not allocated
from the slab (v3)

Nicolas Pitre (1):
      ARM: 6765/1: remove obsolete comment from asm/mach/arch.h

Nobuhiro Iwamatsu (2):
      sh: sh7750: move machtypes.h to include/generated
      sh: sh7750: Fix incompatible pointer type

Paul Bolle (1):
      of/flattree: Drop an uninteresting message to pr_debug level

Peter Zijlstra (1):
      powerpc/mm: Make hpte_need_flush() safe for preemption

Petr Uzel (1):
      block: kill loop_mutex

Rafael J. Wysocki (1):
      ACPI / ACPICA: Implicit notify for multiple devices

Rajashekhara, Sudhakar (1):
      davinci: da8xx/omap-l1x: add platform device for davinci-pcm-audio

Randy Dunlap (1):
      net: update Documentation/networking/00-INDEX

Richard Samson (1):
      ALSA: hda - add new Fermi 5xx codec IDs to snd-hda

Ryusuke Konishi (1):
      nilfs2: fix regression that i-flag is not set on changeless checkpoints

Rémi Denis-Courmont (1):
      f_phonet: avoid pskb_pull(), fix OOPS with CONFIG_HIGHMEM

Sage Weil (9):
      Revert "ceph: keep reference to parent inode on ceph_dentry"
      ceph: do not set I_COMPLETE
      ceph: do not clear I_COMPLETE from d_release
      libceph: fix handling of short returns from get_user_pages
      libceph: retry after authorization failure
      libceph: fix msgr backoff
      libceph: fix msgr keepalive flag
      libceph: fix msgr standby handling
      ceph: no .snap inside of snapped namespace

Sergei Shtylyov (1):
      DaVinci: fix compilation warnings in <mach/clkdev.h>

Shweta Gulati (1):
      OMAP2+: PM: SmartReflex: fix memory leaks in Smartreflex driver

Stanislaw Gruszka (2):
      ath9k: correct ath9k_hw_set_interrupts
      r8169: disable ASPM

Stephen Hemminger (2):
      skge: don't mark carrier down at start
      e1000: fix sparse warning

Stuart Menefy (2):
      sh: Ensure ST40-300 BogoMIPS value is consistent
      sh: Flush executable pages in copy_user_highpage

Sujith Manoharan (1):
      ath9k_htc: Fix an endian issue

Takashi Iwai (1):
      ALSA: hda - Don't set to D3 in Cirrus errata init verbs

Tao Ma (1):
      blktrace: Remove blk_fill_rwbs_rq.

Tejun Heo (2):
      block: add @force_kblockd to __blk_run_queue()
      block: blk-flush shouldn't call directly into q->request_fn()
__blk_run_queue()

Thomas Gleixner (19):
      alpha: Pyxis convert irq_chip functions
      alpha: srm: Convert irq_chip functions
      alpha: i8259, alcor, jensen wildfire: Convert irq_chip
      alpha: cabriolet: Convert irq_chip functions
      alpha: dp264: Convert irq_chip functions
      alpha: eb64p: Convert irq_chip functions
      alpha: eiger: Convert irq_chip functions
      alpha: marvel: Convert irq_chip functions
      alpha: mikasa: Convert irq_chip functions
      alpha: rawhide: Convert irq_chip functions
      alpha: noritake: Convert irq_chip functions
      alpha: rx164: Convert irq_chip functions
      alpha: sable: Convert irq_chip functions
      alpha: takara: Convert irq_chip functions
      alpha: titan: Convert irq_chip functions
      alpha: irq: Remove pointless irq status manipulation
      alpha: irq: Convert affinity to use irq_data
      alpha: Enable GENERIC_HARDIRQS_NO_DEPRECATED
      pps: make pps_gen_parport depend on BROKEN

Uwe Kleine-König (1):
      ARM: 6757/1: fix tlb.h induced linux/swap.h build failure

Vasiliy Kulikov (1):
      ACPI / debugfs: Fix buffer overflows, double free

Vivek Goyal (1):
      blk-throttle: Do not use kblockd workqueue for throtl work

Vladislav Zolotarov (3):
      bnx2x: Add a missing bit for PXP parity register of 57712.
      bnx2x: perform statistics "action" before state transition.
      bnx2x: properly calculate lro_mss

Will Deacon (2):
      ARM: 6767/1: ptrace: fix register indexing in GETHBPREGS request
      ARM: 6768/1: hw_breakpoint: ensure debug logic is powered up on v7 cores

roel (1):
      drm: index i shadowed in 2nd loop

vwadekar@nvidia.com (1):
      mfd: Avoid tps6586x burst writes
