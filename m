Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab1DMQ3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:29:40 -0400
Received: from kroah.org ([198.145.64.141]:52671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697Ab1DMQMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:36 -0400
Date: Wed, 13 Apr 2011 09:11:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/71] 2.6.33.10-longterm review
Message-ID: <20110413161106.GA20405@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.33.10 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, Apr 15 2011, 15:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                               |    2 +-
 arch/powerpc/kernel/crash.c            |    4 ++
 arch/x86/kernel/cpu/mtrr/main.c        |   20 +++++--
 arch/x86/kernel/head64.c               |    3 +
 arch/x86/kernel/setup.c                |    5 --
 arch/x86/mm/init.c                     |   19 +++++++
 arch/x86/mm/init_64.c                  |   11 ++--
 drivers/atm/solos-pci.c                |    9 +++-
 drivers/block/cciss.h                  |    1 +
 drivers/bluetooth/btusb.c              |    3 +
 drivers/char/tpm/tpm.c                 |    2 +-
 drivers/mfd/ab3100-core.c              |    4 +-
 drivers/misc/ep93xx_pwm.c              |    6 +-
 drivers/net/myri10ge/myri10ge.c        |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    4 ++
 drivers/net/wireless/b43/dma.c         |    2 +-
 drivers/net/wireless/b43/dma.h         |    2 +-
 drivers/net/wireless/p54/p54usb.c      |    2 +
 drivers/rtc/rtc-ds1511.c               |    2 +-
 drivers/scsi/ses.c                     |    4 +-
 drivers/staging/hv/Channel.c           |    8 ++--
 drivers/staging/hv/Connection.c        |    6 ++-
 drivers/staging/hv/Vmbus.c             |    2 +-
 drivers/staging/hv/VmbusPrivate.h      |    1 +
 drivers/staging/usbip/stub_rx.c        |   40 +++++---------
 drivers/staging/usbip/stub_tx.c        |   74 +++++++++++++++++++++-----
 drivers/staging/usbip/usbip_common.c   |   64 ++++++++++++++++++++++-
 drivers/staging/usbip/usbip_common.h   |    2 +
 drivers/staging/usbip/vhci_rx.c        |    3 +
 fs/btrfs/ctree.h                       |    4 ++
 fs/btrfs/disk-io.c                     |    4 +-
 fs/btrfs/ioctl.c                       |    4 ++
 fs/btrfs/root-tree.c                   |   18 ++++++
 fs/btrfs/transaction.c                 |    1 +
 fs/compat.c                            |   28 +++++-----
 fs/ecryptfs/keystore.c                 |    1 +
 fs/ecryptfs/mmap.c                     |    5 ++
 fs/exec.c                              |   32 ++++++++++--
 fs/ext4/inode.c                        |   11 ++--
 fs/nfsd/lockd.c                        |    1 -
 fs/nilfs2/file.c                       |   12 ++--
 fs/ocfs2/aops.c                        |    6 ++
 fs/quota/dquot.c                       |   13 ++---
 fs/squashfs/dir.c                      |    9 +++
 fs/squashfs/namei.c                    |   12 ++++
 fs/ubifs/commit.c                      |    2 +-
 fs/ubifs/debug.c                       |   41 +++++++++++++--
 fs/ubifs/lpt.c                         |    7 +--
 fs/xfs/xfs_fsops.c                     |    3 +
 include/linux/binfmts.h                |    5 ++
 include/scsi/scsi_device.h             |    2 +-
 include/sound/soc-dapm.h               |   16 +++---
 kernel/kgdb.c                          |    9 +--
 kernel/perf_event.c                    |    3 +-
 kernel/signal.c                        |    4 +-
 mm/mremap.c                            |   11 +++-
 net/ax25/af_ax25.c                     |    2 +-
 net/bluetooth/bnep/sock.c              |    1 +
 net/bluetooth/sco.c                    |    1 +
 net/bridge/netfilter/ebtables.c        |    2 +
 net/can/bcm.c                          |    4 +-
 net/core/dev.c                         |    2 +
 net/econet/af_econet.c                 |    8 ++-
 net/ipv4/inet_diag.c                   |   27 ++++++----
 net/ipv4/netfilter/arp_tables.c        |    3 +
 net/ipv4/netfilter/ip_tables.c         |    3 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c     |    5 ++-
 net/ipv6/netfilter/ip6_tables.c        |    3 +
 net/irda/af_irda.c                     |   16 +++---
 net/irda/iriap.c                       |    6 ++
 net/irda/irnet/irnet_ppp.c             |    3 +
 net/mac80211/sta_info.c                |    1 +
 net/netfilter/nf_conntrack_h323_asn1.c |    2 +-
 net/packet/af_packet.c                 |    3 +-
 net/rds/rdma.c                         |    8 +++
 net/rose/rose_subr.c                   |   18 ++++++-
 net/tipc/socket.c                      |    1 +
 sound/core/init.c                      |    4 ++
 sound/oss/dev_table.h                  |    2 +-
 sound/oss/midi_synth.c                 |   34 ++++++------
 sound/oss/midi_synth.h                 |    2 +-
 sound/oss/opl3.c                       |   23 +++++---
 sound/oss/sequencer.c                  |    2 +-
 sound/pci/ens1370.c                    |   23 +++++++--
 sound/pci/hda/patch_analog.c           |   89 ++++++++++++++++++++++++++++++++
 sound/pci/hda/patch_realtek.c          |    2 +-
 86 files changed, 662 insertions(+), 208 deletions(-)
