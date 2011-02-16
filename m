Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1BPARY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:17:24 -0500
Received: from kroah.org ([198.145.64.141]:38535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab1BPARW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:17:22 -0500
Date: Tue, 15 Feb 2011 16:15:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/272] 2.6.37.1-stable review
Message-ID: <20110216001559.GA31413@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, there are still some patches that people have sent me that did not
make it to this release.  They will show up in the next one, this one is
big enough, as I'm sure you will agree.

This is the start of the stable review cycle for the 2.6.37.1 release.
There are 272 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, Feb 18, 2011 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/kernel-parameters.txt            |    1 +
 Makefile                                       |    2 +-
 arch/arm/kernel/head.S                         |   41 ++++---
 arch/arm/mach-s5pv310/cpu.c                    |    2 +-
 arch/arm/mm/init.c                             |    6 +
 arch/arm/oprofile/common.c                     |   12 +--
 arch/avr32/include/asm/syscalls.h              |    9 --
 arch/parisc/kernel/firmware.c                  |   13 +--
 arch/powerpc/boot/dts/p1022ds.dts              |    4 +-
 arch/powerpc/kernel/cpu_setup_6xx.S            |   40 +++---
 arch/powerpc/mm/numa.c                         |    2 +-
 arch/powerpc/platforms/pseries/lpar.c          |   37 ++++++
 arch/powerpc/sysdev/fsl_rio.c                  |    1 -
 arch/sh/include/asm/io.h                       |   10 ++-
 arch/sh/include/asm/pgtable_32.h               |    7 +-
 arch/x86/Kconfig                               |    1 +
 arch/x86/include/asm/mmu_context.h             |    5 +-
 arch/x86/include/asm/uv/uv_bau.h               |    9 +-
 arch/x86/kernel/cpu/mtrr/main.c                |   10 ++-
 arch/x86/kernel/irq.c                          |    3 +-
 arch/x86/kernel/process.c                      |   22 +++-
 arch/x86/platform/uv/tlb_uv.c                  |   22 +++-
 block/blk-core.c                               |   26 +++-
 block/blk-merge.c                              |    3 +-
 block/cfq-iosched.c                            |    4 +
 block/genhd.c                                  |    1 +
 drivers/ata/libata-scsi.c                      |   24 +++-
 drivers/ata/pata_mpc52xx.c                     |    2 +-
 drivers/base/power/runtime.c                   |    9 +-
 drivers/block/nbd.c                            |    3 -
 drivers/char/agp/intel-agp.c                   |   27 +++--
 drivers/char/ipmi/ipmi_si_intf.c               |   12 +--
 drivers/char/tpm/tpm.c                         |   28 ++++-
 drivers/char/tpm/tpm.h                         |    2 +
 drivers/char/tpm/tpm_tis.c                     |   10 +-
 drivers/char/virtio_console.c                  |   15 ++-
 drivers/cpuidle/cpuidle.c                      |   82 ++++++------
 drivers/firewire/core-card.c                   |   11 ++-
 drivers/firmware/dmi_scan.c                    |   11 ++-
 drivers/gpu/drm/Kconfig                        |    3 +
 drivers/gpu/drm/drm_crtc_helper.c              |   17 ++-
 drivers/gpu/drm/i915/i915_dma.c                |   10 ++-
 drivers/gpu/drm/i915/i915_drv.c                |   10 ++-
 drivers/gpu/drm/i915/i915_drv.h                |    1 +
 drivers/gpu/drm/i915/i915_reg.h                |    9 +-
 drivers/gpu/drm/i915/intel_crt.c               |   30 ++++-
 drivers/gpu/drm/i915/intel_display.c           |    4 +-
 drivers/gpu/drm/i915/intel_dp.c                |   23 +++-
 drivers/gpu/drm/i915/intel_drv.h               |    3 +
 drivers/gpu/drm/i915/intel_lvds.c              |   18 ++--
 drivers/gpu/drm/i915/intel_panel.c             |   31 +++++
 drivers/gpu/drm/i915/intel_sdvo.c              |   33 ++----
 drivers/gpu/drm/radeon/atombios_crtc.c         |   18 +++-
 drivers/gpu/drm/radeon/atombios_dp.c           |    4 +-
 drivers/gpu/drm/radeon/evergreen.c             |    7 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c    |   39 +++++-
 drivers/gpu/drm/radeon/radeon_atombios.c       |   47 ++++----
 drivers/gpu/drm/radeon/radeon_display.c        |  132 +++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c    |    6 +-
 drivers/gpu/drm/radeon/radeon_mode.h           |   23 +++-
 drivers/gpu/vga/vgaarb.c                       |    2 +-
 drivers/hwmon/applesmc.c                       |   48 +++-----
 drivers/hwmon/lm63.c                           |   59 +++++++--
 drivers/hwmon/via686a.c                        |   14 ++-
 drivers/i2c/i2c-core.c                         |   14 ++-
 drivers/idle/intel_idle.c                      |   43 +++++++-
 drivers/infiniband/hw/cxgb4/cm.c               |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c               |    6 +-
 drivers/input/input.c                          |   37 ++----
 drivers/input/mouse/bcm5974.c                  |   40 ++++++
 drivers/input/serio/i8042-x86ia64io.h          |   21 +++
 drivers/input/serio/i8042.c                    |    6 +-
 drivers/md/dm-mpath.c                          |   12 --
 drivers/md/dm.c                                |    5 +-
 drivers/md/md.c                                |   27 +++--
 drivers/md/md.h                                |    3 +-
 drivers/media/IR/ir-keytable.c                 |   28 +++--
 drivers/media/dvb/frontends/ix2505v.c          |    2 +-
 drivers/media/radio/radio-aimslab.c            |   23 +---
 drivers/media/video/em28xx/em28xx-cards.c      |    4 +-
 drivers/mmc/host/bfin_sdh.c                    |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c                 |    2 +-
 drivers/net/e1000/e1000_main.c                 |   10 +-
 drivers/net/fec.c                              |    4 +-
 drivers/net/ixgbe/ixgbe_main.c                 |   11 ++-
 drivers/net/virtio_net.c                       |   27 +++--
 drivers/net/wireless/ath/ath9k/ar9002_calib.c  |   10 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c     |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 ++-
 drivers/net/wireless/ath/ath9k/ath9k.h         |    4 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c       |   40 ++++++-
 drivers/net/wireless/ath/ath9k/hif_usb.h       |    1 +
 drivers/net/wireless/ath/ath9k/hw.c            |    6 +-
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 drivers/net/wireless/ath/ath9k/main.c          |    8 +-
 drivers/net/wireless/ath/ath9k/pci.c           |    4 +
 drivers/net/wireless/ath/carl9170/rx.c         |    2 +-
 drivers/net/wireless/ath/key.c                 |    2 +
 drivers/net/wireless/hostap/hostap_cs.c        |   15 +--
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   15 ++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |    6 +
 drivers/net/wireless/p54/txrx.c                |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c          |    1 +
 drivers/pci/pci-stub.c                         |    3 +
 drivers/power/ds2760_battery.c                 |    2 +-
 drivers/power/jz4740-battery.c                 |    7 +
 drivers/rtc/rtc-cmos.c                         |   16 ++-
 drivers/s390/cio/qdio.h                        |    6 +
 drivers/s390/cio/qdio_main.c                   |   43 +++++---
 drivers/s390/crypto/ap_bus.c                   |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c            |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c            |   24 +++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           |   64 ++++++++--
 drivers/scsi/sd.c                              |    9 ++-
 drivers/serial/68360serial.c                   |    1 +
 drivers/serial/8250.c                          |    3 +-
 drivers/ssb/pcmcia.c                           |    2 +-
 drivers/staging/bcm/InterfaceInit.c            |    1 +
 drivers/staging/bcm/InterfaceInit.h            |    1 +
 drivers/staging/brcm80211/sys/wl_mac80211.c    |   45 ++++----
 drivers/staging/comedi/drivers/jr3_pci.c       |    7 +
 drivers/staging/comedi/drivers/ni_labpc.c      |    3 +-
 drivers/staging/hv/blkvsc_drv.c                |    1 +
 drivers/staging/hv/netvsc.c                    |    2 +-
 drivers/staging/hv/netvsc_drv.c                |    2 +-
 drivers/staging/iio/adc/ad7476_core.c          |    2 +-
 drivers/staging/iio/adc/ad799x_core.c          |    2 +-
 drivers/staging/rt2860/chips/rt3090.c          |    3 +-
 drivers/staging/rt2860/chips/rt30xx.c          |    4 +-
 drivers/staging/rt2860/rt_main_dev.c           |    2 -
 drivers/staging/rt2860/usb_main_dev.c          |    1 +
 drivers/staging/rtl8712/usb_intf.c             |  145 +++++++++++++++++-----
 drivers/staging/speakup/kobjects.c             |    2 +-
 drivers/staging/usbip/vhci_hcd.c               |   14 --
 drivers/staging/zram/zram_drv.c                |    4 +
 drivers/tty/n_gsm.c                            |    1 +
 drivers/tty/sysrq.c                            |   19 +++-
 drivers/usb/class/cdc-acm.c                    |    1 +
 drivers/usb/core/hcd-pci.c                     |    7 +-
 drivers/usb/core/hcd.c                         |    2 +-
 drivers/usb/core/hub.c                         |   26 ++++
 drivers/usb/gadget/printer.c                   |   19 ++--
 drivers/usb/host/ehci-au1xxx.c                 |    2 +-
 drivers/usb/host/ehci-hcd.c                    |   27 +++-
 drivers/usb/host/ehci-hub.c                    |    7 +
 drivers/usb/host/ehci-pci.c                    |   41 ++++++-
 drivers/usb/host/ehci-sched.c                  |   79 ++++++++++++
 drivers/usb/host/ehci.h                        |    1 +
 drivers/usb/host/xhci-ring.c                   |    2 +-
 drivers/usb/host/xhci.c                        |   60 ++++------
 drivers/usb/serial/ch341.c                     |   10 ++
 drivers/usb/serial/cp210x.c                    |   16 +--
 drivers/usb/serial/digi_acceleport.c           |   10 --
 drivers/usb/serial/ftdi_sio.c                  |   39 ++++++-
 drivers/usb/serial/ftdi_sio_ids.h              |   32 +++++-
 drivers/usb/serial/generic.c                   |   20 +++
 drivers/usb/serial/io_edgeport.c               |    4 +-
 drivers/usb/serial/io_tables.h                 |    1 +
 drivers/usb/serial/iuu_phoenix.c               |    1 +
 drivers/usb/serial/keyspan.h                   |    4 +
 drivers/usb/serial/keyspan_pda.c               |   17 ---
 drivers/usb/serial/moto_modem.c                |    1 +
 drivers/usb/serial/option.c                    |   23 +++-
 drivers/usb/serial/oti6858.c                   |    1 +
 drivers/usb/serial/pl2303.c                    |   12 ++
 drivers/usb/serial/pl2303.h                    |    1 +
 drivers/usb/serial/qcaux.c                     |    3 +
 drivers/usb/serial/siemens_mpi.c               |    1 +
 drivers/usb/serial/spcp8x5.c                   |    7 +-
 drivers/usb/serial/ti_usb_3410_5052.c          |    2 +-
 drivers/usb/serial/usb-serial.c                |    8 +-
 drivers/usb/serial/usb_debug.c                 |    1 +
 drivers/usb/storage/unusual_cypress.h          |    5 +
 drivers/usb/storage/unusual_devs.h             |   32 +++++
 drivers/video/aty/atyfb_base.c                 |   27 +----
 drivers/video/backlight/88pm860x_bl.c          |    4 +-
 drivers/virtio/virtio_pci.c                    |   20 +---
 drivers/xen/platform-pci.c                     |   21 +--
 fs/cifs/cifsproto.h                            |    2 +-
 fs/cifs/cifssmb.c                              |    4 +-
 fs/cifs/connect.c                              |    4 +-
 fs/cifs/file.c                                 |   21 ++--
 fs/cifs/misc.c                                 |    2 +-
 fs/direct-io.c                                 |   10 +-
 fs/eventpoll.c                                 |   16 ++-
 fs/exofs/inode.c                               |    2 -
 fs/ext4/inode.c                                |    1 +
 fs/ext4/mballoc.c                              |  102 +++++++++------
 fs/ext4/page-io.c                              |   11 +-
 fs/ext4/super.c                                |   41 ++++---
 fs/fs-writeback.c                              |   98 ++++++++++++---
 fs/nfs/delegation.c                            |    6 +-
 fs/nfs/dir.c                                   |   50 ++++----
 fs/nfs/direct.c                                |   34 +++--
 fs/nfs/nfs2xdr.c                               |    6 -
 fs/nfs/nfs3xdr.c                               |    6 -
 fs/nfs/nfs4xdr.c                               |    6 -
 fs/nfsd/nfs4idmap.c                            |    4 +-
 fs/nfsd/nfsd.h                                 |    1 +
 fs/nfsd/nfsproc.c                              |    2 +-
 fs/nilfs2/super.c                              |    3 +-
 fs/partitions/check.c                          |   10 ++-
 fs/proc/kcore.c                                |    2 +-
 include/drm/drm_pciids.h                       |    1 -
 include/linux/blkdev.h                         |    1 +
 include/linux/completion.h                     |    8 +-
 include/linux/dynamic_debug.h                  |   18 +--
 include/linux/genhd.h                          |    2 +
 include/linux/ieee80211.h                      |    2 +-
 include/linux/klist.h                          |    2 +-
 include/linux/kref.h                           |    1 +
 include/linux/lockdep.h                        |    3 +
 include/linux/memory_hotplug.h                 |    6 +
 include/linux/mmzone.h                         |   10 +-
 include/linux/nl80211.h                        |    6 +-
 include/linux/oprofile.h                       |   13 ++-
 include/linux/radix-tree.h                     |   16 +++
 include/linux/security.h                       |   15 +--
 include/linux/sunrpc/xdr.h                     |    4 +-
 include/linux/sysrq.h                          |    3 +
 include/linux/usb/hcd.h                        |    1 +
 include/linux/usb/serial.h                     |    3 +
 include/linux/vmstat.h                         |    5 +
 include/net/cfg80211.h                         |   15 ++-
 include/scsi/scsi.h                            |    1 +
 init/calibrate.c                               |    6 +-
 kernel/irq/migration.c                         |   14 ++-
 kernel/perf_event.c                            |   15 ++-
 kernel/ptrace.c                                |    2 +-
 kernel/sched.c                                 |   22 +++-
 kernel/sched_rt.c                              |    2 +-
 kernel/smp.c                                   |   30 +++++
 kernel/sys.c                                   |    3 +-
 kernel/sysctl.c                                |    3 +-
 kernel/trace/trace.c                           |    6 +-
 kernel/watchdog.c                              |   41 +++----
 kernel/workqueue.c                             |   14 ++-
 lib/dynamic_debug.c                            |    9 +-
 lib/kref.c                                     |   12 ++
 mm/memcontrol.c                                |    7 +-
 mm/memory_hotplug.c                            |    4 +
 mm/migrate.c                                   |   75 ++++--------
 mm/mmzone.c                                    |   21 ---
 mm/page_alloc.c                                |   35 ++++--
 mm/slub.c                                      |    4 +-
 mm/vmscan.c                                    |   23 ++--
 mm/vmstat.c                                    |   68 ++++++++++-
 net/ax25/af_ax25.c                             |    2 +-
 net/core/ethtool.c                             |    2 +-
 net/core/rtnetlink.c                           |    3 +
 net/core/sock.c                                |    2 +-
 net/ipv4/ip_fragment.c                         |   34 +++++
 net/ipv6/ip6_output.c                          |    3 +
 net/mac80211/agg-rx.c                          |   11 +--
 net/mac80211/key.c                             |    6 +
 net/mac80211/rx.c                              |    4 +-
 net/mac80211/tx.c                              |    6 +-
 net/sched/sch_fifo.c                           |    2 -
 net/sunrpc/xdr.c                               |  155 +++++++++++++++++++-----
 net/unix/af_unix.c                             |    2 +-
 net/wireless/reg.c                             |   33 +++++-
 security/capability.c                          |    2 +-
 security/security.c                            |    3 +-
 security/selinux/hooks.c                       |   15 ++-
 security/selinux/nlmsgtab.c                    |    2 +
 security/smack/smack_lsm.c                     |   14 +-
 sound/atmel/ac97c.c                            |    5 +-
 sound/core/hrtimer.c                           |    5 +-
 sound/pci/au88x0/au88x0_pcm.c                  |   24 +++-
 sound/pci/hda/hda_codec.c                      |    3 +
 sound/pci/hda/hda_eld.c                        |    2 +-
 sound/pci/hda/patch_conexant.c                 |    9 ++-
 sound/pci/hda/patch_hdmi.c                     |   51 ++++++++-
 sound/pci/hda/patch_realtek.c                  |    2 +
 sound/pci/hda/patch_sigmatel.c                 |    2 +-
 sound/soc/blackfin/bf5xx-ac97.c                |    4 +-
 sound/soc/blackfin/bf5xx-tdm.c                 |    2 +-
 sound/soc/codecs/wm8990.c                      |   10 +-
 sound/soc/codecs/wm8994.c                      |   17 ++-
 sound/soc/codecs/wm_hubs.c                     |   15 +--
 sound/soc/davinci/davinci-evm.c                |    2 +-
 sound/soc/pxa/corgi.c                          |    4 +-
 sound/soc/pxa/poodle.c                         |    2 +-
 sound/soc/pxa/spitz.c                          |    4 +-
 sound/soc/soc-core.c                           |    2 +-
 sound/usb/midi.c                               |   11 ++-
 sound/usb/usx2y/us122l.c                       |   41 +++---
 287 files changed, 2858 insertions(+), 1280 deletions(-)
