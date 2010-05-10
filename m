Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0EJWh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:37:26 -0400
Received: from kroah.org ([198.145.64.141]:53057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab0EJWhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:37:20 -0400
Date: Mon, 10 May 2010 15:37:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/98] 2.6.32.13-stable review
Message-ID: <20100510223714.GA18416@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.13 release.
There are 98 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wed, May 12, 2010, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.13-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/kernel-parameters.txt       |    5 +-
 Makefile                                  |    2 +-
 arch/arm/mach-pxa/include/mach/colibri.h  |    1 +
 arch/mips/include/asm/mach-sibyte/war.h   |    6 +-
 arch/mips/sibyte/sb1250/setup.c           |   15 +++
 arch/parisc/kernel/pci.c                  |    7 +-
 arch/powerpc/mm/fsl_booke_mmu.c           |    5 -
 arch/x86/Kconfig                          |    9 +-
 arch/x86/kernel/acpi/sleep.c              |    2 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 +-
 arch/x86/kernel/cpu/intel.c               |   21 ++++
 arch/x86/kernel/cpu/intel_cacheinfo.c     |   13 +-
 arch/x86/kernel/k8.c                      |   14 +++
 arch/x86/kernel/pci-gart_64.c             |    2 +-
 arch/x86/kernel/process_64.c              |    5 +-
 arch/x86/kvm/x86.c                        |   12 --
 block/blk-timeout.c                       |   12 +-
 crypto/async_tx/async_raid6_recov.c       |   21 ++--
 drivers/Makefile                          |    2 +-
 drivers/acpi/power_meter.c                |    2 +-
 drivers/acpi/sleep.c                      |  173 +++++++++++++++++++++++++++--
 drivers/ata/libata-eh.c                   |    5 +
 drivers/char/agp/Kconfig                  |    2 +-
 drivers/cpuidle/governors/menu.c          |    9 +-
 drivers/edac/edac_mce_amd.c               |    5 +-
 drivers/gpu/drm/i915/i915_gem.c           |    6 +
 drivers/gpu/drm/i915/i915_gem_tiling.c    |   22 ++--
 drivers/gpu/drm/i915/i915_reg.h           |    2 +-
 drivers/i2c/i2c-core.c                    |   26 +++--
 drivers/md/md.c                           |   10 ++-
 drivers/md/raid5.c                        |   54 ++++-----
 drivers/media/dvb/ttpci/budget.c          |    3 -
 drivers/net/bnx2.c                        |    6 +-
 drivers/net/r8169.c                       |   13 ++-
 drivers/net/tg3.c                         |    1 +
 drivers/net/usb/dm9601.c                  |    2 +-
 drivers/net/wireless/p54/p54pci.c         |   10 ++-
 drivers/net/wireless/p54/p54usb.c         |    1 +
 drivers/net/wireless/p54/txrx.c           |    2 +-
 drivers/pci/pci.c                         |    6 +-
 drivers/scsi/libiscsi.c                   |    2 +-
 drivers/scsi/libsas/sas_ata.c             |    4 +
 drivers/scsi/libsas/sas_scsi_host.c       |    4 +
 drivers/scsi/qla2xxx/qla_isr.c            |  120 ++++++++++-----------
 drivers/scsi/scsi_debug.c                 |    3 +-
 drivers/scsi/scsi_error.c                 |   15 +++-
 drivers/scsi/scsi_lib.c                   |   10 ++-
 drivers/scsi/sd.c                         |    1 +
 drivers/serial/8250_pnp.c                 |    2 +
 drivers/staging/hv/Hv.c                   |    2 +-
 drivers/staging/hv/RndisFilter.c          |    1 +
 drivers/staging/hv/netvsc_drv.c           |    3 +-
 drivers/staging/usbip/usbip_event.c       |    3 +
 drivers/usb/core/driver.c                 |   32 +++++-
 drivers/usb/core/generic.c                |    2 +-
 drivers/usb/core/inode.c                  |    4 +-
 drivers/usb/host/ehci-hcd.c               |    1 +
 drivers/usb/host/ehci-mem.c               |    2 +-
 drivers/usb/host/ehci-sched.c             |   38 +++++--
 drivers/usb/host/ehci.h                   |    5 +-
 drivers/usb/host/ohci-hub.c               |    2 +-
 drivers/usb/host/xhci-mem.c               |   65 +++++++++++
 drivers/usb/host/xhci.h                   |    4 +
 drivers/usb/serial/sierra.c               |    1 +
 drivers/w1/slaves/w1_therm.c              |    5 +-
 fs/ext4/extents.c                         |    9 +-
 fs/jfs/resize.c                           |    6 +-
 fs/nfs/client.c                           |    2 +
 fs/nfs/dir.c                              |    2 +
 fs/nfsd/nfs4xdr.c                         |    8 +-
 fs/ocfs2/buffer_head_io.c                 |    2 +
 fs/ocfs2/dlm/dlmfs.c                      |    2 +-
 fs/ocfs2/inode.c                          |    1 +
 fs/ocfs2/refcounttree.c                   |    3 +
 fs/proc/base.c                            |    2 +-
 fs/reiserfs/dir.c                         |    2 -
 fs/reiserfs/xattr.c                       |   19 +---
 fs/xfs/linux-2.6/xfs_super.c              |    5 +
 fs/xfs/linux-2.6/xfs_sync.c               |  107 +++++++++++++++++-
 fs/xfs/linux-2.6/xfs_sync.h               |    7 +-
 fs/xfs/quota/xfs_qm_syscalls.c            |    3 +-
 fs/xfs/xfs_ag.h                           |    1 +
 fs/xfs/xfs_mount.h                        |    1 +
 include/linux/acpi.h                      |    1 +
 include/linux/ata.h                       |    4 +-
 include/linux/poison.h                    |   25 ++++-
 include/linux/syscalls.h                  |    6 +-
 include/trace/ftrace.h                    |    3 +-
 init/initramfs.c                          |    3 +-
 kernel/cred.c                             |    2 -
 kernel/perf_event.c                       |    2 +-
 kernel/trace/trace.h                      |    3 +-
 lib/flex_array.c                          |    2 +-
 mm/hugetlb.c                              |    5 +-
 mm/memcontrol.c                           |    4 +-
 net/dccp/probe.c                          |    3 +-
 net/mac80211/agg-tx.c                     |    1 -
 security/inode.c                          |    4 +-
 security/keys/request_key.c               |    9 ++-
 sound/pci/hda/hda_intel.c                 |    1 +
 sound/pci/hda/patch_conexant.c            |   10 +-
 sound/pci/hda/patch_realtek.c             |    2 +-
 sound/pci/hda/patch_sigmatel.c            |    6 +
 sound/pci/maestro3.c                      |    9 ++
 104 files changed, 843 insertions(+), 292 deletions(-)
