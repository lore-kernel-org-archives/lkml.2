Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2DKXLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:11:13 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60181 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761176Ab2DKXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:11:10 -0400
Date: Wed, 11 Apr 2012 16:11:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/78] 3.3.2-stable review
Message-ID: <20120411231102.GA6404@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.3.2 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Apr 13 23:10:16 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.3.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                           |    4 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |    3 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |    6 +-
 arch/arm/mach-at91/board-sam9263ek.c               |    1 +
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    1 +
 arch/m68k/mac/config.c                             |    3 +
 arch/x86/include/asm/timer.h                       |    8 +-
 arch/x86/kernel/apic/io_apic.c                     |   40 +----
 arch/x86/kernel/kgdb.c                             |   60 ++++++++
 arch/x86/kernel/tsc.c                              |    3 +-
 arch/x86/net/bpf_jit_comp.c                        |    2 +-
 drivers/acpi/acpica/tbfadt.c                       |    8 +-
 drivers/acpi/processor_thermal.c                   |   45 +++++-
 drivers/base/firmware_class.c                      |   96 ++++++++----
 drivers/base/power/runtime.c                       |    3 +-
 drivers/base/regmap/regcache-rbtree.c              |    8 +-
 drivers/dma/ioat/dma.c                             |   16 +-
 drivers/dma/ioat/dma.h                             |    6 +-
 drivers/dma/ioat/dma_v2.c                          |    8 +-
 drivers/dma/ioat/dma_v3.c                          |    8 +-
 drivers/gpu/drm/drm_fb_helper.c                    |    8 +-
 drivers/gpu/drm/i915/i915_drv.c                    |    2 +
 drivers/gpu/drm/i915/i915_reg.h                    |    1 +
 drivers/gpu/drm/i915/intel_bios.c                  |   23 ++-
 drivers/gpu/drm/i915/intel_display.c               |    6 +
 drivers/gpu/drm/i915/intel_lvds.c                  |    8 +
 drivers/gpu/drm/i915/intel_sprite.c                |    3 +
 drivers/gpu/drm/radeon/atom.c                      |   15 +-
 drivers/gpu/drm/radeon/atom.h                      |    1 +
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   12 ++
 drivers/media/video/uvc/uvc_video.c                |   50 +++---
 drivers/mfd/da9052-spi.c                           |    4 +-
 drivers/mfd/twl6030-irq.c                          |   13 +-
 drivers/misc/kgdbts.c                              |  160 ++++++++++++++------
 drivers/mmc/core/sdio_bus.c                        |   12 +-
 drivers/mmc/host/atmel-mci.c                       |    9 +-
 drivers/mmc/host/sdhci-dove.c                      |    1 +
 drivers/mtd/devices/block2mtd.c                    |    1 +
 drivers/mtd/devices/doc2000.c                      |    2 +-
 drivers/mtd/devices/doc2001.c                      |    2 +-
 drivers/mtd/devices/doc2001plus.c                  |    2 +-
 drivers/mtd/devices/docg3.c                        |    2 +-
 drivers/mtd/devices/lart.c                         |    1 +
 drivers/mtd/devices/m25p80.c                       |    1 +
 drivers/mtd/devices/sst25l.c                       |    1 +
 drivers/mtd/maps/ixp4xx.c                          |    5 +-
 drivers/mtd/maps/lantiq-flash.c                    |    3 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                |    4 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   12 +-
 drivers/net/ethernet/marvell/sky2.c                |    5 +-
 drivers/net/ethernet/via/via-rhine.c               |   12 +-
 drivers/net/usb/cdc_eem.c                          |    1 +
 drivers/net/usb/zaurus.c                           |    5 +
 drivers/net/wireless/ath/ath9k/calib.c             |    5 +-
 drivers/net/wireless/iwlegacy/3945-mac.c           |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c           |    1 -
 drivers/net/wireless/iwlegacy/common.c             |   18 ++-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |    2 +-
 drivers/platform/x86/acer-wmi.c                    |    1 +
 drivers/pnp/pnpacpi/core.c                         |    7 +-
 drivers/staging/android/lowmemorykiller.c          |   47 +-----
 drivers/target/tcm_fc/tcm_fc.h                     |    1 +
 drivers/target/tcm_fc/tfc_cmd.c                    |   10 +-
 drivers/target/tcm_fc/tfc_conf.c                   |   13 +-
 drivers/target/tcm_fc/tfc_io.c                     |    2 +
 drivers/usb/host/ohci-at91.c                       |    4 +-
 fs/cifs/file.c                                     |   10 +-
 fs/locks.c                                         |    3 +-
 fs/nfs/nfs4proc.c                                  |    2 +-
 include/linux/fs.h                                 |    5 +
 include/linux/kernel.h                             |   13 ++
 include/linux/kgdb.h                               |    7 +-
 include/linux/kmod.h                               |   27 +++-
 kernel/cred.c                                      |    2 +
 kernel/debug/debug_core.c                          |   53 +++----
 kernel/irq/migration.c                             |   10 +-
 kernel/kmod.c                                      |  117 ++++++++++----
 kernel/power/hibernate.c                           |   18 +--
 kernel/power/process.c                             |    8 +
 kernel/power/suspend.c                             |    7 -
 kernel/power/user.c                                |   10 +-
 kernel/sysctl.c                                    |    8 +-
 kernel/trace/trace.c                               |    4 +
 kernel/trace/trace_entries.h                       |   16 +-
 kernel/trace/trace_export.c                        |    2 +-
 net/mac80211/agg-rx.c                              |    3 +-
 net/rose/rose_dev.c                                |    4 +-
 scripts/mod/modpost.c                              |    9 +-
 scripts/mod/modpost.h                              |    1 +
 security/tomoyo/mount.c                            |   38 ++---
 sound/pci/hda/patch_realtek.c                      |   11 +-
 sound/soc/codecs/ak4642.c                          |    2 +-
 sound/soc/codecs/wm8994.c                          |    2 +-
 sound/soc/tegra/tegra_i2s.c                        |    2 +-
 96 files changed, 815 insertions(+), 411 deletions(-)

