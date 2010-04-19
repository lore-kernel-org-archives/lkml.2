Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0DSXoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 19:44:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740Ab0DSXoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 19:44:14 -0400
Date: Mon, 19 Apr 2010 16:42:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.34-rc5
Message-ID: <alpine.LFD.2.00.1004191633050.9086@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another -rc. This time there wasn't some big nasty 
regression I was working on to hold things up, and it felt like a pretty 
regular -rc release.

Random fixes all around. The most noticeable (for people who got hit by 
it) may be the fix for bootup problems that some people had (ACPI dividing 
by zero: kernel bugzilla 15749), but there's stuff all over. The shortlog 
gives some idea.

>From a pure diff size perspective, some of the variable renaming stuff in 
the i915 driver is probably the bulk of the diff, but ignoring those 
(which look big but are basically sed-scripted automated renames to make 
things easier in the future), most of it's really pretty small and random. 

Radeon updates, amd-iommu fixes, sparc now knows ftrace etc etc. On the 
filesystems side, fixes to xfs, ecryptfs, cephfs and nfs..

Give it a test. And if you still have a regression open, ping the 
developers..

		Linus

---
Alex Deucher (6):
      drm/radeon/kms: more atom parser fixes (v2)
      drm/radeon/kms/atom: fix dual-link DVI on DCE3.2/4.0
      drm/radeon/kms/evergreen: don't enable hdmi audio stuff
      drm/radeon/kms: fix tv dac conflict resolver
      drm/radeon/kms: adjust pll settings for tv
      drm/radeon/kms: disable the tv encoder when tv/cv is not in use

Alexey Starikovskiy (1):
      ACPI: EC: Limit burst to 64 bits

Amit Kumar Salecha (1):
      qlcnic: fix set mac addr

Anders Larsen (1):
      ARM: 5975/1: AT91 slow-clock suspend: don't wait when turning PLLs off

Ayaz Abdulla (1):
      forcedeth: fix tx limit2 flag check

Brice Goglin (1):
      myri10ge: fix rx_pause in myri10ge_set_pauseparam

Chase Douglas (1):
      Input: ALPS - add signature for HP Pavilion dm3 laptops

Chris Wright (5):
      x86/amd-iommu: Pt mode fix for domain_destroy
      x86/amd-iommu: enable iommu before attaching devices
      x86/amd-iommu: warn when issuing command to uninitialized cmd buffer
      Revert "x86: disable IOMMUs on kernel crash"
      x86/amd-iommu: use for_each_pci_dev

Christian Pulvermacher (1):
      ecryptfs: fix error code for missing xattrs in lower fs

Clemens Ladisch (3):
      firewire: cdev: disallow receive packets without header
      firewire: cdev: require quadlet-aligned headers for transmit packets
      firewire: cdev: iso packet documentation

Corbin Simpson (1):
      drivers/gpu/radeon: Add MSPOS regs to safe list.

Dan Carpenter (2):
      dma-debug: Cleanup for copy-loop in filter_write()
      stmmac: use resource_size()

Daniel Lezcano (1):
      packet : remove init_net restriction

Daniel Vetter (2):
      drm/i915: introduce to_intel_bo helper
      agp/intel: intel_845_driver is an agp driver!

Dave Airlie (2):
      drm/radeon/kms: only change mode when coherent value changes.
      drm/radeon/kms: add FireMV 2400 PCI ID.

Dave Chinner (2):
      xfs: ensure that sync updates the log tail correctly
      xfs: don't warn on EAGAIN in inode reclaim

David Howells (1):
      rcu: Better explain the condition parameter of rcu_dereference_check()

David S. Miller (15):
      tcp: Set CHECKSUM_UNNECESSARY in tcp_init_nondata_skb
      Revert "tcp: Set CHECKSUM_UNNECESSARY in tcp_init_nondata_skb"
      sparc64: Use kstack_valid() in die_if_kernel().
      sparc64: Adjust __raw_local_irq_save() to cooperate in NMIs.
      sparc64: Add HAVE_FUNCTION_TRACE_MCOUNT_TEST and tidy up.
      sparc64: Kill CONFIG_STACK_DEBUG code.
      sparc64: Kill unnecessary static on local var in ftrace_call_replace().
      sparc64: Remove profiling from some low-level bits.
      sparc64: Use a seperate counter for timer interrupts and NMI checks, like x86.
      sparc64: Give a stack frame to the ftrace call sites.
      sparc64: Add function graph tracer support.
      sparc64: Support kmemleak.
      sparc64: Add kmemleak annotation to sun4v_build_virq()
      sparc64: Fix memory leak in pci_register_iommu_region().
      sparc64: Add some more commentary to __raw_local_irq_save()

Dmitry Torokhov (2):
      Input: sparse-keymap - implement safer freeing of the keymap
      Revert "Input: wacom - merge out and in prox events"

Dominik Brodowski (1):
      Input: i8042 - spelling fix

Eric Anholt (2):
      drm/i915: Rename intel_output to intel_encoder.
      drm/i915: Rename many remaining uses of "output" to encoder or connector.

Eric Dumazet (4):
      can: avoids a false warning
      fib: suppress lockdep-RCU false positive in FIB trie.
      net: dev_pick_tx() fix
      ip: Fix ip_dev_loopback_xmit()

Ernst Schwab (1):
      ARM: 5974/1: arm/mach-at91 Makefile: remove two blanks.

Felix Fietkau (1):
      ath9k: fix double calls to ath_radio_enable

Florian Fainelli (1):
      r6040: fix r6040_multicast_list

Geert Uytterhoeven (2):
      m68k: Fix asm constraints for atomic_sub_and_test() and atomic_add_negative()
      [WATCHDOG] max63xx driver depends on ioremap()

H Hartley Sweeten (1):
      Input: matrix_keypad - allow platform to disable key autorepeat

Henrik Rydberg (4):
      Input: bcm5974 - retract efi-broken suspend_resume
      Input: clarify the no-finger event in multitouch protocol
      Input: update the status of the Multitouch X driver project
      hwmon: (applesmc) Switch maintainers

Herbert Xu (1):
      bridge: Fix IGMP3 report parsing

Huang Weiyi (1):
      ASoC: wm2000: remove unused #include <linux/version.h>

Imre Deak (2):
      ARM: 6050/1: VFP: fix the SMP versions of vfp_{sync,flush}_hwstate
      ARM: 6051/1: VFP: preserve the HW context when calling signal handlers

Javier Cardona (1):
      mac80211: Handle mesh action frames in ieee80211_rx_h_action

Jean Delvare (4):
      hwmon: (sht15) Properly handle the case CONFIG_REGULATOR=n
      hwmon: (it87) Don't arbitrarily enable temperature channels
      hwmon: (it87) Properly handle wrong sensor type requests
      hwmon: (it87) Invalidate cache on temperature sensor change

Jeff Dike (1):
      vhost-net: fix vq_memory_access_ok error checking

Jeff Mahoney (1):
      ecryptfs: fix use with tmpfs by removing d_drop from ecryptfs_destroy_inode

Jerome Glisse (2):
      drm/radeon/kms: print GPU family and device id when loading
      drm/radeon/kms: fix rs600 tlb flush

Jerome Oufella (1):
      hwmon: (sht15) Fix sht15_calc_temp interpolation function

Jiri Slaby (1):
      PM / Hibernate: user.c, fix SNAPSHOT_SET_SWAP_AREA handling

Joe Perches (1):
      vsprintf: Change struct printf_spec.precision from s8 to s16

Joerg Roedel (5):
      x86/amd-iommu: Protect IOMMU-API map/unmap path
      x86/amd-iommu: Report errors in acpi parsing functions upstream
      x86/amd-iommu: Use helper function to destroy domain
      x86/amd-iommu: Remove obsolete parameter documentation
      x86/gart: Disable GART explicitly before initialization

Joerg Schirottke (1):
      ALSA: hda - add a quirk for Clevo M570U laptop

Johannes Berg (2):
      mac80211: annotate station rcu dereferences
      iwlwifi: work around bogus active chains detection

John Hughes (2):
      x25: Patch to fix bug 15678 - x25 accesses fields beyond end of packet.
      x.25 attempts to negotiate invalid throughput

Jorge Boncompte [DTI2] (1):
      udp: fix for unicast RX path optimization

Julia Lawall (1):
      x86/amd-iommu: Remove double NULL check in check_device

Justin P. Mattock (1):
      hwmon: (applesmc) Add iMac9,1 and MacBookPro2,2 support

Kailang Yang (2):
      ALSA: hda - Fix auto-parser of ALC269vb for HP pin NID 0x21
      ALSA: hda - Fix setup for ALC269vb amic and dmic models

Ken Kawasaki (1):
      smc91c92_cs: define multicast_table as unsigned char

Krzysztof Halasa (1):
      WAN: flush tx_queue in hdlc_ppp to prevent panic on rmmod hw_driver.

Linus Torvalds (2):
      Fix ISDN/Gigaset build failure
      Linux 2.6.34-rc5

Luuk Paulussen (1):
      [WATCHDOG] fixed book E watchdog period register mask.

Marc Zyngier (1):
      [WATCHDOG] max63xx: be careful when disabling the watchdog

Marek Ol¨ák (2):
      drm/radeon/kms: fix calculation of mipmapped 3D texture sizes
      drm/radeon/kms: allow R500 regs VAP_ALT_NUM_VERTICES and VAP_INDEX_OFFSET

Maurus Cuelenaere (1):
      ALSA: hda: Add support for Medion WIM2160

Maxim Kuvyrkov (1):
      m68k: Fix `struct sigcontext' for ColdFire

Michael Chan (1):
      cnic: Fix crash during bnx2x MTU change.

Michael S. Tsirkin (1):
      tun: orphan an skb on tx

Mika Westerberg (1):
      ARM: 6052/1: kdump: make kexec work in interrupt context

Nicolas Pitre (1):
      ARM: 6007/1: fix highmem with VIPT cache and DMA

Patrick Loschmidt (1):
      net: corrected documentation for hardware time stamping

Paul E. McKenney (3):
      rcu: Add rcu_access_pointer and rcu_dereference_protected
      rcu: Update docs for rcu_access_pointer and rcu_dereference_protected
      rcu: Make RCU lockdep check the lockdep_recursion variable

Philby John (1):
      ALSA: aaci - Fix alignment faults on ARM Cortex introduced by commit 29a4f2d3

Ping Cheng (1):
      Input: wacom - switch mode upon system resume

Rik van Riel (1):
      rmap: add exclusively owned pages to the newest anon_vma

Robert Hooker (1):
      drm/i915: Disable FBC on 915GM and 945GM.

Rusty Russell (2):
      lguest: workaround cmpxchg8b_emu by ignoring cli in the guest.
      lguest: stop using KVM hypercall mechanism

Sage Weil (9):
      ceph: fix dentry rehashing on virtual .snap dir
      ceph: allow writeback of snapped pages older than 'oldest' snapc
      ceph: fix snap context reference leaks
      ceph: fix leaked inode ref due to snap metadata writeback race
      ceph: fix ack counter reset on connection reset
      ceph: decode v5 of osdmap (pool names) [protocol change]
      ceph: fix dentry reference leak in dcache readdir
      ceph: queue_cap_snap should always queue dirty context
      ceph: use separate class for ceph sockets' sk_lock

Santosh Shilimkar (1):
      [WATCHDOG] omap4: Fix WDT Kconfig

Sascha Hauer (5):
      ASoC: imx-ssi: honor IMX_SSI_DMA flag
      ASoC: imx-pcm-dma-mx2: restart DMA after an error
      ASoC: imx-ssi: Use a hrtimer in FIQ mode
      ASoC: imx-ssi: increase minimum periods to 4
      ASoC: imx-ssi: do not call hrtimer_disable in trigger function

Shanyu Zhao (1):
      iwlwifi: use consistent table for tx data collect

Shirley Ma (1):
      virtio_net: missing sg_init_table

Stefan Assmann (1):
      igb: restrict WoL for 82576 ET2 Quad Port Server Adapter

Stefan Bader (1):
      drm/i915: Add no_lvds entry for the Clientron U800

Stefan Richter (3):
      firewire: cdev: fix information leak
      firewire: cdev: comment fixlet
      firewire: cdev: change license of exported header files to MIT license

Stephen Smalley (1):
      SELinux: Reduce max avtab size to avoid page allocation failures

Takashi Iwai (7):
      ALSA: hda - Fix initial capture source connections of ALC880/260
      ALSA: usb - Fix Oops after usb-midi disconnection
      ALSA: hda - Enhance fix-up table for Realtek codecs
      ALSA: hda - Add fix-up for Sony VAIO with ALC269
      ALSA: hda - Fix control element allocations in VIA codec parser
      ALSA: hda - Avoid invalid "Independent HP" control for VIA codecs
      ALSA: hda - Add position_fix quirk for Biostar mobo

Terry Loftin (1):
      e1000e: stop cleaning when we reach tx_ring->next_to_use

Tilman Schmidt (1):
      gigaset: include cleanup cleanup

Trond Myklebust (6):
      NFSv4: Fall back to ordinary lookup if nfs4_atomic_open() returns EISDIR
      NFS: Fix the mode calculation in nfs_find_open_context
      NFS: Ensure that writeback_single_inode() calls write_inode() when syncing
      NFS: Fix a race with the new commit code
      NFS: Ensure that the WRITE and COMMIT RPC calls are always uninterruptible
      NFSv4: fix delegated locking

Tyler Hicks (7):
      eCryptfs: Fix metadata in xattr feature regression
      eCryptfs: Rename ecryptfs_crypt_stat.num_header_bytes_at_front
      eCryptfs: Clear buffer before reading in metadata xattr
      eCryptfs: Strip metadata in xattr flag in encrypted view
      eCryptfs: Decrypt symlink target for stat size
      eCryptfs: Copy lower directory inode times and size on link
      eCryptfs: Turn lower lookup error messages into debug messages

Wey-Yi Guy (1):
      iwlwifi: need check for valid qos packet before free

Yehuda Sadeh (1):
      ceph: reserve one more caps space when doing readdir

Yong Wang (1):
      Input: sparse-keymap - free the right keymap on error

Zhao Yakui (1):
      drm/i915: Ignore LVDS EDID when it is unavailabe or invalid

Zhu Yi (2):
      iwlwifi: fix DMA allocation warnings
      iwlwifi: avoid Tx queue memory allocation in interface down
