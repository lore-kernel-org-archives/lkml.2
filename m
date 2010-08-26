Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0H0ACM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:02:12 -0400
Received: from kroah.org ([198.145.64.141]:54771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab0H0AAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:00:46 -0400
Date: Thu, 26 Aug 2010 16:58:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.35.4
Message-ID: <20100826235848.GE13527@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826235552.GA13527@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.35.4 kernel.

All users of the 2.6.35 kernel series must upgrade.

The updated 2.6.35.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 
 arch/arm/include/asm/ptrace.h                 |   17 +
 arch/arm/mach-ixp4xx/ixdp425-setup.c          |    1 
 arch/arm/mach-mx3/mach-qong.c                 |    1 
 arch/arm/mach-orion5x/ts78xx-setup.c          |    1 
 arch/blackfin/mach-bf537/boards/stamp.c       |    1 
 arch/blackfin/mach-bf561/boards/acvilon.c     |    1 
 arch/powerpc/Makefile                         |    2 
 arch/sparc/include/asm/atomic_64.h            |   10 -
 arch/sparc/include/asm/fb.h                   |    4 
 arch/sparc/include/asm/parport.h              |    4 
 arch/sparc/include/asm/rwsem-const.h          |    2 
 arch/x86/Kconfig                              |    5 
 arch/x86/include/asm/cmpxchg_32.h             |   67 ++-----
 arch/x86/include/asm/cmpxchg_64.h             |    4 
 arch/x86/kernel/apic/apic.c                   |    2 
 arch/x86/kernel/apic/io_apic.c                |    2 
 arch/x86/kernel/cpu/perf_event_intel.c        |   81 ++++++--
 arch/x86/kernel/cpu/perf_event_p4.c           |    9 
 arch/x86/kernel/mpparse.c                     |   16 +
 arch/x86/kernel/smpboot.c                     |   19 ++
 arch/x86/lib/atomic64_386_32.S                |  236 ++++++++++++++------------
 arch/x86/oprofile/nmi_int.c                   |   17 +
 drivers/acpi/apei/erst.c                      |    1 
 drivers/char/agp/intel-gtt.c                  |   11 +
 drivers/char/mem.c                            |    2 
 drivers/char/tty_io.c                         |    4 
 drivers/gpu/drm/drm_drv.c                     |    4 
 drivers/gpu/drm/i915/i915_dma.c               |    8 
 drivers/gpu/drm/i915/intel_display.c          |   23 +-
 drivers/gpu/drm/radeon/radeon_atombios.c      |   16 +
 drivers/gpu/drm/radeon/radeon_device.c        |    2 
 drivers/gpu/drm/radeon/radeon_i2c.c           |    7 
 drivers/gpu/drm/radeon/radeon_irq_kms.c       |    5 
 drivers/gpu/drm/radeon/radeon_kms.c           |    4 
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |    2 
 drivers/gpu/drm/radeon/radeon_pm.c            |    5 
 drivers/hwmon/pc87360.c                       |   31 +--
 drivers/isdn/gigaset/capi.c                   |   17 -
 drivers/isdn/sc/ioctl.c                       |   10 -
 drivers/md/dm-exception-store.c               |    4 
 drivers/md/dm-exception-store.h               |    3 
 drivers/md/dm-ioctl.c                         |   50 +++--
 drivers/md/dm-snap.c                          |   44 +++-
 drivers/md/dm.c                               |   63 +++++-
 drivers/md/dm.h                               |    5 
 drivers/memstick/core/mspro_block.c           |    6 
 drivers/mtd/chips/cfi_cmdset_0001.c           |   20 +-
 drivers/mtd/lpddr/lpddr_cmds.c                |   20 +-
 drivers/mtd/nand/nand_base.c                  |    1 
 drivers/mtd/nand/plat_nand.c                  |    5 
 drivers/mtd/nand/pxa3xx_nand.c                |    2 
 drivers/net/e1000e/82571.c                    |   31 +--
 drivers/net/e1000e/defines.h                  |    4 
 drivers/net/e1000e/lib.c                      |   10 +
 drivers/net/wireless/ath/ath5k/base.c         |   21 ++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   15 +
 drivers/net/wireless/iwlwifi/iwl-3945.c       |   16 -
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c   |   17 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |   17 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   20 --
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   83 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c       |   70 ++-----
 drivers/net/wireless/iwlwifi/iwl-core.h       |   13 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |   56 +++++-
 drivers/net/wireless/wl12xx/wl1251_cmd.c      |    2 
 drivers/platform/x86/compal-laptop.c          |    9 
 drivers/platform/x86/dell-laptop.c            |    7 
 drivers/regulator/wm8994-regulator.c          |    5 
 drivers/serial/suncore.c                      |   15 -
 drivers/staging/batman-adv/hard-interface.c   |   21 +-
 drivers/staging/batman-adv/originator.c       |   14 -
 drivers/usb/host/xhci-ring.c                  |    2 
 drivers/usb/serial/cp210x.c                   |    4 
 drivers/usb/serial/ftdi_sio.c                 |    5 
 drivers/usb/serial/ftdi_sio_ids.h             |    9 
 drivers/usb/serial/io_ti.c                    |    2 
 drivers/usb/serial/navman.c                   |    1 
 drivers/usb/serial/option.c                   |    7 
 drivers/usb/serial/pl2303.c                   |    1 
 drivers/usb/serial/pl2303.h                   |    4 
 drivers/video/matrox/matroxfb_base.h          |    4 
 firmware/Makefile                             |    2 
 fs/char_dev.c                                 |    1 
 fs/nfs/dir.c                                  |    2 
 fs/nfs/nfs4proc.c                             |    8 
 fs/nfs/super.c                                |    7 
 fs/nilfs2/super.c                             |    4 
 fs/ocfs2/acl.c                                |   33 +++
 fs/ocfs2/dlm/dlmmaster.c                      |    9 
 fs/ocfs2/dlm/dlmrecovery.c                    |   22 +-
 fs/ocfs2/dlm/dlmthread.c                      |  114 ++++++------
 fs/ocfs2/refcounttree.c                       |   20 +-
 include/acpi/platform/aclinux.h               |   10 -
 include/linux/mm_types.h                      |    2 
 include/linux/mtd/flashchip.h                 |    2 
 include/linux/skbuff.h                        |    4 
 include/linux/tty.h                           |    3 
 include/sound/emu10k1.h                       |    1 
 include/trace/events/timer.h                  |    8 
 kernel/fork.c                                 |    7 
 kernel/sched.c                                |   10 -
 kernel/time/timekeeping.c                     |   14 -
 kernel/trace/ring_buffer.c                    |    3 
 kernel/trace/trace_functions_graph.c          |   10 -
 mm/memory.c                                   |   15 +
 mm/mlock.c                                    |   21 +-
 mm/mmap.c                                     |   21 +-
 mm/nommu.c                                    |    7 
 mm/slab.c                                     |    4 
 net/bridge/br_device.c                        |    8 
 net/bridge/br_fdb.c                           |    2 
 net/bridge/br_input.c                         |    6 
 net/bridge/br_stp_bpdu.c                      |    2 
 net/can/bcm.c                                 |   41 ++--
 net/can/raw.c                                 |    4 
 net/core/dev.c                                |    9 
 net/ipv4/tcp.c                                |    7 
 net/netlink/af_netlink.c                      |   46 +----
 net/sched/act_nat.c                           |    3 
 net/sched/sch_sfq.c                           |   13 +
 net/wireless/mlme.c                           |    8 
 scripts/mkmakefile                            |    4 
 sound/core/pcm_native.c                       |    4 
 sound/pci/emu10k1/emu10k1.c                   |    4 
 sound/pci/emu10k1/emupcm.c                    |   30 ++-
 sound/pci/emu10k1/memory.c                    |    4 
 sound/pci/hda/patch_conexant.c                |    1 
 sound/pci/hda/patch_realtek.c                 |    1 
 sound/pci/intel8x0.c                          |    6 
 sound/pci/riptide/riptide.c                   |   11 -
 sound/soc/codecs/wm8580.c                     |    6 
 sound/soc/codecs/wm8776.c                     |    7 
 sound/soc/soc-cache.c                         |    4 
 134 files changed, 1259 insertions(+), 700 deletions(-)

Alex Deucher (6):
      drm/radeon/kms: add additional quirk for Acer rv620 laptop
      drm/radeon/kms: don't enable MSIs on AGP boards
      drm/radeon/kms/pm: bail early if nothing's changing
      drm/radeon/kms: fix typo in radeon_compute_pll_gain
      drm/radeon/kms/DCE3+: switch pads to ddc mode when going i2c
      drm/radeon/kms: fix sideport detection on newer rs880 boards

Anatolij Gustschin (1):
      powerpc: Fix typo in uImage target

Arjan van de Ven (1):
      tracing: Fix timer tracing

Axel Lin (1):
      pxa3xx: fix ns2cycle equation

Borislav Petkov (1):
      x86, hotplug: Serialize CPU hotplug to avoid bringup concurrency issues

Bruce Allan (2):
      e1000e: disable ASPM L1 on 82573
      e1000e: don't check for alternate MAC addr on parts that don't support it

Carsten Otte (1):
      slab: fix object alignment

Changli Gao (3):
      act_nat: the checksum of ICMP doesn't have pseudo header
      net: disable preemption before call smp_processor_id()
      act_nat: fix wild pointer

Chris Wilson (1):
      drm/i915/edp: Flush the write before waiting for PLLs

Cliff Cai (1):
      ASoC: register cache should be 1 byte aligned for 1 byte long register

Craig Shelley (1):
      USB: CP210x Fix Break On/Off

Cyrill Gorcunov (1):
      perf, x86: P4 PMU -- update nmi irq statistics and unmask lvt entry properly

Dan Carpenter (2):
      isdn: fix information leak
      isdn: gigaset: add missing unlock

Daniel Kiper (1):
      x86, apic: Fix apic=debug boot crash

Daniel T Chen (1):
      ALSA: intel8x0: Mute External Amplifier by default for ThinkPad X31

Daniel Vetter (2):
      drm/i915: fixup pageflip ringbuffer commands for i8xx
      drm/i915: i8xx also doesn't like multiple oustanding pageflips

Dave Airlie (1):
      drm: stop information leak of old kernel stack.

David Howells (1):
      Fix init ordering of /dev/console vs callers of modprobe

David S. Miller (4):
      sparc64: Add missing ID to parport probing code.
      sparc64: Fix rwsem constant bug leading to hangs.
      sparc64: Fix atomic64_t routine return values.
      sparc: Really fix "console=" for serial consoles.

Dmitry Popov (1):
      tcp: cookie transactions setsockopt memory leak

Dr. David Alan Gilbert (1):
      drm/radeon/kms: add missing copy from user

Eric W. Biederman (1):
      x86, apic: Map the local apic when parsing the MP table.

Galen Seitz (1):
      USB: ftdi_sio: add product ID for Lenz LI-USB

Greg Kroah-Hartman (2):
      USB: io_ti: check firmware version before updating
      Linux 2.6.35.4

H. Peter Anvin (1):
      x86, asm: Clean up and simplify set_64bit()

Herbert Xu (1):
      bridge: Fix skb leak when multicast parsing fails on TX

Huang Ying (1):
      tracing: Fix ring_buffer_read_page reading out of page boundary

Jan Beulich (1):
      fixes for using make 3.82

Jarek Poplawski (4):
      net: Fix napi_gro_frags vs netpoll path
      net: Fix a memmove bug in dev_gro_receive()
      pkt_sched: Fix sch_sfq vs tcf_bind_filter oops
      pkt_sched: Fix sch_sfq vs tc_modify_qdisc oops

Jaroslav Kysela (1):
      ALSA: emu10k1 - delay the PCM interrupts (add pcm_irq_delay parameter)

Jason Wessel (1):
      timekeeping: Fix overflow in rawtime tv_nsec on 32 bit archs

Jean Delvare (1):
      hwmon: (pc87360) Fix device resource declaration

Jef Driesen (1):
      USB: pl2303: New vendor and product id

Jerome Glisse (1):
      drm/radeon/kms: fix GTT/VRAM overlapping test

Jesse Barnes (1):
      drm/agp/i915: trim stolen space to 32M

Jiaju Zhang (1):
      Fix the nested PR lock calling issue in ACL

Johannes Berg (4):
      cfg80211: fix locking in action frame TX
      iwlagn: fix rts cts protection
      iwlwifi: fix 3945 filter flags
      netlink: fix compat recvmsg

John Stultz (1):
      time: Workaround gcc loop optimization that causes 64bit div errors

John Villalovos (1):
      Oprofile: Change CPUIDS from decimal to hex, and add some comments

John Youn (1):
      USB: xhci: Remove buggy assignment in next_trb()

Jonathan Woithe (1):
      ALSA: hda - Fix missing stream for second ADC on Realtek ALC260 HDA codec

Joonyoung Shim (1):
      regulator: Default GPIO controlled WM8994 regulators to disabled

Josh Hunt (1):
      oprofile: add support for Intel processor model 30

Kiyoshi Ueda (3):
      dm: prevent access to md being deleted
      dm ioctl: release _hash_lock between devices in remove_all
      dm: separate device deletion from dm_put

Linus Torvalds (3):
      mm: make the vma list be doubly linked
      mm: make the mlock() stack guard page checks stricter
      mm: make stack guard page logic use vm_prev pointer

Luca Barbieri (1):
      x86, asm: Refactor atomic64_386_32.S to support old binutils and be cleaner

Marek Lindner (1):
      Staging: batman-adv: unify orig_hash_lock spinlock handling to avoid deadlocks

Marek Vasut (3):
      ARM: Fix gen_nand probe structures contents
      BFIN: Fix gen_nand probe structures contents
      gen_nand: Test if nr_chips field is valid

Mark Brown (2):
      ASoC: Fix inverted mute controls for WM8580
      ASoC: Remove DSP mode support for WM8776

Martin Michlmayr (1):
      USB: ftdi_sio: Add ID for Ionics PlugComputer

Maxim Levitsky (3):
      memstick: init sysfs attributes
      memstick: fix hangs on unexpected device removal in mspro_blk
      ath5k: disable ASPM L0s for all cards

Michael Tokarev (1):
      USB: option: add Celot CT-650

Michael Wileczka (1):
      USB: ftdi_sio: fix endianess of max packet size

Mikulas Patocka (2):
      dm snapshot: iterate origin and cow devices
      dm snapshot: test chunk size against both origin and snapshot

Oliver Hartkopp (2):
      can: add limit for nframes and clean up signed/unsigned variables
      can-raw: Fix skb_orphan_try handling

Ondrej Zary (1):
      matroxfb: fix incorrect use of memcpy_toio()

Patrick J. LoPresti (1):
      nfs: Add "lookupcache" to displayed mount options

Rajkumar Manoharan (1):
      ath9k_htc: fix panic on packet injection using airbase-ng tool.

Ross Burton (1):
      USB: add device IDs for igotu to navman

Russell King (1):
      ARM: Tighten check for allowable CPSR values

Ryusuke Konishi (1):
      nilfs2: fix list corruption after ifile creation failure

Shaohua Li (1):
      tracing: Fix an unallocated memory access in function_graph

Srinivas Eeda (1):
      ocfs2 fix o2dlm dlm run purgelist (rev 3)

Stefani Seibold (1):
      mtd: change struct flchip_shared spinlock locking into mutex

Stephen Hemminger (1):
      bridge: add rcu_read_lock on transmit

Sven Eckelmann (3):
      Staging: batman-adv: Create batman_if only on register event
      Staging: batman-adv: Don't use net_dev after dev_put
      Staging: batman-adv: Don't write in not allocated packet_buff

Takashi Iwai (2):
      ALSA: riptide - Fix detection / load of firmware files
      ALSA: hda - Add quirk for Dell Vostro 1220

Tao Ma (1):
      ocfs2: Count more refcount records in file system fragmentation.

Thomas Gleixner (1):
      acpi: fix bogus preemption logic

Tiger Yang (1):
      ocfs2: do not overwrite error codes in ocfs2_init_acl

Tilman Sauerbeck (1):
      mtd: nand: Fix probe of Samsung NAND chips

Tilman Schmidt (1):
      isdn/gigaset: reduce syslog spam

Tim Chen (1):
      mutex: Improve the scalability of optimistic spinning

Trond Myklebust (1):
      NFS: Fix an Oops in the NFSv4 atomic open code

Victor van den Elzen (1):
      platform/x86: move rfkill for Dell Mini 1012 to compal-laptop

Wengang Wang (3):
      ocfs2/dlm: fix a dead lock
      ocfs2/dlm: avoid incorrect bit set in refmap on recovery master
      ocfs2/dlm: remove potential deadlock -V3

Yuri Kululin (1):
      wl1251: fix trigger scan timeout usage

Zhang, Yanmin (1):
      perf, x86: Fix Intel-nhm PMU programming errata workaround

