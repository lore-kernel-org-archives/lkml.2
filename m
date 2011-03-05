Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab1CEA65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 19:58:57 -0500
Received: from kroah.org ([198.145.64.141]:50080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab1CEA64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:58:56 -0500
Date: Fri, 4 Mar 2011 16:57:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/73] 2.6.37.3-stable review
Message-ID: <20110305005720.GA16162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.37.3 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Tuesday March 8 2011, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/networking/dns_resolver.txt    |    9 ++-
 Makefile                                     |    2 +-
 arch/x86/include/asm/acpi.h                  |    1 +
 arch/x86/include/asm/smpboot_hooks.h         |    2 +-
 arch/x86/kernel/acpi/boot.c                  |   14 +++-
 arch/x86/kernel/early-quirks.c               |   16 ++---
 block/blk-core.c                             |   18 ++---
 block/blk-flush.c                            |    8 ++-
 block/blk-throttle.c                         |   29 +++++---
 block/cfq-iosched.c                          |    6 +-
 block/elevator.c                             |    4 +-
 block/genhd.c                                |    2 +-
 drivers/acpi/debugfs.c                       |   20 ++++--
 drivers/block/floppy.c                       |    2 +-
 drivers/block/loop.c                         |    5 --
 drivers/bluetooth/ath3k.c                    |    5 ++
 drivers/bluetooth/btusb.c                    |   12 ++-
 drivers/gpu/drm/drm_irq.c                    |    3 +-
 drivers/gpu/drm/i915/i915_dma.c              |   11 +++
 drivers/gpu/drm/radeon/radeon_display.c      |    2 +-
 drivers/md/linear.c                          |    1 -
 drivers/md/md.c                              |   25 +++++++-
 drivers/md/md.h                              |    2 +
 drivers/md/multipath.c                       |    1 -
 drivers/md/raid0.c                           |    1 -
 drivers/md/raid1.c                           |    6 +-
 drivers/md/raid10.c                          |    7 +-
 drivers/md/raid5.c                           |    1 -
 drivers/mfd/tps6586x.c                       |   10 ++--
 drivers/mfd/ucb1x00-ts.c                     |   12 +++-
 drivers/net/e1000e/ich8lan.c                 |   16 +++--
 drivers/net/e1000e/netdev.c                  |    3 +-
 drivers/net/e1000e/phy.c                     |   14 ++++
 drivers/net/r8169.c                          |    6 ++
 drivers/net/tg3.c                            |    8 ++-
 drivers/net/wireless/ath/ath9k/hif_usb.c     |    9 ++-
 drivers/net/wireless/ath/carl9170/usb.c      |    2 +
 drivers/net/wireless/p54/p54pci.c            |   14 +++--
 drivers/net/wireless/p54/p54usb.c            |    1 +
 drivers/rtc/rtc-ds3232.c                     |   14 +++--
 drivers/scsi/scsi_lib.c                      |    2 +-
 drivers/scsi/scsi_transport_fc.c             |    2 +-
 drivers/staging/brcm80211/sys/wl_mac80211.c  |   14 +++-
 drivers/staging/brcm80211/sys/wlc_mac80211.c |   14 ++++-
 drivers/staging/brcm80211/sys/wlc_pub.h      |    2 +
 drivers/staging/comedi/drivers/mite.c        |    2 -
 drivers/staging/comedi/drivers/ni_6527.c     |    4 +
 drivers/staging/comedi/drivers/ni_65xx.c     |    4 +
 drivers/staging/comedi/drivers/ni_660x.c     |    4 +
 drivers/staging/comedi/drivers/ni_670x.c     |    4 +
 drivers/staging/comedi/drivers/ni_pcidio.c   |    4 +
 drivers/staging/comedi/drivers/ni_pcimio.c   |    4 +
 drivers/staging/usbip/vhci.h                 |    6 +-
 drivers/staging/usbip/vhci_hcd.c             |   54 ++++++++++++--
 drivers/staging/usbip/vhci_rx.c              |   15 +++--
 drivers/usb/core/hub.c                       |   23 +++---
 drivers/usb/core/quirks.c                    |    8 ++
 drivers/usb/host/xhci-ring.c                 |   40 ++++++-----
 drivers/usb/musb/musb_core.c                 |    1 +
 drivers/usb/musb/omap2430.c                  |    1 +
 drivers/usb/serial/sierra.c                  |    3 +
 drivers/usb/serial/usb_wwan.c                |   15 +++--
 drivers/usb/serial/visor.c                   |   12 +++
 fs/block_dev.c                               |   12 ++--
 fs/eventpoll.c                               |   95 ++++++++++++++++++++++++++
 fs/ext2/namei.c                              |    9 +--
 fs/fuse/file.c                               |   52 ++++++++++++--
 fs/fuse/fuse_i.h                             |    6 ++-
 fs/gfs2/main.c                               |    9 +--
 fs/inode.c                                   |   31 ++++++--
 fs/internal.h                                |    2 +-
 fs/nilfs2/btnode.c                           |    5 --
 fs/nilfs2/btnode.h                           |    1 -
 fs/nilfs2/mdt.c                              |    4 +-
 fs/nilfs2/page.h                             |    1 -
 fs/nilfs2/segment.c                          |    3 +-
 fs/nilfs2/super.c                            |    2 +-
 fs/ocfs2/refcounttree.c                      |    7 ++-
 fs/ocfs2/super.c                             |   28 ++++++--
 fs/partitions/ldm.c                          |    5 ++
 include/drm/drmP.h                           |    2 +-
 include/linux/blkdev.h                       |    5 +-
 include/linux/fs.h                           |    4 +-
 include/linux/pm.h                           |    2 +
 include/linux/pm_wakeup.h                    |   25 ++++---
 include/linux/vmstat.h                       |   10 ++-
 kernel/time/tick-broadcast.c                 |   10 +++
 kernel/time/tick-common.c                    |    6 ++-
 kernel/time/tick-internal.h                  |    3 +
 lib/swiotlb.c                                |    6 +-
 mm/memory.c                                  |    2 +
 mm/page_alloc.c                              |    5 +-
 mm/vmscan.c                                  |   19 +++++-
 mm/vmstat.c                                  |   36 ++--------
 net/dccp/input.c                             |    7 +-
 net/dns_resolver/dns_key.c                   |   20 +++++-
 net/ipv4/devinet.c                           |   30 ++++++---
 net/ipv4/inet_timewait_sock.c                |    2 +
 net/wireless/wext-compat.c                   |    4 +-
 sound/pci/hda/patch_conexant.c               |    5 ++
 sound/pci/hda/patch_via.c                    |    2 +-
 sound/soc/imx/eukrea-tlv320.c                |    2 +-
 sound/soc/pxa/e740_wm9705.c                  |    4 +-
 sound/soc/pxa/e750_wm9705.c                  |    4 +-
 sound/soc/pxa/e800_wm9712.c                  |    4 +-
 sound/soc/pxa/em-x270.c                      |    4 +-
 sound/soc/pxa/mioa701_wm9713.c               |    4 +-
 sound/soc/pxa/palm27x.c                      |    4 +-
 sound/soc/pxa/tosa.c                         |    4 +-
 sound/soc/pxa/zylonite.c                     |    4 +-
 sound/usb/card.c                             |    4 +
 sound/usb/pcm.c                              |    7 ++-
 sound/usb/usbaudio.h                         |    1 +
 113 files changed, 763 insertions(+), 322 deletions(-)
