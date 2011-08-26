Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1HZVvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:51:50 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42027 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541Ab1HZVvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:51:49 -0400
X-Sasl-enc: giIN3Uq3GpnEfjTA9QWh/x/x+Ar/Ine1aK3c+UtZaEfo 1314395508
Date: Fri, 26 Aug 2011 14:51:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/35] 3.0.4-stable review
Message-ID: <20110826215139.GA11498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.4 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, August 29, 2011, 12:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                   |    4 +-
 arch/x86/include/asm/xen/page.h            |    4 +-
 arch/x86/kernel/apic/x2apic_uv_x.c         |    1 -
 arch/x86/kernel/cpu/intel.c                |   10 +++---
 arch/x86/kernel/cpu/mtrr/main.c            |   23 +++++++++++++++++
 arch/x86/platform/olpc/olpc.c              |    4 +-
 arch/x86/vdso/vdso32/sysenter.S            |    2 +-
 arch/x86/xen/enlighten.c                   |    4 +-
 arch/x86/xen/mmu.c                         |   12 ++++++---
 arch/x86/xen/smp.c                         |    4 +-
 drivers/block/loop.c                       |    6 +++-
 drivers/block/xen-blkfront.c               |    6 ++--
 drivers/edac/i7core_edac.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |   10 +++++++
 drivers/gpu/drm/ttm/ttm_bo.c               |    4 ++-
 drivers/mmc/host/sdhci.c                   |    3 --
 drivers/net/igb/e1000_82575.c              |    1 +
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   17 +++++-------
 fs/befs/linuxvfs.c                         |   23 ++++++++++------
 fs/btrfs/extent-tree.c                     |   12 +++++++-
 fs/btrfs/tree-log.c                        |   28 +++++++++++++++++---
 fs/btrfs/volumes.c                         |   17 ++++++++++++
 fs/btrfs/volumes.h                         |    2 +
 fs/cifs/connect.c                          |    3 +-
 fs/cifs/dir.c                              |    4 +-
 fs/ext4/ext4_jbd2.h                        |    4 +-
 fs/ext4/inode.c                            |   26 +++++++++++++++++-
 fs/ext4/page-io.c                          |    6 +++-
 fs/ext4/super.c                            |    1 -
 fs/fuse/dev.c                              |    4 +++
 fs/nfs/callback.h                          |    2 +-
 fs/nfs/callback_proc.c                     |   25 ++++++++++++++----
 fs/nfs/callback_xdr.c                      |   24 +++++------------
 fs/nfs/objlayout/objio_osd.c               |   28 +++++++++-----------
 fs/nfs/objlayout/pnfs_osd_xdr_cli.c        |    3 ++
 include/linux/personality.h                |    1 +
 include/linux/stop_machine.h               |    2 +
 kernel/irq/generic-chip.c                  |    4 +-
 kernel/stop_machine.c                      |    2 +-
 kernel/sys.c                               |   38 ++++++++++++++++++++++++++++
 sound/pci/ac97/ac97_patch.c                |    1 +
 sound/usb/caiaq/audio.c                    |   31 +++++++++++++++++++---
 sound/usb/caiaq/device.h                   |    1 +
 sound/usb/mixer.c                          |    3 +-
 44 files changed, 298 insertions(+), 114 deletions(-)
