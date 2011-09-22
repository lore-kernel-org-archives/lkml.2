Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1IVAdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 20:33:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53932 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1IVAdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 20:33:10 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Sep 2011 17:32:48 -0700
X-Google-Sender-Auth: FR1c3D4Lg7B-wre9GR4CSIn0qVw
Message-ID: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
Subject: Linux 3.1-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was supposed to do this on Monday, but it didn't seem to be hugely pressing.

Not only were there some patches under discussion, it is becoming
clear that I might as well not release the final 3.1 until after my
upcoming vacation early October - otherwise the next merge window
would just be total chaos. A merge window with kernel.org being off
just really wouldn't work, and doing a release only to then have some
chaotic merge window followed by travel seems crazy.

So here we are, two days late, but in no hurry.

We've actually fixed a few core regressions - they may not be easy to
hit (which is why it took so long), but we had a nasty dentry bug
(fixed by the first commit in the shortlog below) that admittedly was
only triggerable with NFS and some odd directory movement, but it was
still interesting to see something like that at this stage. Some
rather subtle dentry refcounting rules had resulted in an "obvious
cleanup" having broken a subtle rule about dentry parent lifetimes
etc.

We had some other "core" stuff too (wasting time looping over swap
page entries in find_get_pages), but as you can see from the shortlog,
most of it ends up being pretty peripheral. Mostly random driver
fixes, which is also backed up by the diffstat - 60% drivers, 8%
networking, 7% arch (arm and UM), 7% filesystem, 5% mm, random small
patches elsewhere.

                    Linus

---
Al Viro (7):
      restore pinning the victim dentry in vfs_rmdir()/vfs_rename_dir()
      um: fix oopsable race in line_close()
      um: winch_interrupt() can happen inside of free_winch()
      um: fix free_winch() mess
      um: PTRACE_[GS]ETFPXREGS had been wired on the wrong subarch
      um: clean arch_ptrace() up a bit
      um: fix strrchr() problems

Alex Deucher (2):
      drm/radeon/kms: fix typo in r100_blit_copy
      drm/radeon/kms: Make GPU/CPU page size handling consistent in
blit code (v2)

Alexander Sverdlin (1):
      init: carefully handle loglevel option on kernel cmdline.

Anand Gadiyar (1):
      mfd: Make omap-usb-host TLL mode work again

Andi Kleen (2):
      IRDA: Fix global type conflicts in net/irda/irsysctl.c v2
      watchdog: Initconst section fixes for watchdog

Andiry Xu (1):
      USB: xHCI: prevent infinite loop when processing MSE event

Andrew Vasquez (1):
      [SCSI] qla2xxx: Correct inadvertent loop state transitions
during port-update handling.

Anton Blanchard (3):
      ibmveth: Fix issue with DMA mapping failure
      ibmveth: Checksum offload is always disabled
      ibmveth: Fix checksum offload failure handling

Ariel Elior (1):
      bnx2x: Fix for a host coalescing bug which impared latency.

Arjan van de Ven (1):
      ALSA: pcm - fix race condition in wait_for_avail()

Arnd Bergmann (1):
      ASoC: Fix trivial build regression in Kirkwood I2S

Arun Easi (2):
      [SCSI] qla2xxx: T10 DIF - Handle uninitalized sectors.
      [SCSI] qla2xxx: T10 DIF - Fix incorrect error reporting.

Axel Lin (3):
      Input: cm109 - fix checking return value of usb_control_msg
      Input: adp5588-keys - remove incorrect modalias
      drivers/rtc/rtc-imxdi.c needs linux/sched.h

Banajit Goswami (1):
      ARM: S3C64XX: Remove un-used code backlight code on SMDK6410

Bart De Schuymer (1):
      netfilter: ebtables: fix ebtables build dependency

Ben Hutchings (4):
      alpha, gpio: GENERIC_GPIO default must be n
      Revert "sfc: Use write-combining to reduce TX latency" and follow-ups
      sfc: Use 64-bit writes for TX push where possible
      gianfar: Fix overflow check and return value for gfar_get_cls_all()

Ben Skeggs (1):
      drm/ttm: request zeroed system memory pages for new TT buffer objects

Benjamin Herrenschmidt (1):
      pci: Don't crash when reading mpss from root complex

Benny Halevy (1):
      MAINTAINERS: update e-mail address of Benny Halevy

Bjorn Helgaas (1):
      PNP: update pnp.debug usage (needs value on command line)

Brian King (1):
      ibmveth: Fix DMA unmap error

Carsten Emde (1):
      floppy: use del_timer_sync() in init cleanup

Caspar Zhang (1):
      mm/mempolicy.c: fix pgoff in mbind vma merge

Chad Dupuis (3):
      [SCSI] qla2xxx: Fix qla24xx revision check while enabling interrupts.
      [SCSI] qla2xxx: Double check for command completion if abort
mailbox command fails.
      [SCSI] qla2xxx: Update version number to 8.03.07.07-k.

Changhwan Youn (1):
      ARM: EXYNOS4: restart clocksource while system resumes

Chen Ganir (1):
      Bluetooth: Fixed BT ST Channel reg order

Chen Gong (1):
      ACPI APEI: Add Kconfig option IRQ_WORK for GHES

Chris Bagwell (1):
      Input: wacom - fix touch parsing on newer Bamboos

Christoph Hellwig (5):
      block: remove READ_META and WRITE_META
      block: separate priority boosting from REQ_META
      xfs: fix a use after free in xfs_end_io_direct_write
      hfsplus: fix filesystem size checks
      tcm_fc: Work queue based approach instead of managing own thread
and event based mechanism

Dan Williams (5):
      [SCSI] isci: fix sata response handling
      [SCSI] isci: fix 32-bit operation when CONFIG_HIGHMEM64G=n
      [SCSI] isci: dynamic interrupt coalescing
      [SCSI] isci: fix event-get pointer increment
      [SCSI] isci: add version number

Daniel Hellstrom (2):
      GRETH: RX/TX bytes were never increased
      GRETH: avoid overwrite IP-stack's IP-frags checksum

Daniel Mack (1):
      can: ti_hecc: include linux/io.h

Dave Hansen (3):
      make /proc/$pid/numa_maps gather_stats() take variable page size
      break out numa_maps gather_pte_stats() checks
      teach /proc/$pid/numa_maps about transparent hugepages

Dave Jiang (2):
      [SCSI] isci: Update MAINTAINERS entry for the isci driver
      [SCSI] isci: Adding documentation to API change and fixup sysfs
registration

David Henningsson (2):
      ALSA: HDA: Cirrus - fix "Surround Speaker" volume control name
      ALSA: HDA: Add support for IDT 92HD93

David Rientjes (1):
      numa: fix NUMA compile error when sysfs and procfs are disabled

David Vrabel (2):
      xen/e820: if there is no dom0_mem=, don't tweak extra_pages.
      mm: sync vmalloc address space page tables in alloc_vm_area()

David Ward (1):
      net: Align AF-specific flowi structs to long

Dmitry Kravkov (6):
      bnx2x: fix BRB thresholds for dropless_fc mode
      bnx2x: decrease print level to debug
      bnx2x: fix MF for 4-port devices
      bnx2x: don't reset device while reading its configuration.
      bnx2x: init fw_seq after undi_unload is done
      bnx2x: don't access removed registers on 57712 and above

Don Fry (1):
      iwlagn: workaround bug crashing some APs

Donggeun Kim (1):
      drivers/rtc/rtc-s3c.c: fix no occurrence of alarm interrupt

Eddie Wai (1):
      [SCSI] bnx2i: Fixed the endian on TTT for NOP out transmission

Eric Dumazet (5):
      netfilter: xt_rateest: fix xt_rateest_mt_checkentry()
      net: ipv4: relax AF_INET check in bind()
      tcp: Change possible SYN flooding messages
      caif: fix a potential NULL dereference
      tcp: fix build error if !CONFIG_SYN_COOKIES

Eric Seppanen (1):
      block: Fix queue_flag update when rq_affinity goes from 2 to 1

Fabio Estevam (1):
      ASoC: imx: Fix build warning of unused 'card' variable

Felix Fietkau (1):
      ath9k_hw: fix calibration on 5 ghz

Florian Westphal (1):
      netfilter: nf_queue: reject NF_STOLEN verdicts from userspace

Francois Romieu (2):
      r8169: remove erroneous processing of always set bit.
      r8169: do not enable the TBI for anything but the original 8169.

Gao feng (1):
      fib:fix BUG_ON in fib_nl_newrule when add new fib rule

Geert Uytterhoeven (1):
      genirq: Make irq_shutdown() symmetric vs. irq_startup again

George (2):
      rtlwifi: rtl8192su: Fix problem connecting to HT-enabled AP
      rtlwifi: Fix problem when switching connections

Greg Kroah-Hartman (1):
      USB: xhci: Set change bit when warm reset change is set.

Guenter Roeck (1):
      hwmon: (pmbus) Fix low limit temperature alarms

H Hartley Sweeten (2):
      lib/sha1.c: quiet sparse noise about symbol not declared
      watchdog: WatchDog Timer Driver Core - use passed watchdog_device

Hayes Wang (3):
      r8169: fix the reset setting for 8111evl
      r8169: add MODULE_FIRMWARE for the firmware of 8111evl
      r8169: fix WOL setting for 8105 and 8111evl

Henry Wong (1):
      ppp_generic: fix multilink fragment MTU calculation (again)

Hidetoshi Seto (1):
      btrfs: fix d_off in the first dirent

Ian Campbell (3):
      MAINTAINERS: Update ATLX driver maintainers
      MAINTAINERS: Update Cisco VIC driver maintainers
      MAINTAINERS: Update BNA 10G Maintainer

Igor Maravić (1):
      pkt_sched: cls_rsvp.h was outdated

Ingo van Lil (1):
      um: Save FPU registers between task switches

Jan Beulich (1):
      xen/i386: follow-up to "replace order-based range checking of
M2P table by linear one"

Jan Kara (2):
      mm: Cleanup clearing of BDI_pending bit in bdi_forker_thread()
      mm: Add comment explaining task state setting in bdi_forker_thread()

Jason Gerecke (2):
      Input: wacom - advertise BTN_TOOL_PEN and BTN_STYLUS for PenPartner
      Input: wacom - add POINTER and DIRECT device properties

Jean Delvare (1):
      hwmon: (coretemp) Initialize tmin

Jeff Kirsher (1):
      e1000: Fix driver to be used on PA RISC C8000 workstations

Jeff Layton (1):
      cifs: fix possible memory corruption in CIFSFindNext

Jeff Liu (1):
      BTRFS: Fix lseek return value for error

Jeff Skirvin (1):
      [SCSI] isci: Leave requests alone if already terminating.

Jeremy Fitzhardinge (1):
      xen: use non-tracing preempt in xen_clocksource_read()

Jesper Juhl (2):
      netfilter: ip_queue: Fix small leak in ipq_build_packet_message()
      drivers/misc/pti.c: give 'comm' function scope in
pti_control_frame_built_and_sent()

Jesse Brandeburg (1):
      ixgbe: fix possible null buffer error

Joe Jin (2):
      xen-blkback: Don't disconnect backend until state switched to
XenbusStateClosed.
      xen-blkback: fixed indentation and comments

Johan Hovold (2):
      mfd: Fix initialisation of tps65910 interrupts
      drivers/leds/ledtrig-timer.c: fix broken sysfs delay handling

Johannes Berg (3):
      mac80211: fix missing sta_lock in __sta_info_destroy
      iwlagn: fix stack corruption
      iwlagn: fix command queue timeout

Johannes Weiner (2):
      mm: vmscan: fix force-scanning small targets without swap
      memcg: Revert "memcg: add memory.vmscan_stat"

John Crispin (1):
      watchdog: lantiq: fix watchdogs timeout handling

Jonathan Neuschäfer (1):
      um: drivers/xterm.c: fix a file descriptor leak

Jonghwan Choi (1):
      ARM: EXYNOS4: Fix wrong pll type for vpll

Josef Bacik (1):
      Btrfs: only clear the need lookup flag after the dentry is setup

Jozsef Kadlecsik (2):
      netfilter: nf_ct_tcp: fix incorrect handling of invalid TCP option
      netfilter: nf_ct_tcp: wrong multiplication of
TCPOLEN_TSTAMP_ALIGNED in tcp_sack skips fastpath

Jurgen Kramer (1):
      Bluetooth: add support for 2011 mac mini

KAMEZAWA Hiroyuki (1):
      mm/mempolicy.c: make copy_from_user() provably correct

Kasper Pedersen (1):
      tg3: fix VLAN tagging regression

Kavan Smith (1):
      ipheth: iPhone 4 Verizon CDMA USB Product ID add

Kiran Patil (1):
      tcm_fc: Invalidation of DDP context for FCoE target in error conditions

Konrad Rzeszutek Wilk (1):
      xen/irq: Alter the locking to use a mutex instead of a spinlock.

Kukjin Kim (3):
      ARM: EXYNOS4: Fix return type of local_timer_setup()
      ARM: EXYNOS4: Fix routing timer interrupt to offline CPU
      ARM: SAMSUNG: fix to prevent declaring duplicated

Kyle Manna (2):
      mfd: Copy the device pointer to the twl4030-madc structure
      mfd: Check for twl4030-madc NULL pointer

Larry Finger (2):
      rt2800pci: Fix compiler error on PowerPC
      rtl2800usb: Fix incorrect storage of MAC address on big-endian platforms

Lars-Peter Clausen (3):
      ASoC: snd_soc_codec_{readable,writable}_register change default to true
      ASoC: Fix register cache sync register_writable WARN_ONs
      ASoC: Blackfin: bf5xx-ad193x: Fix codec device name

Lasse Collin (1):
      XZ: Fix incorrect XZ_BUF_ERROR

Len Brown (1):
      acpica: ACPI_MAX_SLEEP should be 2 sec, not 20

Li Zefan (3):
      Btrfs: fix pages truncation in btrfs_ioctl_clone()
      Btrfs: don't make a file partly checksummed through file clone
      Btrfs: don't change inode flag of the dest clone file

Lin Ming (1):
      netconsole: switch init_netconsole() to late_initcall

Linus Torvalds (4):
      asm alternatives: remove incorrect alignment notes
      Make TASKSTATS require root access
      Make taskstats round statistics down to nearest 1k bytes/events
      Linux 3.1-rc7

Linus Walleij (1):
      mach-integrator: fix VGA base regression

Maciej Żenczykowski (1):
      net: relax PKTINFO non local ipv6 udp xmit check

Manual Munz (1):
      b43: Fix beacon problem in ad-hoc mode

Marcin Tomczak (1):
      [SCSI] isci: change sas phy timeouts from 54us to 59us

Marcos Paulo de Souza (1):
      Documentation: networking: dmfe.txt: Remove the maintainer of
orphan networking driver

Marek Szyprowski (1):
      ARM: SAMSUNG: fix watchdog reset issue with clk_get()

Mark Brown (3):
      MAINTAINERS: Add some missed Wolfson files
      ASoC: Fix reporting of partial jack updates
      mfd: Fix value of WM8994_CONFIGURE_GPIO

Matthew Garrett (1):
      APEI: Fix WHEA _OSC call

Max Matveev (1):
      sctp: deal with multiple COOKIE_ECHO chunks

Michael S. Tsirkin (1):
      net: copy userspace buffers on device forwarding

Michel Dänzer (2):
      drm/radeon: Don't read from CP ring write pointer registers.
      drm/radeon: Unreference GEM object outside of spinlock in page
flip error path.

Ming Lei (2):
      mfd: Fix omap-usb-host build failure
      firewire: ohci: add no MSI quirk for O2Micro controller

Mohammed Shafi Shajakhan (1):
      ath9k: Fix kernel panic on unplugging the device

MyungJoo Ham (1):
      mfd: Set MAX8997 irq pointer

Naga Chumbalkar (2):
      drivers/cpufreq/pcc-cpufreq.c: avoid NULL pointer dereference
      watchdog: hpwdt: prevent multiple "NMI occurred" messages

Nicholas Bellinger (3):
      target: Skip non hex characters for VPD=0x83 NAA IEEE Registered Extended
      iscsi-target: Disable markers + remove dangerous local scope array usage
      iscsi-target: Fix sendpage breakage with proper
padding+DataDigest iovec offsets

Nicolas Pitre (1):
      ARM: Dove: fix second SPI initialization call

Oliver Neukum (1):
      Bluetooth: Fix timeout on scanning for the second time

Patrick McHardy (1):
      netfilter: update netfilter git URL

Pavel Shilovsky (1):
      CIFS: Fix ERR_PTR dereference in cifs_get_root

Peter Ujfalusi (1):
      ASoC: soc-dapm: Fix parameter comment for snd_soc_dapm_free

Pieter-Augustijn Van Malleghem (2):
      Input: bcm5974 - add MacBookAir4,1 trackpad support
      Bluetooth: Add MacBookAir4,1 support

Ping Cheng (1):
      Input: wacom - remove pressure for touch devices

Rajkumar Manoharan (3):
      ath9k_hw: Fix init mode register regression
      wireless: Reset beacon_found while updating regulatory
      wireless: Fix rate mask for scan request

Randy Dunlap (1):
      staging: fix comedi build when ISA_DMA_API is enabled but
COMEDI_PCI is not enabled

Robert Love (1):
      [SCSI] fcoe: Fix deadlock between fip's recv_work and rtnl

Roland Dreier (1):
      target: Fix race between multiple invocations of target_qf_do_work()

Roy Li (1):
      ipv6: fix a possible double free

Russell King (1):
      drivers/gpio/gpio-generic.c: fix build errors

Sachin Prabhu (1):
      nfs: Do not allow multiple mounts on same mountpoint when using -o noac

Sage Weil (1):
      Btrfs: reserve sufficient space for ioctl clone

Sanket Shah (1):
      netfilter: nf_ct_pptp: fix DNATed PPTP connection address translation

Sascha Hauer (1):
      mfd: Rename wm8350 static gpio_set_debounce()

Saurav Kashyap (3):
      [SCSI] qla2xxx: Acquire hardware lock while manipulating dsd list.
      [SCSI] qla2xxx: Save and restore irq in the response queue
interrupt handler.
      [SCSI] qla2xxx: Set the task attributes after memsetting fcp cmnd.

Seth Forshee (1):
      hfsplus: Fix kfree of wrong pointers in hfsplus_fill_super() error path

Seth Jennings (1):
      staging: zcache: fix cleancache crash

Shaohua Li (4):
      block: change force plug flush call order
      block: simplify force plug flush code a little bit
      slub: add slab with one free object to partial list tail
      mm: account skipped entries to avoid looping in find_get_pages

Shirish Pargaonkar (1):
      cifs: Fix broken sec=ntlmv2/i sec option (try #2)

Stanislaw Gruszka (2):
      iwlegacy: fix BUG_ON(info->control.rates[0].idx < 0)
      ipw2x00: fix rtnl mutex deadlock

Stefano Stabellini (1):
      xen: disable PV spinlocks on HVM

Steffen Klassert (1):
      xfrm: Perform a replay check after return from async codepaths

Stephen M. Cameron (2):
      [SCSI] hpsa: fix problem that OBDR devices are not detected
      [SCSI] hpsa: fix physical device lun and target numbering problem

Stephen Warren (1):
      arm/dt: Tegra: Update SDHCI nodes to match bindings

Steve French (1):
      Fix the conflict between rwpidforward and rw mount options

Takashi Iwai (2):
      ALSA: hda - Terminate the recursive connection search properly
      ALSA: hda/realtek - Fix auto-mute with HP+LO configuration

Tanmay Upadhyay (1):
      net: pxa168: Fix build errors by including interrupt.h

Tao Ma (1):
      block: Don't check QUEUE_FLAG_SAME_COMP in __blk_complete_request

Thadeu Lima de Souza Cascardo (1):
      um: disable CMPXCHG_DOUBLE as it breaks UML build

Thomas Abraham (1):
      ARM: EXYNOS4: fix incorrect pad configuration for keypad row lines

Thomas Gleixner (1):
      x86, iommu: Mark DMAR IRQ as non-threaded

Thomas Tuttle (1):
      workqueue: lock cwq access in drain_workqueue

Timur Tabi (1):
      ASoC: MPC5200: replace of_device with platform_device

Toshiharu Okada (3):
      pch_gbe: fixed the issue which receives an unnecessary packet.
      pch_gbe: added the process of FIFO over run error
      pch_gbe: support ML7831 IOH

Trond Myklebust (5):
      NFSv4: nfs4_proc_async_renew should use a GFP_NOFS allocation
      NFSv4: nfs4_proc_renew should be declared static
      NFSv4: The NFSv4.0 client must send RENEW calls if it holds a delegation
      NFSv4: renewd needs to be able to handle the NFS4ERR_CB_PATH_DOWN error
      NFS: Fix a typo in nfs_flush_multi

Vasu Dev (2):
      [SCSI] libfc: fix fc_eh_host_reset
      [SCSI] libfc: block SCSI eh thread for blocked rports

Vladislav Zolotarov (1):
      bnx2x: fix rx ring size report

WANG Cong (1):
      cris: fix a build error in drivers/tty/serial/crisv10.c

Wanlong Gao (1):
      blk-cgroup: be able to remove the record of unplugged device

Yan, Zheng (2):
      ipv4: Fix fib_info->fib_metrics leak
      ipv6: don't use inetpeer to store metrics for routes.

Yaniv Rosner (6):
      bnx2x: Fix ETS bandwidth
      bnx2x: Enable FEC for 57810-KR
      bnx2x: Remove fiber remote fault detection
      bnx2x: Fix XMAC loopback test
      bnx2x: Fix 578xx link LED
      bnx2x: Fix ethtool advertisement

Yi Zou (1):
      [SCSI] libfc: fix referencing to fc_fcp_pkt from the frame
pointer via fr_fsp()

Zheng Yan (1):
      tcp: fix validation of D-SACK

dpward (2):
      net: Make flow cache namespace-aware
      net: Handle different key sizes between address families in flow cache

nhorman (1):
      net: don't clear IFF_XMIT_DST_RELEASE in ether_setup

rajan.aggarwal85@gmail.com (1):
      net/can/af_can.c: Change del_timer to del_timer_sync
