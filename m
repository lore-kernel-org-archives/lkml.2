Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240Ab2CIToc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:44:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43849 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2CIToa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:44:30 -0500
Date: Fri, 9 Mar 2012 11:44:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/95] 3.2.10-stable review
Message-ID: <20120309194424.GA2134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.10 release.
There are 95 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 11 19:00:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/hwmon/jc42                    |   26 ++-
 Makefile                                    |    4 +-
 arch/alpha/include/asm/futex.h              |    2 +-
 arch/arm/Kconfig                            |    2 +-
 arch/arm/include/asm/pmu.h                  |    2 +-
 arch/arm/kernel/perf_event.c                |   22 +-
 arch/arm/kernel/perf_event_v6.c             |   22 +--
 arch/arm/kernel/perf_event_v7.c             |   11 +-
 arch/arm/kernel/perf_event_xscale.c         |   20 ++-
 arch/arm/mach-dove/common.c                 |    3 +-
 arch/arm/mach-kirkwood/common.c             |    3 +-
 arch/arm/mach-kirkwood/mpp.h                |  320 +++++++++++++-------------
 arch/arm/mach-lpc32xx/include/mach/irqs.h   |    2 +-
 arch/arm/mach-lpc32xx/irq.c                 |   25 ++-
 arch/arm/mach-lpc32xx/serial.c              |   20 ++-
 arch/arm/mach-mv78xx0/common.c              |    3 +-
 arch/arm/mach-mv78xx0/mpp.h                 |  226 ++++++++++----------
 arch/arm/mach-omap2/board-4430sdp.c         |   22 ++-
 arch/arm/mach-omap2/board-omap4panda.c      |   22 ++-
 arch/arm/mach-omap2/mailbox.c               |    3 +-
 arch/arm/mach-orion5x/common.c              |    4 +-
 arch/arm/mm/proc-v7.S                       |    4 +-
 arch/arm/plat-orion/common.c                |    9 +-
 arch/arm/plat-orion/include/plat/common.h   |    3 +-
 arch/arm/plat-orion/mpp.c                   |    3 +-
 arch/arm/plat-s3c24xx/dma.c                 |    2 +-
 arch/avr32/Kconfig                          |    1 +
 arch/s390/Kconfig                           |    3 +
 arch/s390/include/asm/compat.h              |    7 -
 arch/s390/kernel/process.c                  |    1 -
 arch/s390/kernel/ptrace.c                   |    2 +-
 arch/s390/kernel/setup.c                    |    2 +-
 arch/s390/kernel/signal.c                   |    1 -
 arch/s390/mm/fault.c                        |    1 -
 arch/s390/mm/mmap.c                         |    2 +-
 arch/x86/include/asm/perf_event.h           |    8 +
 arch/x86/kernel/cpu/perf_event.h            |    8 +-
 arch/x86/kernel/cpu/perf_event_amd.c        |   37 +++-
 arch/x86/kvm/svm.c                          |    5 +
 block/bsg.c                                 |    3 +-
 drivers/acpi/sleep.c                        |   16 ++
 drivers/crypto/mv_cesa.c                    |    1 +
 drivers/gpu/drm/i915/i915_reg.h             |   15 ++
 drivers/gpu/drm/i915/intel_display.c        |   32 +++-
 drivers/gpu/drm/radeon/r600_blit_shaders.c  |    8 +
 drivers/hid/hid-ids.h                       |    3 +
 drivers/hid/usbhid/hid-quirks.c             |    1 +
 drivers/hwmon/Kconfig                       |    5 +-
 drivers/hwmon/jc42.c                        |   30 +++-
 drivers/hwmon/pmbus/pmbus_core.c            |    3 +-
 drivers/hwmon/pmbus/zl6100.c                |   10 +-
 drivers/i2c/busses/i2c-mxs.c                |   13 +-
 drivers/input/mouse/alps.c                  |    7 +-
 drivers/iommu/amd_iommu_init.c              |    2 +-
 drivers/iommu/omap-iommu.c                  |    3 +-
 drivers/md/dm-flakey.c                      |    2 +-
 drivers/md/dm-io.c                          |   23 ++-
 drivers/md/dm-ioctl.c                       |    2 +-
 drivers/md/dm-raid.c                        |   17 +-
 drivers/md/dm-thin-metadata.c               |   25 ++-
 drivers/mfd/cs5535-mfd.c                    |    6 +-
 drivers/mfd/mfd-core.c                      |    2 +-
 drivers/mfd/wm8994-core.c                   |   14 ++
 drivers/misc/cs5535-mfgpt.c                 |    2 +-
 drivers/mmc/host/atmel-mci.c                |   21 +-
 drivers/mmc/host/sdhci-esdhc-imx.c          |    5 +-
 drivers/net/usb/cdc_ether.c                 |    7 +
 drivers/net/usb/usbnet.c                    |    2 +
 drivers/net/usb/zaurus.c                    |    7 +
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   25 +--
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |   19 ++
 drivers/net/wireless/ath/ath9k/hw.h         |    1 -
 drivers/net/wireless/ath/carl9170/tx.c      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |   36 +++-
 drivers/rapidio/devices/tsi721.c            |    5 +-
 drivers/regulator/88pm8607.c                |    6 +-
 drivers/s390/block/dasd_eckd.c              |    2 +-
 drivers/s390/block/dasd_ioctl.c             |    1 +
 drivers/s390/char/fs3270.c                  |    1 +
 drivers/s390/char/vmcp.c                    |    1 +
 drivers/s390/cio/chsc_sch.c                 |    1 +
 drivers/s390/cio/qdio_main.c                |    4 +-
 drivers/s390/scsi/zfcp_cfdc.c               |    1 +
 drivers/scsi/osd/osd_uld.c                  |    4 +-
 drivers/spi/spi-topcliff-pch.c              |    6 +-
 drivers/staging/media/lirc/lirc_serial.c    |  100 ++++-----
 drivers/tty/Kconfig                         |    2 +-
 drivers/video/omap2/dss/hdmi.c              |    3 +
 drivers/video/omap2/dss/ti_hdmi.h           |    4 +
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c   |   77 ++++++-
 drivers/video/via/hw.c                      |    4 +
 drivers/watchdog/hpwdt.c                    |    5 +-
 fs/aio.c                                    |    2 +
 fs/autofs4/autofs_i.h                       |    1 +
 fs/autofs4/dev-ioctl.c                      |    1 +
 fs/autofs4/inode.c                          |    2 +
 fs/autofs4/waitq.c                          |   22 ++-
 fs/binfmt_elf.c                             |    2 +-
 fs/cifs/dir.c                               |   20 ++-
 include/linux/compat.h                      |    4 +
 include/linux/regset.h                      |   10 +-
 include/video/omapdss.h                     |    5 +
 kernel/irq/manage.c                         |   44 ++++-
 kernel/kprobes.c                            |   12 +-
 mm/huge_memory.c                            |    6 +-
 mm/memcontrol.c                             |    5 +-
 mm/nommu.c                                  |    2 -
 net/mac80211/rate.c                         |    2 +-
 sound/pci/hda/hda_codec.c                   |    8 +-
 sound/pci/hda/hda_codec.h                   |    3 +
 sound/pci/hda/patch_conexant.c              |   22 ++-
 sound/pci/hda/patch_realtek.c               |    2 +-
 sound/pci/hda/patch_sigmatel.c              |    2 +-
 sound/soc/imx/imx-ssi.c                     |    2 +-
 sound/soc/soc-dapm.c                        |   12 +-
 116 files changed, 1082 insertions(+), 586 deletions(-)

