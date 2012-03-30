Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408Ab2C3T6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:58:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63123 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761354Ab2C3T6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:58:16 -0400
Date: Fri, 30 Mar 2012 12:58:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/108] 3.0.27-stable review
Message-ID: <20120330195812.GA31833@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.27 release.
There are 108 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Apr  1 19:57:16 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.27-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                          |    4 +-
 arch/x86/include/asm/kvm_emulate.h                |   16 +++
 arch/x86/kernel/apic/io_apic.c                    |   40 ++++++--
 arch/x86/kernel/entry_32.S                        |   17 ++--
 arch/x86/kernel/tls.c                             |    4 +-
 arch/x86/kernel/tsc.c                             |   10 ++
 arch/x86/kernel/vm86_32.c                         |    2 +
 arch/x86/kvm/emulate.c                            |   51 ++++++++++
 arch/x86/kvm/x86.c                                |   23 +++++
 arch/x86/net/bpf_jit_comp.c                       |   14 +--
 drivers/ata/pata_legacy.c                         |    3 +-
 drivers/bluetooth/ath3k.c                         |    1 +
 drivers/bluetooth/btusb.c                         |   10 +-
 drivers/firewire/ohci.c                           |    5 +-
 drivers/gpu/drm/i915/i915_drv.c                   |    7 ++
 drivers/gpu/drm/i915/intel_drv.h                  |    2 +-
 drivers/gpu/drm/i915/intel_fb.c                   |   10 ++
 drivers/gpu/drm/radeon/radeon_atombios.c          |   14 +++
 drivers/gpu/drm/radeon/radeon_connectors.c        |    4 +
 drivers/gpu/drm/radeon/radeon_cursor.c            |   13 ++-
 drivers/gpu/drm/radeon/radeon_object.c            |   18 +++-
 drivers/gpu/drm/radeon/radeon_object.h            |    2 +
 drivers/hid/hid-chicony.c                         |    7 ++
 drivers/hid/hid-core.c                            |    1 +
 drivers/hid/hid-ids.h                             |    1 +
 drivers/hwmon/fam15h_power.c                      |    2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c          |   18 +---
 drivers/infiniband/ulp/iser/iscsi_iser.h          |    1 +
 drivers/infiniband/ulp/iser/iser_initiator.c      |   30 +++---
 drivers/md/bitmap.c                               |    2 +
 drivers/md/dm-crypt.c                             |   38 +++----
 drivers/md/dm-exception-store.c                   |    2 +-
 drivers/md/raid1.c                                |   17 +++-
 drivers/md/raid10.c                               |   17 +++-
 drivers/media/dvb/frontends/lgdt330x.c            |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c     |   10 ++
 drivers/mtd/ubi/scan.c                            |    8 +-
 drivers/mtd/ubi/wl.c                              |   10 +-
 drivers/net/e1000e/e1000.h                        |    1 +
 drivers/net/e1000e/netdev.c                       |   23 ++++-
 drivers/net/sky2.c                                |   11 +++
 drivers/net/usb/usbnet.c                          |   10 +-
 drivers/net/wireless/p54/p54spi.c                 |   14 ++-
 drivers/net/wireless/rt2x00/rt2800usb.c           |    1 +
 drivers/net/wireless/rtlwifi/pci.c                |   16 +--
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   15 ++-
 drivers/rtc/interface.c                           |   15 ++-
 drivers/target/loopback/tcm_loop.c                |    6 ++
 drivers/target/target_core_alua.c                 |    7 +-
 drivers/target/target_core_cdb.c                  |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c                   |    6 +-
 drivers/tty/moxa.c                                |    2 +-
 drivers/tty/serial/amba-pl011.c                   |   15 ++-
 drivers/tty/serial/sh-sci.c                       |   15 ++-
 drivers/tty/vt/consolemap.c                       |   51 ++++++++--
 drivers/usb/class/cdc-wdm.c                       |   17 ++--
 drivers/usb/gadget/fsl_udc_core.c                 |   18 ++--
 drivers/usb/gadget/hid.c                          |    6 +-
 drivers/usb/gadget/inode.c                        |    2 +
 drivers/usb/host/ehci-fsl.c                       |    4 +
 drivers/usb/host/ehci-fsl.h                       |    1 +
 drivers/usb/host/fsl-mph-dr-of.c                  |    1 -
 drivers/usb/musb/musb_gadget.c                    |   18 ++++
 drivers/usb/serial/cp210x.c                       |   44 ++++++++-
 drivers/usb/serial/ftdi_sio.c                     |   32 ++++--
 drivers/usb/serial/ftdi_sio.h                     |    3 +-
 drivers/usb/serial/ftdi_sio_ids.h                 |   19 +++-
 drivers/usb/serial/generic.c                      |    4 +-
 drivers/usb/serial/mos7840.c                      |   83 +++++++++++-----
 drivers/usb/serial/option.c                       |   16 +++
 drivers/usb/serial/qcserial.c                     |  109 ++++++++++++++-------
 drivers/video/backlight/tosa_lcd.c                |    2 +-
 drivers/video/fbmem.c                             |   18 +++-
 drivers/video/udlfb.c                             |    2 +-
 drivers/video/uvesafb.c                           |   12 ++-
 fs/cifs/connect.c                                 |    3 +-
 fs/dcache.c                                       |    3 +-
 fs/ext4/ext4_jbd2.h                               |   56 ++++++-----
 fs/ext4/extents.c                                 |    2 +
 fs/ext4/inode.c                                   |   45 ++++++---
 fs/hugetlbfs/inode.c                              |   25 ++---
 fs/jbd2/transaction.c                             |    2 +
 fs/lockd/svc.c                                    |    2 +-
 fs/nfs/delegation.c                               |   11 +++
 fs/nfs/delegation.h                               |    1 +
 fs/nfs/nfs4_fs.h                                  |    3 +
 fs/nfs/nfs4proc.c                                 |   31 +++++-
 fs/nfs/nfs4state.c                                |   29 +++++-
 fs/proc/namespaces.c                              |    2 +-
 fs/proc/task_mmu.c                                |    9 ++
 fs/sysfs/inode.c                                  |   11 ++-
 fs/udf/file.c                                     |    2 -
 fs/xfs/xfs_iget.c                                 |   18 ++--
 fs/xfs/xfs_log_recover.c                          |   33 +++----
 include/asm-generic/pgtable.h                     |   61 ++++++++++++
 include/asm-generic/unistd.h                      |    2 +-
 include/linux/fb.h                                |    1 +
 include/linux/math64.h                            |    4 +
 kernel/futex.c                                    |   19 ++--
 kernel/irq/chip.c                                 |    3 +-
 kernel/irq/manage.c                               |    2 +-
 kernel/module.c                                   |    3 +-
 kernel/power/hibernate.c                          |    7 +-
 kernel/time/ntp.c                                 |    2 +-
 lib/kobject_uevent.c                              |   19 ++--
 mm/bootmem.c                                      |    5 +-
 mm/memcontrol.c                                   |    4 +
 mm/memory.c                                       |   16 ++-
 mm/mempolicy.c                                    |    2 +-
 mm/mincore.c                                      |    2 +-
 mm/pagewalk.c                                     |    2 +-
 mm/slub.c                                         |    3 +-
 mm/sparse.c                                       |   30 +++---
 mm/swapfile.c                                     |    4 +-
 net/core/dev.c                                    |    3 +-
 net/ipv6/route.c                                  |    8 +-
 net/l2tp/l2tp_ppp.c                               |    2 +-
 net/rds/send.c                                    |    1 -
 net/sunrpc/cache.c                                |    2 +
 net/sunrpc/sched.c                                |   15 ++-
 net/xfrm/xfrm_replay.c                            |    6 +-
 sound/soc/pxa/pxa-ssp.c                           |   61 +++++++-----
 122 files changed, 1184 insertions(+), 454 deletions(-)

