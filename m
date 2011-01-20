Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1ATDNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 22:13:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1ATDNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 22:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=Sl3rKAq6YAjxEvmxg/7GxXE5YrlvApIJ6wbfp7fkgwxKq3ejPfNjHZzSnXrUifDFLn
         7u69uhK+3aznB2/7YJQA==
Date: Wed, 19 Jan 2011 19:13:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Robin Holt <holt@sgi.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] kconfig: rename CONFIG_EMBEDDED to CONFIG_EXPERT
Message-ID: <alpine.DEB.2.00.1101191912440.2555@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The meaning of CONFIG_EMBEDDED has long since been obsoleted; the option
is used to configure any non-standard kernel with a much larger scope
than only small devices.

This patch renames the option to CONFIG_EXPERT in init/Kconfig and fixes
references to the option throughout the kernel.  A new CONFIG_EMBEDDED
option is added that automatically selects CONFIG_EXPERT when enabled
and can be used in the future to isolate options that should only be
considered for embedded systems (RISC architectures, SLOB, etc).

Calling the option "EXPERT" more accurately represents its intention:
only expert users who understand the impact of the configuration changes
they are making should enable it.

Reviewed-by: Ingo Molnar <mingo@elte.hu>
Acked-by: David Woodhouse <david.woodhouse@intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/arm/configs/ag5evm_defconfig                 |    2 +-
 arch/arm/configs/am200epdkit_defconfig            |    2 +-
 arch/arm/configs/at572d940hfek_defconfig          |    2 +-
 arch/arm/configs/badge4_defconfig                 |    2 +-
 arch/arm/configs/bcmring_defconfig                |    2 +-
 arch/arm/configs/cm_x2xx_defconfig                |    2 +-
 arch/arm/configs/colibri_pxa270_defconfig         |    2 +-
 arch/arm/configs/collie_defconfig                 |    2 +-
 arch/arm/configs/corgi_defconfig                  |    2 +-
 arch/arm/configs/da8xx_omapl_defconfig            |    2 +-
 arch/arm/configs/davinci_all_defconfig            |    2 +-
 arch/arm/configs/dove_defconfig                   |    2 +-
 arch/arm/configs/ebsa110_defconfig                |    2 +-
 arch/arm/configs/edb7211_defconfig                |    2 +-
 arch/arm/configs/em_x270_defconfig                |    2 +-
 arch/arm/configs/ep93xx_defconfig                 |    2 +-
 arch/arm/configs/eseries_pxa_defconfig            |    2 +-
 arch/arm/configs/ezx_defconfig                    |    2 +-
 arch/arm/configs/footbridge_defconfig             |    2 +-
 arch/arm/configs/fortunet_defconfig               |    2 +-
 arch/arm/configs/h5000_defconfig                  |    2 +-
 arch/arm/configs/imote2_defconfig                 |    2 +-
 arch/arm/configs/ixp2000_defconfig                |    2 +-
 arch/arm/configs/ixp23xx_defconfig                |    2 +-
 arch/arm/configs/ixp4xx_defconfig                 |    2 +-
 arch/arm/configs/loki_defconfig                   |    2 +-
 arch/arm/configs/lpd7a400_defconfig               |    2 +-
 arch/arm/configs/lpd7a404_defconfig               |    2 +-
 arch/arm/configs/magician_defconfig               |    2 +-
 arch/arm/configs/mv78xx0_defconfig                |    2 +-
 arch/arm/configs/mx1_defconfig                    |    2 +-
 arch/arm/configs/mx21_defconfig                   |    2 +-
 arch/arm/configs/mx27_defconfig                   |    2 +-
 arch/arm/configs/mx3_defconfig                    |    2 +-
 arch/arm/configs/mx51_defconfig                   |    2 +-
 arch/arm/configs/nhk8815_defconfig                |    2 +-
 arch/arm/configs/omap1_defconfig                  |    2 +-
 arch/arm/configs/omap2plus_defconfig              |    2 +-
 arch/arm/configs/orion5x_defconfig                |    2 +-
 arch/arm/configs/pcm027_defconfig                 |    2 +-
 arch/arm/configs/pcontrol_g20_defconfig           |    2 +-
 arch/arm/configs/pleb_defconfig                   |    2 +-
 arch/arm/configs/pnx4008_defconfig                |    2 +-
 arch/arm/configs/simpad_defconfig                 |    2 +-
 arch/arm/configs/spitz_defconfig                  |    2 +-
 arch/arm/configs/stmp378x_defconfig               |    2 +-
 arch/arm/configs/stmp37xx_defconfig               |    2 +-
 arch/arm/configs/tct_hammer_defconfig             |    2 +-
 arch/arm/configs/trizeps4_defconfig               |    2 +-
 arch/arm/configs/u300_defconfig                   |    2 +-
 arch/arm/configs/viper_defconfig                  |    2 +-
 arch/arm/configs/xcep_defconfig                   |    2 +-
 arch/avr32/Kconfig                                |    4 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    2 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    2 +-
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |    2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |    2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF527-TLL6527M_defconfig    |    2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF561-ACVILON_defconfig     |    2 +-
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig   |    2 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BlackStamp_defconfig        |    2 +-
 arch/blackfin/configs/CM-BF527_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF533_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |    2 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |    2 +-
 arch/blackfin/configs/CM-BF548_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF561_defconfig          |    2 +-
 arch/blackfin/configs/DNP5370_defconfig           |    2 +-
 arch/blackfin/configs/H8606_defconfig             |    2 +-
 arch/blackfin/configs/IP0X_defconfig              |    2 +-
 arch/blackfin/configs/PNAV-10_defconfig           |    2 +-
 arch/blackfin/configs/SRV1_defconfig              |    2 +-
 arch/blackfin/configs/TCM-BF518_defconfig         |    2 +-
 arch/blackfin/configs/TCM-BF537_defconfig         |    2 +-
 arch/cris/configs/artpec_3_defconfig              |    2 +-
 arch/cris/configs/etrax-100lx_v2_defconfig        |    2 +-
 arch/cris/configs/etraxfs_defconfig               |    2 +-
 arch/frv/defconfig                                |    2 +-
 arch/h8300/defconfig                              |    2 +-
 arch/m32r/configs/m32700ut.smp_defconfig          |    2 +-
 arch/m32r/configs/m32700ut.up_defconfig           |    2 +-
 arch/m32r/configs/mappi.nommu_defconfig           |    2 +-
 arch/m32r/configs/mappi.smp_defconfig             |    2 +-
 arch/m32r/configs/mappi.up_defconfig              |    2 +-
 arch/m32r/configs/mappi2.opsp_defconfig           |    2 +-
 arch/m32r/configs/mappi2.vdec2_defconfig          |    2 +-
 arch/m32r/configs/mappi3.smp_defconfig            |    2 +-
 arch/m32r/configs/oaks32r_defconfig               |    2 +-
 arch/m32r/configs/opsput_defconfig                |    2 +-
 arch/m32r/configs/usrv_defconfig                  |    2 +-
 arch/m68knommu/configs/m5208evb_defconfig         |    2 +-
 arch/m68knommu/configs/m5249evb_defconfig         |    2 +-
 arch/m68knommu/configs/m5272c3_defconfig          |    2 +-
 arch/m68knommu/configs/m5275evb_defconfig         |    2 +-
 arch/m68knommu/configs/m5307c3_defconfig          |    2 +-
 arch/m68knommu/configs/m5407c3_defconfig          |    2 +-
 arch/m68knommu/defconfig                          |    2 +-
 arch/microblaze/configs/mmu_defconfig             |    2 +-
 arch/microblaze/configs/nommu_defconfig           |    2 +-
 arch/mips/Kconfig.debug                           |    2 +-
 arch/mips/configs/ar7_defconfig                   |    2 +-
 arch/mips/configs/bcm47xx_defconfig               |    2 +-
 arch/mips/configs/bcm63xx_defconfig               |    2 +-
 arch/mips/configs/bigsur_defconfig                |    2 +-
 arch/mips/configs/capcella_defconfig              |    2 +-
 arch/mips/configs/cavium-octeon_defconfig         |    2 +-
 arch/mips/configs/cobalt_defconfig                |    2 +-
 arch/mips/configs/db1000_defconfig                |    2 +-
 arch/mips/configs/db1100_defconfig                |    2 +-
 arch/mips/configs/db1200_defconfig                |    2 +-
 arch/mips/configs/db1500_defconfig                |    2 +-
 arch/mips/configs/db1550_defconfig                |    2 +-
 arch/mips/configs/decstation_defconfig            |    2 +-
 arch/mips/configs/e55_defconfig                   |    2 +-
 arch/mips/configs/fuloong2e_defconfig             |    2 +-
 arch/mips/configs/gpr_defconfig                   |    2 +-
 arch/mips/configs/ip22_defconfig                  |    2 +-
 arch/mips/configs/ip27_defconfig                  |    2 +-
 arch/mips/configs/ip28_defconfig                  |    2 +-
 arch/mips/configs/ip32_defconfig                  |    2 +-
 arch/mips/configs/jazz_defconfig                  |    2 +-
 arch/mips/configs/jmr3927_defconfig               |    2 +-
 arch/mips/configs/lasat_defconfig                 |    2 +-
 arch/mips/configs/lemote2f_defconfig              |    2 +-
 arch/mips/configs/malta_defconfig                 |    2 +-
 arch/mips/configs/markeins_defconfig              |    2 +-
 arch/mips/configs/mipssim_defconfig               |    2 +-
 arch/mips/configs/mpc30x_defconfig                |    2 +-
 arch/mips/configs/msp71xx_defconfig               |    2 +-
 arch/mips/configs/mtx1_defconfig                  |    2 +-
 arch/mips/configs/pb1100_defconfig                |    2 +-
 arch/mips/configs/pb1200_defconfig                |    2 +-
 arch/mips/configs/pb1500_defconfig                |    2 +-
 arch/mips/configs/pb1550_defconfig                |    2 +-
 arch/mips/configs/pnx8335-stb225_defconfig        |    2 +-
 arch/mips/configs/pnx8550-jbs_defconfig           |    2 +-
 arch/mips/configs/pnx8550-stb810_defconfig        |    2 +-
 arch/mips/configs/powertv_defconfig               |    2 +-
 arch/mips/configs/rb532_defconfig                 |    2 +-
 arch/mips/configs/rbtx49xx_defconfig              |    2 +-
 arch/mips/configs/rm200_defconfig                 |    2 +-
 arch/mips/configs/sb1250-swarm_defconfig          |    2 +-
 arch/mips/configs/tb0219_defconfig                |    2 +-
 arch/mips/configs/tb0226_defconfig                |    2 +-
 arch/mips/configs/tb0287_defconfig                |    2 +-
 arch/mips/configs/workpad_defconfig               |    2 +-
 arch/mips/configs/wrppmc_defconfig                |    2 +-
 arch/mips/configs/yosemite_defconfig              |    2 +-
 arch/mn10300/configs/asb2303_defconfig            |    2 +-
 arch/mn10300/configs/asb2364_defconfig            |    2 +-
 arch/parisc/configs/a500_defconfig                |    2 +-
 arch/parisc/configs/c3000_defconfig               |    2 +-
 arch/powerpc/configs/40x/acadia_defconfig         |    2 +-
 arch/powerpc/configs/40x/ep405_defconfig          |    2 +-
 arch/powerpc/configs/40x/hcu4_defconfig           |    2 +-
 arch/powerpc/configs/40x/kilauea_defconfig        |    2 +-
 arch/powerpc/configs/40x/makalu_defconfig         |    2 +-
 arch/powerpc/configs/40x/walnut_defconfig         |    2 +-
 arch/powerpc/configs/44x/arches_defconfig         |    2 +-
 arch/powerpc/configs/44x/bamboo_defconfig         |    2 +-
 arch/powerpc/configs/44x/bluestone_defconfig      |    2 +-
 arch/powerpc/configs/44x/canyonlands_defconfig    |    2 +-
 arch/powerpc/configs/44x/ebony_defconfig          |    2 +-
 arch/powerpc/configs/44x/eiger_defconfig          |    2 +-
 arch/powerpc/configs/44x/icon_defconfig           |    2 +-
 arch/powerpc/configs/44x/iss476-smp_defconfig     |    2 +-
 arch/powerpc/configs/44x/katmai_defconfig         |    2 +-
 arch/powerpc/configs/44x/rainier_defconfig        |    2 +-
 arch/powerpc/configs/44x/redwood_defconfig        |    2 +-
 arch/powerpc/configs/44x/sam440ep_defconfig       |    2 +-
 arch/powerpc/configs/44x/sequoia_defconfig        |    2 +-
 arch/powerpc/configs/44x/taishan_defconfig        |    2 +-
 arch/powerpc/configs/44x/warp_defconfig           |    2 +-
 arch/powerpc/configs/52xx/cm5200_defconfig        |    2 +-
 arch/powerpc/configs/52xx/lite5200b_defconfig     |    2 +-
 arch/powerpc/configs/52xx/motionpro_defconfig     |    2 +-
 arch/powerpc/configs/52xx/pcm030_defconfig        |    2 +-
 arch/powerpc/configs/52xx/tqm5200_defconfig       |    2 +-
 arch/powerpc/configs/83xx/asp8347_defconfig       |    2 +-
 arch/powerpc/configs/83xx/kmeter1_defconfig       |    2 +-
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |    2 +-
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |    2 +-
 arch/powerpc/configs/83xx/sbc834x_defconfig       |    2 +-
 arch/powerpc/configs/85xx/ksi8560_defconfig       |    2 +-
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |    2 +-
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |    2 +-
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |    2 +-
 arch/powerpc/configs/85xx/sbc8548_defconfig       |    2 +-
 arch/powerpc/configs/85xx/sbc8560_defconfig       |    2 +-
 arch/powerpc/configs/85xx/socrates_defconfig      |    2 +-
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8540_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8541_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8548_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8555_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8560_defconfig       |    2 +-
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   |    2 +-
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     |    2 +-
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    |    2 +-
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |    2 +-
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |    2 +-
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |    2 +-
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |    2 +-
 arch/powerpc/configs/adder875_defconfig           |    2 +-
 arch/powerpc/configs/e55xx_smp_defconfig          |    2 +-
 arch/powerpc/configs/ep8248e_defconfig            |    2 +-
 arch/powerpc/configs/ep88xc_defconfig             |    2 +-
 arch/powerpc/configs/gamecube_defconfig           |    2 +-
 arch/powerpc/configs/holly_defconfig              |    2 +-
 arch/powerpc/configs/mgcoge_defconfig             |    2 +-
 arch/powerpc/configs/mgsuvd_defconfig             |    2 +-
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |    2 +-
 arch/powerpc/configs/mpc8272_ads_defconfig        |    2 +-
 arch/powerpc/configs/mpc83xx_defconfig            |    2 +-
 arch/powerpc/configs/mpc85xx_defconfig            |    2 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig        |    2 +-
 arch/powerpc/configs/mpc866_ads_defconfig         |    2 +-
 arch/powerpc/configs/mpc86xx_defconfig            |    2 +-
 arch/powerpc/configs/mpc885_ads_defconfig         |    2 +-
 arch/powerpc/configs/ppc40x_defconfig             |    2 +-
 arch/powerpc/configs/ppc44x_defconfig             |    2 +-
 arch/powerpc/configs/pq2fads_defconfig            |    2 +-
 arch/powerpc/configs/ps3_defconfig                |    2 +-
 arch/powerpc/configs/storcenter_defconfig         |    2 +-
 arch/powerpc/configs/tqm8xx_defconfig             |    2 +-
 arch/powerpc/configs/wii_defconfig                |    2 +-
 arch/powerpc/platforms/iseries/Kconfig            |    2 +-
 arch/powerpc/platforms/pseries/Kconfig            |    6 +-
 arch/score/configs/spct6600_defconfig             |    2 +-
 arch/sh/Kconfig                                   |    2 +-
 arch/tile/Kconfig                                 |    2 +-
 arch/tile/Kconfig.debug                           |    2 +-
 arch/tile/configs/tile_defconfig                  |    2 +-
 arch/um/defconfig                                 |    2 +-
 arch/x86/Kconfig                                  |   20 +++---
 arch/x86/Kconfig.cpu                              |    2 +-
 arch/x86/Kconfig.debug                            |    4 +-
 arch/xtensa/configs/common_defconfig              |    2 +-
 arch/xtensa/configs/iss_defconfig                 |    2 +-
 arch/xtensa/configs/s6105_defconfig               |    2 +-
 block/Kconfig                                     |    2 +-
 drivers/acpi/Kconfig                              |    2 +-
 drivers/ata/Kconfig                               |    2 +-
 drivers/base/Kconfig                              |    2 +-
 drivers/char/Kconfig                              |   10 ++--
 drivers/cpufreq/Kconfig                           |    2 +-
 drivers/firmware/Kconfig                          |    2 +-
 drivers/gpu/drm/Kconfig                           |    2 +-
 drivers/gpu/drm/drm_fb_helper.c                   |    4 +-
 drivers/gpu/drm/nouveau/Kconfig                   |    2 +-
 drivers/gpu/vga/Kconfig                           |    2 +-
 drivers/hid/Kconfig                               |   64 ++++++++++----------
 drivers/hid/usbhid/Kconfig                        |    2 +-
 drivers/ide/Kconfig                               |    2 +-
 drivers/infiniband/hw/mthca/Kconfig               |    2 +-
 drivers/infiniband/ulp/ipoib/Kconfig              |    2 +-
 drivers/input/Kconfig                             |    6 +-
 drivers/input/keyboard/Kconfig                    |    4 +-
 drivers/input/mouse/Kconfig                       |   10 ++--
 drivers/input/serio/Kconfig                       |    6 +-
 drivers/input/touchscreen/Kconfig                 |   30 +++++-----
 drivers/media/common/tuners/Kconfig               |    2 +-
 drivers/media/dvb/frontends/Kconfig               |    2 +-
 drivers/media/video/Kconfig                       |    2 +-
 drivers/net/Kconfig                               |    2 +-
 drivers/pci/pcie/Kconfig                          |    2 +-
 drivers/pcmcia/Kconfig                            |   12 ++--
 drivers/serial/Kconfig                            |    4 +-
 drivers/ssb/Kconfig                               |    2 +-
 drivers/usb/core/Kconfig                          |    6 +-
 drivers/video/Kconfig                             |    2 +-
 drivers/video/console/Kconfig                     |    2 +-
 fs/Kconfig                                        |    2 +-
 fs/proc/Kconfig                                   |    6 +-
 fs/sysfs/Kconfig                                  |    2 +-
 init/Kconfig                                      |   60 +++++++++++--------
 lib/Kconfig.debug                                 |    6 +-
 lib/xz/Kconfig                                    |   12 ++--
 net/mac80211/Kconfig                              |    6 +-
 net/rfkill/Kconfig                                |    4 +-
 net/wireless/Kconfig                              |    2 +-
 usr/Kconfig                                       |   18 +++---
 298 files changed, 431 insertions(+), 423 deletions(-)

diff --git a/arch/arm/configs/ag5evm_defconfig b/arch/arm/configs/ag5evm_defconfig
index 2b9cf56..212ead3 100644
--- a/arch/arm/configs/ag5evm_defconfig
+++ b/arch/arm/configs/ag5evm_defconfig
@@ -10,7 +10,7 @@ CONFIG_NAMESPACES=y
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
diff --git a/arch/arm/configs/am200epdkit_defconfig b/arch/arm/configs/am200epdkit_defconfig
index 5536c48..f0dea52 100644
--- a/arch/arm/configs/am200epdkit_defconfig
+++ b/arch/arm/configs/am200epdkit_defconfig
@@ -3,7 +3,7 @@ CONFIG_LOCALVERSION="gum"
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_EPOLL is not set
 # CONFIG_SHMEM is not set
diff --git a/arch/arm/configs/at572d940hfek_defconfig b/arch/arm/configs/at572d940hfek_defconfig
index 695e32d..1b1158a 100644
--- a/arch/arm/configs/at572d940hfek_defconfig
+++ b/arch/arm/configs/at572d940hfek_defconfig
@@ -17,7 +17,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_defconfig
index 3a1ad15..5b54abb 100644
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -1,6 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 CONFIG_ARCH_SA1100=y
diff --git a/arch/arm/configs/bcmring_defconfig b/arch/arm/configs/bcmring_defconfig
index 75984cd..795374d 100644
--- a/arch/arm/configs/bcmring_defconfig
+++ b/arch/arm/configs/bcmring_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/arm/configs/cm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
index dcfbcf3..a93ff8d 100644
--- a/arch/arm/configs/cm_x2xx_defconfig
+++ b/arch/arm/configs/cm_x2xx_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/arm/configs/colibri_pxa270_defconfig b/arch/arm/configs/colibri_pxa270_defconfig
index f52c64e..2ef2c5e 100644
--- a/arch/arm/configs/colibri_pxa270_defconfig
+++ b/arch/arm/configs/colibri_pxa270_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 310f9a6..6c56ad0 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BASE_FULL is not set
 # CONFIG_EPOLL is not set
 CONFIG_SLOB=y
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index 4a1fa81..e53c475 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
index cdc40c4..88ccde0 100644
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index 2519cc5..889922a 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
index 9359e1b..54bf5ee 100644
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/ebsa110_defconfig b/arch/arm/configs/ebsa110_defconfig
index c319418..14559db 100644
--- a/arch/arm/configs/ebsa110_defconfig
+++ b/arch/arm/configs/ebsa110_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_ARCH_EBSA110=y
 CONFIG_PCCARD=m
diff --git a/arch/arm/configs/edb7211_defconfig b/arch/arm/configs/edb7211_defconfig
index 7b62be1..d52ded35 100644
--- a/arch/arm/configs/edb7211_defconfig
+++ b/arch/arm/configs/edb7211_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_ARCH_CLPS711X=y
 CONFIG_ARCH_EDB7211=y
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index d7db34f..60a21e0 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 6d6689c..8e97b2f 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/eseries_pxa_defconfig b/arch/arm/configs/eseries_pxa_defconfig
index 1691dea..d68ac67 100644
--- a/arch/arm/configs/eseries_pxa_defconfig
+++ b/arch/arm/configs/eseries_pxa_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index c4eeb6d..227a477 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -7,7 +7,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/footbridge_defconfig b/arch/arm/configs/footbridge_defconfig
index 4f925ea..038518a 100644
--- a/arch/arm/configs/footbridge_defconfig
+++ b/arch/arm/configs/footbridge_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_MODULES=y
 CONFIG_ARCH_FOOTBRIDGE=y
diff --git a/arch/arm/configs/fortunet_defconfig b/arch/arm/configs/fortunet_defconfig
index e11c7ea..840fced 100644
--- a/arch/arm/configs/fortunet_defconfig
+++ b/arch/arm/configs/fortunet_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_ARCH_CLPS711X=y
 CONFIG_ARCH_FORTUNET=y
diff --git a/arch/arm/configs/h5000_defconfig b/arch/arm/configs/h5000_defconfig
index ac336f1..37903e3 100644
--- a/arch/arm/configs/h5000_defconfig
+++ b/arch/arm/configs/h5000_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
index ade55c8..176ec22 100644
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -6,7 +6,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/ixp2000_defconfig b/arch/arm/configs/ixp2000_defconfig
index 9083246..8405ade 100644
--- a/arch/arm/configs/ixp2000_defconfig
+++ b/arch/arm/configs/ixp2000_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/ixp23xx_defconfig b/arch/arm/configs/ixp23xx_defconfig
index 7fc056a..6887176 100644
--- a/arch/arm/configs/ixp23xx_defconfig
+++ b/arch/arm/configs/ixp23xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
index 5c50239..063e2ab 100644
--- a/arch/arm/configs/ixp4xx_defconfig
+++ b/arch/arm/configs/ixp4xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/arm/configs/loki_defconfig b/arch/arm/configs/loki_defconfig
index e1eaff7..1ba752b 100644
--- a/arch/arm/configs/loki_defconfig
+++ b/arch/arm/configs/loki_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/lpd7a400_defconfig b/arch/arm/configs/lpd7a400_defconfig
index 20caaab..5a48f17 100644
--- a/arch/arm/configs/lpd7a400_defconfig
+++ b/arch/arm/configs/lpd7a400_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
 # CONFIG_IOSCHED_DEADLINE is not set
diff --git a/arch/arm/configs/lpd7a404_defconfig b/arch/arm/configs/lpd7a404_defconfig
index 1efcce9..22d0631 100644
--- a/arch/arm/configs/lpd7a404_defconfig
+++ b/arch/arm/configs/lpd7a404_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=16
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index af805e8..a88e64d 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index b0d0824..7305ebd 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_PROFILING=y
diff --git a/arch/arm/configs/mx1_defconfig b/arch/arm/configs/mx1_defconfig
index 2f38d97..b39b5ce 100644
--- a/arch/arm/configs/mx1_defconfig
+++ b/arch/arm/configs/mx1_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/mx21_defconfig b/arch/arm/configs/mx21_defconfig
index 6454e18..411f88d 100644
--- a/arch/arm/configs/mx21_defconfig
+++ b/arch/arm/configs/mx21_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/mx27_defconfig b/arch/arm/configs/mx27_defconfig
index 813cfb3..9ad4c656 100644
--- a/arch/arm/configs/mx27_defconfig
+++ b/arch/arm/configs/mx27_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/mx3_defconfig b/arch/arm/configs/mx3_defconfig
index e648ea3..7c4b30b 100644
--- a/arch/arm/configs/mx3_defconfig
+++ b/arch/arm/configs/mx3_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/mx51_defconfig b/arch/arm/configs/mx51_defconfig
index 5c7a872..9cba68c 100644
--- a/arch/arm/configs/mx51_defconfig
+++ b/arch/arm/configs/mx51_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index 0e2dc26..37207d1 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index a350cc6..7b63462 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -6,7 +6,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index ccedde1..ae890ca 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index 439323b..a288d70 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=y
diff --git a/arch/arm/configs/pcm027_defconfig b/arch/arm/configs/pcm027_defconfig
index 583a061..2f136c3 100644
--- a/arch/arm/configs/pcm027_defconfig
+++ b/arch/arm/configs/pcm027_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/pcontrol_g20_defconfig b/arch/arm/configs/pcontrol_g20_defconfig
index b42ee62..c75c9fc 100644
--- a/arch/arm/configs/pcontrol_g20_defconfig
+++ b/arch/arm/configs/pcontrol_g20_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/arm/configs/pleb_defconfig b/arch/arm/configs/pleb_defconfig
index d1efbdc..cb08cc5 100644
--- a/arch/arm/configs/pleb_defconfig
+++ b/arch/arm/configs/pleb_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_SHMEM is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/pnx4008_defconfig b/arch/arm/configs/pnx4008_defconfig
index bd481f0..35a31cc 100644
--- a/arch/arm/configs/pnx4008_defconfig
+++ b/arch/arm/configs/pnx4008_defconfig
@@ -5,7 +5,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/simpad_defconfig b/arch/arm/configs/simpad_defconfig
index af3b12e..d335815 100644
--- a/arch/arm/configs/simpad_defconfig
+++ b/arch/arm/configs/simpad_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="oe1"
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index aebd4bb..7015827 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/stmp378x_defconfig b/arch/arm/configs/stmp378x_defconfig
index 94a2d90..1079c2b 100644
--- a/arch/arm/configs/stmp378x_defconfig
+++ b/arch/arm/configs/stmp378x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/stmp37xx_defconfig b/arch/arm/configs/stmp37xx_defconfig
index d8ee58c..564a5cc 100644
--- a/arch/arm/configs/stmp37xx_defconfig
+++ b/arch/arm/configs/stmp37xx_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index e89ca19..95c0f0d 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_BUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
index 37f4834..3162173 100644
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/u300_defconfig b/arch/arm/configs/u300_defconfig
index c1c252c..4a5a126 100644
--- a/arch/arm/configs/u300_defconfig
+++ b/arch/arm/configs/u300_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_AIO is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/viper_defconfig b/arch/arm/configs/viper_defconfig
index 9d7bf5e..8b0c717 100644
--- a/arch/arm/configs/viper_defconfig
+++ b/arch/arm/configs/viper_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=13
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_SHMEM is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
index 70d47db..5b55041 100644
--- a/arch/arm/configs/xcep_defconfig
+++ b/arch/arm/configs/xcep_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SHMEM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 313b130..cd2062f 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -1,8 +1,8 @@
 config AVR32
 	def_bool y
-	# With EMBEDDED=n, we get lots of stuff automatically selected
+	# With EXPERT=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
-	select EMBEDDED
+	select EXPERT
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index c0b988e..db8d38a 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 864af5b..3e50d78 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
index 7b6a337..362f59d 100644
--- a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
+++ b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_AIO is not set
 CONFIG_SLAB=y
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
index 4faa6b4..023ff0d 100644
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 9d893eb..4e5a121 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-TLL6527M_defconfig b/arch/blackfin/configs/BF527-TLL6527M_defconfig
index 97a2767..cd0636b 100644
--- a/arch/blackfin/configs/BF527-TLL6527M_defconfig
+++ b/arch/blackfin/configs/BF527-TLL6527M_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index f847743..9f8fc84 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index 0e7262c..ccc432b 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 4d14a00..5666954 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index fbee9d7..ac22124 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 05dd11d..944404b 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
index bcb14d1..b7c8451 100644
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
index 4cf4510..7e67ba3 100644
--- a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 843aaa5..141e593 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index dae7adf..97ebe09 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -6,7 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
index f341424..c245754 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
index 8c7e08f..baf1c15 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
index bd3cb76..707cbf8 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
index 82224f3..4596935 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index 433598c..df26758 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index ded7d84..6c7b215 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/DNP5370_defconfig b/arch/blackfin/configs/DNP5370_defconfig
index 0ebc7d9..f503136 100644
--- a/arch/blackfin/configs/DNP5370_defconfig
+++ b/arch/blackfin/configs/DNP5370_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLOB=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_CFQ is not set
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index 700fb70..7450127 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/IP0X_defconfig b/arch/blackfin/configs/IP0X_defconfig
index b40156d..5e797cf 100644
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index be866d9..a566a2f 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
index b64bdf7..8538095 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
index 1bccd9a..d496ae9 100644
--- a/arch/blackfin/configs/TCM-BF518_defconfig
+++ b/arch/blackfin/configs/TCM-BF518_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig b/arch/blackfin/configs/TCM-BF537_defconfig
index 00ce899..65f6421 100644
--- a/arch/blackfin/configs/TCM-BF537_defconfig
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/cris/configs/artpec_3_defconfig b/arch/cris/configs/artpec_3_defconfig
index 590f72c..71854d4 100644
--- a/arch/cris/configs/artpec_3_defconfig
+++ b/arch/cris/configs/artpec_3_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/cris/configs/etrax-100lx_v2_defconfig b/arch/cris/configs/etrax-100lx_v2_defconfig
index 1b2853e..a85aabf 100644
--- a/arch/cris/configs/etrax-100lx_v2_defconfig
+++ b/arch/cris/configs/etrax-100lx_v2_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/cris/configs/etraxfs_defconfig b/arch/cris/configs/etraxfs_defconfig
index f73d38c..87c7227 100644
--- a/arch/cris/configs/etraxfs_defconfig
+++ b/arch/cris/configs/etraxfs_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/frv/defconfig b/arch/frv/defconfig
index b8ebe9e..b1b7926 100644
--- a/arch/frv/defconfig
+++ b/arch/frv/defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_MMU=y
 CONFIG_FRV_OUTOFLINE_ATOMIC_OPS=y
diff --git a/arch/h8300/defconfig b/arch/h8300/defconfig
index 342f777..042425a 100644
--- a/arch/h8300/defconfig
+++ b/arch/h8300/defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
diff --git a/arch/m32r/configs/m32700ut.smp_defconfig b/arch/m32r/configs/m32700ut.smp_defconfig
index 816c3ec..a3d727e 100644
--- a/arch/m32r/configs/m32700ut.smp_defconfig
+++ b/arch/m32r/configs/m32700ut.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/m32700ut.up_defconfig b/arch/m32r/configs/m32700ut.up_defconfig
index 8478568..b833416 100644
--- a/arch/m32r/configs/m32700ut.up_defconfig
+++ b/arch/m32r/configs/m32700ut.up_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.nommu_defconfig b/arch/m32r/configs/mappi.nommu_defconfig
index 354a964..7c90ce2 100644
--- a/arch/m32r/configs/mappi.nommu_defconfig
+++ b/arch/m32r/configs/mappi.nommu_defconfig
@@ -3,7 +3,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.smp_defconfig b/arch/m32r/configs/mappi.smp_defconfig
index 9022307..367d07c 100644
--- a/arch/m32r/configs/mappi.smp_defconfig
+++ b/arch/m32r/configs/mappi.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.up_defconfig b/arch/m32r/configs/mappi.up_defconfig
index 3726068..cb11384 100644
--- a/arch/m32r/configs/mappi.up_defconfig
+++ b/arch/m32r/configs/mappi.up_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi2.opsp_defconfig b/arch/m32r/configs/mappi2.opsp_defconfig
index 6136fad..3bff779 100644
--- a/arch/m32r/configs/mappi2.opsp_defconfig
+++ b/arch/m32r/configs/mappi2.opsp_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi2.vdec2_defconfig b/arch/m32r/configs/mappi2.vdec2_defconfig
index dce1fc7..75246c9 100644
--- a/arch/m32r/configs/mappi2.vdec2_defconfig
+++ b/arch/m32r/configs/mappi2.vdec2_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi3.smp_defconfig b/arch/m32r/configs/mappi3.smp_defconfig
index b204e2e..27cefd4 100644
--- a/arch/m32r/configs/mappi3.smp_defconfig
+++ b/arch/m32r/configs/mappi3.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/oaks32r_defconfig b/arch/m32r/configs/oaks32r_defconfig
index 5aa4ea9..5087a51 100644
--- a/arch/m32r/configs/oaks32r_defconfig
+++ b/arch/m32r/configs/oaks32r_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/opsput_defconfig b/arch/m32r/configs/opsput_defconfig
index 8494c6a..50c6f52 100644
--- a/arch/m32r/configs/opsput_defconfig
+++ b/arch/m32r/configs/opsput_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/usrv_defconfig b/arch/m32r/configs/usrv_defconfig
index 1df293b..a3cfaae 100644
--- a/arch/m32r/configs/usrv_defconfig
+++ b/arch/m32r/configs/usrv_defconfig
@@ -5,7 +5,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/m68knommu/configs/m5208evb_defconfig b/arch/m68knommu/configs/m5208evb_defconfig
index 6ac2981..2f5655c 100644
--- a/arch/m68knommu/configs/m5208evb_defconfig
+++ b/arch/m68knommu/configs/m5208evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5249evb_defconfig b/arch/m68knommu/configs/m5249evb_defconfig
index 14934ff..16df72b 100644
--- a/arch/m68knommu/configs/m5249evb_defconfig
+++ b/arch/m68knommu/configs/m5249evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5272c3_defconfig b/arch/m68knommu/configs/m5272c3_defconfig
index 5985a3b..4e6ea50 100644
--- a/arch/m68knommu/configs/m5272c3_defconfig
+++ b/arch/m68knommu/configs/m5272c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5275evb_defconfig b/arch/m68knommu/configs/m5275evb_defconfig
index 5a7857e..f3dd741 100644
--- a/arch/m68knommu/configs/m5275evb_defconfig
+++ b/arch/m68knommu/configs/m5275evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5307c3_defconfig b/arch/m68knommu/configs/m5307c3_defconfig
index e810201..bce0a20 100644
--- a/arch/m68knommu/configs/m5307c3_defconfig
+++ b/arch/m68knommu/configs/m5307c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5407c3_defconfig b/arch/m68knommu/configs/m5407c3_defconfig
index 5c124a7..618cc32 100644
--- a/arch/m68knommu/configs/m5407c3_defconfig
+++ b/arch/m68knommu/configs/m5407c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/defconfig b/arch/m68knommu/defconfig
index 6ac2981..2f5655c 100644
--- a/arch/m68knommu/defconfig
+++ b/arch/m68knommu/defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index ab8fbe7..b3f5eec 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -7,7 +7,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE="rootfs.cpio"
 CONFIG_INITRAMFS_COMPRESSION_GZIP=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
index ebc143c..0249e4b 100644
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -6,7 +6,7 @@ CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index f437cd1..5358f90 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -7,7 +7,7 @@ config TRACE_IRQFLAGS_SUPPORT
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED
+	bool "Early printk" if EXPERT
 	depends on SYS_HAS_EARLY_PRINTK
 	default y
 	help
diff --git a/arch/mips/configs/ar7_defconfig b/arch/mips/configs/ar7_defconfig
index c78c7e7..6cd5a51 100644
--- a/arch/mips/configs/ar7_defconfig
+++ b/arch/mips/configs/ar7_defconfig
@@ -14,7 +14,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index 927d58b..22fdf2f 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -21,7 +21,7 @@ CONFIG_CGROUP_CPUACCT=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/bcm63xx_defconfig b/arch/mips/configs/bcm63xx_defconfig
index b806a4e..9190051 100644
--- a/arch/mips/configs/bcm63xx_defconfig
+++ b/arch/mips/configs/bcm63xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_TINY_RCU=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 9749bc8..1cdff6b 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -26,7 +26,7 @@ CONFIG_PID_NS=y
 CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/capcella_defconfig b/arch/mips/configs/capcella_defconfig
index 502a8e9..5135dc0 100644
--- a/arch/mips/configs/capcella_defconfig
+++ b/arch/mips/configs/capcella_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/cavium-octeon_defconfig b/arch/mips/configs/cavium-octeon_defconfig
index 3567b6f..75165df 100644
--- a/arch/mips/configs/cavium-octeon_defconfig
+++ b/arch/mips/configs/cavium-octeon_defconfig
@@ -15,7 +15,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/cobalt_defconfig b/arch/mips/configs/cobalt_defconfig
index 6c4f7e9..5419adb 100644
--- a/arch/mips/configs/cobalt_defconfig
+++ b/arch/mips/configs/cobalt_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/mips/configs/db1000_defconfig b/arch/mips/configs/db1000_defconfig
index dda158b..4044c9e 100644
--- a/arch/mips/configs/db1000_defconfig
+++ b/arch/mips/configs/db1000_defconfig
@@ -11,7 +11,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/db1100_defconfig b/arch/mips/configs/db1100_defconfig
index 7e4fc76..c6b4993 100644
--- a/arch/mips/configs/db1100_defconfig
+++ b/arch/mips/configs/db1100_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/db1200_defconfig b/arch/mips/configs/db1200_defconfig
index 6fe205f..1f69249 100644
--- a/arch/mips/configs/db1200_defconfig
+++ b/arch/mips/configs/db1200_defconfig
@@ -12,7 +12,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/db1500_defconfig b/arch/mips/configs/db1500_defconfig
index a741c554..b6e21c7 100644
--- a/arch/mips/configs/db1500_defconfig
+++ b/arch/mips/configs/db1500_defconfig
@@ -10,7 +10,7 @@ CONFIG_LOCALVERSION="-db1500"
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/db1550_defconfig b/arch/mips/configs/db1550_defconfig
index cd32dd8..798a553 100644
--- a/arch/mips/configs/db1550_defconfig
+++ b/arch/mips/configs/db1550_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index b15bfd1..87d0340 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/e55_defconfig b/arch/mips/configs/e55_defconfig
index 0b60c06..0126e66 100644
--- a/arch/mips/configs/e55_defconfig
+++ b/arch/mips/configs/e55_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index 63944a1..e5b73de 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -17,7 +17,7 @@ CONFIG_NAMESPACES=y
 CONFIG_USER_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index 53edc13..48a40ae 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -11,7 +11,7 @@ CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index 36de199..d160656 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -17,7 +17,7 @@ CONFIG_IPC_NS=y
 CONFIG_USER_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 4b16c48..0e36abc 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -15,7 +15,7 @@ CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip28_defconfig b/arch/mips/configs/ip28_defconfig
index 98f2c77..4dbf626 100644
--- a/arch/mips/configs/ip28_defconfig
+++ b/arch/mips/configs/ip28_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 5bea99b..7bbd521 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 6ae46bc..92a60ae 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/jmr3927_defconfig b/arch/mips/configs/jmr3927_defconfig
index bf24e93..db5705e 100644
--- a/arch/mips/configs/jmr3927_defconfig
+++ b/arch/mips/configs/jmr3927_defconfig
@@ -4,7 +4,7 @@ CONFIG_TOSHIBA_JMR3927=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/lasat_defconfig b/arch/mips/configs/lasat_defconfig
index 6447261..d9f3db2 100644
--- a/arch/mips/configs/lasat_defconfig
+++ b/arch/mips/configs/lasat_defconfig
@@ -8,7 +8,7 @@ CONFIG_HZ_1000=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index f7033f3..167c1d0 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -21,7 +21,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 9d03b68..7270f31 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -15,7 +15,7 @@ CONFIG_UTS_NS=y
 CONFIG_IPC_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 86bf001..9c9a123 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -9,7 +9,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/mipssim_defconfig b/arch/mips/configs/mipssim_defconfig
index 4925f50..b5ad738 100644
--- a/arch/mips/configs/mipssim_defconfig
+++ b/arch/mips/configs/mipssim_defconfig
@@ -7,7 +7,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/mpc30x_defconfig b/arch/mips/configs/mpc30x_defconfig
index efb779f..c16de98 100644
--- a/arch/mips/configs/mpc30x_defconfig
+++ b/arch/mips/configs/mpc30x_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/msp71xx_defconfig b/arch/mips/configs/msp71xx_defconfig
index ab05145..d1142e9 100644
--- a/arch/mips/configs/msp71xx_defconfig
+++ b/arch/mips/configs/msp71xx_defconfig
@@ -8,7 +8,7 @@ CONFIG_LOCALVERSION="-pmc"
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SHMEM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 8146997..a97a42c 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -11,7 +11,7 @@ CONFIG_AUDIT=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/mips/configs/pb1100_defconfig b/arch/mips/configs/pb1100_defconfig
index 1597aa1..75eb1b1 100644
--- a/arch/mips/configs/pb1100_defconfig
+++ b/arch/mips/configs/pb1100_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1200_defconfig b/arch/mips/configs/pb1200_defconfig
index 96f0d43..dcbe270 100644
--- a/arch/mips/configs/pb1200_defconfig
+++ b/arch/mips/configs/pb1200_defconfig
@@ -12,7 +12,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1500_defconfig b/arch/mips/configs/pb1500_defconfig
index b4bfd48..fa00487 100644
--- a/arch/mips/configs/pb1500_defconfig
+++ b/arch/mips/configs/pb1500_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1550_defconfig b/arch/mips/configs/pb1550_defconfig
index 5a66002..e83d649 100644
--- a/arch/mips/configs/pb1550_defconfig
+++ b/arch/mips/configs/pb1550_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pnx8335-stb225_defconfig b/arch/mips/configs/pnx8335-stb225_defconfig
index 39926a1..f292576 100644
--- a/arch/mips/configs/pnx8335-stb225_defconfig
+++ b/arch/mips/configs/pnx8335-stb225_defconfig
@@ -11,7 +11,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/pnx8550-jbs_defconfig b/arch/mips/configs/pnx8550-jbs_defconfig
index 3376bc8..1d1f206 100644
--- a/arch/mips/configs/pnx8550-jbs_defconfig
+++ b/arch/mips/configs/pnx8550-jbs_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/pnx8550-stb810_defconfig b/arch/mips/configs/pnx8550-stb810_defconfig
index 6514f1b..15c66a5 100644
--- a/arch/mips/configs/pnx8550-stb810_defconfig
+++ b/arch/mips/configs/pnx8550-stb810_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/powertv_defconfig b/arch/mips/configs/powertv_defconfig
index f1f58e91..3b0b6e8 100644
--- a/arch/mips/configs/powertv_defconfig
+++ b/arch/mips/configs/powertv_defconfig
@@ -14,7 +14,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index d6457bc..55902d9 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -13,7 +13,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/rbtx49xx_defconfig b/arch/mips/configs/rbtx49xx_defconfig
index 29acfab..9cba856 100644
--- a/arch/mips/configs/rbtx49xx_defconfig
+++ b/arch/mips/configs/rbtx49xx_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 2b3e476..2c0230e 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/sb1250-swarm_defconfig b/arch/mips/configs/sb1250-swarm_defconfig
index 64840d7..5b0463e 100644
--- a/arch/mips/configs/sb1250-swarm_defconfig
+++ b/arch/mips/configs/sb1250-swarm_defconfig
@@ -15,7 +15,7 @@ CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0219_defconfig b/arch/mips/configs/tb0219_defconfig
index d9be37f..30036b4 100644
--- a/arch/mips/configs/tb0219_defconfig
+++ b/arch/mips/configs/tb0219_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0226_defconfig b/arch/mips/configs/tb0226_defconfig
index 3d25dd0..81bfa1d 100644
--- a/arch/mips/configs/tb0226_defconfig
+++ b/arch/mips/configs/tb0226_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0287_defconfig b/arch/mips/configs/tb0287_defconfig
index be697c9..c415c4f 100644
--- a/arch/mips/configs/tb0287_defconfig
+++ b/arch/mips/configs/tb0287_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/workpad_defconfig b/arch/mips/configs/workpad_defconfig
index 7ec9287..ee4b2be 100644
--- a/arch/mips/configs/workpad_defconfig
+++ b/arch/mips/configs/workpad_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/wrppmc_defconfig b/arch/mips/configs/wrppmc_defconfig
index a231b73..44a451b 100644
--- a/arch/mips/configs/wrppmc_defconfig
+++ b/arch/mips/configs/wrppmc_defconfig
@@ -7,7 +7,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_EPOLL is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/yosemite_defconfig b/arch/mips/configs/yosemite_defconfig
index ab3a3dc..f72d305 100644
--- a/arch/mips/configs/yosemite_defconfig
+++ b/arch/mips/configs/yosemite_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index 3f749b6..1fd41ec 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mn10300/configs/asb2364_defconfig b/arch/mn10300/configs/asb2364_defconfig
index 83ce2f2..31d7626 100644
--- a/arch/mn10300/configs/asb2364_defconfig
+++ b/arch/mn10300/configs/asb2364_defconfig
@@ -15,7 +15,7 @@ CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
diff --git a/arch/parisc/configs/a500_defconfig b/arch/parisc/configs/a500_defconfig
index f9305f3..b647b18 100644
--- a/arch/parisc/configs/a500_defconfig
+++ b/arch/parisc/configs/a500_defconfig
@@ -8,7 +8,7 @@ CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index 628d3e0..311ca36 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/powerpc/configs/40x/acadia_defconfig b/arch/powerpc/configs/40x/acadia_defconfig
index 97fedce..4182c77 100644
--- a/arch/powerpc/configs/40x/acadia_defconfig
+++ b/arch/powerpc/configs/40x/acadia_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/ep405_defconfig b/arch/powerpc/configs/40x/ep405_defconfig
index 33b3c24..2dbb293 100644
--- a/arch/powerpc/configs/40x/ep405_defconfig
+++ b/arch/powerpc/configs/40x/ep405_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/hcu4_defconfig b/arch/powerpc/configs/40x/hcu4_defconfig
index 4613079..ebeb4ac 100644
--- a/arch/powerpc/configs/40x/hcu4_defconfig
+++ b/arch/powerpc/configs/40x/hcu4_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/kilauea_defconfig b/arch/powerpc/configs/40x/kilauea_defconfig
index 34b8c1a..532ea9d 100644
--- a/arch/powerpc/configs/40x/kilauea_defconfig
+++ b/arch/powerpc/configs/40x/kilauea_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/makalu_defconfig b/arch/powerpc/configs/40x/makalu_defconfig
index 651be09..3c142ac 100644
--- a/arch/powerpc/configs/40x/makalu_defconfig
+++ b/arch/powerpc/configs/40x/makalu_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/walnut_defconfig b/arch/powerpc/configs/40x/walnut_defconfig
index ded455e..ff57d48 100644
--- a/arch/powerpc/configs/40x/walnut_defconfig
+++ b/arch/powerpc/configs/40x/walnut_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/44x/arches_defconfig b/arch/powerpc/configs/44x/arches_defconfig
index 63746a0..3ed16d5 100644
--- a/arch/powerpc/configs/44x/arches_defconfig
+++ b/arch/powerpc/configs/44x/arches_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/bamboo_defconfig b/arch/powerpc/configs/44x/bamboo_defconfig
index f5f2a4e..b1b7d2c 100644
--- a/arch/powerpc/configs/44x/bamboo_defconfig
+++ b/arch/powerpc/configs/44x/bamboo_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/bluestone_defconfig b/arch/powerpc/configs/44x/bluestone_defconfig
index ac65b48..30a0a8e 100644
--- a/arch/powerpc/configs/44x/bluestone_defconfig
+++ b/arch/powerpc/configs/44x/bluestone_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_PCI_QUIRKS is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/44x/canyonlands_defconfig b/arch/powerpc/configs/44x/canyonlands_defconfig
index 17e4dd9..a46942a 100644
--- a/arch/powerpc/configs/44x/canyonlands_defconfig
+++ b/arch/powerpc/configs/44x/canyonlands_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/ebony_defconfig b/arch/powerpc/configs/44x/ebony_defconfig
index fedd03f..07d77e5 100644
--- a/arch/powerpc/configs/44x/ebony_defconfig
+++ b/arch/powerpc/configs/44x/ebony_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/44x/eiger_defconfig b/arch/powerpc/configs/44x/eiger_defconfig
index ebff701..2ce7e9a 100644
--- a/arch/powerpc/configs/44x/eiger_defconfig
+++ b/arch/powerpc/configs/44x/eiger_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/icon_defconfig b/arch/powerpc/configs/44x/icon_defconfig
index 865e93f..18730ff 100644
--- a/arch/powerpc/configs/44x/icon_defconfig
+++ b/arch/powerpc/configs/44x/icon_defconfig
@@ -6,7 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/iss476-smp_defconfig b/arch/powerpc/configs/44x/iss476-smp_defconfig
index 8ece4c7..92f863a 100644
--- a/arch/powerpc/configs/44x/iss476-smp_defconfig
+++ b/arch/powerpc/configs/44x/iss476-smp_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_PROFILING=y
diff --git a/arch/powerpc/configs/44x/katmai_defconfig b/arch/powerpc/configs/44x/katmai_defconfig
index 4ca9b48..34c0914 100644
--- a/arch/powerpc/configs/44x/katmai_defconfig
+++ b/arch/powerpc/configs/44x/katmai_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/rainier_defconfig b/arch/powerpc/configs/44x/rainier_defconfig
index e3b65d2..21c33fa 100644
--- a/arch/powerpc/configs/44x/rainier_defconfig
+++ b/arch/powerpc/configs/44x/rainier_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/redwood_defconfig b/arch/powerpc/configs/44x/redwood_defconfig
index 64cd0f3..01cc2b1 100644
--- a/arch/powerpc/configs/44x/redwood_defconfig
+++ b/arch/powerpc/configs/44x/redwood_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/sam440ep_defconfig b/arch/powerpc/configs/44x/sam440ep_defconfig
index 01d0336..dfcffed 100644
--- a/arch/powerpc/configs/44x/sam440ep_defconfig
+++ b/arch/powerpc/configs/44x/sam440ep_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/sequoia_defconfig b/arch/powerpc/configs/44x/sequoia_defconfig
index 89b2f96..47e399f 100644
--- a/arch/powerpc/configs/44x/sequoia_defconfig
+++ b/arch/powerpc/configs/44x/sequoia_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/taishan_defconfig b/arch/powerpc/configs/44x/taishan_defconfig
index e3386cf..a6a002e 100644
--- a/arch/powerpc/configs/44x/taishan_defconfig
+++ b/arch/powerpc/configs/44x/taishan_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/warp_defconfig b/arch/powerpc/configs/44x/warp_defconfig
index 9c13b9d..6cf9d66 100644
--- a/arch/powerpc/configs/44x/warp_defconfig
+++ b/arch/powerpc/configs/44x/warp_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/52xx/cm5200_defconfig b/arch/powerpc/configs/52xx/cm5200_defconfig
index f234c4d..69b57da 100644
--- a/arch/powerpc/configs/52xx/cm5200_defconfig
+++ b/arch/powerpc/configs/52xx/cm5200_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/lite5200b_defconfig b/arch/powerpc/configs/52xx/lite5200b_defconfig
index a4a795c..f3638ae 100644
--- a/arch/powerpc/configs/52xx/lite5200b_defconfig
+++ b/arch/powerpc/configs/52xx/lite5200b_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/motionpro_defconfig b/arch/powerpc/configs/52xx/motionpro_defconfig
index 20d53a1..6828eda 100644
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/pcm030_defconfig b/arch/powerpc/configs/52xx/pcm030_defconfig
index 6bd5833..7f7e4a8 100644
--- a/arch/powerpc/configs/52xx/pcm030_defconfig
+++ b/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
diff --git a/arch/powerpc/configs/52xx/tqm5200_defconfig b/arch/powerpc/configs/52xx/tqm5200_defconfig
index 3a1f702..959cd2c 100644
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig
+++ b/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/83xx/asp8347_defconfig b/arch/powerpc/configs/83xx/asp8347_defconfig
index eed42d8..d2762d9 100644
--- a/arch/powerpc/configs/83xx/asp8347_defconfig
+++ b/arch/powerpc/configs/83xx/asp8347_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/kmeter1_defconfig b/arch/powerpc/configs/83xx/kmeter1_defconfig
index e43ecb2..7a7b731 100644
--- a/arch/powerpc/configs/83xx/kmeter1_defconfig
+++ b/arch/powerpc/configs/83xx/kmeter1_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
index c2e6ab5..c683bce 100644
--- a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
index 1d3b200..a721cd3 100644
--- a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
index 91fe73b..a5699a1 100644
--- a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
index 6d300f2..b4da1a7 100644
--- a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
index b236a67..291f822 100644
--- a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
index 001dead..f8b228a 100644
--- a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig b/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
index 9dccefc..99660c0 100644
--- a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
index d4b165d..10b5c4c 100644
--- a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
index 89ba672..45925d7 100644
--- a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig b/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
index 2ea6b40..f367985 100644
--- a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
index bffe3c7..414eda3 100644
--- a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/sbc834x_defconfig b/arch/powerpc/configs/83xx/sbc834x_defconfig
index fa5c9ee..6d6463f 100644
--- a/arch/powerpc/configs/83xx/sbc834x_defconfig
+++ b/arch/powerpc/configs/83xx/sbc834x_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/85xx/ksi8560_defconfig b/arch/powerpc/configs/85xx/ksi8560_defconfig
index 385b1af..8f7c106 100644
--- a/arch/powerpc/configs/85xx/ksi8560_defconfig
+++ b/arch/powerpc/configs/85xx/ksi8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_KSI8560=y
 CONFIG_CPM2=y
diff --git a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig b/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
index 222b704..55e0725 100644
--- a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
+++ b/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC8540_ADS=y
 CONFIG_NO_HZ=y
diff --git a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig b/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
index 619702d..d724095 100644
--- a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
+++ b/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC8560_ADS=y
 CONFIG_BINFMT_MISC=y
diff --git a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig b/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
index 6bf56e8..4b44bea 100644
--- a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
+++ b/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC85xx_CDS=y
 CONFIG_NO_HZ=y
diff --git a/arch/powerpc/configs/85xx/sbc8548_defconfig b/arch/powerpc/configs/85xx/sbc8548_defconfig
index a9a17d0..5b2b651 100644
--- a/arch/powerpc/configs/85xx/sbc8548_defconfig
+++ b/arch/powerpc/configs/85xx/sbc8548_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_SBC8548=y
diff --git a/arch/powerpc/configs/85xx/sbc8560_defconfig b/arch/powerpc/configs/85xx/sbc8560_defconfig
index 820e32d..f7fdb03 100644
--- a/arch/powerpc/configs/85xx/sbc8560_defconfig
+++ b/arch/powerpc/configs/85xx/sbc8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_SBC8560=y
diff --git a/arch/powerpc/configs/85xx/socrates_defconfig b/arch/powerpc/configs/85xx/socrates_defconfig
index b6db3f4..77506b5 100644
--- a/arch/powerpc/configs/85xx/socrates_defconfig
+++ b/arch/powerpc/configs/85xx/socrates_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/stx_gp3_defconfig b/arch/powerpc/configs/85xx/stx_gp3_defconfig
index 333a41b..5d4db15 100644
--- a/arch/powerpc/configs/85xx/stx_gp3_defconfig
+++ b/arch/powerpc/configs/85xx/stx_gp3_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/85xx/tqm8540_defconfig b/arch/powerpc/configs/85xx/tqm8540_defconfig
index 33db352..ddcb9f3 100644
--- a/arch/powerpc/configs/85xx/tqm8540_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8540_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8541_defconfig b/arch/powerpc/configs/85xx/tqm8541_defconfig
index f0c20df..981abd6 100644
--- a/arch/powerpc/configs/85xx/tqm8541_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8541_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8548_defconfig b/arch/powerpc/configs/85xx/tqm8548_defconfig
index a883450..37b3d72 100644
--- a/arch/powerpc/configs/85xx/tqm8548_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8548_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/85xx/tqm8555_defconfig b/arch/powerpc/configs/85xx/tqm8555_defconfig
index ff95f90..3593b32 100644
--- a/arch/powerpc/configs/85xx/tqm8555_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8555_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8560_defconfig b/arch/powerpc/configs/85xx/tqm8560_defconfig
index 8d6c90e..de413ac 100644
--- a/arch/powerpc/configs/85xx/tqm8560_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
index f53efe4..5ea3124 100644
--- a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
+++ b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
@@ -11,7 +11,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
index 432ebc2..4b24412 100644
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
+++ b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc310_defconfig b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
index ce5e919..a360ba4 100644
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
index 589e71e..be2829d 100644
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
index 321fb47..036bfb2 100644
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_ELF_CORE is not set
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
index b5e4639..0c9c7ed 100644
--- a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/sbc8641d_defconfig b/arch/powerpc/configs/86xx/sbc8641d_defconfig
index 71145c3..0a92ca0 100644
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig
+++ b/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs/adder875_defconfig
index ca84c7f..6912874 100644
--- a/arch/powerpc/configs/adder875_defconfig
+++ b/arch/powerpc/configs/adder875_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/e55xx_smp_defconfig b/arch/powerpc/configs/e55xx_smp_defconfig
index 94d120e..06f9549 100644
--- a/arch/powerpc/configs/e55xx_smp_defconfig
+++ b/arch/powerpc/configs/e55xx_smp_defconfig
@@ -12,7 +12,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/ep8248e_defconfig b/arch/powerpc/configs/ep8248e_defconfig
index 2677b08..fceffb3 100644
--- a/arch/powerpc/configs/ep8248e_defconfig
+++ b/arch/powerpc/configs/ep8248e_defconfig
@@ -2,7 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 # CONFIG_IOSCHED_CFQ is not set
diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
index f9a3112..219fd47 100644
--- a/arch/powerpc/configs/ep88xc_defconfig
+++ b/arch/powerpc/configs/ep88xc_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/gamecube_defconfig b/arch/powerpc/configs/gamecube_defconfig
index fcf0a39..e74d3a4 100644
--- a/arch/powerpc/configs/gamecube_defconfig
+++ b/arch/powerpc/configs/gamecube_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 CONFIG_PERF_COUNTERS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/powerpc/configs/holly_defconfig b/arch/powerpc/configs/holly_defconfig
index b9b63a6..94ebfee 100644
--- a/arch/powerpc/configs/holly_defconfig
+++ b/arch/powerpc/configs/holly_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_PPC_CHRP is not set
diff --git a/arch/powerpc/configs/mgcoge_defconfig b/arch/powerpc/configs/mgcoge_defconfig
index c4ed255..39518e9 100644
--- a/arch/powerpc/configs/mgcoge_defconfig
+++ b/arch/powerpc/configs/mgcoge_defconfig
@@ -3,7 +3,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 # CONFIG_IOSCHED_CFQ is not set
diff --git a/arch/powerpc/configs/mgsuvd_defconfig b/arch/powerpc/configs/mgsuvd_defconfig
index f276c7c..2a49062 100644
--- a/arch/powerpc/configs/mgsuvd_defconfig
+++ b/arch/powerpc/configs/mgsuvd_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BUG is not set
diff --git a/arch/powerpc/configs/mpc7448_hpc2_defconfig b/arch/powerpc/configs/mpc7448_hpc2_defconfig
index 3b94708..75f0bbf 100644
--- a/arch/powerpc/configs/mpc7448_hpc2_defconfig
+++ b/arch/powerpc/configs/mpc7448_hpc2_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/mpc8272_ads_defconfig b/arch/powerpc/configs/mpc8272_ads_defconfig
index c7d68ff..6a22400 100644
--- a/arch/powerpc/configs/mpc8272_ads_defconfig
+++ b/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -2,7 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/mpc83xx_defconfig b/arch/powerpc/configs/mpc83xx_defconfig
index 5b1b10f..5aac9a8 100644
--- a/arch/powerpc/configs/mpc83xx_defconfig
+++ b/arch/powerpc/configs/mpc83xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index 3aeb594..99a19d1 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/mpc85xx_smp_defconfig b/arch/powerpc/configs/mpc85xx_smp_defconfig
index d62c801..c636f23 100644
--- a/arch/powerpc/configs/mpc85xx_smp_defconfig
+++ b/arch/powerpc/configs/mpc85xx_smp_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/mpc866_ads_defconfig b/arch/powerpc/configs/mpc866_ads_defconfig
index 668215c..5c25882 100644
--- a/arch/powerpc/configs/mpc866_ads_defconfig
+++ b/arch/powerpc/configs/mpc866_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BUG is not set
diff --git a/arch/powerpc/configs/mpc86xx_defconfig b/arch/powerpc/configs/mpc86xx_defconfig
index 63b90d4..55b5431 100644
--- a/arch/powerpc/configs/mpc86xx_defconfig
+++ b/arch/powerpc/configs/mpc86xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index f9b8348..9e146cd 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/ppc40x_defconfig b/arch/powerpc/configs/ppc40x_defconfig
index 93d7425..bfd634b 100644
--- a/arch/powerpc/configs/ppc40x_defconfig
+++ b/arch/powerpc/configs/ppc40x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/ppc44x_defconfig b/arch/powerpc/configs/ppc44x_defconfig
index 2fa05f7..4713320 100644
--- a/arch/powerpc/configs/ppc44x_defconfig
+++ b/arch/powerpc/configs/ppc44x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/pq2fads_defconfig b/arch/powerpc/configs/pq2fads_defconfig
index a4353be..baad8db 100644
--- a/arch/powerpc/configs/pq2fads_defconfig
+++ b/arch/powerpc/configs/pq2fads_defconfig
@@ -3,7 +3,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index 49cffe0..caba919 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -8,7 +8,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_PERF_EVENTS is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/storcenter_defconfig b/arch/powerpc/configs/storcenter_defconfig
index 4f0c10a..ebb2a66 100644
--- a/arch/powerpc/configs/storcenter_defconfig
+++ b/arch/powerpc/configs/storcenter_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/tqm8xx_defconfig b/arch/powerpc/configs/tqm8xx_defconfig
index d0a5b67..8616fde 100644
--- a/arch/powerpc/configs/tqm8xx_defconfig
+++ b/arch/powerpc/configs/tqm8xx_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/wii_defconfig b/arch/powerpc/configs/wii_defconfig
index bb8ba75..175295f 100644
--- a/arch/powerpc/configs/wii_defconfig
+++ b/arch/powerpc/configs/wii_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 CONFIG_PERF_COUNTERS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/powerpc/platforms/iseries/Kconfig b/arch/powerpc/platforms/iseries/Kconfig
index 47a20cf..e5bc9f7 100644
--- a/arch/powerpc/platforms/iseries/Kconfig
+++ b/arch/powerpc/platforms/iseries/Kconfig
@@ -2,7 +2,7 @@ config PPC_ISERIES
 	bool "IBM Legacy iSeries"
 	depends on PPC64 && PPC_BOOK3S
 	select PPC_INDIRECT_IO
-	select PPC_PCI_CHOICE if EMBEDDED
+	select PPC_PCI_CHOICE if EXPERT
 
 menu "iSeries device drivers"
 	depends on PPC_ISERIES
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 5d1b743..5b3da4b 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -10,7 +10,7 @@ config PPC_PSERIES
 	select RTAS_ERROR_LOGGING
 	select PPC_UDBG_16550
 	select PPC_NATIVE
-	select PPC_PCI_CHOICE if EMBEDDED
+	select PPC_PCI_CHOICE if EXPERT
 	default y
 
 config PPC_SPLPAR
@@ -24,9 +24,9 @@ config PPC_SPLPAR
 	  two or more partitions.
 
 config EEH
-	bool "PCI Extended Error Handling (EEH)" if EMBEDDED
+	bool "PCI Extended Error Handling (EEH)" if EXPERT
 	depends on PPC_PSERIES && PCI
-	default y if !EMBEDDED
+	default y if !EXPERT
 
 config PSERIES_MSI
        bool
diff --git a/arch/score/configs/spct6600_defconfig b/arch/score/configs/spct6600_defconfig
index 9883c50..df1edbf 100644
--- a/arch/score/configs/spct6600_defconfig
+++ b/arch/score/configs/spct6600_defconfig
@@ -9,7 +9,7 @@ CONFIG_LOG_BUF_SHIFT=12
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index fff2522..ae55556 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -1,6 +1,6 @@
 config SUPERH
 	def_bool y
-	select EMBEDDED
+	select EXPERT
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT
 	select HAVE_MEMBLOCK
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index e11b5fc..4e8b82b 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -220,7 +220,7 @@ config FORCE_MAX_ZONEORDER
 
 choice
 	depends on !TILEGX
-	prompt "Memory split" if EMBEDDED
+	prompt "Memory split" if EXPERT
 	default VMSPLIT_3G
 	---help---
 	  Select the desired split between kernel and user memory.
diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
index a81f0fb..9bc161a 100644
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -3,7 +3,7 @@ menu "Kernel hacking"
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
+	bool "Early printk" if EXPERT && DEBUG_KERNEL
 	default y
 	help
 	  Write kernel log output directly via the hypervisor console.
diff --git a/arch/tile/configs/tile_defconfig b/arch/tile/configs/tile_defconfig
index 919c54a..0fe54445 100644
--- a/arch/tile/configs/tile_defconfig
+++ b/arch/tile/configs/tile_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE="usr/contents.txt"
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
 CONFIG_MODULES=y
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 564f3de..9f7634f 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -133,7 +133,7 @@ CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_BLK_DEV_INITRD is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
-# CONFIG_EMBEDDED is not set
+# CONFIG_EXPERT is not set
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3ed5ad9..d5ed94d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -627,11 +627,11 @@ config APB_TIMER
          as it is off-chip. APB timers are always running regardless of CPU
          C states, they are used as per CPU clockevent device when possible.
 
-# Mark as embedded because too many people got it wrong.
+# Mark as expert because too many people got it wrong.
 # The code disables itself when not needed.
 config DMI
 	default y
-	bool "Enable DMI scanning" if EMBEDDED
+	bool "Enable DMI scanning" if EXPERT
 	---help---
 	  Enabled scanning of DMI to identify machine quirks. Say Y
 	  here unless you have verified that your setup is not
@@ -639,7 +639,7 @@ config DMI
 	  BIOS code.
 
 config GART_IOMMU
-	bool "GART IOMMU support" if EMBEDDED
+	bool "GART IOMMU support" if EXPERT
 	default y
 	select SWIOTLB
 	depends on X86_64 && PCI && AMD_NB
@@ -889,7 +889,7 @@ config X86_THERMAL_VECTOR
 	depends on X86_MCE_INTEL
 
 config VM86
-	bool "Enable VM86 support" if EMBEDDED
+	bool "Enable VM86 support" if EXPERT
 	default y
 	depends on X86_32
 	---help---
@@ -1073,7 +1073,7 @@ endchoice
 
 choice
 	depends on EXPERIMENTAL
-	prompt "Memory split" if EMBEDDED
+	prompt "Memory split" if EXPERT
 	default VMSPLIT_3G
 	depends on X86_32
 	---help---
@@ -1135,7 +1135,7 @@ config ARCH_DMA_ADDR_T_64BIT
 	def_bool X86_64 || HIGHMEM64G
 
 config DIRECT_GBPAGES
-	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
+	bool "Enable 1GB pages for kernel pagetables" if EXPERT
 	default y
 	depends on X86_64
 	---help---
@@ -1369,7 +1369,7 @@ config MATH_EMULATION
 
 config MTRR
 	def_bool y
-	prompt "MTRR (Memory Type Range Register) support" if EMBEDDED
+	prompt "MTRR (Memory Type Range Register) support" if EXPERT
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
 	  the Memory Type Range Registers (MTRRs) may be used to control
@@ -1435,7 +1435,7 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
 
 config X86_PAT
 	def_bool y
-	prompt "x86 PAT support" if EMBEDDED
+	prompt "x86 PAT support" if EXPERT
 	depends on MTRR
 	---help---
 	  Use PAT attributes to setup page level cache control.
@@ -1539,7 +1539,7 @@ config KEXEC_JUMP
 	  code in physical address mode via KEXEC
 
 config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
+	hex "Physical address where the kernel is loaded" if (EXPERT || CRASH_DUMP)
 	default "0x1000000"
 	---help---
 	  This gives the physical address where the kernel is loaded.
@@ -1934,7 +1934,7 @@ config PCI_MMCONFIG
 	depends on X86_64 && PCI && ACPI
 
 config PCI_CNB20LE_QUIRK
-	bool "Read CNB20LE Host Bridge Windows" if EMBEDDED
+	bool "Read CNB20LE Host Bridge Windows" if EXPERT
 	default n
 	depends on PCI && EXPERIMENTAL
 	help
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 15588a0..283c5a6 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -424,7 +424,7 @@ config X86_DEBUGCTLMSR
 	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386) && !UML
 
 menuconfig PROCESSOR_SELECT
-	bool "Supported processor vendors" if EMBEDDED
+	bool "Supported processor vendors" if EXPERT
 	---help---
 	  This lets you choose what x86 vendor support code your kernel
 	  will include.
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 45143bb..615e188 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -31,7 +31,7 @@ config X86_VERBOSE_BOOTUP
 	  see errors. Disable this if you want silent bootup.
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED
+	bool "Early printk" if EXPERT
 	default y
 	---help---
 	  Write kernel log output directly into the VGA buffer or to a serial
@@ -138,7 +138,7 @@ config DEBUG_NX_TEST
 
 config DOUBLEFAULT
 	default y
-	bool "Enable doublefault exception handler" if EMBEDDED
+	bool "Enable doublefault exception handler" if EXPERT
 	depends on X86_32
 	---help---
 	  This option allows trapping of rare doublefault exceptions that
diff --git a/arch/xtensa/configs/common_defconfig b/arch/xtensa/configs/common_defconfig
index 1d230ee..b90038e 100644
--- a/arch/xtensa/configs/common_defconfig
+++ b/arch/xtensa/configs/common_defconfig
@@ -32,7 +32,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_HOTPLUG is not set
 CONFIG_KOBJECT_UEVENT=y
 # CONFIG_IKCONFIG is not set
-# CONFIG_EMBEDDED is not set
+# CONFIG_EXPERT is not set
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
 # CONFIG_KALLSYMS_EXTRA_PASS is not set
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 7368164..0234cd1 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -55,7 +55,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index bb84fbc..095cd80 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -55,7 +55,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
diff --git a/block/Kconfig b/block/Kconfig
index 6c9213e..60be1e0 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -2,7 +2,7 @@
 # Block layer core configuration
 #
 menuconfig BLOCK
-       bool "Enable the block layer" if EMBEDDED
+       bool "Enable the block layer" if EXPERT
        default y
        help
 	 Provide block layer support for the kernel.
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 10c7ad5..2aa042a 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -318,7 +318,7 @@ config ACPI_PCI_SLOT
 	  the module will be called pci_slot.
 
 config X86_PM_TIMER
-	bool "Power Management Timer Support" if EMBEDDED
+	bool "Power Management Timer Support" if EXPERT
 	depends on X86
 	default y
 	help
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index c6b298d..c2328ae 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -783,7 +783,7 @@ config PATA_PCMCIA
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
+	depends on EXPERT || PPC || HAVE_PATA_PLATFORM
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index fd96345..d57e8d0 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -70,7 +70,7 @@ config PREVENT_FIRMWARE_BUILD
 	  If unsure say Y here.
 
 config FW_LOADER
-	tristate "Userspace firmware loading support" if EMBEDDED
+	tristate "Userspace firmware loading support" if EXPERT
 	default y
 	---help---
 	  This option is provided for the case where no in-kernel-tree modules
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 0f175a8..4237602 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -5,7 +5,7 @@
 menu "Character devices"
 
 config VT
-	bool "Virtual terminal" if EMBEDDED
+	bool "Virtual terminal" if EXPERT
 	depends on !S390
 	select INPUT
 	default y
@@ -39,13 +39,13 @@ config VT
 config CONSOLE_TRANSLATIONS
 	depends on VT
 	default y
-	bool "Enable character translations in console" if EMBEDDED
+	bool "Enable character translations in console" if EXPERT
 	---help---
 	  This enables support for font mapping and Unicode translation
 	  on virtual consoles.
 
 config VT_CONSOLE
-	bool "Support for console on virtual terminal" if EMBEDDED
+	bool "Support for console on virtual terminal" if EXPERT
 	depends on VT
 	default y
 	---help---
@@ -429,7 +429,7 @@ config SGI_MBCS
 source "drivers/serial/Kconfig"
 
 config UNIX98_PTYS
-	bool "Unix98 PTY support" if EMBEDDED
+	bool "Unix98 PTY support" if EXPERT
 	default y
 	---help---
 	  A pseudo terminal (PTY) is a software device consisting of two
@@ -495,7 +495,7 @@ config LEGACY_PTY_COUNT
 
 config TTY_PRINTK
 	bool "TTY driver to output user messages via printk"
-	depends on EMBEDDED
+	depends on EXPERT
 	default n
 	---help---
 	  If you say Y here, the support for writing user messages (i.e.
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index a8c8d9c..ca8ee80 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -71,7 +71,7 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 
 config CPU_FREQ_DEFAULT_GOV_POWERSAVE
 	bool "powersave"
-	depends on EMBEDDED
+	depends on EXPERT
 	select CPU_FREQ_GOV_POWERSAVE
 	help
 	  Use the CPUFreq governor 'powersave' as default. This sets
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index e8b6a13..e710424 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -27,7 +27,7 @@ config EDD_OFF
 	  using the kernel parameter 'edd={on|skipmbr|off}'.
 
 config FIRMWARE_MEMMAP
-    bool "Add firmware-provided memory map to sysfs" if EMBEDDED
+    bool "Add firmware-provided memory map to sysfs" if EXPERT
     default X86
     help
       Add the firmware-provided (unmodified) memory map to /sys/firmware/memmap.
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 64828a7..bea966f 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -23,7 +23,7 @@ config DRM_KMS_HELPER
 	tristate
 	depends on DRM
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EMBEDDED
+	select FRAMEBUFFER_CONSOLE if !EXPERT
 	help
 	  FB and CRTC helpers for KMS drivers.
 
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 5c4f9b9..6977a1c 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1533,11 +1533,11 @@ bool drm_fb_helper_hotplug_event(struct drm_fb_helper *fb_helper)
 }
 EXPORT_SYMBOL(drm_fb_helper_hotplug_event);
 
-/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EMBEDDED)
+/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
  * but the module doesn't depend on any fb console symbols.  At least
  * attempt to load fbcon to avoid leaving the system without a usable console.
  */
-#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EMBEDDED)
+#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
 static int __init drm_fb_helper_modinit(void)
 {
 	const char *name = "fbcon";
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 21d6c29..de70959 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -8,7 +8,7 @@ config DRM_NOUVEAU
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EMBEDDED
+	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
 	help
diff --git a/drivers/gpu/vga/Kconfig b/drivers/gpu/vga/Kconfig
index 8d0e31a..96c83a9 100644
--- a/drivers/gpu/vga/Kconfig
+++ b/drivers/gpu/vga/Kconfig
@@ -1,5 +1,5 @@
 config VGA_ARB
-	bool "VGA Arbitration" if EMBEDDED
+	bool "VGA Arbitration" if EXPERT
 	default y
 	depends on PCI
 	help
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 24cca2f..2560f01 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -62,9 +62,9 @@ config HID_3M_PCT
 	Support for 3M PCT touch screens.
 
 config HID_A4TECH
-	tristate "A4 tech mice" if EMBEDDED
+	tristate "A4 tech mice" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
@@ -77,9 +77,9 @@ config HID_ACRUX_FF
 	game controllers.
 
 config HID_APPLE
-	tristate "Apple {i,Power,Mac}Books" if EMBEDDED
+	tristate "Apple {i,Power,Mac}Books" if EXPERT
 	depends on (USB_HID || BT_HIDP)
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for some Apple devices which less or more break
 	HID specification.
@@ -88,9 +88,9 @@ config HID_APPLE
 	MacBooks, MacBook Pros and Apple Aluminum.
 
 config HID_BELKIN
-	tristate "Belkin Flip KVM and Wireless keyboard" if EMBEDDED
+	tristate "Belkin Flip KVM and Wireless keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
@@ -101,16 +101,16 @@ config HID_CANDO
 	Support for Cando dual touch panel.
 
 config HID_CHERRY
-	tristate "Cherry Cymotion keyboard" if EMBEDDED
+	tristate "Cherry Cymotion keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Cherry Cymotion keyboard.
 
 config HID_CHICONY
-	tristate "Chicony Tactical pad" if EMBEDDED
+	tristate "Chicony Tactical pad" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Chicony Tactical pad.
 
@@ -130,9 +130,9 @@ config HID_PRODIKEYS
 	  and some additional multimedia keys.
 
 config HID_CYPRESS
-	tristate "Cypress mouse and barcode readers" if EMBEDDED
+	tristate "Cypress mouse and barcode readers" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for cypress mouse and barcode readers.
 
@@ -174,16 +174,16 @@ config HID_ELECOM
 	Support for the ELECOM BM084 (bluetooth mouse).
 
 config HID_EZKEY
-	tristate "Ezkey BTC 8193 keyboard" if EMBEDDED
+	tristate "Ezkey BTC 8193 keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Ezkey BTC 8193 keyboard.
 
 config HID_KYE
-	tristate "Kye/Genius Ergo Mouse" if EMBEDDED
+	tristate "Kye/Genius Ergo Mouse" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Kye/Genius Ergo Mouse.
 
@@ -212,16 +212,16 @@ config HID_TWINHAN
 	Support for Twinhan IR remote control.
 
 config HID_KENSINGTON
-	tristate "Kensington Slimblade Trackball" if EMBEDDED
+	tristate "Kensington Slimblade Trackball" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Kensington Slimblade Trackball.
 
 config HID_LOGITECH
-	tristate "Logitech devices" if EMBEDDED
+	tristate "Logitech devices" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
 
@@ -276,9 +276,9 @@ config HID_MAGICMOUSE
 	Apple Wireless "Magic" Mouse.
 
 config HID_MICROSOFT
-	tristate "Microsoft non-fully HID-compliant devices" if EMBEDDED
+	tristate "Microsoft non-fully HID-compliant devices" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Microsoft devices that are not fully compliant with HID standard.
 
@@ -289,9 +289,9 @@ config HID_MOSART
 	Support for MosArt dual-touch panels.
 
 config HID_MONTEREY
-	tristate "Monterey Genius KB29E keyboard" if EMBEDDED
+	tristate "Monterey Genius KB29E keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Monterey Genius KB29E.
 
@@ -365,8 +365,8 @@ config HID_PICOLCD
 	  - IR
 
 config HID_PICOLCD_FB
-	bool "Framebuffer support" if EMBEDDED
-	default !EMBEDDED
+	bool "Framebuffer support" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=FB || FB=y
 	select FB_DEFERRED_IO
@@ -379,8 +379,8 @@ config HID_PICOLCD_FB
 	  frambuffer device.
 
 config HID_PICOLCD_BACKLIGHT
-	bool "Backlight control" if EMBEDDED
-	default !EMBEDDED
+	bool "Backlight control" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
 	---help---
@@ -388,16 +388,16 @@ config HID_PICOLCD_BACKLIGHT
 	  class.
 
 config HID_PICOLCD_LCD
-	bool "Contrast control" if EMBEDDED
-	default !EMBEDDED
+	bool "Contrast control" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
 	---help---
 	  Provide access to PicoLCD's LCD contrast via lcd class.
 
 config HID_PICOLCD_LEDS
-	bool "GPO via leds class" if EMBEDDED
-	default !EMBEDDED
+	bool "GPO via leds class" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
 	---help---
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index 4edb3be..0f20fd1 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -45,7 +45,7 @@ config USB_HIDDEV
 	  If unsure, say Y.
 
 menu "USB HID Boot Protocol drivers"
-	depends on USB!=n && USB_HID!=y && EMBEDDED
+	depends on USB!=n && USB_HID!=y && EXPERT
 
 config USB_KBD
 	tristate "USB HIDBP Keyboard (simple Boot) support"
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 98ccfeb..9827c5e 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -134,7 +134,7 @@ config BLK_DEV_IDECD
 	  module will be called ide-cd.
 
 config BLK_DEV_IDECD_VERBOSE_ERRORS
-	bool "Verbose error logging for IDE/ATAPI CDROM driver" if EMBEDDED
+	bool "Verbose error logging for IDE/ATAPI CDROM driver" if EXPERT
 	depends on BLK_DEV_IDECD
 	default y
 	help
diff --git a/drivers/infiniband/hw/mthca/Kconfig b/drivers/infiniband/hw/mthca/Kconfig
index 03efc07..da314c3 100644
--- a/drivers/infiniband/hw/mthca/Kconfig
+++ b/drivers/infiniband/hw/mthca/Kconfig
@@ -7,7 +7,7 @@ config INFINIBAND_MTHCA
 	  ("Tavor") and the MT25208 PCI Express HCA ("Arbel").
 
 config INFINIBAND_MTHCA_DEBUG
-	bool "Verbose debugging output" if EMBEDDED
+	bool "Verbose debugging output" if EXPERT
 	depends on INFINIBAND_MTHCA
 	default y
 	---help---
diff --git a/drivers/infiniband/ulp/ipoib/Kconfig b/drivers/infiniband/ulp/ipoib/Kconfig
index 55855ee..cda8eac 100644
--- a/drivers/infiniband/ulp/ipoib/Kconfig
+++ b/drivers/infiniband/ulp/ipoib/Kconfig
@@ -24,7 +24,7 @@ config INFINIBAND_IPOIB_CM
 	  unless you limit mtu for these destinations to 2044.
 
 config INFINIBAND_IPOIB_DEBUG
-	bool "IP-over-InfiniBand debugging" if EMBEDDED
+	bool "IP-over-InfiniBand debugging" if EXPERT
 	depends on INFINIBAND_IPOIB
 	default y
 	---help---
diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 07c2cd4..1903c0f 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -6,7 +6,7 @@ menu "Input device support"
 	depends on !S390
 
 config INPUT
-	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EMBEDDED
+	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EXPERT
 	default y
 	help
 	  Say Y here if you have any input device (mouse, keyboard, tablet,
@@ -67,7 +67,7 @@ config INPUT_SPARSEKMAP
 comment "Userland interfaces"
 
 config INPUT_MOUSEDEV
-	tristate "Mouse interface" if EMBEDDED
+	tristate "Mouse interface" if EXPERT
 	default y
 	help
 	  Say Y here if you want your mouse to be accessible as char devices
@@ -150,7 +150,7 @@ config INPUT_EVBUG
 	  module will be called evbug.
 
 config INPUT_APMPOWER
-	tristate "Input Power Event -> APM Bridge" if EMBEDDED
+	tristate "Input Power Event -> APM Bridge" if EXPERT
 	depends on INPUT && APM_EMULATION
 	help
 	  Say Y here if you want suspend key events to trigger a user
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 7b3c0b8..4175073 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 menuconfig INPUT_KEYBOARD
-	bool "Keyboards" if EMBEDDED || !X86
+	bool "Keyboards" if EXPERT || !X86
 	default y
 	help
 	  Say Y here, and a list of supported keyboards will be displayed.
@@ -57,7 +57,7 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EMBEDDED || !X86
+	tristate "AT keyboard" if EXPERT || !X86
 	default y
 	select SERIO
 	select SERIO_LIBPS2
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index bf5fd7f..9c1e6ee 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -39,7 +39,7 @@ config MOUSE_PS2
 	  module will be called psmouse.
 
 config MOUSE_PS2_ALPS
-	bool "ALPS PS/2 mouse protocol extension" if EMBEDDED
+	bool "ALPS PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -49,7 +49,7 @@ config MOUSE_PS2_ALPS
 	  If unsure, say Y.
 
 config MOUSE_PS2_LOGIPS2PP
-	bool "Logitech PS/2++ mouse protocol extension" if EMBEDDED
+	bool "Logitech PS/2++ mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -59,7 +59,7 @@ config MOUSE_PS2_LOGIPS2PP
 	  If unsure, say Y.
 
 config MOUSE_PS2_SYNAPTICS
-	bool "Synaptics PS/2 mouse protocol extension" if EMBEDDED
+	bool "Synaptics PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -69,7 +69,7 @@ config MOUSE_PS2_SYNAPTICS
 	  If unsure, say Y.
 
 config MOUSE_PS2_LIFEBOOK
-	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EMBEDDED
+	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2 && X86 && DMI
 	help
@@ -79,7 +79,7 @@ config MOUSE_PS2_LIFEBOOK
 	  If unsure, say Y.
 
 config MOUSE_PS2_TRACKPOINT
-	bool "IBM Trackpoint PS/2 mouse protocol extension" if EMBEDDED
+	bool "IBM Trackpoint PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 307eef7..55f2c22 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 config SERIO
-	tristate "Serial I/O support" if EMBEDDED || !X86
+	tristate "Serial I/O support" if EXPERT || !X86
 	default y
 	help
 	  Say Yes here if you have any input device that uses serial I/O to
@@ -19,7 +19,7 @@ config SERIO
 if SERIO
 
 config SERIO_I8042
-	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
+	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
 		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
@@ -168,7 +168,7 @@ config SERIO_MACEPS2
 	  module will be called maceps2.
 
 config SERIO_LIBPS2
-	tristate "PS/2 driver library" if EMBEDDED
+	tristate "PS/2 driver library" if EXPERT
 	depends on SERIO_I8042 || SERIO_I8042=n
 	help
 	  Say Y here if you are using a driver for device connected
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 0c9f4b1..61834ae 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -540,62 +540,62 @@ config TOUCHSCREEN_MC13783
 
 config TOUCHSCREEN_USB_EGALAX
 	default y
-	bool "eGalax, eTurboTouch CT-410/510/700 device support" if EMBEDDED
+	bool "eGalax, eTurboTouch CT-410/510/700 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_PANJIT
 	default y
-	bool "PanJit device support" if EMBEDDED
+	bool "PanJit device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_3M
 	default y
-	bool "3M/Microtouch EX II series device support" if EMBEDDED
+	bool "3M/Microtouch EX II series device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ITM
 	default y
-	bool "ITM device support" if EMBEDDED
+	bool "ITM device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ETURBO
 	default y
-	bool "eTurboTouch (non-eGalax compatible) device support" if EMBEDDED
+	bool "eTurboTouch (non-eGalax compatible) device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GUNZE
 	default y
-	bool "Gunze AHL61 device support" if EMBEDDED
+	bool "Gunze AHL61 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_DMC_TSC10
 	default y
-	bool "DMC TSC-10/25 device support" if EMBEDDED
+	bool "DMC TSC-10/25 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_IRTOUCH
 	default y
-	bool "IRTOUCHSYSTEMS/UNITOP device support" if EMBEDDED
+	bool "IRTOUCHSYSTEMS/UNITOP device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_IDEALTEK
 	default y
-	bool "IdealTEK URTC1000 device support" if EMBEDDED
+	bool "IdealTEK URTC1000 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GENERAL_TOUCH
 	default y
-	bool "GeneralTouch Touchscreen device support" if EMBEDDED
+	bool "GeneralTouch Touchscreen device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GOTOP
 	default y
-	bool "GoTop Super_Q2/GogoPen/PenPower tablet device support" if EMBEDDED
+	bool "GoTop Super_Q2/GogoPen/PenPower tablet device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_JASTEC
 	default y
-	bool "JASTEC/DigiTech DTR-02U USB touch controller device support" if EMBEDDED
+	bool "JASTEC/DigiTech DTR-02U USB touch controller device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_E2I
@@ -605,17 +605,17 @@ config TOUCHSCREEN_USB_E2I
 
 config TOUCHSCREEN_USB_ZYTRONIC
 	default y
-	bool "Zytronic controller" if EMBEDDED
+	bool "Zytronic controller" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ETT_TC45USB
 	default y
-	bool "ET&T USB series TC4UM/TC5UH touchscreen controller support" if EMBEDDED
+	bool "ET&T USB series TC4UM/TC5UH touchscreen controller support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_NEXIO
 	default y
-	bool "NEXIO/iNexio device support" if EMBEDDED
+	bool "NEXIO/iNexio device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_TOUCHIT213
diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 78b0895..6fc79f1 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -34,7 +34,7 @@ config MEDIA_TUNER
 config MEDIA_TUNER_CUSTOMISE
 	bool "Customize analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
-	default y if EMBEDDED
+	default y if EXPERT
 	help
 	  This allows the user to deselect tuner drivers unnecessary
 	  for their hardware from the build. Use this option with care
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index ef3e43a..b8519ba 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -1,7 +1,7 @@
 config DVB_FE_CUSTOMISE
 	bool "Customise the frontend modules to build"
 	depends on DVB_CORE
-	default y if EMBEDDED
+	default y if EXPERT
 	help
 	  This allows the user to select/deselect frontend drivers for their
 	  hardware from the build.
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index eb875af..34e7aba 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -78,7 +78,7 @@ config VIDEO_FIXED_MINOR_RANGES
 
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
-	default y if !EMBEDDED
+	default y if !EXPERT
 	---help---
 	  Most video cards may require additional modules to encode or
 	  decode audio/video standards. This option will autoselect
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 16fe4f9..0382332 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2864,7 +2864,7 @@ config MLX4_CORE
 	default n
 
 config MLX4_DEBUG
-	bool "Verbose debugging output" if (MLX4_CORE && EMBEDDED)
+	bool "Verbose debugging output" if (MLX4_CORE && EXPERT)
 	depends on MLX4_CORE
 	default y
 	---help---
diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index dda7098..dc29348 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -31,7 +31,7 @@ source "drivers/pci/pcie/aer/Kconfig"
 # PCI Express ASPM
 #
 config PCIEASPM
-	bool "PCI Express ASPM control" if EMBEDDED
+	bool "PCI Express ASPM control" if EXPERT
 	depends on PCI && PCIEPORTBUS
 	default y
 	help
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index de886f3..6e318ce 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -69,7 +69,7 @@ comment "PC-card bridges"
 config YENTA
 	tristate "CardBus yenta-compatible bridge support"
 	depends on PCI
-	select CARDBUS if !EMBEDDED
+	select CARDBUS if !EXPERT
 	select PCCARD_NONSTATIC if PCMCIA != n
 	---help---
 	  This option enables support for CardBus host bridges.  Virtually
@@ -84,27 +84,27 @@ config YENTA
 
 config YENTA_O2
 	default y
-	bool "Special initialization for O2Micro bridges" if EMBEDDED
+	bool "Special initialization for O2Micro bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_RICOH
 	default y
-	bool "Special initialization for Ricoh bridges" if EMBEDDED
+	bool "Special initialization for Ricoh bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_TI
 	default y
-	bool "Special initialization for TI and EnE bridges" if EMBEDDED
+	bool "Special initialization for TI and EnE bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_ENE_TUNE
 	default y
-	bool "Auto-tune EnE bridges for CB cards" if EMBEDDED
+	bool "Auto-tune EnE bridges for CB cards" if EXPERT
 	depends on YENTA_TI && CARDBUS
 
 config YENTA_TOSHIBA
 	default y
-	bool "Special initialization for Toshiba ToPIC bridges" if EMBEDDED
+	bool "Special initialization for Toshiba ToPIC bridges" if EXPERT
 	depends on YENTA
 
 config PD6729
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index c1df767..b1682d7 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -81,7 +81,7 @@ config SERIAL_8250_GSC
 	default SERIAL_8250
 
 config SERIAL_8250_PCI
-	tristate "8250/16550 PCI device support" if EMBEDDED
+	tristate "8250/16550 PCI device support" if EXPERT
 	depends on SERIAL_8250 && PCI
 	default SERIAL_8250
 	help
@@ -90,7 +90,7 @@ config SERIAL_8250_PCI
 	  Saves about 9K.
 
 config SERIAL_8250_PNP
-	tristate "8250/16550 PNP device support" if EMBEDDED
+	tristate "8250/16550 PNP device support" if EXPERT
 	depends on SERIAL_8250 && PNP
 	default SERIAL_8250
 	help
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 2d8cc45..42cdaa9 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -82,7 +82,7 @@ config SSB_SDIOHOST
 
 config SSB_SILENT
 	bool "No SSB kernel messages"
-	depends on SSB && EMBEDDED
+	depends on SSB && EXPERT
 	help
 	  This option turns off all Sonics Silicon Backplane printks.
 	  Note that you won't be able to identify problems, once
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index bcc2477..18d02e3 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -123,9 +123,9 @@ config USB_OTG
 
 config USB_OTG_WHITELIST
 	bool "Rely on OTG Targeted Peripherals List"
-	depends on USB_OTG || EMBEDDED
+	depends on USB_OTG || EXPERT
 	default y if USB_OTG
-	default n if EMBEDDED
+	default n if EXPERT
 	help
 	  If you say Y here, the "otg_whitelist.h" file will be used as a
 	  product whitelist, so USB peripherals not listed there will be
@@ -141,7 +141,7 @@ config USB_OTG_WHITELIST
 
 config USB_OTG_BLACKLIST_HUB
 	bool "Disable external hubs"
-	depends on USB_OTG || EMBEDDED
+	depends on USB_OTG || EXPERT
 	help
 	  If you say Y here, then Linux will refuse to enumerate
 	  external hubs.  OTG hosts are allowed to reduce hardware
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index d916ac0..6bafb51b 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1227,7 +1227,7 @@ config FB_CARILLO_RANCH
 
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EMBEDDED
+	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EXPERT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 5a35f22..2209e35 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -5,7 +5,7 @@
 menu "Console display driver support"
 
 config VGA_CONSOLE
-	bool "VGA text console" if EMBEDDED || !X86
+	bool "VGA text console" if EXPERT || !X86
 	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
 	default y
 	help
diff --git a/fs/Kconfig b/fs/Kconfig
index 9a7921a..3db9caa 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -50,7 +50,7 @@ config EXPORTFS
 	tristate
 
 config FILE_LOCKING
-	bool "Enable POSIX file locking API" if EMBEDDED
+	bool "Enable POSIX file locking API" if EXPERT
 	default y
 	help
 	  This option enables standard file locking support, required
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 6a00688..15af622 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -1,5 +1,5 @@
 config PROC_FS
-	bool "/proc file system support" if EMBEDDED
+	bool "/proc file system support" if EXPERT
 	default y
 	help
 	  This is a virtual file system providing information about the status
@@ -40,7 +40,7 @@ config PROC_VMCORE
         Exports the dump image of crashed kernel in ELF format.
 
 config PROC_SYSCTL
-	bool "Sysctl support (/proc/sys)" if EMBEDDED
+	bool "Sysctl support (/proc/sys)" if EXPERT
 	depends on PROC_FS
 	select SYSCTL
 	default y
@@ -61,7 +61,7 @@ config PROC_SYSCTL
 config PROC_PAGE_MONITOR
  	default y
 	depends on PROC_FS && MMU
-	bool "Enable /proc page monitoring" if EMBEDDED
+	bool "Enable /proc page monitoring" if EXPERT
  	help
 	  Various /proc files exist to monitor process memory utilization:
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
diff --git a/fs/sysfs/Kconfig b/fs/sysfs/Kconfig
index f4b6758..8c41fea 100644
--- a/fs/sysfs/Kconfig
+++ b/fs/sysfs/Kconfig
@@ -1,5 +1,5 @@
 config SYSFS
-	bool "sysfs file system support" if EMBEDDED
+	bool "sysfs file system support" if EXPERT
 	default y
 	help
 	The sysfs filesystem is a virtual filesystem that the kernel uses to
diff --git a/init/Kconfig b/init/Kconfig
index 4e33790..be788c0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -745,8 +745,8 @@ config DEBUG_BLK_CGROUP
 endif # CGROUPS
 
 menuconfig NAMESPACES
-	bool "Namespaces support" if EMBEDDED
-	default !EMBEDDED
+	bool "Namespaces support" if EXPERT
+	default !EXPERT
 	help
 	  Provides the way to make tasks work with different objects using
 	  the same id. For example same IPC id may refer to different objects
@@ -899,23 +899,31 @@ config SYSCTL
 config ANON_INODES
 	bool
 
-menuconfig EMBEDDED
-	bool "Configure standard kernel features (for small systems)"
+menuconfig EXPERT
+	bool "Configure standard kernel features (expert users)"
 	help
 	  This option allows certain base kernel options and settings
           to be disabled or tweaked. This is for specialized
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+config EMBEDDED
+	bool "Embedded system"
+	select EXPERT
+	help
+	  This option should be enabled if compiling the kernel for
+	  an embedded system so certain expert options are available
+	  for configuration.
+
 config UID16
-	bool "Enable 16-bit UID system calls" if EMBEDDED
+	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
 config SYSCTL_SYSCALL
-	bool "Sysctl syscall support" if EMBEDDED
+	bool "Sysctl syscall support" if EXPERT
 	depends on PROC_SYSCTL
 	default y
 	select SYSCTL
@@ -932,7 +940,7 @@ config SYSCTL_SYSCALL
 	  If unsure say Y here.
 
 config KALLSYMS
-	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
+	 bool "Load all symbols for debugging/ksymoops" if EXPERT
 	 default y
 	 help
 	   Say Y here to let the kernel print out symbolic crash information and
@@ -963,7 +971,7 @@ config KALLSYMS_EXTRA_PASS
 
 
 config HOTPLUG
-	bool "Support for hot-pluggable devices" if EMBEDDED
+	bool "Support for hot-pluggable devices" if EXPERT
 	default y
 	help
 	  This option is provided for the case where no hotplug or uevent
@@ -973,7 +981,7 @@ config HOTPLUG
 
 config PRINTK
 	default y
-	bool "Enable support for printk" if EMBEDDED
+	bool "Enable support for printk" if EXPERT
 	help
 	  This option enables normal printk support. Removing it
 	  eliminates most of the message strings from the kernel image
@@ -982,7 +990,7 @@ config PRINTK
 	  strongly discouraged.
 
 config BUG
-	bool "BUG() support" if EMBEDDED
+	bool "BUG() support" if EXPERT
 	default y
 	help
           Disabling this option eliminates support for BUG and WARN, reducing
@@ -993,12 +1001,12 @@ config BUG
 
 config ELF_CORE
 	default y
-	bool "Enable ELF core dumps" if EMBEDDED
+	bool "Enable ELF core dumps" if EXPERT
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
 config PCSPKR_PLATFORM
-	bool "Enable PC-Speaker support" if EMBEDDED
+	bool "Enable PC-Speaker support" if EXPERT
 	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
 	default y
 	help
@@ -1007,14 +1015,14 @@ config PCSPKR_PLATFORM
 
 config BASE_FULL
 	default y
-	bool "Enable full-sized data structures for core" if EMBEDDED
+	bool "Enable full-sized data structures for core" if EXPERT
 	help
 	  Disabling this option reduces the size of miscellaneous core
 	  kernel data structures. This saves memory on small machines,
 	  but may reduce performance.
 
 config FUTEX
-	bool "Enable futex support" if EMBEDDED
+	bool "Enable futex support" if EXPERT
 	default y
 	select RT_MUTEXES
 	help
@@ -1023,7 +1031,7 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config EPOLL
-	bool "Enable eventpoll support" if EMBEDDED
+	bool "Enable eventpoll support" if EXPERT
 	default y
 	select ANON_INODES
 	help
@@ -1031,7 +1039,7 @@ config EPOLL
 	  support for epoll family of system calls.
 
 config SIGNALFD
-	bool "Enable signalfd() system call" if EMBEDDED
+	bool "Enable signalfd() system call" if EXPERT
 	select ANON_INODES
 	default y
 	help
@@ -1041,7 +1049,7 @@ config SIGNALFD
 	  If unsure, say Y.
 
 config TIMERFD
-	bool "Enable timerfd() system call" if EMBEDDED
+	bool "Enable timerfd() system call" if EXPERT
 	select ANON_INODES
 	default y
 	help
@@ -1051,7 +1059,7 @@ config TIMERFD
 	  If unsure, say Y.
 
 config EVENTFD
-	bool "Enable eventfd() system call" if EMBEDDED
+	bool "Enable eventfd() system call" if EXPERT
 	select ANON_INODES
 	default y
 	help
@@ -1061,7 +1069,7 @@ config EVENTFD
 	  If unsure, say Y.
 
 config SHMEM
-	bool "Use full shmem filesystem" if EMBEDDED
+	bool "Use full shmem filesystem" if EXPERT
 	default y
 	depends on MMU
 	help
@@ -1072,7 +1080,7 @@ config SHMEM
 	  which may be appropriate on small systems without swap.
 
 config AIO
-	bool "Enable AIO support" if EMBEDDED
+	bool "Enable AIO support" if EXPERT
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
@@ -1149,16 +1157,16 @@ endmenu
 
 config VM_EVENT_COUNTERS
 	default y
-	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
+	bool "Enable VM event counters for /proc/vmstat" if EXPERT
 	help
 	  VM event counters are needed for event counts to be shown.
 	  This option allows the disabling of the VM event counters
-	  on EMBEDDED systems.  /proc/vmstat will only show page counts
+	  on EXPERT systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.
 
 config PCI_QUIRKS
 	default y
-	bool "Enable PCI quirk workarounds" if EMBEDDED
+	bool "Enable PCI quirk workarounds" if EXPERT
 	depends on PCI
 	help
 	  This enables workarounds for various PCI chipset
@@ -1167,7 +1175,7 @@ config PCI_QUIRKS
 
 config SLUB_DEBUG
 	default y
-	bool "Enable SLUB debugging support" if EMBEDDED
+	bool "Enable SLUB debugging support" if EXPERT
 	depends on SLUB && SYSFS
 	help
 	  SLUB has extensive debug support features. Disabling these can
@@ -1211,7 +1219,7 @@ config SLUB
 	   a slab allocator.
 
 config SLOB
-	depends on EMBEDDED
+	depends on EXPERT
 	bool "SLOB (Simple Allocator)"
 	help
 	   SLOB replaces the stock allocator with a drastically simpler
@@ -1222,7 +1230,7 @@ endchoice
 
 config MMAP_ALLOW_UNINITIALIZED
 	bool "Allow mmapped anonymous memory to be uninitialized"
-	depends on EMBEDDED && !MMU
+	depends on EXPERT && !MMU
 	default n
 	help
 	  Normally, and according to the Linux spec, anonymous memory obtained
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d05adb..3967c23 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -657,7 +657,7 @@ config DEBUG_HIGHMEM
 	  Disable for production systems.
 
 config DEBUG_BUGVERBOSE
-	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
+	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
@@ -729,8 +729,8 @@ config DEBUG_WRITECOUNT
 	  If unsure, say N.
 
 config DEBUG_MEMORY_INIT
-	bool "Debug memory initialisation" if EMBEDDED
-	default !EMBEDDED
+	bool "Debug memory initialisation" if EXPERT
+	default !EXPERT
 	help
 	  Enable this for additional checks during memory initialisation.
 	  The sanity checks verify aspects of the VM such as the memory model
diff --git a/lib/xz/Kconfig b/lib/xz/Kconfig
index e3b6e18..60a6088 100644
--- a/lib/xz/Kconfig
+++ b/lib/xz/Kconfig
@@ -7,37 +7,37 @@ config XZ_DEC
 	  CRC32 is supported. See Documentation/xz.txt for more information.
 
 config XZ_DEC_X86
-	bool "x86 BCJ filter decoder" if EMBEDDED
+	bool "x86 BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder" if EMBEDDED
+	bool "PowerPC BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder" if EMBEDDED
+	bool "IA-64 BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder" if EMBEDDED
+	bool "ARM BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder" if EMBEDDED
+	bool "ARM-Thumb BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder" if EMBEDDED
+	bool "SPARC BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 9109262..c766056 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -20,7 +20,7 @@ config MAC80211_HAS_RC
 	def_bool n
 
 config MAC80211_RC_PID
-	bool "PID controller based rate control algorithm" if EMBEDDED
+	bool "PID controller based rate control algorithm" if EXPERT
 	select MAC80211_HAS_RC
 	---help---
 	  This option enables a TX rate control algorithm for
@@ -28,14 +28,14 @@ config MAC80211_RC_PID
 	  rate.
 
 config MAC80211_RC_MINSTREL
-	bool "Minstrel" if EMBEDDED
+	bool "Minstrel" if EXPERT
 	select MAC80211_HAS_RC
 	default y
 	---help---
 	  This option enables the 'minstrel' TX rate control algorithm
 
 config MAC80211_RC_MINSTREL_HT
-	bool "Minstrel 802.11n support" if EMBEDDED
+	bool "Minstrel 802.11n support" if EXPERT
 	depends on MAC80211_RC_MINSTREL
 	default y
 	---help---
diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index eaf7658..7fce6df 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -18,7 +18,7 @@ config RFKILL_LEDS
 	default y
 
 config RFKILL_INPUT
-	bool "RF switch input support" if EMBEDDED
+	bool "RF switch input support" if EXPERT
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
-	default y if !EMBEDDED
+	default y if !EXPERT
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index d0ee290..1f1ef70 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -95,7 +95,7 @@ config CFG80211_DEBUGFS
 	  If unsure, say N.
 
 config CFG80211_INTERNAL_REGDB
-	bool "use statically compiled regulatory rules database" if EMBEDDED
+	bool "use statically compiled regulatory rules database" if EXPERT
 	default n
 	depends on CFG80211
 	---help---
diff --git a/usr/Kconfig b/usr/Kconfig
index 4780dea..65b845b 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -46,7 +46,7 @@ config INITRAMFS_ROOT_GID
 	  If you are not sure, leave it set to "0".
 
 config RD_GZIP
-	bool "Support initial ramdisks compressed using gzip" if EMBEDDED
+	bool "Support initial ramdisks compressed using gzip" if EXPERT
 	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_GZIP
@@ -55,8 +55,8 @@ config RD_GZIP
 	  If unsure, say Y.
 
 config RD_BZIP2
-	bool "Support initial ramdisks compressed using bzip2" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using bzip2" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_BZIP2
 	help
@@ -64,8 +64,8 @@ config RD_BZIP2
 	  If unsure, say N.
 
 config RD_LZMA
-	bool "Support initial ramdisks compressed using LZMA" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using LZMA" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZMA
 	help
@@ -73,8 +73,8 @@ config RD_LZMA
 	  If unsure, say N.
 
 config RD_XZ
-	bool "Support initial ramdisks compressed using XZ" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using XZ" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_XZ
 	help
@@ -82,8 +82,8 @@ config RD_XZ
 	  If unsure, say N.
 
 config RD_LZO
-	bool "Support initial ramdisks compressed using LZO" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using LZO" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZO
 	help
