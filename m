Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab2FGEOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:14:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2FGEOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:14:12 -0400
Date: Thu, 7 Jun 2012 13:14:06 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/82] 3.4.2-stable review
Message-ID: <20120607041406.GA13233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.2 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun  9 04:03:32 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                          |   4 +-
 arch/arm/Kconfig                                  |   2 +-
 arch/arm/mach-ixp4xx/common.c                     |  48 +++++++++-
 arch/arm/mach-ixp4xx/include/mach/gpio.h          |  79 +---------------
 arch/microblaze/Kconfig                           |   2 +-
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h |   1 +
 arch/parisc/kernel/entry.S                        |  30 +++---
 arch/parisc/kernel/vmlinux.lds.S                  |   6 +-
 arch/x86/include/asm/pgtable-3level.h             |  50 ++++++++++
 arch/x86/kernel/nmi.c                             |   6 +-
 arch/x86/kernel/ptrace.c                          |   6 --
 arch/x86/xen/enlighten.c                          |   3 +
 drivers/acpi/battery.c                            |  10 +-
 drivers/atm/solos-pci.c                           |   4 +-
 drivers/gpu/drm/i915/intel_display.c              |   2 +-
 drivers/gpu/drm/i915/intel_dp.c                   |  17 ++--
 drivers/gpu/drm/i915/intel_lvds.c                 |   8 ++
 drivers/gpu/drm/i915/intel_sdvo.c                 |  12 ++-
 drivers/gpu/drm/i915/intel_sdvo_regs.h            |   5 +
 drivers/gpu/drm/i915/intel_tv.c                   |  53 +++++++++++
 drivers/gpu/drm/radeon/evergreen.c                |  18 +++-
 drivers/gpu/drm/radeon/evergreend.h               |   1 +
 drivers/gpu/drm/radeon/ni.c                       |  32 +++++--
 drivers/gpu/drm/radeon/r600_audio.c               |   5 +-
 drivers/gpu/drm/radeon/radeon_atombios.c          |   4 +-
 drivers/gpu/drm/radeon/radeon_cs.c                |  31 ++++---
 drivers/gpu/drm/radeon/radeon_gart.c              |  19 ++--
 drivers/gpu/drm/radeon/rv770.c                    |  10 +-
 drivers/gpu/drm/radeon/rv770d.h                   |   1 +
 drivers/gpu/drm/ttm/ttm_bo.c                      |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c               |   2 +-
 drivers/iommu/amd_iommu.c                         | 108 ++++++++++++++--------
 drivers/iommu/amd_iommu_init.c                    |  13 +--
 drivers/iommu/amd_iommu_types.h                   |   3 +
 drivers/md/raid1.c                                |   4 +
 drivers/md/raid10.c                               |   5 +-
 drivers/mtd/Kconfig                               |   2 +-
 drivers/mtd/devices/block2mtd.c                   |   1 -
 drivers/mtd/nand/mxc_nand.c                       |  12 +--
 drivers/mtd/nand/nand_bbt.c                       |   1 +
 drivers/net/ethernet/freescale/fec_mpc52xx.c      |   2 +-
 drivers/net/usb/asix.c                            |   3 +-
 drivers/net/wireless/ath/ath9k/xmit.c             |  16 ++--
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |   1 +
 drivers/net/wireless/wl1251/sdio.c                |   2 +-
 drivers/net/wireless/wl1251/spi.c                 |   3 +-
 drivers/scsi/scsi_lib.c                           |  11 ++-
 drivers/scsi/scsi_wait_scan.c                     |   2 +-
 fs/attr.c                                         |   5 +
 fs/cifs/cifsglob.h                                |   1 +
 fs/cifs/cifsproto.h                               |   6 +-
 fs/cifs/cifssmb.c                                 |  12 +--
 fs/cifs/file.c                                    |  57 +++++++-----
 fs/cifs/readdir.c                                 |  15 ++-
 fs/exofs/super.c                                  |   2 +-
 fs/ext4/ialloc.c                                  |  10 +-
 fs/ext4/ioctl.c                                   |  12 ++-
 fs/ext4/mballoc.c                                 |   6 +-
 fs/ext4/namei.c                                   |   6 ++
 fs/ext4/resize.c                                  |   2 +
 fs/ext4/super.c                                   |   4 +-
 fs/namespace.c                                    |   3 +-
 fs/nfs/idmap.c                                    |  10 +-
 fs/nfs/nfs4proc.c                                 |   2 +
 fs/proc/base.c                                    |  17 ++--
 fs/proc/task_mmu.c                                |   2 +-
 include/asm-generic/pgtable.h                     |  22 ++++-
 include/drm/drm_pciids.h                          |  17 +++-
 include/linux/Kbuild                              |   1 +
 include/linux/kernel-page-flags.h                 |   4 +
 include/linux/radix-tree.h                        |   5 +-
 include/linux/skbuff.h                            |   2 -
 include/net/dst.h                                 |   1 +
 kernel/fork.c                                     |   3 +-
 lib/radix-tree.c                                  |   3 +
 mm/hugetlb.c                                      |  29 ++++--
 mm/slub.c                                         |   9 +-
 mm/vmalloc.c                                      |   3 +-
 mm/vmscan.c                                       |   2 +-
 net/ipv4/esp4.c                                   |  24 ++---
 net/ipv4/fib_semantics.c                          |  12 +--
 net/ipv6/esp6.c                                   |  18 ++--
 net/ipv6/ip6_output.c                             |  68 ++++++++++----
 net/l2tp/l2tp_ip.c                                |  30 ++++--
 net/mac80211/util.c                               |  12 +--
 net/sunrpc/clnt.c                                 |   2 +
 net/sunrpc/xprt.c                                 |   5 +-
 net/xfrm/xfrm_policy.c                            |   3 +
 sound/usb/pcm.c                                   |   3 +
 tools/vm/page-types.c                             |  28 +-----
 92 files changed, 739 insertions(+), 410 deletions(-)

