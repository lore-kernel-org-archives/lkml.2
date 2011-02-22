Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1BVBpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 20:45:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943Ab1BVBpQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 20:45:16 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Feb 2011 17:44:53 -0800
Message-ID: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
Subject: Linux 2.6.38-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Another week, another -rc. This one has the fix for the rather
annoying (but also very rare) memory corruption that we were battling
for a couple of weeks - but since I suspect only two people ever saw
it, I doubt most of you care. It was a big relief for _me_ to have it
resolved, though, so I'll mention it anyway. There's another patch for
a related issue pending, it will go in soon.

Diff-wise, the most noticeable thing here is removal of the /proc
interface from the target code (so that we don't make a release with
deprecated interfaces). But ignoring that (and some arm mach/map.h
cleanup patches), the diffs really are pretty small.

But what is probably actually noticeable is a lot of small fixups,
mostly in drivers. Nothing really exciting, I'm afraid. Or not afraid,
since excitement at this stage in the -rc series is a bad thing.

I do want to remind developers to please take a look at Rafael's
latest regression list (I particularly care for the "since 2.6.37",
but I feel compelled to ask people to look at the 36->37 regression
list too.

And for the people who actually reported the regressions (or didn't,
but have found new ones) - please do update the status of the
regression. Some of them I'm really feel a lot more happy about if
they had a note that "yes, I tested with -rc6, and the problem is
still there". We've fixed a fair number of problems, so it's always
good to have regression reporters ping us with something like "hey,
I'm still here, and you may have fixed all those other things, but you
didn't fix my issue".

                                       Linus

---
Ahmed S. Darwish (2):
      Documentation: complete crashkernel= parameter documentation
      Documentation: explain [KMG] parameter suffix

Akinobu Mita (2):
      sparc: use bitmap_set()
      sparc: fix size argument to find_next_zero_bit()

Alex Deucher (1):
      drm/radeon/kms: add missing frac fb div flag for dce4+

Amir Hanania (1):
      ixgbe: work around for DDP last buffer size

Andrew Vasquez (1):
      [SCSI] qla2xxx: Return DID_NO_CONNECT when FC device is lost.

Andy Gospodarek (1):
      ixgbe: fix panic due to uninitialised pointer

Andy Whitcroft (1):
      ecryptfs: read on a directory should return EISDIR if not supported

Axel Lin (1):
      ARM: SAMSUNG: Drop exporting s3c24xx_ts_set_platdata

Bao Liang (1):
      Bluetooth: Set conn state to BT_DISCONN to avoid multiple responses

Ben Skeggs (4):
      drm/nouveau: fix non-EDIDful native mode selection
      drm/nv40: fix tiling-related setup for a number of chipsets
      drm/nouveau: flips/flipd need to always set 'evict' for
move_accel_cleanup()
      drm/nouveau: fix suspend/resume on GPUs that don't have PM support

Casey Leedom (4):
      cxgb4vf: Check driver parameters in the right place ...
      cxgb4vf: Behave properly when CONFIG_DEBUG_FS isn't defined ...
      cxgb4vf: Quiesce Virtual Interfaces on shutdown ...
      cxgb4vf: Use defined Mailbox Timeout

Catalin Marinas (1):
      ARM: 6676/1: Correct the cpu_architecture() function for ARMv7

Cho, Yu-Chen (1):
      Bluetooth: add Atheros BT AR9285 fw supported

Chuck Ebbert (1):
      block: revert block_dev read-only check

Clemens Ladisch (4):
      hwmon: (jc42) fix type mismatch
      hwmon: (jc42) more helpful documentation
      hwmon: (jc42) do not allow writing to locked registers
      hwmon: (k10temp) add support for AMD Family 12h/14h CPUs

Dan Carpenter (1):
      [SCSI] target: iblock/pscsi claim checking for NULL instead of IS_ERR

Daniel Hellstrom (1):
      sparc32: unaligned memory access (MNA) trap handler bug

Daniel Walker (1):
      MAINTAINERS: email address change

Darrick J. Wong (1):
      [SCSI] scsi_debug: Fix 32-bit overflow in do_device_access
causing memory corruption

David Henningsson (3):
      ALSA: HDA: Add position_fix quirk for an Asus device
      ALSA: HDA: Conexant auto: Handle multiple connections to ADC node
      ALSA: HDA: Do not announce false surround in Conexant auto

David S. Miller (4):
      hisax: Fix unchecked alloc_skb() return.
      iwlwifi: Delete iwl3945_good_plcp_health.
      isdn: hisax: Use l2headersize() instead of dup (and buggy) func.
      sparc64: Fix NMI startup bug which also breaks perf.

Dmitry Torokhov (1):
      module: explicitly align module_version_attribute structure

Eliad Peller (1):
      mac80211: add missing locking in ieee80211_reconfig

Eric Dumazet (2):
      net: provide default_advmss() methods to blackhole dst_ops
      net: deinit automatic LIST_HEAD

Francisco Jerez (3):
      drm/nv10: Fix crash when allocating a BO larger than half the
available VRAM.
      drm/nv04-nv40: Fix NULL dereference when we fail to find an LVDS
native mode.
      drm/nouveau: Fix detection of DDC-based LVDS on DCB15 boards.

Fubo Chen (1):
      [SCSI] target: fixed missing lock drop in error path

Giuseppe Cavallaro (1):
      stmmac: enable wol via magic frame by default.

Guenter Roeck (1):
      MAINTAINERS: Remove stale hwmon quilt tree

Heiko Carstens (2):
      [S390] atomic: use ACCESS_ONCE() for atomic_read()
      [S390] atomic: use inline asm

Herbert Xu (4):
      crypto: sha-s390 - Reset index after processing partial block
      bridge: Fix mglist corruption that leads to memory corruption
      bridge: Fix timer typo that may render snooping less effective
      bridge: Replace mp->mglist hlist with a bool

Hiroaki SHIMODA (1):
      xfrm: avoid possible oopse in xfrm_alloc_dst

Horst Hartmann (1):
      [S390] net: provide architecture specific NET_SKB_PAD

Ian Campbell (2):
      arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.
      xen: suspend and resume system devices when running PVHVM

Indan Zupancic (1):
      drm/i915: Do not handle backlight combination mode specially

Ivan Vecera (1):
      drivers/net: Call netif_carrier_off at the end of the probe

James Bottomley (1):
      [SCSI] qla2xxx: Fix race that could hang kthread_stop()

Jan Beulich (1):
      hwmon: (lm85) extend to support EMC6D103 chips

Jeff Layton (1):
      cifs: fix handling of scopeid in cifs_convert_address

Jesper Juhl (4):
      Don't potentially dereference NULL in net/dcb/dcbnl.c:dcbnl_getapp()
      USB Network driver infrastructure: Fix leak when
usb_autopm_get_interface() returns less than zero in kevent().
      Net, USB, Option, hso: Do not dereference NULL pointer
      ATM, Solos PCI ADSL2+: Don't deref NULL pointer if
net_ratelimit() and alloc_skb() interact badly.

Jesse Brandeburg (2):
      e1000e: check down flag in tasks
      e1000e: flush all writebacks before unload

John Fastabend (1):
      net: dcb: application priority is per net_device

John Stultz (2):
      RTC: Revert UIE emulation removal
      RTC: Re-enable UIE timer/polling emulation

Kashyap, Desai (3):
      [SCSI] mptfusion: mptctl_release is required in mptctl.c
      [SCSI] mptfusion: Fix Incorrect return value in mptscsih_dev_reset
      [SCSI] mptfusion: Bump version 03.04.18

Keng-Yu Lin (1):
      dell-laptop: Toggle the unsupported hardware killswitch

Kukjin Kim (5):
      ARM: S5PV310: Cleanup map.h file
      ARM: S5PV210: Cleanup map.h file
      ARM: S5PC100: Clenaup map.h file
      ARM: S5P6442: Cleanup map.h file
      ARM: S5P64X0: Cleanup map.h file

Kurt Van Dijck (1):
      net/can/softing: make CAN_SOFTING_CS depend on CAN_SOFTING

Linus Torvalds (5):
      vfs: fix BUG_ON() in fs/namei.c:1461
      Expand CONFIG_DEBUG_LIST to several other list operations
      net: dont leave active on stack LIST_HEAD
      Revert "tpm_tis: Use timeouts returned from TPM"
      Linux 2.6.38-rc6

Maciej Sosnowski (1):
      RDMA/nes: Don't generate async events for unregistered devices

Madhuranath Iyengar (1):
      [SCSI] qla2xxx: Change from irq to irqsave with host_lock

Marek Ol¹ák (1):
      drm/radeon/kms: do not reject X16 and Y16X16 floating-point
formats on r300

Marek Szyprowski (2):
      ARM: S5PV210: Update max8998_platform_data
      ARM: S5PV210: Fix regulator names

Martin Schwidefsky (1):
      [S390] correct ipl parameter block safe guard

Matt Carlson (1):
      tg3: Restrict phy ioctl access

Matthew Garrett (1):
      acer-wmi: Fix capitalisation of GUID

Michal Marek (1):
      fixdep: Do not record dependency on the source file itself

Mike Marciniszyn (2):
      IB/qib: Fix double add_timer()
      IB/qib: Prevent double completions after a timeout or RNR error

NeilBrown (1):
      nfsd: correctly handle return value from nfsd_map_name_to_*

Nicholas Bellinger (6):
      [SCSI] target/iblock: Fix failed bd claim NULL pointer dereference
      [SCSI] target: Fix demo-mode MappedLUN shutdown UA/PR breakage
      [SCSI] target: Fix top-level configfs_subsystem default_group
shutdown breakage
      [SCSI] target: Fix SCF_SCSI_CONTROL_SG_IO_CDB breakage
      [SCSI] target: Remove procfs based target_core_mib.c code
      [SCSI] target: fix use after free detected by SLUB poison

Nicolas Pitre (2):
      ARM: 6739/1: update .gitignore for boot/compressed
      ARM: 6745/1: kprobes insn decoding fix

Patrick McHardy (1):
      netfilter: nf_iterate: fix incorrect RCU usage

Pawel Moll (1):
      ARM: 6740/1: Place correctly notes section in the linker script

Randy Dunlap (4):
      net: fix ifenslave build flags
      platform/x86: ideapad-laptop depends on INPUT
      Documentation: log_buf_len uses [KMG] suffix
      Docbook: add fs/eventfd.c and fix typos in it

Raymond Yau (1):
      ALSA: au88x0 - Modify pointer callback to give accurate playback position

Russell King (4):
      ARM: Ensure predictable endian state on signal handler entry
      ARM: Keep exit text/data around for SMP_ON_UP
      ARM: tlb: delay page freeing for SMP and ARMv7 CPUs
      ARM: tlb: move noMMU tlb_flush() to asm/tlb.h

Sage Weil (3):
      libceph: fix socket read error handling
      libceph: fix socket write error handling
      ceph: queue cap_snaps once per realm

Sebastian Andrzej Siewior (1):
      spi/pxa2xx pci: fix the release - remove race

Seth Forshee (1):
      thinkpad_acpi: Always report scancodes for hotkeys

Shiraz Hashim (1):
      ARM: 6722/1: SPEAr: sp810: switch to slow mode before reset

Shirish Pargaonkar (1):
      cifs: Fix regression in LANMAN (LM) auth code

Srinidhi Kasagar (1):
      ARM: 6741/1: errata: pl310 cache sync operation may be faulty

Stanislaw Gruszka (2):
      iwl3945: remove plcp check
      PM / Hibernate: Return error code when alloc_image_page() fails

Stefan Haberland (1):
      [S390] dasd: correct device table

Steffen Klassert (1):
      ip_gre: Add IPPROTO_GRE to flowi in ipgre_tunnel_xmit

Steve French (1):
      [CIFS] update cifs version

Takashi Iwai (1):
      ALSA: caiaq - Fix possible string-buffer overflow

Tejun Heo (3):
      workqueue: wake up a worker when a rescuer is leaving a gcwq
      workqueue, freezer: unify spelling of 'freeze' + 'able' to 'freezable'
      workqueue: make sure MAYDAY_INITIAL_TIMEOUT is at least 2 jiffies long

Thomas Abraham (1):
      ARM: S5P: Fix end address in memory resource information for UART devices

Thomas Gleixner (4):
      platform-drivers: x86: pmic: Fix up bogus irq hackery
      platform-drivers: x86: Convert pmic to new irq_chip functions
      platform-drivers: x86: pmic: Use irq_chip buslock mechanism
      platform-drivers: x86: pmic: Use request_irq instead of chained handler

Timo Warns (1):
      fs/partitions: Validate map_count in Mac partition tables

Toshiharu Okada (2):
      pch_gbe: Fix the issue that the receiving data is not normal.
      pch_gbe: Fix the MAC Address load issue.

Tyler Hicks (3):
      eCryptfs: Revert "dont call lookup_one_len to avoid NULL nameidata"
      eCryptfs: Handle NULL nameidata pointers
      eCryptfs: Copy up lower inode attrs in getattr

Uwe Kleine-König (1):
      RTC: Release mutex in error path of rtc_alarm_irq_enable

Vasiliy Kulikov (3):
      platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
      platform: x86: asus_acpi: world-writable procfs files
      platform: x86: acer-wmi: world-writable sysfs threeg file

Will Deacon (2):
      ARM: 6742/1: pmu: avoid setting IRQ affinity on UP systems
      ARM: 6743/1: errata: interrupted ICALLUIS may prevent completion
of broadcasted operation

Yehuda Sadeh (1):
      ceph: keep reference to parent inode on ceph_dentry

viresh kumar (3):
      ARM: 6720/1: SPEAr: Append UL to VMALLOC_END
      ARM: 6712/1: SPEAr: replace readl(), writel() with relaxed
versions in uncompress.h
      ARM: 6700/1: SPEAr: Correct SOC config base address for spear320
