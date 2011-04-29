Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860Ab1D2S54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:57:56 -0400
Received: from kroah.org ([198.145.64.141]:50139 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab1D2S5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:57:54 -0400
Date: Fri, 29 Apr 2011 11:57:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/55] 2.6.38.5-stable review
Message-ID: <20110429185706.GA12824@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.38.5 release.
There are 55 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by May 2, 2011, 15:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.38.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                    |    2 +-
 arch/m68k/mm/motorola.c                     |    2 +
 arch/parisc/mm/init.c                       |    4 +-
 arch/s390/kvm/sie64a.S                      |    4 +-
 arch/s390/mm/fault.c                        |    4 +-
 arch/um/sys-i386/Makefile                   |    2 +-
 arch/x86/include/asm/gart.h                 |    4 +-
 arch/x86/kernel/aperture_64.c               |    2 +-
 arch/x86/kernel/pci-gart_64.c               |    9 +++-
 block/blk-sysfs.c                           |    4 +-
 drivers/acpi/battery.c                      |   22 +++++++++
 drivers/acpi/scan.c                         |    4 ++
 drivers/ata/ahci.c                          |    2 +-
 drivers/ata/libahci.c                       |   17 ++++++-
 drivers/ata/libata-core.c                   |    4 +-
 drivers/ata/libata-eh.c                     |    6 ++-
 drivers/char/agp/generic.c                  |   19 ++++++--
 drivers/char/virtio_console.c               |   11 ----
 drivers/gpu/drm/Kconfig                     |    1 +
 drivers/gpu/drm/i915/intel_display.c        |   68 ++++++++++++++-------------
 drivers/gpu/drm/i915/intel_tv.c             |    2 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c     |    4 +-
 drivers/gpu/drm/radeon/atom.c               |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    6 +--
 drivers/input/xen-kbdfront.c                |   12 ++++-
 drivers/media/dvb/b2c2/flexcop-pci.c        |    2 +-
 drivers/net/netxen/netxen_nic.h             |    4 +-
 drivers/net/netxen/netxen_nic_main.c        |   17 +++++++
 drivers/net/qlcnic/qlcnic.h                 |    1 +
 drivers/net/qlcnic/qlcnic_main.c            |   14 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    8 ++--
 drivers/net/wireless/ath/ath9k/hw.c         |    9 ----
 drivers/net/wireless/ath/ath9k/mac.c        |   39 +++++++++++++---
 drivers/net/wireless/ath/ath9k/mac.h        |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c       |    6 +-
 drivers/net/wireless/ath/regd_common.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 --
 drivers/net/wireless/iwlwifi/iwl-core.c     |   22 +++++++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    7 ---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 +---
 drivers/net/wireless/p54/txrx.c             |    2 +-
 drivers/pci/intel-iommu.c                   |   17 ++++++-
 drivers/platform/x86/ideapad-laptop.c       |    2 +
 drivers/tty/n_gsm.c                         |    8 ++-
 drivers/tty/serial/imx.c                    |    3 +-
 drivers/virtio/virtio_ring.c                |    1 +
 fs/file.c                                   |   18 ++++---
 fs/nfs/nfs4state.c                          |    4 +-
 fs/nfs/super.c                              |    9 ++++
 fs/nfsd/nfs4state.c                         |    3 +-
 fs/ubifs/recovery.c                         |   26 ++++++++++
 fs/ubifs/super.c                            |   18 ++++++-
 include/linux/huge_mm.h                     |    2 +-
 include/linux/libata.h                      |    1 +
 include/linux/mm.h                          |    3 +-
 init/Kconfig                                |    1 +
 mm/huge_memory.c                            |   43 +++++++++-------
 mm/memory.c                                 |    2 +-
 mm/oom_kill.c                               |    9 ++-
 scripts/kconfig/conf.c                      |    2 +-
 sound/pci/hda/patch_realtek.c               |   25 +++++++++-
 sound/soc/codecs/jz4740.c                   |    2 -
 sound/soc/codecs/wm_hubs.c                  |    8 ++--
 67 files changed, 400 insertions(+), 190 deletions(-)
