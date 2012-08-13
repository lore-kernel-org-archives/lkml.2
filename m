Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2HMUtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:49:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2HMUUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 00/82] 3.5.2-stable review
Date: Mon, 13 Aug 2012 13:18:36 -0700
Message-Id: <20120813201746.448504360@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 3.5.2 release.
There are 82 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Aug 15 20:17:43 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.5.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/security/Yama.txt              |   14 +-
 MAINTAINERS                                  |    2 +-
 Makefile                                     |    4 +-
 arch/arm/boot/dts/imx53-ard.dts              |   20 ++
 arch/arm/configs/mxs_defconfig               |    1 -
 arch/arm/include/asm/cacheflush.h            |    8 +-
 arch/arm/include/asm/mutex.h                 |  119 +--------
 arch/arm/kernel/entry-armv.S                 |  111 +++++---
 arch/arm/kernel/process.c                    |    2 +
 arch/arm/kernel/smp.c                        |    3 +-
 arch/arm/kernel/traps.c                      |    8 -
 arch/arm/mach-imx/clk-imx31.c                |    2 +-
 arch/arm/mach-imx/clk-imx51-imx53.c          |    1 +
 arch/arm/mach-pxa/raumfeld.c                 |    2 +-
 arch/arm/mm/tlb-v7.S                         |   12 +
 arch/arm/vfp/entry.S                         |   16 +-
 arch/arm/vfp/vfphw.S                         |   19 +-
 arch/arm/vfp/vfpmodule.c                     |    8 +-
 arch/ia64/include/asm/atomic.h               |    4 +-
 arch/ia64/kernel/irq_ia64.c                  |    1 -
 arch/sh/mm/fault.c                           |    8 +-
 arch/x86/kernel/alternative.c                |    2 +-
 arch/x86/syscalls/syscall_64.tbl             |    2 +-
 block/blk-ioc.c                              |    1 +
 drivers/acpi/processor_driver.c              |    2 +-
 drivers/block/virtio_blk.c                   |   25 +-
 drivers/char/mspec.c                         |    2 +-
 drivers/char/random.c                        |  352 +++++++++++++++++---------
 drivers/firmware/dmi_scan.c                  |    3 +
 drivers/firmware/pcdp.c                      |    4 +-
 drivers/hid/hid-chicony.c                    |    1 +
 drivers/hid/hid-core.c                       |    2 +
 drivers/hid/hid-cypress.c                    |    2 +
 drivers/hid/hid-ids.h                        |    5 +
 drivers/hid/hid-multitouch.c                 |    5 +
 drivers/input/mouse/synaptics.c              |   22 ++
 drivers/input/tablet/wacom_wac.c             |    2 +-
 drivers/input/touchscreen/eeti_ts.c          |   21 +-
 drivers/isdn/hardware/mISDN/avmfritz.c       |    7 +-
 drivers/isdn/mISDN/layer2.c                  |    2 +-
 drivers/md/raid1.c                           |    5 +-
 drivers/media/rc/ene_ir.c                    |    3 +-
 drivers/media/video/m5mols/m5mols_controls.c |    4 +-
 drivers/media/video/videobuf-dma-contig.c    |   53 ++--
 drivers/mfd/ab3100-core.c                    |    5 -
 drivers/mfd/ezx-pcap.c                       |    2 +-
 drivers/mfd/wm831x-otp.c                     |    8 +
 drivers/net/ethernet/intel/e1000e/82571.c    |    4 +-
 drivers/net/tun.c                            |    1 -
 drivers/net/wireless/ath/ath9k/hw.c          |    1 +
 drivers/net/wireless/ath/ath9k/hw.h          |    1 +
 drivers/net/wireless/ath/ath9k/pci.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   13 +-
 drivers/net/wireless/rt2x00/rt61pci.c        |    3 +-
 drivers/platform/x86/asus-wmi.c              |    7 +-
 drivers/rtc/rtc-wm831x.c                     |   24 +-
 drivers/target/target_core_cdb.c             |   43 +++-
 drivers/usb/core/hub.c                       |    9 +
 drivers/video/smscufx.c                      |    2 +-
 fs/exofs/ore.c                               |   14 +-
 fs/nilfs2/ioctl.c                            |    4 +-
 fs/nilfs2/super.c                            |    3 +
 fs/nilfs2/the_nilfs.c                        |    1 +
 fs/nilfs2/the_nilfs.h                        |    2 +
 include/linux/input/eeti_ts.h                |    1 +
 include/linux/irqdesc.h                      |    1 -
 include/linux/mfd/ezx-pcap.h                 |    1 +
 include/linux/random.h                       |    6 +-
 include/linux/security.h                     |    2 -
 include/trace/events/random.h                |  134 ++++++++++
 kernel/irq/handle.c                          |    7 +-
 kernel/irq/manage.c                          |   17 --
 kernel/printk.c                              |    2 +
 lib/vsprintf.c                               |    3 +-
 mm/hugetlb.c                                 |   25 +-
 mm/internal.h                                |    2 +
 mm/memory-failure.c                          |    6 +-
 mm/mmu_notifier.c                            |   45 ++--
 mm/page_alloc.c                              |    4 +-
 mm/sparse.c                                  |    3 +
 mm/vmscan.c                                  |   38 ++-
 net/core/dev.c                               |    3 +
 net/core/rtnetlink.c                         |    1 +
 net/mac80211/mesh.c                          |    1 +
 net/sunrpc/clnt.c                            |    3 +-
 net/sunrpc/rpcb_clnt.c                       |    4 +-
 net/wireless/core.c                          |    5 +
 net/wireless/core.h                          |    1 +
 net/wireless/reg.c                           |   16 +-
 net/wireless/util.c                          |    2 +-
 security/selinux/hooks.c                     |   15 +-
 security/yama/yama_lsm.c                     |   41 +++
 sound/pci/hda/patch_conexant.c               |    1 -
 sound/pci/hda/patch_realtek.c                |    7 +-
 94 files changed, 931 insertions(+), 506 deletions(-)


