Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2IQAtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:49:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33286 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304Ab2IQAtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:03 -0400
Message-Id: <20120917003625.784119135@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/135] 3.2.30-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.30 release.
There are 135 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Sep 19 01:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.29 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 .../devicetree/bindings/mmc/fsl-imx-esdhc.txt      |    8 +-
 Documentation/i2c/busses/i2c-i801                  |    2 +
 Makefile                                           |    4 +-
 arch/arm/Kconfig                                   |    1 +
 arch/arm/Makefile                                  |    4 +-
 arch/arm/boot/dts/imx51-babbage.dts                |    4 +-
 arch/arm/include/asm/pgtable.h                     |   34 ++---
 arch/arm/kernel/hw_breakpoint.c                    |   55 ++++++--
 arch/arm/kernel/traps.c                            |   11 +-
 arch/arm/mach-dove/common.c                        |    2 +-
 arch/arm/mach-imx/hotplug.c                        |   23 +--
 arch/arm/mach-kirkwood/common.c                    |    4 +-
 arch/arm/mach-mv78xx0/common.c                     |    6 +-
 arch/arm/mach-orion5x/common.c                     |    3 +-
 arch/arm/mm/flush.c                                |    2 -
 arch/arm/plat-omap/dmtimer.c                       |    2 +-
 arch/arm/plat-orion/common.c                       |    8 +-
 arch/arm/plat-orion/include/plat/common.h          |    6 +-
 arch/arm/plat-s3c24xx/dma.c                        |    2 +-
 arch/parisc/include/asm/atomic.h                   |    4 +-
 arch/powerpc/kernel/asm-offsets.c                  |    1 +
 arch/powerpc/kernel/dbell.c                        |    2 +
 arch/powerpc/kernel/entry_64.S                     |   23 ++-
 arch/powerpc/kernel/process.c                      |   12 +-
 arch/powerpc/kernel/smp.c                          |   11 +-
 arch/powerpc/kernel/sysfs.c                        |   10 ++
 arch/powerpc/kernel/traps.c                        |    3 +-
 arch/powerpc/sysdev/xics/icp-hv.c                  |   42 ++++--
 arch/x86/xen/setup.c                               |    9 +-
 drivers/ata/ahci.c                                 |    2 +
 drivers/gpu/drm/drm_crtc.c                         |   19 +--
 drivers/gpu/drm/drm_edid.c                         |   25 +++-
 drivers/gpu/drm/i915/i915_irq.c                    |   20 ++-
 drivers/gpu/drm/i915/i915_reg.h                    |   10 +-
 drivers/gpu/drm/i915/intel_display.c               |   41 ++----
 drivers/gpu/drm/i915/intel_lvds.c                  |    4 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   30 ++--
 drivers/gpu/drm/nouveau/nouveau_display.c          |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |  146 +++++++++++++++++---
 drivers/gpu/drm/radeon/atombios_encoders.c         |  105 +++++++-------
 drivers/gpu/drm/radeon/radeon_device.c             |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    6 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   10 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   73 ++++++++++
 drivers/hid/Kconfig                                |    1 +
 drivers/hid/hid-core.c                             |    3 +
 drivers/hid/hid-ids.h                              |    5 +
 drivers/hid/hid-multitouch.c                       |   15 ++
 drivers/hid/usbhid/hid-quirks.c                    |    4 +
 drivers/hwmon/asus_atk0110.c                       |    6 +
 drivers/hwmon/twl4030-madc-hwmon.c                 |    9 +-
 drivers/i2c/busses/Kconfig                         |    7 +
 drivers/i2c/busses/Makefile                        |    5 +-
 drivers/i2c/busses/i2c-designware-core.c           |   11 ++
 drivers/i2c/busses/i2c-i801.c                      |    6 +
 drivers/input/serio/i8042-x86ia64io.h              |   14 ++
 drivers/isdn/isdnloop/isdnloop.c                   |   12 --
 drivers/mmc/card/block.c                           |   27 +++-
 drivers/mmc/host/mxs-mmc.c                         |   12 +-
 drivers/mmc/host/sdhci-esdhc.h                     |    6 +-
 drivers/mtd/ubi/vtbl.c                             |    4 +-
 drivers/net/can/mcp251x.c                          |   11 +-
 drivers/net/ethernet/freescale/gianfar.c           |    2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   26 ++--
 drivers/net/ethernet/intel/e1000e/e1000.h          |    1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |   49 +++----
 drivers/net/ethernet/sfc/efx.c                     |    6 +
 drivers/net/ethernet/sfc/efx.h                     |   14 +-
 drivers/net/ethernet/sfc/ethtool.c                 |   16 ++-
 drivers/net/ethernet/sfc/nic.h                     |    3 +
 drivers/net/ethernet/sfc/tx.c                      |   19 +++
 drivers/net/ppp/pptp.c                             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |   30 ++--
 drivers/net/wireless/rt2x00/rt2400pci.c            |    9 ++
 drivers/net/wireless/rt2x00/rt2400pci.h            |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c            |    9 ++
 drivers/net/wireless/rt2x00/rt2500usb.c            |   11 +-
 drivers/net/wireless/rt2x00/rt2500usb.h            |   17 +--
 drivers/net/wireless/rt2x00/rt2800pci.c            |    9 ++
 drivers/net/wireless/rt2x00/rt2800usb.c            |   22 ++-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    9 ++
 drivers/net/wireless/rt2x00/rt61pci.h              |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c              |    9 ++
 drivers/net/wireless/rt2x00/rt73usb.h              |    3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |   13 +-
 drivers/scsi/scsi_error.c                          |   10 ++
 drivers/scsi/scsi_scan.c                           |   10 ++
 drivers/staging/comedi/drivers/das08.c             |    4 +-
 drivers/staging/rtl8712/recv_linux.c               |    7 +-
 drivers/staging/vt6656/dpc.c                       |    2 +-
 drivers/staging/vt6656/rxtx.c                      |   38 ++---
 drivers/staging/zcache/zcache-main.c               |    7 +-
 drivers/tty/serial/imx.c                           |   30 ++--
 drivers/usb/core/quirks.c                          |    4 +
 drivers/usb/host/ehci-q.c                          |   12 +-
 drivers/usb/host/pci-quirks.c                      |   49 ++++++-
 drivers/usb/host/pci-quirks.h                      |    2 +
 drivers/usb/host/xhci-hub.c                        |   42 ++++++
 drivers/usb/host/xhci-pci.c                        |    9 ++
 drivers/usb/host/xhci-ring.c                       |   39 ++++--
 drivers/usb/host/xhci.c                            |  124 +++++++++++++++++
 drivers/usb/host/xhci.h                            |    7 +
 drivers/usb/serial/ftdi_sio.c                      |   22 ++-
 drivers/usb/serial/ftdi_sio_ids.h                  |   29 +++-
 drivers/usb/serial/option.c                        |    4 +
 drivers/video/omap2/omapfb/omapfb-main.c           |    2 +-
 drivers/xen/swiotlb-xen.c                          |    2 +-
 fs/cifs/file.c                                     |    2 +-
 fs/ecryptfs/inode.c                                |    5 +
 fs/ext3/inode.c                                    |   17 ++-
 fs/fuse/dev.c                                      |    1 +
 fs/nfs/inode.c                                     |    2 +-
 fs/nfs/nfs3proc.c                                  |    2 +-
 fs/nfs/nfs4proc.c                                  |    4 +-
 fs/nfs/nfs4xdr.c                                   |   11 +-
 fs/nfs/super.c                                     |    2 +
 fs/stat.c                                          |    5 +-
 fs/udf/file.c                                      |   35 ++++-
 include/drm/drm_mode.h                             |    5 +-
 include/linux/kobject.h                            |    2 +-
 include/linux/ktime.h                              |    7 -
 include/linux/mmc/card.h                           |    1 +
 include/linux/mv643xx_eth.h                        |    2 +
 include/linux/netdevice.h                          |    4 +
 include/linux/nfs_fs.h                             |    5 -
 include/linux/pci_ids.h                            |    2 +-
 include/linux/perf_event.h                         |    2 +-
 include/linux/sunrpc/xprt.h                        |    3 +
 include/linux/time.h                               |   29 +++-
 include/net/scm.h                                  |    4 +-
 include/net/sock.h                                 |    2 +
 kernel/events/core.c                               |   62 +++++----
 kernel/time/timekeeping.c                          |   32 ++++-
 kernel/workqueue.c                                 |    9 +-
 mm/mempolicy.c                                     |    2 +-
 net/atm/common.c                                   |    1 +
 net/atm/pvc.c                                      |    1 +
 net/bluetooth/hci_sock.c                           |    2 +
 net/bluetooth/l2cap_sock.c                         |    1 +
 net/bluetooth/rfcomm/sock.c                        |    2 +
 net/bluetooth/rfcomm/tty.c                         |    2 +-
 net/core/dev.c                                     |   27 +++-
 net/core/sock.c                                    |    1 +
 net/dccp/ccids/ccid3.c                             |    1 +
 net/ipv4/ipmr.c                                    |   14 +-
 net/ipv4/tcp.c                                     |    4 +-
 net/ipv4/tcp_cong.c                                |    3 +-
 net/ipv4/tcp_output.c                              |   21 +--
 net/ipv6/addrconf.c                                |    4 +-
 net/l2tp/l2tp_core.c                               |    3 +-
 net/l2tp/l2tp_core.h                               |    1 +
 net/llc/af_llc.c                                   |    3 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    1 +
 net/netlink/af_netlink.c                           |    6 +-
 net/packet/af_packet.c                             |   10 +-
 net/sched/act_gact.c                               |   14 +-
 net/socket.c                                       |    1 +
 net/sunrpc/xprt.c                                  |   34 +++--
 net/sunrpc/xprtrdma/transport.c                    |    1 +
 net/sunrpc/xprtsock.c                              |    3 +
 net/unix/af_unix.c                                 |    4 +-
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/ice1712/prodigy_hifi.c                   |    3 +-
 168 files changed, 1549 insertions(+), 581 deletions(-)

-- 
Ben Hutchings
The world is coming to an end.	Please log off.

