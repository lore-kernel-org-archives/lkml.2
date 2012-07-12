Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210Ab2GLRvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:51:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54622 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab2GLRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:51:03 -0400
Date: Thu, 12 Jul 2012 10:50:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/68] 3.0.37-stable review
Message-ID: <20120712175057.GA9917@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.37 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jul 14 17:50:33 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.37-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/stable_kernel_rules.txt        |    6 ++
 Makefile                                     |    4 +-
 arch/arm/kernel/smp.c                        |   12 ++-
 arch/powerpc/xmon/xmon.c                     |    2 +-
 arch/x86/include/asm/cpufeature.h            |    2 +-
 arch/x86/kernel/acpi/boot.c                  |   27 ++++---
 arch/x86/kernel/cpu/scattered.c              |    2 +-
 arch/x86/kernel/reboot.c                     |    8 ++
 drivers/acpi/acpi_pad.c                      |    7 +-
 drivers/acpi/sysfs.c                         |    4 +-
 drivers/block/umem.c                         |   40 ++++++++++
 drivers/gpu/drm/drm_edid.c                   |    2 +-
 drivers/gpu/drm/i915/i915_suspend.c          |    5 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c      |    2 +-
 drivers/hwmon/applesmc.c                     |    4 +-
 drivers/hwmon/coretemp.c                     |    2 +-
 drivers/md/raid10.c                          |    6 ++
 drivers/md/raid5.c                           |    8 +-
 drivers/media/dvb/siano/smsusb.c             |    2 +
 drivers/mtd/nand/cafe_nand.c                 |    2 +-
 drivers/net/benet/be_main.c                  |    5 +-
 drivers/net/bonding/bond_main.c              |    9 ++-
 drivers/net/can/c_can/c_can.c                |    4 +-
 drivers/net/dummy.c                          |    4 +-
 drivers/net/sky2.c                           |   10 ++-
 drivers/net/usb/ipheth.c                     |    5 ++
 drivers/net/wireless/ath/ath9k/hw.c          |   16 +++-
 drivers/net/wireless/ath/ath9k/main.c        |    9 +++
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    5 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    7 ++
 drivers/net/wireless/mwifiex/wmm.c           |    2 +
 drivers/net/wireless/rtl818x/rtl8187/leds.c  |    2 +-
 drivers/oprofile/oprofile_perf.c             |    2 +-
 drivers/pci/pci-driver.c                     |   12 +++
 drivers/pci/pci.c                            |    5 --
 drivers/pci/quirks.c                         |   26 -------
 drivers/rtc/rtc-mxc.c                        |    5 +-
 drivers/target/tcm_fc/tfc_sess.c             |    3 +-
 drivers/usb/class/cdc-wdm.c                  |    2 +
 drivers/usb/host/pci-quirks.c                |   13 ++++
 drivers/usb/serial/cp210x.c                  |   11 +++
 drivers/usb/serial/option.c                  |   34 +++++++++
 drivers/vhost/vhost.c                        |    2 +
 fs/btrfs/tree-log.c                          |    6 ++
 fs/ecryptfs/kthread.c                        |    2 +-
 fs/ecryptfs/miscdev.c                        |   48 +++++++-----
 fs/nilfs2/gcinode.c                          |    2 +
 fs/nilfs2/segment.c                          |    2 +
 fs/open.c                                    |    6 +-
 fs/ramfs/file-nommu.c                        |    1 +
 fs/udf/super.c                               |  102 ++++++++++++++++----------
 include/linux/mmzone.h                       |    2 +-
 include/linux/pci.h                          |    2 -
 include/net/cipso_ipv4.h                     |   29 +++++++-
 include/net/sch_generic.h                    |    7 +-
 kernel/trace/trace.c                         |    2 +
 mm/compaction.c                              |    5 +-
 mm/madvise.c                                 |   16 +++-
 mm/vmscan.c                                  |    7 +-
 net/bridge/br_if.c                           |    1 +
 net/bridge/br_netlink.c                      |    2 +-
 net/bridge/br_private.h                      |    1 +
 net/core/ethtool.c                           |    1 +
 net/core/netpoll.c                           |   11 +--
 net/core/sock.c                              |    7 +-
 net/ipv6/route.c                             |   41 ++++++++---
 net/l2tp/l2tp_eth.c                          |    2 +
 net/mac80211/rx.c                            |    5 +-
 net/wireless/reg.c                           |    2 +-
 sound/pci/hda/patch_realtek.c                |    1 +
 sound/soc/codecs/tlv320aic3x.c               |    4 +-
 sound/soc/codecs/tlv320aic3x.h               |    1 +
 72 files changed, 477 insertions(+), 181 deletions(-)

