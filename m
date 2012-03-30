Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375Ab2C3T6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:58:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33099 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761360Ab2C3T62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:58:28 -0400
Date: Fri, 30 Mar 2012 12:58:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/149] 3.2.14-stable review
Message-ID: <20120330195823.GA31857@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.14 release.
There are 149 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Apr  1 19:48:28 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.14-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                          |    4 +-
 arch/arm/mach-tegra/Kconfig                       |   12 ++
 arch/x86/include/asm/kvm_emulate.h                |   16 ++
 arch/x86/kernel/apic/io_apic.c                    |   40 ++++-
 arch/x86/kernel/entry_32.S                        |   17 +-
 arch/x86/kernel/tls.c                             |    4 +-
 arch/x86/kernel/tsc.c                             |   10 ++
 arch/x86/kernel/vm86_32.c                         |    2 +
 arch/x86/kvm/emulate.c                            |   51 ++++++
 arch/x86/kvm/x86.c                                |   23 +++
 arch/x86/net/bpf_jit_comp.c                       |   14 +-
 drivers/ata/pata_legacy.c                         |    3 +-
 drivers/base/power/domain.c                       |    3 +-
 drivers/bluetooth/ath3k.c                         |    1 +
 drivers/bluetooth/btusb.c                         |   10 +-
 drivers/char/tpm/Kconfig                          |    1 -
 drivers/char/tpm/tpm.c                            |    3 +-
 drivers/firewire/ohci.c                           |    5 +-
 drivers/gpio/gpio-davinci.c                       |   26 +--
 drivers/gpio/gpio-omap.c                          |    5 +-
 drivers/gpu/drm/i915/i915_drv.c                   |    7 +
 drivers/gpu/drm/i915/i915_gem.c                   |    7 +-
 drivers/gpu/drm/i915/intel_drv.h                  |    2 +-
 drivers/gpu/drm/i915/intel_fb.c                   |   10 ++
 drivers/gpu/drm/radeon/radeon_atombios.c          |   14 ++
 drivers/gpu/drm/radeon/radeon_connectors.c        |    4 +
 drivers/gpu/drm/radeon/radeon_cursor.c            |   13 +-
 drivers/gpu/drm/radeon/radeon_object.c            |   18 ++-
 drivers/gpu/drm/radeon/radeon_object.h            |    2 +
 drivers/hid/hid-chicony.c                         |    7 +
 drivers/hid/hid-core.c                            |    1 +
 drivers/hid/hid-ids.h                             |    1 +
 drivers/hwmon/fam15h_power.c                      |    2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c          |   18 +--
 drivers/infiniband/ulp/iser/iscsi_iser.h          |    1 +
 drivers/infiniband/ulp/iser/iser_initiator.c      |   30 ++--
 drivers/iommu/amd_iommu.c                         |    2 +-
 drivers/md/bitmap.c                               |    2 +
 drivers/md/dm-crypt.c                             |   38 ++---
 drivers/md/dm-exception-store.c                   |    2 +-
 drivers/md/dm-thin.c                              |  124 +++++++++------
 drivers/md/md.c                                   |   40 ++---
 drivers/md/persistent-data/dm-btree-remove.c      |  174 ++++++++++++---------
 drivers/md/raid1.c                                |   17 +-
 drivers/md/raid10.c                               |   17 +-
 drivers/media/dvb/dvb-usb/mxl111sf.c              |    6 +-
 drivers/media/dvb/frontends/lgdt330x.c            |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c     |   10 ++
 drivers/mtd/ubi/scan.c                            |    8 +-
 drivers/mtd/ubi/wl.c                              |   10 +-
 drivers/net/ethernet/intel/e1000e/e1000.h         |    1 +
 drivers/net/ethernet/intel/e1000e/netdev.c        |   23 ++-
 drivers/net/ethernet/marvell/sky2.c               |   11 ++
 drivers/net/usb/usbnet.c                          |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |   18 +--
 drivers/net/wireless/p54/p54spi.c                 |   14 +-
 drivers/net/wireless/rt2x00/rt2800usb.c           |    1 +
 drivers/net/wireless/rtlwifi/pci.c                |   18 ++-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   15 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |    2 +
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c       |   14 +-
 drivers/net/wireless/rtlwifi/usb.c                |   12 +-
 drivers/rtc/interface.c                           |   20 ++-
 drivers/rtc/rtc-mpc5121.c                         |    2 +
 drivers/staging/rtl8712/Kconfig                   |    7 -
 drivers/staging/rtl8712/os_intfs.c                |    2 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c     |    8 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c         |    5 +-
 drivers/staging/rtl8712/sta_info.h                |    4 -
 drivers/staging/zcache/zcache-main.c              |    4 +-
 drivers/target/iscsi/iscsi_target.c               |   14 +-
 drivers/target/iscsi/iscsi_target_configfs.c      |    6 +-
 drivers/target/loopback/tcm_loop.c                |    6 +
 drivers/target/target_core_alua.c                 |    7 +-
 drivers/target/target_core_cdb.c                  |    2 +-
 drivers/target/target_core_device.c               |    6 +-
 drivers/target/tcm_fc/tfc_cmd.c                   |    6 +-
 drivers/tty/moxa.c                                |    2 +-
 drivers/tty/serial/amba-pl011.c                   |   15 +-
 drivers/tty/serial/sh-sci.c                       |   15 +-
 drivers/tty/vt/consolemap.c                       |   51 +++++-
 drivers/usb/class/cdc-wdm.c                       |   17 +-
 drivers/usb/dwc3/gadget.c                         |   24 ++-
 drivers/usb/gadget/f_subset.c                     |   34 ++--
 drivers/usb/gadget/fsl_udc_core.c                 |   18 +--
 drivers/usb/gadget/hid.c                          |    6 +-
 drivers/usb/gadget/inode.c                        |    2 +
 drivers/usb/host/ehci-fsl.c                       |    4 +
 drivers/usb/host/ehci-fsl.h                       |    1 +
 drivers/usb/host/fsl-mph-dr-of.c                  |    1 -
 drivers/usb/musb/musb_gadget.c                    |   18 +++
 drivers/usb/renesas_usbhs/mod_gadget.c            |    6 +
 drivers/usb/serial/cp210x.c                       |   44 +++++-
 drivers/usb/serial/ftdi_sio.c                     |   32 +++-
 drivers/usb/serial/ftdi_sio.h                     |    3 +-
 drivers/usb/serial/ftdi_sio_ids.h                 |   19 ++-
 drivers/usb/serial/generic.c                      |    4 +-
 drivers/usb/serial/mos7840.c                      |   83 +++++++---
 drivers/usb/serial/option.c                       |   16 ++
 drivers/usb/serial/qcserial.c                     |  109 ++++++++-----
 drivers/usb/storage/realtek_cr.c                  |    8 +-
 drivers/video/backlight/tosa_lcd.c                |    2 +-
 drivers/video/fbmem.c                             |   18 ++-
 drivers/video/udlfb.c                             |    2 +-
 drivers/video/uvesafb.c                           |   12 +-
 fs/cifs/cifsfs.c                                  |    8 +-
 fs/cifs/cifsglob.h                                |   10 +-
 fs/cifs/cifssmb.c                                 |    9 +-
 fs/cifs/connect.c                                 |   14 +-
 fs/cifs/dir.c                                     |    6 +-
 fs/cifs/file.c                                    |   23 +--
 fs/cifs/transport.c                               |    4 +-
 fs/dcache.c                                       |    3 +-
 fs/ext4/ext4.h                                    |    2 +
 fs/ext4/ext4_jbd2.h                               |   56 +++----
 fs/ext4/extents.c                                 |    2 +
 fs/ext4/fsync.c                                   |    2 +
 fs/ext4/inode.c                                   |   46 +++---
 fs/ext4/page-io.c                                 |   11 +-
 fs/hugetlbfs/inode.c                              |   25 ++-
 fs/jbd2/transaction.c                             |    2 +
 fs/lockd/svc.c                                    |    2 +-
 fs/nfs/callback_xdr.c                             |    4 +-
 fs/nfs/delegation.c                               |   11 ++
 fs/nfs/delegation.h                               |    1 +
 fs/nfs/nfs4_fs.h                                  |    3 +
 fs/nfs/nfs4proc.c                                 |   64 +++++---
 fs/nfs/nfs4state.c                                |   33 +++-
 fs/proc/namespaces.c                              |    2 +-
 fs/proc/proc_sysctl.c                             |   17 +-
 fs/proc/task_mmu.c                                |    9 ++
 fs/sysfs/inode.c                                  |   11 +-
 fs/udf/file.c                                     |    2 -
 fs/xfs/xfs_iget.c                                 |   18 ++-
 fs/xfs/xfs_log_recover.c                          |   33 ++--
 include/asm-generic/pgtable.h                     |   61 ++++++++
 include/asm-generic/unistd.h                      |    2 +-
 include/linux/fb.h                                |    1 +
 include/linux/math64.h                            |    4 +
 include/linux/rtc.h                               |    3 +-
 kernel/futex.c                                    |   19 ++-
 kernel/irq/chip.c                                 |    3 +-
 kernel/irq/manage.c                               |    2 +-
 kernel/module.c                                   |    3 +-
 kernel/power/hibernate.c                          |    7 +-
 kernel/time/ntp.c                                 |    2 +-
 lib/kobject_uevent.c                              |   19 ++-
 mm/bootmem.c                                      |    5 +-
 mm/memcontrol.c                                   |    4 +
 mm/memory.c                                       |   16 +-
 mm/mempolicy.c                                    |    2 +-
 mm/mincore.c                                      |    2 +-
 mm/pagewalk.c                                     |    2 +-
 mm/slub.c                                         |    3 +-
 mm/sparse.c                                       |   30 ++--
 mm/swapfile.c                                     |    4 +-
 net/core/dev.c                                    |    3 +-
 net/core/rtnetlink.c                              |    2 +
 net/ipv6/ip6_output.c                             |   11 +-
 net/ipv6/route.c                                  |    8 +-
 net/l2tp/l2tp_ppp.c                               |    2 +-
 net/rds/send.c                                    |    1 -
 net/sunrpc/cache.c                                |    2 +
 net/sunrpc/sched.c                                |   15 +-
 net/xfrm/xfrm_replay.c                            |    6 +-
 security/integrity/ima/Kconfig                    |    2 +-
 sound/pci/hda/hda_eld.c                           |    4 +-
 sound/soc/fsl/p1022_ds.c                          |   24 ++-
 sound/soc/pxa/pxa-ssp.c                           |   61 +++++---
 169 files changed, 1618 insertions(+), 797 deletions(-)

