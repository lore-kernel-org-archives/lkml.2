Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab1LGWMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:12:49 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33224 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758510Ab1LGWMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:12:47 -0500
X-Sasl-enc: bfo5X1zrgx92LbjjOtutWpXAt7XRZqcWp9AEA4YMlev9 1323295966
Date: Wed, 7 Dec 2011 14:12:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/104] 3.1.5-stable review
Message-ID: <20111207221243.GA6817@kroah.com>
References: <20111207161246.GA10995@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207161246.GA10995@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 08:12:46AM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 3.1.5 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> Responses should be made by Friday, December 9, 2011, 17:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.5-rc1.gz
> and the diffstat can be found below.

I forgot a number of networking patches, so there is an -rc2 patch now
at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.5-rc2.gz

and the diffstat for it is below.

thanks,

greg k-h


 Makefile                                       |    4 +-
 arch/arm/Kconfig                               |   12 ++
 arch/arm/configs/ezx_defconfig                 |    2 +-
 arch/arm/configs/imote2_defconfig              |    2 +-
 arch/arm/configs/magician_defconfig            |    2 +-
 arch/arm/configs/zeus_defconfig                |    2 +-
 arch/arm/kernel/process.c                      |    3 +
 arch/arm/mach-mxs/clock-mx28.c                 |    2 +-
 arch/arm/mach-omap2/Kconfig                    |    1 +
 arch/arm/mach-omap2/omap_hwmod.c               |    6 +-
 arch/arm/mach-omap2/pm.c                       |    6 +-
 arch/arm/mach-omap2/smartreflex.c              |    2 +-
 arch/arm/mach-omap2/twl-common.c               |   11 ++
 arch/arm/mach-omap2/twl-common.h               |    3 +
 arch/arm/mach-pxa/balloon3.c                   |    2 +-
 arch/arm/mach-pxa/colibri-pxa320.c             |    2 +-
 arch/arm/mach-pxa/gumstix.c                    |    2 +-
 arch/arm/mach-pxa/include/mach/palm27x.h       |    4 +-
 arch/arm/mach-pxa/palm27x.c                    |    4 +-
 arch/arm/mach-pxa/palmtc.c                     |    2 +-
 arch/arm/mach-pxa/vpac270.c                    |    2 +-
 arch/s390/kernel/ptrace.c                      |   18 +++
 arch/x86/include/asm/timer.h                   |   23 ++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c      |    6 +-
 arch/x86/kernel/mpparse.c                      |    2 +-
 arch/x86/kernel/reboot.c                       |   13 ++-
 arch/x86/mm/highmem_32.c                       |    2 +
 arch/x86/oprofile/init.c                       |    7 +-
 drivers/crypto/mv_cesa.c                       |   12 +-
 drivers/firmware/sigma.c                       |   81 +++++++++----
 drivers/gpu/drm/drm_crtc.c                     |    4 +
 drivers/gpu/drm/i915/i915_irq.c                |    1 +
 drivers/gpu/drm/i915/i915_reg.h                |    4 +
 drivers/gpu/drm/i915/i915_suspend.c            |    2 +
 drivers/gpu/drm/i915/intel_display.c           |   14 ++
 drivers/gpu/drm/i915/intel_panel.c             |    3 +-
 drivers/gpu/drm/radeon/evergreen.c             |    7 +-
 drivers/gpu/drm/radeon/r100.c                  |    7 +-
 drivers/gpu/drm/radeon/radeon_atombios.c       |   24 ++++
 drivers/gpu/drm/radeon/rs600.c                 |    7 +-
 drivers/gpu/drm/radeon/rv770.c                 |    7 +-
 drivers/hid/hid-core.c                         |    2 +-
 drivers/hid/hid-ids.h                          |    2 +-
 drivers/i2c/algos/i2c-algo-bit.c               |    4 +-
 drivers/infiniband/core/addr.c                 |    9 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    4 +
 drivers/infiniband/hw/cxgb4/cm.c               |    4 +
 drivers/infiniband/hw/mlx4/qp.c                |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c             |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   18 ++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |   36 ++++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c     |    5 -
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   29 ++---
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    2 +
 drivers/net/wireless/iwlwifi/iwl-pci.c         |    8 +-
 drivers/net/wireless/p54/p54spi.c              |    5 +-
 drivers/net/wireless/rt2x00/rt2800lib.c        |    2 +-
 drivers/net/wireless/rtlwifi/ps.c              |   17 ++--
 drivers/oprofile/oprof.c                       |   29 ++++-
 drivers/oprofile/timer_int.c                   |    1 +
 drivers/pci/hotplug/shpchp_core.c              |    4 +-
 drivers/pci/hotplug/shpchp_hpc.c               |    4 +-
 drivers/regulator/aat2870-regulator.c          |    2 +-
 drivers/regulator/twl-regulator.c              |   46 +++++++-
 drivers/rtc/class.c                            |   10 +-
 drivers/rtc/interface.c                        |   44 ++++++--
 drivers/s390/net/qeth_l3_main.c                |    7 +
 drivers/scsi/scsi_lib.c                        |    3 +-
 drivers/staging/comedi/comedi_fops.c           |   94 +++++++++++----
 drivers/staging/rts_pstor/rtsx.c               |    1 +
 drivers/staging/usbip/vhci_rx.c                |   10 +-
 drivers/usb/host/ehci-sched.c                  |   22 ++--
 drivers/usb/host/whci/qset.c                   |    2 +-
 drivers/usb/host/xhci.c                        |    5 +-
 drivers/usb/musb/musb_core.c                   |    6 -
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio_ids.h              |    1 +
 drivers/usb/serial/option.c                    |    4 +
 drivers/usb/storage/unusual_devs.h             |    7 +
 drivers/video/via/share.h                      |    4 +-
 fs/ecryptfs/crypto.c                           |   26 ++--
 fs/ecryptfs/ecryptfs_kernel.h                  |    5 +-
 fs/ecryptfs/file.c                             |   23 ++++-
 fs/ecryptfs/inode.c                            |   52 +++++----
 fs/ext4/inode.c                                |    2 +-
 fs/xfs/xfs_buf.h                               |    1 -
 fs/xfs/xfs_file.c                              |   34 +++++-
 fs/xfs/xfs_iops.c                              |    2 +-
 fs/xfs/xfs_mount.c                             |   29 ++---
 fs/xfs/xfs_qm.c                                |    3 +-
 fs/xfs/xfs_vnodeops.c                          |   14 ++-
 include/drm/drm_mode.h                         |    2 +
 include/drm/drm_pciids.h                       |    8 ++
 include/linux/clocksource.h                    |    3 +-
 include/linux/sigma.h                          |   13 +--
 include/net/inetpeer.h                         |    1 +
 include/net/red.h                              |   15 +--
 kernel/cgroup_freezer.c                        |   11 ++-
 kernel/hrtimer.c                               |    6 +-
 kernel/irq/manage.c                            |    5 +-
 kernel/irq/spurious.c                          |    4 +-
 kernel/jump_label.c                            |    3 +-
 kernel/time/clockevents.c                      |    1 +
 kernel/time/clocksource.c                      |   62 ++++++++--
 kernel/time/tick-broadcast.c                   |    2 +-
 kernel/time/timekeeping.c                      |   11 ++
 kernel/trace/ftrace.c                          |    1 -
 kernel/trace/trace_events.c                    |    1 -
 kernel/trace/trace_events_filter.c             |    6 +-
 mm/hugetlb.c                                   |    2 +
 mm/slab.c                                      |    5 +-
 net/bridge/br_multicast.c                      |    2 +
 net/ipv4/ah4.c                                 |    6 +-
 net/ipv4/ip_options.c                          |    1 +
 net/ipv4/route.c                               |  152 ++++++++++++++++--------
 net/ipv6/ah6.c                                 |    6 +-
 net/mac80211/agg-tx.c                          |   41 ++++++-
 net/mac80211/main.c                            |    6 +
 net/sched/sch_red.c                            |    4 +-
 net/sched/sch_teql.c                           |   31 +++--
 net/sunrpc/xprtsock.c                          |    3 +-
 net/wireless/nl80211.c                         |    4 +-
 net/wireless/reg.c                             |   49 +++++---
 sound/pci/hda/patch_realtek.c                  |   14 ++-
 sound/pci/hda/patch_sigmatel.c                 |   18 ---
 sound/pci/hda/patch_via.c                      |   76 +++++++-----
 sound/pci/lx6464es/lx_core.c                   |   16 ++-
 sound/soc/codecs/ad1836.h                      |    2 +-
 sound/soc/codecs/sta32x.c                      |   63 ++++++++++-
 sound/soc/codecs/sta32x.h                      |    1 +
 sound/soc/codecs/wm8731.c                      |    1 +
 sound/soc/codecs/wm8753.c                      |    3 +
 sound/soc/fsl/fsl_ssi.c                        |    1 +
 tools/perf/util/trace-event-parse.c            |    2 +
 135 files changed, 1171 insertions(+), 472 deletions(-)

