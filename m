Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435Ab1LPTs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:48:27 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35908 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759793Ab1LPTsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:07 -0500
X-Sasl-enc: AOLMxlFHbVW4Jm2rG5P88UwY4SM7Tt133m3pOZYBoJ3a 1324064885
Date: Fri, 16 Dec 2011 11:46:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/45] 3.0.14-stable review
Message-ID: <20111216194603.GA15028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.14 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by December 19, 2011, 18:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.14-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                    |    4 +-
 arch/arm/mach-at91/at91sam9260.c            |    6 +-
 arch/arm/mach-davinci/board-da850-evm.c     |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c    |    6 +-
 arch/arm/mach-mxs/include/mach/mxs.h        |    1 +
 arch/x86/kernel/hpet.c                      |   21 +++++---
 arch/x86/mm/gup.c                           |    2 +
 arch/x86/xen/setup.c                        |   18 ++++++-
 drivers/firmware/iscsi_ibft.c               |   42 +++++++++++++++-
 drivers/firmware/iscsi_ibft_find.c          |   26 +---------
 drivers/hwmon/coretemp.c                    |    2 +
 drivers/hwmon/jz4740-hwmon.c                |    2 +-
 drivers/md/raid5.c                          |    2 +-
 drivers/mmc/host/mxcmmc.c                   |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   36 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   18 +------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/pci/intel-iommu.c                   |   40 +++++++++------
 drivers/ptp/ptp_clock.c                     |    4 +-
 drivers/staging/rtl8712/usb_intf.c          |    1 +
 drivers/target/target_core_transport.c      |    9 +++-
 drivers/usb/class/cdc-acm.c                 |   10 ++++
 drivers/usb/serial/option.c                 |    7 ++-
 fs/dcache.c                                 |   71 ++++++++++++++++----------
 fs/ext4/inode.c                             |    9 ++-
 fs/ext4/page-io.c                           |   12 +++++
 fs/ext4/super.c                             |   17 +++---
 fs/fuse/dev.c                               |    3 +-
 fs/hfs/btree.c                              |   20 ++++++--
 fs/jbd/journal.c                            |    8 +++
 fs/jbd2/journal.c                           |    8 +++
 fs/namespace.c                              |   20 ++++---
 fs/proc/meminfo.c                           |    7 ++-
 fs/seq_file.c                               |    6 +-
 fs/xfs/linux-2.6/xfs_export.c               |    8 ++--
 fs/xfs/xfs_attr.c                           |   14 +----
 fs/xfs/xfs_bmap.c                           |   10 +---
 fs/xfs/xfs_inode.c                          |    8 ---
 include/drm/drm_pciids.h                    |   10 ++++
 include/linux/dcache.h                      |    3 +-
 include/linux/fs.h                          |    1 +
 include/linux/log2.h                        |    1 -
 kernel/taskstats.c                          |    1 +
 kernel/time/alarmtimer.c                    |    2 +-
 mm/hugetlb.c                                |    1 +
 mm/page_alloc.c                             |   10 +++-
 mm/percpu-vm.c                              |   12 ++--
 mm/percpu.c                                 |   34 ++++++++-----
 mm/vmalloc.c                                |    2 +
 net/mac80211/agg-tx.c                       |   17 ++++++-
 security/apparmor/path.c                    |   65 ++++++++++++++----------
 security/tomoyo/realpath.c                  |    9 ++-
 sound/pci/hda/patch_realtek.c               |    2 +
 sound/pci/sis7019.c                         |   64 ++++++++++++++++++++----
 sound/soc/soc-utils.c                       |   31 +++++++++++-
 55 files changed, 492 insertions(+), 256 deletions(-)
