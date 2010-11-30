Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab0K3Fg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 00:36:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab0K3Fg5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 00:36:57 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Nov 2010 21:36:03 -0800
Message-ID: <AANLkTikbjZXMio0CZ_AYGpi_8784EyWStK9sD23jSZzD@mail.gmail.com>
Subject: Linux 2.6.37-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suspected, spending most of the week in Japan made some kernel
developers break out in gleeful shouts of "let's send Linus patches
when he is jet-lagged, and see if we can confuse him even more than
usual". As a result -rc4 has about twice the commits that -rc3 had.

Why am I not surprised?

That said, it's still not huge by historical standards. In fact, in
the 2.6.3x series, only 2.6.31 had fewer commits (286 to 393) in its
-rc3. So things have been reasonably calm.

By pure number of lines, the most noticeable updates were to the tile
architecture and the SiS fbcon driver (40% and 10% respectively). The
rest is mostly random noise all around (half drivers, half elsewhere).

The most _noticeable_ change is that hopefully the NFS readdir
regression really got fixed now. And btrfs has a number of fixes, many
of them apparently found by xfsqa.

Other than that? The shortlog probably gives a reasonable view into
the random small changes (mostly one-liners, the diffstat really looks
fairly nice and flat apart from the tile and sisfb changes)

So give it a try, and report any regressions you see,

                          Linus

---
Aaro Koskinen (9):
      sisfb: delete obsolete PCI ROM bug workaround
      sisfb: delete fallback code for pci_map_rom()
      sisfb: delete dead SIS_XORG_XF86 code
      sisfb: delete redudant #define SIS_LINUX_KERNEL
      sisfb: use CONFIG_FB_SIS_301/315 instead of SIS301/315H
      sisfb: remove InPort/OutPort wrappers
      sisfb: replace SiS_SetMemory with memset_io
      sisfb: move the CONFIG warning to sis_main.c
      sisfb: delete osdef.h

Abhijith Das (1):
      GFS2: Userland expects quota limit/warn/usage in 512b blocks

Abhilash Kesavan (3):
      ARM: S3C24XX: Fix Demux error in UART3 irqs on S3C2443 and S3C2416
      ARM: S3C24XX: Fix UART3 submask on S3C2416 and S3C2443
      ARM: S5PV210: Fix sysdev related warning messages

Alan Stern (1):
      USB: EHCI: fix obscure race in ehci_endpoint_disable

Alberto Panizzo (1):
      mach-pcm037_eet: Fix section mismatch for eet_init_devices()

Alex Shi (1):
      sched: Fix volanomark performance regression

Alexey Dobriyan (1):
      tcp: restrict net.ipv4.tcp_adv_win_scale (#20312)

Anand Gadiyar (1):
      ARM: 6484/1: fix compile warning in mm/init.c

Anders Kaseorg (1):
      module: Update prototype for ref_module (formerly use_module)

Andiry Xu (3):
      xHCI: release spinlock when setup interrupt
      xHCI: fix wMaxPacketSize mask
      USB: EHCI: AMD periodic frame list table quirk

Andreas Mohr (1):
      ALSA: azt3328: period bug fix (for PA), add missing ACK on stop timer

Andrew Morton (1):
      arch/x86/include/asm/fixmap.h: mark __set_fixmap_offset as __always_inline

Anupam Chanda (1):
      e1000: fix screaming IRQ

Arnaldo Carvalho de Melo (1):
      perf record: Handle restrictive permissions in /proc/{kallsyms,modules}

Arnd Hannemann (1):
      fbdev: sh_mobile_lcdcfb: fix bug in reconfig()

Arne Jansen (1):
      btrfs: Fix early enospc because 'unused' calculated with wrong sign.

Arun Bharadwaj (1):
      Pure nfs client performance using odirect.

Axel Lin (27):
      ASoC: Fix snd_soc_register_dais error handling
      mmc: ushc: Return proper error code for ushc_probe()
      ASoC: Return proper error if snd_soc_register_dais fails in
psc_i2s_of_probe
      USB: isp1362-hcd - fix section mismatch warning
      ASoC: uda134x - set reg_cache_default to uda134x_reg
      ASoC: stac9766 - set reg_cache_default to stac9766_reg
      EDAC, MCE: Fix edac_init_mce_inject error handling
      ASoC: Do not update the cache if write to hardware failed
      ASoC: max98088 - fix a memory leak
      ASoC: wm8904 - fix memory leaks
      ASoC: wm8994 - fix memory leaks
      ASoC: wm8961 - clear WM8961_DACSLOPE bit for normal mode
      ASoC: wm8961 - clear WM8961_MCLKDIV bit for freq <= 16500000
      ASoC: Return proper error for omap3pandora_soc_init
      ASoC: nuc900-ac97: fix a memory leak
      drivers/misc/isl29020.c: remove incorrect kfree in isl29020_remove()
      ASoC: Call snd_soc_unregister_dais instead of
snd_soc_unregister_dai in sh4_soc_dai_remove
      ASoC: efika-audio-fabric: fix resource leak in efika_fabric_init
error path
      ASoC: pcm030-audio-fabric: fix resource leak in
pcm030_fabric_init error path
      ASoC: snd-soc-afeb9260: remove unneeded platform_device_del in error path
      ASoC: sam9g20_wm8731: fix resource leak in at91sam9g20ek_init error path
      ASoC: simone: fix resource leak in simone_init error path
      ASoC: imx-ssi: fix resource leak
      ASoC: phycore-ac97: fix resource leak
      ASoC: davinci-vcif - fix a memory leak
      ASoC: tlv320aic3x - fix variable may be used uninitialized warning
      ASoC: Fix resource reclaim for osk5912

Baruch Siach (1):
      mx25: fix spi device registration typo

Bastian Blank (1):
      xen/evtchn: Fix name of Xen event-channel device

Ben Hutchings (1):
      atl1c: Fix hardware type check for enabling OTP CLK

Breno Leitao (1):
      ehea: Add some info messages and fix an issue

Casey Leedom (1):
      cxgb4vf: fix setting unicast/multicast addresses ...

Chris Mason (4):
      Btrfs: add migrate page for metadata inode
      Btrfs: avoid NULL pointer deref in try_release_extent_buffer
      Btrfs: deal with DIO bios that span more than one ordered extent
      Btrfs: don't use migrate page without CONFIG_MIGRATION

Chris Metcalf (6):
      MAINTAINERS: add drivers/char/hvc_tile.c as maintained by tile
      arch/tile: fix rwlock so would-be write lockers don't block new readers
      drivers/net/tile/: on-chip network drivers for the tile architecture
      pci root complex: support for tile architecture
      arch/tile: make glibc's sysconf(_SC_NPROCESSORS_CONF) work correctly
      arch/tile: fix memchr() not to dereference memory for zero length

Chris Paulson-Ellis (1):
      ASoC: davinci: fixes for multi-component

Christian Lamparter (1):
      carl9170: fix virtual interface setup crash

Cyrill Gorcunov (1):
      net, ppp: Report correct error code if unit allocation failed

Daisuke Nishimura (1):
      memcg: avoid deadlock between move charge and try_charge()

Dan Carpenter (4):
      fbcmap: cleanup white space in fb_alloc_cmap()
      fbcmap: integer overflow bug
      UBI: release locks in check_corruption
      nilfs2: nilfs_iget_for_gc() returns ERR_PTR

Dan Rosenberg (1):
      DECnet: don't leak uninitialized stack byte

Daniel Drake (2):
      mmc: sdhci: Properly enable SDIO IRQ wakeups
      lxfb: Program panel v/h sync output polarity correctly

Daniel Klaffenbach (1):
      ssb: b43-pci-bridge: Add new vendor for BCM4318

Daniel T Chen (3):
      ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master
and Headphone controls
      ALSA: hda: Add Samsung R720 SSID for subwoofer pin fixup
      ALSA: hda: Use hp-laptop quirk to enable headphones automute for Asus A52J

Darius Augulis (1):
      ARM: S3C64XX: fix uart clock setup for mini6410/real6410

Darrick J. Wong (1):
      md: Call blk_queue_flush() to establish flush/fua support

Dave Airlie (1):
      Revert "debug_locks: set oops_in_progress if we will log messages."

David Daney (3):
      phylib: Use common page register definition for Marvell PHYs.
      phylib: Add support for Marvell 88E1149R devices.
      of/phylib: Use device tree properties to initialize Marvell PHYs.

David Henningsson (2):
      ALSA: HDA: Enable digital mic on IDT 92HD87B
      ALSA: HDA: Add an extra DAC for Realtek ALC887-VD

David S. Miller (1):
      tcp: Make TCP_MAXSEG minimum more correct.

David Sterba (1):
      mm: remove call to find_vma in pagewalk for non-hugetlbfs

Denis Kuplyakov (1):
      ALSA: hda - Fix Acer 7730G support

Dimitri Sivanich (1):
      x86: UV: Address interrupt/IO port operation conflict

Dimitris Papastamos (1):
      ASoC: WM8776: Removed unneeded struct member

Dmitry Artamonow (1):
      ASoC: fix SND_PXA2XX_LIB Kconfig warning

Don Zickus (1):
      x86, perf, nmi: Disable perf if counters are not accessible

Eric Bénard (2):
      mmc: sdhci-esdhc-imx: fix timeout on i.MX's sdhci
      mmc: sdhci-esdhc-imx: enable QUIRK_NO_MULTIBLOCK only for i.MX25
and i.MX35

Eric Dumazet (3):
      net: allow GFP_HIGHMEM in __vmalloc()
      af_unix: limit unix_tot_inflight
      af_unix: limit recursion level

Felix Fietkau (1):
      ath9k: fix timeout on stopping rx dma

Filip Aben (1):
      hso: fix disable_net

Florian Fainelli (1):
      ALSA: sound/mixart: avoid redefining {readl,write}_{le,be} accessors

Frederic Weisbecker (2):
      x86: Ignore trap bits on single step exceptions
      reiserfs: fix inode mutex - reiserfs lock misordering

Gerrit Renker (1):
      dccp: fix error in updating the GAR

Giuseppe CAVALLARO (3):
      sh: avoid to flush all cache in sys_cacheflush
      sh: fix vsyscall compilation due to .eh_frame issue
      sh: Use GCC __builtin_prefetch() to implement prefetch().

Greg Kroah-Hartman (8):
      USB: atm: ueagle-atm: fix up some permissions on the sysfs files
      USB: ehci: fix debugfs 'lpm' permissions
      USB: storage: sierra_ms: fix sysfs file attribute
      USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
      USB: misc: trancevibrator: fix up a sysfs attribute permission
      USB: misc: usbled: fix up some sysfs attribute permissions
      USB: misc: usbsevseg: fix up some sysfs attribute permissions
      USB: OTG: langwell_otg: fix up some sysfs attribute permissions

Greg Thelen (1):
      ioprio: grab rcu_read_lock in sys_ioprio_{set,get}()

Guennadi Liakhovetski (2):
      mmc: fix rmmod race for hosts using card-detection polling
      wireless: b43: fix error path in SDIO

Guenter Roeck (2):
      hwmon: (i5k_amb) Fix compile warning
      hwmon: (lis3lv02d_i2c) Fix compile warnings

Heiko Carstens (1):
      [S390] nmi: fix clock comparator revalidation

Herton Ronaldo Krzesinski (1):
      ALSA: hda - Fix ALC660-VD/ALC861-VD capture/playback mixers

Huang Weiyi (1):
      xen: remove duplicated #include

Ian Campbell (3):
      xen: implement XENMEM_machphys_mapping
      xen: make evtchn's name less generic
      xen: x86/32: perform initial startup on initial_page_table

Ian Kent (1):
      Btrfs - fix race between btrfs_get_sb() and umount

Jacob Pan (1):
      mmc: sdhci: Fix crash on boot with C0 stepping Moorestown platforms

James Jones (1):
      ARM: 6482/2: Fix find_next_zero_bit and related assembly

Jan Beulich (2):
      xen/evtchn: clear secondary CPUs' cpu_evtchn_mask[] after restore
      x86-64: Fix and clean up AMD Fam10 MMCONF enabling

Jan Glauber (1):
      [S390] qdio: free indicator after reset is finished

Janusz Krzysztofik (1):
      ASoC: OMAP: fix OMAP1 compilation problem

Jason Wessel (1):
      perf,hw_breakpoint: Initialize hardware api earlier

Jens Axboe (1):
      cciss: fix build for PROC_FS disabled

Jeremy Fitzhardinge (18):
      xen/evtchn: track enabled state for each port
      xen/evtchn: dynamically allocate port_user array
      xen/evtchn: ports start enabled
      xen/evtchn: remove spurious barrier
      xen/evtchn: don't do unbind_from_irqhandler under spinlock
      xen/evtchn: add missing static
      xen/blkfront: map REQ_FLUSH into a full barrier
      xen/blkfront: change blk_shadow.request to proper pointer
      xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER
      xen/blkfront: cope with backend that fail empty
BLKIF_OP_WRITE_BARRIER requests
      xen/xenfs: update xenfs_mount for new prototype
      xen/events: use locked set|clear_bit() for cpu_evtchn_mask
      Revert "xen/privcmd: create address space to allow writable mmaps"
      xen/evtchn: the evtchn device is non-seekable
      xen: add extra pages to balloon
      xen/balloon: the balloon_lock is useless
      xen/balloon: make sure we only include remaining extra ram
      xen: re-enable boot-time ballooning

Jesper Juhl (2):
      sound/oss: Remove unnecessary casts of void ptr
      ASoC: MPC5200: Eliminate duplicate include of of_device.h

Jesse Marroquin (1):
      ASoC: Add support for MAX98089 CODEC

Jiri Slaby (2):
      Char: virtio_console, fix memory leak
      NET: wan/x25_asy, move lapb_unregister to x25_asy_close_tty

Joe Perches (4):
      sound/oss/dev_table.c: Use vzalloc
      ALSA: sound/ppc: Use printf extension %pR for struct resource
      ALSA: sound/core/pcm_lib.c: Remove unnecessary semicolons
      ALSA: sound/pci/asihpi/hpioctl.c: Remove unnecessary casts of
pci_get_drvdata

John Fastabend (1):
      ipv6: fix missing in6_ifa_put in addrconf

Josef Bacik (11):
      Btrfs: handle the space_cache option properly
      Btrfs: handle NFS lookups properly
      Btrfs: fix more ESTALE problems with NFS
      Btrfs: use dget_parent where we can UPDATED
      Btrfs: hold i_mutex when calling btrfs_log_dentry_safe
      Btrfs: make btrfs_add_nondir take parent inode as an argument
      Btrfs: fix typo in fallocate to make it honor actual size
      Btrfs: make sure new inode size is ok in fallocate
      Btrfs: update inode ctime when using links
      Btrfs: fix fiemap
      Btrfs: setup blank root and fs_info for mount time

Josh Wu (1):
      USB: gadget: AT91: fix typo in atmel_usba_udc driver

Julia Lawall (1):
      ALSA: sound/pci/ctxfi/ctpcm.c: Remove potential for use after free

Justin Maggard (1):
      md: fix return value of rdev_size_change()

KAMEZAWA Hiroyuki (1):
      mm/page_alloc.c: fix build_all_zonelist() where percpu_alloc()
is wrongly called under stop_machine_run()

Kailang Yang (3):
      ALSA: hda - Fixed ALC887-VD initial error
      ALSA: hda - Fix wrong ALC269 variant check
      ALSA: hda - Identify more variants for ALC269

Ken Sumrall (1):
      fuse: fix attributes after open(O_TRUNC)

Kevin Hilman (1):
      OMAP: UART: don't resume UARTs that are not enabled.

Kirill A. Shutemov (1):
      memcg: fix false positive VM_BUG on non-SMP

Konrad Rzeszutek Wilk (2):
      xen: set IO permission early (before early_cpu_init())
      xen/events: Use PIRQ instead of GSI value when unmapping MSI/MSI-X irqs.

Kukjin Kim (1):
      ARM: S3C24XX: Fix wrong s3c_gpio_cfgpull

Kuninori Morimoto (6):
      ARM: mach-shmobile: clock-sh7372: remove fsidiv bogus disable
      ARM: mach-shmobile: ap4evb: FSI clock use proper process for HDMI
      ARM: mach-shmobile: ap4evb: FSI clock use proper process for ak4642
      ARM: mach-shmobile: clock-sh7372: modify error code
      ARM: mach-shmobile: clock-sh7372: remove unnecessary fsi clocks
      ARM: mach-shmobile: clock-sh7372: remove bogus pllc2 clock toggling.

Li Zefan (3):
      btrfs: Check if dest_offset is block-size aligned before cloning file
      btrfs: Set file size correctly in file clone
      btrfs: Show device attr correctly for symlinks

Linus Torvalds (4):
      Rename 'pipe_info()' to 'get_pipe_info()'
      Export 'get_pipe_info()' to other users
      Un-inline get_pipe_info() helper function
      Linux 2.6.37-rc4

Linus Walleij (1):
      ARM: 6488/1: nomadik: prevent sched_clock() wraparound

Loïc Minier (1):
      include/linux/fs.h: fix userspace build

Magnus Damm (1):
      ARM: mach-shmobile: sh7372 USB0/IIC1 MSTP fix

Manoj Iyer (1):
      ALSA: hda - Enable jack sense for Thinkpad Edge 11

Marek Belisko (1):
      ASoC: s3c24xx: Fix compilation problem for mini2440

Mariusz Kozlowski (1):
      btrfs: make 1-bit signed fileds unsigned

Mark Brown (8):
      ASoC: Check return value of strict_strtoul() in WM8962
      ASoC: Lock the CODEC in PXA external jack controls
      ASoC: Remove broken WM8350 direction constants
      ASoC: Ensure sane WM835x AIF configuration by default
      ASoC: Fix dapm_seq_compare() for multi-component
      ASoC: Fix register cache setup WM8994 for multi-component
      ASoC: Fix multi-component mismerge in WM8523
      ASoC: Restore WM8994 volatile and readable register operations

Masami Hiramatsu (1):
      x86/kprobes: Prevent kprobes to probe on save_args()

Matthew Garrett (1):
      tpm: Autodetect itpm devices

Mel Gorman (1):
      scripts: fix gfp-translate for recent changes to gfp.h

Miao Xie (3):
      btrfs: fix free dip and dip->csums twice
      btrfs: cleanup duplicate bio allocating functions
      btrfs: fix panic caused by direct IO

Michael S. Tsirkin (2):
      virtio: return correct capacity to users
      vhost/net: fix rcu check usage

Michal Hocko (1):
      cgroups: make swap accounting default behavior configurable

Mike Frysinger (1):
      fbdev: da8xx: punt duplicated FBIO_WAITFORVSYNC define

MyungJoo Ham (1):
      ARM: 6490/1: MM: bugfix: initialize spinlock for init_mm.context

Nagendra Tomar (1):
      inet: Fix __inet_inherit_port() to correctly increment bsockets
and num_owners

Naoya Horiguchi (1):
      pagemap: set pagemap walk limit to PMD boundary

NeilBrown (1):
      md/raid1: really fix recovery looping when single good device fails.

Nicolas Kaiser (1):
      SuperH IrDA: correct Baud rate error correction

Nikhil Rao (1):
      sched: Fix idle balancing

Ohad Ben-Cohen (2):
      mmc: sdio: fix nasty oops in mmc_sdio_detect
      mmc: sdio: fix runtime PM anomalies by introducing MMC_CAP_POWER_OFF_CARD

Paul Mundt (5):
      sh: clkfwk: Kill off unused clk_set_rate_ex().
      sh: clkfwk: Kill off now unused algo_id in set_rate op.
      sh: clkfwk: Disable init clk op for non-legacy clocks.
      MAINTAINERS: Add fbdev patchwork entry, tidy up file patterns.
      sh: clkfwk: Build fix for non-legacy CPG changes.

Paul Walmsley (1):
      OMAP2+: PM/serial: hold console semaphore while OMAP UARTs are disabled

Pavel Emelyanov (1):
      netns: Don't leak others' openreq-s in proc

Per Fransson (1):
      ARM: 6473/1: Small update to ux500 specific L2 cache code

Peter Rosin (1):
      ALSA: AT73C213: Rectify misleading comment.

Peter Zijlstra (4):
      perf: Fix owner-list vs exit
      perf, x86: Fixup Kconfig deps
      perf: Fix the software context switch counter
      powerpc: Use call_rcu_sched() for pagetables

Phil Blundell (3):
      econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
      econet: fix CVE-2010-3850
      econet: fix CVE-2010-3848

Philip Rakity (2):
      mmc: Fix printing of card DDR type
      mmc: sdhci: 8-bit bus width changes

Rabin Vincent (1):
      perf symbols: Remove incorrect open-coded container_of()

Rakib Mullick (1):
      x86, hw_nmi: Move backtrace_mask declaration under ARCH_HAS_NMI_WATCHDOG

Randy Dunlap (2):
      xen: fix header export to userspace
      dmar, x86: Use function stubs when CONFIG_INTR_REMAP is disabled

Raoul Bhatia (1):
      EDAC: Fix typos in Documentation/edac.txt

Robin@sgi.com (1):
      sgi-xpc: XPC fails to discover partitions with all nasids above 128

Russell King (4):
      ARM: improve compiler's ability to optimize page tables
      ARM: avoid marking decompressor .stack section as having contents
      SCSI: arm fas216: fix missing ';'
      ARM: avoid annoying <4>'s in printk output

Ryan Mallon (1):
      Fix Atmel soc audio boards Kconfig dependency

Ryusuke Konishi (1):
      nilfs2: fix typo in comment of nilfs_dat_move function

Samu Onkalo (6):
      drivers/leds/leds-lp5521.c: change some macros to functions
      drivers/leds/leds-lp5523.c: change some macros to functions
      drivers/leds/leds-lp5521.c: adjust delays and add comments to them
      drivers/leds/leds-lp5523.c: adjust delays and add comments to them
      drivers/leds/leds-lp5521.c: perform SW reset before detection
      drivers/leds/leds-lp5523.c: perform SW reset before detection

Sarah Sharp (2):
      xhci: Remove excessive printks with shared IRQs.
      xhci: Fix command ring replay after resume.

Sascha Hauer (10):
      ASoC i.MX eukrea tlv320: Fix for multicomponent
      ASoC i.MX phycore ac97: remove unnecessary includes
      ASoC i.MX: register dma audio device
      ASoC i.MX: switch to new DMA api
      phycore-ac97: add ac97 to cardname
      ARM mx3fb: check for DMA engine type
      ARM i.MX: sdma is merged, so remove #ifdef SDMA_IS_MERGED
      ARM i.MX pcm037 eet: compile fixes
      ARM i.MX spi: fix compilation for i.MX21
      ARM i.MX27 eukrea: Fix compilation

Sergey Senozhatsky (1):
      posix-cpu-timers: Rcu_read_lock/unlock protect find_task_by_vpid call

Sergio Aguirre (1):
      irq_work: Drop cmpxchg() result

Simon Horman (1):
      bonding: change list contact to netdev@vger.kernel.org

Sonny Rao (1):
      qlge: Fix incorrect usage of module parameters and netdev msg level

Stefan Richter (4):
      firewire: net: count stats.tx_packets and stats.tx_bytes
      firewire: net: fix memory leaks
      firewire: net: replace lists by counters
      firewire: net: throttle TX queue before running out of tlabels

Stefano Stabellini (1):
      xen: set vma flag VM_PFNMAP in the privcmd mmap file_op

Stephen Hemminger (1):
      virtio: fix format of sysfs driver/vendor files

Steven J. Magnani (1):
      nommu: yield CPU while disposing VM

Steven Rostedt (5):
      tracing: Fix module use of trace_bprintk()
      tracing: Force arch_local_irq_* notrace for paravirt
      tracing: Fix recursive user stack trace
      isdn: icn: Fix stack corruption bug.
      leds: fix bug with reading NAS SS4200 dmi code

Takashi Iwai (3):
      ALSA: atmel - Fix the return value in error path
      ALSA: Revert "ALSA: hda - Fix switching between dmic and mic
using the same mux on IDT/STAC"
      ALSA: hda - Use ALC_INIT_DEFAULT for really default initialization

Tetsuo Handa (1):
      x86, asm: Fix binutils 2.15 build failure

Thomas Gleixner (1):
      perf: Fix inherit vs. context rotation bug

Toshiharu Okada (2):
      pch_gbe dreiver: chang author
      pch_gbe driver: The wrong of initializer entry

Tracey Dent (2):
      EDAC: Remove deprecated kbuild goal definitions
      Net: ceph: Makefile: Remove unnessary code

Trond Myklebust (9):
      SUNRPC: Fix an infinite loop in call_refresh/call_refreshresult
      NFS: Buffer overflow in ->decode_dirent() should not be fatal
      NFS: Assume eof if the server returns no readdir records
      NFS: Fix a page leak in nfs_do_filldir()
      NFS: Fix a page leak in uncached_readdir()
      NFS: Fix the error handling in "uncached_readdir()"
      NFS: Don't ignore errors from nfs_do_filldir()
      NFS: Correct the array bound calculation in nfs_readdir_add_to_array
      NFS: Ensure we return the dirent->d_type when it is known

Uwe Kleine-König (1):
      backlight: grab ops_lock before testing bd->ops

Vasiliy Kulikov (4):
      xen: xenfs: privcmd: check put_user() return code
      ALSA: snd-atmel-abdac: test wrong variable
      ASoC: s3c24xx: test wrong variable
      ASoC: atmel: test wrong variable

Vasily Khoruzhick (2):
      ASoC: RX1950: Fix hw_params function
      ARM: S3C2410: Adapt h1940-bluetooth to gpiolib changes

Vicente Jimenez Aguilar (1):
      fbdev: Update documentation index file.

Vivek Goyal (2):
      blk-throttle: Fix calculation of max number of WRITES to be dispatched
      block: fix amiga and atari floppy driver compile warning

Will Deacon (1):
      ARM: 6489/1: thumb2: fix incorrect optimisation in usracc

Will Newton (1):
      uml: disable winch irq before freeing handler data

Wolfgang Grandegger (1):
      au1000_eth: fix invalid address accessing the MAC enable register

Yang Li (1):
      ucc_geth: fix ucc halt problem in half duplex mode

Yinghai Lu (1):
      x86: Use online node real index in calulate_tbl_offset()

kishore kadiyala (1):
      mmc: omap4: hsmmc: Fix improper card detection while booting
