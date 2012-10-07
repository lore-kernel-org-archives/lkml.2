Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2JGXVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:21:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38112 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab2JGXVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:37 -0400
Message-Id: <20121007225834.673681075@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/108] 3.2.31-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.31 release.
There are 108 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Oct 10 00:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.30 will be posted as an additional
response to this, and the diffstat can be found below.

I have only scanned for 'cc: stable' in commits up to 3.6, so don't be
surprised that fixes that went upstream in the last week don't appear
here.  I'll get to them in the next round.

Ben.

-------------
 Makefile                                           |    4 +-
 arch/arm/boot/compressed/head.S                    |    1 +
 arch/arm/mach-imx/mach-armadillo5x0.c              |    3 +-
 arch/x86/kernel/alternative.c                      |    2 +-
 arch/x86/xen/enlighten.c                           |    4 +
 arch/x86/xen/setup.c                               |    4 +
 drivers/ata/libata-core.c                          |    1 +
 drivers/block/aoe/aoecmd.c                         |    1 +
 drivers/block/cciss_scsi.c                         |    1 +
 drivers/block/nbd.c                                |    9 ++
 drivers/bluetooth/ath3k.c                          |    7 ++
 drivers/bluetooth/btusb.c                          |   14 ++-
 drivers/cpufreq/powernow-k8.c                      |   63 +++++-----
 drivers/dma/at_hdmac.c                             |   13 +-
 drivers/dma/pl330.c                                |    5 +
 drivers/edac/sb_edac.c                             |    7 +-
 drivers/gpio/gpio-lpc32xx.c                        |    5 +
 drivers/gpu/drm/i915/i915_gem.c                    |    3 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |  126 ++++----------------
 drivers/hid/hid-core.c                             |   16 ++-
 drivers/hid/hid-logitech-dj.c                      |   83 ++++++++++---
 drivers/hid/hid-logitech-dj.h                      |    1 +
 drivers/hid/hidraw.c                               |  107 +++++++++--------
 drivers/hwmon/ad7314.c                             |    8 ++
 drivers/hwmon/ads7871.c                            |    9 ++
 drivers/hwmon/fam15h_power.c                       |   15 ++-
 drivers/input/serio/i8042-x86ia64io.h              |    6 +
 drivers/iommu/intr_remapping.c                     |   18 ++-
 drivers/md/dm-table.c                              |   26 +++-
 drivers/md/dm.c                                    |   56 ++++++---
 drivers/md/raid10.c                                |    8 +-
 drivers/mmc/host/sdhci.c                           |    5 +-
 drivers/net/can/janz-ican3.c                       |    4 +-
 drivers/net/can/ti_hecc.c                          |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   12 +-
 drivers/net/ethernet/broadcom/tg3.c                |   14 ++-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    4 +
 drivers/net/ethernet/ti/davinci_cpdma.c            |    1 +
 drivers/net/ppp/pppoe.c                            |    2 +-
 drivers/net/usb/asix.c                             |    4 +
 drivers/net/usb/sierra_net.c                       |    2 +-
 drivers/net/wan/ixp4xx_hss.c                       |    1 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   26 ++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   12 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |    8 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |   13 +-
 drivers/platform/x86/asus-laptop.c                 |    8 +-
 drivers/rtc/rtc-twl.c                              |    5 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    3 +
 drivers/scsi/hpsa.c                                |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |    7 ++
 drivers/target/target_core_transport.c             |    9 +-
 drivers/tty/serial/pch_uart.c                      |   19 ++-
 drivers/usb/core/devices.c                         |    2 +-
 drivers/usb/core/hcd.c                             |    6 +-
 drivers/usb/gadget/dummy_hcd.c                     |    8 +-
 drivers/watchdog/hpwdt.c                           |    3 +
 fs/cifs/cifs_unicode.c                             |    2 +-
 fs/dcache.c                                        |   10 +-
 fs/proc/proc_sysctl.c                              |    5 +-
 include/linux/dcache.h                             |    2 +
 include/linux/hid.h                                |    2 +-
 include/linux/hidraw.h                             |    4 +-
 include/linux/memory.h                             |    2 +-
 include/linux/xfrm.h                               |    2 +
 include/net/bluetooth/smp.h                        |    2 +-
 include/net/xfrm.h                                 |    3 +
 include/trace/events/kmem.h                        |    4 +-
 kernel/async.c                                     |   13 +-
 kernel/cpuset.c                                    |    3 +
 kernel/exit.c                                      |   16 +++
 kernel/sched.c                                     |   40 ++++++-
 kernel/workqueue.c                                 |   25 ++--
 mm/memory_hotplug.c                                |   16 ++-
 mm/page_alloc.c                                    |    2 +-
 net/8021q/vlan_core.c                              |    3 +-
 net/bluetooth/hci_conn.c                           |    4 +
 net/bluetooth/l2cap_core.c                         |   11 +-
 net/bluetooth/l2cap_sock.c                         |    2 +-
 net/bluetooth/smp.c                                |    4 +-
 net/core/dev.c                                     |   15 ++-
 net/core/net_namespace.c                           |    4 +-
 net/core/sock.c                                    |    3 +-
 net/ipv4/raw.c                                     |   14 ++-
 net/ipv4/tcp.c                                     |   10 +-
 net/ipv6/mip6.c                                    |   20 ++--
 net/ipv6/raw.c                                     |   21 ++--
 net/ipv6/route.c                                   |   11 +-
 net/l2tp/l2tp_eth.c                                |    2 +-
 net/netrom/af_netrom.c                             |    7 +-
 net/rds/recv.c                                     |    3 +
 net/sched/sch_cbq.c                                |    5 +-
 net/sched/sch_qfq.c                                |    5 +-
 net/sctp/output.c                                  |   21 +++-
 net/wireless/reg.c                                 |   12 +-
 net/xfrm/xfrm_input.c                              |    2 +-
 net/xfrm/xfrm_policy.c                             |    2 +-
 net/xfrm/xfrm_replay.c                             |   15 +++
 net/xfrm/xfrm_user.c                               |   57 ++++++---
 sound/soc/samsung/dma.c                            |    8 +-
 103 files changed, 796 insertions(+), 436 deletions(-)

-- 
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

