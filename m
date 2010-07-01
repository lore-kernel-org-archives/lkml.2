Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0GARwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:52:41 -0400
Received: from kroah.org ([198.145.64.141]:41032 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab0GARwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:52:19 -0400
Date: Thu, 1 Jul 2010 10:52:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/200] 2.6.34.1 stable review
Message-ID: <20100701175201.GA2149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701175100.GA2078@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.34.1 release.
There are 200 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sat, July 3, 17:00:00 UTC UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.34.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/hwmon/ltc4245                     |    4 +-
 Makefile                                        |    2 +-
 arch/arm/common/sa1111.c                        |    9 +-
 arch/arm/mach-mx2/devices.c                     |    4 +-
 arch/arm/mm/cache-v7.S                          |    4 +
 arch/arm/mm/copypage-feroceon.c                 |    4 +-
 arch/arm/mm/copypage-v4wb.c                     |    4 +-
 arch/arm/mm/copypage-v4wt.c                     |    4 +-
 arch/arm/mm/copypage-xsc3.c                     |    4 +-
 arch/arm/mm/fault.c                             |    3 +
 arch/arm/mm/init.c                              |    6 +-
 arch/arm/vfp/vfphw.S                            |    2 +-
 arch/blackfin/include/asm/cache.h               |    2 +
 arch/frv/include/asm/cache.h                    |    2 +
 arch/m68k/include/asm/cache.h                   |    2 +
 arch/mn10300/include/asm/cache.h                |    2 +
 arch/parisc/math-emu/decode_exc.c               |    1 +
 arch/powerpc/kernel/asm-offsets.c               |    8 +
 arch/powerpc/kernel/head_fsl_booke.S            |   13 +-
 arch/powerpc/kvm/book3s.c                       |   10 +
 arch/powerpc/kvm/booke.c                        |   15 +-
 arch/powerpc/kvm/powerpc.c                      |    3 +-
 arch/powerpc/lib/string.S                       |    4 +-
 arch/powerpc/mm/fsl_booke_mmu.c                 |   25 +--
 arch/powerpc/mm/mmu_decl.h                      |   10 +-
 arch/powerpc/mm/pgtable_32.c                    |    8 +
 arch/powerpc/mm/pgtable_64.c                    |    8 +
 arch/powerpc/mm/tlb_nohash_low.S                |   28 ++
 arch/powerpc/oprofile/op_model_cell.c           |    2 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   30 +--
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    8 +
 arch/powerpc/platforms/pseries/smp.c            |   28 ++
 arch/s390/kvm/kvm-s390.c                        |    4 +-
 arch/x86/include/asm/kvm_host.h                 |    3 +
 arch/x86/include/asm/msr-index.h                |    5 +-
 arch/x86/kernel/amd_iommu.c                     |   16 +-
 arch/x86/kernel/amd_iommu_init.c                |   20 ++-
 arch/x86/kernel/cpu/perf_event.c                |    5 +-
 arch/x86/kernel/pvclock.c                       |   24 ++
 arch/x86/kernel/setup.c                         |   11 +
 arch/x86/kernel/tboot.c                         |    1 +
 arch/x86/kvm/mmu.c                              |   10 +-
 arch/x86/kvm/svm.c                              |  163 ++++++++-----
 arch/x86/kvm/vmx.c                              |   38 ++-
 arch/x86/kvm/x86.c                              |   58 +++--
 arch/x86/oprofile/nmi_int.c                     |   10 +-
 arch/x86/xen/suspend.c                          |    4 +-
 arch/xtensa/include/asm/cache.h                 |    1 +
 block/cfq-iosched.c                             |   20 +-
 drivers/acpi/video_detect.c                     |    2 +-
 drivers/ata/libata-core.c                       |    7 +-
 drivers/ata/libata-sff.c                        |    2 +-
 drivers/ata/sata_nv.c                           |    5 +-
 drivers/ata/sata_via.c                          |   13 +
 drivers/base/cpu.c                              |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c                |   11 +-
 drivers/clocksource/sh_cmt.c                    |   21 +-
 drivers/clocksource/sh_tmu.c                    |   20 +-
 drivers/firewire/core-card.c                    |   24 ++-
 drivers/gpu/drm/drm_edid.c                      |    2 +-
 drivers/gpu/drm/i915/i915_gem.c                 |   19 ++
 drivers/gpu/drm/i915/intel_display.c            |    6 -
 drivers/gpu/drm/i915/intel_dp.c                 |   10 -
 drivers/gpu/drm/radeon/radeon.h                 |    1 +
 drivers/gpu/drm/radeon/radeon_agp.c             |    5 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |    7 +-
 drivers/gpu/drm/radeon/radeon_device.c          |    2 +
 drivers/gpu/drm/radeon/radeon_display.c         |    5 +-
 drivers/gpu/drm/radeon/radeon_state.c           |    5 +-
 drivers/hid/hid-core.c                          |    1 +
 drivers/hid/hid-gyration.c                      |    1 +
 drivers/hid/hid-ids.h                           |    1 +
 drivers/hwmon/ltc4245.c                         |   18 +-
 drivers/md/linear.c                             |    1 +
 drivers/md/md.c                                 |   99 +++++++-
 drivers/md/md.h                                 |    1 +
 drivers/md/raid1.c                              |    9 +-
 drivers/md/raid10.c                             |    2 +-
 drivers/md/raid5.c                              |    7 +-
 drivers/media/video/uvc/uvc_ctrl.c              |    2 +
 drivers/misc/vmware_balloon.c                   |   18 ++-
 drivers/net/arcnet/com20020-pci.c               |    4 +-
 drivers/net/can/sja1000/sja1000.c               |   20 ++-
 drivers/net/can/sja1000/sja1000.h               |    1 +
 drivers/net/mlx4/icm.c                          |    3 +-
 drivers/net/wireless/ath/ar9170/hw.h            |    1 +
 drivers/net/wireless/ath/ar9170/main.c          |    2 +-
 drivers/net/wireless/ath/ar9170/usb.c           |   10 +
 drivers/net/wireless/ath/ath5k/base.c           |   11 +-
 drivers/net/wireless/ath/ath9k/hw.c             |    4 +-
 drivers/net/wireless/ath/ath9k/init.c           |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c       |   10 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c         |   21 ++-
 drivers/net/wireless/iwlwifi/iwl-tx.c           |    2 +
 drivers/net/wireless/p54/p54usb.c               |    1 +
 drivers/net/wireless/rtl818x/rtl8180_dev.c      |    1 +
 drivers/net/wireless/wl12xx/wl1251_sdio.c       |    1 +
 drivers/oprofile/cpu_buffer.c                   |   63 +----
 drivers/pci/quirks.c                            |   13 +-
 drivers/pcmcia/ds.c                             |    1 +
 drivers/pcmcia/yenta_socket.c                   |    5 +-
 drivers/platform/x86/Kconfig                    |    1 +
 drivers/rtc/rtc-cmos.c                          |    5 +-
 drivers/rtc/rtc-s3c.c                           |    5 +-
 drivers/scsi/libsas/sas_ata.c                   |    5 +-
 drivers/scsi/libsas/sas_scsi_host.c             |   16 +-
 drivers/serial/68328serial.c                    |    2 +-
 drivers/staging/batman-adv/proc.c               |   51 +++--
 drivers/staging/batman-adv/vis.c                |  235 ++++++++++++------
 drivers/staging/batman-adv/vis.h                |    8 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c      |    2 +-
 drivers/staging/rt2860/usb_main_dev.c           |    1 +
 drivers/staging/vt6655/device_main.c            |    2 +
 drivers/usb/class/cdc-acm.c                     |    6 +-
 drivers/usb/core/driver.c                       |    2 +
 drivers/usb/core/hcd.c                          |  169 ++++++++-----
 drivers/usb/core/message.c                      |   45 +---
 drivers/usb/core/urb.c                          |    9 +-
 drivers/usb/core/usb.c                          |    4 +
 drivers/usb/gadget/fsl_udc_core.c               |    2 +-
 drivers/usb/host/ehci-au1xxx.c                  |   16 +-
 drivers/usb/host/ehci-fsl.c                     |    2 +
 drivers/usb/host/ehci-hub.c                     |  158 ++++++++++---
 drivers/usb/host/ehci-pci.c                     |   15 +-
 drivers/usb/host/ehci.h                         |   10 +
 drivers/usb/host/fhci.h                         |    9 +-
 drivers/usb/host/whci/qset.c                    |    2 +-
 drivers/usb/host/xhci-pci.c                     |    2 +-
 drivers/usb/host/xhci-ring.c                    |   39 +++-
 drivers/usb/host/xhci.c                         |   54 ++++-
 drivers/usb/mon/mon_bin.c                       |    2 +-
 drivers/usb/mon/mon_text.c                      |    4 +-
 drivers/usb/serial/cp210x.c                     |   11 +
 drivers/usb/serial/cypress_m8.c                 |    2 +-
 drivers/usb/serial/digi_acceleport.c            |    4 +-
 drivers/usb/serial/ftdi_sio.c                   |    4 +
 drivers/usb/serial/ir-usb.c                     |    2 +
 drivers/usb/serial/kl5kusb105.c                 |    1 +
 drivers/usb/serial/kobil_sct.c                  |    3 +-
 drivers/usb/serial/mos7840.c                    |    1 -
 drivers/usb/serial/option.c                     |  180 ++++++++++++++
 drivers/usb/serial/qcaux.c                      |    5 +
 drivers/usb/serial/spcp8x5.c                    |    4 +-
 drivers/usb/serial/visor.c                      |    1 +
 drivers/usb/storage/unusual_devs.h              |   15 ++
 drivers/vhost/net.c                             |    2 +-
 drivers/video/arcfb.c                           |    8 +-
 drivers/video/hgafb.c                           |   10 +-
 drivers/video/vfb.c                             |    4 +-
 drivers/video/vga16fb.c                         |   10 +-
 drivers/video/w100fb.c                          |   10 +-
 drivers/xen/xenbus/xenbus_xs.c                  |    2 +-
 fs/aio.c                                        |   65 +++--
 fs/btrfs/acl.c                                  |    3 +
 fs/cifs/cifsproto.h                             |    6 +-
 fs/cifs/dir.c                                   |   20 +-
 fs/cifs/file.c                                  |   11 +-
 fs/compat.c                                     |  132 ++++++----
 fs/dcache.c                                     |    1 +
 fs/exofs/dir.c                                  |    2 +-
 fs/ext4/move_extent.c                           |    3 +
 fs/ext4/resize.c                                |    3 +-
 fs/fs-writeback.c                               |   14 +-
 fs/gfs2/file.c                                  |    7 +
 fs/libfs.c                                      |    3 +-
 fs/namei.c                                      |    2 +-
 fs/nfs/write.c                                  |   20 ++-
 fs/nfsd/nfssvc.c                                |    2 +-
 fs/nfsd/vfs.c                                   |   11 +-
 fs/nfsd/vfs.h                                   |    1 +
 include/linux/aio.h                             |    5 +
 include/linux/compat.h                          |    4 +
 include/linux/fs.h                              |    2 +-
 include/linux/miscdevice.h                      |    7 +-
 include/linux/pci_ids.h                         |    1 +
 include/linux/perf_event.h                      |    5 +-
 include/linux/slub_def.h                        |   11 +-
 include/linux/swap.h                            |   10 -
 include/linux/tboot.h                           |    1 +
 include/linux/usb.h                             |    9 +
 include/trace/events/signal.h                   |    3 +-
 kernel/cgroup.c                                 |    2 +-
 kernel/compat.c                                 |   25 +-
 kernel/mutex.c                                  |    7 +
 kernel/perf_event.c                             |  299 +++++++++++++---------
 kernel/posix-timers.c                           |   11 +-
 kernel/signal.c                                 |    6 +-
 lib/idr.c                                       |    5 +-
 mm/filemap.c                                    |   10 +-
 mm/slub.c                                       |   33 +--
 net/mac80211/Kconfig                            |    9 +
 net/mac80211/cfg.c                              |    7 +-
 net/mac80211/mlme.c                             |   40 +++-
 net/mac80211/rx.c                               |    3 +-
 net/mac80211/tx.c                               |    5 +-
 scripts/kconfig/Makefile                        |    2 +-
 sound/core/pcm_lib.c                            |   13 +-
 sound/core/pcm_native.c                         |   39 +---
 sound/pci/hda/hda_intel.c                       |    9 +-
 sound/pci/hda/patch_realtek.c                   |    1 +
 sound/pci/hda/patch_sigmatel.c                  |    2 +-
 sound/soc/codecs/wm8350.c                       |    4 +-
 sound/soc/codecs/wm8400.c                       |   18 +-
 sound/soc/codecs/wm8990.c                       |   18 +-
 sound/soc/imx/imx-pcm-dma-mx2.c                 |    7 +-
 tools/perf/bench/mem-memcpy.c                   |    2 +-
 tools/perf/bench/sched-messaging.c              |    4 +-
 tools/perf/builtin-annotate.c                   |    8 +-
 tools/perf/builtin-buildid-cache.c              |    2 +-
 tools/perf/builtin-buildid-list.c               |    4 +-
 tools/perf/builtin-diff.c                       |    4 +-
 tools/perf/builtin-help.c                       |    2 +-
 tools/perf/builtin-lock.c                       |    2 +-
 tools/perf/builtin-probe.c                      |    2 +-
 tools/perf/builtin-record.c                     |   24 +-
 tools/perf/builtin-report.c                     |    6 +-
 tools/perf/builtin-sched.c                      |    6 +-
 tools/perf/builtin-stat.c                       |   10 +-
 tools/perf/builtin-timechart.c                  |    2 +-
 tools/perf/builtin-top.c                        |   47 +++--
 tools/perf/builtin-trace.c                      |    2 +-
 tools/perf/util/debug.c                         |    2 +-
 tools/perf/util/debug.h                         |    3 +-
 tools/perf/util/parse-options.c                 |    6 +
 tools/perf/util/parse-options.h                 |    4 +-
 tools/perf/util/symbol.c                        |   25 +-
 tools/perf/util/symbol.h                        |   15 ++
 tools/perf/util/trace-event-parse.c             |    2 +-
 tools/perf/util/trace-event.h                   |    3 +-
 229 files changed, 2312 insertions(+), 1134 deletions(-)
