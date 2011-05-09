Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab1EIXOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:14:43 -0400
Received: from kroah.org ([198.145.64.141]:43799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab1EIXO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:14:29 -0400
Date: Mon, 9 May 2011 16:14:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.13
Message-ID: <20110509231403.GA2992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.13 kernel.

This is primarily for the use of those people who are stuck using the
.33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
is welcome to use this one as well.

I'll be maintaining it for a while longer as it looks like the -rt tree
isn't moving forward to any newer kernel any time soon.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 +-
 arch/arm/kernel/sys_oabi-compat.c       |    2 +-
 arch/m68k/mm/motorola.c                 |    2 ++
 arch/parisc/mm/init.c                   |    4 +++-
 arch/x86/kernel/cpu/amd.c               |    2 +-
 arch/x86/kernel/pci-gart_64.c           |    9 ++++++++-
 block/blk-sysfs.c                       |    4 +++-
 drivers/ata/libata-scsi.c               |   24 ++++++++++++++++++------
 drivers/char/agp/generic.c              |   19 +++++++++++++++----
 drivers/char/i8k.c                      |    7 ++++---
 drivers/gpu/drm/radeon/atom.c           |    6 +++---
 drivers/input/xen-kbdfront.c            |   12 +++++++++++-
 drivers/media/dvb/b2c2/flexcop-pci.c    |    2 +-
 drivers/mmc/host/sdhci-pci.c            |    1 +
 drivers/mmc/host/sdhci.c                |    9 ++++++++-
 drivers/net/igbvf/igbvf.h               |    1 -
 drivers/net/wireless/ath/regd_common.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    8 ++++++--
 drivers/net/wireless/p54/txrx.c         |    2 +-
 drivers/pci/intel-iommu.c               |   15 +++++++++++++--
 drivers/s390/block/dasd_eckd.c          |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c      |   23 +++++++++++++++++++++--
 drivers/scsi/pmcraid.c                  |    3 +++
 drivers/scsi/scsi_lib.c                 |    7 ++++++-
 drivers/scsi/scsi_sysfs.c               |   16 ++++++++--------
 drivers/serial/imx.c                    |    3 ++-
 drivers/staging/usbip/vhci_hcd.c        |    2 +-
 drivers/usb/musb/musb_core.c            |    1 +
 fs/nfs/inode.c                          |   26 +++++++++++++++++---------
 fs/nfs/nfs4state.c                      |    4 ++--
 fs/nfs/super.c                          |    9 +++++++++
 fs/nfsd/vfs.c                           |    9 ++++++++-
 fs/partitions/ldm.c                     |   16 ++++++++++++----
 fs/ubifs/recovery.c                     |   26 ++++++++++++++++++++++++++
 init/Kconfig                            |    1 +
 net/can/bcm.c                           |    7 ++++++-
 net/can/raw.c                           |    7 ++++++-
 net/ipv4/ip_output.c                    |    9 ++++++---
 net/unix/af_unix.c                      |   16 +++++++++++++++-
 scripts/kconfig/conf.c                  |    2 +-
 sound/soc/codecs/wm_hubs.c              |    8 ++++----
 42 files changed, 258 insertions(+), 73 deletions(-)

Alan Stern (1):
      USB: fix regression in usbip by setting has_tt flag

Alex Deucher (1):
      drm/radeon/kms: fix bad shift in atom iio table parser

Alex Williamson (2):
      intel-iommu: Unlink domain from iommu
      intel-iommu: Fix get_domain_for_dev() error path

Artem Bityutskiy (1):
      UBIFS: fix master node recovery

Ben Dooks (1):
      mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish

Ben Hutchings (1):
      kconfig: Avoid buffer underrun in choice input

Boris Ostrovsky (1):
      x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

Chris Ball (2):
      mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
      mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish

Christian Lamparter (1):
      ath: add missing regdomain pair 0x5c mapping

Dan Rosenberg (3):
      pmcraid: reject negative request size
      mpt2sas: prevent heap overflows and unchecked reads
      ARM: 6891/1: prevent heap corruption in OABI semtimedop

Dave Jones (1):
      can: Add missing socket check in can/bcm release.

David Rientjes (1):
      set memory ranges in N_NORMAL_MEMORY when onlined

Eric W. Biederman (1):
      af_unix: Only allow recv on connected seqpacket sockets.

Felipe Balbi (1):
      usb: musb: core: set has_tt flag

Fry, Donald H (1):
      iwlagn: Support new 5000 microcode.

Greg Kroah-Hartman (1):
      Linux 2.6.33.13

Greg Rose (1):
      Remove extra struct page member from the buffer info structure

Herbert Xu (1):
      udp: Fix bogus UFO packet generation

Igor Mammedov (1):
      Input: xen-kbdfront - fix mouse getting stuck after save/restore

James Bottomley (3):
      slub: fix panic with DISCONTIGMEM
      put stricter guards on queue dead checks
      fix oops in scsi_run_queue()

Jason Conti (1):
      p54: Initialize extra_len in p54_tx_80211

Jeff Layton (1):
      nfs: don't lose MS_SYNCHRONOUS on remount of noac mount

Jim Bos (2):
      i8k: Tell gcc that *regs gets clobbered
      Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)

Joerg Roedel (1):
      x86, gart: Make sure GART does not map physmem above 1TB

Liu Yuan (1):
      block, blk-sysfs: Fix an err return path in blk_register_queue()

Mark Brown (1):
      ASoC: Fix output PGA enabling in wm_hubs CODECs

Michael Schmitz (1):
      m68k/mm: Set all online nodes in N_NORMAL_MEMORY

Oliver Hartkopp (1):
      can: add missing socket check in can/raw release

Patrick Boettcher (1):
      FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci

Sachin Prabhu (1):
      Open with O_CREAT flag set fails to open existing files on non writable directories

Stanislaw Gruszka (1):
      iwlwifi: fix skb usage after free

Stefan Haberland (1):
      dasd: correct device table

Tejun Heo (1):
      libata: set queue DMA alignment to sector size for ATAPI too

Timo Warns (1):
      fs/partitions/ldm.c: fix oops caused by corrupted partition table

Trond Myklebust (2):
      NFS: nfs_wcc_update_inode() should set nfsi->attr_gencount
      NFSv4.1: Ensure state manager thread dies on last umount

Uwe Kleine-König (1):
      serial/imx: read cts state only after acking cts change irq

Vasiliy Kulikov (2):
      agp: fix arbitrary kernel memory writes
      agp: fix OOM and buffer overflow

