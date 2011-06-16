Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1FPAUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:20:31 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39182 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab1FPAU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:20:29 -0400
X-Sasl-enc: ImbIiRVPGfDFZixyD+uVEsTtuUKaUmNPYe6xN+S3QKoc 1308183628
Date: Wed, 15 Jun 2011 17:19:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/91] 2.6.32.42-longterm review
Message-ID: <20110616001900.GA25375@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.42 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sat, Jun 18, 2011, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.-rc1.gz
and the diffstat can be found below.

The full set of patches will be sent, as normal, however they will be
delayed by a few hours out of respect for those still awake and trying
to get work done.

thanks,

greg k-h

 Makefile                                |    2 +-
 arch/powerpc/kernel/misc_64.S           |   13 ++++--
 arch/powerpc/oprofile/op_model_power4.c |   24 +++++++++++-
 arch/x86/include/asm/uaccess.h          |    2 +-
 arch/x86/kernel/amd_iommu_init.c        |    8 ++--
 arch/x86/kernel/cpu/amd.c               |   16 +++++--
 arch/x86/kernel/process_32.c            |    1 -
 arch/x86/kernel/process_64.c            |    1 -
 arch/x86/lib/copy_user_64.S             |    4 +-
 arch/x86/xen/mmu.c                      |    2 +-
 arch/x86/xen/multicalls.c               |   12 +++---
 block/blk-core.c                        |    2 +
 block/blk.h                             |    3 +-
 drivers/acpi/scan.c                     |   12 +++---
 drivers/ata/pata_cmd64x.c               |   66 ++++++++++++++++++++----------
 drivers/ata/pata_hpt366.c               |    8 +---
 drivers/ata/pata_hpt37x.c               |   21 ++++------
 drivers/ata/pata_hpt3x2n.c              |   15 ++-----
 drivers/ata/pata_sil680.c               |    6 +--
 drivers/block/brd.c                     |   11 +++--
 drivers/block/loop.c                    |   11 +++--
 drivers/block/nbd.c                     |    6 +++
 drivers/char/i8k.c                      |    4 +-
 drivers/cpufreq/cpufreq.c               |   20 ++++++++-
 drivers/cpufreq/cpufreq_stats.c         |   22 +++++++++-
 drivers/cpuidle/governors/menu.c        |    4 +-
 drivers/gpu/drm/i915/intel_lvds.c       |    8 ++++
 drivers/gpu/drm/radeon/radeon_device.c  |    1 +
 drivers/md/dm-table.c                   |   17 ++++++++
 drivers/md/md.c                         |    2 +-
 drivers/md/raid5.c                      |    8 ++--
 drivers/mtd/mtdconcat.c                 |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/p54/p54usb.c       |    1 +
 drivers/pci/hotplug/pcihp_slot.c        |   45 +++++++++++++++++++++
 drivers/pci/pci.c                       |    8 +++-
 drivers/pci/quirks.c                    |   10 +++++
 drivers/scsi/scsi_scan.c                |   11 +++--
 drivers/scsi/scsi_sysfs.c               |   19 ++++-----
 drivers/scsi/ultrastor.c                |    2 +-
 drivers/staging/usbip/usbip_common.c    |    2 +-
 drivers/usb/class/cdc-acm.c             |    2 +
 drivers/usb/core/hub.c                  |    6 ++-
 drivers/usb/gadget/at91_udc.c           |    2 +-
 drivers/usb/gadget/f_rndis.c            |    3 +-
 drivers/usb/host/ohci-pci.c             |   12 +++++-
 drivers/usb/host/xhci-mem.c             |   18 +++++++--
 drivers/usb/serial/cp210x.c             |    4 ++
 drivers/usb/serial/ftdi_sio.c           |    2 +
 drivers/usb/serial/ftdi_sio_ids.h       |    6 +++
 drivers/usb/serial/garmin_gps.c         |   20 ++++++---
 drivers/usb/serial/moto_modem.c         |    1 +
 drivers/xen/events.c                    |    9 +----
 fs/block_dev.c                          |   27 ++++++++----
 fs/dcookies.c                           |    3 +
 fs/ecryptfs/keystore.c                  |   46 ++++++++++------------
 fs/exec.c                               |    5 +--
 fs/ext3/namei.c                         |   13 +++++-
 fs/ext4/mballoc.c                       |    2 +
 fs/fat/file.c                           |    2 +-
 fs/jbd/commit.c                         |    9 +++-
 fs/jbd/journal.c                        |   16 ++++++-
 fs/partitions/ldm.c                     |    5 ++
 fs/ubifs/journal.c                      |    1 +
 fs/ubifs/sb.c                           |    3 +-
 fs/ubifs/shrinker.c                     |    6 ++-
 fs/ubifs/super.c                        |    1 +
 fs/xfs/linux-2.6/xfs_sync.c             |   16 ++++++--
 fs/xfs/linux-2.6/xfs_sync.h             |    1 +
 fs/xfs/xfs_iget.c                       |    1 +
 include/linux/interrupt.h               |    3 +-
 include/linux/pci_ids.h                 |    2 +
 include/linux/seqlock.h                 |    4 +-
 kernel/irq/manage.c                     |   11 +++++-
 kernel/irq/pm.c                         |    3 -
 kernel/lockdep.c                        |    2 +-
 kernel/time/timekeeping.c               |    9 +++-
 kernel/trace/ftrace.c                   |   12 +++--
 lib/locking-selftest.c                  |    2 +-
 mm/hugetlb.c                            |    4 +-
 mm/kmemleak.c                           |    7 ++-
 mm/page_alloc.c                         |    2 +-
 net/atm/atm_sysfs.c                     |   10 +++++
 net/ipv6/netfilter/ip6t_REJECT.c        |    4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 +---
 net/netfilter/xt_DSCP.c                 |    2 +-
 net/sunrpc/xprtsock.c                   |   16 ++++++-
 net/wireless/nl80211.c                  |    2 +-
 sound/pci/hda/patch_realtek.c           |    1 +
 sound/pci/hda/patch_sigmatel.c          |    2 +-
 sound/soc/codecs/wm_hubs.c              |   24 +++++++-----
 91 files changed, 552 insertions(+), 256 deletions(-)
