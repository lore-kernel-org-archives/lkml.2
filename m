Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2HMWPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:15:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59891 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2HMWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:14:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 00/65] 3.4.9-stable review
Date: Mon, 13 Aug 2012 15:13:44 -0700
Message-Id: <20120813221414.965154048@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 3.4.9 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Aug 15 22:14:12 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 MAINTAINERS                               |    2 +-
 Makefile                                  |    4 +-
 arch/arm/boot/dts/imx53-ard.dts           |   20 ++
 arch/arm/configs/mxs_defconfig            |    1 -
 arch/arm/include/asm/cacheflush.h         |    8 +-
 arch/arm/include/asm/mutex.h              |  119 +---------
 arch/arm/kernel/entry-armv.S              |  111 +++++----
 arch/arm/kernel/process.c                 |    2 +
 arch/arm/kernel/smp.c                     |    3 +-
 arch/arm/kernel/traps.c                   |    8 -
 arch/arm/mach-pxa/raumfeld.c              |    2 +-
 arch/arm/mm/tlb-v7.S                      |   12 +
 arch/arm/vfp/entry.S                      |   16 +-
 arch/arm/vfp/vfphw.S                      |   19 +-
 arch/arm/vfp/vfpmodule.c                  |    8 +-
 arch/ia64/include/asm/atomic.h            |    4 +-
 arch/ia64/kernel/irq_ia64.c               |    1 -
 arch/x86/kernel/alternative.c             |    2 +-
 arch/x86/kernel/microcode_core.c          |   31 ++-
 drivers/acpi/processor_driver.c           |    2 +-
 drivers/char/mspec.c                      |    2 +-
 drivers/char/random.c                     |  352 +++++++++++++++++++----------
 drivers/firmware/dmi_scan.c               |    3 +
 drivers/firmware/pcdp.c                   |    4 +-
 drivers/hid/hid-chicony.c                 |    1 +
 drivers/hid/hid-core.c                    |    2 +
 drivers/hid/hid-cypress.c                 |    2 +
 drivers/hid/hid-ids.h                     |    5 +
 drivers/hid/hid-multitouch.c              |    5 +
 drivers/input/tablet/wacom_wac.c          |    2 +-
 drivers/input/touchscreen/eeti_ts.c       |   21 +-
 drivers/md/raid1.c                        |    5 +-
 drivers/media/rc/ene_ir.c                 |    3 +-
 drivers/mfd/ab3100-core.c                 |    5 -
 drivers/mfd/ezx-pcap.c                    |    2 +-
 drivers/mfd/wm831x-otp.c                  |    8 +
 drivers/net/ethernet/intel/e1000e/82571.c |    4 +-
 drivers/net/tun.c                         |    1 -
 drivers/net/wireless/ath/ath9k/hw.c       |    1 +
 drivers/net/wireless/ath/ath9k/hw.h       |    1 +
 drivers/net/wireless/ath/ath9k/pci.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   13 +-
 drivers/net/wireless/rt2x00/rt61pci.c     |    3 +-
 drivers/platform/x86/asus-wmi.c           |    7 +-
 drivers/rtc/rtc-wm831x.c                  |   24 +-
 drivers/target/target_core_cdb.c          |   43 ++--
 drivers/usb/core/hub.c                    |    9 +
 drivers/video/smscufx.c                   |    2 +-
 fs/exofs/ore.c                            |   14 +-
 fs/nilfs2/ioctl.c                         |    4 +-
 fs/nilfs2/super.c                         |    3 +
 fs/nilfs2/the_nilfs.c                     |    1 +
 fs/nilfs2/the_nilfs.h                     |    2 +
 include/linux/input/eeti_ts.h             |    1 +
 include/linux/irqdesc.h                   |    1 -
 include/linux/mfd/ezx-pcap.h              |    1 +
 include/linux/random.h                    |    6 +-
 include/trace/events/random.h             |  134 +++++++++++
 kernel/irq/handle.c                       |    7 +-
 kernel/irq/manage.c                       |   17 --
 mm/hugetlb.c                              |   25 +-
 mm/memory-failure.c                       |    6 +-
 mm/mmu_notifier.c                         |   45 ++--
 net/core/dev.c                            |    3 +
 net/core/rtnetlink.c                      |    1 +
 net/mac80211/mesh.c                       |    1 +
 net/sunrpc/clnt.c                         |    3 +-
 net/sunrpc/rpcb_clnt.c                    |    4 +-
 net/wireless/core.c                       |    5 +
 net/wireless/core.h                       |    1 +
 net/wireless/reg.c                        |   16 +-
 net/wireless/util.c                       |    5 +-
 sound/pci/hda/patch_conexant.c            |    1 -
 sound/pci/hda/patch_realtek.c             |    7 +-
 74 files changed, 774 insertions(+), 446 deletions(-)


