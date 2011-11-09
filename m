Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab1KIVfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:35:55 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51401 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704Ab1KIVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:35:53 -0500
X-Sasl-enc: GnVqjzEG6BZY6zgAhlDMByndb6GcqRn9YRgtQDiaam5M 1320874552
Date: Wed, 9 Nov 2011 13:28:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [000/262] 3.0.9-stable review
Message-ID: <20111109212847.GA20838@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.9 release.
There are 262 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, November 11, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/hwspinlock.txt                     |   18 +--
 Documentation/power/runtime_pm.txt               |   10 ++
 Documentation/stable_kernel_rules.txt            |   14 +-
 MAINTAINERS                                      |   14 +-
 Makefile                                         |    4 +-
 arch/arm/mach-ux500/cpu.c                        |   25 +++-
 arch/arm/plat-mxc/include/mach/iomux-v3.h        |   10 +-
 arch/powerpc/include/asm/sparsemem.h             |    2 +-
 arch/powerpc/mm/gup.c                            |   12 --
 arch/powerpc/mm/hash_utils_64.c                  |    6 +-
 arch/powerpc/mm/hugetlbpage.c                    |   21 ++-
 arch/powerpc/mm/mem.c                            |    3 +-
 arch/powerpc/mm/mmu_context_hash64.c             |   12 +-
 arch/powerpc/mm/numa.c                           |    3 +-
 arch/powerpc/platforms/pseries/dlpar.c           |    4 +
 arch/powerpc/platforms/pseries/eeh.c             |    2 +-
 arch/s390/kernel/ptrace.c                        |   28 ++--
 arch/s390/kvm/kvm-s390.c                         |   14 ++-
 arch/s390/mm/gup.c                               |   14 ++-
 arch/s390/mm/pgtable.c                           |    5 +-
 arch/um/drivers/ubd_kern.c                       |   31 ++++-
 arch/x86/include/asm/apic.h                      |    2 +-
 arch/x86/include/asm/uv/uv_bau.h                 |    1 +
 arch/x86/include/asm/uv/uv_hub.h                 |   37 +++++-
 arch/x86/kernel/amd_iommu.c                      |    2 +-
 arch/x86/kernel/apic/bigsmp_32.c                 |   20 ++-
 arch/x86/kernel/apic/probe_32.c                  |   10 +-
 arch/x86/kernel/apic/x2apic_uv_x.c               |    7 +-
 arch/x86/kernel/kprobes.c                        |    4 +-
 arch/x86/mm/gup.c                                |   10 --
 arch/x86/platform/uv/tlb_uv.c                    |   17 +--
 block/genhd.c                                    |    8 +
 crypto/cryptd.c                                  |    2 +-
 drivers/acpi/atomicio.c                          |    2 +-
 drivers/ata/ata_piix.c                           |   37 ++++-
 drivers/base/power/runtime.c                     |   18 ++-
 drivers/block/cciss.c                            |    7 +
 drivers/block/xen-blkback/blkback.c              |    2 +-
 drivers/bluetooth/ath3k.c                        |    6 +
 drivers/bluetooth/btusb.c                        |   22 +++-
 drivers/gpu/drm/i915/intel_dp.c                  |   31 ++++-
 drivers/gpu/drm/i915/intel_panel.c               |   21 ++-
 drivers/gpu/drm/radeon/atombios_dp.c             |   11 ++
 drivers/gpu/drm/radeon/evergreen.c               |    1 +
 drivers/gpu/drm/radeon/r100.c                    |    1 +
 drivers/gpu/drm/radeon/r600.c                    |   19 +--
 drivers/gpu/drm/radeon/radeon.h                  |    1 +
 drivers/gpu/drm/radeon/radeon_combios.c          |    4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c       |   29 ++++-
 drivers/gpu/drm/radeon/radeon_drv.c              |    4 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c          |   48 ++++++-
 drivers/gpu/drm/radeon/radeon_mode.h             |    1 +
 drivers/gpu/drm/radeon/rs600.c                   |    1 +
 drivers/hid/Kconfig                              |    3 +-
 drivers/hid/hid-apple.c                          |   27 ++++
 drivers/hid/hid-core.c                           |   17 ++
 drivers/hid/hid-ids.h                            |   17 ++
 drivers/hid/hid-multitouch.c                     |    5 +
 drivers/hid/usbhid/hid-quirks.c                  |    1 +
 drivers/hwmon/coretemp.c                         |    3 +-
 drivers/hwmon/w83627ehf.c                        |   12 ++-
 drivers/hwspinlock/hwspinlock_core.c             |   45 +++---
 drivers/leds/led-class.c                         |    7 +-
 drivers/md/raid5.c                               |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c         |   81 +++++++++-
 drivers/media/dvb/frontends/dib0070.c            |   37 ++++-
 drivers/media/dvb/frontends/dib0090.c            |   70 ++++++++--
 drivers/media/dvb/frontends/dib7000m.c           |   27 +++-
 drivers/media/dvb/frontends/dib7000p.c           |   32 ++++-
 drivers/media/dvb/frontends/dib8000.c            |   72 ++++++++--
 drivers/media/dvb/frontends/dib9000.c            |  164 ++++++++++++++++++---
 drivers/media/dvb/frontends/dibx000_common.c     |   76 ++++++++--
 drivers/media/dvb/frontends/dibx000_common.h     |    1 +
 drivers/media/video/cx23885/cx23885-dvb.c        |    2 +-
 drivers/media/video/uvc/uvc_driver.c             |    2 +-
 drivers/media/video/uvc/uvc_video.c              |   10 +-
 drivers/media/video/uvc/uvcvideo.h               |    2 +-
 drivers/mmc/core/core.c                          |   10 +-
 drivers/mmc/core/core.h                          |    1 +
 drivers/mmc/core/mmc.c                           |    3 +
 drivers/mmc/core/sd.c                            |    1 +
 drivers/mmc/core/sdio.c                          |    1 +
 drivers/mtd/mtdchar.c                            |    1 +
 drivers/mtd/nand/nand_base.c                     |   27 ++--
 drivers/mtd/nand/pxa3xx_nand.c                   |   14 +-
 drivers/mtd/redboot.c                            |    3 +
 drivers/net/bonding/bond_main.c                  |    7 +-
 drivers/net/enic/enic_main.c                     |    8 +-
 drivers/net/macvlan.c                            |    2 +-
 drivers/net/netconsole.c                         |    5 +
 drivers/net/phy/dp83640.c                        |    9 +-
 drivers/net/rionet.c                             |    4 +-
 drivers/net/tg3.c                                |    2 +-
 drivers/net/usb/asix.c                           |    7 +-
 drivers/net/usb/cdc_ncm.c                        |   47 +++++-
 drivers/net/usb/ipheth.c                         |    5 +
 drivers/net/usb/rtl8150.c                        |    1 -
 drivers/net/wireless/ath/ath9k/ani.c             |    5 -
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c      |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h      |   12 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |   10 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c         |    1 +
 drivers/net/wireless/ath/ath9k/hw.c              |    4 +
 drivers/net/wireless/ath/ath9k/recv.c            |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c            |    2 +-
 drivers/net/wireless/wl12xx/scan.c               |   19 ++-
 drivers/net/xen-netback/interface.c              |    4 +-
 drivers/pci/quirks.c                             |   28 ++--
 drivers/pci/xen-pcifront.c                       |    5 +-
 drivers/platform/x86/samsung-laptop.c            |   39 +++++-
 drivers/platform/x86/wmi.c                       |    6 +-
 drivers/power/ds2780_battery.c                   |   86 +++++++-----
 drivers/s390/cio/ccwgroup.c                      |   42 +++---
 drivers/scsi/device_handler/scsi_dh.c            |   10 +-
 drivers/scsi/hosts.c                             |    9 +-
 drivers/scsi/hpsa.c                              |    7 +
 drivers/scsi/ipr.c                               |    2 +-
 drivers/scsi/isci/isci.h                         |    2 +-
 drivers/scsi/isci/port_config.c                  |    2 +-
 drivers/scsi/isci/request.c                      |   49 +++----
 drivers/scsi/isci/request.h                      |    3 -
 drivers/scsi/isci/sas.h                          |    2 -
 drivers/scsi/libsas/sas_expander.c               |    2 +
 drivers/scsi/megaraid/megaraid_sas_base.c        |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c             |   15 ++-
 drivers/scsi/scsi_lib.c                          |    9 +
 drivers/scsi/scsi_scan.c                         |    1 +
 drivers/scsi/st.c                                |    4 +-
 drivers/staging/hv/hyperv_storage.h              |    1 +
 drivers/staging/hv/storvsc_drv.c                 |    2 +
 drivers/staging/quatech_usb2/quatech_usb2.c      |    9 +-
 drivers/staging/serqt_usb2/serqt_usb2.c          |    3 -
 drivers/target/loopback/tcm_loop.c               |   18 +++
 drivers/target/target_core_alua.c                |   20 +++
 drivers/tty/pty.c                                |   26 ++--
 drivers/tty/serial/crisv10.c                     |    4 +-
 drivers/tty/serial/jsm/jsm.h                     |    7 -
 drivers/tty/serial/jsm/jsm_driver.c              |    1 -
 drivers/tty/serial/jsm/jsm_neo.c                 |   29 ++--
 drivers/tty/serial/jsm/jsm_tty.c                 |   94 ++----------
 drivers/tty/serial/pxa.c                         |   20 +++
 drivers/tty/serial/serial_core.c                 |    2 +
 drivers/tty/tty_io.c                             |   48 +++++--
 drivers/usb/class/cdc-acm.c                      |    3 +
 drivers/usb/core/devio.c                         |   27 +++-
 drivers/usb/core/driver.c                        |    7 +-
 drivers/usb/core/hcd.c                           |    2 +
 drivers/usb/core/quirks.c                        |   24 +++
 drivers/usb/gadget/printer.c                     |    2 +-
 drivers/usb/host/ehci-dbg.c                      |    2 +-
 drivers/usb/host/ehci-hcd.c                      |   32 ++++-
 drivers/usb/host/ehci-hub.c                      |   12 ++
 drivers/usb/host/ehci-pci.c                      |    5 +
 drivers/usb/host/ehci-sched.c                    |   30 +++-
 drivers/usb/host/ehci.h                          |   17 ++
 drivers/usb/host/fhci-sched.c                    |   19 ++-
 drivers/usb/host/isp1760-hcd.c                   |    3 +
 drivers/usb/host/ohci-hub.c                      |    5 +-
 drivers/usb/host/xhci-hub.c                      |   22 ++-
 drivers/usb/host/xhci-mem.c                      |   54 ++++---
 drivers/usb/host/xhci-pci.c                      |    3 +
 drivers/usb/host/xhci-ring.c                     |   82 +++++++----
 drivers/usb/host/xhci.c                          |    6 +
 drivers/usb/host/xhci.h                          |    3 +
 drivers/usb/mon/mon_bin.c                        |    2 +-
 drivers/usb/serial/ftdi_sio.c                    |    5 +
 drivers/usb/serial/ftdi_sio_ids.h                |   13 ++-
 drivers/usb/serial/option.c                      |  170 ++++++++++++++--------
 drivers/usb/serial/pl2303.c                      |    1 +
 drivers/usb/serial/pl2303.h                      |    5 +
 drivers/usb/serial/qcserial.c                    |    3 +
 drivers/usb/storage/transport.c                  |   34 +++--
 drivers/usb/storage/usb.c                        |   16 ++-
 drivers/video/carminefb.c                        |    6 +-
 drivers/video/fbmem.c                            |    3 -
 drivers/video/fbsysfs.c                          |    3 +
 drivers/video/sh_mobile_hdmi.c                   |   47 ++++---
 drivers/video/via/via_modesetting.h              |    5 +
 drivers/video/via/viafbdev.c                     |   16 ++-
 drivers/w1/slaves/w1_ds2780.c                    |   48 +++++--
 drivers/w1/slaves/w1_ds2780.h                    |    2 +
 drivers/xen/events.c                             |    2 +-
 drivers/xen/swiotlb-xen.c                        |    7 +-
 fs/binfmt_elf.c                                  |   11 ++-
 fs/block_dev.c                                   |   13 +-
 fs/cifs/connect.c                                |    4 +-
 fs/cifs/inode.c                                  |   19 ++-
 fs/eventpoll.c                                   |   25 +++-
 fs/ext4/ext4.h                                   |    4 +-
 fs/ext4/inode.c                                  |    3 -
 fs/ext4/namei.c                                  |    8 +-
 fs/ext4/page-io.c                                |   18 ++-
 fs/ext4/xattr.c                                  |    6 +
 fs/hppfs/hppfs.c                                 |    1 +
 fs/namei.c                                       |   55 +++++--
 fs/namespace.c                                   |    3 +-
 fs/nfs/super.c                                   |    2 +-
 fs/nfs/write.c                                   |   43 ++----
 fs/nfsd/nfs4proc.c                               |    6 +-
 fs/nfsd/nfs4recover.c                            |    2 +-
 fs/nfsd/nfs4state.c                              |   30 +++--
 fs/nfsd/nfs4xdr.c                                |   12 ++
 fs/nfsd/state.h                                  |    6 -
 fs/nfsd/vfs.c                                    |    3 +-
 fs/nfsd/vfs.h                                    |    1 +
 fs/proc/base.c                                   |   10 +-
 fs/proc/task_mmu.c                               |    3 +
 fs/quota/quota.c                                 |    2 +-
 fs/stat.c                                        |    5 +-
 fs/statfs.c                                      |    2 +-
 include/drm/drm_dp_helper.h                      |    3 +
 include/linux/ext2_fs.h                          |    4 +-
 include/linux/ext3_fs.h                          |    4 +-
 include/linux/interrupt.h                        |    3 +
 include/linux/io-mapping.h                       |    4 +
 include/linux/jiffies.h                          |    2 +-
 include/linux/mm.h                               |   67 ++++-----
 include/linux/mm_types.h                         |   22 +++-
 include/linux/namei.h                            |    2 +
 include/linux/phy.h                              |    2 +-
 include/linux/skbuff.h                           |    7 +-
 include/linux/tty.h                              |    4 +-
 include/linux/usb/hcd.h                          |    2 +-
 include/linux/vmalloc.h                          |    1 +
 include/net/flow.h                               |   25 +++-
 kernel/irq/pm.c                                  |   48 +++++-
 kernel/kmod.c                                    |    4 +-
 kernel/power/suspend.c                           |    2 +-
 kernel/signal.c                                  |    4 +-
 kernel/time.c                                    |    2 +-
 kernel/trace/trace.c                             |    4 +-
 lib/kobject_uevent.c                             |    2 +-
 lib/nlattr.c                                     |    1 +
 mm/huge_memory.c                                 |   37 ++++--
 mm/internal.h                                    |   46 ++++++
 mm/memory.c                                      |    2 +-
 mm/swap.c                                        |   83 +++++++----
 mm/vmalloc.c                                     |   65 ++++++--
 net/bridge/br_device.c                           |    3 -
 net/bridge/br_if.c                               |    9 +-
 net/bridge/br_netlink.c                          |    1 +
 net/bridge/br_private.h                          |    1 +
 net/caif/caif_dev.c                              |    5 +-
 net/can/bcm.c                                    |   53 +++----
 net/core/dev.c                                   |    1 +
 net/core/flow.c                                  |   31 ++--
 net/core/sock.c                                  |    1 +
 net/core/timestamping.c                          |   12 ++-
 net/ipv4/tcp_input.c                             |    4 +-
 net/ipv4/tcp_ipv4.c                              |   11 +-
 net/ipv4/xfrm4_policy.c                          |   14 +-
 net/ipv6/tcp_ipv6.c                              |   11 +-
 net/l2tp/l2tp_core.c                             |    4 +-
 net/mac80211/cfg.c                               |    2 +-
 net/mac80211/ieee80211_i.h                       |    2 +
 net/mac80211/mlme.c                              |   18 ++-
 net/mac80211/status.c                            |    2 +-
 net/mac80211/work.c                              |    9 +-
 net/packet/af_packet.c                           |    5 +-
 net/sunrpc/auth_unix.c                           |    3 +
 scripts/kconfig/menu.c                           |    7 +-
 sound/pci/hda/patch_conexant.c                   |   30 ++++-
 sound/pci/hda/patch_realtek.c                    |   14 +-
 sound/pci/hda/patch_sigmatel.c                   |   56 +++-----
 sound/soc/codecs/ak4535.c                        |   10 +-
 sound/soc/codecs/ak4642.c                        |   22 ++--
 sound/soc/codecs/wm8711.c                        |    4 +-
 sound/soc/codecs/wm8741.c                        |    4 +-
 sound/soc/codecs/wm8904.c                        |    2 +-
 sound/soc/codecs/wm8940.c                        |    2 +
 sound/soc/codecs/wm8962.c                        |   38 +++--
 sound/soc/codecs/wm8994.c                        |    2 +-
 sound/usb/misc/ua101.c                           |   28 +++-
 tools/perf/util/probe-event.c                    |    4 +-
 280 files changed, 2892 insertions(+), 1239 deletions(-)
