Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441Ab2DKXMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:12:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57268 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761176Ab2DKXMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:12:16 -0400
Date: Wed, 11 Apr 2012 16:12:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/59] 3.2.15-stable review
Message-ID: <20120411231213.GA13124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.15 release.
There are 59 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Apr 13 23:10:33 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.15-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                           |    4 +-
 arch/arm/mach-tegra/Kconfig                        |    5 -
 arch/m68k/mac/config.c                             |    3 +
 arch/x86/include/asm/timer.h                       |    8 +-
 arch/x86/kernel/apic/io_apic.c                     |   40 +----
 arch/x86/kernel/kgdb.c                             |   60 ++++++++
 arch/x86/kernel/tsc.c                              |    3 +-
 arch/x86/net/bpf_jit_comp.c                        |    2 +-
 arch/x86/pci/acpi.c                                |   10 ++
 drivers/acpi/acpica/tbfadt.c                       |    8 +-
 drivers/acpi/processor_thermal.c                   |   45 +++++-
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
 drivers/gpu/drm/radeon/atom.c                      |   15 +-
 drivers/gpu/drm/radeon/atom.h                      |    1 +
 drivers/iommu/amd_iommu_init.c                     |   24 ++-
 drivers/mfd/twl6030-irq.c                          |   13 +-
 drivers/misc/kgdbts.c                              |  160 ++++++++++++++------
 drivers/mmc/host/atmel-mci.c                       |    9 +-
 drivers/mmc/host/sdhci-dove.c                      |    1 +
 drivers/mtd/devices/block2mtd.c                    |    1 +
 drivers/mtd/devices/lart.c                         |    1 +
 drivers/mtd/devices/m25p80.c                       |    1 +
 drivers/mtd/devices/sst25l.c                       |    1 +
 drivers/mtd/maps/ixp4xx.c                          |    5 +-
 drivers/mtd/maps/lantiq-flash.c                    |    3 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                |    4 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   13 +-
 drivers/net/ethernet/marvell/sky2.c                |    5 +-
 drivers/net/ethernet/realtek/r8169.c               |    5 +
 drivers/net/usb/cdc_eem.c                          |    1 +
 drivers/net/usb/zaurus.c                           |    5 +
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |    2 +-
 drivers/platform/x86/acer-wmi.c                    |    1 +
 drivers/pnp/pnpacpi/core.c                         |    7 +-
 drivers/target/target_core_transport.c             |    6 +-
 drivers/target/tcm_fc/tcm_fc.h                     |    1 +
 drivers/target/tcm_fc/tfc_cmd.c                    |   10 +-
 drivers/target/tcm_fc/tfc_conf.c                   |   13 +-
 drivers/target/tcm_fc/tfc_io.c                     |    2 +
 fs/cifs/file.c                                     |   10 +-
 fs/locks.c                                         |    3 +-
 fs/nfs/nfs4proc.c                                  |    2 +-
 include/linux/fs.h                                 |    5 +
 include/linux/kernel.h                             |   13 ++
 include/linux/kgdb.h                               |    7 +-
 kernel/cred.c                                      |    2 +
 kernel/debug/debug_core.c                          |   53 +++----
 kernel/irq/migration.c                             |   10 +-
 kernel/sysctl.c                                    |    8 +-
 kernel/trace/trace.c                               |    4 +
 kernel/trace/trace_entries.h                       |   16 +-
 kernel/trace/trace_export.c                        |    2 +-
 net/bluetooth/hci_conn.c                           |    4 +
 net/mac80211/agg-rx.c                              |    3 +-
 net/rose/rose_dev.c                                |    4 +-
 scripts/mod/modpost.c                              |    9 +-
 scripts/mod/modpost.h                              |    1 +
 security/tomoyo/mount.c                            |   38 ++---
 sound/soc/codecs/ak4642.c                          |    2 +-
 sound/soc/codecs/wm8994.c                          |    2 +-
 71 files changed, 550 insertions(+), 236 deletions(-)

