Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab1EFA5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:57:12 -0400
Received: from kroah.org ([198.145.64.141]:55556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab1EFA5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:57:05 -0400
Date: Thu, 5 May 2011 17:23:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/143] 2.6.32.40-longterm review
Message-ID: <20110506002311.GA15354@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.40 release.
There are 143 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Many thanks to Ben Hutchings for sending the large majority of these
patches to me for inclusion based on the patches in the Debian stable
kernel.  I really appreciate it.

Responses should be made by Sunday, May 8, 2011, 00:01:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.40-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 Documentation/usb/proc_usb_info.txt          |   34 ++++--
 Makefile                                     |    2 +-
 arch/arm/kernel/sys_oabi-compat.c            |    2 +-
 arch/m68k/mm/motorola.c                      |    2 +
 arch/mips/mm/dma-default.c                   |   28 +++--
 arch/parisc/mm/init.c                        |    4 +-
 arch/powerpc/boot/Makefile                   |    2 +-
 arch/x86/include/asm/kvm_host.h              |    3 +
 arch/x86/include/asm/pvclock.h               |   38 ++++++
 arch/x86/kernel/cpu/amd.c                    |    2 +-
 arch/x86/kernel/pvclock.c                    |    3 +-
 arch/x86/kvm/x86.c                           |   48 +++++++-
 block/blk-sysfs.c                            |    4 +-
 drivers/ata/libata-scsi.c                    |   24 +++-
 drivers/ata/sata_via.c                       |   15 +++
 drivers/bluetooth/btusb.c                    |    9 ++
 drivers/char/agp/generic.c                   |   19 +++-
 drivers/char/i8k.c                           |    7 +-
 drivers/gpu/drm/radeon/atom.c                |    6 +-
 drivers/hid/hid-apple.c                      |   46 +++++++-
 drivers/hid/hid-core.c                       |   12 ++
 drivers/hid/hid-ids.h                        |    6 +
 drivers/hwmon/applesmc.c                     |   66 +++++++++++
 drivers/input/mouse/elantech.c               |  142 +++++++++++++++--------
 drivers/input/mouse/elantech.h               |    8 +-
 drivers/input/mouse/synaptics.c              |   35 +++++-
 drivers/input/mouse/synaptics.h              |    4 +
 drivers/input/xen-kbdfront.c                 |   12 ++-
 drivers/media/dvb/b2c2/flexcop-pci.c         |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c  |   46 +++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h      |    1 +
 drivers/mmc/core/core.c                      |   81 +++++++++----
 drivers/mmc/core/host.c                      |    6 +
 drivers/mmc/host/sdhci-pci.c                 |    1 +
 drivers/mmc/host/sdhci.c                     |    9 ++-
 drivers/net/atl1c/atl1c_main.c               |    2 -
 drivers/net/bnx2x_main.c                     |   27 +++--
 drivers/net/bonding/bond_3ad.c               |    4 +
 drivers/net/bonding/bond_alb.c               |    4 +
 drivers/net/bonding/bond_main.c              |    4 +
 drivers/net/cxgb3/common.h                   |    8 +-
 drivers/net/cxgb3/cxgb3_main.c               |   25 +++--
 drivers/net/e1000/e1000_main.c               |  162 +++++++++++++++-----------
 drivers/net/e1000e/ich8lan.c                 |   11 ++
 drivers/net/igbvf/igbvf.h                    |    1 -
 drivers/net/ipg.c                            |    4 +-
 drivers/net/myri10ge/myri10ge.c              |    4 +
 drivers/net/netx-eth.c                       |    3 +
 drivers/net/netxen/netxen_nic.h              |    6 +
 drivers/net/netxen/netxen_nic_init.c         |    6 +-
 drivers/net/netxen/netxen_nic_main.c         |    4 +
 drivers/net/niu.c                            |   17 +--
 drivers/net/pcmcia/pcnet_cs.c                |    7 +
 drivers/net/pppol2tp.c                       |    3 +
 drivers/net/spider_net.c                     |    1 +
 drivers/net/tehuti.c                         |    4 +-
 drivers/net/tokenring/tms380tr.c             |    2 +
 drivers/net/tulip/tulip_core.c               |    1 +
 drivers/net/virtio_net.c                     |   48 +++++---
 drivers/net/wireless/ath/regd_common.h       |    1 +
 drivers/net/wireless/b43/sdio.c              |    3 +
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c        |    8 +-
 drivers/net/wireless/p54/txrx.c              |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c      |    3 +-
 drivers/net/wireless/rt2x00/rt2500usb.c      |   13 ++-
 drivers/net/wireless/rt2x00/rt2800usb.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h         |    7 +
 drivers/net/wireless/rt2x00/rt2x00dev.c      |   15 +++
 drivers/net/wireless/rt2x00/rt2x00queue.c    |    6 +-
 drivers/net/wireless/rt2x00/rt61pci.c        |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c        |    2 +-
 drivers/pci/intel-iommu.c                    |   23 +++-
 drivers/platform/x86/dell-laptop.c           |   15 +++
 drivers/s390/block/dasd_eckd.c               |    2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c    |    8 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c           |   23 ++++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    4 +-
 drivers/scsi/pmcraid.c                       |    3 +
 drivers/scsi/scsi_sysfs.c                    |   16 ++--
 drivers/serial/imx.c                         |    3 +-
 drivers/staging/rtl8192su/r8192S_firmware.c  |    5 +
 drivers/staging/rtl8192su/r8192U_core.c      |  120 ++++++++++++++-----
 drivers/staging/rtl8192su/r819xU_cmdpkt.c    |    6 +
 drivers/staging/usbip/vhci_hcd.c             |    2 +-
 drivers/usb/core/devices.c                   |   10 +-
 drivers/usb/core/hub.c                       |   15 ++-
 drivers/usb/musb/musb_core.c                 |    1 +
 drivers/video/backlight/mbp_nvidia_bl.c      |   18 +++
 fs/btrfs/volumes.c                           |    4 +
 fs/cifs/inode.c                              |   12 +-
 fs/gfs2/quota.c                              |  132 +++++++++++----------
 fs/nfs/inode.c                               |   26 +++--
 fs/nfs/nfs4proc.c                            |   43 +++++++-
 fs/nfs/nfs4state.c                           |    4 +-
 fs/nfs/super.c                               |    9 ++
 fs/nfsd/vfs.c                                |    9 ++-
 fs/partitions/ldm.c                          |   16 ++-
 fs/partitions/osf.c                          |   12 ++-
 fs/ubifs/recovery.c                          |   26 ++++
 include/linux/mmc/host.h                     |    3 +
 include/net/af_unix.h                        |    2 +
 include/net/mac80211.h                       |    6 +
 init/Kconfig                                 |    1 +
 init/main.c                                  |   12 ++
 net/can/bcm.c                                |    7 +-
 net/econet/af_econet.c                       |   62 +++++-----
 net/ipv4/ip_output.c                         |    9 +-
 net/ipv6/addrconf.c                          |    3 -
 net/mac80211/main.c                          |    2 +
 net/phonet/pn_dev.c                          |    3 +
 net/sunrpc/xprtsock.c                        |   28 ++++-
 net/unix/af_unix.c                           |   53 ++++++++-
 net/unix/garbage.c                           |    9 ++-
 scripts/kconfig/conf.c                       |    2 +-
 sound/pci/hda/patch_cirrus.c                 |   44 +++++++-
 sound/ppc/tumbler.c                          |    9 ++-
 sound/soc/codecs/wm_hubs.c                   |    8 +-
 sound/synth/emux/emux_hwdep.c                |    3 +
 tools/perf/Makefile                          |   75 ++++++++----
 122 files changed, 1542 insertions(+), 522 deletions(-)
