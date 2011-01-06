Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1AFAZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:25:07 -0500
Received: from kroah.org ([198.145.64.141]:38367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1AFAZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:25:05 -0500
Date: Wed, 5 Jan 2011 16:25:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/152] 2.6.36.3-stable review
Message-ID: <20110106002500.GA3172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.36.3 release.
There are 152 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, January 7, 2011, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.36.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/kernel-parameters.txt            |    2 +-
 Documentation/power/runtime_pm.txt             |    4 +-
 Makefile                                       |    2 +-
 arch/arm/mach-at91/include/mach/at91_mci.h     |    2 +
 arch/arm/mm/cache-v6.S                         |   28 +++--
 arch/mips/jz4740/board-qi_lb60.c               |    4 +-
 arch/sparc/include/asm/openprom.h              |    2 +-
 arch/sparc/include/asm/oplib_32.h              |   35 +-----
 arch/sparc/include/asm/oplib_64.h              |   46 +-------
 arch/sparc/kernel/leon_kernel.c                |    4 +-
 arch/sparc/prom/Makefile                       |    1 -
 arch/sparc/prom/console_32.c                   |   65 ++--------
 arch/sparc/prom/console_64.c                   |   81 +++----------
 arch/sparc/prom/devops_32.c                    |   87 -------------
 arch/sparc/prom/devops_64.c                    |   67 ----------
 arch/sparc/prom/misc_64.c                      |   16 +---
 arch/sparc/prom/printf.c                       |   35 +++++-
 arch/sparc/prom/tree_32.c                      |   15 ---
 arch/sparc/prom/tree_64.c                      |   18 ---
 arch/tile/kernel/process.c                     |    7 +
 arch/x86/include/asm/kvm_host.h                |    2 +-
 arch/x86/include/asm/processor.h               |   23 ----
 arch/x86/kernel/apic/apic.c                    |    8 ++
 arch/x86/kernel/apic/io_apic.c                 |    1 +
 arch/x86/kernel/apic/probe_64.c                |    7 -
 arch/x86/kernel/cpu/amd.c                      |    3 +-
 arch/x86/kernel/microcode_intel.c              |   16 +--
 arch/x86/kernel/smpboot.c                      |   85 +++++++++++++-
 arch/x86/kernel/xsave.c                        |    3 +-
 arch/x86/kvm/svm.c                             |    4 +
 arch/x86/kvm/vmx.c                             |    5 -
 arch/x86/kvm/x86.c                             |    7 +-
 arch/x86/kvm/x86.h                             |    5 +
 arch/x86/oprofile/op_model_amd.c               |   24 +++--
 arch/x86/vdso/Makefile                         |    4 +-
 block/blk-merge.c                              |    6 +-
 block/blk-settings.c                           |   25 +----
 block/blk-sysfs.c                              |    2 +-
 drivers/acpi/acpica/dswexec.c                  |   19 +++-
 drivers/acpi/ec.c                              |    3 +
 drivers/ata/libata-sff.c                       |    7 +-
 drivers/block/xen-blkfront.c                   |    2 +-
 drivers/char/n_gsm.c                           |    6 +-
 drivers/char/ramoops.c                         |   12 +-
 drivers/dma/mv_xor.c                           |    2 +-
 drivers/edac/amd64_edac.c                      |    2 +-
 drivers/edac/edac_mc.c                         |   10 +-
 drivers/firewire/ohci.c                        |   47 +++++--
 drivers/gpio/cs5535-gpio.c                     |   19 +++-
 drivers/gpio/rdc321x-gpio.c                    |    2 +-
 drivers/gpu/drm/drm_crtc.c                     |   10 +-
 drivers/gpu/drm/i915/i915_dma.c                |   23 ++++
 drivers/gpu/drm/i915/i915_reg.h                |    1 +
 drivers/gpu/drm/i915/intel_bios.c              |    2 +-
 drivers/gpu/drm/i915/intel_display.c           |    4 +-
 drivers/gpu/drm/i915/intel_dp.c                |   37 +++++-
 drivers/gpu/drm/nouveau/nouveau_drv.h          |    6 +
 drivers/gpu/drm/nouveau/nouveau_irq.c          |    1 +
 drivers/gpu/drm/nouveau/nv50_display.c         |   35 ++++--
 drivers/gpu/drm/radeon/atombios_crtc.c         |    3 +-
 drivers/gpu/drm/radeon/evergreen.c             |   25 ++---
 drivers/gpu/drm/radeon/r600.c                  |   17 ++-
 drivers/gpu/drm/radeon/radeon_device.c         |    9 +-
 drivers/hwmon/adm1026.c                        |   20 ++--
 drivers/infiniband/core/uverbs_cmd.c           |  101 +++++++++-------
 drivers/input/mouse/synaptics.h                |    3 +-
 drivers/md/dm-table.c                          |    5 -
 drivers/md/md.c                                |   15 +--
 drivers/md/raid10.c                            |    2 +-
 drivers/media/common/saa7146_hlp.c             |    8 +-
 drivers/media/common/saa7146_video.c           |   16 ++--
 drivers/media/video/gspca/sonixj.c             |   17 ++-
 drivers/media/video/mx2_camera.c               |    2 -
 drivers/mfd/wm831x-core.c                      |    8 +-
 drivers/mmc/core/core.c                        |    1 +
 drivers/mmc/host/at91_mci.c                    |   13 ++-
 drivers/mmc/host/atmel-mci.c                   |   18 ++-
 drivers/net/8139cp.c                           |   10 +-
 drivers/net/benet/be_cmds.c                    |    2 +-
 drivers/net/bonding/bonding.h                  |    4 +-
 drivers/net/ifb.c                              |    2 +
 drivers/net/pppoe.c                            |    2 +-
 drivers/net/r8169.c                            |    4 +-
 drivers/net/tehuti.c                           |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   73 ++++++------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    9 +-
 drivers/net/wireless/ath/ath9k/eeprom.c        |    6 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |   13 +--
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |   12 ++-
 drivers/net/wireless/ath/ath9k/hw.c            |    3 +-
 drivers/net/wireless/ath/ath9k/mac.c           |    3 +-
 drivers/net/wireless/ath/ath9k/main.c          |   11 ++-
 drivers/net/wireless/ath/ath9k/recv.c          |    4 +-
 drivers/net/wireless/ath/ath9k/reg.h           |    6 +-
 drivers/net/wireless/orinoco/main.c            |    6 +
 drivers/net/wireless/orinoco/orinoco_cs.c      |   14 +-
 drivers/net/wireless/orinoco/spectrum_cs.c     |   14 +-
 drivers/net/wireless/orinoco/wext.c            |    4 +-
 drivers/net/wireless/p54/p54usb.c              |    6 +
 drivers/net/wireless/rt2x00/rt2400pci.c        |    6 +-
 drivers/net/wireless/rt2x00/rt2500pci.c        |   12 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c        |   12 ++-
 drivers/net/wireless/rt2x00/rt2800.h           |    7 +
 drivers/net/wireless/rt2x00/rt2800lib.c        |   59 ++++++----
 drivers/net/wireless/rt2x00/rt2x00.h           |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c        |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c          |   12 ++-
 drivers/net/wireless/rt2x00/rt73usb.c          |   12 ++-
 drivers/net/xen-netfront.c                     |    4 +-
 drivers/pci/dmar.c                             |    5 +
 drivers/pci/quirks.c                           |   23 ++++
 drivers/platform/x86/intel_ips.c               |   36 +++++-
 drivers/platform/x86/intel_ips.h               |   21 +++
 drivers/rtc/rtc-rs5c372.c                      |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c                |    1 +
 drivers/scsi/qla2xxx/qla_nx.c                  |    1 +
 drivers/scsi/qla2xxx/qla_os.c                  |    1 +
 drivers/scsi/scsi_lib.c                        |    3 +-
 drivers/staging/cx25821/cx25821-video.c        |    8 +-
 drivers/staging/cx25821/cx25821-video.h        |    2 +-
 drivers/usb/gadget/composite.c                 |   16 ++--
 drivers/usb/host/xhci-mem.c                    |   25 +++--
 drivers/usb/misc/uss720.c                      |    4 +-
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio_ids.h              |    5 +
 drivers/usb/storage/unusual_devs.h             |    7 +
 drivers/watchdog/rdc321x_wdt.c                 |    2 +-
 fs/exec.c                                      |    5 +
 fs/fuse/file.c                                 |   72 ++++++++++-
 fs/nfs/file.c                                  |    2 +
 fs/nfs/mount_clnt.c                            |    4 +-
 fs/nfsd/nfs3xdr.c                              |    6 +-
 fs/nfsd/xdr4.h                                 |   21 ++--
 fs/notify/inotify/inotify_user.c               |    1 +
 include/linux/blkdev.h                         |    9 +-
 include/linux/bootmem.h                        |    2 +
 include/linux/mfd/wm8994/pdata.h               |    2 +-
 include/linux/pm_runtime.h                     |    3 +-
 include/linux/sched.h                          |    2 +-
 include/media/saa7146.h                        |    2 +-
 include/net/af_unix.h                          |    2 +
 include/net/sock.h                             |    4 +-
 include/xen/interface/io/ring.h                |   11 ++-
 kernel/exit.c                                  |    8 ++
 kernel/fork.c                                  |    1 +
 kernel/power/user.c                            |    2 +-
 kernel/printk.c                                |    4 +-
 kernel/sched.c                                 |  156 +++++++++++++++++++++--
 kernel/timer.c                                 |    8 +-
 kernel/trace/trace.c                           |   10 ++-
 kernel/user.c                                  |    1 +
 kernel/watchdog.c                              |    3 +-
 mm/memcontrol.c                                |   19 ++--
 mm/mmap.c                                      |   16 ++-
 net/ax25/af_ax25.c                             |    2 +-
 net/bridge/br_multicast.c                      |    2 +-
 net/core/dst.c                                 |    1 +
 net/core/filter.c                              |   19 +--
 net/core/timestamping.c                        |    6 +-
 net/econet/af_econet.c                         |   12 ++-
 net/ipv4/tcp.c                                 |    2 +-
 net/ipv4/tcp_ipv4.c                            |    8 +-
 net/ipv4/tcp_output.c                          |   42 ++++---
 net/l2tp/l2tp_ip.c                             |    6 +-
 net/llc/af_llc.c                               |    5 +-
 net/mac80211/rx.c                              |    5 +-
 net/mac80211/tx.c                              |   21 +++-
 net/packet/af_packet.c                         |    7 +-
 net/sched/cls_cgroup.c                         |    2 -
 net/sunrpc/svc_xprt.c                          |    9 ++-
 net/unix/af_unix.c                             |   37 +++++-
 net/unix/garbage.c                             |    9 ++-
 net/x25/x25_link.c                             |    1 +
 security/integrity/ima/ima_policy.c            |    2 +
 sound/oss/soundcard.c                          |    4 +-
 sound/pci/hda/hda_eld.c                        |   20 +--
 sound/pci/hda/hda_intel.c                      |    2 +
 sound/pci/hda/patch_conexant.c                 |    4 +-
 sound/pci/hda/patch_hdmi.c                     |    1 -
 sound/pci/hda/patch_realtek.c                  |    1 +
 sound/soc/codecs/wm8580.c                      |    2 +-
 sound/soc/codecs/wm8904.c                      |    3 +-
 sound/soc/codecs/wm8955.c                      |    3 +-
 sound/soc/codecs/wm8960.c                      |    3 +-
 sound/soc/codecs/wm_hubs.c                     |    2 +-
 185 files changed, 1384 insertions(+), 1025 deletions(-)
