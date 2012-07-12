Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2GLTY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:24:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40168 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab2GLTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:24:26 -0400
Date: Thu, 12 Jul 2012 12:24:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/187] 3.4.5-stable review
Message-ID: <20120712192421.GA28926@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.5 release.
There are 187 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jul 14 19:15:16 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/device-mapper/verity.txt             |  131 +++++++-------------
 Documentation/stable_kernel_rules.txt              |    6 +
 Makefile                                           |    4 +-
 arch/arm/mach-dove/include/mach/bridge-regs.h      |    1 +
 arch/arm/mach-dove/include/mach/dove.h             |    1 +
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h  |    1 +
 arch/arm/mach-kirkwood/include/mach/kirkwood.h     |    1 +
 arch/arm/mach-mv78xx0/include/mach/bridge-regs.h   |    1 +
 arch/arm/mach-mv78xx0/include/mach/mv78xx0.h       |    2 +
 arch/arm/mach-orion5x/include/mach/bridge-regs.h   |    2 +-
 arch/arm/mach-orion5x/include/mach/orion5x.h       |    1 +
 arch/arm/mach-tegra/reset.c                        |    2 +-
 arch/arm/mm/mmu.c                                  |   74 +++++++++++
 arch/arm/plat-orion/common.c                       |    2 +-
 arch/arm/plat-samsung/include/plat/map-s3c.h       |    2 +-
 .../arm/plat-samsung/include/plat/watchdog-reset.h |    2 +-
 arch/powerpc/include/asm/hw_irq.h                  |   11 +-
 arch/powerpc/kernel/irq.c                          |   50 +++++++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |    2 +-
 arch/powerpc/mm/numa.c                             |    2 +-
 arch/powerpc/platforms/cell/pervasive.c            |   11 +-
 arch/powerpc/platforms/pseries/iommu.c             |    4 +-
 arch/powerpc/platforms/pseries/processor_idle.c    |   17 +--
 arch/powerpc/xmon/xmon.c                           |    2 +-
 arch/x86/ia32/ia32_signal.c                        |    2 +-
 arch/x86/include/asm/cpufeature.h                  |    2 +-
 arch/x86/include/asm/pgtable-3level.h              |   54 ++++++++
 arch/x86/kernel/acpi/boot.c                        |   27 ++--
 arch/x86/kernel/cpu/scattered.c                    |    2 +-
 arch/x86/kernel/reboot.c                           |    8 ++
 drivers/acpi/acpi_pad.c                            |    7 +-
 drivers/acpi/acpica/hwsleep.c                      |   22 ----
 drivers/acpi/apei/apei-base.c                      |   17 ++-
 drivers/acpi/apei/apei-internal.h                  |    9 ++
 drivers/acpi/apei/ghes.c                           |    6 +-
 drivers/acpi/sleep.c                               |    4 +-
 drivers/acpi/sysfs.c                               |    4 +-
 drivers/acpi/video.c                               |    2 +
 drivers/base/power/main.c                          |    6 +-
 drivers/block/umem.c                               |   40 ++++++
 drivers/block/xen-blkback/common.h                 |    2 +
 drivers/clk/clk.c                                  |   27 ++--
 drivers/dma/pl330.c                                |    2 +-
 drivers/gpio/gpio-wm8994.c                         |    5 +-
 drivers/gpu/drm/drm_edid.c                         |    2 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   57 +++++----
 drivers/gpu/drm/i915/i915_suspend.c                |    5 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |   13 +-
 drivers/gpu/drm/radeon/si.c                        |    4 +-
 drivers/hid/hid-multitouch.c                       |   58 +++++++--
 drivers/hwmon/applesmc.c                           |    4 +-
 drivers/hwmon/coretemp.c                           |    4 +-
 drivers/hwspinlock/hwspinlock_core.c               |    4 +-
 drivers/iommu/amd_iommu.c                          |    9 ++
 drivers/iommu/amd_iommu_init.c                     |    4 +-
 drivers/iommu/tegra-smmu.c                         |    4 +-
 drivers/md/persistent-data/dm-space-map-checker.c  |   54 ++++----
 drivers/md/persistent-data/dm-space-map-disk.c     |   11 +-
 .../md/persistent-data/dm-transaction-manager.c    |   11 +-
 drivers/md/raid10.c                                |   12 +-
 drivers/md/raid5.c                                 |   14 ++-
 drivers/media/dvb/siano/smsusb.c                   |    2 +
 drivers/media/video/gspca/gspca.c                  |    4 +-
 drivers/mtd/nand/cafe_nand.c                       |    2 +-
 drivers/net/bonding/bond_main.c                    |    9 +-
 drivers/net/can/c_can/c_can.c                      |    4 +-
 drivers/net/can/flexcan.c                          |    4 +-
 drivers/net/dummy.c                                |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   15 ---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   35 ++++--
 drivers/net/ethernet/broadcom/tg3.c                |    3 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    5 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |    1 +
 drivers/net/ethernet/intel/e1000e/ethtool.c        |    6 +-
 drivers/net/ethernet/intel/e1000e/mac.c            |    2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   79 +++---------
 drivers/net/ethernet/intel/e1000e/phy.c            |    8 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c         |   29 +++--
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   14 ++-
 drivers/net/ethernet/marvell/sky2.c                |   10 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |   11 +-
 drivers/net/ethernet/realtek/r8169.c               |    3 +
 drivers/net/ethernet/sun/niu.c                     |   12 +-
 drivers/net/macvtap.c                              |   25 +++-
 drivers/net/usb/ipheth.c                           |    5 +
 drivers/net/usb/qmi_wwan.c                         |  109 +++++++++-------
 drivers/net/wireless/ath/ath.h                     |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h             |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   16 ++-
 drivers/net/wireless/ath/ath9k/main.c              |   18 +--
 drivers/net/wireless/ath/ath9k/recv.c              |    7 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   31 +++--
 drivers/net/wireless/ath/key.c                     |    4 +
 drivers/net/wireless/ipw2x00/ipw.h                 |   23 ++++
 drivers/net/wireless/ipw2x00/ipw2100.c             |    4 +
 drivers/net/wireless/ipw2x00/ipw2200.c             |    4 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c        |   12 ++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |    6 +
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |    5 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h       |    7 ++
 drivers/net/wireless/mwifiex/cfg80211.c            |   21 ++--
 drivers/net/wireless/mwifiex/wmm.c                 |    3 +
 drivers/net/wireless/rtl818x/rtl8187/leds.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |    3 +
 drivers/net/xen-netfront.c                         |    8 +-
 drivers/oprofile/oprofile_perf.c                   |    2 +-
 drivers/pci/pci-driver.c                           |   12 ++
 drivers/pci/pci.c                                  |    5 -
 drivers/pci/quirks.c                               |   26 ----
 drivers/remoteproc/Kconfig                         |    2 +
 drivers/rpmsg/virtio_rpmsg_bus.c                   |   55 +++++++-
 drivers/rtc/rtc-ab8500.c                           |    2 +-
 drivers/rtc/rtc-mxc.c                              |    5 +-
 drivers/rtc/rtc-spear.c                            |    2 +-
 drivers/scsi/aic94xx/aic94xx_task.c                |    2 +-
 drivers/scsi/libsas/sas_ata.c                      |   12 +-
 drivers/scsi/sd.c                                  |    2 +
 drivers/staging/iio/adc/ad7606_core.c              |    1 +
 drivers/staging/rtl8712/usb_intf.c                 |    2 +
 drivers/target/tcm_fc/tfc_sess.c                   |    3 +-
 drivers/usb/class/cdc-wdm.c                        |    2 +
 drivers/usb/core/hub.c                             |   18 +--
 drivers/usb/host/xhci-hub.c                        |   44 ++++++-
 drivers/usb/host/xhci-ring.c                       |   11 ++
 drivers/usb/host/xhci.h                            |    6 +-
 drivers/usb/serial/cp210x.c                        |   11 ++
 drivers/usb/serial/metro-usb.c                     |    8 --
 drivers/usb/serial/option.c                        |   34 +++++
 drivers/usb/storage/scsiglue.c                     |    6 +
 drivers/usb/storage/unusual_devs.h                 |    7 --
 drivers/video/omap2/dss/apply.c                    |    2 +-
 drivers/video/omap2/dss/dispc.c                    |    5 +-
 drivers/video/omap2/dss/dss.h                      |    3 +-
 fs/btrfs/tree-log.c                                |    6 +
 fs/cifs/connect.c                                  |   41 +++---
 fs/ecryptfs/kthread.c                              |    2 +-
 fs/ecryptfs/miscdev.c                              |   48 ++++---
 fs/exec.c                                          |    2 +-
 fs/lockd/clntlock.c                                |   13 +-
 fs/lockd/svc.c                                     |   38 +++---
 fs/nfs/callback.c                                  |   16 ++-
 fs/nfs/idmap.c                                     |   13 +-
 fs/nfsd/nfsctl.c                                   |   12 +-
 fs/nfsd/nfssvc.c                                   |   29 ++++-
 fs/nilfs2/gcinode.c                                |    2 +
 fs/nilfs2/segment.c                                |    2 +
 fs/ocfs2/file.c                                    |    6 +-
 fs/open.c                                          |    6 +-
 fs/ramfs/file-nommu.c                              |    1 +
 fs/splice.c                                        |   35 +++---
 fs/udf/super.c                                     |  102 +++++++++------
 include/asm-generic/pgtable.h                      |   32 ++++-
 include/linux/aio.h                                |    1 +
 include/linux/lockd/bind.h                         |    4 +-
 include/linux/memblock.h                           |    4 +-
 include/linux/mm_types.h                           |   10 ++
 include/linux/mmzone.h                             |    2 +-
 include/linux/pci.h                                |    2 -
 include/linux/rpmsg.h                              |    6 +
 include/linux/skbuff.h                             |    7 +-
 include/linux/splice.h                             |    8 +-
 include/linux/sunrpc/svc.h                         |    1 +
 include/net/cipso_ipv4.h                           |   29 ++++-
 include/net/inetpeer.h                             |    5 +-
 include/net/sch_generic.h                          |    7 +-
 include/scsi/libsas.h                              |    6 +-
 include/scsi/scsi_cmnd.h                           |    8 +-
 include/scsi/scsi_device.h                         |    1 +
 kernel/exit.c                                      |    1 +
 kernel/relay.c                                     |    5 +-
 kernel/trace/trace.c                               |    8 +-
 lib/dynamic_queue_limits.c                         |   18 +--
 mm/compaction.c                                    |    5 +-
 mm/madvise.c                                       |   16 ++-
 mm/memblock.c                                      |  123 +++++++++++-------
 mm/nobootmem.c                                     |   38 +++---
 mm/shmem.c                                         |    3 +-
 mm/vmscan.c                                        |    7 +-
 net/batman-adv/routing.c                           |    2 +
 net/batman-adv/translation-table.c                 |    8 +-
 net/bridge/br_if.c                                 |    1 +
 net/bridge/br_netlink.c                            |    2 +-
 net/bridge/br_private.h                            |    1 +
 net/can/raw.c                                      |    3 -
 net/core/dev.c                                     |   23 +---
 net/core/drop_monitor.c                            |  102 +++++----------
 net/core/neighbour.c                               |   14 +--
 net/core/netpoll.c                                 |   11 +-
 net/core/skbuff.c                                  |    3 +-
 net/core/sock.c                                    |    7 +-
 net/ipv4/inetpeer.c                                |   16 ++-
 net/ipv6/ip6_fib.c                                 |    2 +-
 net/ipv6/route.c                                   |   41 ++++--
 net/iucv/af_iucv.c                                 |    1 -
 net/l2tp/l2tp_eth.c                                |    2 +
 net/l2tp/l2tp_ip.c                                 |    9 +-
 net/mac80211/mlme.c                                |   24 ++--
 net/mac80211/rx.c                                  |    5 +-
 net/nfc/nci/ntf.c                                  |   10 +-
 net/nfc/rawsock.c                                  |    5 +-
 net/sunrpc/rpcb_clnt.c                             |   12 +-
 net/sunrpc/svc.c                                   |   23 ++--
 net/wireless/reg.c                                 |    2 +-
 sound/pci/hda/hda_codec.c                          |    2 +
 sound/pci/hda/patch_realtek.c                      |    1 +
 sound/pci/hda/patch_sigmatel.c                     |    4 +-
 sound/soc/codecs/tlv320aic3x.c                     |    4 +-
 sound/soc/codecs/tlv320aic3x.h                     |    1 +
 sound/soc/codecs/wm2200.c                          |    1 +
 tools/hv/hv_kvp_daemon.c                           |   10 +-
 214 files changed, 1802 insertions(+), 1011 deletions(-)
 create mode 100644 drivers/net/wireless/ipw2x00/ipw.h

