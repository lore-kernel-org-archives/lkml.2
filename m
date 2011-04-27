Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab1D0EbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 00:31:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218Ab1D0EbA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 00:31:00 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Apr 2011 21:30:09 -0700
Message-ID: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
Subject: Linux 2.6.39-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another keyboard destroyed by spilling coffee on it..
C'est la vie.

We have slightly fewer commits than in -rc4, which is good. At the
same time, I have to berate some people for merging some dubious
regression fixes. Sadly, the "people" I have to berate is me, because
-rc5 contains what technically _is_ a regression, but it's a
performance thing, and it's a bit scary. It's the patches from Andi
(with some editing by Eric) to make it possible to do the whole RCU
pathname walk even if you have SElinux enabled.

I've been alternately kicking myself for merging it, and just being so
pleased with the rcu pathname walk now extending outside of the
no-security confines ... I dunno. The patches are all pretty simple
(there's also a few dentry cleanup patches that were the result of me
looking at profiles and generated code), and it really is a rather
important performance thing, but at the same time I would shout at
others for trying to merge it to me this late. So I'll consider myself
properly chastised.

Other than that? We should have all the fallout from the block layer
plugging changes fixed now, and Tejun fixed the infinite CD-ROM
disk-change notification thing. So that's hopefully all good and done.

And then there are all the usual driver noise (including some hwmon
documentation), some ecryptfs and gfs2 updates and just various small
random fixups. The diffstat actually looks pretty good, most of it is
just one-liners and stuff like a few new device ID's etc.

Go forth and test,

                     Linus

---
Alex Deucher (4):
      drm/radeon/kms: fix bad shift in atom iio table parser
      drm/radeon/kms: add connectors even if i2c fails
      drm/radeon/kms: adjust evergreen display watermark setup
      drm/radeon/kms: pll tweaks for r7xx

Alex Williamson (2):
      intel-iommu: Unlink domain from iommu
      intel-iommu: Fix get_domain_for_dev() error path

Amit Kumar Salecha (1):
      qlcnic: limit skb frags for non tso packet

Amit Shah (3):
      virtio: Decrement avail idx on buffer detach
      virtio_pci: Prevent double-free of pci regions after device hot-unplug
      virtio: console: Enable call to hvc_remove() on console port remove

Anatolij Gustschin (1):
      net: can: mscan: fix build breakage in mpc5xxx_can

Andi Kleen (2):
      perf: Support Xeon E7's via the Westmere PMU driver
      SECURITY: Move exec_permission RCU checks into security modules

Andre Przywara (1):
      perf, x86: Fix pre-defined cache-misses event for AMD family 15h cpus

Arnaldo Carvalho de Melo (1):
      perf evsel: Fix use of inherit

Artem Bityutskiy (3):
      UBIFS: fix false space checking failure
      UBIFS: fix false assertion warning in case of I/O failures
      UBIFS: fix master node recovery

Axel Lin (1):
      RTC: rtc-omap: Fix a leak of the IRQ during init failure

Ben Hutchings (4):
      sfc: Do not use efx_process_channel_now() in online self-test
      net: Disable all TSO features when SG is disabled
      net: Disable NETIF_F_TSO_ECN when TSO is disabled
      kconfig: Avoid buffer underrun in choice input

Ben Skeggs (4):
      drm/nouveau: split ramin_lock into two locks, one hardirq safe
      drm/nouveau: fix nv30 pcie boards
      drm/nouveau: populate ttm_alloced with false, when it's not
      drm/nouveau: fix pinning of notifier block

Benjamin Marzinski (1):
      GFS2: directly write blocks past i_size

Bob Peterson (2):
      GFS2: write_end error path fails to unlock transaction lock
      GFS2: filesystem hang caused by incorrect lock order

Borislav Petkov (3):
      amd64_edac: Remove node interleave warning
      amd64_edac: Factor in CC6 save area
      amd64_edac: Erratum #637 workaround

Brian Cavagnolo (1):
      mwl8k: do not free unrequested irq

Carsten Otte (1):
      [S390] kvm-390: Let kernel exit SIE instruction on work

Chris Mason (1):
      Btrfs: do some plugging in the submit_bio threads

Chris Wilson (2):
      drm/i915: Sanitize the output registers after resume
      drm/i915: Initialise g4x watermarks for disabled pipes

Christian Lamparter (1):
      ath: add missing regdomain pair 0x5c mapping

Christoph Hellwig (1):
      add hlist_bl_lock/unlock helpers

CoolCold (1):
      md: Update documentation for sync_min and sync_max entries

Cyrill Gorcunov (1):
      perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask on overflow

Cédric Cano (1):
      drm/radeon/kms: fix IH writeback on r6xx+ on big endian machines

Dave Chinner (1):
      xfs: fix duplicate message output

Dave Jones (1):
      irda: fix locking unbalance in irda_sendmsg

David Rientjes (2):
      Revert "x86, NUMA: Fix fakenuma boot failure"
      x86, numa: Fix cpu nodemasks for NUMA emulation and
CONFIG_DEBUG_PER_CPU_MAPS

David S. Miller (3):
      llc: Fix length check in llc_fixup_skb().
      ieee802154: Remove hacked CFLAGS in net/ieee802154/Makefile
      Revert "tcp: disallow bind() to reuse addr/port"

David Sterba (1):
      btrfs: add missing spin_unlock to a rare exit path

Dilan Lee (1):
      ASoC: WM8903: HP and Line out PGA/mixer DAPM fixes

Eric Dumazet (3):
      bridge: reset IPCB in br_parse_ip_options
      inetpeer: reduce stack usage
      ip: ip_options_compile() resilient to NULL skb route

Eric Paris (1):
      SELINUX: Make selinux cache VFS RCU walks safe

Felix Fietkau (2):
      ath9k: fix missing ath9k_ps_wakeup/ath9k_ps_restore calls
      ath9k_hw: fix stopping rx DMA during resets

Francois Romieu (1):
      r8169: add Realtek as maintainer.

Giuseppe CAVALLARO (3):
      stmmac: fixed dma lib build when turn-on the debug option
      stmmac: fix open funct when exit on error
      stmmac: fix Transmit Underflow error

Guennadi Liakhovetski (1):
      ASoC: add a module alias to the FSI driver

Guenter Roeck (7):
      hwmon: Add submitting-patches checklist to documentation
      hwmon: (pmbus) Removed unused variable from struct pmbus_data
      hwmon: (smm665) Fix spelling error in driver documentation
      hwmon: (pmbus) Documentation updates
      hwmon: (max8688) Add driver documentation
      hwmon: (max16064) Add driver documentation
      hwmon: (max34440) Add driver documentation

Hannes Reinecke (1):
      ahci: EM supported message type sysfs attribute

Heiko Carstens (1):
      [S390] pfault: fix token handling

Igor Plyatov (2):
      ata: pata_at91.c bugfix for high master clock
      ata: pata_at91.c bugfix for initial_timing initialisation

Ingo Molnar (1):
      x86, perf event: Turn off unstructured raw event access to
offcore registers

Itaru Kitayama (1):
      btrfs: fix wrong allocating flag when reading page

J. Bruce Fields (1):
      nfsd4: fix struct file leak on delegation

Jan Glauber (3):
      [S390] prng: prevent access beyond end of stack
      [S390] fix page table walk for changing page attributes
      [S390] qdio: reset error states immediately

Jan Kara (1):
      vfs: Pass setxattr(2) flags properly

Jan Kiszka (1):
      intel-iommu: Fix use after release during device attach

Jason Conti (1):
      p54: Initialize extra_len in p54_tx_80211

Jassi Brar (1):
      MAINTAINERS: Update Samsung ASoC maintainer's id

Jeff Mahoney (1):
      libata: Pioneer DVR-216D can't do SETXFER

Jens Axboe (5):
      block: kill blk_flush_plug_list() export
      cfq-iosched: read_lock() does not always imply rcu_read_lock()
      block: get rid of QUEUE_FLAG_REENTER
      block: remove stale kerneldoc member from __blk_run_queue()
      elevator: check for ELEVATOR_INSERT_SORT_MERGE in !elvpriv case too

Jian Peng (1):
      libata: ahci_start_engine compliant to AHCI spec

Joakim Tjernlund (1):
      net: Do not wrap sysctl igmp_max_memberships in IP_MULTICAST

Joerg Roedel (3):
      x86, gart: Convert spaces to tabs in enable_gart_translation
      x86, gart: Set DISTLBWALKPRB bit always
      x86, gart: Make sure GART does not map physmem above 1TB

Johannes Berg (1):
      iwlagn: override 5300 EEPROM # of chains

John W. Linville (1):
      iwlegacy: make iwl3945 and iwl4965 select IWLWIFI_LEGACY

Jonathan Cameron (1):
      ARM: 6881/1: cputype.h uses __attribute_const__ which requires
including kernel.h

Josef Bacik (2):
      Btrfs: free bitmaps properly when evicting the cache
      Btrfs: put the right bio if we have an error

Joseph Cihula (1):
      intel_iommu: disable all VT-d PMRs when TXT launched

Jozsef Kadlecsik (5):
      netfilter: ipset: list:set timeout variant fixes
      netfilter: ipset: References are protected by rwlock instead of mutex
      netfilter: ipset: bitmap:ip,mac type requires "src" for MAC
      netfilter: ipset: set match and SET target fixes
      netfilter: ipset: Fix the order of listing of sets

Krishna Kumar (1):
      ip6_pol_route panic: Do not allow VLAN on loopback

Krzysztof Wojcik (1):
      md: Cleanup after raid45->raid0 takeover

Kuninori Morimoto (3):
      ASoC: fsi: take care in failing case of dai register
      ASoC: fsi: modify vague PM control on probe
      ASoC: fsi: driver safely remove for against irq

Lars-Peter Clausen (2):
      ASoC: codecs: JZ4740: Fix OOPS
      ARM: s3c2440: gta02; Register dfbmcs320 device for BT audio interface

Li Zefan (1):
      Btrfs: Free free_space item properly in btrfs_trim_block_group()

Lin Ming (1):
      perf hists browser: Fix seg fault when annotate null symbol

Linus Torvalds (5):
      Revert "[media] V4L: videobuf, don't use dma addr as physical"
      vfs: get rid of 'struct dcache_hash_bucket' abstraction
      vfs: get rid of insane dentry hashing rules
      bit_spinlock: don't play preemption games inside the busy loop
      Linux 2.6.39-rc5

Linus Walleij (2):
      mach-ux500: fix i2c0 device setup regression
      rtc: fix coh901331 startup crash

Liu Yuan (1):
      block, blk-sysfs: Fix an err return path in blk_register_queue()

Lu Guanqun (4):
      ASoC: check channel mismatch between cpu_dai and codec_dai
      ASoC: fix config error path
      ASoC: sst_platform: Fix lock acquring
      ASoC: sn95031: decorate function with __devexit_p()

Marcin Slusarz (2):
      drm/nouveau: fix notifier memory corruption bug
      drm/nouveau: fix allocation of notifier object

Mark Brown (2):
      ASoC: Set left channel volume update bits for WM8994
      ASoC: Fix output PGA enabling in wm_hubs CODECs

Markus Trippelsdorf (1):
      EDAC: Remove debugging output in scrub rate handling

Mathew McKernan (2):
      drm/i915/tv: Remember the detected TV type
      drm/i915/tv: Only poll for TV connections

Maxime Bizon (1):
      ahci: don't enable port irq before handler is registered

Mike Waychison (1):
      ALSA: hda - Fix unused warnings when !SND_HDA_NEEDS_RESUME

Mikhail Kshevetskiy (1):
      tty/n_gsm: fix bug in CRC calculation for gsm1 mode

Neil Turton (2):
      sfc: Stop the TX queues during loopback self-tests
      sfc: Use rmb() to ensure reads occur in order

NeilBrown (2):
      md/raid5: remove setting of ->queue_lock
      md: Fix dev_sectors on takeover from raid0 to raid4/5

Niels de Vos (1):
      parport_pc.c: correctly release the requested region for the IT887x

OGAWA Hirofumi (1):
      nfsd4: Fix filp leak

Otavio Salvador (2):
      net/sis900: store MAC into perm_addr for SiS 900, 630E, 635 and
96x variants
      net/natsami: store MAC into perm_addr

Patrick McHardy (1):
      connector: fix skb double free in cn_rx_skb()

Pavel Shilovsky (1):
      CIFS: Fix memory over bound bug in cifs_parse_mount_options

Peter Pan(潘卫平) (5):
      bonding:set save_load to 0 when initializing
      bonding:delete unused alb_timer
      bonding:delete unused rlb_interval_counter
      net: fix tranmitted/tranmitting typo
      bonding:fix two typos

Peter Zijlstra (1):
      perf, x86: Update/fix Intel Nehalem cache events

Rafael J. Wysocki (2):
      PM: Fix error code paths executed after failing syscore_suspend()
      PM: Add missing syscore_suspend() and syscore_resume() calls

Randy Dunlap (3):
      PCI: pci-label: Fix build failure when CONFIG_NLS is set to 'm'
by allmodconfig
      raid5: fix build error, sector_t usage
      init/Kconfig: fix EXPERT menu list

Rasesh Mody (2):
      bna: fix for clean fw re-initialization
      bna: fix memory leak during RX path cleanup

Raymond Yau (1):
      ALSA: emu10k1 - Fix "Music" controls to "Synth" controls in documents

Richard Cochran (1):
      posix clocks: Replace mutex with reader/writer semaphore

Robert Richter (1):
      perf, x86: Fix AMD family 15h FPU event constraints

Russell King (1):
      ARM: Add new syscalls

Sachin Prabhu (1):
      Open with O_CREAT flag set fails to open existing files on non
writable directories

Sangbeom Kim (1):
      ASoC: SAMSUNG: Fix the inverted clocks handling for pcm driver

Seth Heasley (3):
      ata_piix: IDE-mode SATA patch for Intel Panther Point DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Panther Point DeviceIDs
      watchdog: iTCO_wdt: TCO Watchdog patch for Intel Panther Point PCH

Sitsofe Wheeler (1):
      drm/i915/tv: Fix modeset flickering introduced in 7f58aabc3

Sjur Brændeland (2):
      caif: Bugfix use for_each_safe when removing list nodes.
      caif: performance bugfix - allow radio stack to prioritize packets.

Stanislaw Gruszka (1):
      iwlegacy: fix tx_power initialization

Stefan Weinhuber (2):
      [S390] dasd: fix race between open and offline
      [S390] dasd: check sense type in device change handler

Stefano Stabellini (2):
      xen: do not create the extra e820 region at an addr lower than 4G
      xen: mask_rw_pte: do not apply the early_ioremap checks on x86_32

Stephen Warren (1):
      ASoC: Tegra: Suspend/resume support

Steven Whitehouse (1):
      GFS2: Don't try to deallocate unlinked inodes when mounted ro

Sujith Manoharan (1):
      ath9k_htc: Fix ethtool reporting

Takashi Iwai (1):
      ALSA: hda - Add a fix-up for Acer dmic with ALC271x codec

Tao Ma (1):
      block: Remove the extra check in queue_requests_store

Tejun Heo (4):
      block: don't propagate unlisted DISK_EVENTs to userland
      ide: unexport DISK_EVENT_MEDIA_CHANGE for ide-gd and ide-cd
      libata: Kill unused ATA_DFLAG_{H|D}IPM flags
      libata: Implement ATA_FLAG_NO_DIPM and apply it to mcp65

Thomas Gleixner (1):
      xtensa: Fixup irq conversion fallout and nmi_count

Tsutomu Itoh (3):
      Btrfs: fix missing mutex_unlock in btrfs_del_dir_entries_in_log()
      Btrfs: check return value of kmalloc()
      Btrfs: cleanup error handling in inode.c

Tyler Hicks (5):
      eCryptfs: Remove extra d_delete in ecryptfs_rmdir
      eCryptfs: dput dentries returned from dget_parent
      eCryptfs: Add reference counting to lower files
      eCryptfs: Handle failed metadata read in lookup
      eCryptfs: Flush dirty pages in setattr

Uwe Kleine-König (1):
      serial/imx: read cts state only after acking cts change irq

Vasiliy Kulikov (2):
      agp: fix OOM and buffer overflow
      agp: fix arbitrary kernel memory writes

Vlad Yasevich (1):
      sctp: fix oops when updating retransmit path with DEBUG on

Wei Yongjun (1):
      sctp: fix oops while removed transport still using as retran path

Yaniv Rosner (1):
      bnx2x: Fix port identification problem

amit salecha (1):
      netxen: limit skb frags for non tso packet

huajun li (1):
      usbnet: Fix up 'FLAG_POINTTOPOINT' and 'FLAG_MULTI_PACKET' overlaps.
