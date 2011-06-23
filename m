Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab1FWWK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:10:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40298 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760019Ab1FWWKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:10:54 -0400
X-Sasl-enc: MbvFaplCtlOrAiHuzNWGVoh90lbC+e2EjI2UmVGpX2LU 1308867051
Date: Thu, 23 Jun 2011 15:10:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.39.2
Message-ID: <20110623221010.GA15937@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.39.2 kernel.

All users of the 2.6.39 kernel series must upgrade.

The updated 2.6.39.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.39.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.39.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt            |    2 
 Makefile                                       |    2 
 arch/powerpc/kernel/head_32.S                  |    2 
 arch/powerpc/kernel/smp.c                      |    4 -
 arch/tile/kernel/pci.c                         |   11 +--
 arch/x86/kernel/amd_iommu.c                    |   48 +++++++++++++++-
 arch/x86/kernel/amd_iommu_init.c               |    8 +-
 arch/x86/kernel/devicetree.c                   |   11 +++
 arch/x86/kernel/process_32.c                   |    1 
 arch/x86/kernel/process_64.c                   |    1 
 arch/x86/kernel/setup.c                        |    7 --
 arch/x86/kernel/smpboot.c                      |   13 ++++
 arch/x86/lguest/boot.c                         |    1 
 arch/x86/platform/efi/efi.c                    |   45 ---------------
 arch/x86/platform/efi/efi_64.c                 |    5 -
 arch/x86/xen/multicalls.c                      |   12 ++--
 block/blk-core.c                               |    2 
 drivers/block/nbd.c                            |    6 ++
 drivers/cpufreq/cpufreq_stats.c                |    1 
 drivers/gpu/drm/i915/intel_lvds.c              |    8 ++
 drivers/gpu/drm/radeon/atombios_crtc.c         |   12 ++--
 drivers/gpu/drm/radeon/r100_track.h            |    8 ++
 drivers/gpu/drm/radeon/radeon_device.c         |    1 
 drivers/hwmon/coretemp.c                       |   21 +------
 drivers/md/md.c                                |    2 
 drivers/md/raid5.c                             |    8 +-
 drivers/media/media-devnode.c                  |    4 -
 drivers/net/igb/igb_main.c                     |    3 +
 drivers/net/usb/cdc_ncm.c                      |    1 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 ++-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   10 ++-
 drivers/net/wireless/ath/ath9k/main.c          |    4 +
 drivers/net/wireless/ath/ath9k/rc.c            |    3 -
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c   |    4 -
 drivers/net/wireless/iwlegacy/iwl-4965.c       |   14 ++--
 drivers/net/wireless/iwlegacy/iwl-core.c       |   30 ++++------
 drivers/net/wireless/iwlegacy/iwl-core.h       |    2 
 drivers/net/wireless/iwlegacy/iwl-dev.h        |   13 ----
 drivers/net/wireless/iwlegacy/iwl4965-base.c   |   19 +++---
 drivers/net/wireless/iwlwifi/iwl-2000.c        |   74 -------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    3 -
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    2 
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |   12 ----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |   19 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   19 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c        |    6 --
 drivers/net/wireless/iwlwifi/iwl-core.h        |    2 
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   13 ----
 drivers/net/wireless/iwlwifi/iwl-rx.c          |   24 ++++----
 drivers/net/wireless/zd1211rw/zd_usb.c         |   53 ++++++++++++++---
 drivers/oprofile/buffer_sync.c                 |   21 +++----
 drivers/pci/hotplug/pcihp_slot.c               |   45 +++++++++++++++
 drivers/pci/intel-iommu.c                      |   48 +++++++++++-----
 drivers/pci/iova.c                             |   12 +++-
 drivers/platform/x86/asus-wmi.c                |    2 
 drivers/scsi/scsi_scan.c                       |    2 
 drivers/scsi/scsi_sysfs.c                      |    1 
 drivers/staging/gma500/psb_fb.c                |   10 +++
 drivers/tty/serial/serial_core.c               |   63 +++------------------
 drivers/usb/class/cdc-acm.c                    |    2 
 drivers/usb/core/hub.c                         |    6 +-
 drivers/usb/host/xhci-dbg.c                    |    8 +-
 drivers/usb/host/xhci-mem.c                    |   14 ++++
 drivers/usb/host/xhci-pci.c                    |   14 ++++
 drivers/usb/host/xhci.c                        |   14 ++++
 drivers/usb/host/xhci.h                        |    6 ++
 drivers/usb/serial/ftdi_sio.c                  |    1 
 drivers/usb/serial/ftdi_sio_ids.h              |    1 
 drivers/usb/serial/option.c                    |   34 ++++++++---
 drivers/usb/storage/transport.c                |   29 +++++++++
 drivers/usb/storage/unusual_devs.h             |   19 ++++++
 drivers/usb/storage/usb.c                      |   13 ++++
 drivers/usb/storage/usb.h                      |    2 
 drivers/video/vga16fb.c                        |    2 
 fs/block_dev.c                                 |    4 -
 fs/cifs/cifsencrypt.c                          |    2 
 fs/cifs/connect.c                              |    6 +-
 fs/dcookies.c                                  |    3 +
 fs/exec.c                                      |    5 -
 fs/fat/file.c                                  |    2 
 fs/ubifs/journal.c                             |    1 
 fs/ubifs/shrinker.c                            |    6 +-
 include/linux/efi.h                            |    1 
 include/linux/usb_usual.h                      |    4 +
 kernel/irq/irqdesc.c                           |    8 +-
 kernel/lockdep.c                               |    2 
 mm/hugetlb.c                                   |    4 -
 net/mac80211/ibss.c                            |    6 +-
 net/wireless/nl80211.c                         |    2 
 security/apparmor/lsm.c                        |    2 
 security/tomoyo/mount.c                        |    2 
 sound/pci/hda/patch_realtek.c                  |    1 
 sound/soc/codecs/ad1836.c                      |   14 ++--
 sound/soc/codecs/ad1836.h                      |    6 ++
 sound/soc/codecs/wm8804.c                      |    9 ++-
 sound/soc/codecs/wm8962.c                      |    4 -
 sound/soc/samsung/i2s.c                        |    4 -
 sound/soc/soc-dapm.c                           |   17 ++---
 98 files changed, 616 insertions(+), 454 deletions(-)


Alan Stern (1):
      usb-storage: redo incorrect reads

Alex Deucher (1):
      drm/radeon/kms: viewport height has to be even

Alex Williamson (2):
      intel-iommu: Flush unmaps at domain_exit
      intel-iommu: Only unlink device domains from iommu

Artem Bityutskiy (2):
      UBIFS: fix shrinker object count reports
      UBIFS: fix memory leak on error path

Bruno Prémont (1):
      video: Fix use-after-free by vga16fb on rmmod

Chris Metcalf (1):
      arch/tile: allocate PCI IRQs later in boot

Chris Wright (2):
      intel-iommu: Check for identity mapping candidate using system dma mask
      intel-iommu: Dont cache iova above 32bit

Dan Carpenter (1):
      xen: off by one errors in multicalls.c

Dan Williams (3):
      option: add Zoom 4597 modem USB IDs
      option: add Alcatel X200 to sendsetup blacklist
      option: add Prolink PH300 modem IDs

Daniel Haid (1):
      drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu

Daniel Halperin (1):
      ath9k: fix two more bugs in tx power

Daniel T Chen (1):
      ALSA: hda: Fix quirk for Dell Inspiron 910

Dave Jones (1):
      CPUFREQ: Remove cpufreq_stats sysfs entries on module unload.

Dmitry Torokhov (1):
      USB: xhci - fix interval calculation for FS isoc endpoints

Florian Fainelli (1):
      x86: devicetree: Add missing early_init_dt_setup_initrd_arch stub

Greg Kroah-Hartman (3):
      Revert "USB: option: add ID for ZTE MF 330"
      Revert "x86, efi: Retain boot service code until after switching to virtual mode"
      Linux 2.6.39.2

Guenter Roeck (1):
      hwmon: (coretemp) Fix TjMax detection for older CPUs

Hans de Goede (1):
      drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

Hugh Dickins (1):
      mm: fix ENOSPC returned by handle_mm_fault()

James Bottomley (1):
      Fix oops caused by queue refcounting failure

Jean Delvare (1):
      hwmon: (coretemp) Relax target temperature range check

Jeff Layton (2):
      cifs: silence printk when establishing first session on socket
      cifs: don't allow cifs_reconnect to exit with NULL socket pointer

Jens Axboe (1):
      block: export blk_{get,put}_queue()

Jiri Slaby (3):
      serial: core, move termios handling to uart_startup
      serial: core, do not set DTR/RTS twice on startup
      serial: core, remove uart_update_termios

Joe Perches (1):
      asus-wmi: Remove __init from asus_wmi_platform_init

Joerg Roedel (3):
      x86/amd-iommu: Use only per-device dma_ops
      x86/amd-iommu: Fix 3 possible endless loops
      x86/amd-iommu: Fix boot crash with hidden PCI devices

Johannes Berg (1):
      mac80211: fix IBSS teardown race

John Johansen (1):
      AppArmor: Fix sleep in invalid context from task_setrlimit

Jordan_Hargrave@Dell.com (1):
      PCI: Set PCIE maxpayload for card during hotplug insertion

Josh Boyer (1):
      powerpc: Fix 32-bit SMP build

Jussi Kivilinna (1):
      zd1211rw: fix to work on OHCI

Lars-Peter Clausen (2):
      ASoC: AD1836: Fix setting the PCM format
      ASoC: snd_soc_new_{mixer,mux,pga} make sure to use right DAPM context

Laurent Pinchart (1):
      media: Fix media device minor registration

Libor Pechacek (1):
      USB: core: Tolerate protocol stall during hub and port status read

Linus Walleij (1):
      genirq: Fix descriptor init on non-sparse IRQs

Luciano Coelho (1):
      nl80211: fix check for valid SSID size in scan operations

Maarten Lankhorst (2):
      xhci: Add defines for hardcoded slot states
      xhci: Do not issue device reset when device is not setup

Marek Olšák (1):
      drm/radeon/kms: do bounds checking for 3D_LOAD_VBPNTR and bump array limit

Mark Brown (2):
      ASoC: Fix WM8962 headphone volume update for use of advanced caches
      ASoC: WM8804 does not support sample rates below 32kHz

Mathias Krause (1):
      exec: delay address limit change until point of no return

Michael Chang (1):
      staging: gma500: get control from firmware framebuffer if conflicts

Mike Habeck (1):
      intel-iommu: Add domain check in domain_remove_one_dev_info

Mike Travis (3):
      intel-iommu: Speed up processing of the identity_mapping function
      intel-iommu: Use coherent DMA mask when requested
      intel-iommu: Remove Host Bridge devices from identity mapping

Namhyung Kim (4):
      nbd: limit module parameters to a sane value
      md: check ->hot_remove_disk when removing disk
      md/raid5: fix raid5_set_bi_hw_segments
      md/raid5: fix FUA request handling in ops_run_io()

OGAWA Hirofumi (1):
      fat: Fix corrupt inode flags when remove ATTR_SYS flag

Peter Zijlstra (1):
      lockdep: Fix lock_is_held() on recursion

Rajkumar Manoharan (2):
      ath9k: Reset chip on baseband hang
      ath9k: set 40 Mhz rate only if hw is configured in ht40

Robert Richter (3):
      oprofile: Free potentially owned tasks in case of errors
      oprofile: Fix locking dependency in sync_start()
      oprofile, dcookies: Fix possible circular locking dependency

Rusty Russell (1):
      lguest: fix timer interrupt setup

Sangbeom Kim (1):
      ASoC: SAMSUNG: Fix the incorrect referencing of I2SCON register

Sarah Sharp (1):
      xhci: Disable MSI for some Fresco Logic hosts.

Stanislaw Gruszka (6):
      iwl4965: fix 5GHz operation
      iwl4965: correctly validate temperature value
      iwlagn: use cts-to-self protection on 5000 adapters series
      iwl4965: set tx power after rxon_assoc
      iwlagn: fix channel switch locking
      iwlegacy: fix channel switch locking

Stefan Metzmacher (1):
      usbnet/cdc_ncm: add missing .reset_resume hook

Steffen Sledz (1):
      USB: serial: add another 4N-GALAXY.DE PID to ftdi_sio driver

Tejun Heo (1):
      block: blkdev_get() should access ->bd_disk only after success

Tetsuo Handa (1):
      TOMOYO: Fix oops in tomoyo_mount_acl().

Thomas Gleixner (1):
      x86: cpu-hotplug: Prevent softirq wakeup on wrong CPU

Toby Gray (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia E7 and C7

Torsten Hilbrich (1):
      USB: option Add blacklist for ZTE K3765-Z (19d2:2002)

Wey-Yi Guy (1):
      iwlagn: send tx power command if defer cause by RXON not match

Williams, Mitch A (1):
      igb: fix i350 SR-IOV failture

kerstin jonsson (1):
      powerpc/4xx: Fix regression in SMP on 476

