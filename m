Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1HCWN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 18:13:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49165 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755615Ab1HCWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 18:13:50 -0400
X-Sasl-enc: I+JUtPD4AUpdJykWgPxqbBkHfB8F3mM1ij90+aY+DFou 1312409629
Date: Wed, 3 Aug 2011 15:13:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/102] 3.0.1-stable review
Message-ID: <20110803221345.GA10346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.1 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, August 5, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                           |    4 +-
 arch/alpha/kernel/time.c                           |    2 +-
 arch/arm/mach-pxa/cm-x300.c                        |    8 +-
 arch/powerpc/kernel/crash.c                        |    6 +-
 arch/powerpc/kernel/time.c                         |    2 +-
 arch/powerpc/platforms/pseries/hvconsole.c         |    2 +-
 arch/x86/include/asm/msr-index.h                   |    3 +
 arch/x86/kernel/cpu/intel.c                        |   18 +++
 arch/x86/kernel/relocate_kernel_32.S               |    2 +
 arch/x86/kernel/relocate_kernel_64.S               |    2 +
 arch/x86/oprofile/backtrace.c                      |   56 ++++++++--
 arch/xtensa/kernel/ptrace.c                        |    3 +
 block/blk-core.c                                   |    3 +
 block/blk-exec.c                                   |    7 ++
 drivers/block/cciss.h                              |    2 +-
 drivers/firewire/core-cdev.c                       |   20 ++--
 drivers/firmware/sigma.c                           |    3 +
 drivers/gpu/drm/radeon/atombios_dp.c               |   22 +++-
 drivers/gpu/drm/radeon/radeon_combios.c            |    3 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |    3 +
 drivers/infiniband/ulp/srp/ib_srp.c                |    2 +
 drivers/md/dm-io.c                                 |   29 +++++-
 drivers/md/dm-mpath.c                              |    5 +
 drivers/md/dm-snap-persistent.c                    |    2 +-
 drivers/md/dm.c                                    |   10 ++-
 drivers/misc/Kconfig                               |    3 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |    2 +-
 drivers/net/jme.c                                  |   20 +++-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    3 +-
 drivers/net/wireless/ath/ath9k/mac.c               |    3 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |    2 +-
 drivers/pci/pci.c                                  |    7 +-
 drivers/pci/quirks.c                               |   23 ++++
 drivers/rtc/interface.c                            |   55 +++++++---
 drivers/rtc/rtc-tegra.c                            |    2 +-
 drivers/scsi/hpsa.h                                |    2 +-
 drivers/scsi/libsas/sas_expander.c                 |    3 +
 drivers/scsi/pmcraid.c                             |    3 +
 drivers/scsi/scsi_devinfo.c                        |    2 +
 drivers/scsi/scsi_lib.c                            |    2 +
 drivers/scsi/ses.c                                 |    6 +-
 drivers/scsi/sr.c                                  |   46 +++++++-
 drivers/scsi/sr.h                                  |    7 ++
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   49 ++++++---
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   31 +++---
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    9 ++
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    5 -
 drivers/staging/comedi/comedi_fops.c               |    4 +-
 drivers/staging/hv/channel.c                       |    2 +-
 drivers/staging/hv/channel_mgmt.c                  |    2 +-
 drivers/staging/hv/connection.c                    |    2 +-
 drivers/staging/hv/netvsc.c                        |    4 +-
 drivers/staging/hv/rndis_filter.c                  |    6 +-
 drivers/staging/hv/storvsc.c                       |    8 +-
 drivers/staging/hv/storvsc_drv.c                   |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c             |    6 +
 drivers/staging/usbip/vhci_hcd.c                   |    4 +-
 drivers/tty/hvc/hvc_console.c                      |    8 +-
 drivers/tty/n_gsm.c                                |    4 -
 drivers/tty/serial/8250.c                          |    2 +-
 drivers/tty/serial/Kconfig                         |    2 +-
 drivers/usb/host/ehci-hcd.c                        |    8 +-
 drivers/usb/host/ehci-hub.c                        |    3 +-
 drivers/usb/host/ehci-q.c                          |   85 +++++++--------
 drivers/usb/host/ehci.h                            |    4 +-
 drivers/usb/host/pci-quirks.c                      |   28 +++++
 drivers/usb/musb/musb_core.c                       |    1 +
 drivers/usb/serial/pl2303.c                        |    1 +
 drivers/usb/serial/pl2303.h                        |    4 +
 drivers/watchdog/shwdt.c                           |    2 +-
 fs/cifs/dir.c                                      |    2 +-
 fs/ecryptfs/inode.c                                |    1 +
 fs/ecryptfs/keystore.c                             |   47 +++++----
 fs/ext3/xattr.c                                    |   12 ++-
 fs/ext4/ext4.h                                     |    1 +
 fs/ext4/extents.c                                  |   11 +-
 fs/ext4/mballoc.c                                  |    2 +-
 fs/gfs2/ops_fstype.c                               |    4 +-
 fs/nfs/delegation.c                                |   16 ++--
 fs/nfs/dir.c                                       |   56 ++++++----
 fs/nfs/nfs4filelayout.c                            |    2 +-
 fs/nfs/nfs4proc.c                                  |    8 ++-
 fs/nfs/nfs4xdr.c                                   |    2 +-
 fs/nfs/pnfs.c                                      |   63 ++++++-----
 fs/nfs/pnfs.h                                      |    6 +-
 fs/nfsd/nfs4state.c                                |   66 +++++-------
 fs/proc/base.c                                     |   16 +++-
 include/linux/firewire-cdev.h                      |    3 +
 include/linux/mm.h                                 |    2 +
 include/linux/netdevice.h                          |    5 +-
 include/linux/nfs_fs.h                             |    3 +-
 include/linux/nfs_xdr.h                            |    2 +-
 ipc/sem.c                                          |   13 ++-
 kernel/events/core.c                               |    7 +-
 kernel/futex.c                                     |    4 +-
 kernel/trace/trace.h                               |    1 +
 kernel/trace/trace_events.c                        |  113 ++++++++++++++++---
 kernel/trace/trace_events_filter.c                 |    6 +
 lib/xz/xz_private.h                                |    2 +-
 mm/backing-dev.c                                   |    1 +
 mm/memcontrol.c                                    |    2 +-
 mm/memory.c                                        |   58 ++++++++++-
 mm/oom_kill.c                                      |    4 +-
 net/bridge/br_private.h                            |    1 +
 net/bridge/br_stp.c                                |    4 +-
 net/core/ethtool.c                                 |    4 +-
 net/mac80211/mlme.c                                |    3 +
 net/sunrpc/svc_xprt.c                              |   11 +-
 net/wireless/reg.c                                 |    5 +-
 security/apparmor/domain.c                         |    2 +-
 security/apparmor/lsm.c                            |    2 +-
 sound/core/pcm_compat.c                            |    2 +-
 sound/pci/hda/patch_realtek.c                      |    7 +-
 sound/pci/oxygen/xonar_pcm179x.c                   |    5 +-
 sound/soc/davinci/davinci-vcif.c                   |    9 +-
 sound/soc/soc-core.c                               |    1 +
 tools/perf/Makefile                                |    5 +-
 tools/perf/util/header.c                           |    5 +-
 tools/perf/util/session.c                          |   30 +++--
 tools/perf/util/session.h                          |    1 +
 121 files changed, 932 insertions(+), 403 deletions(-)
