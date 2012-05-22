Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2EVNUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:20:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49546 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2EVNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:20:10 -0400
Date: Tue, 22 May 2012 06:20:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial patches for 3.5-rc1
Message-ID: <20120522132006.GA1444@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.5-rc1

for you to fetch changes up to d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

----------------------------------------------------------------
TTY pull request for 3.5-rc1

Here's the big TTY/serial driver pull request for the 3.5-rc1 merge window.

Nothing major in here, just lots of incremental changes from Alan and
Jiri reworking some tty core things to behave better and to get a more
solid grasp on some of the nasty tty locking issues.

There are a few tty and serial driver updates in here as well.

All of this has been in the linux-next releases for a while with no problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------

 Documentation/ABI/testing/sysfs-bus-hsi            |   19 -
 .../ata/{ahci-platform.txt => calxeda-sata.txt}    |    5 +-
 .../devicetree/bindings/sound/sgtl5000.txt         |    2 -
 Documentation/networking/ip-sysctl.txt             |    4 +-
 Documentation/power/freezing-of-tasks.txt          |   37 +-
 Documentation/security/keys.txt                    |   14 +-
 MAINTAINERS                                        |   12 +-
 Makefile                                           |    2 +-
 arch/alpha/Kconfig                                 |    2 +-
 arch/alpha/include/asm/rtc.h                       |    8 +-
 arch/alpha/kernel/core_tsunami.c                   |    1 -
 arch/alpha/kernel/sys_marvel.c                     |    2 +-
 arch/arm/Kconfig                                   |    9 -
 arch/arm/boot/dts/msm8660-surf.dts                 |    4 +-
 arch/arm/boot/dts/versatile-ab.dts                 |    2 +-
 arch/arm/boot/dts/versatile-pb.dts                 |    2 +-
 arch/arm/configs/mini2440_defconfig                |    2 -
 arch/arm/include/asm/thread_info.h                 |    7 -
 arch/arm/include/asm/tls.h                         |    4 -
 arch/arm/kernel/irq.c                              |    6 +-
 arch/arm/kernel/signal.c                           |   55 ++-
 arch/arm/kernel/smp.c                              |   28 +-
 arch/arm/kernel/smp_twd.c                          |    6 +-
 arch/arm/mach-exynos/clock-exynos4.c               |   24 +-
 arch/arm/mach-exynos/clock-exynos5.c               |   24 +-
 arch/arm/mach-exynos/common.c                      |   14 +-
 arch/arm/mach-exynos/dev-dwmci.c                   |   13 +-
 arch/arm/mach-exynos/mach-nuri.c                   |    1 -
 arch/arm/mach-exynos/mach-universal_c210.c         |    1 -
 arch/arm/mach-msm/board-msm8x60.c                  |   25 +-
 arch/arm/mach-omap2/serial.c                       |    8 -
 arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h        |    7 -
 arch/arm/mach-pxa/mfp-pxa2xx.c                     |   21 +-
 arch/arm/mach-pxa/pxa27x.c                         |    6 +-
 arch/arm/mach-s3c24xx/Kconfig                      |    8 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    2 -
 arch/arm/mach-sa1100/generic.c                     |    2 +-
 arch/arm/mach-tegra/board-harmony.c                |    2 +
 arch/arm/mach-tegra/board-paz00.c                  |    3 +
 arch/arm/mach-tegra/board-seaboard.c               |    2 +
 arch/arm/mach-tegra/board-trimslice.c              |    2 +
 arch/arm/mach-u300/core.c                          |    6 +-
 arch/arm/mach-u300/i2c.c                           |    9 +-
 arch/arm/mach-u300/include/mach/irqs.h             |  150 +++----
 arch/arm/mach-ux500/mbox-db5500.c                  |    2 +-
 arch/arm/mm/abort-ev6.S                            |   17 +-
 arch/arm/mm/cache-l2x0.c                           |   25 +-
 arch/arm/mm/init.c                                 |    4 +-
 arch/arm/mm/mmu.c                                  |    4 +-
 arch/arm/plat-omap/dma.c                           |   14 -
 arch/arm/plat-omap/include/plat/omap-serial.h      |    1 -
 arch/arm/plat-samsung/include/plat/sdhci.h         |   28 --
 arch/arm/vfp/vfpmodule.c                           |   99 -----
 arch/blackfin/mach-bf538/boards/ezkit.c            |   53 +--
 arch/hexagon/kernel/dma.c                          |    1 -
 arch/hexagon/kernel/process.c                      |    6 +-
 arch/hexagon/kernel/ptrace.c                       |    1 -
 arch/hexagon/kernel/smp.c                          |    8 +-
 arch/hexagon/kernel/time.c                         |    1 -
 arch/hexagon/kernel/vdso.c                         |    1 -
 arch/mips/ath79/dev-wmac.c                         |    2 +-
 arch/mips/include/asm/mach-jz4740/irq.h            |    2 +-
 arch/mips/include/asm/mmu_context.h                |    6 +
 arch/mips/kernel/signal.c                          |   27 +-
 arch/mips/kernel/signal32.c                        |   20 +-
 arch/mips/kernel/signal_n32.c                      |   10 +-
 arch/parisc/kernel/pdc_cons.c                      |    2 +-
 arch/powerpc/boot/dts/fsl/pq3-mpic-message-B.dtsi  |   43 --
 arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi            |   10 -
 arch/powerpc/include/asm/irq.h                     |    4 +
 arch/powerpc/include/asm/mpic.h                    |   18 +
 arch/powerpc/include/asm/mpic_msgr.h               |    1 -
 arch/powerpc/include/asm/reg_booke.h               |    5 +
 arch/powerpc/kernel/irq.c                          |    6 +-
 arch/powerpc/kernel/machine_kexec.c                |    7 +-
 arch/powerpc/kernel/setup_32.c                     |    3 -
 arch/powerpc/net/bpf_jit.h                         |    8 +-
 arch/powerpc/net/bpf_jit_64.S                      |  108 +----
 arch/powerpc/net/bpf_jit_comp.c                    |   26 +-
 arch/powerpc/platforms/85xx/common.c               |    6 -
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |   11 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |   13 +-
 arch/powerpc/platforms/cell/axon_msi.c             |    8 +-
 arch/powerpc/platforms/cell/beat_interrupt.c       |    2 +-
 arch/powerpc/platforms/powermac/low_i2c.c          |    9 -
 arch/powerpc/platforms/powermac/pic.c              |    6 +-
 arch/powerpc/platforms/pseries/Kconfig             |    4 +-
 arch/powerpc/platforms/pseries/eeh.c               |    2 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |    3 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                   |   61 ++-
 arch/powerpc/sysdev/mpic.c                         |   54 +--
 arch/powerpc/sysdev/mpic_msgr.c                    |   12 +-
 arch/powerpc/sysdev/scom.c                         |    1 -
 arch/powerpc/sysdev/xics/xics-common.c             |    7 +-
 arch/sh/include/asm/atomic.h                       |    2 +-
 arch/sh/mm/fault_32.c                              |    2 +-
 arch/tile/include/asm/pci.h                        |    4 +-
 arch/tile/kernel/pci.c                             |    4 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/boot/compressed/head_32.S                 |   14 +-
 arch/x86/boot/compressed/head_64.S                 |   22 +-
 arch/x86/boot/compressed/relocs.c                  |    2 +
 arch/x86/boot/tools/build.c                        |   15 +-
 arch/x86/ia32/ia32_aout.c                          |    3 +-
 arch/x86/include/asm/posix_types.h                 |    6 +-
 arch/x86/include/asm/sigcontext.h                  |    2 +-
 arch/x86/include/asm/siginfo.h                     |    8 +-
 arch/x86/include/asm/unistd.h                      |    6 +-
 arch/x86/include/asm/word-at-a-time.h              |   33 --
 arch/x86/include/asm/x86_init.h                    |    1 +
 arch/x86/kernel/acpi/sleep.c                       |    4 -
 arch/x86/kernel/acpi/sleep.h                       |    4 -
 arch/x86/kernel/acpi/wakeup_32.S                   |    4 +-
 arch/x86/kernel/acpi/wakeup_64.S                   |    4 +-
 arch/x86/kernel/apic/apic.c                        |   34 +-
 arch/x86/kernel/apic/apic_numachip.c               |    7 +-
 arch/x86/kernel/apic/x2apic_phys.c                 |    6 -
 arch/x86/kernel/cpu/amd.c                          |   29 +-
 arch/x86/kernel/cpu/common.c                       |    9 +
 arch/x86/kernel/cpu/intel_cacheinfo.c              |    8 +-
 arch/x86/kernel/i387.c                             |    1 -
 arch/x86/kernel/microcode_amd.c                    |   12 +-
 arch/x86/kernel/microcode_core.c                   |   10 +-
 arch/x86/kernel/x86_init.c                         |    1 +
 arch/x86/platform/geode/net5501.c                  |    2 +-
 arch/x86/platform/mrst/mrst.c                      |    4 +-
 arch/x86/xen/enlighten.c                           |    4 +-
 arch/x86/xen/smp.c                                 |   15 -
 arch/x86/xen/xen-asm.S                             |    2 +-
 arch/xtensa/include/asm/hardirq.h                  |    3 +
 arch/xtensa/include/asm/io.h                       |    1 -
 arch/xtensa/kernel/signal.c                        |    1 -
 drivers/acpi/power.c                               |    2 +-
 drivers/acpi/scan.c                                |   17 +-
 drivers/acpi/sleep.c                               |   52 +--
 drivers/ata/ahci.c                                 |    2 -
 drivers/ata/ahci_platform.c                        |    1 -
 drivers/ata/libata-core.c                          |    2 +-
 drivers/ata/libata-eh.c                            |    3 +-
 drivers/ata/libata-scsi.c                          |   38 +-
 drivers/ata/pata_arasan_cf.c                       |    4 +-
 drivers/bcma/sprom.c                               |    7 +-
 drivers/bluetooth/ath3k.c                          |    4 -
 drivers/bluetooth/btusb.c                          |    6 -
 drivers/dma/amba-pl08x.c                           |    1 -
 drivers/dma/at_hdmac.c                             |    4 +
 drivers/dma/imx-dma.c                              |    9 +-
 drivers/dma/mxs-dma.c                              |   10 +-
 drivers/dma/pl330.c                                |   25 +-
 drivers/dma/ste_dma40.c                            |  323 +++++---------
 drivers/dma/ste_dma40_ll.h                         |    2 +
 drivers/firmware/efivars.c                         |  196 --------
 drivers/gpio/gpio-pxa.c                            |   21 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |   30 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    3 -
 drivers/gpu/drm/i915/i915_dma.c                    |   15 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |    8 +-
 drivers/gpu/drm/i915/i915_reg.h                    |    1 -
 drivers/gpu/drm/i915/intel_crt.c                   |   29 +-
 drivers/gpu/drm/i915/intel_display.c               |    9 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |    4 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |    8 -
 drivers/gpu/drm/i915/intel_sdvo.c                  |   34 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |   10 +-
 drivers/gpu/drm/nouveau/nouveau_hdmi.c             |    4 +-
 drivers/gpu/drm/nouveau/nv10_gpio.c                |    2 +-
 drivers/gpu/drm/nouveau/nvc0_fb.c                  |    5 -
 drivers/gpu/drm/radeon/atombios_crtc.c             |    7 +-
 drivers/gpu/drm/radeon/radeon_device.c             |    4 +-
 drivers/gpu/drm/radeon/radeon_display.c            |    3 +-
 drivers/hsi/clients/hsi_char.c                     |    2 +-
 drivers/hsi/hsi.c                                  |  223 +++++-----
 drivers/hwmon/ad7314.c                             |   12 +-
 drivers/hwmon/coretemp.c                           |    6 +-
 drivers/hwmon/fam15h_power.c                       |    9 +-
 drivers/i2c/busses/i2c-eg20t.c                     |    4 +-
 drivers/i2c/busses/i2c-mxs.c                       |    8 +-
 drivers/i2c/busses/i2c-pnx.c                       |    3 +-
 drivers/i2c/busses/i2c-tegra.c                     |    8 -
 drivers/infiniband/core/mad.c                      |    8 +-
 drivers/infiniband/hw/mlx4/main.c                  |    2 +-
 drivers/input/mouse/synaptics.c                    |    3 +-
 drivers/isdn/i4l/isdn_common.c                     |    5 -
 drivers/isdn/i4l/isdn_tty.c                        |  466 ++++++++------------
 drivers/md/bitmap.c                                |    3 +-
 drivers/md/bitmap.h                                |    3 +
 drivers/md/dm-raid.c                               |    4 +-
 drivers/md/md.c                                    |    7 +-
 drivers/mfd/omap-usb-host.c                        |    1 -
 drivers/mmc/host/mxs-mmc.c                         |    3 -
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |    1 -
 drivers/net/arcnet/arc-rimi.c                      |    8 +-
 drivers/net/caif/caif_hsi.c                        |    9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    2 -
 drivers/net/dummy.c                                |    6 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |   12 +-
 drivers/net/ethernet/atheros/atlx/atl1.h           |    3 +-
 drivers/net/ethernet/atheros/atlx/atlx.c           |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   |   12 +-
 drivers/net/ethernet/broadcom/tg3.c                |   18 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   92 ++--
 drivers/net/ethernet/dlink/dl2k.c                  |   52 ++-
 drivers/net/ethernet/dlink/dl2k.h                  |    7 +
 drivers/net/ethernet/freescale/ucc_geth.c          |    6 +-
 drivers/net/ethernet/freescale/ucc_geth.h          |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   60 ++-
 drivers/net/ethernet/ibm/ehea/ehea_phyp.h          |    2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   15 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    2 +-
 drivers/net/ethernet/intel/e1000e/param.c          |   99 ++---
 drivers/net/ethernet/intel/igbvf/netdev.c          |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |    1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |   10 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   29 +-
 drivers/net/ethernet/marvell/sky2.c                |   31 +-
 drivers/net/ethernet/marvell/sky2.h                |    1 +
 drivers/net/ethernet/micrel/ks8851.c               |   21 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |    2 +-
 drivers/net/ethernet/micrel/ksz884x.c              |    2 +-
 drivers/net/ethernet/realtek/8139cp.c              |   10 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   17 +-
 drivers/net/ethernet/sun/sungem.c                  |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    2 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |    5 -
 drivers/net/ethernet/ti/tlan.c                     |    2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |    4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  |    6 +-
 drivers/net/hyperv/netvsc_drv.c                    |   38 +-
 drivers/net/phy/icplus.c                           |   12 +-
 drivers/net/ppp/ppp_generic.c                      |   15 +-
 drivers/net/usb/asix.c                             |    4 +-
 drivers/net/usb/hso.c                              |  105 ++---
 drivers/net/usb/qmi_wwan.c                         |   30 --
 drivers/net/usb/smsc75xx.c                         |   36 +-
 drivers/net/usb/smsc95xx.c                         |    3 +-
 drivers/net/usb/usbnet.c                           |    5 +-
 drivers/net/virtio_net.c                           |    5 +-
 drivers/net/wan/farsync.c                          |    1 -
 drivers/net/wireless/ath/ath5k/ahb.c               |    8 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |    2 -
 drivers/net/wireless/ath/ath9k/hw.c                |    9 +-
 drivers/net/wireless/ath/ath9k/hw.h                |    3 +-
 drivers/net/wireless/ath/ath9k/main.c              |    9 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   10 +-
 drivers/net/wireless/b43/main.c                    |   10 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   63 +--
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   11 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |   13 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |    8 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c            |   16 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |   11 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |    3 +
 drivers/net/wireless/iwlwifi/iwl-fh.h              |   24 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c        |   10 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |   27 +-
 drivers/net/wireless/libertas/cfg.c                |    9 +-
 drivers/net/wireless/mwifiex/pcie.h                |   18 +-
 drivers/net/wireless/rtlwifi/pci.c                 |    1 -
 drivers/net/wireless/wl1251/main.c                 |    1 -
 drivers/net/wireless/wl1251/sdio.c                 |    2 +-
 drivers/pci/Makefile                               |    1 -
 drivers/pci/pci-acpi.c                             |    4 +-
 drivers/platform/x86/acerhdf.c                     |   67 +--
 drivers/platform/x86/dell-laptop.c                 |    1 -
 drivers/platform/x86/intel_ips.c                   |    2 +-
 drivers/platform/x86/intel_mid_powerbtn.c          |    2 +-
 drivers/rtc/rtc-ds1307.c                           |    1 -
 drivers/rtc/rtc-mpc5121.c                          |    3 +-
 drivers/s390/char/con3215.c                        |  142 +++---
 drivers/s390/char/keyboard.c                       |   30 +-
 drivers/s390/char/keyboard.h                       |   14 +-
 drivers/s390/char/sclp_tty.c                       |   33 +-
 drivers/s390/char/sclp_vt220.c                     |   33 +-
 drivers/s390/char/tty3270.c                        |  121 +++--
 drivers/s390/net/qeth_core_main.c                  |    6 +-
 drivers/scsi/ipr.c                                 |    6 +-
 drivers/scsi/libfc/fc_lport.c                      |   12 +-
 drivers/scsi/libsas/sas_ata.c                      |   33 +-
 drivers/scsi/libsas/sas_discover.c                 |   61 ++-
 drivers/scsi/libsas/sas_event.c                    |   24 +-
 drivers/scsi/libsas/sas_expander.c                 |   56 +--
 drivers/scsi/libsas/sas_init.c                     |   11 +-
 drivers/scsi/libsas/sas_internal.h                 |    6 +-
 drivers/scsi/libsas/sas_phy.c                      |   21 +-
 drivers/scsi/libsas/sas_port.c                     |   17 +-
 drivers/scsi/scsi_lib.c                            |    2 +-
 drivers/spi/Kconfig                                |    2 +-
 drivers/spi/Makefile                               |    2 +-
 drivers/spi/spi-bcm63xx.c                          |  163 +++----
 drivers/spi/spi-bfin-sport.c                       |   21 +-
 drivers/spi/spi-bfin5xx.c                          |   14 +-
 drivers/spi/spi-ep93xx.c                           |   24 +-
 drivers/spi/spi-pl022.c                            |   58 +--
 drivers/staging/octeon/ethernet-rx.c               |    1 -
 drivers/staging/octeon/ethernet-tx.c               |    1 -
 drivers/staging/octeon/ethernet.c                  |    1 -
 drivers/staging/ozwpan/ozpd.c                      |    2 +
 drivers/staging/serial/68360serial.c               |    4 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |   20 +-
 drivers/staging/tidspbridge/core/wdt.c             |    8 +-
 drivers/staging/zcache/Kconfig                     |    2 +-
 drivers/tty/amiserial.c                            |   14 +-
 drivers/tty/bfin_jtag_comm.c                       |   44 +-
 drivers/tty/cyclades.c                             |    2 +-
 drivers/tty/hvc/hvc_console.c                      |   96 ++--
 drivers/tty/hvc/hvc_console.h                      |    4 +-
 drivers/tty/hvc/hvc_xen.c                          |    4 +-
 drivers/tty/hvc/hvcs.c                             |   74 ++--
 drivers/tty/hvc/hvsi.c                             |  128 +++---
 drivers/tty/hvc/hvsi_lib.c                         |    2 +-
 drivers/tty/ipwireless/tty.c                       |   81 ++--
 drivers/tty/mxser.c                                |    2 +-
 drivers/tty/n_r3964.c                              |   11 +-
 drivers/tty/n_tty.c                                |    9 +-
 drivers/tty/pty.c                                  |   40 +-
 drivers/tty/serial/68328serial.c                   |  383 +++++++---------
 drivers/tty/serial/68328serial.h                   |  186 --------
 drivers/tty/serial/8250/8250.c                     |  312 +++++++------
 drivers/tty/serial/8250/8250.h                     |   16 +
 drivers/tty/serial/8250/8250_em.c                  |  186 ++++++++
 drivers/tty/serial/8250/8250_pci.c                 |   63 +++
 drivers/tty/serial/8250/Kconfig                    |    8 +
 drivers/tty/serial/8250/Makefile                   |    1 +
 drivers/tty/serial/amba-pl011.c                    |  109 +----
 drivers/tty/serial/bfin_uart.c                     |   74 ++--
 drivers/tty/serial/crisv10.c                       |   36 +-
 drivers/tty/serial/mxs-auart.c                     |    2 +
 drivers/tty/serial/of_serial.c                     |   26 ++
 drivers/tty/serial/omap-serial.c                   |   74 +++-
 drivers/tty/serial/pch_uart.c                      |   53 ++-
 drivers/tty/serial/pmac_zilog.c                    |    6 +-
 drivers/tty/serial/serial_core.c                   |    1 +
 drivers/tty/synclink.c                             |    4 +-
 drivers/tty/synclink_gt.c                          |    4 +-
 drivers/tty/synclinkmp.c                           |    4 +-
 drivers/tty/tty_buffer.c                           |   85 +++-
 drivers/tty/tty_io.c                               |   76 ++--
 drivers/tty/tty_ldisc.c                            |   37 +-
 drivers/tty/tty_mutex.c                            |   60 ++-
 drivers/tty/tty_port.c                             |    6 +-
 drivers/tty/vt/consolemap.c                        |  123 ++++--
 drivers/tty/vt/keyboard.c                          |   28 +-
 drivers/tty/vt/vt.c                                |   68 ++-
 drivers/tty/vt/vt_ioctl.c                          |   25 +-
 drivers/usb/class/cdc-wdm.c                        |    7 +-
 drivers/usb/core/hcd-pci.c                         |    9 -
 drivers/usb/gadget/dummy_hcd.c                     |    1 +
 drivers/usb/gadget/f_mass_storage.c                |    2 +-
 drivers/usb/gadget/file_storage.c                  |    2 +-
 drivers/usb/gadget/u_serial.c                      |   51 +--
 drivers/usb/gadget/udc-core.c                      |    4 +-
 drivers/usb/gadget/uvc.h                           |    2 +-
 drivers/usb/gadget/uvc_v4l2.c                      |    2 +-
 drivers/usb/host/ehci-pci.c                        |    8 -
 drivers/usb/host/ehci-tegra.c                      |  376 ++++++++--------
 drivers/usb/musb/davinci.c                         |    3 +-
 drivers/usb/musb/musb_core.h                       |    2 +-
 drivers/usb/otg/gpio_vbus.c                        |   15 +-
 drivers/vhost/net.c                                |    2 +-
 drivers/vhost/vhost.c                              |    5 +-
 drivers/vhost/vhost.h                              |    2 +-
 drivers/video/bfin-lq035q1-fb.c                    |    1 -
 drivers/watchdog/hpwdt.c                           |    6 +-
 drivers/xen/events.c                               |    2 +-
 drivers/xen/xen-acpi-processor.c                   |    5 +-
 fs/autofs4/autofs_i.h                              |   12 +-
 fs/autofs4/dev-ioctl.c                             |    3 +-
 fs/autofs4/inode.c                                 |    4 +-
 fs/autofs4/waitq.c                                 |   22 +-
 fs/btrfs/backref.c                                 |   27 +-
 fs/btrfs/ctree.c                                   |   28 +-
 fs/btrfs/ctree.h                                   |    2 +-
 fs/btrfs/disk-io.c                                 |   40 +-
 fs/btrfs/disk-io.h                                 |    3 +-
 fs/btrfs/extent-tree.c                             |   17 +-
 fs/btrfs/extent_io.c                               |   60 +--
 fs/btrfs/extent_io.h                               |    4 +-
 fs/btrfs/file.c                                    |    9 +-
 fs/btrfs/inode.c                                   |   54 ++-
 fs/btrfs/ioctl.c                                   |    5 +-
 fs/btrfs/ioctl.h                                   |    4 +-
 fs/btrfs/reada.c                                   |   48 +-
 fs/btrfs/relocation.c                              |    4 +-
 fs/btrfs/scrub.c                                   |   22 +-
 fs/btrfs/super.c                                   |    7 +-
 fs/btrfs/transaction.c                             |    6 +-
 fs/btrfs/tree-log.c                                |    2 +-
 fs/btrfs/volumes.c                                 |   13 +-
 fs/buffer.c                                        |    1 +
 fs/cifs/cifsfs.c                                   |   14 +-
 fs/cifs/cifsfs.h                                   |    2 +-
 fs/cifs/cifssmb.c                                  |    6 +-
 fs/cifs/connect.c                                  |   33 +-
 fs/cifs/dir.c                                      |   17 +-
 fs/cifs/file.c                                     |    3 +-
 fs/dcache.c                                        |   26 +-
 fs/dlm/lock.c                                      |   12 -
 fs/eventpoll.c                                     |    4 +-
 fs/ext4/super.c                                    |    2 -
 fs/gfs2/lock_dlm.c                                 |   10 +-
 fs/hfsplus/catalog.c                               |    4 -
 fs/hfsplus/dir.c                                   |   11 -
 fs/hugetlbfs/inode.c                               |    1 -
 fs/jbd2/commit.c                                   |    4 +-
 fs/namei.c                                         |    4 +-
 fs/nfs/blocklayout/blocklayout.c                   |    4 +-
 fs/nfs/client.c                                    |    5 +-
 fs/nfs/dir.c                                       |    4 +-
 fs/nfs/idmap.c                                     |    4 -
 fs/nfs/internal.h                                  |    8 +-
 fs/nfs/namespace.c                                 |   93 ++--
 fs/nfs/nfs4_fs.h                                   |   11 +-
 fs/nfs/nfs4filelayoutdev.c                         |    2 +-
 fs/nfs/nfs4namespace.c                             |   86 +---
 fs/nfs/nfs4proc.c                                  |  186 ++------
 fs/nfs/nfs4state.c                                 |   31 +-
 fs/nfs/nfs4xdr.c                                   |   53 +--
 fs/nfs/objlayout/objlayout.c                       |    2 +
 fs/nfs/pnfs.c                                      |    2 +-
 fs/nfs/read.c                                      |    2 +-
 fs/nfs/super.c                                     |   12 +-
 fs/nfs/write.c                                     |    5 +-
 fs/nfsd/nfs4recover.c                              |    2 +-
 fs/pipe.c                                          |   31 +-
 fs/proc/task_mmu.c                                 |    3 +
 include/acpi/actypes.h                             |    7 +-
 include/asm-generic/siginfo.h                      |   14 +-
 include/asm-generic/statfs.h                       |    2 +-
 include/linux/efi.h                                |   13 +-
 include/linux/generic_serial.h                     |   64 +--
 include/linux/gpio-pxa.h                           |    4 -
 include/linux/hsi/hsi.h                            |   31 +-
 include/linux/irq.h                                |    7 -
 include/linux/isdn.h                               |   26 +-
 include/linux/libata.h                             |    3 +-
 include/linux/netfilter_bridge.h                   |    9 -
 include/linux/nfs_xdr.h                            |    7 +-
 include/linux/of_serial.h                          |   17 +
 include/linux/pipe_fs_i.h                          |    1 -
 include/linux/seqlock.h                            |   23 +-
 include/linux/serial_8250.h                        |    2 +
 include/linux/serial_core.h                        |    5 +
 include/linux/skbuff.h                             |   11 +-
 include/linux/spi/spi.h                            |    2 +-
 include/linux/tty.h                                |   23 +-
 include/linux/tty_ldisc.h                          |    2 +
 include/linux/usb/hcd.h                            |    2 -
 include/linux/vm_event_item.h                      |    5 +-
 include/linux/vt_kern.h                            |    1 -
 include/net/bluetooth/hci_core.h                   |    3 +-
 include/net/dst.h                                  |    7 +-
 include/net/ip6_fib.h                              |   48 --
 include/net/ip_vs.h                                |    4 +-
 include/net/red.h                                  |    6 +-
 include/net/sock.h                                 |    5 +-
 include/scsi/libsas.h                              |   40 +-
 include/scsi/sas_ata.h                             |    4 +-
 init/do_mounts.c                                   |    2 +-
 init/main.c                                        |   25 +-
 kernel/events/core.c                               |    2 +-
 kernel/irq/debug.h                                 |   38 +-
 kernel/power/swap.c                                |   28 +-
 kernel/rcutree.c                                   |    1 +
 kernel/sched/core.c                                |   22 +-
 kernel/sched/fair.c                                |   18 +-
 kernel/sched/features.h                            |    1 -
 kernel/time/tick-broadcast.c                       |   13 +-
 kernel/trace/trace.c                               |    8 +-
 kernel/trace/trace.h                               |    4 +-
 kernel/trace/trace_output.c                        |    5 -
 mm/hugetlb.c                                       |    2 +-
 mm/memcontrol.c                                    |   17 +-
 mm/mempolicy.c                                     |   11 +-
 mm/migrate.c                                       |   16 +-
 mm/nobootmem.c                                     |   10 +-
 mm/swap_state.c                                    |    2 +-
 mm/vmscan.c                                        |   11 +-
 mm/vmstat.c                                        |    4 +-
 net/ax25/af_ax25.c                                 |    9 +-
 net/bluetooth/hci_core.c                           |   27 +-
 net/bluetooth/hci_event.c                          |    3 -
 net/bluetooth/mgmt.c                               |    2 +-
 net/bluetooth/rfcomm/tty.c                         |  137 +++---
 net/bridge/br_forward.c                            |    1 -
 net/bridge/br_netfilter.c                          |    8 +-
 net/caif/chnl_net.c                                |    9 +-
 net/core/dev.c                                     |   20 -
 net/core/drop_monitor.c                            |   89 +---
 net/core/net_namespace.c                           |   33 +-
 net/ieee802154/6lowpan.c                           |   40 +-
 net/ipv4/inet_diag.c                               |    2 +-
 net/ipv4/tcp.c                                     |    9 +-
 net/ipv4/tcp_input.c                               |   14 +-
 net/ipv4/tcp_output.c                              |    1 -
 net/ipv4/udp_diag.c                                |    9 -
 net/ipv6/addrconf.c                                |    9 +-
 net/ipv6/ip6_fib.c                                 |    9 +-
 net/ipv6/ndisc.c                                   |    3 +-
 net/ipv6/route.c                                   |   71 ++-
 net/ipv6/tcp_ipv6.c                                |    4 -
 net/key/af_key.c                                   |    2 +-
 net/l2tp/l2tp_ip.c                                 |    8 +-
 net/mac80211/ibss.c                                |    4 +-
 net/mac80211/ieee80211_i.h                         |    2 +-
 net/mac80211/iface.c                               |    4 +-
 net/mac80211/mlme.c                                |    2 +-
 net/mac80211/rx.c                                  |   10 +-
 net/mac80211/tx.c                                  |    3 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   11 -
 net/netfilter/ipvs/ip_vs_ctl.c                     |   56 +--
 net/netfilter/ipvs/ip_vs_ftp.c                     |    2 -
 net/netfilter/ipvs/ip_vs_lblc.c                    |    3 -
 net/netfilter/ipvs/ip_vs_lblcr.c                   |    3 -
 net/netfilter/ipvs/ip_vs_proto.c                   |   38 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |    5 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |    5 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |    5 +-
 net/netfilter/xt_CT.c                              |    2 +-
 net/phonet/pn_dev.c                                |   21 +-
 net/sched/sch_gred.c                               |    7 +-
 net/sched/sch_netem.c                              |    6 +-
 net/sunrpc/clnt.c                                  |   50 +--
 net/sunrpc/rpc_pipe.c                              |    3 +-
 net/sunrpc/sunrpc_syms.c                           |   17 +-
 net/wireless/util.c                                |    2 +-
 scripts/mod/file2alias.c                           |    4 -
 sound/pci/hda/patch_realtek.c                      |    1 -
 sound/soc/blackfin/bf5xx-ssm2602.c                 |    2 -
 sound/soc/codecs/cs42l73.c                         |    2 -
 sound/soc/codecs/tlv320aic23.c                     |    4 +-
 sound/soc/codecs/wm8350.c                          |   11 +-
 sound/soc/codecs/wm8994.c                          |  276 +++---------
 sound/soc/codecs/wm_hubs.c                         |   15 +-
 sound/soc/omap/omap-pcm.c                          |    4 -
 sound/soc/samsung/s3c2412-i2s.c                    |    2 +-
 sound/soc/sh/fsi.c                                 |    7 +-
 sound/soc/soc-core.c                               |    7 +-
 sound/soc/soc-dapm.c                               |    2 -
 tools/perf/Makefile                                |    4 +-
 tools/perf/builtin-report.c                        |   17 +-
 tools/perf/builtin-test.c                          |   30 --
 tools/perf/util/parse-events.l                     |    2 +-
 tools/perf/util/symbol.c                           |   13 +-
 tools/testing/ktest/ktest.pl                       |   12 +-
 552 files changed, 4698 insertions(+), 6763 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-bus-hsi
 rename Documentation/devicetree/bindings/ata/{ahci-platform.txt => calxeda-sata.txt} (90%)
 delete mode 100644 arch/powerpc/boot/dts/fsl/pq3-mpic-message-B.dtsi
 delete mode 100644 drivers/tty/serial/68328serial.h
 create mode 100644 drivers/tty/serial/8250/8250_em.c
 create mode 100644 include/linux/of_serial.h

---------------

Alan Cox (7):
      vt: push the tty_lock down into the map handling
      tty_lock: undo the old tty_lock use on the ctty
      pty: Lock the devpts bits privately
      tty_lock: Localise the lock
      tty: drop the pty lock during hangup
      tty: Allow uart_register/unregister/register
      tty: Fix LED error return

Arnaud Patard (1):
      8250_pci: fix pch uart matching

Christian Melki (1):
      8250.c: less than 2400 baud fix.

Corbin Atkinson (1):
      serial_core: Update buffer overrun statistics.

Dan Carpenter (1):
      tty: hvc_xen: NULL dereference on allocation failure

Dan Williams (2):
      tegra, serial8250: add ->handle_break() uart_port op
      serial/8250_pci: fix suspend/resume vs init/exit quirks

Geert Uytterhoeven (1):
      tty/amiserial: Add missing argument for tty_unlock()

Govindraj.R (1):
      OMAP2+: UART: Remove cpu checks for populating errata flags

Greg Kroah-Hartman (1):
      Revert "serial_core: Update buffer overrun statistics."

H Hartley Sweeten (1):
      tty: mxser: local variables should not be exposed globally

Heiko Carstens (1):
      tty: add missing tty_port_tty_get() call to raw3215_wakeup

Ivo Sieben (1):
      tty: move global ldisc idle waitqueue to the individual ldisc

Jiri Slaby (71):
      TTY: crisv10, remove unused tmp_buf
      TTY: crisv10, initialize tty_port
      TTY: deprecate linux/generic_serial.h
      ISDN: i4l, remove cvs crap
      TTY: isdn, remove callout
      TTY: isdn, remove ISDN_ASYNC_* flags
      TTY: isdn, do not play with module refcounts
      TTY: isdn, make some functions readable
      TTY: isdn, remove unused members from modem_info
      TTY: isdn, add tty_port
      TTY: isdn, use open/close_wait from tty_port
      TTY: isdn, use counts from tty_port
      TTY: isdn, use tty from tty_port
      TTY: isdn, use xmit_buf from tty_port
      TTY: isdn, define local tty_port
      TTY: isdn, use tty_port_close_end helper
      TTY: isdn, define tty_port_operations
      TTY: isdn, use tty_port_block_til_ready helper
      TTY: hso, do not set TTY MAGIC
      TTY: hso, free tty_driver
      TTY: hso, add tty_port
      TTY: hso, remove tty NULL checks fro tty->ops
      TTY: hso, use tty from tty_port
      TTY: con3215, centralize allocation
      TTY: sclp_tty, add tty_port
      TTY: sclp_vt220, add tty_port
      TTY: sclp_vt220, remove unused allocation
      TTY: tty3270, move initialization to allocation
      TTY: tty3270, get rid of ugly aliasing
      TTY: tty3270, push tty down to tty3270_do_write
      TTY: tty3270, add tty_port
      TTY: bfin_jtag_comm, add tty_port
      TTY: bfin_jtag_comm, use tty from tty_port
      TTY: HVC, add tty_port
      TTY: HVC, use tty from tty_port
      TTY: HVC, use count from tty_port
      TTY: hvcs, add tty_port
      TTY: hvcs, use kref from tty_port
      TTY: hvcs, use tty from tty_port
      TTY: hvsi, CLOCAL is not in tty->flags
      TTY: hvsi, add tty_port
      TTY: hvsi, sanitize uses of tty
      TTY: hvsi, use tty from tty_port
      TTY: ipwireless, use synchronous hangup
      TTY: ipwireless, move prints to appropriate places
      TTY: ipwireless, add tty_port
      TTY: ipwireless, use tty from tty_port
      TTY: 68328serial, remove serial_state and friends
      TTY: 68328serial, remove unused stuff from m68k_serial
      TTY: 68328serial, remove garbage
      TTY: 68328serial, use ulong flags for interrupts status
      TTY: 68328serial, remove 68328serial.h
      TTY: 68328serial, add tty_port
      TTY: 68328serial, use open/close_wait from tty_port
      TTY: 68328serial, use close_delay/closing_wait from tty_port
      TTY: 68328serial, use flags from tty_port
      TTY: 68328serial, propagate tty
      TTY: 68328serial, use tty from tty_port
      TTY: 68328serial, use tty_port_block_til_ready
      TTY: usb/u_serial, add tty_port
      TTY: usb/u_serial, use tty from tty_port
      TTY: usb/u_serial use close_wait from tty_port
      TTY: rfcomm/tty, add tty_port
      TTY: rfcomm/tty, use tty_port refcounting
      TTY: rfcomm/tty, remove work for tty_wakeup
      TTY: rfcomm/tty, use count from tty_port
      ISDN: remove uses of isdn_tty_revision
      TTY: hvc, fix TTY refcounting
      TTY: con3215, add tty_port
      TTY: con3215, use tty from tty_port
      TTY: n_tty, do not dereference user buffer

Lothar Waﬂmann (1):
      Add missing call to uart_update_timeout()

Magnus Damm (8):
      serial8250: Add dl_read()/dl_write() callbacks
      serial8250: Use dl_read()/dl_write() on Alchemy
      serial8250: Use dl_read()/dl_write() on RM9K
      serial8250: Clean up default map and dl code
      serial8250: Introduce serial8250_register_8250_port()
      serial8250-em: Emma Mobile UART driver V2
      serial8250-em: clk_get() IS_ERR() error handling fix
      serial8250-em: Add DT support

Michael Gehring (1):
      tty/vt: handle bad user buffer in {G,P}IO_CMAP ioctl

Paul Gortmaker (1):
      cris: fix missing tty arg in wait_event_interruptible_tty call

Rajanikanth H.V (1):
      serial: pl011: implement workaround for CTS clear event issue

Sonic Zhang (4):
      serial: bfin_uart: Adapt bf5xx serial driver to bf60x serial4 controller.
      serial: bfin_uart: narrow the reboot condition in DMA tx interrupt
      serial: bfin_uart: RTS and CTS MMRs can be either 16-bit width or 32-bit width.
      serial: bfin_uart: Make MMR access compatible with 32 bits bf609 style controller.

Sudhakar Mamillapalli (1):
      serial/8250_pci: Clear FIFOs for Intel ME Serial Over Lan device on BI

Tomoya MORINAGA (7):
      pch_uart: Delete unused structure member
      pch_uart: change type to u8
      pch_uart: change type to %d to %02x
      pch_uart: Support modem status interrupt
      pch_uart: delete unused data structure
      pch_uart: Fix return value issue
      pch_uart: Fix duplicate memory release issue

Xiaobing Tu (1):
      tty: hold lock across tty buffer finding and buffer filling

