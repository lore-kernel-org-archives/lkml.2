Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab1BPBZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:25:58 -0500
Received: from kroah.org ([198.145.64.141]:49146 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab1BPAWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:22 -0500
Date: Tue, 15 Feb 2011 16:22:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 000/176] 2.6.36.4-stable review
Message-ID: <20110216002212.GA9246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, this is the LAST 2.6.36 kernel to be released.  It is "end of
life" after this release.

This is the start of the stable review cycle for the 2.6.36.4 release.
There are 176 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, Feb 18, 2011 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.36.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/kernel-parameters.txt            |    1 +
 Makefile                                       |    2 +-
 arch/arm/mm/init.c                             |    6 ++
 arch/avr32/include/asm/syscalls.h              |    9 ---
 arch/parisc/kernel/firmware.c                  |   13 +----
 arch/powerpc/boot/dts/p1022ds.dts              |    4 +-
 arch/powerpc/kernel/cpu_setup_6xx.S            |   40 ++++++------
 arch/powerpc/mm/numa.c                         |    2 +-
 arch/powerpc/platforms/pseries/lpar.c          |   37 +++++++++++
 arch/powerpc/sysdev/fsl_rio.c                  |    1 -
 arch/sh/include/asm/io.h                       |   10 +++-
 arch/sh/include/asm/pgtable_32.h               |    7 ++-
 arch/x86/include/asm/mmu_context.h             |    5 +-
 arch/x86/kernel/cpu/mtrr/main.c                |   10 +++-
 arch/x86/kvm/i8259.c                           |    2 +
 arch/x86/kvm/mmu.c                             |   10 ++-
 block/cfq-iosched.c                            |    4 +
 drivers/ata/pata_mpc52xx.c                     |    2 +-
 drivers/char/agp/intel-agp.c                   |   27 +++++---
 drivers/char/ipmi/ipmi_si_intf.c               |   12 +---
 drivers/char/tpm/tpm.c                         |   28 ++++++--
 drivers/char/tpm/tpm.h                         |    2 +
 drivers/char/tpm/tpm_tis.c                     |   28 ++++++++-
 drivers/char/virtio_console.c                  |   15 ++++-
 drivers/cpuidle/cpuidle.c                      |   82 ++++++++++++------------
 drivers/firewire/core-card.c                   |   11 +++-
 drivers/gpu/drm/Kconfig                        |    3 +
 drivers/gpu/drm/drm_crtc_helper.c              |    5 +-
 drivers/gpu/drm/i915/i915_dma.c                |   10 ++-
 drivers/gpu/drm/i915/i915_drv.c                |   10 +++-
 drivers/gpu/drm/i915/i915_reg.h                |    9 ++-
 drivers/gpu/drm/i915/intel_dp.c                |   23 +++++--
 drivers/gpu/drm/i915/intel_lvds.c              |    8 ++
 drivers/gpu/drm/radeon/atombios_dp.c           |    4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c       |   37 +++++++----
 drivers/gpu/drm/radeon/radeon_display.c        |    4 +
 drivers/gpu/vga/vgaarb.c                       |    2 +-
 drivers/hwmon/applesmc.c                       |   48 +++++---------
 drivers/hwmon/lm63.c                           |   59 ++++++++++++++----
 drivers/hwmon/via686a.c                        |   14 +++-
 drivers/i2c/i2c-core.c                         |   14 ++++-
 drivers/infiniband/hw/cxgb4/cm.c               |    2 +-
 drivers/input/mouse/bcm5974.c                  |   40 ++++++++++++
 drivers/input/serio/i8042-x86ia64io.h          |   21 ++++++
 drivers/input/serio/i8042.c                    |    6 ++-
 drivers/md/dm-mpath.c                          |   12 ----
 drivers/md/dm.c                                |    5 +-
 drivers/md/md.c                                |   27 ++++++--
 drivers/md/md.h                                |    3 +-
 drivers/media/radio/radio-aimslab.c            |   23 ++-----
 drivers/media/video/em28xx/em28xx-cards.c      |    4 +-
 drivers/mmc/host/bfin_sdh.c                    |    2 +-
 drivers/net/atlx/atl1.c                        |   10 +++
 drivers/net/fec.c                              |    4 +-
 drivers/net/ixgbe/ixgbe_main.c                 |   11 +++-
 drivers/net/virtio_net.c                       |   27 +++++---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c  |   10 ++--
 drivers/net/wireless/ath/ath9k/ar9002_hw.c     |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h         |    7 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c       |   40 ++++++++++-
 drivers/net/wireless/ath/ath9k/hif_usb.h       |    1 +
 drivers/net/wireless/ath/ath9k/hw.c            |    6 ++-
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 drivers/net/wireless/ath/ath9k/init.c          |    1 -
 drivers/net/wireless/ath/ath9k/main.c          |   64 ++++++++----------
 drivers/net/wireless/ath/ath9k/pci.c           |    4 +
 drivers/net/wireless/ath/ath9k/recv.c          |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   15 +++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |    6 ++
 drivers/net/wireless/p54/txrx.c                |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c          |    1 +
 drivers/pci/pci-stub.c                         |    3 +
 drivers/power/ds2760_battery.c                 |    2 +-
 drivers/power/jz4740-battery.c                 |    7 ++
 drivers/rtc/rtc-cmos.c                         |   16 +++--
 drivers/s390/cio/qdio.h                        |    6 ++
 drivers/s390/cio/qdio_main.c                   |   43 ++++++++----
 drivers/scsi/libsas/sas_scsi_host.c            |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c            |   24 ++++++--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           |   64 +++++++++++++++----
 drivers/scsi/sd.c                              |    9 ++-
 drivers/serial/8250.c                          |    3 +-
 drivers/ssb/pcmcia.c                           |    2 +-
 drivers/staging/comedi/drivers/jr3_pci.c       |    7 ++
 drivers/staging/comedi/drivers/ni_labpc.c      |    3 +-
 drivers/staging/hv/blkvsc_drv.c                |    1 +
 drivers/staging/hv/netvsc.c                    |    2 +-
 drivers/staging/hv/netvsc_drv.c                |    1 +
 drivers/staging/rt2860/chips/rt3090.c          |    3 +-
 drivers/staging/rt2860/chips/rt30xx.c          |    4 +-
 drivers/staging/rt2860/rt_main_dev.c           |    2 -
 drivers/staging/rt2860/usb_main_dev.c          |    1 +
 drivers/staging/usbip/vhci_hcd.c               |   14 ----
 drivers/staging/zram/zram_drv.c                |    4 +
 drivers/usb/class/cdc-acm.c                    |    1 +
 drivers/usb/core/hcd.c                         |    2 +-
 drivers/usb/core/hub.c                         |   26 ++++++++
 drivers/usb/gadget/printer.c                   |   19 +++---
 drivers/usb/host/ehci-au1xxx.c                 |    2 +-
 drivers/usb/host/ehci-hcd.c                    |   27 ++++++--
 drivers/usb/host/ehci-hub.c                    |    7 ++
 drivers/usb/host/ehci-pci.c                    |   41 ++++++++++++-
 drivers/usb/host/ehci-sched.c                  |   79 +++++++++++++++++++++++
 drivers/usb/host/ehci.h                        |    1 +
 drivers/usb/host/xhci.c                        |   14 +++-
 drivers/usb/serial/ch341.c                     |   10 +++
 drivers/usb/serial/cp210x.c                    |   16 +----
 drivers/usb/serial/digi_acceleport.c           |   10 ---
 drivers/usb/serial/ftdi_sio.c                  |   39 +++++++++++-
 drivers/usb/serial/ftdi_sio_ids.h              |   32 ++++++++-
 drivers/usb/serial/generic.c                   |   20 ++++++
 drivers/usb/serial/io_edgeport.c               |    4 +-
 drivers/usb/serial/io_tables.h                 |    1 +
 drivers/usb/serial/iuu_phoenix.c               |    1 +
 drivers/usb/serial/keyspan.h                   |    4 +
 drivers/usb/serial/keyspan_pda.c               |   17 -----
 drivers/usb/serial/moto_modem.c                |    1 +
 drivers/usb/serial/option.c                    |   23 ++++++-
 drivers/usb/serial/oti6858.c                   |    1 +
 drivers/usb/serial/pl2303.c                    |   12 ++++
 drivers/usb/serial/pl2303.h                    |    1 +
 drivers/usb/serial/qcaux.c                     |    3 +
 drivers/usb/serial/siemens_mpi.c               |    1 +
 drivers/usb/serial/spcp8x5.c                   |    7 ++-
 drivers/usb/serial/ti_usb_3410_5052.c          |    2 +-
 drivers/usb/serial/usb-serial.c                |    8 ++-
 drivers/usb/serial/usb_debug.c                 |    1 +
 drivers/usb/storage/unusual_cypress.h          |    5 ++
 drivers/usb/storage/unusual_devs.h             |   32 +++++++++
 drivers/video/backlight/88pm860x_bl.c          |    4 +-
 drivers/virtio/virtio_pci.c                    |   20 +-----
 fs/direct-io.c                                 |   10 ++-
 fs/ext4/inode.c                                |    1 +
 fs/nfs/delegation.c                            |    6 +-
 fs/nfs/direct.c                                |   34 ++++++----
 fs/nilfs2/super.c                              |    3 +-
 fs/proc/kcore.c                                |    2 +-
 include/drm/drm_pciids.h                       |    1 -
 include/linux/ieee80211.h                      |    2 +-
 include/linux/klist.h                          |    2 +-
 include/linux/mmzone.h                         |   10 +--
 include/linux/usb/serial.h                     |    3 +
 include/linux/vmstat.h                         |    5 ++
 include/net/cfg80211.h                         |   15 ++--
 include/scsi/scsi.h                            |    1 +
 init/calibrate.c                               |    6 +-
 kernel/ptrace.c                                |    2 +-
 kernel/smp.c                                   |   30 +++++++++
 kernel/sys.c                                   |    3 +-
 kernel/watchdog.c                              |   23 ++++---
 mm/memcontrol.c                                |    1 +
 mm/migrate.c                                   |   48 ++++++--------
 mm/mmzone.c                                    |   21 ------
 mm/page_alloc.c                                |   35 ++++++++--
 mm/vmscan.c                                    |   23 ++++---
 mm/vmstat.c                                    |   68 +++++++++++++++++++-
 net/core/rtnetlink.c                           |    3 +
 net/mac80211/agg-rx.c                          |   11 +---
 net/mac80211/key.c                             |    6 ++
 net/mac80211/rx.c                              |    4 +-
 net/mac80211/tx.c                              |    6 ++-
 net/wireless/reg.c                             |   13 +++-
 security/keys/request_key.c                    |    1 -
 security/selinux/hooks.c                       |    5 +-
 security/selinux/nlmsgtab.c                    |    2 +
 sound/atmel/ac97c.c                            |    5 +-
 sound/core/hrtimer.c                           |    5 +-
 sound/pci/au88x0/au88x0_pcm.c                  |   24 ++++++-
 sound/pci/hda/hda_eld.c                        |    2 +-
 sound/pci/hda/patch_conexant.c                 |    8 ++-
 sound/pci/hda/patch_realtek.c                  |    1 +
 sound/soc/blackfin/bf5xx-ac97.c                |    4 +-
 sound/soc/blackfin/bf5xx-tdm.c                 |    2 +-
 sound/soc/codecs/wm8990.c                      |   10 ++--
 sound/soc/codecs/wm8994.c                      |   17 ++++--
 sound/soc/codecs/wm_hubs.c                     |   15 ++--
 sound/usb/midi.c                               |   11 +++-
 sound/usb/usx2y/us122l.c                       |   41 ++++++------
 180 files changed, 1578 insertions(+), 687 deletions(-)
