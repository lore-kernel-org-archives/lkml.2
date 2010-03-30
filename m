Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0C3Ryt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:54:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657Ab0C3Ryr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:54:47 -0400
Date: Tue, 30 Mar 2010 10:50:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.34-rc3
Message-ID: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, so -rc2 was messy, no question about it. I'm too much of a softie to 
hold back some peoples work, so my hard-line -rc1 didn't work out the way 
I wanted. But _next_ time! For sure this time.

Anyway, from a messy -rc2 we now have a -rc3 that should be in much better 
shape. Regressions fixed, and the ShortLog is short enough to be worth 
posting to lkml (-rc1 never is, and -rc2 seldom is. It's not like -rc2's 
are generally wondeful, this time around wasn't _that_ much different).

One regression fix that is worth pointing out is the EXT3_STATE_NEW 
handling in ext3, because the regression that one fixed was potentially 
quite nasty. It wouldn't cause data corruption, but it _could_ cause 
at least corrupt security labels.

So if you have SELinux enabled (either in permissive or enforcing mode) 
_and_ you ran 2.6.32-rc[12] _and_ your filesystem is ext3, you should not 
just update, you should make sure your extended attributes are fixed. The 
easiest way to fix them is likely to just check the "Relabel on next boot" 
checkmark in the SELinux config GUI ("system-config-selinux" if you don't 
do that whole admin menu thing), and reboot into 2.6.34-rc3.

[ And you can use something like 'restorecon -rv /' or whatever after 
  booting into the fixed kernel. See your nearest SELinux manual for real 
  details. ]

You might even want to do the whole "touch /forcefsck" before rebooting to 
make sure fsck runs (I don't think it matters, but it won't hurt - the 
relabeling will be so slow that whatever time your fsck takes is totally 
irrelevant, so do them both and get it over with).

Of course, I suspect most people who run experimental kernels are also the 
kinds of people who have turned off SELinux in annoyance long ago, or tend 
to be the kinds of people who long since upgraded to ext4 (which didn't 
have the problem), but hey, what do I know.

In short - if you started seeing odd security messages after running early 
2.6.34 -rc kernels, now you know what was going on.

Other than that? Random fixes and updates all over. Mostly drivers and 
filesystems, and mostly fairly small things. If you had PCI resource 
conflict problems with the early -rc's due to the _CRS window thing, for 
example, that should hopefully be fixed. See the appended shortlog for 
other details.

		Linus

---
Abraham Arce (1):
      KS8851: Avoid NULL pointer in set rx mode

Adel Gadllah (1):
      iwlwifi: Silence tfds_in_queue message

Adrian Hunter (1):
      mmc: fix incorrect interpretation of card type bits

Al Viro (1):
      Restore LOOKUP_DIRECTORY hint handling in final lookup on open()

Alexander Duyck (3):
      igb: only use vlan_gro_receive if vlans are registered
      skbuff: remove unused dma_head & dma_maps fields
      igb: use correct bits to identify if managability is enabled

Alexandra Kossovsky (1):
      tcp: Fix OOB POLLIN avoidance.

Amerigo Wang (1):
      netpoll: warn when there are spaces in parameters

Ameya Palande (1):
      regulator: Get rid of lockdep warning

Amit Kumar Salecha (4):
      netxen: fix bios version calculation
      netxen: fix warning in ioaddr for NX3031 chip
      netxen: added sanity check for pci map
      netxen: update version to 4.0.73

Amit Shah (2):
      virtio: console: Generate a kobject CHANGE event on adding 'name' attribute
      virtio: console: Check if port is valid in resize_console

Andreas Bombe (1):
      sh64: Remove long unused mid_sched macro

Andreas Herrmann (1):
      x86, amd: Restrict usage of c1e_idle()

Andrei Emeltchenko (1):
      Bluetooth: Fix kernel crash on L2CAP stress tests

Andrew Morton (2):
      timer stats: Fix del_timer_sync() and try_to_del_timer_sync()
      kernel/sched.c: Suppress unused var warning

Andy Gospodarek (1):
      bonding: fix broken multicast with round-robin mode

Anton Blanchard (1):
      ppc64 sys_ipc breakage in 2.6.34-rc2

Arnaldo Carvalho de Melo (2):
      perf top: Improve the autosizing of column lenghts
      perf top: Add missing initialization to zero

Axel Lin (2):
      lp3971: Fix setting val for LDO2 and LDO4
      lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic

Ben Blum (1):
      cgroups: net_cls as module

Ben Menchaca (1):
      gianfar: fix undo of reserve()

Benjamin Li (1):
      bnx2: Fix netpoll crash.

Bjorn Helgaas (11):
      resources: add interfaces that return conflict information
      PCI: for address space collisions, show conflicting resource
      PCI: break out primary/secondary/subordinate for readability
      PCI: make disabled window printk style match the enabled ones
      PCI: print resources consistently with %pR
      PCI: complain about devices that seem to be broken
      PCI: don't say we claimed a resource if we failed
      x86/PCI: remove redundant warnings
      frv/PCI: remove redundant warnings
      x86/PCI: for host bridge address space collisions, show conflicting resource
      x86/PCI: truncate _CRS windows with _LEN > _MAX - _MIN + 1

Borislav Petkov (2):
      edac, mce: Filter out invalid values
      fs/binfmt_aout.c: fix pointer warnings

Brandon L Black (1):
      net: Add MSG_WAITFORONE flag to recvmmsg

Carolyn Wyborny (1):
      igb: Add support for 82576 ET2 Quad Port Server Adapter

Cheng Renquan (1):
      ceph: some documentations fixes

Chris Leech (1):
      ixgbe: filter FIP frames into the FCoE offload queues

Chris Wilson (1):
      drm/i915: Avoid NULL deref in get_pages() unwind after error.

Christian Borntraeger (1):
      [S390] system.h: Fix compile error for 1 and 2 byte cmpxchg

Christian Lamparter (2):
      [ARM] Kirkwood: WPS button keycode mapping
      [ARM] Orion5x: replace KEY_WLAN with KEY_WPS_BUTTON

Clemens Ladisch (4):
      firewire: core: fw_iso_resource_manage: fix error handling
      firewire: ohci: add cycle timer quirk for the TI TSB12LV22
      ALSA: cmipci: work around invalid PCM pointer
      PCI quirk: RS780/RS880: work around missing MSI initialization

Colin Ian King (1):
      softlockup: Stop spurious softlockup messages due to overflow

Crane Cai (1):
      i2c-scmi: Support IBM SMBus CMI devices

Daisuke Nishimura (1):
      memcg: disable move charge in no mmu case

Dan Carpenter (11):
      drm/i915: fix small leak on overlay error path
      sunrpc: handle allocation errors from __rpc_lookup_create()
      pxa168fb: fix incorrect resource calculation
      AFS: Potential null dereference
      regulator: handle kcalloc() failure
      ceph: handle kmalloc() failure
      af_key: return error if pfkey_xfrm_policy2msg_prep() fails
      memcontrol: fix potential null deref
      kcore: fix test for end of list
      fscache: add missing unlock
      hwmon: (w83793) Saving negative errors in unsigned

Daniel Chen (1):
      ALSA: ac97: Add Toshiba P500 to ac97 jack sense blacklist

Daniel Mack (2):
      ASoC: pxa-pcm-lib: initialize DMA channel to -1
      [ARM] pxa/raumfeld: fix button name

Daniel T Chen (3):
      ALSA: hda: Fix 0 dB offset for HP laptops using CX20551 (Waikiki)
      ALSA: ac97: Add IBM ThinkPad R40e to Headphone/Line Jack Sense blacklist
      ALSA: hda: Use LPIB for ga-ma770-ud3 board

Daniel Taylor (1):
      fs/partitions/msdos: add support for large disks

Daniel Vetter (1):
      drm/intel: fix up set_tiling for untiled->tiled transition

Darrick J. Wong (2):
      acpi: Support IBM SMBus CMI devices
      i2c-scmi: Provide module aliases for automatic loading

Dave Airlie (1):
      slow-work: use get_ref wrapper instead of directly calling get_ref

David Howells (9):
      nommu: fix an incorrect comment in the do_mmap_shared_file()
      Document Linux's circular buffering capabilities
      FDPIC: For-loop in elf_core_vma_data_size() is incorrect
      do_sync_read/write() should set kiocb.ki_nbytes to be consistent
      NOMMU: Revert 'nommu: get_user_pages(): pin last page on non-page-aligned start'
      NOMMU: Fix __get_user_pages() to pin last page on offset buffers
      SLOW_WORK: CONFIG_SLOW_WORK_PROC should be CONFIG_SLOW_WORK_DEBUG
      frv/chris: fix lines with a missing semicolons
      KEYS: Add MAINTAINERS record

David Härdeman (1):
      kfifo: fix KFIFO_INIT in include/linux/kfifo.h

David S. Miller (7):
      via-velocity: Fix FLOW_CNTL_TX_RX handling in set_mii_flow_control()
      isdn: Add netdev to lists in MAINTAINERS entry.
      Revert "r8169: enable 64-bit DMA by default for PCI Express devices (v2)"
      Revert "via82cxxx: workaround h/w bugs"
      tulip: Add missing parens.
      Revert "ide: skip probe if there are no devices on the port (v2)"
      sparc64: Properly truncate pt_regs framepointer in perf callback.

Dean Nelson (4):
      PCI: fix return value from pcix_get_max_mmrbc()
      PCI: fix access of PCI_X_CMD by pcix get and set mmrbc functions
      PCI: cleanup error return for pcix get and set mmrbc functions
      hwmon: (coretemp) Add missing newline to dev_warn() message

Derek Kelly (1):
      ALSA: hda - Add support of Nvidia GT220 HDMI

Dmitry Torokhov (1):
      Regulators: max8925-regulator - clean up driver data after removal

Dominik Brodowski (4):
      pcmcia: do not use ioports < 0x100 on x86
      pcmcia: allow for four multifunction subdevices (again)
      power: support _noirq actions on device types and classes
      pcmcia: use dev_pm_ops for class pcmcia_socket_class

Emil Tantilov (4):
      igb: do not modify tx_queue_len on link speed change
      igbvf: do not modify tx_queue_len on link speed change
      e1000e: do not modify tx_queue_len on link speed change
      e1000: do not modify tx_queue_len on link speed change

Eric Anholt (6):
      drm/i915: Don't bother with the BKL for GEM ioctls.
      drm/i915: Enable VS timer dispatch.
      agp/intel: Respect the GTT size on Sandybridge for scratch page setup.
      agp/intel: Don't do the chipset flush on Sandybridge.
      drm/i915: Set up the documented clock gating on Sandybridge and Ironlake.
      drm/i915: Stop trying to use ACPI lid status to determine LVDS connection.

Eric Dumazet (3):
      net: Potential null skb->dev dereference
      netfilter: xt_hashlimit: dl_seq_stop() fix
      netfilter: xt_hashlimit: IPV6 bugfix

Eric Miao (3):
      [ARM] mmp: fix for variables in uncompress.h being discarded
      [ARM] pxa: remove unnecessary 'select FB_W100' from some platforms
      [ARM] pxa/sharpsl: add dependency of max1111 driver to sharpsl_pm

Eric Sandeen (1):
      ext4: Fixed inode allocator to correctly track a flex_bg's used_dirs

Eric W. Biederman (1):
      netxen: The driver doesn't work on NX_P3_B1 so cause probe to fail.

FUJITA Tomonori (1):
      Documentation: rename PCI/PCI-DMA-mapping.txt to DMA-API-HOWTO.txt

Felix Fietkau (1):
      ath9k: fix BUG_ON triggered by PAE frames

Francois Romieu (1):
      r8169: fix broken register writes

Grazvydas Ignotas (1):
      wl1251: fix potential crash

Greg Rose (7):
      ixgbevf: Fix VF Stats accounting after reset
      ixgbevf: Shorten up delay timer for watchdog task
      ixgbevf: Message formatting cleanups
      ixgbevf: Fix signed/unsigned int error
      ixgbe: In SR-IOV mode insert delay before bring the adapter up
      ixgbe: Change where clear_to_send_flag is reset to zero.
      ixgbe: Do not run all Diagnostic offline tests when VFs are active

Greg Thelen (1):
      memcg: fix typo in memcg documentation

Guennadi Liakhovetski (3):
      ASoC: SIU driver shall select FW_LOADER
      SH: fix SCIFA SCASCR register bit definitions
      SH: remove superfluous warning from the serial driver

Guenter Roeck (1):
      ipv4: Don't drop redirected route cache entry unless PTMU actually expired

Guo-Fu Tseng (3):
      jme: Fix VLAN memory leak
      jme: Protect vlgrp structure by pause RX actions.
      jme: Advance driver version number

H Hartley Sweeten (2):
      [ARM] locomo: fix SPI register offset
      [ARM] locomo: fix unpaired spin_lock_irqsave

Hans-Joachim Picht (1):
      [S390] fix broken proc interface for sclp_async

Heiko Carstens (2):
      [S390] smp: fix lowcore allocation
      [S390] sclp: avoid 64 bit division

Henrik Kretzschmar (5):
      genirq: Move two IRQ functions from .init.text to .text
      isdn: Cleanup Sections in PCMCIA driver sedlbauer
      isdn: Cleanup Sections in PCMCIA driver teles
      isdn: Cleanup Sections in PCMCIA driver avma1
      isdn: Cleanup Sections in PCMCIA driver elsa

Herbert Xu (1):
      ipv6: Remove redundant dst NULL check in ip6_dst_check

Huang Weiyi (1):
      [ARM] pxa/raumfeld: remove duplicated #include

Ian Campbell (1):
      x86: Do not free zero sized per cpu areas

Jan Beulich (1):
      x86: Fix placement of FIX_OHCI1394_BASE

Jan Kara (2):
      ext4: Fix estimate of # of blocks needed to write indirect-mapped files
      ext4: Don't use delayed allocation by default when used instead of ext3

Jani Nikula (1):
      c2port: fix device_create() return value check

Jarkko Nikula (1):
      ALSA: pcm_lib - fix xrun functionality

Jaswinder Singh Rajput (1):
      hwmon: (asc7621) Add X58 entry in Kconfig

Jeff Dike (1):
      vhost: fix error path in vhost_net_set_backend

Jeff Layton (1):
      NFS: don't try to decode GETATTR if DELEGRETURN returned error

Jeff Mahoney (2):
      reiserfs: fix oops while creating privroot with selinux enabled
      reiserfs: properly honor read-only devices

Jens Rottmann (1):
      ksz884x: fix return value of netdev_set_eeprom

Jiri Kosina (1):
      x86: Remove excessive early_res debug output

Joe Perches (3):
      drivers/gpu/drm/i915/intel_bios.c: fix continuation line formats
      MAINTAINERS: use tab not spaces for delimiter
      drivers/net: Fix continuation lines

Joern Engel (12):
      Open segment file before using it
      Limit max_pages for insane devices
      Plug memory leak in writeseg_end_io
      Prevent schedule while atomic in __logfs_readdir
      Write out both superblocks on mismatch
      Fix logfs_get_sb_final error path
      Use deactivate_locked_super
      Prevent data corruption in logfs_rewrite_block()
      Simplify and fix pad_wbuf
      [LogFS] Clear PagePrivate when moving journal
      [LogFS] Move reserved segments with journal
      [LogFS] Erase new journal segments

John Fastabend (1):
      ixgbe: cleanup maximum number of tx queues

John Stultz (1):
      time: Fix accumulation bug triggered by long delay.

Jon Maloy (1):
      TIPC: Removed inactive maintainer

Jonathan Cameron (2):
      [ARM] pxa: fix for variables in uncompress.h being discarded
      [ARM] pxa: remove spi cs gpio direction to avoid clash with driver

JosephChan@via.com.tw (2):
      pata_via: Add VIA VX900 support
      pata_via: fix VT6410/6415/6330 detection issue

Jozsef Kadlecsik (1):
      netfilter: ip6table_raw: fix table priority

Julia Lawall (2):
      sound/oss/vidc.c: change the field used with DMA_ACTIVE
      arch/sparc/kernel: Use set_cpus_allowed_ptr

KOSAKI Motohiro (6):
      sched: sched_getaffinity(): Allow less than NR_CPUS length
      sched: Use proper type in sched_getaffinity()
      tmpfs: mpol=bind:0 don't cause mount error.
      tmpfs: handle MPOL_LOCAL mount option properly
      tmpfs: cleanup mpol_parse_str()
      doc: add the documentation for mpol=local

Ken Kawasaki (1):
      pcnet_cs: add new id

Komuro (1):
      pd6729: Coding Style fixes

Kunal Gangakhedkar (1):
      ALSA: hda - Add PCI quirk for HP dv6-1110ax.

Kuninori Morimoto (3):
      sh: mach-ecovec24: Add i2c_put_adapter on sh_eth_init
      sh: ms7724: Add tiny-document for sound
      sh: Add watch-dog register address for SH7722/SH7723/SH7724

Kyle McMartin (1):
      tulip: Fix null dereference in uli526x_rx_packet()

Lai Jiangshan (2):
      rcu: Fix tracepoints & lockdep false positive
      rcu: Fix local_irq_disable() CONFIG_PROVE_RCU=y false positives

Lee Schermerhorn (1):
      mempolicy: fix get_mempolicy() for relative and static nodes

Lennart Schulte (1):
      tcp: Fix tcp_mark_head_lost() with packets == 0

Li Zefan (1):
      cgroups: remove duplicate include

Linus Torvalds (3):
      Fix up prototype for sys_ipc breakage
      ext3: fix broken handling of EXT3_STATE_NEW
      Linux 2.6.34-rc3

Magnus Damm (1):
      serial: sh-sci: fix SH-Mobile SH breakage

Mallikarjuna R Chilakala (3):
      ixgbe: Fix 82599 multispeed fiber link issues due to Tx laser flapping
      ixgbe: Fix 82599 KX4 Wake on LAN issue after an improper system shutdown
      ixgbe: Set IXGBE_RSC_CB(skb)->DMA field to zero after unmapping the address

Marcel Holtmann (2):
      Bluetooth: Fix potential bad memory access with sysfs files
      Bluetooth: Convert debug files to actually use debugfs instead of sysfs

Mark Brown (2):
      ASoC: Bail out of wm_hubs DC servo if calibration fails
      ASoC: Remove BROKEN from i.MX audio after dependencies merged

Mark Fasheh (3):
      ocfs2: set i_mode on disk during acl operations
      ocfs2: Always try for maximum bits with new local alloc windows
      ocfs2: Clear undo bits when local alloc is freed

Martin Schwidefsky (1):
      [S390] fix boot failures with compressed kernels

Masami Hiramatsu (4):
      perf probe: Fix probe_point buffer overrun
      perf probe: Fix need_dwarf flag if lazy matching is used
      perf probe: Fix offset to allow signed value
      perf probe: Use original address instead of CU-based address

Mathieu Desnoyers (1):
      CRED: Fix memory leak in error handling

Matt Fleming (3):
      sh: Flush ITLB too in PTEAEX's flush_tlb_page()
      sh: Replace unsafe manipulation of MMUCR
      sh: Fix build after dynamic PMB rework

Matthew Wilcox (1):
      PCI quirk: Disable MSI on VIA K8T890 systems

Miao Xie (2):
      cpuset: fix the problem that cpuset_mem_spread_node() returns an offline node
      cpuset: alloc nodemask_t on the heap rather than the stack

Michael Chan (1):
      bnx2: Use proper handler during netpoll.

Michael Grzeschik (1):
      lxfb: set the H- and V-SYNC polarity of the flatpanel output

Michael Holzheu (1):
      [S390] zcore: CPU registers are not saved under LPAR

Michael S. Tsirkin (3):
      vhost: fix interrupt mitigation with raw sockets
      vhost: fix error handling in vring ioctls
      exit: fix oops in sync_mm_rss

Mike Frysinger (2):
      can: bfin_can: switch to common Blackfin can header
      blackfin: enable DEBUG_SECTION_MISMATCH

Mitch Williams (1):
      igb: count Rx FIFO errors correctly

Neil Horman (1):
      r8169: offical fix for CVE-2009-4537 (overlength frame DMAs)

Nick Bowler (1):
      Staging: et131x: Properly disable FC in txmac.

Nicolas Dichtel (1):
      net: ipmr/ip6mr: prevent out-of-bounds vif_table access

OGAWA Hirofumi (1):
      fs/partition/msdos: fix unusable extended partition for > 512B sector

Owain G. Ainsworth (1):
      drm/i915: remove an unnecessary wait_request()

Pablo Neira Ayuso (3):
      netlink: fix unaligned access in nla_get_be64()
      netlink: fix NETLINK_RECV_NO_ENOBUFS in netlink_set_err()
      netfilter: ctnetlink: fix reliable event delivery if message building fails

Patrick McHardy (3):
      net: ipmr/ip6mr: fix potential out-of-bounds vif_table access
      netfilter: xt_recent: fix regression in rules using a zero hit_count
      net: fix netlink address dumping in IPv4/IPv6

Paul E. McKenney (2):
      rcu: Make rcu_read_lock_bh_held() allow for disabled BH
      net: suppress lockdep-RCU false positive in FIB trie.

Paul Mackerras (1):
      powerpc/perf_events: Fix call-graph recording, add perf_arch_fetch_caller_regs

Paul Mundt (3):
      PCI: kill off pci_register_set_vga_state() symbol export.
      sh: Tidy up a couple of section mismatches.
      sh: Silence unintialized variable warnings in dwarf unwinder.

Paulius Zaleckas (1):
      if_tunnel.h: add missing ams/byteorder.h include

Pavel Emelyanov (2):
      ipv4: Cleanup struct net dereference in rt_intern_hash
      ipv4: Restart rt_intern_hash after emergency rebuild (v2)

Peter Ujfalusi (2):
      ASoC: tlv320dac33: Fix DSP modes
      ASoC: tlv320dac33: Internal clocking changes

Prarit Bhargava (1):
      hwmon: (coretemp) Fix cpu model output

Priit Laes (1):
      drm/i915: Rename FBC_C3_IDLE to FBC_CTL_C3_IDLE to match other registers

Rafael J. Wysocki (1):
      x86 / perf: Fix suspend to RAM on HP nx6325

Randy Dunlap (2):
      scripts/kernel-doc: handle struct member __aligned
      scripts/kernel-doc: fix fatal error on function prototype

Ravikiran G Thirumalai (1):
      tmpfs: fix oops on mounts with mpol=default

Richard Röjfors (1):
      drivers/gpio/max730x.c: add license macro

Rob Landley (1):
      sparc: Fix use of uid16_t and gid16_t in asm/stat.h

Robert Love (2):
      ixgbe: Don't allow user buffer count to exceed 256
      ixgbe: Priority tag FIP frames

Robin Holt (1):
      mm/ksm.c is doing an unneeded _notify in write_protect_page.

Russell King (3):
      ARM: Fix IXP23xx build error in mach/memory.h
      ARM: Update mach-types
      Documentation/volatile-considered-harmful.txt: correct cpu_relax() documentation

Ryusuke Konishi (3):
      nilfs2: fix duplicate call to nilfs_segctor_cancel_freev
      nilfs2: fix hang-up of cleaner after log writer returned with error
      nilfs2: fix imperfect completion wait in nilfs_wait_on_logs

Sachin Prabhu (1):
      Skip check for mandatory locks when unlocking

Sage Weil (26):
      ceph: implemented caps should always be superset of issued caps
      ceph: add missing locking to protect i_snap_realm_item during split
      ceph: fix inode removal from snap realm when racing with migration
      ceph: fix authenticator timeout
      ceph: fix authenticator buffer size calculation
      ceph: release old ticket_blob buffer
      ceph: clean up service ticket decoding
      ceph: fix null pointer deref of r_osd in debug output
      ceph: drop unnecessary WARN_ON in caps migration
      ceph: fix session locking in handle_caps, ceph_check_caps
      ceph: clean up handle_cap_grant, handle_caps wrt session mutex
      ceph: only release unused caps with mds requests
      ceph: fix mds sync() race with completing requests
      ceph: fix pg pool decoding from incremental osdmap update
      ceph: prevent dup stale messages to console for restarting mds
      ceph: fix connection fault con_work reentrancy problem
      ceph: rename r_sent_stamp r_stamp
      ceph: avoid reopening osd connections when address hasn't changed
      ceph: fix snap rebuild condition
      ceph: make write_begin wait propagate ERESTARTSYS
      ceph: propagate mds session allocation failures to caller
      ceph: fix session check on mds reply
      ceph: fix possible double-free of mds request reference
      ceph: avoid loaded term 'OSD' in documention
      ceph: fix use after free on mds __unregister_request
      ceph: update discussion list address in MAINTAINERS

Srinivas Eeda (1):
      ocfs2: Fix a race in o2dlm lockres mastery

Stanislaw Gruszka (1):
      posix-cpu-timers: Reset expire cache when no timer is running

Stefan Haberland (1):
      [S390] dasd: check tsb validity

Stefan Richter (2):
      firewire: core: fix Model_ID in modalias
      firewire: core: align driver match with modalias

Stefan Weinhuber (1):
      [S390] dasd: fix alignment of transport mode recovery TCW

Steve Glendinning (1):
      smsc95xx: Fix tx checksum offload for small packets

Steven J. Magnani (1):
      NET_DMA: free skbs periodically

Steven Rostedt (1):
      ring-buffer: Do 8 byte alignment for 64 bit that can not handle 4 byte align

Suresh Siddha (1):
      x86: Handle legacy PIC interrupts on all the cpu's

Takashi Iwai (3):
      ALSA: hda - Sort codec entry list of Nvidia HDMI
      ALSA: hda - Fix access-after-free in patch_realtek.c
      ALSA: hda - Don't set invalid connection index in Realtek initialiaiton

Tao Ma (4):
      ocfs2: Change bg_chain check for ocfs2_validate_gd_parent.
      ocfs2: Update i_blocks in reflink operations.
      ocfs2: Fix the update of name_offset when removing xattrs
      ocfs2: Init meta_ac properly in ocfs2_create_empty_xattr_block.

Tejun Heo (1):
      libata-sff: fix spurious IRQ handling

Tetsuo Handa (2):
      rxrpc: Check allocation failure.
      rxrpc: Check allocation failure.

Theodore Ts'o (1):
      ext4: Fix spelling of CONTIG_FS_EXT3 to CONFIG_FS_EXT3

Thomas Gleixner (3):
      genirq: Prevent oneshot irq thread race
      clockevents: Sanitize min_delta_ns adjustment and prevent overflows
      genirq: Protect access to irq_desc->action in can_request_irq()

Thomas Weber (1):
      OMAP: DSS2: VRAM: Fix early_param for vram

Tim Yamin (1):
      PCI quirk: only apply CX700 PCI bus parking quirk if external VT6212L is present

Timo Teräs (2):
      ipv4: check rt_genid in dst_check
      ip_gre: include route header_len in max_headroom calculation

Tomi Valkeinen (2):
      OMAP: DSS2: initialize dss clk sources properly
      OMAP: DSS2: panel-generic: re-implement mode changing

Tristan Ye (2):
      Ocfs2: Journaling i_flags and i_orphaned_slot when adding inode to orphan dir.
      Ocfs2: Handle deletion of reflinked oprhan inodes correctly.

Trond Myklebust (4):
      NFS: Prevent another deadlock in nfs_release_page()
      SUNRPC: Fix a potential memory leak in auth_gss
      SUNRPC: Fix a use after free bug with the NFSv4.1 backchannel
      SUNRPC: Fix the return value of rpc_run_bc_task()

Uwe Kleine-König (1):
      rtc/mc13783: fix use after free bug

Vasu Dev (3):
      ixgbe: fix for real_num_tx_queues update issue
      vlan: adds vlan_dev_select_queue
      vlan: updates vlan real_num_tx_queues

Wolfram Sang (2):
      regulator: fix dangling pointers
      get_maintainer: repair STDIN usage

YOSHIFUJI Hideaki / 吉藤英明 (1):
      ipv6: Don't drop cache route entry unless timer actually expired.

Yegor Yefremov (1):
      KS8695: update ksp->next_rx_desc_read at the end of rx loop

Yinghai Lu (2):
      x86: Make smp_locks end with page alignment
      x86: Make sure free_init_pages() frees pages on page boundary

Zhenyu Wang (1):
      drm/i915: Fix check with IS_GEN6

stephen hemminger (1):
      TCP: check min TTL on received ICMP packets

wzt wzt (1):
      benet: Fix compile warnnings in drivers/net/benet/be_ethtool.c

