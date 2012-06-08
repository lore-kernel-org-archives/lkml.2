Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab2FHFGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:06:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43111 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab2FHFGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:06:44 -0400
Message-Id: <20120608041840.861504477@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/82] 3.2.20-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.20 release.
There are 82 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Jun 10 13:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.19 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 Makefile                                          |    4 +-
 arch/arm/Kconfig                                  |    2 +-
 arch/arm/mach-ixp4xx/common.c                     |   48 ++++++++++++-
 arch/arm/mach-ixp4xx/include/mach/gpio.h          |   79 +--------------------
 arch/microblaze/Kconfig                           |    2 +-
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h |    1 +
 arch/parisc/kernel/entry.S                        |   30 ++++----
 arch/parisc/kernel/vmlinux.lds.S                  |    6 +-
 arch/x86/xen/enlighten.c                          |    3 +
 drivers/acpi/battery.c                            |   10 ++-
 drivers/atm/solos-pci.c                           |    4 +-
 drivers/bluetooth/ath3k.c                         |   10 +++
 drivers/bluetooth/btusb.c                         |   14 +++-
 drivers/gpu/drm/i915/i915_reg.h                   |    6 +-
 drivers/gpu/drm/i915/intel_display.c              |    4 +-
 drivers/gpu/drm/i915/intel_dp.c                   |   17 +++--
 drivers/gpu/drm/i915/intel_lvds.c                 |   32 +++++++++
 drivers/gpu/drm/i915/intel_sdvo.c                 |   12 ++--
 drivers/gpu/drm/i915/intel_sdvo_regs.h            |    5 ++
 drivers/gpu/drm/i915/intel_tv.c                   |    5 ++
 drivers/gpu/drm/radeon/evergreen.c                |   18 +++--
 drivers/gpu/drm/radeon/evergreend.h               |    1 +
 drivers/gpu/drm/radeon/ni.c                       |    6 +-
 drivers/gpu/drm/radeon/radeon_atombios.c          |    4 +-
 drivers/gpu/drm/radeon/rv770.c                    |   10 ++-
 drivers/gpu/drm/radeon/rv770d.h                   |    1 +
 drivers/gpu/drm/ttm/ttm_bo.c                      |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c               |    2 +-
 drivers/iommu/amd_iommu.c                         |   29 ++++++--
 drivers/iommu/amd_iommu_init.c                    |   13 ++--
 drivers/iommu/amd_iommu_types.h                   |    3 +
 drivers/mtd/Kconfig                               |    2 +-
 drivers/mtd/nand/nand_bbt.c                       |    1 +
 drivers/net/ethernet/freescale/fec_mpc52xx.c      |    2 +-
 drivers/net/ethernet/realtek/r8169.c              |   39 +++++++---
 drivers/net/macvlan.c                             |    2 +-
 drivers/net/usb/asix.c                            |    3 +-
 drivers/net/wireless/ath/ath9k/xmit.c             |   16 +++--
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    1 +
 drivers/net/wireless/wl1251/sdio.c                |    2 +-
 drivers/net/wireless/wl1251/spi.c                 |    3 +-
 drivers/scsi/scsi_lib.c                           |   11 +--
 drivers/scsi/scsi_wait_scan.c                     |    2 +-
 drivers/target/target_core_file.c                 |   78 +++++---------------
 drivers/target/target_core_file.h                 |    1 -
 fs/attr.c                                         |    5 ++
 fs/cifs/cifsglob.h                                |    1 +
 fs/cifs/cifsproto.h                               |    6 +-
 fs/cifs/cifssmb.c                                 |   12 ++--
 fs/cifs/file.c                                    |   57 ++++++++-------
 fs/cifs/readdir.c                                 |   15 +++-
 fs/exofs/super.c                                  |    2 +-
 fs/ext4/mballoc.c                                 |    6 +-
 fs/ext4/namei.c                                   |    6 ++
 fs/ext4/super.c                                   |    4 +-
 fs/namespace.c                                    |    3 +-
 fs/nfs/nfs4proc.c                                 |    2 +
 include/drm/drm_pciids.h                          |    4 ++
 include/linux/Kbuild                              |    1 +
 include/linux/kernel-page-flags.h                 |    4 ++
 include/linux/netdevice.h                         |    9 ---
 include/linux/netfilter_bridge.h                  |    9 +++
 include/linux/skbuff.h                            |    2 -
 include/net/dst.h                                 |    2 +
 include/net/sctp/sctp.h                           |   13 ++++
 kernel/fork.c                                     |    3 +-
 lib/btree.c                                       |    4 +-
 mm/hugetlb.c                                      |   29 ++++++--
 mm/slub.c                                         |    9 ++-
 mm/vmalloc.c                                      |   11 +--
 mm/vmscan.c                                       |    2 +-
 net/8021q/vlan_dev.c                              |    2 +-
 net/bridge/br_forward.c                           |    1 +
 net/bridge/br_netfilter.c                         |    8 +--
 net/core/dev.c                                    |   36 ++--------
 net/ipv4/esp4.c                                   |   24 +++----
 net/ipv4/fib_semantics.c                          |   12 ++--
 net/ipv4/fib_trie.c                               |    2 +
 net/ipv6/esp6.c                                   |   18 ++---
 net/ipv6/ip6_output.c                             |   68 +++++++++++++-----
 net/l2tp/l2tp_ip.c                                |   30 ++++++--
 net/mac80211/util.c                               |   12 ++--
 net/sctp/output.c                                 |    4 +-
 net/sctp/transport.c                              |   17 -----
 net/sunrpc/clnt.c                                 |    2 +
 net/sunrpc/xprt.c                                 |    5 +-
 net/xfrm/xfrm_policy.c                            |    3 +
 sound/usb/pcm.c                                   |    3 +
 90 files changed, 595 insertions(+), 428 deletions(-)

-- 
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

