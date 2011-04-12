Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1DLOhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:37:35 -0400
Received: from kroah.org ([198.145.64.141]:57363 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803Ab1DLOhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:31 -0400
Date: Tue, 12 Apr 2011 07:36:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/105] 2.6.38.3-stable review
Message-ID: <20110412143613.GA19478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.38.3 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, April 14, 2011, 15:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.38.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                  |    2 +-
 arch/powerpc/kernel/time.c                |    2 +-
 arch/x86/crypto/aesni-intel_asm.S         |    5 +-
 arch/x86/crypto/aesni-intel_glue.c        |   14 ++++-
 arch/x86/kernel/cpu/mtrr/main.c           |   20 +++++--
 arch/x86/kernel/head64.c                  |    3 +
 arch/x86/kernel/setup.c                   |    5 --
 arch/x86/mm/init.c                        |   28 +++++++--
 arch/x86/mm/init_64.c                     |   74 ++++++++++--------------
 drivers/acpi/pci_root.c                   |    2 +-
 drivers/atm/solos-pci.c                   |   35 +++--------
 drivers/block/cciss.h                     |    1 +
 drivers/bluetooth/btusb.c                 |    3 +
 drivers/char/tpm/tpm.c                    |    2 +-
 drivers/edac/amd64_edac.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c  |   13 ++--
 drivers/hid/hid-magicmouse.c              |    2 +
 drivers/input/mouse/synaptics.c           |    4 +-
 drivers/leds/leds-lp5521.c                |   14 ++--
 drivers/leds/leds-lp5523.c                |   20 +++---
 drivers/media/radio/Kconfig               |    1 +
 drivers/media/video/tlg2300/pd-video.c    |    4 +-
 drivers/mfd/ab3100-core.c                 |    4 +-
 drivers/mfd/ab3550-core.c                 |    6 +-
 drivers/mfd/ab8500-debugfs.c              |    6 +-
 drivers/misc/ep93xx_pwm.c                 |    6 +-
 drivers/net/myri10ge/myri10ge.c           |    1 +
 drivers/net/netxen/netxen_nic_ethtool.c   |    2 +-
 drivers/net/qlcnic/qlcnic_ethtool.c       |    2 +-
 drivers/net/s2io.c                        |    2 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c     |    4 +-
 drivers/net/vxge/vxge-ethtool.c           |    4 +-
 drivers/net/wireless/ath/ath9k/main.c     |    4 +
 drivers/net/wireless/ath/ath9k/xmit.c     |    4 +-
 drivers/net/wireless/b43/dma.c            |    2 +-
 drivers/net/wireless/b43/dma.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 +-
 drivers/net/wireless/p54/p54usb.c         |    2 +
 drivers/net/wireless/rt2x00/rt2800lib.c   |    6 --
 drivers/net/wireless/rt2x00/rt2800pci.c   |   36 +++--------
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    6 +-
 drivers/net/wireless/wl12xx/testmode.c    |    5 +-
 drivers/pci/pcie/aspm.c                   |    7 ++
 drivers/platform/x86/acer-wmi.c           |   19 +++++--
 drivers/rtc/rtc-ds1511.c                  |    2 +-
 drivers/scsi/scsi_transport_iscsi.c       |    2 +-
 drivers/scsi/ses.c                        |    4 +-
 drivers/staging/hv/channel.c              |    8 +-
 drivers/staging/hv/connection.c           |    4 +-
 drivers/staging/hv/netvsc_drv.c           |   24 ++++++++
 drivers/staging/hv/vmbus_drv.c            |    2 +-
 drivers/staging/hv/vmbus_private.h        |    1 +
 drivers/staging/iio/imu/adis16400.h       |    3 +-
 drivers/staging/iio/imu/adis16400_core.c  |   12 ++--
 drivers/staging/iio/imu/adis16400_ring.c  |   12 ++--
 drivers/staging/usbip/stub_rx.c           |   40 +++++--------
 drivers/staging/usbip/stub_tx.c           |   74 +++++++++++++++++++-----
 drivers/staging/usbip/usbip_common.c      |   64 ++++++++++++++++++++-
 drivers/staging/usbip/usbip_common.h      |    2 +
 drivers/staging/usbip/vhci_rx.c           |    3 +
 drivers/watchdog/davinci_wdt.c            |   22 +++----
 drivers/watchdog/max63xx_wdt.c            |   20 +++----
 drivers/watchdog/pnx4008_wdt.c            |   28 ++++-----
 drivers/watchdog/s3c2410_wdt.c            |   19 +++----
 drivers/watchdog/sp5100_tco.c             |   16 +++++-
 fs/btrfs/ctree.h                          |    4 +
 fs/btrfs/disk-io.c                        |    4 +-
 fs/btrfs/ioctl.c                          |    4 +
 fs/btrfs/root-tree.c                      |   18 ++++++
 fs/btrfs/transaction.c                    |    1 +
 fs/ecryptfs/keystore.c                    |    1 +
 fs/ecryptfs/mmap.c                        |    5 ++
 fs/ext4/inode.c                           |   11 ++--
 fs/ext4/super.c                           |    6 ++
 fs/nfsd/lockd.c                           |    1 -
 fs/nfsd/nfs4state.c                       |    9 ++-
 fs/nilfs2/file.c                          |   11 ++--
 fs/notify/inotify/inotify_fsnotify.c      |    1 +
 fs/notify/inotify/inotify_user.c          |   39 ++++--------
 fs/ocfs2/aops.c                           |    6 ++
 fs/quota/dquot.c                          |   13 +---
 fs/squashfs/dir.c                         |    9 +++
 fs/squashfs/namei.c                       |   12 ++++
 fs/squashfs/zlib_wrapper.c                |    6 +-
 fs/ubifs/commit.c                         |    2 +-
 fs/ubifs/debug.c                          |   41 ++++++++++++--
 fs/ubifs/lpt.c                            |    7 +-
 fs/xfs/linux-2.6/xfs_super.c              |   34 ++++++++---
 include/drm/drm_pciids.h                  |    2 +
 include/linux/atmdev.h                    |    1 +
 include/linux/ethtool.h                   |    1 +
 include/linux/pci.h                       |    7 +-
 include/scsi/scsi_device.h                |    2 +-
 include/sound/pcm.h                       |    4 +-
 include/sound/soc-dapm.h                  |   16 +++---
 kernel/perf_event.c                       |    8 ++-
 kernel/signal.c                           |    4 +-
 mm/mremap.c                               |   11 +++-
 net/atm/common.c                          |    1 +
 net/bluetooth/bnep/sock.c                 |    1 +
 net/bluetooth/sco.c                       |    1 +
 net/bridge/netfilter/ebtables.c           |    2 +
 net/core/ethtool.c                        |   17 +++++-
 net/econet/af_econet.c                    |    2 +-
 net/ipv4/netfilter/arp_tables.c           |    3 +
 net/ipv4/netfilter/ip_tables.c            |    7 ++-
 net/ipv4/netfilter/ipt_CLUSTERIP.c        |    5 +-
 net/ipv6/netfilter/ip6_tables.c           |    7 ++-
 net/irda/iriap.c                          |    6 ++
 net/irda/irnet/irnet_ppp.c                |    3 +
 net/mac80211/rc80211_minstrel_ht.c        |   25 ++++++--
 net/mac80211/sta_info.c                   |    1 +
 net/netfilter/nf_conntrack_h323_asn1.c    |    2 +-
 net/rose/rose_subr.c                      |   18 +++++-
 net/sunrpc/auth_gss/gss_krb5_mech.c       |    2 +-
 sound/core/init.c                         |    4 +
 sound/core/pcm_lib.c                      |    4 +-
 sound/core/pcm_native.c                   |    9 ---
 sound/oss/dev_table.h                     |    2 +-
 sound/oss/midi_synth.c                    |   30 ++++------
 sound/oss/midi_synth.h                    |    2 +-
 sound/oss/opl3.c                          |   23 +++++---
 sound/oss/sequencer.c                     |    2 +-
 sound/pci/ens1370.c                       |   23 ++++++-
 sound/pci/hda/patch_analog.c              |   89 +++++++++++++++++++++++++++++
 sound/pci/hda/patch_conexant.c            |    2 +
 sound/pci/hda/patch_hdmi.c                |   70 ++++++++++++++--------
 sound/pci/hda/patch_realtek.c             |    4 +-
 sound/soc/imx/imx-pcm-dma-mx2.c           |    9 ++-
 sound/soc/imx/imx-ssi.h                   |    3 -
 sound/soc/pxa/corgi.c                     |    2 +-
 131 files changed, 943 insertions(+), 489 deletions(-)
