Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0C3XGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:06:19 -0400
Received: from kroah.org ([198.145.64.141]:51727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab0C3XGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:06:12 -0400
Date: Tue, 30 Mar 2010 16:06:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/156] 2.6.33.2-stable review
Message-ID: <20100330230630.GA28824@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330230338.GA28642@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.33.2 release.
There are 156 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by April 1, 2010, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/filesystems/tmpfs.txt          |    6 +-
 Makefile                                     |    2 +-
 arch/arm/boot/compressed/head.S              |   50 +++---
 arch/arm/boot/compressed/vmlinux.lds.in      |    3 +
 arch/powerpc/kernel/perf_event.c             |    8 +-
 arch/sh/boot/compressed/misc.c               |    2 +-
 arch/sparc/kernel/perf_event.c               |    4 +-
 arch/sparc/prom/p1275.c                      |   12 +-
 arch/x86/include/asm/fixmap.h                |    6 +-
 arch/x86/include/asm/msr-index.h             |    2 +
 arch/x86/kernel/cpu/intel.c                  |    3 +-
 arch/x86/kernel/cpu/perf_event.c             |    9 +-
 arch/x86/kernel/dumpstack_64.c               |   12 +-
 arch/x86/kernel/hw_breakpoint.c              |    5 -
 arch/x86/kernel/process.c                    |   32 +++-
 arch/x86/kvm/x86.c                           |    1 +
 arch/x86/mm/pageattr.c                       |   25 +++-
 drivers/ata/ahci.c                           |   28 +++-
 drivers/ata/pata_via.c                       |    4 +
 drivers/char/tty_buffer.c                    |    6 +-
 drivers/edac/edac_mce_amd.c                  |    7 +-
 drivers/gpu/drm/i915/i915_gem.c              |   21 ++-
 drivers/gpu/drm/i915/intel_overlay.c         |   13 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c  |    6 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c      |    8 +-
 drivers/hwmon/coretemp.c                     |    2 +-
 drivers/i2c/busses/i2c-i801.c                |    6 +-
 drivers/i2c/busses/i2c-powermac.c            |   25 ++-
 drivers/ide/icside.c                         |   64 +++++++-
 drivers/ide/ide-probe.c                      |   12 +-
 drivers/ide/pdc202xx_old.c                   |    4 +-
 drivers/input/mouse/alps.c                   |    2 +
 drivers/input/serio/i8042-x86ia64io.h        |    7 +
 drivers/isdn/gigaset/capi.c                  |   46 +++---
 drivers/isdn/gigaset/common.c                |    6 +-
 drivers/isdn/gigaset/dummyll.c               |   14 ++-
 drivers/isdn/gigaset/ev-layer.c              |   12 +-
 drivers/isdn/gigaset/gigaset.h               |    6 +-
 drivers/isdn/gigaset/i4l.c                   |   28 +++-
 drivers/isdn/gigaset/interface.c             |    1 -
 drivers/leds/leds-gpio.c                     |    3 +-
 drivers/media/video/em28xx/em28xx-dvb.c      |    1 +
 drivers/net/bonding/bond_main.c              |    2 +
 drivers/net/can/bfin_can.c                   |    3 +-
 drivers/net/e100.c                           |    2 +-
 drivers/net/jme.c                            |   35 ++++
 drivers/net/pppol2tp.c                       |    6 +-
 drivers/net/r8169.c                          |   29 +++-
 drivers/net/tg3.c                            |    2 +-
 drivers/net/wireless/ath/ath5k/ath5k.h       |    2 +-
 drivers/net/wireless/ath/ath5k/base.c        |   22 ++-
 drivers/net/wireless/ath/ath5k/phy.c         |   37 ++--
 drivers/net/wireless/ath/ath5k/qcu.c         |    5 +-
 drivers/net/wireless/ath/ath5k/reg.h         |    1 +
 drivers/net/wireless/ath/ath5k/reset.c       |    5 +-
 drivers/net/wireless/ath/ath9k/ath9k.h       |    1 +
 drivers/net/wireless/ath/ath9k/beacon.c      |    7 +
 drivers/net/wireless/ath/ath9k/hw.c          |    7 +-
 drivers/net/wireless/ath/ath9k/hw.h          |    1 +
 drivers/net/wireless/ath/ath9k/main.c        |   29 ++--
 drivers/net/wireless/ath/ath9k/pci.c         |    1 +
 drivers/net/wireless/ath/ath9k/rc.c          |    6 +-
 drivers/net/wireless/ath/ath9k/xmit.c        |   32 +---
 drivers/net/wireless/b43/main.c              |   11 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-core.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   21 ++-
 drivers/net/wireless/iwlwifi/iwl-tx.c        |   25 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   16 +-
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |    3 +-
 drivers/pci/pci.c                            |   43 +++---
 drivers/pci/quirks.c                         |   34 ++++
 drivers/platform/x86/classmate-laptop.c      |   31 +++-
 drivers/scsi/qlogicpti.c                     |    2 +-
 drivers/scsi/scsi_transport_fc.c             |   24 ++--
 drivers/scsi/ses.c                           |    4 +-
 drivers/usb/core/devio.c                     |   17 ++-
 drivers/usb/host/ehci-hcd.c                  |    2 +-
 drivers/usb/host/ehci-sched.c                |   28 +++-
 drivers/usb/host/ehci.h                      |    5 +-
 drivers/usb/host/r8a66597-hcd.c              |   16 ++-
 drivers/usb/host/xhci-hcd.c                  |    1 +
 drivers/usb/serial/ftdi_sio.c                |    1 +
 drivers/usb/serial/ftdi_sio_ids.h            |    7 +
 drivers/usb/serial/option.c                  |    7 +-
 drivers/usb/serial/qcserial.c                |   29 ++++
 drivers/video/Kconfig                        |   12 ++
 drivers/video/Makefile                       |    1 +
 drivers/video/sunxvr1000.c                   |  228 ++++++++++++++++++++++++++
 drivers/virtio/virtio_pci.c                  |    3 +-
 fs/exec.c                                    |    3 +-
 fs/gfs2/file.c                               |    2 +-
 fs/nfs/delegation.h                          |    6 +
 fs/nfs/dir.c                                 |    2 +-
 fs/nfs/file.c                                |    3 +-
 fs/nfs/inode.c                               |    2 +-
 fs/nfs/pagelist.c                            |   23 ++-
 fs/nilfs2/segment.c                          |    3 +-
 fs/partitions/msdos.c                        |   85 ++++++----
 fs/quota/dquot.c                             |   45 ++++-
 include/linux/decompress/mm.h                |   14 ++-
 include/linux/if_tunnel.h                    |    1 +
 include/linux/kfifo.h                        |    2 -
 include/linux/kvm.h                          |    1 +
 include/linux/netdevice.h                    |    8 +-
 include/linux/netfilter/nfnetlink.h          |    2 +-
 include/linux/netlink.h                      |    2 +-
 include/linux/perf_event.h                   |    7 +
 include/linux/quotaops.h                     |   11 +-
 include/linux/skbuff.h                       |    6 -
 include/linux/tty.h                          |   11 ++
 include/net/mac80211.h                       |    7 +-
 include/net/netlink.h                        |    6 +-
 include/net/sock.h                           |   17 ++-
 include/net/xfrm.h                           |    3 +-
 init/main.c                                  |    2 +-
 ipc/mqueue.c                                 |    3 +-
 kernel/cpuset.c                              |   20 ++-
 kernel/hw_breakpoint.c                       |    1 -
 kernel/irq/chip.c                            |   31 +++-
 kernel/irq/manage.c                          |   18 ++
 kernel/kthread.c                             |    2 +-
 kernel/perf_event.c                          |   34 +++--
 kernel/sched.c                               |   76 +++++----
 kernel/softlockup.c                          |    4 +-
 kernel/time/clocksource.c                    |    4 +
 kernel/trace/ftrace.c                        |    2 +-
 kernel/trace/ring_buffer.c                   |   12 +-
 kernel/trace/trace.c                         |   25 +++-
 mm/mempolicy.c                               |   40 +++--
 net/8021q/vlan_core.c                        |    4 +-
 net/bluetooth/l2cap.c                        |   15 ++-
 net/bluetooth/rfcomm/core.c                  |   13 ++-
 net/bluetooth/rfcomm/sock.c                  |   11 +-
 net/bluetooth/sco.c                          |   11 +-
 net/core/dev.c                               |    8 +-
 net/core/sock.c                              |   16 ++-
 net/dccp/minisocks.c                         |    2 +-
 net/ipv4/ip_gre.c                            |    4 +-
 net/ipv4/route.c                             |   33 ++--
 net/ipv4/tcp.c                               |   65 +++++---
 net/ipv4/tcp_input.c                         |    3 +
 net/ipv4/tcp_ipv4.c                          |    6 +-
 net/ipv4/tcp_minisocks.c                     |    2 +-
 net/ipv4/tcp_output.c                        |   18 +-
 net/ipv4/udp.c                               |    6 +-
 net/ipv4/xfrm4_policy.c                      |    5 +-
 net/ipv6/route.c                             |   13 +-
 net/ipv6/tcp_ipv6.c                          |    6 +-
 net/ipv6/udp.c                               |   28 ++-
 net/ipv6/xfrm6_policy.c                      |    3 +-
 net/llc/llc_c_ac.c                           |    2 +-
 net/llc/llc_conn.c                           |    3 +-
 net/mac80211/ieee80211_i.h                   |    1 +
 net/mac80211/mlme.c                          |   23 ++-
 net/mac80211/rate.h                          |    5 +-
 net/mac80211/status.c                        |   17 ++-
 net/netfilter/nf_conntrack_netlink.c         |    3 +-
 net/netfilter/nfnetlink.c                    |    4 +-
 net/netfilter/xt_recent.c                    |    2 +-
 net/netlink/af_netlink.c                     |   17 ++-
 net/sctp/input.c                             |   42 +++--
 net/sctp/socket.c                            |    3 +
 net/sunrpc/auth_gss/auth_gss.c               |    5 +-
 net/sunrpc/rpc_pipe.c                        |    2 +
 net/sunrpc/svc_xprt.c                        |   13 +-
 net/sunrpc/svcsock.c                         |    1 +
 net/tipc/socket.c                            |    6 +-
 net/x25/x25_dev.c                            |    2 +-
 net/xfrm/xfrm_policy.c                       |    7 +-
 sound/pci/ac97/ac97_patch.c                  |    2 +
 sound/pci/cmipci.c                           |   14 ++-
 sound/pci/hda/hda_intel.c                    |   10 +
 sound/pci/hda/patch_conexant.c               |   15 ++
 sound/pci/hda/patch_realtek.c                |   10 +-
 tools/perf/Documentation/Makefile            |    4 +-
 tools/perf/Makefile                          |    4 +-
 tools/perf/builtin-annotate.c                |   65 ++++----
 tools/perf/builtin-probe.c                   |    1 -
 tools/perf/util/probe-finder.c               |    3 +
 tools/perf/util/symbol.c                     |    2 +-
 tools/perf/util/symbol.h                     |    2 +
 183 files changed, 1728 insertions(+), 727 deletions(-)
