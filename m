Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0GARwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:52:24 -0400
Received: from kroah.org ([198.145.64.141]:41026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0GARwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:52:17 -0400
Date: Thu, 1 Jul 2010 10:51:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 000/149] 2.6.32.16 stable review
Message-ID: <20100701175144.GA2116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701175100.GA2078@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.16 release.
There are 149 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sat, July 3, 17:00:00 UTC UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.16-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/hwmon/ltc4245                 |    4 +-
 Documentation/networking/3c509.txt          |   12 +-
 Makefile                                    |    2 +-
 arch/arm/common/sa1111.c                    |    9 +-
 arch/arm/mm/copypage-feroceon.c             |    4 +-
 arch/arm/mm/copypage-v4wb.c                 |    4 +-
 arch/arm/mm/copypage-v4wt.c                 |    4 +-
 arch/arm/mm/copypage-xsc3.c                 |    4 +-
 arch/arm/mm/fault.c                         |    3 +
 arch/arm/mm/init.c                          |    6 +-
 arch/arm/vfp/vfphw.S                        |    2 +-
 arch/blackfin/include/asm/cache.h           |    2 +
 arch/frv/include/asm/cache.h                |    2 +
 arch/m68k/include/asm/cache.h               |    2 +
 arch/mn10300/include/asm/cache.h            |    2 +
 arch/parisc/math-emu/decode_exc.c           |    1 +
 arch/powerpc/kvm/powerpc.c                  |    3 +-
 arch/powerpc/lib/string.S                   |    4 +-
 arch/powerpc/oprofile/op_model_cell.c       |    2 +-
 arch/powerpc/platforms/pseries/smp.c        |    6 +
 arch/s390/kvm/kvm-s390.c                    |    4 +-
 arch/x86/include/asm/kvm_host.h             |    1 +
 arch/x86/include/asm/msr-index.h            |    5 +-
 arch/x86/kernel/amd_iommu.c                 |    2 +-
 arch/x86/kernel/cpu/perf_event.c            |    5 +-
 arch/x86/kernel/pvclock.c                   |   24 +++
 arch/x86/kernel/setup.c                     |   11 ++
 arch/x86/kernel/tboot.c                     |    1 +
 arch/x86/kvm/mmu.c                          |   10 +-
 arch/x86/kvm/vmx.c                          |   32 +++--
 arch/x86/kvm/x86.c                          |   55 ++++---
 arch/x86/oprofile/nmi_int.c                 |   10 +-
 arch/x86/xen/suspend.c                      |    4 +-
 arch/xtensa/include/asm/cache.h             |    1 +
 drivers/acpi/video_detect.c                 |    2 +-
 drivers/ata/libata-core.c                   |    7 +-
 drivers/ata/libata-sff.c                    |    2 +-
 drivers/ata/sata_nv.c                       |    5 +-
 drivers/ata/sata_via.c                      |   13 ++
 drivers/base/cpu.c                          |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c            |   11 +-
 drivers/clocksource/sh_cmt.c                |   21 ++-
 drivers/firewire/core-card.c                |   24 +++-
 drivers/gpu/drm/drm_edid.c                  |    2 +-
 drivers/gpu/drm/i915/i915_gem.c             |   19 +++
 drivers/gpu/drm/i915/intel_lvds.c           |    4 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_cp.c          |    1 +
 drivers/gpu/drm/radeon/radeon_drv.h         |    2 +
 drivers/gpu/drm/radeon/radeon_state.c       |    7 +
 drivers/hid/hid-core.c                      |    1 +
 drivers/hid/hid-gyration.c                  |    1 +
 drivers/hid/hid-ids.h                       |    1 +
 drivers/hwmon/ltc4245.c                     |   18 +--
 drivers/input/mouse/psmouse-base.c          |   14 ++-
 drivers/md/dm-exception-store.h             |    2 +-
 drivers/md/md.c                             |   29 ++++
 drivers/md/raid1.c                          |    9 +-
 drivers/md/raid10.c                         |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c |    2 -
 drivers/net/arcnet/com20020-pci.c           |    4 +-
 drivers/net/atl1e/atl1e_ethtool.c           |    2 +
 drivers/net/can/sja1000/sja1000.c           |   20 ++-
 drivers/net/can/sja1000/sja1000.h           |    1 +
 drivers/net/mlx4/icm.c                      |    3 +-
 drivers/net/pppol2tp.c                      |    3 +-
 drivers/net/tulip/Kconfig                   |    4 +
 drivers/net/tulip/dmfe.c                    |   21 +++
 drivers/net/tulip/tulip_core.c              |   32 +++-
 drivers/net/ucc_geth.c                      |   12 +-
 drivers/net/via-velocity.c                  |    8 +-
 drivers/net/virtio_net.c                    |    3 +-
 drivers/net/wireless/ath/ar9170/hw.h        |    1 +
 drivers/net/wireless/ath/ar9170/main.c      |    2 +-
 drivers/net/wireless/ath/ar9170/usb.c       |   10 ++
 drivers/net/wireless/ath/ath5k/base.c       |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c         |    7 +-
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 drivers/net/wireless/ath/ath9k/main.c       |    4 +-
 drivers/net/wireless/ath/ath9k/pci.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   23 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   24 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   74 +++++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   18 ++-
 drivers/net/wireless/p54/p54usb.c           |    1 +
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    1 +
 drivers/net/wireless/wl12xx/wl1251_sdio.c   |    1 +
 drivers/oprofile/cpu_buffer.c               |   63 ++------
 drivers/pci/quirks.c                        |   14 ++-
 drivers/rtc/rtc-cmos.c                      |    5 +-
 drivers/rtc/rtc-s3c.c                       |    5 +-
 drivers/scsi/qla2xxx/qla_isr.c              |   28 ++--
 drivers/staging/comedi/drivers/ni_mio_cs.c  |    2 +-
 drivers/staging/rtl8192su/r8192U_core.c     |    1 +
 drivers/staging/vt6655/device_main.c        |    2 +
 drivers/usb/class/cdc-acm.c                 |    6 +-
 drivers/usb/gadget/fsl_udc_core.c           |    2 +-
 drivers/usb/host/ehci-hub.c                 |   17 ++
 drivers/usb/host/xhci-hcd.c                 |   54 ++++++-
 drivers/usb/host/xhci-ring.c                |   37 ++++-
 drivers/usb/serial/cp210x.c                 |   11 ++
 drivers/usb/serial/ftdi_sio.c               |    4 +
 drivers/usb/serial/ir-usb.c                 |    2 +
 drivers/usb/serial/kl5kusb105.c             |    1 +
 drivers/usb/serial/kobil_sct.c              |    3 +-
 drivers/usb/serial/mos7840.c                |    1 -
 drivers/usb/serial/option.c                 |  226 +++++++++++++++++++++++++++
 drivers/usb/serial/visor.c                  |    1 +
 drivers/usb/storage/unusual_devs.h          |   15 ++
 drivers/xen/xenbus/xenbus_xs.c              |    2 +-
 fs/btrfs/acl.c                              |    3 +
 fs/cifs/cifsproto.h                         |    6 +-
 fs/cifs/dir.c                               |   20 ++-
 fs/cifs/file.c                              |   11 +-
 fs/exofs/dir.c                              |    2 +-
 fs/ext4/move_extent.c                       |    3 +
 fs/ext4/resize.c                            |    3 +-
 fs/fs-writeback.c                           |   14 ++-
 fs/gfs2/file.c                              |    7 +
 fs/jbd/journal.c                            |    2 +-
 fs/jbd2/journal.c                           |    3 +-
 fs/libfs.c                                  |    3 +-
 fs/namespace.c                              |    9 +-
 fs/nfsd/nfssvc.c                            |    2 +-
 include/linux/fs.h                          |    4 +-
 include/linux/pci_ids.h                     |    1 +
 include/linux/swap.h                        |   10 --
 include/linux/tboot.h                       |    1 +
 include/net/sctp/structs.h                  |    1 +
 kernel/compat.c                             |   25 ++--
 kernel/mutex.c                              |    7 +
 kernel/perf_event.c                         |   40 +++--
 kernel/posix-timers.c                       |   11 +-
 kernel/signal.c                             |    6 +-
 mm/filemap.c                                |   10 +-
 mm/hugetlb.c                                |    2 +-
 net/mac80211/Kconfig                        |    9 +
 net/mac80211/rx.c                           |    3 +-
 net/mac80211/tx.c                           |    5 +-
 net/sctp/sm_make_chunk.c                    |   62 +++++++-
 net/tipc/bearer.c                           |   37 +----
 net/tipc/bearer.h                           |    2 +-
 net/tipc/net.c                              |   25 +---
 net/wireless/core.h                         |    2 +
 net/wireless/nl80211.c                      |   37 +----
 net/wireless/util.c                         |   33 ++++
 net/wireless/wext-compat.c                  |    5 +-
 security/keys/keyring.c                     |   18 +-
 security/keys/process_keys.c                |    6 +-
 sound/pci/hda/hda_intel.c                   |   11 +-
 sound/pci/hda/patch_realtek.c               |    1 +
 sound/pci/hda/patch_sigmatel.c              |    2 +-
 sound/soc/codecs/wm8350.c                   |    4 +-
 sound/soc/codecs/wm8400.c                   |   18 +-
 sound/soc/codecs/wm8990.c                   |   18 +-
 156 files changed, 1251 insertions(+), 489 deletions(-)
