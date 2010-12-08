Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0LHA7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:00 -0500
Received: from kroah.org ([198.145.64.141]:48263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab0LHA64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:58:56 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:21 2010
Message-Id: <20101208005617.390418706@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/289] 2.6.36.2-stable review
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.36.2 release.
There are 289 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, December 9, 2010, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.36.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                           |    2 +-
 arch/arm/include/asm/assembler.h                   |    2 +-
 arch/arm/lib/findbit.S                             |    6 +-
 arch/arm/mach-cns3xxx/pcie.c                       |    2 +-
 arch/arm/mm/fault-armv.c                           |   28 +++-
 arch/arm/plat-omap/dma.c                           |   50 +++++-
 arch/arm/plat-omap/include/plat/dma.h              |    4 +
 arch/microblaze/Makefile                           |    8 +-
 arch/powerpc/mm/hash_utils_64.c                    |    2 +-
 arch/s390/kernel/nmi.c                             |   10 +-
 arch/s390/kernel/vtime.c                           |   19 ++
 arch/s390/lib/delay.c                              |   14 +-
 arch/sh/include/asm/syscalls_32.h                  |    7 +-
 arch/um/drivers/line.c                             |    5 +-
 arch/um/kernel/uml.lds.S                           |    2 +-
 arch/um/os-Linux/time.c                            |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c         |    1 +
 arch/x86/kernel/hw_breakpoint.c                    |    4 +
 arch/x86/kvm/svm.c                                 |    2 +-
 arch/x86/kvm/vmx.c                                 |   19 +-
 arch/x86/kvm/x86.c                                 |   14 +-
 arch/x86/xen/enlighten.c                           |    4 -
 block/blk-map.c                                    |    2 +
 block/blk-settings.c                               |    2 +-
 block/genhd.c                                      |    6 +-
 block/scsi_ioctl.c                                 |   34 +++-
 drivers/acpi/battery.c                             |   38 ++++-
 drivers/acpi/bus.c                                 |    7 +-
 drivers/acpi/debugfs.c                             |    2 +-
 drivers/ata/libata-scsi.c                          |    5 +-
 drivers/ata/sata_via.c                             |    9 +-
 drivers/char/agp/intel-agp.c                       |    1 +
 drivers/char/agp/intel-gtt.c                       |   63 +++----
 drivers/char/hpet.c                                |   17 ++
 drivers/char/ipmi/ipmi_si_intf.c                   |   30 ++-
 drivers/char/tty_buffer.c                          |   14 ++-
 drivers/char/tty_io.c                              |   13 +-
 drivers/char/tty_ldisc.c                           |   51 +++++-
 drivers/char/vt_ioctl.c                            |   11 +-
 drivers/crypto/padlock-aes.c                       |    2 +-
 drivers/firewire/ohci.c                            |   64 +++++--
 drivers/gpio/cs5535-gpio.c                         |   16 ++-
 drivers/gpu/drm/i915/i915_dma.c                    |    3 +
 drivers/gpu/drm/i915/i915_irq.c                    |   21 ++-
 drivers/gpu/drm/i915/i915_reg.h                    |    7 +
 drivers/gpu/drm/i915/i915_suspend.c                |    4 +-
 drivers/gpu/drm/i915/intel_crt.c                   |    3 +-
 drivers/gpu/drm/i915/intel_display.c               |    7 +
 drivers/gpu/drm/i915/intel_drv.h                   |    1 +
 drivers/gpu/drm/i915/intel_overlay.c               |    8 +
 drivers/gpu/drm/i915/intel_sdvo.c                  |    8 +-
 drivers/gpu/drm/radeon/atom.c                      |    1 +
 drivers/gpu/drm/radeon/r100.c                      |    6 +
 drivers/gpu/drm/radeon/r100_track.h                |    1 +
 drivers/gpu/drm/radeon/r200.c                      |    2 +
 drivers/gpu/drm/radeon/r600.c                      |   15 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c             |    8 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |    4 +-
 drivers/gpu/drm/radeon/r600_reg.h                  |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |   16 ++
 drivers/gpu/drm/radeon/radeon_bios.c               |   13 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |   15 ++-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   34 ++++
 drivers/gpu/drm/radeon/radeon_encoders.c           |   36 +++-
 drivers/gpu/drm/radeon/radeon_i2c.c                |    1 +
 drivers/gpu/drm/radeon/radeon_object.c             |    4 +-
 drivers/gpu/drm/radeon/radeon_reg.h                |    1 +
 drivers/gpu/drm/radeon/rv770.c                     |    9 +-
 drivers/hid/hid-egalax.c                           |   16 +-
 drivers/hid/usbhid/hid-quirks.c                    |    1 -
 drivers/hwmon/lm85.c                               |    1 +
 drivers/i2c/busses/i2c-pca-platform.c              |    2 +-
 drivers/input/serio/i8042-x86ia64io.h              |    7 +
 drivers/isdn/gigaset/bas-gigaset.c                 |   89 ++++-----
 drivers/isdn/gigaset/isocdata.c                    |    8 +-
 drivers/leds/leds-ss4200.c                         |    1 +
 drivers/md/md.c                                    |    6 +-
 drivers/md/raid1.c                                 |    1 +
 drivers/media/video/cx23885/cx23885-core.c         |    1 +
 drivers/media/video/gspca/gspca.c                  |    4 +-
 drivers/media/video/gspca/sonixj.c                 |    3 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    1 +
 drivers/media/video/msp3400-driver.c               |    7 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   24 ++--
 drivers/misc/ad525x_dpot-spi.c                     |    4 +-
 drivers/misc/sgi-xp/xpc_partition.c                |   25 ++-
 drivers/mmc/core/core.c                            |    2 +-
 drivers/net/e1000/e1000_main.c                     |   12 +-
 drivers/net/jme.c                                  |   22 ++-
 drivers/net/pcmcia/pcnet_cs.c                      |    1 +
 drivers/net/phy/marvell.c                          |   35 ++--
 drivers/net/r6040.c                                |   22 ++-
 drivers/net/r8169.c                                |   19 +-
 drivers/net/usb/usbnet.c                           |   11 +
 drivers/net/wireless/ath/ath.h                     |    1 +
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |    3 +
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  191 +++++++++++++------
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |   14 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    7 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    2 +-
 drivers/net/wireless/ath/ath9k/common.c            |   11 +
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   20 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    1 +
 drivers/net/wireless/ath/ath9k/init.c              |   40 +++-
 drivers/net/wireless/ath/ath9k/mac.c               |    5 +-
 drivers/net/wireless/ath/ath9k/main.c              |   61 +++++--
 drivers/net/wireless/ath/ath9k/rc.c                |    8 +-
 drivers/net/wireless/ath/ath9k/recv.c              |   45 +++--
 drivers/net/wireless/ath/ath9k/reg.h               |    9 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  112 ++++++------
 drivers/net/wireless/b43/sdio.c                    |    3 +
 drivers/oprofile/timer_int.c                       |   13 ++
 drivers/pci/pci-sysfs.c                            |   22 ++-
 drivers/pci/pci.h                                  |    7 +-
 drivers/pci/proc.c                                 |    2 +-
 drivers/pcmcia/soc_common.c                        |    1 +
 drivers/platform/x86/wmi.c                         |    2 +-
 drivers/pnp/pnpacpi/core.c                         |   29 +++-
 drivers/power/olpc_battery.c                       |    8 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    1 +
 drivers/scsi/qla2xxx/qla_init.c                    |    5 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    5 +
 drivers/serial/mfd.c                               |   18 +-
 drivers/ssb/b43_pci_bridge.c                       |    1 +
 drivers/staging/asus_oled/asus_oled.c              |    8 +-
 drivers/staging/batman-adv/soft-interface.c        |    4 +
 drivers/staging/frontier/tranzport.c               |    2 +-
 drivers/staging/iio/accel/adis16220_core.c         |    2 +-
 drivers/staging/line6/control.c                    |  204 ++++++++++----------
 drivers/staging/line6/midi.c                       |    4 +-
 drivers/staging/line6/pod.c                        |   32 ++--
 drivers/staging/line6/toneport.c                   |    4 +-
 drivers/staging/line6/variax.c                     |   12 +-
 drivers/staging/rt2860/usb_main_dev.c              |    2 +
 drivers/staging/rtl8187se/r8185b_init.c            |   30 ++-
 drivers/staging/samsung-laptop/samsung-laptop.c    |    2 +-
 drivers/staging/udlfb/udlfb.c                      |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    7 +-
 drivers/usb/core/devio.c                           |    7 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
 drivers/usb/host/ehci-dbg.c                        |    2 +-
 drivers/usb/host/ehci-hcd.c                        |   10 +-
 drivers/usb/host/ehci-pci.c                        |   12 ++
 drivers/usb/host/ohci-jz4740.c                     |    2 +-
 drivers/usb/host/xhci-hub.c                        |    7 +
 drivers/usb/host/xhci-mem.c                        |  168 ++++++++++++++++-
 drivers/usb/host/xhci-ring.c                       |    1 -
 drivers/usb/host/xhci.c                            |   18 ++
 drivers/usb/host/xhci.h                            |   32 +++
 drivers/usb/misc/cypress_cy7c63.c                  |    6 +-
 drivers/usb/misc/iowarrior.c                       |    1 +
 drivers/usb/misc/sisusbvga/sisusb.c                |    1 +
 drivers/usb/misc/trancevibrator.c                  |    2 +-
 drivers/usb/misc/usbled.c                          |    2 +-
 drivers/usb/misc/usbsevseg.c                       |   10 +-
 drivers/usb/musb/musb_core.c                       |    1 -
 drivers/usb/serial/ftdi_sio.c                      |    4 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   11 +
 drivers/usb/serial/option.c                        |    2 +-
 drivers/usb/serial/usb-serial.c                    |    3 +
 drivers/usb/storage/sierra_ms.c                    |    2 +-
 drivers/video/backlight/backlight.c                |   12 +-
 drivers/video/via/accel.c                          |    7 +-
 drivers/video/via/via_i2c.c                        |   27 +++-
 drivers/xen/events.c                               |    2 +-
 fs/bio.c                                           |   23 ++-
 fs/cifs/dns_resolve.c                              |    2 +-
 fs/cifs/inode.c                                    |   12 +-
 fs/compat.c                                        |   28 ++--
 fs/ecryptfs/inode.c                                |   11 +-
 fs/exec.c                                          |   36 +++-
 fs/ext4/super.c                                    |    1 +
 fs/fuse/file.c                                     |   10 +
 fs/hostfs/hostfs.h                                 |    3 +-
 fs/hostfs/hostfs_kern.c                            |    2 +-
 fs/hostfs/hostfs_user.c                            |    9 +-
 fs/nfs/file.c                                      |   17 +-
 fs/nfs/nfs4proc.c                                  |    9 +-
 fs/nfs/nfs4state.c                                 |   16 +-
 fs/nfs/pagelist.c                                  |    8 +-
 fs/pipe.c                                          |   14 ++-
 fs/proc/base.c                                     |    2 +-
 fs/reiserfs/ioctl.c                                |    7 +-
 fs/reiserfs/xattr_acl.c                            |    6 +-
 fs/splice.c                                        |   24 +--
 include/linux/binfmts.h                            |    5 +
 include/linux/blkdev.h                             |    4 +-
 include/linux/gfp.h                                |    4 +-
 include/linux/kfifo.h                              |    7 +-
 include/linux/netfilter.h                          |    2 +-
 include/linux/pci_ids.h                            |    1 +
 include/linux/perf_event.h                         |    1 +
 include/linux/pipe_fs_i.h                          |    1 +
 include/linux/radix-tree.h                         |   36 ++--
 include/linux/socket.h                             |    2 +-
 include/linux/tty.h                                |    1 +
 include/net/mac80211.h                             |   16 ++
 ipc/compat.c                                       |    6 +
 ipc/compat_mq.c                                    |    5 +
 ipc/shm.c                                          |    1 +
 kernel/exit.c                                      |    9 +
 kernel/irq/proc.c                                  |    2 +-
 kernel/latencytop.c                                |   17 +-
 kernel/perf_event.c                                |   22 ++-
 kernel/pm_qos_params.c                             |    4 +-
 kernel/power/hibernate.c                           |   22 ++-
 kernel/power/suspend.c                             |    5 +-
 kernel/power/user.c                                |    2 +
 kernel/sched.c                                     |   12 ++
 lib/percpu_counter.c                               |    1 +
 lib/radix-tree.c                                   |   83 ++++++---
 mm/filemap.c                                       |   29 ++--
 mm/hugetlb.c                                       |    8 +-
 mm/internal.h                                      |    2 +-
 mm/memcontrol.c                                    |   43 +++--
 mm/memory_hotplug.c                                |    2 +-
 mm/mempolicy.c                                     |    2 +-
 mm/mprotect.c                                      |    2 +-
 mm/nommu.c                                         |    1 +
 mm/page_alloc.c                                    |   21 ++-
 net/8021q/vlan_core.c                              |    3 +
 net/can/bcm.c                                      |    2 +-
 net/compat.c                                       |   10 +-
 net/core/dev.c                                     |   19 ++-
 net/core/filter.c                                  |   64 ++++---
 net/core/iovec.c                                   |   20 +-
 net/decnet/af_decnet.c                             |    2 +
 net/econet/af_econet.c                             |   91 ++++-----
 net/irda/iriap.c                                   |    3 +-
 net/irda/parameters.c                              |    4 +-
 net/mac80211/agg-tx.c                              |    2 +
 net/mac80211/cfg.c                                 |    5 +-
 net/mac80211/ibss.c                                |    1 +
 net/mac80211/ieee80211_i.h                         |    2 +
 net/mac80211/main.c                                |    3 +-
 net/mac80211/mesh_plink.c                          |   17 ++-
 net/mac80211/mlme.c                                |   48 +++--
 net/mac80211/offchannel.c                          |    7 +
 net/mac80211/rate.c                                |    3 +
 net/mac80211/rc80211_minstrel_ht.c                 |    7 +-
 net/mac80211/status.c                              |    1 +
 net/netfilter/nf_conntrack_core.c                  |    3 +-
 net/rds/rdma.c                                     |    2 +-
 net/socket.c                                       |    4 +
 net/sunrpc/clnt.c                                  |    2 +-
 net/wireless/chan.c                                |   51 +++++
 net/wireless/nl80211.c                             |   11 +-
 net/wireless/reg.c                                 |    2 +-
 net/wireless/scan.c                                |   12 +-
 net/x25/x25_facilities.c                           |   20 ++-
 net/x25/x25_in.c                                   |    2 +
 scripts/kconfig/conf.c                             |    2 +-
 sound/core/oss/mixer_oss.c                         |   12 +-
 sound/core/oss/pcm_oss.c                           |   19 +-
 sound/pci/hda/hda_codec.c                          |    8 +-
 sound/pci/hda/hda_codec.h                          |    1 +
 sound/pci/hda/hda_intel.c                          |   25 ++-
 sound/pci/hda/patch_analog.c                       |    7 +
 sound/pci/hda/patch_ca0110.c                       |    2 +-
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_realtek.c                      |   51 +++++-
 sound/pci/hda/patch_sigmatel.c                     |   16 ++
 sound/pci/intel8x0.c                               |    6 +
 sound/soc/codecs/wm8900.c                          |    6 -
 sound/soc/codecs/wm8961.c                          |    4 +-
 269 files changed, 2563 insertions(+), 1114 deletions(-)

