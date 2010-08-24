Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0HXWqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:46:47 -0400
Received: from kroah.org ([198.145.64.141]:59753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab0HXWqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:46:45 -0400
Date: Tue, 24 Aug 2010 15:46:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/114] 2.6.35.4-stable review
Message-ID: <20100824224610.GA5424@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.35.4 release.
There are 114 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, August 26, 2010 22:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                      |    2 +-
 arch/arm/include/asm/ptrace.h                 |   17 ++-
 arch/arm/mach-ixp4xx/ixdp425-setup.c          |    1 +
 arch/arm/mach-mx3/mach-qong.c                 |    1 +
 arch/arm/mach-orion5x/ts78xx-setup.c          |    1 +
 arch/blackfin/mach-bf537/boards/stamp.c       |    1 +
 arch/blackfin/mach-bf561/boards/acvilon.c     |    1 +
 arch/powerpc/Makefile                         |    2 +-
 arch/powerpc/kernel/head_64.S                 |    6 +-
 arch/sparc/include/asm/atomic_64.h            |   10 +-
 arch/sparc/include/asm/fb.h                   |    4 +
 arch/sparc/include/asm/parport.h              |    4 +
 arch/sparc/include/asm/rwsem-const.h          |    2 +-
 arch/x86/Kconfig                              |    5 +
 arch/x86/include/asm/cmpxchg_32.h             |   67 ++-----
 arch/x86/include/asm/cmpxchg_64.h             |    4 +-
 arch/x86/kernel/apic/apic.c                   |    2 +-
 arch/x86/kernel/apic/io_apic.c                |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c        |   81 +++++++--
 arch/x86/kernel/cpu/perf_event_p4.c           |    9 +-
 arch/x86/kernel/mpparse.c                     |   16 ++
 arch/x86/kernel/smpboot.c                     |   19 ++
 arch/x86/lib/atomic64_386_32.S                |  236 +++++++++++++-----------
 arch/x86/oprofile/nmi_int.c                   |   17 ++-
 drivers/acpi/apei/erst.c                      |    1 +
 drivers/char/agp/intel-gtt.c                  |   11 +-
 drivers/char/mem.c                            |    2 +-
 drivers/char/tty_io.c                         |    4 +-
 drivers/gpu/drm/drm_drv.c                     |    4 +-
 drivers/gpu/drm/i915/i915_dma.c               |    8 +
 drivers/gpu/drm/i915/intel_display.c          |   23 ++-
 drivers/gpu/drm/radeon/radeon_atombios.c      |   16 ++-
 drivers/gpu/drm/radeon/radeon_device.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_i2c.c           |    7 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c       |    5 +-
 drivers/gpu/drm/radeon/radeon_kms.c           |    4 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c            |    5 +
 drivers/hwmon/pc87360.c                       |   31 ++--
 drivers/isdn/gigaset/capi.c                   |   17 +-
 drivers/isdn/sc/ioctl.c                       |   10 +-
 drivers/md/dm-exception-store.c               |    4 +-
 drivers/md/dm-exception-store.h               |    3 +-
 drivers/md/dm-ioctl.c                         |   50 ++++--
 drivers/md/dm-snap.c                          |   44 +++--
 drivers/md/dm.c                               |   63 +++++--
 drivers/md/dm.h                               |    5 +
 drivers/memstick/core/mspro_block.c           |    6 +-
 drivers/mtd/chips/cfi_cmdset_0001.c           |   20 +-
 drivers/mtd/lpddr/lpddr_cmds.c                |   20 +-
 drivers/mtd/nand/nand_base.c                  |    1 +
 drivers/mtd/nand/plat_nand.c                  |    5 +
 drivers/mtd/nand/pxa3xx_nand.c                |    2 +-
 drivers/net/e1000e/82571.c                    |   31 ++--
 drivers/net/e1000e/defines.h                  |    4 +
 drivers/net/e1000e/lib.c                      |   10 +
 drivers/net/wireless/ath/ath5k/base.c         |   21 +++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   15 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c       |   16 --
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c   |   17 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |   17 +--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   20 +--
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   83 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c       |   70 +++-----
 drivers/net/wireless/iwlwifi/iwl-core.h       |   13 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |   56 ++++++-
 drivers/net/wireless/wl12xx/wl1251_cmd.c      |    2 +-
 drivers/platform/x86/compal-laptop.c          |    9 +
 drivers/platform/x86/dell-laptop.c            |    7 +
 drivers/regulator/wm8994-regulator.c          |    5 +-
 drivers/serial/suncore.c                      |   15 +-
 drivers/staging/batman-adv/hard-interface.c   |   21 ++-
 drivers/staging/batman-adv/originator.c       |   14 +-
 drivers/usb/host/xhci-ring.c                  |    2 +-
 drivers/usb/serial/cp210x.c                   |    4 +-
 drivers/usb/serial/ftdi_sio.c                 |    5 +-
 drivers/usb/serial/ftdi_sio_ids.h             |    9 +
 drivers/usb/serial/io_ti.c                    |    2 +-
 drivers/usb/serial/navman.c                   |    1 +
 drivers/usb/serial/option.c                   |    7 +-
 drivers/usb/serial/pl2303.c                   |    1 +
 drivers/usb/serial/pl2303.h                   |    4 +
 drivers/video/matrox/matroxfb_base.h          |    4 +-
 firmware/Makefile                             |    2 +-
 fs/char_dev.c                                 |    1 +
 fs/nfs/dir.c                                  |    2 +-
 fs/nfs/nfs4proc.c                             |    8 +-
 fs/nfs/super.c                                |    7 +
 fs/nilfs2/super.c                             |    4 +-
 fs/ocfs2/acl.c                                |   33 +++-
 fs/ocfs2/dlm/dlmmaster.c                      |    9 +-
 fs/ocfs2/dlm/dlmrecovery.c                    |   22 +--
 fs/ocfs2/dlm/dlmthread.c                      |  114 ++++++------
 fs/ocfs2/refcounttree.c                       |   20 ++-
 include/acpi/platform/aclinux.h               |   10 +-
 include/linux/mm_types.h                      |    2 +-
 include/linux/mtd/flashchip.h                 |    2 +-
 include/linux/skbuff.h                        |    4 +-
 include/linux/tty.h                           |    3 +
 include/sound/emu10k1.h                       |    1 +
 include/trace/events/timer.h                  |    8 +-
 kernel/fork.c                                 |    7 +-
 kernel/sched.c                                |   10 +-
 kernel/time/timekeeping.c                     |   14 +-
 kernel/trace/ring_buffer.c                    |    3 +
 kernel/trace/trace_functions_graph.c          |   10 +-
 mm/memory.c                                   |   15 ++-
 mm/mlock.c                                    |   21 ++-
 mm/mmap.c                                     |   21 ++-
 mm/nommu.c                                    |    7 +-
 mm/slab.c                                     |    4 +-
 net/bridge/br_device.c                        |    8 +-
 net/bridge/br_fdb.c                           |    2 +-
 net/bridge/br_input.c                         |    6 +-
 net/bridge/br_stp_bpdu.c                      |    2 +-
 net/can/bcm.c                                 |   41 +++--
 net/can/raw.c                                 |    4 +
 net/core/dev.c                                |    9 +-
 net/ipv4/tcp.c                                |    7 +-
 net/netlink/af_netlink.c                      |   46 ++---
 net/sched/act_nat.c                           |    3 +-
 net/sched/sch_sfq.c                           |   13 ++
 net/wireless/mlme.c                           |    8 +-
 scripts/mkmakefile                            |    4 +-
 sound/core/pcm_native.c                       |    4 +
 sound/pci/emu10k1/emu10k1.c                   |    4 +
 sound/pci/emu10k1/emupcm.c                    |   30 +++-
 sound/pci/emu10k1/memory.c                    |    4 +-
 sound/pci/hda/patch_conexant.c                |    1 +
 sound/pci/hda/patch_realtek.c                 |    1 +
 sound/pci/intel8x0.c                          |    6 +
 sound/pci/riptide/riptide.c                   |   11 +-
 sound/soc/codecs/wm8580.c                     |    6 +-
 sound/soc/codecs/wm8776.c                     |    7 -
 sound/soc/soc-cache.c                         |    4 +-
 135 files changed, 1262 insertions(+), 703 deletions(-)
