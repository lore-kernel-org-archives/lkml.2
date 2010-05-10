Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab0EJWhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:37:24 -0400
Received: from kroah.org ([198.145.64.141]:53056 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab0EJWhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:37:20 -0400
Date: Mon, 10 May 2010 15:37:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/117] 2.6.33.4-stable review
Message-ID: <20100510223700.GA18404@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.33.4 release.
There are 117 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wed, May 12, 2010, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                        |    2 +-
 arch/arm/mach-pxa/include/mach/colibri.h        |    1 +
 arch/mips/include/asm/mach-sibyte/war.h         |    6 +-
 arch/mips/sibyte/sb1250/setup.c                 |   15 +++
 arch/powerpc/kernel/head_64.S                   |   11 ++
 arch/powerpc/mm/fsl_booke_mmu.c                 |    5 -
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   42 +++-----
 arch/powerpc/platforms/pseries/offline_states.h |    1 +
 arch/sparc/include/asm/irqflags_64.h            |   23 +++-
 arch/sparc/include/asm/thread_info_64.h         |    2 +-
 arch/sparc/kernel/pci_common.c                  |   11 ++-
 arch/sparc/kernel/rtrap_64.S                    |   12 ++-
 arch/sparc/kernel/traps_64.c                    |   26 +----
 arch/sparc/kernel/unaligned_64.c                |    6 +-
 arch/x86/Kconfig                                |    4 +-
 arch/x86/kernel/apic/io_apic.c                  |    3 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c       |    3 +-
 arch/x86/kernel/cpu/intel.c                     |   21 ++++
 arch/x86/kernel/k8.c                            |   14 +++
 arch/x86/kernel/pci-gart_64.c                   |    2 +-
 arch/x86/kernel/process_64.c                    |    4 +-
 block/blk-timeout.c                             |   12 +-
 crypto/async_tx/async_raid6_recov.c             |   21 ++--
 drivers/Makefile                                |    2 +-
 drivers/acpi/power_meter.c                      |    2 +-
 drivers/acpi/sleep.c                            |  144 +++++++++++++++++++++++
 drivers/ata/libata-eh.c                         |    5 +
 drivers/base/memory.c                           |    2 +-
 drivers/char/agp/Kconfig                        |    2 +-
 drivers/cpuidle/governors/menu.c                |    9 +-
 drivers/edac/edac_mce_amd.c                     |    5 +-
 drivers/gpu/drm/i915/i915_debugfs.c             |    2 +-
 drivers/gpu/drm/i915/i915_dma.c                 |   16 ++-
 drivers/gpu/drm/i915/i915_drv.h                 |   26 ++++-
 drivers/gpu/drm/i915/i915_gem.c                 |    8 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c          |   24 ++---
 drivers/gpu/drm/i915/i915_irq.c                 |   18 ++--
 drivers/gpu/drm/i915/i915_reg.h                 |    2 +-
 drivers/gpu/drm/i915/intel_bios.c               |    3 +-
 drivers/gpu/drm/i915/intel_crt.c                |   14 +-
 drivers/gpu/drm/i915/intel_display.c            |   56 +++++-----
 drivers/gpu/drm/i915/intel_lvds.c               |    2 +-
 drivers/gpu/drm/i915/intel_overlay.c            |    2 +-
 drivers/i2c/i2c-core.c                          |   21 +++-
 drivers/md/md.c                                 |   10 ++-
 drivers/md/raid5.c                              |   54 ++++-----
 drivers/media/dvb/ttpci/budget.c                |    3 -
 drivers/net/bnx2.c                              |    6 +-
 drivers/net/r8169.c                             |   13 ++-
 drivers/net/sfc/efx.c                           |    4 +-
 drivers/net/sfc/falcon.c                        |    4 +-
 drivers/net/sfc/falcon_boards.c                 |   13 +--
 drivers/net/sfc/nic.h                           |    2 +-
 drivers/net/sfc/siena.c                         |   13 ++-
 drivers/net/tg3.c                               |    1 +
 drivers/net/tun.c                               |    4 +
 drivers/net/usb/cdc_ether.c                     |    1 +
 drivers/net/usb/dm9601.c                        |    2 +-
 drivers/net/wan/hdlc_ppp.c                      |    6 +
 drivers/net/wireless/ath/ath9k/main.c           |    2 +-
 drivers/net/wireless/p54/p54pci.c               |    2 +-
 drivers/net/wireless/p54/p54usb.c               |    1 +
 drivers/net/wireless/p54/txrx.c                 |    2 +-
 drivers/pci/pci.c                               |    6 +-
 drivers/scsi/libiscsi.c                         |    2 +-
 drivers/scsi/libsas/sas_ata.c                   |    4 +
 drivers/scsi/libsas/sas_scsi_host.c             |    4 +
 drivers/scsi/scsi_debug.c                       |    3 +-
 drivers/scsi/scsi_error.c                       |   15 +++-
 drivers/scsi/scsi_lib.c                         |   10 ++-
 drivers/scsi/sd.c                               |    1 +
 drivers/serial/8250_pnp.c                       |    2 +
 drivers/staging/hv/Hv.c                         |    2 +-
 drivers/staging/hv/RndisFilter.c                |    1 +
 drivers/staging/hv/netvsc_drv.c                 |    3 +-
 drivers/staging/usbip/usbip_event.c             |    3 +
 drivers/usb/core/driver.c                       |   32 +++++-
 drivers/usb/core/generic.c                      |    2 +-
 drivers/usb/core/inode.c                        |    4 +-
 drivers/usb/core/message.c                      |    2 +-
 drivers/usb/host/ehci-hcd.c                     |    1 +
 drivers/usb/host/ehci-mem.c                     |    2 +-
 drivers/usb/host/ehci-sched.c                   |   38 +++++--
 drivers/usb/host/ehci.h                         |    5 +-
 drivers/usb/host/ohci-hub.c                     |    2 +-
 drivers/usb/host/xhci-mem.c                     |   65 ++++++++++
 drivers/usb/host/xhci.h                         |    4 +
 drivers/usb/serial/sierra.c                     |    1 +
 drivers/w1/slaves/w1_therm.c                    |    5 +-
 fs/ext4/extents.c                               |    9 +-
 fs/jfs/resize.c                                 |    6 +-
 fs/nfs/client.c                                 |    2 +
 fs/nfs/dir.c                                    |    2 +
 fs/nfsd/nfs4xdr.c                               |    8 +-
 fs/ocfs2/buffer_head_io.c                       |    2 +
 fs/ocfs2/dlm/dlmfs.c                            |    2 +-
 fs/ocfs2/inode.c                                |    1 +
 fs/ocfs2/refcounttree.c                         |    3 +
 fs/proc/base.c                                  |    2 +-
 fs/reiserfs/dir.c                               |    2 -
 fs/reiserfs/xattr.c                             |   19 +---
 fs/xfs/linux-2.6/xfs_super.c                    |    5 +
 fs/xfs/linux-2.6/xfs_sync.c                     |  107 ++++++++++++++++-
 fs/xfs/linux-2.6/xfs_sync.h                     |    7 +-
 fs/xfs/quota/xfs_qm_syscalls.c                  |    3 +-
 fs/xfs/xfs_ag.h                                 |    1 +
 fs/xfs/xfs_mount.h                              |    1 +
 include/drm/drm_pciids.h                        |    1 +
 include/linux/ata.h                             |    4 +-
 include/linux/poison.h                          |    9 ++
 include/net/sctp/command.h                      |    1 +
 include/net/sctp/sctp.h                         |    1 +
 init/initramfs.c                                |    3 +-
 kernel/cred.c                                   |    2 -
 kernel/perf_event.c                             |    2 +-
 lib/flex_array.c                                |    2 +-
 mm/hugetlb.c                                    |    5 +-
 mm/memcontrol.c                                 |    4 +-
 net/ieee802154/af_ieee802154.c                  |    3 +
 net/ipv4/tcp.c                                  |    1 +
 net/ipv4/udp.c                                  |    4 +-
 net/ipv6/tcp_ipv6.c                             |    2 +-
 net/ipv6/udp.c                                  |    4 +-
 net/mac80211/agg-tx.c                           |    1 -
 net/sctp/associola.c                            |    6 +-
 net/sctp/endpointola.c                          |    1 +
 net/sctp/sm_make_chunk.c                        |   32 ++----
 net/sctp/sm_sideeffect.c                        |   26 ++++
 net/sctp/sm_statefuns.c                         |    8 +-
 net/sctp/socket.c                               |   14 ++-
 net/tipc/bearer.c                               |   37 +-----
 net/tipc/bearer.h                               |    2 +-
 net/tipc/net.c                                  |   25 +----
 security/inode.c                                |    4 +-
 security/keys/request_key.c                     |    9 ++-
 sound/pci/hda/hda_intel.c                       |    1 +
 sound/pci/hda/patch_conexant.c                  |    7 +-
 sound/pci/hda/patch_realtek.c                   |    2 +-
 sound/pci/hda/patch_sigmatel.c                  |    6 +
 sound/pci/maestro3.c                            |    9 ++
 140 files changed, 989 insertions(+), 405 deletions(-)
