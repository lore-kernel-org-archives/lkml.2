Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0C3XGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:06:36 -0400
Received: from kroah.org ([198.145.64.141]:51723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab0C3XGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:06:11 -0400
Date: Tue, 30 Mar 2010 16:06:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/116] 2.6.32.11-stable review
Message-ID: <20100330230600.GA28802@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330230338.GA28642@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.32.11 release.
There are 116 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by April 1, 2010, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.11-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/filesystems/tmpfs.txt            |    6 +-
 Makefile                                       |    2 +-
 arch/arm/boot/compressed/head.S                |   50 ++++----
 arch/arm/boot/compressed/vmlinux.lds.in        |    3 +
 arch/mips/mm/tlbex.c                           |    8 -
 arch/sh/boot/compressed/misc.c                 |    2 +-
 arch/sparc/prom/p1275.c                        |   10 +-
 arch/x86/include/asm/fixmap.h                  |    6 +-
 arch/x86/include/asm/msr-index.h               |    2 +
 arch/x86/kernel/acpi/boot.c                    |    5 -
 arch/x86/kernel/apic/apic.c                    |   14 --
 arch/x86/kernel/apic/probe_32.c                |   27 ++++-
 arch/x86/kernel/apic/probe_64.c                |   13 +--
 arch/x86/kernel/cpu/intel.c                    |    3 +-
 arch/x86/kernel/mpparse.c                      |    7 -
 arch/x86/kernel/process.c                      |   32 ++++-
 arch/x86/kernel/process_64.c                   |    1 +
 arch/x86/kernel/smpboot.c                      |    2 -
 block/blk-settings.c                           |   93 ++++++++++----
 drivers/ata/ahci.c                             |   28 +++-
 drivers/char/tty_buffer.c                      |    6 +-
 drivers/edac/edac_mce_amd.c                    |    8 +-
 drivers/gpu/drm/drm_edid.c                     |  163 +++++++++---------------
 drivers/gpu/drm/i915/i915_drv.h                |    2 +-
 drivers/gpu/drm/i915/i915_gem.c                |   21 ++--
 drivers/gpu/drm/i915/intel_bios.c              |    4 -
 drivers/gpu/drm/i915/intel_crt.c               |    2 +-
 drivers/hwmon/coretemp.c                       |    2 +-
 drivers/i2c/busses/i2c-i801.c                  |    6 +-
 drivers/input/mouse/alps.c                     |    2 +
 drivers/input/serio/i8042-x86ia64io.h          |    7 +
 drivers/input/tablet/wacom.h                   |    7 +-
 drivers/input/tablet/wacom_sys.c               |    7 +-
 drivers/isdn/gigaset/ev-layer.c                |   12 +-
 drivers/isdn/gigaset/interface.c               |    1 -
 drivers/leds/leds-gpio.c                       |    3 +-
 drivers/media/video/em28xx/em28xx-dvb.c        |    1 +
 drivers/mmc/host/s3cmci.c                      |    2 +
 drivers/net/e1000e/hw.h                        |    1 +
 drivers/net/e1000e/ich8lan.c                   |    1 +
 drivers/net/e1000e/netdev.c                    |    1 +
 drivers/net/ixgbe/ixgbe_82599.c                |    1 +
 drivers/net/ixgbe/ixgbe_main.c                 |    2 +
 drivers/net/ixgbe/ixgbe_type.h                 |    1 +
 drivers/net/jme.c                              |   35 +++++
 drivers/net/tg3.c                              |   23 +++-
 drivers/net/tg3.h                              |    3 +
 drivers/net/wireless/ath/ath5k/ath5k.h         |    2 +-
 drivers/net/wireless/ath/ath5k/base.c          |   22 +++-
 drivers/net/wireless/ath/ath5k/qcu.c           |    5 +-
 drivers/net/wireless/ath/ath5k/reset.c         |    5 +-
 drivers/net/wireless/ath/ath9k/ath9k.h         |    1 +
 drivers/net/wireless/ath/ath9k/main.c          |   26 ++--
 drivers/net/wireless/ath/ath9k/xmit.c          |   32 +----
 drivers/net/wireless/b43/main.c                |   11 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-core.c        |   12 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c          |   21 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c          |   25 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   16 +-
 drivers/net/wireless/wl12xx/wl1251_debugfs.c   |    3 +-
 drivers/pci/pci.c                              |   43 +++----
 drivers/pci/pcie/aer/aerdrv_core.c             |   10 +-
 drivers/pci/quirks.c                           |   34 +++++
 drivers/scsi/mvsas/mv_init.c                   |    1 +
 drivers/scsi/scsi_transport_fc.c               |   24 ++--
 drivers/scsi/ses.c                             |    4 +-
 drivers/staging/rt2860/common/2860_rtmp_init.c |    2 +-
 drivers/usb/core/devio.c                       |   17 ++-
 drivers/usb/host/ehci-hcd.c                    |    2 +-
 drivers/usb/host/ehci-sched.c                  |   28 +++-
 drivers/usb/host/ehci.h                        |    5 +-
 drivers/usb/host/r8a66597-hcd.c                |   16 ++-
 drivers/usb/host/xhci-hcd.c                    |    1 +
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio_ids.h              |    7 +
 drivers/usb/serial/option.c                    |    7 +-
 drivers/usb/serial/qcserial.c                  |   29 ++++
 drivers/video/efifb.c                          |   11 ++-
 drivers/virtio/virtio_pci.c                    |    3 +-
 fs/exec.c                                      |    3 +-
 fs/gfs2/file.c                                 |    2 +-
 fs/nfs/delegation.h                            |    6 +
 fs/nfs/dir.c                                   |    2 +-
 fs/nfs/file.c                                  |    3 +-
 fs/nfs/inode.c                                 |    2 +-
 fs/nfs/pagelist.c                              |   23 ++--
 fs/partitions/msdos.c                          |   85 +++++++------
 fs/quota/dquot.c                               |   45 ++++++-
 include/linux/decompress/mm.h                  |   14 ++-
 include/linux/hrtimer.h                        |   13 ++-
 include/linux/if_tunnel.h                      |    1 +
 include/linux/lcm.h                            |    8 +
 include/linux/quotaops.h                       |   11 ++-
 include/linux/tty.h                            |   11 ++
 include/net/mac80211.h                         |    4 +
 init/main.c                                    |    9 +-
 ipc/mqueue.c                                   |    3 +-
 kernel/cpuset.c                                |   20 ++-
 kernel/hrtimer.c                               |   96 ++++++++------
 kernel/kthread.c                               |    2 +-
 kernel/perf_event.c                            |   13 ++-
 kernel/sched.c                                 |   76 ++++++-----
 kernel/softlockup.c                            |    4 +-
 kernel/time/clocksource.c                      |    4 +
 kernel/time/timer_list.c                       |    5 +-
 kernel/trace/ftrace.c                          |    2 +-
 kernel/trace/ring_buffer.c                     |   12 +-
 kernel/trace/trace.c                           |   24 +++-
 lib/Makefile                                   |    2 +-
 lib/lcm.c                                      |   15 ++
 mm/mempolicy.c                                 |   40 ++++--
 mm/readahead.c                                 |   12 ++
 net/bluetooth/l2cap.c                          |   15 ++-
 net/bluetooth/rfcomm/core.c                    |   15 ++-
 net/bluetooth/rfcomm/sock.c                    |   11 ++-
 net/bluetooth/sco.c                            |   11 ++-
 net/mac80211/ieee80211_i.h                     |    1 +
 net/mac80211/main.c                            |   15 ++
 net/mac80211/mlme.c                            |   20 ++-
 net/mac80211/rx.c                              |    8 +
 net/netfilter/xt_recent.c                      |    2 +-
 net/sunrpc/auth_gss/auth_gss.c                 |    5 +-
 net/sunrpc/rpc_pipe.c                          |    2 +
 security/min_addr.c                            |    3 +
 sound/pci/ac97/ac97_patch.c                    |    2 +
 sound/pci/cmipci.c                             |   14 ++-
 sound/pci/hda/hda_intel.c                      |   10 ++
 sound/pci/hda/patch_conexant.c                 |   15 ++
 sound/pci/hda/patch_realtek.c                  |   11 ++-
 tools/perf/Documentation/Makefile              |    4 +-
 tools/perf/Makefile                            |    4 +-
 133 files changed, 1170 insertions(+), 649 deletions(-)
