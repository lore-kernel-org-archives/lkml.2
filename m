Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1FPAH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:07:29 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56826 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab1FPAH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:07:26 -0400
X-Sasl-enc: SOdQBiAb03PMk2sppGnoWnMFTdbD4QE7OpIf94/73nkB 1308182844
Date: Wed, 15 Jun 2011 17:02:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/89] 2.6.39.2-stable review
Message-ID: <20110616000258.GA14529@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.39.2 release.
There are 89 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sat, Jun 18, 2011, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.39.2-rc1.gz
and the diffstat can be found below.

The full set of patches will be sent, as normal, however they will be
delayed by a few hours out of respect for those still awake and trying
to get work done.

thanks,

greg k-h

 Documentation/kernel-parameters.txt            |    2 +
 Makefile                                       |    2 +-
 arch/powerpc/kernel/head_32.S                  |    2 +-
 arch/powerpc/kernel/smp.c                      |    4 +-
 arch/tile/kernel/pci.c                         |   11 ++--
 arch/x86/kernel/amd_iommu.c                    |   48 ++++++++++++++-
 arch/x86/kernel/amd_iommu_init.c               |    8 +-
 arch/x86/kernel/devicetree.c                   |   11 ++++
 arch/x86/kernel/process_32.c                   |    1 -
 arch/x86/kernel/process_64.c                   |    1 -
 arch/x86/kernel/setup.c                        |    7 --
 arch/x86/kernel/smpboot.c                      |   13 ++++
 arch/x86/lguest/boot.c                         |    1 +
 arch/x86/platform/efi/efi.c                    |   45 +--------------
 arch/x86/platform/efi/efi_64.c                 |    5 +-
 arch/x86/xen/multicalls.c                      |   12 ++--
 block/blk-core.c                               |    2 +
 drivers/block/nbd.c                            |    6 ++
 drivers/cpufreq/cpufreq_stats.c                |    1 +
 drivers/gpu/drm/i915/intel_lvds.c              |    8 +++
 drivers/gpu/drm/radeon/atombios_crtc.c         |   12 +++-
 drivers/gpu/drm/radeon/r100_track.h            |    8 ++-
 drivers/gpu/drm/radeon/radeon_device.c         |    1 +
 drivers/hwmon/coretemp.c                       |   21 +------
 drivers/md/md.c                                |    2 +-
 drivers/md/raid5.c                             |    8 +-
 drivers/media/media-devnode.c                  |    4 +-
 drivers/net/igb/igb_main.c                     |    3 +
 drivers/net/usb/cdc_ncm.c                      |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 +++-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   10 +++-
 drivers/net/wireless/ath/ath9k/main.c          |    4 +-
 drivers/net/wireless/ath/ath9k/rc.c            |    3 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c   |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c       |   14 ++---
 drivers/net/wireless/iwlegacy/iwl-core.c       |   30 ++++------
 drivers/net/wireless/iwlegacy/iwl-core.h       |    2 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h        |   13 +----
 drivers/net/wireless/iwlegacy/iwl4965-base.c   |   19 +++---
 drivers/net/wireless/iwlwifi/iwl-2000.c        |   74 ------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    3 -
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |   12 +---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |   19 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   19 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c        |    6 +--
 drivers/net/wireless/iwlwifi/iwl-core.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   13 +----
 drivers/net/wireless/iwlwifi/iwl-rx.c          |   24 ++++----
 drivers/net/wireless/zd1211rw/zd_usb.c         |   53 +++++++++++++----
 drivers/oprofile/buffer_sync.c                 |   21 ++++---
 drivers/pci/hotplug/pcihp_slot.c               |   45 ++++++++++++++
 drivers/pci/intel-iommu.c                      |   48 +++++++++++----
 drivers/pci/iova.c                             |   12 +++-
 drivers/platform/x86/asus-wmi.c                |    2 +-
 drivers/scsi/scsi_scan.c                       |    2 +-
 drivers/scsi/scsi_sysfs.c                      |    1 +
 drivers/staging/gma500/psb_fb.c                |   10 +++
 drivers/tty/serial/serial_core.c               |   63 +++-----------------
 drivers/usb/class/cdc-acm.c                    |    2 +
 drivers/usb/core/hub.c                         |    6 +-
 drivers/usb/host/xhci-dbg.c                    |    8 +-
 drivers/usb/host/xhci-mem.c                    |   14 ++++-
 drivers/usb/host/xhci-pci.c                    |   14 ++++-
 drivers/usb/host/xhci.c                        |   14 +++++
 drivers/usb/host/xhci.h                        |    6 ++
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio_ids.h              |    1 +
 drivers/usb/serial/option.c                    |   34 ++++++++---
 drivers/usb/storage/transport.c                |   29 +++++++++
 drivers/usb/storage/unusual_devs.h             |   19 ++++++
 drivers/usb/storage/usb.c                      |   13 ++++-
 drivers/usb/storage/usb.h                      |    2 +
 drivers/video/vga16fb.c                        |    2 +
 fs/block_dev.c                                 |    4 +-
 fs/cifs/cifsencrypt.c                          |    2 +-
 fs/cifs/connect.c                              |    6 +-
 fs/dcookies.c                                  |    3 +
 fs/exec.c                                      |    5 +-
 fs/fat/file.c                                  |    2 +-
 fs/ubifs/journal.c                             |    1 +
 fs/ubifs/shrinker.c                            |    6 ++-
 include/linux/efi.h                            |    1 -
 include/linux/usb_usual.h                      |    4 +-
 kernel/irq/irqdesc.c                           |    8 +--
 kernel/lockdep.c                               |    2 +-
 mm/hugetlb.c                                   |    4 +-
 net/mac80211/ibss.c                            |    6 +-
 net/wireless/nl80211.c                         |    2 +-
 security/apparmor/lsm.c                        |    2 +-
 security/tomoyo/mount.c                        |    2 +-
 sound/pci/hda/patch_realtek.c                  |    1 +
 sound/soc/codecs/ad1836.c                      |   14 ++--
 sound/soc/codecs/ad1836.h                      |    6 ++
 sound/soc/codecs/wm8804.c                      |    9 ++-
 sound/soc/codecs/wm8962.c                      |    4 +-
 sound/soc/samsung/i2s.c                        |    4 +-
 sound/soc/soc-dapm.c                           |   17 +++---
 98 files changed, 616 insertions(+), 454 deletions(-)
