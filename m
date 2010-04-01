Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0DAXTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:19:17 -0400
Received: from kroah.org ([198.145.64.141]:35363 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab0DAXSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:18:45 -0400
Date: Thu, 1 Apr 2010 16:16:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.11
Message-ID: <20100401231656.GA11291@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.11 kernel.

All users of the 2.6.32 kernel series should upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/tmpfs.txt            |    6 
 Makefile                                       |    2 
 arch/arm/boot/compressed/head.S                |   50 +++----
 arch/arm/boot/compressed/vmlinux.lds.in        |    3 
 arch/mips/mm/tlbex.c                           |    8 -
 arch/sh/boot/compressed/misc.c                 |    2 
 arch/sparc/prom/p1275.c                        |   10 -
 arch/x86/include/asm/fixmap.h                  |    6 
 arch/x86/include/asm/msr-index.h               |    2 
 arch/x86/kernel/acpi/boot.c                    |    5 
 arch/x86/kernel/apic/apic.c                    |   14 --
 arch/x86/kernel/apic/probe_32.c                |   27 +++-
 arch/x86/kernel/apic/probe_64.c                |   13 -
 arch/x86/kernel/cpu/intel.c                    |    3 
 arch/x86/kernel/mpparse.c                      |    7 -
 arch/x86/kernel/process.c                      |   32 +++-
 arch/x86/kernel/process_64.c                   |    1 
 arch/x86/kernel/smpboot.c                      |    2 
 block/blk-settings.c                           |   93 ++++++++++----
 drivers/ata/ahci.c                             |   28 +++-
 drivers/char/tty_buffer.c                      |    6 
 drivers/edac/edac_mce_amd.c                    |    8 -
 drivers/gpu/drm/drm_edid.c                     |  163 +++++++++----------------
 drivers/gpu/drm/i915/i915_drv.h                |    2 
 drivers/gpu/drm/i915/i915_gem.c                |   21 +--
 drivers/gpu/drm/i915/intel_bios.c              |    4 
 drivers/gpu/drm/i915/intel_crt.c               |    2 
 drivers/hwmon/coretemp.c                       |    2 
 drivers/i2c/busses/i2c-i801.c                  |    6 
 drivers/input/mouse/alps.c                     |    2 
 drivers/input/serio/i8042-x86ia64io.h          |    7 +
 drivers/input/tablet/wacom.h                   |    7 -
 drivers/input/tablet/wacom_sys.c               |    7 -
 drivers/isdn/gigaset/ev-layer.c                |   12 -
 drivers/isdn/gigaset/interface.c               |    1 
 drivers/leds/leds-gpio.c                       |    3 
 drivers/media/video/em28xx/em28xx-dvb.c        |    1 
 drivers/mmc/host/s3cmci.c                      |    2 
 drivers/net/e1000e/hw.h                        |    1 
 drivers/net/e1000e/ich8lan.c                   |    1 
 drivers/net/e1000e/netdev.c                    |    1 
 drivers/net/ixgbe/ixgbe_82599.c                |    1 
 drivers/net/ixgbe/ixgbe_main.c                 |    2 
 drivers/net/ixgbe/ixgbe_type.h                 |    1 
 drivers/net/jme.c                              |   35 +++++
 drivers/net/tg3.c                              |   23 ++-
 drivers/net/tg3.h                              |    3 
 drivers/net/wireless/ath/ath5k/ath5k.h         |    2 
 drivers/net/wireless/ath/ath5k/base.c          |   22 ++-
 drivers/net/wireless/ath/ath5k/qcu.c           |    5 
 drivers/net/wireless/ath/ath5k/reset.c         |    5 
 drivers/net/wireless/ath/ath9k/ath9k.h         |    1 
 drivers/net/wireless/ath/ath9k/main.c          |   26 ++-
 drivers/net/wireless/ath/ath9k/xmit.c          |   32 ----
 drivers/net/wireless/b43/main.c                |   11 -
 drivers/net/wireless/iwlwifi/iwl-3945.c        |    8 -
 drivers/net/wireless/iwlwifi/iwl-core.c        |   12 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |    7 -
 drivers/net/wireless/iwlwifi/iwl-rx.c          |   21 +--
 drivers/net/wireless/iwlwifi/iwl-tx.c          |   25 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   16 +-
 drivers/net/wireless/wl12xx/wl1251_debugfs.c   |    3 
 drivers/pci/pci.c                              |   43 +++---
 drivers/pci/pcie/aer/aerdrv_core.c             |   10 -
 drivers/pci/quirks.c                           |    1 
 drivers/scsi/mvsas/mv_init.c                   |    1 
 drivers/scsi/scsi_transport_fc.c               |   24 +--
 drivers/scsi/ses.c                             |    4 
 drivers/staging/rt2860/common/2860_rtmp_init.c |    2 
 drivers/usb/core/devio.c                       |   17 ++
 drivers/usb/host/ehci-hcd.c                    |    2 
 drivers/usb/host/ehci-sched.c                  |   28 +++-
 drivers/usb/host/ehci.h                        |    5 
 drivers/usb/host/r8a66597-hcd.c                |   16 +-
 drivers/usb/host/xhci-hcd.c                    |    1 
 drivers/usb/serial/ftdi_sio.c                  |    1 
 drivers/usb/serial/ftdi_sio_ids.h              |    7 +
 drivers/usb/serial/option.c                    |    7 -
 drivers/usb/serial/qcserial.c                  |   29 ++++
 drivers/video/efifb.c                          |   11 +
 drivers/virtio/virtio_pci.c                    |    3 
 fs/exec.c                                      |    3 
 fs/gfs2/file.c                                 |    2 
 fs/nfs/delegation.h                            |    6 
 fs/nfs/dir.c                                   |    2 
 fs/nfs/file.c                                  |    3 
 fs/nfs/inode.c                                 |    2 
 fs/nfs/pagelist.c                              |   23 +--
 fs/partitions/msdos.c                          |   85 +++++++------
 fs/quota/dquot.c                               |   45 +++++-
 include/linux/decompress/mm.h                  |   14 +-
 include/linux/hrtimer.h                        |   13 +
 include/linux/if_tunnel.h                      |    1 
 include/linux/lcm.h                            |    8 +
 include/linux/quotaops.h                       |   11 +
 include/linux/tty.h                            |   11 +
 include/net/mac80211.h                         |    4 
 init/main.c                                    |    9 -
 ipc/mqueue.c                                   |    3 
 kernel/cpuset.c                                |   20 +--
 kernel/hrtimer.c                               |   96 ++++++++------
 kernel/kthread.c                               |    2 
 kernel/perf_event.c                            |   13 +
 kernel/sched.c                                 |   76 ++++++-----
 kernel/softlockup.c                            |    4 
 kernel/time/clocksource.c                      |    4 
 kernel/time/timer_list.c                       |    5 
 kernel/trace/ftrace.c                          |    2 
 kernel/trace/ring_buffer.c                     |   12 -
 kernel/trace/trace.c                           |   24 +++
 lib/Makefile                                   |    2 
 lib/lcm.c                                      |   15 ++
 mm/mempolicy.c                                 |   40 +++---
 mm/readahead.c                                 |   12 +
 net/bluetooth/l2cap.c                          |   15 ++
 net/bluetooth/rfcomm/core.c                    |   15 +-
 net/bluetooth/rfcomm/sock.c                    |   11 +
 net/bluetooth/sco.c                            |   11 +
 net/mac80211/ieee80211_i.h                     |    1 
 net/mac80211/main.c                            |   15 ++
 net/mac80211/mlme.c                            |   20 ++-
 net/mac80211/rx.c                              |    8 +
 net/netfilter/xt_recent.c                      |    2 
 net/sunrpc/auth_gss/auth_gss.c                 |    5 
 net/sunrpc/rpc_pipe.c                          |    2 
 security/min_addr.c                            |    3 
 sound/pci/ac97/ac97_patch.c                    |    2 
 sound/pci/cmipci.c                             |   14 +-
 sound/pci/hda/hda_intel.c                      |   10 +
 sound/pci/hda/patch_conexant.c                 |   15 ++
 sound/pci/hda/patch_realtek.c                  |   11 +
 tools/perf/Documentation/Makefile              |    4 
 tools/perf/Makefile                            |    4 
 133 files changed, 1137 insertions(+), 649 deletions(-)

Adam Jackson (1):
      drm/edid: Unify detailed block parsing between base and extension blocks

Adel Gadllah (1):
      iwlwifi: Silence tfds_in_queue message

Alan Cox (1):
      tty: Keep the default buffering to sub-page units

Alan Stern (1):
      USB: fix usbfs regression

Alexander Duyck (1):
      pci: add support for 82576NS serdes to existing SR-IOV quirk

Andiry Xu (1):
      USB: xHCI: re-initialize cmd_completion

Andreas Herrmann (1):
      x86, amd: Restrict usage of c1e_idle()

Andrei Emeltchenko (1):
      Bluetooth: Fix kernel crash on L2CAP stress tests

Andrew Patterson (1):
      PCI: unconditionally clear AER uncorr status register during cleanup

André Goddard Rosa (1):
      mqueue: fix mq_open() file descriptor leak on user-space processes

Anton Vorontsov (1):
      leds-gpio: fix default state handling on OF platforms

Ben Hutchings (1):
      rt2860sta: Fix argument to linux_pci_unmap_single()

Bernhard Rosenkraenzer (1):
      USB: qcserial: add new device ids

Bob Copeland (2):
      ath5k: dont use external sleep clock in AP mode
      ath5k: fix setup for CAB queue

Borislav Petkov (1):
      edac, mce: Filter out invalid values

Bruce Allan (1):
      e1000e: enable new 82567V-3 device

Chris Wilson (1):
      drm/i915: Avoid NULL deref in get_pages() unwind after error.

Christoph Fritz (1):
      Input: i8042 - add ALDI/MEDION netbook E1222 to qurik reset table

Clemens Ladisch (3):
      ALSA: cmipci: work around invalid PCM pointer
      USB: EHCI: fix ITD list order
      USB: EHCI: adjust ehci_iso_stream for changes in ehci_qh

Colin Ian King (1):
      softlockup: Stop spurious softlockup messages due to overflow

Dan Carpenter (1):
      sunrpc: handle allocation errors from __rpc_lookup_create()

Daniel Chen (1):
      ALSA: ac97: Add Toshiba P500 to ac97 jack sense blacklist

Daniel Sangorrin (1):
      USB: serial: ftdi: add CONTEC vendor and product id

Daniel T Chen (6):
      ALSA: hda: enable MSI for Gateway M-6866
      ALSA: hda: Use LPIB and 6stack-dig for eMachines T5212
      ALSA: hda: Fix 0 dB offset for HP laptops using CX20551 (Waikiki)
      ALSA: hda: Use LPIB for ga-ma770-ud3 board
      ALSA: ac97: Add IBM ThinkPad R40e to Headphone/Line Jack Sense blacklist
      ALSA: hda: Use ALC260_WILL quirk for another Acer model (0x1025007f)

Daniel Taylor (1):
      fs/partitions/msdos: add support for large disks

David Daney (1):
      MIPS: Cleanup forgotten label_module_alloc in tlbex.c

David S. Miller (1):
      sparc64: Make prom entry spinlock NMI safe.

Dean Nelson (4):
      PCI: fix return value from pcix_get_max_mmrbc()
      PCI: fix access of PCI_X_CMD by pcix get and set mmrbc functions
      PCI: cleanup error return for pcix get and set mmrbc functions
      hwmon: (coretemp) Add missing newline to dev_warn() message

Dimitri Sivanich (1):
      x86: Fix sched_clock_cpu for systems with unsynchronized TSC

Dmitry Monakhov (1):
      quota: manage reserved space when quota is not active [v2]

Don Skidmore (1):
      ixgbe: add support for 82599 KR device 0x1517

Felix Fietkau (1):
      ath9k: fix BUG_ON triggered by PAE frames

Francesco Lavra (1):
      V4L/DVB (13961): em28xx-dvb: fix memleak in dvb_fini()

Gal Rosen (1):
      SCSI: scsi_transport_fc: Fix synchronization issue while deleting vport

Grazvydas Ignotas (1):
      wl1251: fix potential crash

Greg Kroah-Hartman (1):
      Linux 2.6.32.11

Guo-Fu Tseng (2):
      jme: Fix VLAN memory leak
      jme: Protect vlgrp structure by pause RX actions.

Hisashi Hifumi (1):
      readahead: add blk_run_backing_dev

Jan Beulich (1):
      x86: Fix placement of FIX_OHCI1394_BASE

Jan Kara (1):
      quota: Fix warning when a delayed write happens before quota is enabled

Jean Delvare (1):
      i2c-i801: Don't use the block buffer for I2C block writes

John Kacur (1):
      perf: Make the install relative to DESTDIR if specified

John Stultz (1):
      timekeeping: Prevent oops when GENERIC_TIME=n

Julia Lawall (1):
      drivers/scsi/ses.c: eliminate double free

KOSAKI Motohiro (4):
      tmpfs: mpol=bind:0 don't cause mount error.
      tmpfs: handle MPOL_LOCAL mount option properly
      tmpfs: cleanup mpol_parse_str()
      doc: add the documentation for mpol=local

Kees Cook (1):
      sysctl: require CAP_SYS_RAWIO to set mmap_min_addr

Lai Jiangshan (1):
      ring-buffer: Move disabled check into preempt disable section

Lars-Peter Clausen (1):
      s3cmci: initialize default platform data no_wprotect and no_detect with 1

Louis Rilling (1):
      tg3: Fix tg3_poll_controller() passing wrong pointer to tg3_interrupt()

Marcel Holtmann (2):
      Bluetooth: Fix sleeping function in RFCOMM within invalid context
      Bluetooth: Fix potential bad memory access with sysfs files

Marcin Slusarz (1):
      efifb: fix framebuffer handoff

Martin K. Petersen (1):
      block: Backport of various I/O topology fixes from 2.6.33 and 2.6.34

Matt Carlson (1):
      tg3: Fix 5906 transmit hangs

Mel Gorman (1):
      tty: Take a 256 byte padding into account when buffering below sub-page units

Miao Xie (1):
      cpuset: fix the problem that cpuset_mem_spread_node() returns an offline node

Michael Buesch (1):
      b43: Workaround circular locking in hw-tkip key update callback

Michael S. Tsirkin (1):
      virtio: fix out of range array access

Ming Lei (1):
      ath9k: fix lockdep warning when unloading module

Nathaniel McCallum (3):
      USB: option: fix incorrect manufacturer name in usb/serial/option: MAXON->CMOTECH
      USB: option: move hardcoded PID to a macro in usb/serial/option
      USB: option: add support for a new CMOTECH device to usb/serial/option

Neil Horman (1):
      coredump: suppress uid comparison test if core output files are pipes

Nobuhiro Iwamatsu (1):
      sh: Fix zImage boot using fixed PMB.

OGAWA Hirofumi (1):
      fs/partition/msdos: fix unusable extended partition for > 512B sector

Oleg Nesterov (1):
      x86: set_personality_ia32() misses force_personality32

Patrick McHardy (1):
      netfilter: xt_recent: fix regression in rules using a zero hit_count

Paul Mackerras (1):
      perf_event: Fix oops triggered by cpu offline/online

Paulius Zaleckas (1):
      if_tunnel.h: add missing ams/byteorder.h include

Peter Zijlstra (1):
      sched: Mark boot-cpu active before smp_init()

Ping Cheng (1):
      Input: wacom - ensure the device is initialized properly upon resume

Ravikiran G Thirumalai (1):
      tmpfs: fix oops on mounts with mpol=default

Russell King (2):
      decompress: fix new decompressor for PIC
      ARM: Fix decompressor's kernel size estimation for ROM=y

Sachin Prabhu (1):
      GFS2: Skip check for mandatory locks when unlocking

Senthil Balasubramanian (1):
      ath9k: Enable TIM timer interrupt only when needed.

Shaohua Li (1):
      drm/i915: fix gpio register detection logic for BIOS without VBT

Srinivas (1):
      mvsas: add support for Adaptec ASC-1045/1405 SAS/SATA HBA

Stanislaw Gruszka (1):
      iwlwifi: use dma_alloc_coherent

Steven Rostedt (4):
      function-graph: Init curr_ret_stack with ret_stack
      tracing: Use same local variable when resetting the ring buffer
      tracing: Disable buffer switching when starting or stopping trace
      tracing: Do not record user stack trace from NMI context

Suresh Siddha (2):
      x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs
      sched: Fix SCHED_MC regression caused by change in sched cpu_power

Takashi Iwai (3):
      ALSA: hda - Fix input source elements of secondary ADCs on Realtek
      ALSA: hda - Disable MSI for Nvidia controller
      ALSA: hda - Fix secondary ADC of ALC260 basic model

Tejun Heo (1):
      ahci: use BIOS date in broken_suspend list

Thomas Bächler (1):
      Input: alps - add support for the touchpad on Toshiba Tecra A11-11L

Thomas Gleixner (1):
      hrtimer: Tune hrtimer_interrupt hang logic

Tilman Schmidt (2):
      gigaset: correct clearing of at_state strings on RING
      gigaset: prune use of tty_buffer_request_room

Trond Myklebust (4):
      NFSv4: Don't ignore the NFS_INO_REVAL_FORCED flag in nfs_revalidate_inode()
      NFS: Avoid a deadlock in nfs_release_page
      NFS: Prevent another deadlock in nfs_release_page()
      SUNRPC: Fix a potential memory leak in auth_gss

Vivek Natarajan (3):
      mac80211: Retry null data frame for power save
      ath9k: Enable IEEE80211_HW_REPORTS_TX_ACK_STATUS flag for ath9k
      mac80211: Reset dynamic ps timer in Rx path.

Yoshihiro Shimoda (1):
      usb: r8a66597-hcd: fix removed from an attached hub

