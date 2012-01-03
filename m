Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2ACWip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:45 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36069 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804Ab2ACWii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:38 -0500
X-Sasl-enc: e+rQEkilgQg0pJSfHmvXZVQKYHi06Qfxc+gK3cP/wm0O 1325630317
Date: Tue, 3 Jan 2012 14:33:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/75] 3.1.8-stable review
Message-ID: <20120103223332.GA4112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.1.8 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, January 6, 2012, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                     |    4 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/oprofile/common.c                   |    2 +-
 arch/arm/plat-mxc/pwm.c                      |   16 +-
 arch/s390/oprofile/init.c                    |    2 +-
 arch/sh/oprofile/common.c                    |    4 +-
 arch/sparc/include/asm/pgtable_32.h          |   20 +-
 arch/sparc/include/asm/pgtable_64.h          |   20 +-
 arch/sparc/kernel/entry.h                    |    7 +
 arch/sparc/kernel/module.c                   |   27 +
 arch/sparc/kernel/pci_sun4v.c                |    4 +-
 arch/sparc/kernel/setup_64.c                 |   48 +-
 arch/sparc/kernel/signal32.c                 |   18 +-
 arch/sparc/kernel/signal_32.c                |   30 +-
 arch/sparc/kernel/signal_64.c                |   42 +-
 arch/sparc/kernel/visemul.c                  |   32 +-
 arch/sparc/lib/memcpy.S                      |  804 ++++----------------------
 arch/sparc/mm/Makefile                       |    1 -
 arch/sparc/mm/btfixup.c                      |    3 +-
 arch/sparc/mm/generic_32.c                   |   98 ----
 arch/sparc/mm/generic_64.c                   |  164 ------
 arch/x86/net/bpf_jit_comp.c                  |    4 +-
 block/blk-core.c                             |   14 +-
 block/cfq-iosched.c                          |   16 +-
 drivers/gpu/drm/i915/i915_dma.c              |   10 +
 drivers/gpu/drm/i915/i915_drv.h              |    1 +
 drivers/gpu/drm/i915/i915_reg.h              |    8 +-
 drivers/gpu/drm/i915/intel_sdvo.c            |    8 +-
 drivers/gpu/drm/radeon/evergreen.c           |   12 +
 drivers/infiniband/hw/mlx4/main.c            |    6 +-
 drivers/input/mouse/synaptics.c              |   11 +
 drivers/media/video/omap/omap_vout.c         |    1 +
 drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
 drivers/mfd/twl-core.c                       |   16 +-
 drivers/mfd/twl4030-madc.c                   |   22 +
 drivers/mmc/host/mmci.c                      |   14 +-
 drivers/mmc/host/vub300.c                    |    2 +-
 drivers/net/pptp.c                           |    4 +-
 drivers/net/wireless/ath/ath9k/rc.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |    5 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    2 +-
 drivers/oprofile/oprofile_files.c            |    7 +-
 drivers/oprofile/oprofilefs.c                |   11 +-
 drivers/rtc/interface.c                      |    6 +
 drivers/rtc/rtc-m41t80.c                     |    9 +
 drivers/s390/scsi/zfcp_scsi.c                |    4 +
 drivers/scsi/fcoe/fcoe.c                     |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c          |    6 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h          |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    2 +-
 drivers/ssb/driver_pcicore.c                 |    8 +-
 drivers/watchdog/hpwdt.c                     |    5 +-
 fs/nfs/file.c                                |    2 +-
 fs/nfs/nfs4state.c                           |    8 +-
 fs/nilfs2/ioctl.c                            |   13 +
 include/linux/blkdev.h                       |    3 -
 include/linux/i2c/twl4030-madc.h             |    4 +
 include/linux/lglock.h                       |   36 +-
 include/net/dst.h                            |    1 +
 include/net/flow.h                           |    1 +
 include/net/sctp/structs.h                   |    4 +
 kernel/cgroup.c                              |    5 -
 kernel/futex.c                               |   28 +-
 kernel/sysctl_binary.c                       |    2 +-
 mm/filemap.c                                 |    7 +-
 mm/hugetlb.c                                 |    2 +-
 mm/memcontrol.c                              |    3 +-
 mm/mempolicy.c                               |   11 +-
 mm/oom_kill.c                                |    2 +-
 mm/percpu.c                                  |    6 +-
 net/bridge/br_netfilter.c                    |    2 +-
 net/core/flow.c                              |   12 +
 net/ipv4/devinet.c                           |    5 +
 net/ipv4/ipconfig.c                          |    4 +
 net/ipv4/ipip.c                              |    7 +-
 net/ipv4/route.c                             |  111 ++++-
 net/ipv6/ip6_output.c                        |    2 +-
 net/ipv6/route.c                             |    2 +-
 net/ipv6/sit.c                               |    7 +-
 net/llc/af_llc.c                             |   14 +-
 net/mac80211/agg-tx.c                        |   86 ++--
 net/sched/sch_gred.c                         |    2 +-
 net/sched/sch_mqprio.c                       |    2 +-
 net/sctp/associola.c                         |    2 +-
 net/sctp/output.c                            |    8 +-
 net/sctp/outqueue.c                          |    6 +-
 net/sctp/protocol.c                          |    3 +
 net/sctp/socket.c                            |    2 -
 net/sctp/sysctl.c                            |   13 +
 net/sunrpc/xprt.c                            |   10 +-
 net/xfrm/xfrm_policy.c                       |   18 +-
 security/selinux/netport.c                   |    4 +-
 sound/pci/hda/hda_intel.c                    |    1 +
 sound/soc/codecs/wm8996.c                    |    1 +
 99 files changed, 812 insertions(+), 1235 deletions(-)
