Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1EBQhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:37:37 -0400
Received: from kroah.org ([198.145.64.141]:47191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1EBQhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:37:34 -0400
Date: Mon, 2 May 2011 09:37:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.38.5
Message-ID: <20110502163710.GA26329@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.38.5 kernel.

All users of the 2.6.38 kernel series must upgrade.

The updated 2.6.38.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.38.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/m68k/mm/motorola.c                     |    2 
 arch/parisc/mm/init.c                       |    4 
 arch/s390/kvm/sie64a.S                      |    4 
 arch/s390/mm/fault.c                        |    4 
 arch/um/sys-i386/Makefile                   |    2 
 arch/um/sys-i386/atomic64_cx8_32.S          |  225 ++++++++++++++++++++++++++++
 arch/x86/include/asm/gart.h                 |    4 
 arch/x86/kernel/aperture_64.c               |    2 
 arch/x86/kernel/pci-gart_64.c               |    9 -
 block/blk-sysfs.c                           |    4 
 drivers/acpi/battery.c                      |   22 ++
 drivers/acpi/scan.c                         |    4 
 drivers/ata/ahci.c                          |    2 
 drivers/ata/libahci.c                       |   17 +-
 drivers/ata/libata-core.c                   |    4 
 drivers/ata/libata-eh.c                     |    6 
 drivers/char/agp/generic.c                  |   19 +-
 drivers/char/virtio_console.c               |   11 -
 drivers/gpu/drm/Kconfig                     |    1 
 drivers/gpu/drm/i915/intel_display.c        |   68 ++++----
 drivers/gpu/drm/i915/intel_tv.c             |    2 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c     |    4 
 drivers/gpu/drm/radeon/atom.c               |    6 
 drivers/gpu/drm/radeon/atombios_crtc.c      |    6 
 drivers/input/xen-kbdfront.c                |   12 +
 drivers/media/dvb/b2c2/flexcop-pci.c        |    2 
 drivers/net/netxen/netxen_nic.h             |    4 
 drivers/net/netxen/netxen_nic_main.c        |   17 ++
 drivers/net/qlcnic/qlcnic.h                 |    1 
 drivers/net/qlcnic/qlcnic_main.c            |   14 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    8 
 drivers/net/wireless/ath/ath9k/hw.c         |    9 -
 drivers/net/wireless/ath/ath9k/mac.c        |   39 +++-
 drivers/net/wireless/ath/ath9k/mac.h        |    2 
 drivers/net/wireless/ath/ath9k/recv.c       |    6 
 drivers/net/wireless/ath/regd_common.h      |    1 
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    5 
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 
 drivers/net/wireless/iwlwifi/iwl-core.c     |   22 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    7 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 -
 drivers/net/wireless/p54/txrx.c             |    2 
 drivers/pci/intel-iommu.c                   |   17 +-
 drivers/platform/x86/ideapad-laptop.c       |    2 
 drivers/tty/n_gsm.c                         |    8 
 drivers/tty/serial/imx.c                    |    3 
 drivers/virtio/virtio_ring.c                |    1 
 fs/file.c                                   |   18 +-
 fs/nfs/nfs4state.c                          |    4 
 fs/nfs/super.c                              |    9 +
 fs/nfsd/nfs4state.c                         |    3 
 fs/ubifs/recovery.c                         |   26 +++
 fs/ubifs/super.c                            |   18 +-
 include/linux/huge_mm.h                     |    2 
 include/linux/libata.h                      |    1 
 include/linux/mm.h                          |    3 
 init/Kconfig                                |    1 
 mm/huge_memory.c                            |   43 ++---
 mm/memory.c                                 |    2 
 mm/oom_kill.c                               |    9 -
 scripts/kconfig/conf.c                      |    2 
 sound/pci/hda/patch_realtek.c               |   25 ++-
 sound/soc/codecs/jz4740.c                   |    2 
 sound/soc/codecs/wm_hubs.c                  |    8 
 68 files changed, 625 insertions(+), 190 deletions(-)


Alex Deucher (2):
      drm/radeon/kms: pll tweaks for r7xx
      drm/radeon/kms: fix bad shift in atom iio table parser

Alex Williamson (2):
      intel-iommu: Unlink domain from iommu
      intel-iommu: Fix get_domain_for_dev() error path

Amit Kumar Salecha (1):
      qlcnic: limit skb frags for non tso packet

Amit Shah (2):
      virtio: Decrement avail idx on buffer detach
      virtio: console: Enable call to hvc_remove() on console port remove

Andrea Arcangeli (1):
      mm: thp: fix /dev/zero MAP_PRIVATE and vm_flags cleanups

Andrew Morton (1):
      vfs: avoid large kmalloc()s for the fdtable

Artem Bityutskiy (2):
      UBIFS: fix master node recovery
      UBIFS: fix false space checking failure

Ben Hutchings (1):
      kconfig: Avoid buffer underrun in choice input

Carsten Otte (1):
      kvm-390: Let kernel exit SIE instruction on work

Chris Wilson (1):
      drm/i915: Sanitize the output registers after resume

Christian Lamparter (1):
      ath: add missing regdomain pair 0x5c mapping

Dave Airlie (1):
      drm: select FRAMEBUFFER_CONSOLE_PRIMARY if we have FRAMEBUFFER_CONSOLE

David Rientjes (1):
      set memory ranges in N_NORMAL_MEMORY when onlined

Felix Fietkau (2):
      ath9k_hw: fix stopping rx DMA during resets
      ath9k_hw: partially revert "fix dma descriptor rx error bit parsing"

Greg Kroah-Hartman (1):
      Linux 2.6.38.5

Heiko Carstens (1):
      pfault: fix token handling

Igor Mammedov (1):
      Input: xen-kbdfront - fix mouse getting stuck after save/restore

Ike Panhc (1):
      ideapad: read brightness setting on brightness key notify

J. Bruce Fields (1):
      nfsd4: fix struct file leak on delegation

James Bottomley (1):
      slub: fix panic with DISCONTIGMEM

Jan Kiszka (1):
      intel-iommu: Fix use after release during device attach

Jason Conti (1):
      p54: Initialize extra_len in p54_tx_80211

Jeff Layton (1):
      nfs: don't lose MS_SYNCHRONOUS on remount of noac mount

Joerg Roedel (2):
      x86, gart: Set DISTLBWALKPRB bit always
      x86, gart: Make sure GART does not map physmem above 1TB

KOSAKI Motohiro (1):
      oom: use pte pages in OOM score

Kyle McMartin (1):
      ACPI battery: fribble sysfs files from a resume notifier

Lars-Peter Clausen (1):
      ASoC: codecs: JZ4740: Fix OOPS

Liu Yuan (1):
      block, blk-sysfs: Fix an err return path in blk_register_queue()

Marcin Slusarz (1):
      drm/nouveau: fix notifier memory corruption bug

Mark Brown (1):
      ASoC: Fix output PGA enabling in wm_hubs CODECs

Mathew McKernan (1):
      drm/i915/tv: Remember the detected TV type

Maxime Bizon (1):
      ahci: don't enable port irq before handler is registered

Mel Gorman (1):
      mm: check if PTE is already allocated during page fault

Michael Schmitz (1):
      m68k/mm: Set all online nodes in N_NORMAL_MEMORY

Mikhail Kshevetskiy (1):
      tty/n_gsm: fix bug in CRC calculation for gsm1 mode

OGAWA Hirofumi (1):
      nfsd4: Fix filp leak

Patrick Boettcher (1):
      FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci

Rafael J. Wysocki (1):
      ACPI / PM: Avoid infinite recurrence while registering power resources

Richard Weinberger (1):
      um: mdd support for 64 bit atomic operations

Stanislaw Gruszka (4):
      iwlwifi: do not set tx power when channel is changing
      iwl3945: do not deprecate software scan
      iwl3945: disable hw scan by default
      iwlegacy: fix tx_power initialization

Takashi Iwai (1):
      ALSA: hda - Add a fix-up for Acer dmic with ALC271x codec

Tejun Heo (1):
      libata: Implement ATA_FLAG_NO_DIPM and apply it to mcp65

Trond Myklebust (1):
      NFSv4.1: Ensure state manager thread dies on last umount

Uwe Kleine-König (1):
      serial/imx: read cts state only after acking cts change irq

Vasiliy Kulikov (2):
      agp: fix arbitrary kernel memory writes
      agp: fix OOM and buffer overflow

amit salecha (1):
      netxen: limit skb frags for non tso packet

