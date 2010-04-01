Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab0DAXUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:20:09 -0400
Received: from kroah.org ([198.145.64.141]:35371 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758946Ab0DAXSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:18:50 -0400
Date: Thu, 1 Apr 2010 16:17:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.2
Message-ID: <20100401231754.GC11291@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.2 kernel.

All users of the 2.6.33 kernel series should upgrade.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/tmpfs.txt          |    6 
 Makefile                                     |    2 
 arch/arm/boot/compressed/head.S              |   50 ++---
 arch/arm/boot/compressed/vmlinux.lds.in      |    3 
 arch/powerpc/kernel/perf_event.c             |    8 
 arch/sh/boot/compressed/misc.c               |    2 
 arch/sparc/kernel/perf_event.c               |    4 
 arch/sparc/prom/p1275.c                      |   12 -
 arch/x86/include/asm/fixmap.h                |    6 
 arch/x86/include/asm/msr-index.h             |    2 
 arch/x86/kernel/cpu/intel.c                  |    3 
 arch/x86/kernel/cpu/perf_event.c             |    9 -
 arch/x86/kernel/dumpstack_64.c               |   10 -
 arch/x86/kernel/hw_breakpoint.c              |    5 
 arch/x86/kernel/process.c                    |   32 ++-
 arch/x86/kvm/x86.c                           |    1 
 arch/x86/mm/pageattr.c                       |   25 ++
 drivers/ata/ahci.c                           |   28 ++-
 drivers/ata/pata_via.c                       |    4 
 drivers/char/tty_buffer.c                    |    6 
 drivers/edac/edac_mce_amd.c                  |    7 
 drivers/gpu/drm/i915/i915_gem.c              |   21 +-
 drivers/gpu/drm/i915/intel_overlay.c         |   13 +
 drivers/gpu/drm/nouveau/nouveau_connector.c  |    6 
 drivers/hwmon/coretemp.c                     |    2 
 drivers/i2c/busses/i2c-i801.c                |    6 
 drivers/i2c/busses/i2c-powermac.c            |   25 ++
 drivers/ide/icside.c                         |   64 +++++++
 drivers/ide/ide-probe.c                      |   12 -
 drivers/ide/pdc202xx_old.c                   |    4 
 drivers/input/mouse/alps.c                   |    2 
 drivers/input/serio/i8042-x86ia64io.h        |    7 
 drivers/isdn/gigaset/capi.c                  |   46 +++--
 drivers/isdn/gigaset/common.c                |    6 
 drivers/isdn/gigaset/dummyll.c               |   14 +
 drivers/isdn/gigaset/ev-layer.c              |   12 -
 drivers/isdn/gigaset/gigaset.h               |    6 
 drivers/isdn/gigaset/i4l.c                   |   28 ++-
 drivers/isdn/gigaset/interface.c             |    1 
 drivers/leds/leds-gpio.c                     |    3 
 drivers/media/video/em28xx/em28xx-dvb.c      |    1 
 drivers/net/bonding/bond_main.c              |    2 
 drivers/net/can/bfin_can.c                   |    3 
 drivers/net/e100.c                           |    2 
 drivers/net/jme.c                            |   35 ++++
 drivers/net/pppol2tp.c                       |    6 
 drivers/net/r8169.c                          |   29 ++-
 drivers/net/tg3.c                            |    2 
 drivers/net/wireless/ath/ath5k/ath5k.h       |    2 
 drivers/net/wireless/ath/ath5k/base.c        |   22 ++
 drivers/net/wireless/ath/ath5k/phy.c         |   37 ++--
 drivers/net/wireless/ath/ath5k/qcu.c         |    5 
 drivers/net/wireless/ath/ath5k/reg.h         |    1 
 drivers/net/wireless/ath/ath5k/reset.c       |    5 
 drivers/net/wireless/ath/ath9k/ath9k.h       |    1 
 drivers/net/wireless/ath/ath9k/beacon.c      |    7 
 drivers/net/wireless/ath/ath9k/hw.c          |    7 
 drivers/net/wireless/ath/ath9k/hw.h          |    1 
 drivers/net/wireless/ath/ath9k/main.c        |   29 ++-
 drivers/net/wireless/ath/ath9k/pci.c         |    1 
 drivers/net/wireless/ath/ath9k/rc.c          |    6 
 drivers/net/wireless/ath/ath9k/xmit.c        |   32 ---
 drivers/net/wireless/b43/main.c              |   11 -
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    8 
 drivers/net/wireless/iwlwifi/iwl-core.c      |   12 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h   |    7 
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   21 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c        |   25 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   16 -
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |    3 
 drivers/pci/pci.c                            |   43 ++---
 drivers/pci/quirks.c                         |    1 
 drivers/platform/x86/classmate-laptop.c      |   31 ++-
 drivers/scsi/qlogicpti.c                     |    2 
 drivers/scsi/scsi_transport_fc.c             |   24 +-
 drivers/scsi/ses.c                           |    4 
 drivers/usb/core/devio.c                     |   17 +-
 drivers/usb/host/ehci-hcd.c                  |    2 
 drivers/usb/host/ehci-sched.c                |   28 ++-
 drivers/usb/host/ehci.h                      |    5 
 drivers/usb/host/r8a66597-hcd.c              |   16 +
 drivers/usb/host/xhci-hcd.c                  |    1 
 drivers/usb/serial/ftdi_sio.c                |    1 
 drivers/usb/serial/ftdi_sio_ids.h            |    7 
 drivers/usb/serial/option.c                  |    7 
 drivers/usb/serial/qcserial.c                |   29 +++
 drivers/video/Kconfig                        |   12 +
 drivers/video/Makefile                       |    1 
 drivers/video/sunxvr1000.c                   |  228 +++++++++++++++++++++++++++
 drivers/virtio/virtio_pci.c                  |    3 
 fs/exec.c                                    |    3 
 fs/gfs2/file.c                               |    2 
 fs/nfs/delegation.h                          |    6 
 fs/nfs/dir.c                                 |    2 
 fs/nfs/file.c                                |    3 
 fs/nfs/inode.c                               |    2 
 fs/nfs/pagelist.c                            |   23 +-
 fs/nilfs2/segment.c                          |    3 
 fs/partitions/msdos.c                        |   85 +++++-----
 fs/quota/dquot.c                             |   45 ++++-
 include/linux/decompress/mm.h                |   14 +
 include/linux/if_tunnel.h                    |    1 
 include/linux/kfifo.h                        |    2 
 include/linux/kvm.h                          |    1 
 include/linux/netdevice.h                    |    8 
 include/linux/netfilter/nfnetlink.h          |    2 
 include/linux/netlink.h                      |    2 
 include/linux/perf_event.h                   |    7 
 include/linux/quotaops.h                     |   11 +
 include/linux/skbuff.h                       |    6 
 include/linux/tty.h                          |   11 +
 include/net/mac80211.h                       |    7 
 include/net/netlink.h                        |    6 
 include/net/sock.h                           |   17 +-
 include/net/xfrm.h                           |    3 
 init/main.c                                  |    2 
 ipc/mqueue.c                                 |    3 
 kernel/cpuset.c                              |   20 +-
 kernel/hw_breakpoint.c                       |    1 
 kernel/irq/chip.c                            |   31 ++-
 kernel/irq/manage.c                          |   18 ++
 kernel/kthread.c                             |    2 
 kernel/perf_event.c                          |   34 ++--
 kernel/sched.c                               |   76 +++++----
 kernel/softlockup.c                          |    4 
 kernel/time/clocksource.c                    |    4 
 kernel/trace/ftrace.c                        |    2 
 kernel/trace/ring_buffer.c                   |   12 -
 kernel/trace/trace.c                         |   25 ++
 mm/mempolicy.c                               |   40 ++--
 net/8021q/vlan_core.c                        |    4 
 net/bluetooth/l2cap.c                        |   15 +
 net/bluetooth/rfcomm/core.c                  |   13 +
 net/bluetooth/rfcomm/sock.c                  |   11 +
 net/bluetooth/sco.c                          |   11 +
 net/core/dev.c                               |    8 
 net/core/sock.c                              |   16 +
 net/dccp/minisocks.c                         |    2 
 net/ipv4/ip_gre.c                            |    4 
 net/ipv4/route.c                             |   33 ++-
 net/ipv4/tcp.c                               |   65 +++++--
 net/ipv4/tcp_input.c                         |    3 
 net/ipv4/tcp_ipv4.c                          |    6 
 net/ipv4/tcp_minisocks.c                     |    2 
 net/ipv4/tcp_output.c                        |   18 +-
 net/ipv4/udp.c                               |    6 
 net/ipv4/xfrm4_policy.c                      |    5 
 net/ipv6/route.c                             |   13 +
 net/ipv6/tcp_ipv6.c                          |    6 
 net/ipv6/udp.c                               |   28 ++-
 net/ipv6/xfrm6_policy.c                      |    3 
 net/llc/llc_c_ac.c                           |    2 
 net/llc/llc_conn.c                           |    3 
 net/mac80211/ieee80211_i.h                   |    1 
 net/mac80211/mlme.c                          |   23 ++
 net/mac80211/rate.h                          |    5 
 net/mac80211/status.c                        |   17 +-
 net/netfilter/nf_conntrack_netlink.c         |    3 
 net/netfilter/nfnetlink.c                    |    4 
 net/netfilter/xt_recent.c                    |    2 
 net/netlink/af_netlink.c                     |   17 +-
 net/sctp/input.c                             |   42 +++-
 net/sctp/socket.c                            |    3 
 net/sunrpc/auth_gss/auth_gss.c               |    5 
 net/sunrpc/rpc_pipe.c                        |    2 
 net/sunrpc/svc_xprt.c                        |   13 -
 net/sunrpc/svcsock.c                         |    1 
 net/tipc/socket.c                            |    6 
 net/x25/x25_dev.c                            |    2 
 net/xfrm/xfrm_policy.c                       |    7 
 sound/pci/ac97/ac97_patch.c                  |    2 
 sound/pci/cmipci.c                           |   14 +
 sound/pci/hda/hda_intel.c                    |   10 +
 sound/pci/hda/patch_conexant.c               |   15 +
 sound/pci/hda/patch_realtek.c                |   10 -
 tools/perf/Documentation/Makefile            |    4 
 tools/perf/Makefile                          |    4 
 tools/perf/builtin-annotate.c                |   63 +++----
 tools/perf/builtin-probe.c                   |    1 
 tools/perf/util/probe-finder.c               |    3 
 tools/perf/util/symbol.c                     |    2 
 tools/perf/util/symbol.h                     |    2 
 182 files changed, 1692 insertions(+), 718 deletions(-)

Adel Gadllah (1):
      iwlwifi: Silence tfds_in_queue message

Alan Cox (1):
      tty: Keep the default buffering to sub-page units

Alan Stern (1):
      USB: fix usbfs regression

Alexander Duyck (2):
      pci: add support for 82576NS serdes to existing SR-IOV quirk
      skbuff: remove unused dma_head & dma_maps fields

Alexandra Kossovsky (1):
      tcp: Fix OOB POLLIN avoidance.

Andiry Xu (1):
      USB: xHCI: re-initialize cmd_completion

Andreas Herrmann (1):
      x86, amd: Restrict usage of c1e_idle()

Andrei Emeltchenko (1):
      Bluetooth: Fix kernel crash on L2CAP stress tests

André Goddard Rosa (1):
      mqueue: fix mq_open() file descriptor leak on user-space processes

Anton Vorontsov (1):
      leds-gpio: fix default state handling on OF platforms

Arnaldo Carvalho de Melo (1):
      perf annotate: Defer allocating sym_priv->hist array

Barry Song (1):
      can: fix bfin_can build error after alloc_candev() change

Bartlomiej Zolnierkiewicz (1):
      icside: bring back ->maskproc method

Ben Skeggs (1):
      drm/nouveau: report unknown connector state if lid closed

Bernhard Rosenkraenzer (1):
      USB: qcserial: add new device ids

Bob Copeland (2):
      ath5k: dont use external sleep clock in AP mode
      ath5k: fix setup for CAB queue

Borislav Petkov (1):
      edac, mce: Filter out invalid values

Bruno Randolf (1):
      ath5k: fix I/Q calibration (for real)

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

Dan Carpenter (2):
      sunrpc: handle allocation errors from __rpc_lookup_create()
      drm/i915: fix small leak on overlay error path

Daniel Chen (1):
      ALSA: ac97: Add Toshiba P500 to ac97 jack sense blacklist

Daniel Sangorrin (1):
      USB: serial: ftdi: add CONTEC vendor and product id

Daniel T Chen (4):
      ALSA: hda: Use LPIB and 6stack-dig for eMachines T5212
      ALSA: hda: Fix 0 dB offset for HP laptops using CX20551 (Waikiki)
      ALSA: hda: Use LPIB for ga-ma770-ud3 board
      ALSA: ac97: Add IBM ThinkPad R40e to Headphone/Line Jack Sense blacklist

Daniel Taylor (1):
      fs/partitions/msdos: add support for large disks

David Härdeman (1):
      kfifo: fix KFIFO_INIT in include/linux/kfifo.h

David S. Miller (5):
      sparc64: Make prom entry spinlock NMI safe.
      Revert "ide: skip probe if there are no devices on the port (v2)"
      sparc64: Properly truncate pt_regs framepointer in perf callback.
      sparc64: Add very basic XVR-1000 framebuffer driver.
      e100: Fix ring parameter change handling regression.

Dean Nelson (4):
      PCI: fix return value from pcix_get_max_mmrbc()
      PCI: fix access of PCI_X_CMD by pcix get and set mmrbc functions
      PCI: cleanup error return for pcix get and set mmrbc functions
      hwmon: (coretemp) Add missing newline to dev_warn() message

Dimitri Sivanich (1):
      x86: Fix sched_clock_cpu for systems with unsynchronized TSC

Dmitry Monakhov (1):
      quota: manage reserved space when quota is not active [v2]

Eric Dumazet (2):
      net: Potential null skb->dev dereference
      tcp: Fix tcp_make_synack()

Felix Fietkau (1):
      ath9k: fix BUG_ON triggered by PAE frames

Francesco Lavra (1):
      V4L/DVB (13961): em28xx-dvb: fix memleak in dvb_fini()

Frederic Weisbecker (2):
      x86/stacktrace: Don't dereference bad frame pointers
      hw-breakpoints: Remove stub unthrottle callback

Gal Rosen (1):
      SCSI: scsi_transport_fc: Fix synchronization issue while deleting vport

Grazvydas Ignotas (1):
      wl1251: fix potential crash

Greg Kroah-Hartman (1):
      Linux 2.6.33.2

Guenter Roeck (1):
      ipv4: Don't drop redirected route cache entry unless PTMU actually expired

Guo-Fu Tseng (2):
      jme: Fix VLAN memory leak
      jme: Protect vlgrp structure by pause RX actions.

Herbert Xu (1):
      ipsec: Fix bogus bundle flowi

J. Bruce Fields (2):
      Revert "sunrpc: fix peername failed on closed listener"
      Revert "sunrpc: move the close processing after do recvfrom method"

James Chapman (2):
      l2tp: Fix oops in pppol2tp_xmit
      l2tp: Fix UDP socket reference count bugs in the pppol2tp driver

Jan Beulich (1):
      x86: Fix placement of FIX_OHCI1394_BASE

Jan Kara (1):
      quota: Fix warning when a delayed write happens before quota is enabled

Jan Kiszka (1):
      KVM: x86: Add KVM_CAP_X86_ROBUST_SINGLESTEP

Jean Delvare (2):
      i2c-powermac: Be less verbose in the absence of real errors.
      i2c-i801: Don't use the block buffer for I2C block writes

John Kacur (1):
      perf: Make the install relative to DESTDIR if specified

John Stultz (1):
      timekeeping: Prevent oops when GENERIC_TIME=n

JosephChan@via.com.tw (1):
      pata_via: fix VT6410/6415/6330 detection issue

Julia Lawall (1):
      drivers/scsi/ses.c: eliminate double free

KOSAKI Motohiro (4):
      tmpfs: mpol=bind:0 don't cause mount error.
      tmpfs: handle MPOL_LOCAL mount option properly
      tmpfs: cleanup mpol_parse_str()
      doc: add the documentation for mpol=local

Lai Jiangshan (2):
      ring-buffer: Move disabled check into preempt disable section
      tracing: Fix warning in s_next of trace file ops

Lennart Schulte (1):
      tcp: Fix tcp_mark_head_lost() with packets == 0

Louis Rilling (1):
      tg3: Fix tg3_poll_controller() passing wrong pointer to tg3_interrupt()

Luis R. Rodriguez (1):
      ath9k: add support for 802.11n bonded out AR2427

Marcel Holtmann (1):
      Bluetooth: Fix potential bad memory access with sysfs files

Masami Hiramatsu (1):
      perf probe: Fix probe_point buffer overrun

Meelis Roos (1):
      qlogicpti: Remove slash in QlogicPTI irq name

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

Neil Brown (1):
      nfsd: ensure sockets are closed on error

Neil Horman (2):
      coredump: suppress uid comparison test if core output files are pipes
      r8169: offical fix for CVE-2009-4537 (overlength frame DMAs)

Nobuhiro Iwamatsu (1):
      sh: Fix zImage boot using fixed PMB.

OGAWA Hirofumi (1):
      fs/partition/msdos: fix unusable extended partition for > 512B sector

Pablo Neira Ayuso (3):
      netlink: fix NETLINK_RECV_NO_ENOBUFS in netlink_set_err()
      netfilter: ctnetlink: fix reliable event delivery if message building fails
      netlink: fix unaligned access in nla_get_be64()

Patrick McHardy (2):
      netfilter: xt_recent: fix regression in rules using a zero hit_count
      bonding: fix device leak on error in bond_create()

Paul Mackerras (1):
      perf_event: Fix oops triggered by cpu offline/online

Paulius Zaleckas (1):
      if_tunnel.h: add missing ams/byteorder.h include

Peter Zijlstra (1):
      perf: Provide generic perf_sample_data initialization

Ralf Gerbig (1):
      ALSA: hda - Sound MSI fallout on a Asus mobo NVIDIA MCP55

Ravikiran G Thirumalai (1):
      tmpfs: fix oops on mounts with mpol=default

Russell King (3):
      decompress: fix new decompressor for PIC
      ARM: Fix decompressor's kernel size estimation for ROM=y
      ide: Fix Promise UDMA33 IDE driver (pdc202xx_old)

Ryusuke Konishi (1):
      nilfs2: fix hang-up of cleaner after log writer returned with error

Sachin Prabhu (1):
      GFS2: Skip check for mandatory locks when unlocking

Senthil Balasubramanian (2):
      ath9k: Enable TIM timer interrupt only when needed.
      ath9k: configure the beacon only if the STA is associated

Stanislaw Gruszka (1):
      iwlwifi: use dma_alloc_coherent

Steven J. Magnani (1):
      NET_DMA: free skbs periodically

Steven Rostedt (4):
      function-graph: Init curr_ret_stack with ret_stack
      tracing: Use same local variable when resetting the ring buffer
      tracing: Disable buffer switching when starting or stopping trace
      tracing: Do not record user stack trace from NMI context

Sujith (1):
      mac80211: Fix HT rate control configuration

Suresh Siddha (2):
      x86_64, cpa: Don't work hard in preserving kernel 2M mappings when using 4K already
      sched: Fix SCHED_MC regression caused by change in sched cpu_power

Takashi Iwai (3):
      ALSA: hda - Fix input source elements of secondary ADCs on Realtek
      ALSA: hda - Disable MSI for Nvidia controller
      ALSA: hda - Fix secondary ADC of ALC260 basic model

Tejun Heo (1):
      ahci: use BIOS date in broken_suspend list

Thadeu Lima de Souza Cascardo (1):
      classmate-laptop: use a single MODULE_DEVICE_TABLE to get correct aliases

Thomas Bächler (1):
      Input: alps - add support for the touchpad on Toshiba Tecra A11-11L

Thomas Gleixner (1):
      genirq: Prevent oneshot irq thread race

Tilman Schmidt (5):
      gigaset: correct clearing of at_state strings on RING
      gigaset: prune use of tty_buffer_request_room
      gigaset: avoid registering CAPI driver more than once
      gigaset: fix build failure
      gigaset: correct range checking off by one error

Timo Teräs (2):
      ip_gre: include route header_len in max_headroom calculation
      ipv4: check rt_genid in dst_check

Trond Myklebust (4):
      NFSv4: Don't ignore the NFS_INO_REVAL_FORCED flag in nfs_revalidate_inode()
      NFS: Avoid a deadlock in nfs_release_page
      NFS: Prevent another deadlock in nfs_release_page()
      SUNRPC: Fix a potential memory leak in auth_gss

Vitaliy Gusev (1):
      route: Fix caught BUG_ON during rt_secret_rebuild_oneshot()

Vivek Natarajan (2):
      mac80211: Retry null data frame for power save
      ath9k: Enable IEEE80211_HW_REPORTS_TX_ACK_STATUS flag for ath9k

YOSHIFUJI Hideaki / 吉藤英明 (1):
      ipv6: Don't drop cache route entry unless timer actually expired.

Yoshihiro Shimoda (1):
      usb: r8a66597-hcd: fix removed from an attached hub

Zhu Yi (9):
      net: add limit for socket backlog
      tcp: use limited socket backlog
      udp: use limited socket backlog
      llc: use limited socket backlog
      sctp: use limited socket backlog
      tipc: use limited socket backlog
      x25: use limited socket backlog
      net: backlog functions rename
      net: add __must_check to sk_add_backlog

