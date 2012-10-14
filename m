Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2JNOlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45998 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab2JNOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:22 -0400
Message-Id: <20121014143533.742627615@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/147] 3.2.32-stable review
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.32 release.
There are 147 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Oct 16 23:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.31 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 Documentation/virtual/lguest/lguest.c          |    1 +
 Makefile                                       |    4 +-
 arch/arm/plat-omap/counter_32k.c               |   21 +-
 arch/mips/Makefile                             |    2 +-
 arch/mips/kernel/Makefile                      |    2 +-
 arch/mn10300/Makefile                          |    2 +-
 arch/powerpc/platforms/pseries/eeh_driver.c    |   94 ++++++--
 arch/x86/include/asm/pgtable.h                 |   11 +-
 arch/x86/platform/efi/efi.c                    |    1 +
 block/blk-core.c                               |    2 +-
 drivers/acpi/bus.c                             |    8 +-
 drivers/bluetooth/btusb.c                      |    2 +-
 drivers/char/ttyprintk.c                       |    2 +-
 drivers/dma/dmaengine.c                        |    4 +-
 drivers/firewire/core-cdev.c                   |    4 +-
 drivers/firmware/efivars.c                     |   17 +-
 drivers/gpu/drm/i915/i915_gem.c                |   17 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c     |    3 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c         |    4 +-
 drivers/gpu/drm/i915/i915_irq.c                |   24 +-
 drivers/gpu/drm/i915/i915_reg.h                |    7 +
 drivers/gpu/drm/i915/intel_display.c           |   35 ++-
 drivers/gpu/drm/i915/intel_hdmi.c              |   17 +-
 drivers/gpu/drm/radeon/evergreen.c             |  185 +++++++--------
 drivers/gpu/drm/radeon/evergreen_reg.h         |    3 +
 drivers/gpu/drm/radeon/evergreend.h            |    7 +
 drivers/gpu/drm/radeon/radeon_asic.h           |    1 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c        |   10 +
 drivers/gpu/drm/radeon/radeon_pm.c             |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   19 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |    3 +-
 drivers/input/mouse/synaptics.c                |   31 ++-
 drivers/iommu/intel-iommu.c                    |    4 +-
 drivers/media/rc/ite-cir.c                     |    2 +-
 drivers/media/video/gspca/pac7302.c            |    2 +
 drivers/mmc/host/omap_hsmmc.c                  |    4 +-
 drivers/mmc/host/sdhci-s3c.c                   |    2 +-
 drivers/mmc/host/sh_mmcif.c                    |    4 +
 drivers/mtd/maps/autcpu12-nvram.c              |   19 +-
 drivers/mtd/mtdpart.c                          |    5 +-
 drivers/mtd/nand/nand_bbt.c                    |    2 +-
 drivers/mtd/nand/nandsim.c                     |    1 +
 drivers/mtd/nand/omap2.c                       |    3 +-
 drivers/mtd/ubi/build.c                        |    5 +
 drivers/mtd/ubi/scan.c                         |    2 +-
 drivers/net/can/mscan/mpc5xxx_can.c            |    4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c  |    8 +-
 drivers/net/ethernet/realtek/r8169.c           |   21 +-
 drivers/net/rionet.c                           |   20 +-
 drivers/net/wireless/ath/ath9k/pci.c           |    5 +-
 drivers/pci/probe.c                            |    6 +-
 drivers/s390/scsi/zfcp_aux.c                   |    1 +
 drivers/s390/scsi/zfcp_ccw.c                   |   73 +++++-
 drivers/s390/scsi/zfcp_cfdc.c                  |    2 +-
 drivers/s390/scsi/zfcp_dbf.c                   |   22 +-
 drivers/s390/scsi/zfcp_dbf.h                   |    1 +
 drivers/s390/scsi/zfcp_def.h                   |    2 +
 drivers/s390/scsi/zfcp_ext.h                   |    2 +
 drivers/s390/scsi/zfcp_fsf.c                   |   23 +-
 drivers/s390/scsi/zfcp_qdio.c                  |   16 +-
 drivers/s390/scsi/zfcp_sysfs.c                 |   18 +-
 drivers/s390/scsi/zfcp_unit.c                  |   36 ++-
 drivers/scsi/atp870u.c                         |   11 +-
 drivers/scsi/device_handler/scsi_dh_alua.c     |    3 +-
 drivers/scsi/hpsa.c                            |   41 +++-
 drivers/scsi/hpsa.h                            |    2 +
 drivers/scsi/hpsa_cmd.h                        |    1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    3 +
 drivers/scsi/isci/init.c                       |    1 -
 drivers/scsi/isci/probe_roms.c                 |    1 -
 drivers/scsi/scsi_sysfs.c                      |   30 ++-
 drivers/staging/comedi/comedi_fops.c           |    5 +-
 drivers/staging/comedi/drivers/jr3_pci.c       |    2 +-
 drivers/staging/comedi/drivers/s626.c          |    2 +-
 drivers/staging/speakup/speakup_soft.c         |   13 +-
 drivers/target/iscsi/iscsi_target.c            |    2 +-
 drivers/target/iscsi/iscsi_target_core.h       |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |   12 +
 drivers/target/target_core_configfs.c          |    8 +-
 drivers/target/target_core_file.c              |   41 +++-
 drivers/target/target_core_file.h              |    1 +
 drivers/tty/n_gsm.c                            |  104 +++++----
 drivers/tty/n_tty.c                            |    3 +-
 drivers/tty/serial/8250_pci.c                  |    9 +-
 drivers/tty/serial/amba-pl011.c                |   15 +-
 drivers/usb/host/xhci-mem.c                    |    7 +
 drivers/usb/host/xhci-pci.c                    |    1 +
 drivers/usb/host/xhci-ring.c                   |  286 +++++++++++++++++++++++-
 drivers/usb/host/xhci.c                        |   39 +++-
 drivers/usb/host/xhci.h                        |   20 ++
 drivers/usb/serial/ftdi_sio.c                  |    2 +
 drivers/usb/serial/ftdi_sio_ids.h              |    5 +
 drivers/usb/serial/option.c                    |    3 +-
 drivers/usb/serial/qcaux.c                     |   10 +-
 fs/autofs4/root.c                              |    6 +-
 fs/binfmt_elf.c                                |   19 +-
 fs/ecryptfs/ecryptfs_kernel.h                  |    2 +
 fs/ecryptfs/file.c                             |  100 ++++-----
 fs/ecryptfs/inode.c                            |   65 +++---
 fs/ecryptfs/main.c                             |    1 +
 fs/ecryptfs/mmap.c                             |   39 ++--
 fs/ext4/inode.c                                |   25 ++-
 fs/ext4/move_extent.c                          |  174 +++++---------
 fs/ext4/namei.c                                |    2 -
 fs/fs-writeback.c                              |    1 +
 fs/jffs2/wbuf.c                                |    8 +-
 fs/lockd/mon.c                                 |    4 +-
 fs/nfs/blocklayout/blocklayout.c               |  176 ++++++++++++++-
 fs/nfs/blocklayout/blocklayout.h               |    1 +
 fs/udf/super.c                                 |    5 +-
 include/linux/mempolicy.h                      |    2 +-
 include/linux/pci_ids.h                        |    1 -
 include/net/ip_vs.h                            |    2 +-
 kernel/rcutree.c                               |    4 +-
 kernel/sched_stoptask.c                        |   22 +-
 kernel/sys.c                                   |    1 +
 kernel/workqueue.c                             |   27 ++-
 lib/gcd.c                                      |    3 +
 mm/hugetlb.c                                   |    4 +-
 mm/mempolicy.c                                 |  116 ++++++----
 mm/slab.c                                      |    6 +-
 mm/truncate.c                                  |    3 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 +
 net/ipv4/netfilter/nf_nat_sip.c                |   10 +-
 net/netfilter/nf_conntrack_expect.c            |   29 +--
 net/netfilter/xt_hashlimit.c                   |    8 +-
 net/netfilter/xt_limit.c                       |   13 +-
 net/sunrpc/xprtsock.c                          |   21 +-
 scripts/Kbuild.include                         |   14 +-
 scripts/Makefile.fwinst                        |    2 +-
 scripts/gcc-version.sh                         |    6 +-
 scripts/gcc-x86_32-has-stack-protector.sh      |    2 +-
 scripts/gcc-x86_64-has-stack-protector.sh      |    2 +-
 scripts/kconfig/check.sh                       |    2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh     |    2 +-
 scripts/kconfig/streamline_config.pl           |    2 +
 scripts/package/buildtar                       |    2 +-
 sound/drivers/aloop.c                          |    6 +
 sound/pci/hda/patch_conexant.c                 |   94 ++++++--
 tools/hv/hv_kvp_daemon.c                       |    8 +-
 tools/perf/Makefile                            |    2 +-
 tools/power/cpupower/Makefile                  |    2 +-
 143 files changed, 1815 insertions(+), 794 deletions(-)

-- 
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

