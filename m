Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1B1QgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:36:14 -0500
Received: from kroah.org ([198.145.64.141]:41141 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1B1QgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:36:13 -0500
Date: Mon, 28 Feb 2011 08:35:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/68] 2.6.32.30-longterm review
Message-ID: <20110228163502.GA27221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.30 release.
There are 68 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wed, March 2, 16:00:00, 2010, UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.30-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                   |    2 +-
 arch/arm/kernel/signal.c                   |    4 +-
 arch/s390/include/asm/processor.h          |    5 -
 arch/s390/kernel/traps.c                   |   37 ----
 arch/x86/include/asm/acpi.h                |    1 +
 arch/x86/include/asm/pvclock.h             |    1 +
 arch/x86/kernel/acpi/boot.c                |   14 +-
 arch/x86/kernel/early-quirks.c             |   16 +-
 arch/x86/kernel/hpet.c                     |   12 +-
 arch/x86/kernel/pvclock.c                  |    5 +
 arch/x86/xen/time.c                        |    2 +
 drivers/block/pktcdvd.c                    |    2 +-
 drivers/isdn/hisax/config.c                |   18 ++-
 drivers/isdn/hisax/hisax.h                 |    1 +
 drivers/md/dm-raid1.c                      |    2 +-
 drivers/md/dm-region-hash.c                |    5 +-
 drivers/md/md.c                            |    3 +
 drivers/media/dvb/ttpci/av7110_ca.c        |    2 +-
 drivers/media/radio/radio-aimslab.c        |    1 +
 drivers/message/fusion/mptctl.c            |    8 +
 drivers/message/fusion/mptscsih.c          |    7 +-
 drivers/net/benet/be.h                     |    2 +
 drivers/net/benet/be_main.c                |   18 +-
 drivers/net/bonding/bond_ipv6.c            |    9 +-
 drivers/net/ixgbe/ixgbe_82599.c            |    1 +
 drivers/net/ixgbe/ixgbe_main.c             |    3 +
 drivers/net/ixgbe/ixgbe_type.h             |    1 +
 drivers/net/wireless/p54/p54pci.c          |   14 +-
 drivers/platform/x86/acer-wmi.c            |    4 +-
 drivers/platform/x86/asus_acpi.c           |    8 +-
 drivers/platform/x86/tc1100-wmi.c          |    2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +
 drivers/staging/usbip/vhci.h               |    6 +-
 drivers/staging/usbip/vhci_hcd.c           |   54 +++++-
 drivers/staging/usbip/vhci_rx.c            |   15 +-
 drivers/usb/core/hcd-pci.c                 |    4 +-
 drivers/usb/core/quirks.c                  |    8 +
 drivers/usb/host/ohci-hcd.c                |    9 +-
 drivers/usb/host/ohci-pci.c                |   18 ++
 drivers/usb/host/ohci.h                    |    1 +
 drivers/usb/host/pci-quirks.c              |   18 +-
 drivers/usb/host/xhci-ring.c               |   36 ++--
 drivers/usb/musb/omap2430.c                |    1 +
 drivers/usb/serial/sierra.c                |    3 +
 drivers/usb/serial/visor.c                 |   12 ++
 fs/ecryptfs/inode.c                        |    2 +
 fs/eventpoll.c                             |   95 +++++++++
 fs/file_table.c                            |    2 +-
 fs/gfs2/bmap.c                             |    2 +-
 fs/nfs/file.c                              |    2 +-
 fs/nfsd/nfs4xdr.c                          |    8 +-
 fs/nfsd/vfs.c                              |    2 +-
 fs/ocfs2/stack_user.c                      |    2 +-
 fs/partitions/ldm.c                        |    5 +
 fs/partitions/mac.c                        |   17 +-
 fs/proc/array.c                            |    5 +-
 fs/read_write.c                            |    2 -
 fs/splice.c                                |   24 ++-
 fs/xfs/linux-2.6/xfs_export.c              |   11 +-
 fs/xfs/linux-2.6/xfs_ioctl.c               |    7 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c             |   15 +-
 fs/xfs/quota/xfs_qm.c                      |   18 +-
 fs/xfs/quota/xfs_qm_syscalls.c             |   27 ++--
 fs/xfs/xfs_ialloc.c                        |  150 +++++++++------
 fs/xfs/xfs_iget.c                          |   10 +-
 fs/xfs/xfs_inode.c                         |    5 +-
 fs/xfs/xfs_inode.h                         |    6 +-
 fs/xfs/xfs_itable.c                        |  284 ++++------------------------
 fs/xfs/xfs_itable.h                        |   17 --
 fs/xfs/xfs_log_recover.c                   |    2 +-
 fs/xfs/xfs_mount.c                         |    2 +-
 fs/xfs/xfs_rtalloc.c                       |    4 +-
 fs/xfs/xfs_trans_inode.c                   |    2 +-
 fs/xfs/xfs_vnodeops.c                      |    2 +-
 include/linux/cred.h                       |   21 +--
 kernel/cred.c                              |   41 ++++-
 kernel/irq/manage.c                        |    2 +-
 kernel/power/snapshot.c                    |    7 +-
 net/core/filter.c                          |   64 ++++---
 net/ipv4/tcp.c                             |    2 +-
 net/sctp/auth.c                            |    8 +-
 net/sunrpc/cache.c                         |    4 +-
 net/x25/x25_link.c                         |    1 +
 security/selinux/hooks.c                   |    6 +-
 sound/pci/hda/hda_intel.c                  |    1 +
 sound/usb/caiaq/audio.c                    |    2 +-
 sound/usb/caiaq/midi.c                     |    2 +-
 87 files changed, 662 insertions(+), 626 deletions(-)
