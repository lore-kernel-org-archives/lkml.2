Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab1KRM5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:57:04 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60250 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1KRM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:57:00 -0500
Subject: [GIT PULL] [TRIVIAL] defconfig cleanup
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 13:56:42 +0100
Message-ID: <1321621002.20271.354.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

0) I've decided to send you the trivial but rather large defconfig
cleanup as a pull request. Please let me know whether or not this works
for you.

1) I've only cleaned up entirely unused macros. The following macros do
not have a valid matching Kconfig symbol but are still used
(incorrectly) in the tree and/or (as a Kconfig symbol) in the Kconfig
files:
    CONFIG_CPU_FREQ_DEBUG
    CONFIG_FEC2
    CONFIG_KMOD
    CONFIG_NET_ETHERNET
    CONFIG_SERIAL167
    CONFIG_TOUCHSCREEN_AD7160
    CONFIG_USB_GADGET_PXA27X
    CONFIG_USB_MUSB_PERIPHERAL

Some of these have already been corrected by various maintainers. I hope
to recheck later, perhaps in the next release cycle, what is still
unused.

2) This is, of course, horrible to review. Perhaps these command might
help to determine if I've messed things up:
    a) $ for config in $(git diff HEAD^ | grep "^-[^-]" | sed -e "s/^.*
\(\bCONFIG_\w\+\b\).*$/\1/" | sort -u); do git grep -n -w $config; done

should give:
    arch/um/Kconfig.net:38:        CONFIG_NETLINK_DEV configured as Y or
M.

Ie, just some Kconfig help text. And:
    b) $ for config in $(git diff HEAD^ | grep "^-[^-]" | sed -e "s/^.*
\bCONFIG_\(\w\+\b\).*$/\1/" | sort -u); do git grep -n -w $config $(git
ls-files "*Kconfig*"); done

should give:
    drivers/media/Kconfig:9:          If you want to use Video for
Linux, DVB for Linux, or DAB adapters,
    drivers/media/Kconfig:9:          If you want to use Video for
Linux, DVB for Linux, or DAB adapters,
    drivers/media/Kconfig:66:# DVB Core
    [...]

Ie, lots of Kconfig help text, prompt strings, comments, etc.

(Outside the current trivial tree it will also give
    drivers/mtd/nand/Kconfig:423:   select MTD_PARTITIONS

but you already have afcaed05bc ("mtd: drop select of MTD_PARTITIONS")).

3) I can also send you a script I used to list unused macros in
defconfig files. But perhaps you'd rather not use my script (and risk
making the same mistakes I might have made).


Paul Bolle
---
The following changes since commit 15bd1cfb3055d866614cdaf38e43201936264e50:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block (2011-11-18 09:34:35 -0200)

are available in the git repository at:

  git://github.com/pebolle/linux.git for-trivial

Paul Bolle (1):
      Drop all unused macros from defconfigs

 arch/alpha/defconfig                               |    2 -
 arch/arm/configs/acs5k_defconfig                   |    5 --
 arch/arm/configs/acs5k_tiny_defconfig              |    5 --
 arch/arm/configs/afeb9260_defconfig                |    4 --
 arch/arm/configs/ag5evm_defconfig                  |    3 -
 arch/arm/configs/am200epdkit_defconfig             |    3 -
 arch/arm/configs/ap4evb_defconfig                  |    4 --
 arch/arm/configs/assabet_defconfig                 |    2 -
 arch/arm/configs/at91cap9adk_defconfig             |    4 --
 arch/arm/configs/at91rm9200_defconfig              |    6 --
 arch/arm/configs/at91sam9260ek_defconfig           |    1 -
 arch/arm/configs/at91sam9261_defconfig             |    3 -
 arch/arm/configs/at91sam9263_defconfig             |    3 -
 arch/arm/configs/at91sam9g20ek_defconfig           |    5 --
 arch/arm/configs/at91sam9g45_defconfig             |    3 -
 arch/arm/configs/at91sam9rlek_defconfig            |    3 -
 arch/arm/configs/at91x40_defconfig                 |    1 -
 arch/arm/configs/badge4_defconfig                  |    4 --
 arch/arm/configs/bcmring_defconfig                 |    4 --
 arch/arm/configs/cam60_defconfig                   |    7 ---
 arch/arm/configs/cerfcube_defconfig                |    4 --
 arch/arm/configs/cm_x2xx_defconfig                 |    8 ---
 arch/arm/configs/cm_x300_defconfig                 |    4 --
 arch/arm/configs/cns3420vb_defconfig               |    3 -
 arch/arm/configs/colibri_pxa270_defconfig          |    8 ---
 arch/arm/configs/colibri_pxa300_defconfig          |    5 --
 arch/arm/configs/collie_defconfig                  |    3 -
 arch/arm/configs/corgi_defconfig                   |    8 ---
 arch/arm/configs/cpu9260_defconfig                 |    5 --
 arch/arm/configs/cpu9g20_defconfig                 |    5 --
 arch/arm/configs/da8xx_omapl_defconfig             |    6 --
 arch/arm/configs/davinci_all_defconfig             |    7 ---
 arch/arm/configs/dove_defconfig                    |    3 -
 arch/arm/configs/ebsa110_defconfig                 |    1 -
 arch/arm/configs/em_x270_defconfig                 |    7 ---
 arch/arm/configs/ep93xx_defconfig                  |    5 --
 arch/arm/configs/eseries_pxa_defconfig             |    5 --
 arch/arm/configs/exynos4_defconfig                 |    1 -
 arch/arm/configs/ezx_defconfig                     |    8 ---
 arch/arm/configs/footbridge_defconfig              |    1 -
 arch/arm/configs/g3evm_defconfig                   |    4 --
 arch/arm/configs/g4evm_defconfig                   |    4 --
 arch/arm/configs/h3600_defconfig                   |    6 --
 arch/arm/configs/h5000_defconfig                   |    2 -
 arch/arm/configs/h7201_defconfig                   |    2 -
 arch/arm/configs/h7202_defconfig                   |    1 -
 arch/arm/configs/hackkit_defconfig                 |    3 -
 arch/arm/configs/imote2_defconfig                  |    8 ---
 arch/arm/configs/imx_v4_v5_defconfig               |    2 -
 arch/arm/configs/integrator_defconfig              |    1 -
 arch/arm/configs/iop13xx_defconfig                 |    3 -
 arch/arm/configs/iop32x_defconfig                  |    3 -
 arch/arm/configs/iop33x_defconfig                  |    3 -
 arch/arm/configs/ixp2000_defconfig                 |    4 --
 arch/arm/configs/ixp23xx_defconfig                 |    4 --
 arch/arm/configs/ixp4xx_defconfig                  |    4 --
 arch/arm/configs/jornada720_defconfig              |    6 --
 arch/arm/configs/kirkwood_defconfig                |    6 --
 arch/arm/configs/ks8695_defconfig                  |    4 --
 arch/arm/configs/lart_defconfig                    |    3 -
 arch/arm/configs/lpd270_defconfig                  |    3 -
 arch/arm/configs/lubbock_defconfig                 |    3 -
 arch/arm/configs/mackerel_defconfig                |    6 --
 arch/arm/configs/magician_defconfig                |    6 --
 arch/arm/configs/mainstone_defconfig               |    2 -
 arch/arm/configs/mini2440_defconfig                |    9 ----
 arch/arm/configs/mmp2_defconfig                    |    5 --
 arch/arm/configs/msm_defconfig                     |    3 -
 arch/arm/configs/mv78xx0_defconfig                 |    6 --
 arch/arm/configs/mx3_defconfig                     |    2 -
 arch/arm/configs/mx5_defconfig                     |    2 -
 arch/arm/configs/mxs_defconfig                     |    4 --
 arch/arm/configs/neponset_defconfig                |    5 --
 arch/arm/configs/netwinder_defconfig               |    3 -
 arch/arm/configs/netx_defconfig                    |    3 -
 arch/arm/configs/nhk8815_defconfig                 |    3 -
 arch/arm/configs/nuc910_defconfig                  |    4 --
 arch/arm/configs/nuc950_defconfig                  |    4 --
 arch/arm/configs/nuc960_defconfig                  |    4 --
 arch/arm/configs/omap1_defconfig                   |    5 --
 arch/arm/configs/omap2plus_defconfig               |    4 --
 arch/arm/configs/orion5x_defconfig                 |    6 --
 arch/arm/configs/pcm027_defconfig                  |    3 -
 arch/arm/configs/pcontrol_g20_defconfig            |    6 --
 arch/arm/configs/pleb_defconfig                    |    1 -
 arch/arm/configs/pnx4008_defconfig                 |    7 ---
 arch/arm/configs/pxa168_defconfig                  |    5 --
 arch/arm/configs/pxa255-idp_defconfig              |    2 -
 arch/arm/configs/pxa3xx_defconfig                  |    6 --
 arch/arm/configs/pxa910_defconfig                  |    5 --
 arch/arm/configs/qil-a9260_defconfig               |    2 -
 arch/arm/configs/raumfeld_defconfig                |    7 ---
 arch/arm/configs/realview-smp_defconfig            |    6 --
 arch/arm/configs/realview_defconfig                |    6 --
 arch/arm/configs/rpc_defconfig                     |    4 --
 arch/arm/configs/s3c2410_defconfig                 |   13 -----
 arch/arm/configs/s3c6400_defconfig                 |    6 --
 arch/arm/configs/s5p64x0_defconfig                 |    4 --
 arch/arm/configs/s5pc100_defconfig                 |    4 --
 arch/arm/configs/s5pv210_defconfig                 |    4 --
 arch/arm/configs/sam9_l9260_defconfig              |    4 --
 arch/arm/configs/shannon_defconfig                 |    2 -
 arch/arm/configs/shark_defconfig                   |    2 -
 arch/arm/configs/simpad_defconfig                  |    7 ---
 arch/arm/configs/spear3xx_defconfig                |    2 -
 arch/arm/configs/spear6xx_defconfig                |    2 -
 arch/arm/configs/spitz_defconfig                   |    9 ----
 arch/arm/configs/stamp9g20_defconfig               |    6 --
 arch/arm/configs/tct_hammer_defconfig              |    4 --
 arch/arm/configs/tegra_defconfig                   |    1 -
 arch/arm/configs/trizeps4_defconfig                |    5 --
 arch/arm/configs/u300_defconfig                    |    2 -
 arch/arm/configs/u8500_defconfig                   |    2 -
 arch/arm/configs/usb-a9260_defconfig               |    2 -
 arch/arm/configs/versatile_defconfig               |    2 -
 arch/arm/configs/vexpress_defconfig                |    7 ---
 arch/arm/configs/viper_defconfig                   |    5 --
 arch/arm/configs/xcep_defconfig                    |    4 --
 arch/arm/configs/zeus_defconfig                    |    5 --
 arch/avr32/configs/atngw100_defconfig              |    3 -
 arch/avr32/configs/atngw100_evklcd100_defconfig    |    3 -
 arch/avr32/configs/atngw100_evklcd101_defconfig    |    3 -
 arch/avr32/configs/atngw100_mrmt_defconfig         |    6 --
 arch/avr32/configs/atngw100mkii_defconfig          |    3 -
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |    3 -
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |    3 -
 arch/avr32/configs/atstk1002_defconfig             |    3 -
 arch/avr32/configs/atstk1003_defconfig             |    3 -
 arch/avr32/configs/atstk1004_defconfig             |    3 -
 arch/avr32/configs/atstk1006_defconfig             |    3 -
 arch/avr32/configs/favr-32_defconfig               |    3 -
 arch/avr32/configs/hammerhead_defconfig            |    4 --
 arch/avr32/configs/merisc_defconfig                |    5 --
 arch/avr32/configs/mimc200_defconfig               |    3 -
 arch/blackfin/configs/BF518F-EZBRD_defconfig       |    5 --
 arch/blackfin/configs/BF526-EZBRD_defconfig        |    5 --
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig  |    2 -
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig     |    5 --
 arch/blackfin/configs/BF527-EZKIT_defconfig        |    5 --
 arch/blackfin/configs/BF527-TLL6527M_defconfig     |    8 ---
 arch/blackfin/configs/BF533-EZKIT_defconfig        |    5 --
 arch/blackfin/configs/BF533-STAMP_defconfig        |    4 --
 arch/blackfin/configs/BF537-STAMP_defconfig        |    5 --
 arch/blackfin/configs/BF538-EZKIT_defconfig        |    5 --
 arch/blackfin/configs/BF548-EZKIT_defconfig        |    2 -
 arch/blackfin/configs/BF561-ACVILON_defconfig      |    4 --
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig    |    5 --
 arch/blackfin/configs/BF561-EZKIT_defconfig        |    5 --
 arch/blackfin/configs/BlackStamp_defconfig         |    4 --
 arch/blackfin/configs/CM-BF527_defconfig           |    4 --
 arch/blackfin/configs/CM-BF533_defconfig           |    4 --
 arch/blackfin/configs/CM-BF537E_defconfig          |    3 -
 arch/blackfin/configs/CM-BF537U_defconfig          |    3 -
 arch/blackfin/configs/CM-BF548_defconfig           |    4 --
 arch/blackfin/configs/CM-BF561_defconfig           |    4 --
 arch/blackfin/configs/DNP5370_defconfig            |    7 ---
 arch/blackfin/configs/H8606_defconfig              |    3 -
 arch/blackfin/configs/IP0X_defconfig               |    3 -
 arch/blackfin/configs/PNAV-10_defconfig            |    5 --
 arch/blackfin/configs/SRV1_defconfig               |    4 --
 arch/blackfin/configs/TCM-BF518_defconfig          |    4 --
 arch/blackfin/configs/TCM-BF537_defconfig          |    3 -
 arch/frv/defconfig                                 |    1 -
 arch/h8300/defconfig                               |    1 -
 arch/hexagon/configs/comet_defconfig               |    2 -
 arch/ia64/configs/bigsur_defconfig                 |    2 -
 arch/ia64/configs/generic_defconfig                |    5 --
 arch/ia64/configs/gensparse_defconfig              |    4 --
 arch/ia64/configs/tiger_defconfig                  |    4 --
 arch/ia64/configs/xen_domu_defconfig               |    5 --
 arch/ia64/configs/zx1_defconfig                    |    2 -
 arch/m32r/configs/m32104ut_defconfig               |    1 -
 arch/m32r/configs/m32700ut.smp_defconfig           |    1 -
 arch/m32r/configs/m32700ut.up_defconfig            |    1 -
 arch/m32r/configs/mappi.smp_defconfig              |    1 -
 arch/m32r/configs/mappi.up_defconfig               |    1 -
 arch/m32r/configs/mappi3.smp_defconfig             |    1 -
 arch/m32r/configs/usrv_defconfig                   |    4 --
 arch/m68k/configs/amiga_defconfig                  |    8 ---
 arch/m68k/configs/apollo_defconfig                 |    8 ---
 arch/m68k/configs/atari_defconfig                  |    9 ----
 arch/m68k/configs/bvme6000_defconfig               |    8 ---
 arch/m68k/configs/hp300_defconfig                  |    8 ---
 arch/m68k/configs/m5208evb_defconfig               |    6 --
 arch/m68k/configs/m5249evb_defconfig               |    5 --
 arch/m68k/configs/m5272c3_defconfig                |    4 --
 arch/m68k/configs/m5275evb_defconfig               |    5 --
 arch/m68k/configs/m5307c3_defconfig                |    5 --
 arch/m68k/configs/m5407c3_defconfig                |    4 --
 arch/m68k/configs/mac_defconfig                    |    8 ---
 arch/m68k/configs/multi_defconfig                  |    9 ----
 arch/m68k/configs/mvme147_defconfig                |    8 ---
 arch/m68k/configs/mvme16x_defconfig                |    8 ---
 arch/m68k/configs/q40_defconfig                    |    8 ---
 arch/m68k/configs/sun3_defconfig                   |    8 ---
 arch/m68k/configs/sun3x_defconfig                  |    8 ---
 arch/microblaze/configs/mmu_defconfig              |    2 -
 arch/microblaze/configs/nommu_defconfig            |    4 --
 arch/mips/configs/ar7_defconfig                    |    3 -
 arch/mips/configs/bcm47xx_defconfig                |    9 ----
 arch/mips/configs/bcm63xx_defconfig                |    3 -
 arch/mips/configs/bigsur_defconfig                 |    3 -
 arch/mips/configs/capcella_defconfig               |    3 -
 arch/mips/configs/cavium-octeon_defconfig          |    4 --
 arch/mips/configs/cobalt_defconfig                 |    3 -
 arch/mips/configs/db1000_defconfig                 |    3 -
 arch/mips/configs/db1100_defconfig                 |    3 -
 arch/mips/configs/db1200_defconfig                 |    3 -
 arch/mips/configs/db1500_defconfig                 |    4 --
 arch/mips/configs/db1550_defconfig                 |    3 -
 arch/mips/configs/fuloong2e_defconfig              |    8 ---
 arch/mips/configs/gpr_defconfig                    |    5 --
 arch/mips/configs/ip22_defconfig                   |    7 ---
 arch/mips/configs/ip27_defconfig                   |    5 --
 arch/mips/configs/ip28_defconfig                   |    2 -
 arch/mips/configs/ip32_defconfig                   |    5 --
 arch/mips/configs/jazz_defconfig                   |    6 --
 arch/mips/configs/jmr3927_defconfig                |    5 --
 arch/mips/configs/lasat_defconfig                  |    4 --
 arch/mips/configs/lemote2f_defconfig               |    7 ---
 arch/mips/configs/malta_defconfig                  |    5 --
 arch/mips/configs/markeins_defconfig               |    5 --
 arch/mips/configs/mipssim_defconfig                |    2 -
 arch/mips/configs/mpc30x_defconfig                 |    3 -
 arch/mips/configs/mtx1_defconfig                   |    9 ----
 arch/mips/configs/nlm_xlr_defconfig                |    1 -
 arch/mips/configs/pb1100_defconfig                 |    3 -
 arch/mips/configs/pb1200_defconfig                 |    3 -
 arch/mips/configs/pb1500_defconfig                 |    3 -
 arch/mips/configs/pb1550_defconfig                 |    3 -
 arch/mips/configs/pnx8335-stb225_defconfig         |    3 -
 arch/mips/configs/pnx8550-jbs_defconfig            |    1 -
 arch/mips/configs/pnx8550-stb810_defconfig         |    1 -
 arch/mips/configs/powertv_defconfig                |    3 -
 arch/mips/configs/rb532_defconfig                  |    5 --
 arch/mips/configs/rbtx49xx_defconfig               |    5 --
 arch/mips/configs/rm200_defconfig                  |    7 ---
 arch/mips/configs/tb0219_defconfig                 |    2 -
 arch/mips/configs/tb0226_defconfig                 |    4 --
 arch/mips/configs/tb0287_defconfig                 |    9 ----
 arch/mips/configs/workpad_defconfig                |    3 -
 arch/mips/configs/wrppmc_defconfig                 |    2 -
 arch/mn10300/configs/asb2303_defconfig             |    4 --
 arch/mn10300/configs/asb2364_defconfig             |    5 --
 arch/openrisc/configs/or1ksim_defconfig            |    3 -
 arch/parisc/configs/712_defconfig                  |    4 --
 arch/parisc/configs/a500_defconfig                 |    6 --
 arch/parisc/configs/b180_defconfig                 |    2 -
 arch/parisc/configs/c3000_defconfig                |    2 -
 arch/parisc/configs/default_defconfig              |    7 ---
 arch/powerpc/configs/40x/acadia_defconfig          |    6 --
 arch/powerpc/configs/40x/ep405_defconfig           |    4 --
 arch/powerpc/configs/40x/kilauea_defconfig         |    6 --
 arch/powerpc/configs/40x/makalu_defconfig          |    6 --
 arch/powerpc/configs/40x/virtex_defconfig          |    4 --
 arch/powerpc/configs/40x/walnut_defconfig          |    4 --
 arch/powerpc/configs/44x/arches_defconfig          |    5 --
 arch/powerpc/configs/44x/bamboo_defconfig          |    2 -
 arch/powerpc/configs/44x/bluestone_defconfig       |    1 -
 arch/powerpc/configs/44x/canyonlands_defconfig     |    5 --
 arch/powerpc/configs/44x/ebony_defconfig           |    4 --
 arch/powerpc/configs/44x/eiger_defconfig           |    5 --
 arch/powerpc/configs/44x/icon_defconfig            |    5 --
 arch/powerpc/configs/44x/iss476-smp_defconfig      |    3 -
 arch/powerpc/configs/44x/katmai_defconfig          |    3 -
 arch/powerpc/configs/44x/rainier_defconfig         |    3 -
 arch/powerpc/configs/44x/redwood_defconfig         |    5 --
 arch/powerpc/configs/44x/sam440ep_defconfig        |    4 --
 arch/powerpc/configs/44x/sequoia_defconfig         |    3 -
 arch/powerpc/configs/44x/taishan_defconfig         |    3 -
 arch/powerpc/configs/44x/virtex5_defconfig         |    4 --
 arch/powerpc/configs/44x/warp_defconfig            |    6 --
 arch/powerpc/configs/52xx/cm5200_defconfig         |    5 --
 arch/powerpc/configs/52xx/lite5200b_defconfig      |    2 -
 arch/powerpc/configs/52xx/motionpro_defconfig      |    6 --
 arch/powerpc/configs/52xx/pcm030_defconfig         |    4 --
 arch/powerpc/configs/52xx/tqm5200_defconfig        |    4 --
 arch/powerpc/configs/83xx/asp8347_defconfig        |    4 --
 arch/powerpc/configs/83xx/kmeter1_defconfig        |    4 --
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig    |    5 --
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig    |    5 --
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig    |    2 -
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig    |    2 -
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig    |    2 -
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig  |    2 -
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig    |    3 -
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig    |    3 -
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig    |    4 --
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig    |    2 -
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig    |    3 -
 arch/powerpc/configs/83xx/sbc834x_defconfig        |    5 --
 arch/powerpc/configs/85xx/ksi8560_defconfig        |    4 --
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig    |    2 -
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig    |    2 -
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig    |    2 -
 arch/powerpc/configs/85xx/p1023rds_defconfig       |    3 -
 arch/powerpc/configs/85xx/sbc8548_defconfig        |    2 -
 arch/powerpc/configs/85xx/sbc8560_defconfig        |    2 -
 arch/powerpc/configs/85xx/socrates_defconfig       |    5 --
 arch/powerpc/configs/85xx/stx_gp3_defconfig        |    4 --
 arch/powerpc/configs/85xx/tqm8540_defconfig        |    5 --
 arch/powerpc/configs/85xx/tqm8541_defconfig        |    5 --
 arch/powerpc/configs/85xx/tqm8548_defconfig        |    3 -
 arch/powerpc/configs/85xx/tqm8555_defconfig        |    5 --
 arch/powerpc/configs/85xx/tqm8560_defconfig        |    5 --
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig    |    5 --
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |    6 --
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     |    5 --
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |    7 ---
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig   |    5 --
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig   |    3 -
 arch/powerpc/configs/86xx/sbc8641d_defconfig       |    9 ----
 arch/powerpc/configs/adder875_defconfig            |    3 -
 arch/powerpc/configs/amigaone_defconfig            |    6 --
 arch/powerpc/configs/c2k_defconfig                 |    8 ---
 arch/powerpc/configs/cell_defconfig                |    3 -
 arch/powerpc/configs/celleb_defconfig              |    2 -
 arch/powerpc/configs/chrp32_defconfig              |    4 --
 arch/powerpc/configs/ep8248e_defconfig             |    2 -
 arch/powerpc/configs/ep88xc_defconfig              |    3 -
 arch/powerpc/configs/g5_defconfig                  |   10 ----
 arch/powerpc/configs/gamecube_defconfig            |    5 --
 arch/powerpc/configs/holly_defconfig               |    1 -
 arch/powerpc/configs/iseries_defconfig             |    5 --
 arch/powerpc/configs/linkstation_defconfig         |    5 --
 arch/powerpc/configs/maple_defconfig               |    4 --
 arch/powerpc/configs/mgcoge_defconfig              |    2 -
 arch/powerpc/configs/mpc512x_defconfig             |    2 -
 arch/powerpc/configs/mpc5200_defconfig             |    7 ---
 arch/powerpc/configs/mpc7448_hpc2_defconfig        |    3 -
 arch/powerpc/configs/mpc8272_ads_defconfig         |    2 -
 arch/powerpc/configs/mpc83xx_defconfig             |    3 -
 arch/powerpc/configs/mpc866_ads_defconfig          |    2 -
 arch/powerpc/configs/mpc86xx_defconfig             |    3 -
 arch/powerpc/configs/mpc885_ads_defconfig          |    3 -
 arch/powerpc/configs/pasemi_defconfig              |    5 --
 arch/powerpc/configs/pmac32_defconfig              |   11 ----
 arch/powerpc/configs/ppc40x_defconfig              |    4 --
 arch/powerpc/configs/ppc44x_defconfig              |    3 -
 arch/powerpc/configs/ppc64_defconfig               |   12 -----
 arch/powerpc/configs/ppc64e_defconfig              |   11 ----
 arch/powerpc/configs/ppc6xx_defconfig              |   16 ------
 arch/powerpc/configs/pq2fads_defconfig             |    3 -
 arch/powerpc/configs/prpmc2800_defconfig           |    5 --
 arch/powerpc/configs/ps3_defconfig                 |    6 --
 arch/powerpc/configs/pseries_defconfig             |    4 --
 arch/powerpc/configs/storcenter_defconfig          |    4 --
 arch/powerpc/configs/tqm8xx_defconfig              |    5 --
 arch/powerpc/configs/wii_defconfig                 |    5 --
 arch/s390/defconfig                                |    3 -
 arch/score/configs/spct6600_defconfig              |    4 --
 arch/sh/configs/ap325rxa_defconfig                 |    6 --
 arch/sh/configs/apsh4a3a_defconfig                 |    6 --
 arch/sh/configs/apsh4ad0a_defconfig                |    4 --
 arch/sh/configs/cayman_defconfig                   |    1 -
 arch/sh/configs/dreamcast_defconfig                |    4 --
 arch/sh/configs/ecovec24-romimage_defconfig        |    3 -
 arch/sh/configs/ecovec24_defconfig                 |    6 --
 arch/sh/configs/edosk7705_defconfig                |    1 -
 arch/sh/configs/edosk7760_defconfig                |    6 --
 arch/sh/configs/espt_defconfig                     |    5 --
 arch/sh/configs/hp6xx_defconfig                    |    1 -
 arch/sh/configs/kfr2r09-romimage_defconfig         |    1 -
 arch/sh/configs/kfr2r09_defconfig                  |    2 -
 arch/sh/configs/landisk_defconfig                  |    4 --
 arch/sh/configs/lboxre2_defconfig                  |    4 --
 arch/sh/configs/magicpanelr2_defconfig             |    4 --
 arch/sh/configs/microdev_defconfig                 |    1 -
 arch/sh/configs/migor_defconfig                    |    7 ---
 arch/sh/configs/polaris_defconfig                  |    5 --
 arch/sh/configs/r7780mp_defconfig                  |    3 -
 arch/sh/configs/r7785rp_defconfig                  |    1 -
 arch/sh/configs/rsk7201_defconfig                  |    3 -
 arch/sh/configs/rsk7203_defconfig                  |    6 --
 arch/sh/configs/rts7751r2d1_defconfig              |    2 -
 arch/sh/configs/rts7751r2dplus_defconfig           |    4 --
 arch/sh/configs/sdk7780_defconfig                  |    3 -
 arch/sh/configs/sdk7786_defconfig                  |    5 --
 arch/sh/configs/se7206_defconfig                   |    6 --
 arch/sh/configs/se7343_defconfig                   |    5 --
 arch/sh/configs/se7619_defconfig                   |    3 -
 arch/sh/configs/se7705_defconfig                   |    2 -
 arch/sh/configs/se7712_defconfig                   |    3 -
 arch/sh/configs/se7721_defconfig                   |    3 -
 arch/sh/configs/se7722_defconfig                   |    1 -
 arch/sh/configs/se7724_defconfig                   |    6 --
 arch/sh/configs/se7750_defconfig                   |    2 -
 arch/sh/configs/se7751_defconfig                   |    2 -
 arch/sh/configs/se7780_defconfig                   |    5 --
 arch/sh/configs/secureedge5410_defconfig           |    5 --
 arch/sh/configs/sh03_defconfig                     |    3 -
 arch/sh/configs/sh2007_defconfig                   |    4 --
 arch/sh/configs/sh7710voipgw_defconfig             |    2 -
 arch/sh/configs/sh7724_generic_defconfig           |    1 -
 arch/sh/configs/sh7757lcr_defconfig                |    1 -
 arch/sh/configs/sh7763rdp_defconfig                |    5 --
 arch/sh/configs/sh7770_generic_defconfig           |    1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig          |    5 --
 arch/sh/configs/sh7785lcr_defconfig                |    4 --
 arch/sh/configs/shmin_defconfig                    |    2 -
 arch/sh/configs/shx3_defconfig                     |    4 --
 arch/sh/configs/titan_defconfig                    |    5 --
 arch/sh/configs/ul2_defconfig                      |    5 --
 arch/sh/configs/urquell_defconfig                  |    5 --
 arch/sparc/configs/sparc32_defconfig               |    3 -
 arch/sparc/configs/sparc64_defconfig               |    2 -
 arch/tile/configs/tilegx_defconfig                 |   10 ----
 arch/tile/configs/tilepro_defconfig                |    8 ---
 arch/um/defconfig                                  |   28 -----------
 arch/unicore32/configs/unicore32_defconfig         |   12 -----
 arch/x86/configs/i386_defconfig                    |    4 --
 arch/x86/configs/x86_64_defconfig                  |    4 --
 arch/xtensa/configs/common_defconfig               |   49 --------------------
 arch/xtensa/configs/iss_defconfig                  |   10 ----
 arch/xtensa/configs/s6105_defconfig                |   24 ----------
 415 files changed, 0 insertions(+), 1829 deletions(-)


