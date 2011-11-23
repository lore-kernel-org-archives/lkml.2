Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1KWA0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:26:12 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43494 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757996Ab1KWA0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:26:07 -0500
X-Sasl-enc: deczigLArNdCKlYXZlZb4o6v/7f35Y3JgFreCIHpc/Zp 1322007966
Date: Tue, 22 Nov 2011 16:24:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/53] 3.0.11-stable review
Message-ID: <20111123002419.GA8531@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.11 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, November 25, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.11-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                    |    4 +-
 arch/arm/kernel/head.S                      |    2 +-
 drivers/base/core.c                         |    3 +
 drivers/base/node.c                         |   14 +++---
 drivers/gpu/drm/i915/i915_drv.h             |    1 +
 drivers/gpu/drm/i915/i915_reg.h             |    9 ++++
 drivers/gpu/drm/i915/i915_suspend.c         |    2 +
 drivers/gpu/drm/i915/intel_display.c        |   42 +++++++++++++++--
 drivers/media/video/saa7164/saa7164-cards.c |   66 +++++++++++++++++++++++++++
 drivers/media/video/saa7164/saa7164-dvb.c   |    1 +
 drivers/media/video/saa7164/saa7164.h       |    1 +
 drivers/misc/Kconfig                        |   15 +++---
 drivers/misc/pch_phub.c                     |   22 +++++++++-
 drivers/misc/spear13xx_pcie_gadget.c        |    2 +-
 drivers/net/wireless/libertas/if_spi.c      |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h        |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c     |   22 ++++++++-
 drivers/scsi/aacraid/linit.c                |    4 ++
 drivers/scsi/hpsa.c                         |    5 ++
 drivers/scsi/scsi_scan.c                    |    6 +--
 drivers/tty/hvc/hvc_dcc.c                   |    2 +
 drivers/tty/serial/Kconfig                  |   14 +++---
 drivers/tty/serial/pch_uart.c               |   13 +++++-
 drivers/tty/tty_ldisc.c                     |   30 +++++++++---
 drivers/usb/class/cdc-acm.c                 |    8 ++-
 drivers/usb/core/hub.c                      |    6 +++
 drivers/usb/core/quirks.c                   |   27 +++++++++++
 drivers/usb/host/ehci-sched.c               |   15 ++++--
 drivers/usb/host/pci-quirks.c               |    7 +--
 drivers/usb/host/xhci-mem.c                 |    5 --
 drivers/usb/host/xhci-ring.c                |   13 +++---
 drivers/usb/host/xhci.c                     |   34 +++++++-------
 drivers/usb/serial/ark3116.c                |   10 ++--
 drivers/usb/serial/ftdi_sio.c               |   14 +++++-
 drivers/usb/serial/option.c                 |   23 +++++++++
 drivers/usb/serial/pl2303.c                 |    1 -
 drivers/usb/serial/pl2303.h                 |    4 --
 drivers/usb/storage/protocol.c              |    7 +--
 fs/nfs/dir.c                                |    2 +-
 fs/nfs/file.c                               |   32 +++++++++++++
 fs/nfs/inode.c                              |    2 +-
 fs/nfs/nfs3proc.c                           |    1 +
 fs/nfs/nfs4proc.c                           |    1 +
 fs/nfs/proc.c                               |    1 +
 fs/xfs/linux-2.6/xfs_buf.h                  |    1 -
 fs/xfs/linux-2.6/xfs_file.c                 |   34 +++++++++++---
 fs/xfs/linux-2.6/xfs_iops.c                 |   16 +++++--
 fs/xfs/linux-2.6/xfs_super.c                |   34 ++++----------
 fs/xfs/quota/xfs_qm.c                       |    3 +-
 fs/xfs/xfs_buf_item.c                       |    1 -
 fs/xfs/xfs_mount.c                          |   29 ++++--------
 fs/xfs/xfs_vnodeops.c                       |   14 ++++--
 include/linux/nfs_fs.h                      |    3 +
 include/linux/nfs_xdr.h                     |    1 +
 kernel/irq/spurious.c                       |    2 +-
 net/ipv6/ip6_tunnel.c                       |    8 +++-
 net/mac80211/rx.c                           |    9 +++-
 net/mac80211/util.c                         |    4 ++
 net/wireless/nl80211.c                      |    3 +-
 net/wireless/reg.c                          |    3 +
 60 files changed, 488 insertions(+), 172 deletions(-)
