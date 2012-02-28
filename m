Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2B1BGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:06:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48212 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab2B1BF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:05:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.162 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 27 Feb 2012 17:02:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/73] 3.0.23-stable review
Message-ID: <20120228010246.GA24299@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.23 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar  1 00:00:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.23-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                       |    4 +-
 arch/arm/include/asm/assembler.h               |    5 +
 arch/arm/mm/cache-v7.S                         |    6 +
 arch/powerpc/kernel/perf_event.c               |    8 +-
 arch/x86/include/asm/i387.h                    |  284 +++++++++++++++++++-----
 arch/x86/include/asm/processor.h               |    1 +
 arch/x86/include/asm/thread_info.h             |    2 -
 arch/x86/kernel/cpu/intel_cacheinfo.c          |   44 +++-
 arch/x86/kernel/process_32.c                   |   25 +--
 arch/x86/kernel/process_64.c                   |   29 +--
 arch/x86/kernel/traps.c                        |   41 ++--
 arch/x86/kernel/xsave.c                        |   12 +-
 arch/x86/kvm/vmx.c                             |    2 +-
 drivers/cdrom/cdrom.c                          |    8 +-
 drivers/gpu/drm/radeon/r100.c                  |    4 +-
 drivers/gpu/drm/radeon/rs600.c                 |    4 +-
 drivers/hwmon/ads1015.c                        |    3 +-
 drivers/hwmon/f75375s.c                        |    5 +-
 drivers/hwmon/max6639.c                        |   22 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   55 ++---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    9 +-
 drivers/media/video/hdpvr/hdpvr-video.c        |    3 +-
 drivers/mmc/card/block.c                       |   82 ++++---
 drivers/net/3c59x.c                            |    2 +-
 drivers/net/davinci_emac.c                     |    6 +-
 drivers/net/jme.c                              |   10 +-
 drivers/net/jme.h                              |    2 +-
 drivers/net/usb/ipheth.c                       |    5 +
 drivers/net/veth.c                             |    4 +-
 drivers/net/via-velocity.c                     |    3 -
 drivers/net/wireless/ath/ath9k/rc.c            |    2 +-
 drivers/pci/probe.c                            |    5 +
 drivers/scsi/scsi_pm.c                         |   16 ++
 drivers/scsi/scsi_priv.h                       |    1 +
 drivers/scsi/scsi_scan.c                       |    4 +-
 drivers/usb/core/hcd-pci.c                     |    5 +-
 drivers/usb/core/hcd.c                         |    6 +-
 drivers/usb/core/hub.c                         |   30 ++-
 drivers/usb/host/pci-quirks.c                  |   11 +
 drivers/usb/host/xhci-hub.c                    |    2 +-
 drivers/usb/host/xhci-mem.c                    |   32 ++-
 drivers/usb/host/xhci.c                        |    5 +
 drivers/usb/serial/cp210x.c                    |    2 +
 drivers/usb/serial/option.c                    |  143 +-----------
 drivers/usb/serial/ti_usb_3410_5052.c          |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.h          |    4 +
 drivers/usb/storage/usb.c                      |   89 +++-----
 drivers/usb/storage/usb.h                      |    7 +-
 fs/ecryptfs/inode.c                            |    2 +
 fs/eventpoll.c                                 |  264 ++++++++++++++++++++---
 fs/nfs/nfs4state.c                             |    2 +
 fs/signalfd.c                                  |   15 ++
 include/asm-generic/poll.h                     |    2 +
 include/linux/eventpoll.h                      |    1 +
 include/linux/fs.h                             |    1 +
 include/linux/signalfd.h                       |    5 +-
 include/linux/usb/ch11.h                       |   10 +-
 include/net/flow.h                             |   10 +
 include/net/inet_sock.h                        |    2 +
 include/net/route.h                            |    4 +
 include/net/sch_generic.h                      |    9 +-
 kernel/fork.c                                  |    5 +-
 kernel/irq/autoprobe.c                         |    4 +-
 kernel/irq/chip.c                              |   42 +++-
 kernel/irq/internals.h                         |    2 +-
 kernel/irq/manage.c                            |    2 +-
 mm/nommu.c                                     |    7 +
 net/core/dev.c                                 |   10 +-
 net/core/netpoll.c                             |    2 +-
 net/ipv4/arp.c                                 |    3 +-
 net/ipv4/ip_forward.c                          |    2 +-
 net/ipv4/ip_options.c                          |    4 +-
 net/ipv4/route.c                               |   97 ++++++---
 net/ipv4/tcp_input.c                           |   45 +++--
 net/ipv4/tcp_ipv4.c                            |    5 +
 net/ipv6/ip6mr.c                               |    8 +-
 net/mac80211/main.c                            |    4 +-
 net/netfilter/ipvs/ip_vs_core.c                |    2 +-
 net/sched/sch_choke.c                          |    3 +-
 net/sched/sch_netem.c                          |    7 +-
 net/sched/sch_sfb.c                            |    3 +-
 scripts/package/builddeb                       |   12 +-
 sound/pci/hda/patch_conexant.c                 |   11 +-
 sound/soc/codecs/wm8962.c                      |    2 +-
 85 files changed, 1062 insertions(+), 613 deletions(-)

