Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab1BBAnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:35748 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1BBAnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883417880"
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20110201443.618138584@firstfloor.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [0/139] 2.6.35.11 longterm review
Date: Tue,  1 Feb 2011 16:43:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the longterm review cycle for the 2.6.35.10 release.
There are a large number of patches in this series, all will be posted as a 
response to this one.  If anyone has any issues with these being applied, 
please let me know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

The full quilt queue can be found at
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.35

Responses should be made within 48 hours.

 Documentation/kernel-parameters.txt         |    1 +
 Documentation/power/runtime_pm.txt          |    4 +-
 Makefile                                    |    2 +-
 arch/arm/mach-at91/include/mach/at91_mci.h  |    2 +
 arch/arm/mm/cache-v6.S                      |   28 ++++--
 arch/sparc/include/asm/openprom.h           |    2 +-
 arch/sparc/include/asm/oplib_32.h           |   35 +------
 arch/sparc/include/asm/oplib_64.h           |   46 +--------
 arch/sparc/kernel/leon_kernel.c             |    4 +-
 arch/sparc/prom/Makefile                    |    1 -
 arch/sparc/prom/console_32.c                |   65 ++---------
 arch/sparc/prom/console_64.c                |   81 +++-----------
 arch/sparc/prom/devops_32.c                 |   87 ---------------
 arch/sparc/prom/devops_64.c                 |   67 ------------
 arch/sparc/prom/misc_64.c                   |   16 +---
 arch/sparc/prom/printf.c                    |   35 +++++-
 arch/sparc/prom/tree_32.c                   |   15 ---
 arch/sparc/prom/tree_64.c                   |   18 ---
 arch/x86/include/asm/processor.h            |   23 ----
 arch/x86/kernel/apic/apic.c                 |    8 ++
 arch/x86/kernel/apic/io_apic.c              |    1 +
 arch/x86/kernel/apic/probe_64.c             |    7 --
 arch/x86/kernel/cpu/amd.c                   |    3 +-
 arch/x86/kernel/microcode_intel.c           |   16 +--
 arch/x86/kernel/smpboot.c                   |   85 ++++++++++++++-
 arch/x86/kernel/xsave.c                     |    3 +-
 arch/x86/oprofile/op_model_amd.c            |   24 +++--
 arch/x86/vdso/Makefile                      |    4 +-
 block/blk-merge.c                           |    6 +-
 block/blk-settings.c                        |   25 +----
 block/blk-sysfs.c                           |    2 +-
 drivers/acpi/acpica/dswexec.c               |   19 +++-
 drivers/acpi/ec.c                           |    3 +
 drivers/ata/libata-sff.c                    |    7 +-
 drivers/block/xen-blkfront.c                |    2 +-
 drivers/char/n_gsm.c                        |    6 +-
 drivers/char/ramoops.c                      |   12 ++-
 drivers/dma/mv_xor.c                        |    2 +-
 drivers/edac/amd64_edac.c                   |    2 +-
 drivers/edac/edac_mc.c                      |   10 +-
 drivers/gpio/cs5535-gpio.c                  |   19 +++-
 drivers/gpio/rdc321x-gpio.c                 |    2 +-
 drivers/gpu/drm/drm_crtc.c                  |   10 +-
 drivers/gpu/drm/i915/intel_dp.c             |   37 +++++--
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    6 +
 drivers/gpu/drm/nouveau/nouveau_irq.c       |    1 +
 drivers/gpu/drm/nouveau/nv50_display.c      |   35 +++++--
 drivers/gpu/drm/radeon/atombios_crtc.c      |    3 +-
 drivers/gpu/drm/radeon/evergreen.c          |   25 ++---
 drivers/gpu/drm/radeon/r600.c               |   24 +++--
 drivers/gpu/drm/radeon/radeon_device.c      |    9 +-
 drivers/gpu/drm/radeon/rv770.c              |    9 +-
 drivers/hwmon/adm1026.c                     |   20 ++--
 drivers/infiniband/core/uverbs_cmd.c        |  101 ++++++++++--------
 drivers/input/mouse/synaptics.h             |    3 +-
 drivers/input/serio/i8042-x86ia64io.h       |   21 ++++
 drivers/input/serio/i8042.c                 |    6 +-
 drivers/md/dm-table.c                       |    5 -
 drivers/md/md.c                             |   15 ++--
 drivers/md/raid10.c                         |    2 +-
 drivers/media/video/gspca/sonixj.c          |   17 +++-
 drivers/mfd/wm831x-core.c                   |    8 +-
 drivers/mmc/core/core.c                     |    1 +
 drivers/mmc/host/at91_mci.c                 |   13 ++-
 drivers/mmc/host/atmel-mci.c                |   18 ++-
 drivers/net/8139cp.c                        |   10 +-
 drivers/net/benet/be_cmds.c                 |    2 +-
 drivers/net/bonding/bonding.h               |    4 +-
 drivers/net/ifb.c                           |    2 +
 drivers/net/r8169.c                         |    4 +-
 drivers/net/tehuti.c                        |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c |   12 ++-
 drivers/net/wireless/ath/ath9k/main.c       |   11 ++-
 drivers/net/wireless/orinoco/main.c         |    6 +
 drivers/net/wireless/orinoco/wext.c         |    4 +-
 drivers/net/wireless/p54/p54usb.c           |    6 +
 drivers/net/wireless/rt2x00/rt2400pci.c     |    6 +-
 drivers/net/wireless/rt2x00/rt2500pci.c     |   12 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c     |   12 ++-
 drivers/net/wireless/rt2x00/rt2800.h        |    7 ++
 drivers/net/wireless/rt2x00/rt2800lib.c     |   59 ++++++----
 drivers/net/wireless/rt2x00/rt2x00.h        |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c       |   12 ++-
 drivers/net/wireless/rt2x00/rt73usb.c       |   12 ++-
 drivers/net/xen-netfront.c                  |    4 +-
 drivers/pci/dmar.c                          |    5 +
 drivers/pci/quirks.c                        |   23 ++++
 drivers/rtc/rtc-rs5c372.c                   |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |    1 +
 drivers/scsi/qla2xxx/qla_nx.c               |    1 +
 drivers/scsi/qla2xxx/qla_os.c               |    1 +
 drivers/scsi/scsi_lib.c                     |    3 +-
 drivers/usb/gadget/composite.c              |   16 ++--
 drivers/usb/host/xhci-mem.c                 |   25 +++--
 drivers/usb/misc/uss720.c                   |    4 +-
 drivers/usb/serial/ftdi_sio.c               |    1 +
 drivers/usb/serial/ftdi_sio_ids.h           |    5 +
 drivers/usb/storage/unusual_devs.h          |    7 ++
 drivers/watchdog/rdc321x_wdt.c              |    2 +-
 fs/exec.c                                   |    5 +
 fs/fuse/file.c                              |   72 +++++++++++-
 fs/nfs/file.c                               |    2 +
 fs/nfs/mount_clnt.c                         |    4 +-
 fs/nfsd/nfs3xdr.c                           |    6 +-
 fs/nfsd/xdr4.h                              |   21 ++--
 fs/notify/inotify/inotify_user.c            |    1 +
 include/linux/blkdev.h                      |    9 +-
 include/linux/bootmem.h                     |    2 +
 include/linux/mfd/wm8994/pdata.h            |    2 +-
 include/linux/pm_runtime.h                  |    3 +-
 include/linux/sched.h                       |    2 +-
 include/linux/socket.h                      |    5 +
 include/linux/user_namespace.h              |   14 +++
 include/net/af_unix.h                       |    6 +-
 include/net/scm.h                           |   28 ++++-
 include/net/sock.h                          |    4 +-
 include/xen/interface/io/ring.h             |   11 ++-
 kernel/exit.c                               |    8 ++
 kernel/fork.c                               |    1 +
 kernel/power/user.c                         |    2 +-
 kernel/printk.c                             |    4 +-
 kernel/sched.c                              |  156 ++++++++++++++++++++++++---
 kernel/timer.c                              |    8 ++-
 kernel/trace/trace.c                        |   10 ++-
 kernel/user.c                               |    1 +
 kernel/user_namespace.c                     |   44 ++++++++
 mm/mmap.c                                   |   16 ++-
 net/ax25/af_ax25.c                          |    2 +-
 net/bridge/br_multicast.c                   |    2 +-
 net/core/dst.c                              |    1 +
 net/core/filter.c                           |   19 +---
 net/core/scm.c                              |   24 ++++
 net/core/sock.c                             |   15 +++
 net/econet/af_econet.c                      |   12 ++-
 net/ipv4/tcp.c                              |    2 +-
 net/ipv4/tcp_ipv4.c                         |    8 +-
 net/ipv4/tcp_output.c                       |   42 ++++----
 net/l2tp/l2tp_ip.c                          |    6 +-
 net/llc/af_llc.c                            |    5 +-
 net/mac80211/agg-tx.c                       |    2 +-
 net/mac80211/rx.c                           |    5 +-
 net/mac80211/tx.c                           |   21 +++-
 net/packet/af_packet.c                      |    7 +-
 net/sched/cls_cgroup.c                      |    2 -
 net/sunrpc/svc_xprt.c                       |    9 ++-
 net/unix/af_unix.c                          |   86 +++++++++++-----
 net/unix/garbage.c                          |    9 ++-
 net/x25/x25_link.c                          |    1 +
 security/integrity/ima/ima_policy.c         |    2 +
 sound/oss/soundcard.c                       |    4 +-
 sound/pci/hda/hda_intel.c                   |    2 +
 sound/pci/hda/patch_conexant.c              |    4 +-
 sound/pci/hda/patch_realtek.c               |    1 +
 sound/soc/codecs/wm8580.c                   |    2 +-
 sound/soc/codecs/wm8904.c                   |    3 +-
 sound/soc/codecs/wm8955.c                   |    3 +-
 sound/soc/codecs/wm_hubs.c                  |    2 +-
 158 files changed, 1324 insertions(+), 907 deletions(-)
