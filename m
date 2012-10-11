Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2JKWVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:21:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50505 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759483Ab2JKWVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:21:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18H5SN62RcHefr8JMb484+GCkPv3LIb0w2OwXLyA7
	S87Yv2tP+mY4SE
Message-ID: <50774645.8090808@gmx.de>
Date: Thu, 11 Oct 2012 22:20:53 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev updates for 3.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the changes below. Actually there was more stuff but due to
writing my thesis I didn't have time to review it, so the pull request
for the next merge window might be somewhat larger.


Thanks,

Florian Tobias Schandinat


The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git tags/fbdev-updates-for-3.7

for you to fetch changes up to cd9d6f10d07f26dd8a70e519c22b6b4f8a9e3e7a:

  gbefb: fix compile error (2012-10-11 00:23:15 +0000)

----------------------------------------------------------------
fbdev updates for 3.7

It includes:
- large updates for OMAP
  - basic OMAP5 DSS support for DPI and DSI outputs
  - large cleanups and restructuring
- some update to Exynos and da8xx-fb
- removal of the pnx4008 driver (arch removed)
- various other small patches

----------------------------------------------------------------
Alexander Holler (1):
      video/udlfb: fix line counting in fb_write

Archit Taneja (70):
      OMAPDSS: APPLY: Constify timings argument in dss_mgr_set_timings
      OMAPDSS: DPI: Add locking for DPI interface
      OMAPDSS: Displays: Add locking in generic DPI panel driver
      OMAPDSS: DPI: Maintain our own timings field in driver data
      OMAPDSS: DPI displays: Take care of panel timings in the driver itself
      OMAPDSS: DSI: Maintain own copy of timings in driver data
      OMAPDSS: DSI: Add function to set panel size for command mode panels
      OMAPDSS: DSI: Update manager timings on a manual update
      OMAPDSS: HDMI: Use our own omap_video_timings field when setting interface timings
      OMAPDSS: HDMI: Add locking for hdmi interface set timing functions
      OMAPDSS: SDI: Create a function to set timings
      OMAPDSS: SDI: Maintain our own timings field in driver data
      OMAPDSS: VENC: Split VENC into interface and panel driver
      OMAPDSS: VENC: Maintain our own timings field in driver data
      OMAPDSS: RFBI: Remove partial update support
      OMAPDSS: RFBI: Add function to set panel size
      OMAPDSS: DSI: Maintain copy of pixel format in driver data
      OMAPDSS: RFBI: Maintain copy of pixel size in driver data
      OMAPDSS: RFBI: Maintain copy of number of data lines in driver data
      OMAPDSS: DPI: Maintain copy of number of data lines in driver data
      OMAPDSS: SDI: Maintain copy of data pairs in driver data
      OMAPDSS: DSI: Maintain copy of operation mode in driver data
      OMAPDSS: DSI: Rename dsi_videomode_data to dsi_videomode_timings
      OMAPDSS: DSI: Maintain copy of video mode timings in driver data
      OMAPDSS: RFBI: Maitain copy of rfbi timings in driver data
      OMAPDSS: VENC: Maintain copy of venc type in driver data
      OMAPDSS: VENC: Maintian copy of video output polarity info in private data
      OMAPFB: Clear framebuffers before they are registered
      OMAPDSS: Add basic omap5 features to dss and dispc
      OMAPDSS: DSI: Pass dsi platform device wherever possible
      OMAPDSS: APPLY: Remove omap_dss_device references in wait_for_go functions
      OMAPDSS: outputs: Create a new entity called outputs
      OMAPDSS: outputs: Create and register output instances
      OMAPDSS: output: Add set/unset device ops for omap_dss_output
      OMAPDSS: APPLY: Add manager set/unset output ops for omap_overlay_manager
      OMAPDSS: Remove manager->device references
      OMAP_VOUT: Remove manager->device references
      OMAPFB: remove manager->device references
      OMAPDRM: Remove manager->device references
      OMAPDSS: Create links between managers, outputs and devices
      OMAPDSS: DPI: Replace dssdev->manager with dssdev->output->manager references
      OMAPDSS: DSI: Remove dsi_pdev_map global struct
      OMAPDSS: DSI: Replace dssdev->manager with dssdev->output->manager references
      OMAPDSS: SDI: Replace dssdev->manager with dssdev->output->manager references
      OMAPDSS: RFBI: Replace dssdev->manager with dssdev->output->manager references
      OMAPDSS: VENC: Replace dssdev->manager with dssdev->output->manager references
      OMAPDSS: HDMI: Replace dssdev->manager with dssdev->output->manager references
      OMAPFB: Change dssdev->manager references
      OMAPDSS: MANAGER: Update display sysfs store
      OMAPDSS: OVERLAY/MANAGER: Get device via output
      OMAPDSS: APPLY: Remove omap_dss_device references from dss_ovl_enable/disable
      OMAPDSS: Remove old way of setting manager and device links
      OMAPDSS: DISPC: Constify omap_overlay_info in dispc_ovl_setup()
      OMAPDSS: DISPC: Simplify function names for setting pipeline input and output sizes
      OMAPDSS: DISPC: Pass overlay caps as a parameter to dispc plane functions
      OMAPDSS: OVERLAY: Add position and replication as overlay caps
      OMAPDSS: DISPC: Make dispc_ovl_setup call dispc_ovl_setup_common
      OMAPDSS: DISPC: Don't pass channel out when configuring overlays
      OMAPDSS: DIPSC: Relax scaling limitations when in memory to memory mode
      OMAPDSS: DISPC: Allow both upscaling and downscaling of chroma
      OMAPDSS: DISPC: Add writeback register offsets and dss features structs
      OMAPDSS: DISPC: Configure input and output sizes for writeback
      OMAPDSS: DISPC: Downscale chroma if plane is writeback
      OMAPDSS: DISPC: Don't set chroma resampling bit for writeback
      OMAPDSS: DISPC: Add function to set channel in for writeback
      OMAPDSS: DISPC: Configure overlay-like parameters in dispc_wb_setup
      OMAPDSS: DISPC: Configure writeback specific parameters in dispc_wb_setup()
      OMAPDSS: DISPC: Configure writeback FIFOs
      OMAPDSS: DISPC: Add manager like functions for writeback
      OMAPDSS: DISPC: Configure color conversion coefficients for writeback

Arnd Bergmann (1):
      video: mark nuc900fb_map_video_memory as __devinit

Axel Lin (1):
      video: mbxfb: Include linux/io.h instead of asm/io.h

Bjarni Ingi Gislason (1):
      drivers: console: font_: Change a glyph from "broken bar" to "vertical line"

Chandrabhanu Mahapatra (8):
      OMAPDSS: DISPC: Cleanup cpu_is_xxxx checks
      OMAPDSS: DSS: Remove redundant functions
      OMAPDSS: DSS: Cleanup cpu_is_xxxx checks
      ARM: OMAP: Disable venc for OMAP4
      OMAPDSS: VENC: Remove cpu_is_xxxx checks
      OMAPDSS: DPI: Remove cpu_is_xxxx checks
      OMAPDSS: Correct DISPC_IRQ bit definitions for LCD3
      OMAPDSS: DISPC: Add predecimation limit for TILER based rotations

Damien Cassou (11):
      drivers/video/ep93xx-fb.c: use devm_ functions
      drivers/video/cobalt_lcdfb.c: use devm_ functions
      drivers/video/bf537-lq035.c: use devm_ functions
      drivers/video/mbx/mbxfb.c: use devm_ functions
      drivers/video/gbefb.c: use devm_ functions
      drivers/video/fsl-diu-fb.c: use devm_ functions
      video: exynos_dp: use devm_clk_get function
      drivers/video/epson1355fb.c: use devm_ functions
      drivers/video/jz4740_fb.c: use devm_ functions
      drivers/video/bf54x-lq043fb.c: use devm_ functions
      drivers/video/msm/mddi_client_nt35399.c: use devm_ functions

Daniel Drake (1):
      viafb: don't touch clock state on OLPC XO-1.5

Devendra Naga (1):
      video: bfin-lq035q1: use module_platform_driver

Emil Goode (1):
      video: hpfb: Fix error handling

Florian Tobias Schandinat (3):
      Merge branch 'v3.7-for-florian' of git://git.kernel.org/.../kgene/linux-samsung into fbdev-next
      Merge tag 'omapdss-for-3.7' of git://gitorious.org/linux-omap-dss2/linux into fbdev-next
      gbefb: fix compile error

Geert Uytterhoeven (1):
      fbdev/amifb: Remove write-only variable amifb_inverse

Grazvydas Ignotas (1):
      OMAPFB: fix framebuffer console colors

Jassi Brar (1):
      OMAPDSS: DISPC: Use msleep instead of blocking mdelay

Jean Delvare (1):
      video: bf*: Add missing spinlock init

Jingoo Han (10):
      video: exynos_dp: adjust voltage swing and pre-emphasis during Link Training
      video: s3c-fb: use devm_clk_get()
      video: exynos_dp: check time loop for RPLY_RECEIV
      video: exynos_dp: change return type of exynos_dp_init_video to void
      video: exynos_dp: move setting analog parameter and interrupt to after sw reset
      video: exynos_dp: replace link_status with link_align to check channel equalization
      video: s3c2410: fix checkpatch warnings
      video: exynos_dp: add bit-masking for LINK_TRAINING_CTL register
      video: exynos_dp: increase AUX channel voltage level
      video: exynos_dp: use clk_prepare_enable and clk_disable_unprepare

Julia Lawall (1):
      drivers/video/sunxvr2500.c: fix error return code

Lars-Peter Clausen (1):
      fbdev: jz4740: Use devm_request_and_ioremap

Leela Krishna Amudala (2):
      include/video: move fimd register headers from platform to include/video
      include/video: Add register offsets for FIMD version 8

Manjunathappa, Prakash (5):
      da8xx-fb: add 24bpp LCD configuration support
      da8xx-fb: allow frame to complete after disabling LCDC
      da8xx-fb: enable LCDC if FB is unblanked
      da8xx-fb: add pm_runtime support
      da8xx-fb: save and restore LCDC context across suspend/resume cycle

Peter Senna Tschudin (13):
      drivers/video/sis/initextlfb.c: removes unnecessary semicolon
      drivers/video/mb862xx/mb862xxfbdrv.c: fix error return code
      drivers/video/sunxvr1000.c: fix error return code
      drivers/video/cg3.c: fix error return code
      drivers/video/sunxvr500.c: fix error return code
      drivers/video/atmel_lcdfb.c: fix error return code
      drivers/video/imxfb.c: fix error return code
      drivers/video/bw2.c: fix error return code
      drivers/video/cyber2000fb.c: fix error return code
      drivers/video/ps3fb.c: fix error return code
      drivers/video/arcfb.c: fix error return code
      drivers/video/savage/savagefb_driver.c: fix error return code
      drivers/video/exynos/exynos_mipi_dsi.c: fix error return code

Raphaël Assénat (1):
      OMAPDSS: Do not require a VDDS_DSI regulator on AM35xx

Ricardo Neri (2):
      OMAPDSS: HDMI: Disable PLL properly in case of error at power_on
      OMAPDSS: DISPC: Improvements to DIGIT sync signal selection

Roland Stigge (1):
      video: Remove pnx4008 driver

Sachin Kamat (4):
      video: exynos-mipi-dsi: Add missing static storage class specifiers
      video: s3c2410: Use pr_* and dev_* instead of printk
      video: exynos_mipi_dsi: Remove unused code
      video: exynos_mipi_dsi: Remove unnecessary NULL check

Sean Paul (2):
      video: exynos_dp: Change aux transaction failures
      video: exynos_dp: Fix get_pll_lock_status return value

Stephen Boyd (1):
      video: msm: Remove useless mach/* includes

Thomas Abraham (1):
      video: s3c-fb: use clk_prepare_enable and clk_disable_unprepare

Tomi Valkeinen (53):
      Merge output work from Archit
      OMAPDSS: HDMI: fix initial HDMI enable
      Merge tag 'v3.6-rc4'
      OMAPDSS: HDMI: Move GPIO handling to HDMI driver
      OMAPDSS: HDMI: Add delay to wait for 5V power
      OMAP4: TWL: add vdda_hdmi_dac regulator supply
      OMAPDSS: HDMI: use vdda_hdmi_dac
      OMAPDSS: Add DSI fclk maximum to dss_features
      OMAPDSS: DSI: calculate dsi clock
      OMAP: 4430SDP: remove DSI clock config from board file
      OMAPDSS: fix use of dssdev->caps
      OMAPDSS: Taal: use devm_* functions
      OMAPFB1: remove unnecessary includes
      OMAPFB1: remove a non-used table
      OMAPDSS: remove unnecessary includes
      OMAPFB: clear framebuffers with CPU
      OMAPDSS: VRAM: Remove clearing with sDMA
      OMAPDSS: Taal: Reogranize for device tree
      OMAPDSS: TFP410: use devm_gpio_request_one
      OMAPDSS: split overlay sysfs code
      OMAPDSS: split manager sysfs code
      OMAPDSS: clean up dss_mgr_set_lcd_config
      OMAPDSS: clean up dss_mgr_set_timings
      Revert "OMAPDSS: APPLY: add fifo-merge support"
      Revert "OMAPDSS: APPLY: add fifo merge support funcs"
      OMAPDSS: Improve fifo management code
      OMAPDSS: Use WB fifo for GFX overlay
      OMAPDSS: fix set_timings
      OMAPDSS: fix dss_ovl_unset_manager
      Merge miscellaneous omapdss changes
      Merge branch 'fbdev-for-linus' of git://github.com/schandinat/linux-2.6
      OMAPDSS: omap_dss_register_device() doesn't take display index
      OMAPDSS: Add dss_get_default_display_name()
      OMAPDSS: register only one display device per output
      OMAPDSS: explicitely initialize dssdev->channel for new displays
      OMAPDSS: handle errors in dss_init_device
      OMAPDSS: cleanup dss_recheck_connections
      OMAPDSS: cleanup dss_recheck_connections further
      OMAPDSS: alloc dssdevs dynamically
      OMAPDSS: DSI: improve DSI clock calcs for DISPC
      OMAPDSS: move dss feats to the end of dss.c
      OMAPDSS: Add support for DPI source selection
      OMAPDSS: DSI: Add FEAT_DSI_PLL_SELFREQDCO
      OMAPDSS: DSI: Add FEAT_DSI_PLL_REFSEL
      OMAPDSS: DSI: Add new linebuffer size for OMAP5
      OMAPDSS: DSI: Add code to disable PHY DCC
      OMAPDSS: DSI: make OMAP2_DSS_DSI depend on ARCH_OMAP5
      Merge omapdss single-dssdev series
      Merge OMAP5 DSS changes to omapdss
      OMAPDSS: DSI: fix tlpx_half reg field length
      Merge branch 'archit/outputs-for-3.7'
      Merge branch 'archit/wb-dispc-for-3.7'
      OMAPDSS: add missing include for string.h

Uwe Kleine-König (1):
      video/mx3fb: set .owner to prevent module unloading while being used

Wang YanQing (1):
      video:uvesafb: check the return value of kzalloc

Wei Yongjun (1):
      vmlfb: use list_move_tail instead of list_del/list_add_tail

 arch/arm/mach-exynos/mach-nuri.c                   |    2 +-
 arch/arm/mach-exynos/mach-origen.c                 |    2 +-
 arch/arm/mach-exynos/mach-smdk4x12.c               |    2 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |    2 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |    2 +-
 arch/arm/mach-exynos/setup-fimd0.c                 |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   73 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   27 +-
 arch/arm/mach-omap2/display.c                      |    1 -
 arch/arm/mach-omap2/twl-common.c                   |    6 +
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq5.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    2 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |    2 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |    2 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c              |    2 +-
 arch/arm/mach-s5pv210/mach-aquila.c                |    2 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    2 +-
 arch/arm/plat-samsung/include/plat/regs-fb-v4.h    |  159 ---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |    2 +-
 drivers/media/video/omap/omap_vout.c               |   75 +-
 drivers/staging/omapdrm/omap_drv.c                 |    5 +-
 drivers/video/Kconfig                              |   15 -
 drivers/video/Makefile                             |    2 -
 drivers/video/amifb.c                              |    2 -
 drivers/video/arcfb.c                              |    1 +
 drivers/video/atmel_lcdfb.c                        |    5 +-
 drivers/video/auo_k190x.c                          |    2 -
 drivers/video/bf537-lq035.c                        |   12 +-
 drivers/video/bf54x-lq043fb.c                      |    9 +-
 drivers/video/bfin-lq035q1-fb.c                    |   13 +-
 drivers/video/bfin-t350mcqb-fb.c                   |    1 +
 drivers/video/bw2.c                                |    4 +-
 drivers/video/cg3.c                                |    3 +-
 drivers/video/cobalt_lcdfb.c                       |    5 +-
 drivers/video/console/bitblit.c                    |    2 +-
 drivers/video/console/fbcon.c                      |    2 +-
 drivers/video/console/font_mini_4x6.c              |    2 +-
 drivers/video/console/font_sun8x16.c               |    2 +-
 drivers/video/cyber2000fb.c                        |    4 +-
 drivers/video/da8xx-fb.c                           |  283 ++++--
 drivers/video/ep93xx-fb.c                          |   17 +-
 drivers/video/epson1355fb.c                        |   16 +-
 drivers/video/exynos/exynos_dp_core.c              |  322 +++----
 drivers/video/exynos/exynos_dp_core.h              |    6 +-
 drivers/video/exynos/exynos_dp_reg.c               |   58 +-
 drivers/video/exynos/exynos_dp_reg.h               |    3 +-
 drivers/video/exynos/exynos_mipi_dsi.c             |    9 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c      |    8 -
 drivers/video/fsl-diu-fb.c                         |   10 +-
 drivers/video/gbefb.c                              |   17 +-
 drivers/video/hpfb.c                               |   28 +-
 drivers/video/imxfb.c                              |    1 +
 drivers/video/jz4740_fb.c                          |   44 +-
 drivers/video/mb862xx/mb862xxfbdrv.c               |   12 +-
 drivers/video/mbx/mbxfb.c                          |   25 +-
 drivers/video/msm/mddi.c                           |    3 -
 drivers/video/msm/mddi_client_nt35399.c            |    6 +-
 drivers/video/msm/mdp.c                            |    1 -
 drivers/video/msm/mdp_hw.h                         |    1 -
 drivers/video/mx3fb.c                              |    3 +-
 drivers/video/nuc900fb.c                           |    2 +-
 drivers/video/omap/hwa742.c                        |    1 -
 drivers/video/omap/lcd_ams_delta.c                 |    1 -
 drivers/video/omap/lcd_palmte.c                    |    1 -
 drivers/video/omap/omapfb_main.c                   |    9 -
 drivers/video/omap2/displays/panel-acx565akm.c     |   14 +-
 drivers/video/omap2/displays/panel-generic-dpi.c   |   76 +-
 .../omap2/displays/panel-lgphilips-lb035q02.c      |    3 +
 drivers/video/omap2/displays/panel-n8x0.c          |   31 +-
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |    3 +
 drivers/video/omap2/displays/panel-picodlp.c       |    4 +
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |    3 +
 drivers/video/omap2/displays/panel-taal.c          |  239 ++---
 drivers/video/omap2/displays/panel-tfp410.c        |   20 +-
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |    7 +-
 drivers/video/omap2/dss/Kconfig                    |    2 +-
 drivers/video/omap2/dss/Makefile                   |    4 +-
 drivers/video/omap2/dss/apply.c                    |  330 ++-----
 drivers/video/omap2/dss/core.c                     |   91 +-
 drivers/video/omap2/dss/dispc.c                    | 1019 ++++++++++++++------
 drivers/video/omap2/dss/dispc.h                    |   37 +
 drivers/video/omap2/dss/display.c                  |  108 ++-
 drivers/video/omap2/dss/dpi.c                      |  181 +++-
 drivers/video/omap2/dss/dsi.c                      |  675 ++++++++++---
 drivers/video/omap2/dss/dss.c                      |  257 +++--
 drivers/video/omap2/dss/dss.h                      |   79 +-
 drivers/video/omap2/dss/dss_features.c             |  278 +++++-
 drivers/video/omap2/dss/dss_features.h             |    7 +
 drivers/video/omap2/dss/hdmi.c                     |  247 +++--
 drivers/video/omap2/dss/hdmi_panel.c               |   31 +-
 drivers/video/omap2/dss/manager-sysfs.c            |  512 ++++++++++
 drivers/video/omap2/dss/manager.c                  |  473 +--------
 drivers/video/omap2/dss/output.c                   |  148 +++
 drivers/video/omap2/dss/overlay-sysfs.c            |  456 +++++++++
 drivers/video/omap2/dss/overlay.c                  |  492 +---------
 drivers/video/omap2/dss/rfbi.c                     |  222 +++--
 drivers/video/omap2/dss/sdi.c                      |  136 ++-
 drivers/video/omap2/dss/venc.c                     |  337 +++----
 drivers/video/omap2/dss/venc_panel.c               |  251 +++++
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |    7 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |   34 +-
 drivers/video/omap2/omapfb/omapfb.h                |    5 +-
 drivers/video/omap2/vram.c                         |   56 --
 drivers/video/pnx4008/Makefile                     |    7 -
 drivers/video/pnx4008/dum.h                        |  211 ----
 drivers/video/pnx4008/fbcommon.h                   |   43 -
 drivers/video/pnx4008/pnxrgbfb.c                   |  198 ----
 drivers/video/pnx4008/sdum.c                       |  861 -----------------
 drivers/video/pnx4008/sdum.h                       |  136 ---
 drivers/video/ps3fb.c                              |    7 +-
 drivers/video/s3c-fb.c                             |   54 +-
 drivers/video/s3c2410fb.c                          |   34 +-
 drivers/video/savage/savagefb_driver.c             |    4 +-
 drivers/video/sis/initextlfb.c                     |    2 +-
 drivers/video/sunxvr1000.c                         |    4 +-
 drivers/video/sunxvr2500.c                         |    4 +-
 drivers/video/sunxvr500.c                          |    8 +-
 drivers/video/udlfb.c                              |    2 +-
 drivers/video/uvesafb.c                            |    2 +
 drivers/video/vermilion/vermilion.c                |    3 +-
 drivers/video/via/via_clock.c                      |   19 +
 include/video/omapdss.h                            |  112 ++-
 .../plat/regs-fb.h => include/video/samsung_fimd.h |  152 ++-
 132 files changed, 5372 insertions(+), 4731 deletions(-)
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-fb-v4.h
 create mode 100644 drivers/video/omap2/dss/manager-sysfs.c
 create mode 100644 drivers/video/omap2/dss/output.c
 create mode 100644 drivers/video/omap2/dss/overlay-sysfs.c
 create mode 100644 drivers/video/omap2/dss/venc_panel.c
 delete mode 100644 drivers/video/pnx4008/Makefile
 delete mode 100644 drivers/video/pnx4008/dum.h
 delete mode 100644 drivers/video/pnx4008/fbcommon.h
 delete mode 100644 drivers/video/pnx4008/pnxrgbfb.c
 delete mode 100644 drivers/video/pnx4008/sdum.c
 delete mode 100644 drivers/video/pnx4008/sdum.h
 rename arch/arm/plat-samsung/include/plat/regs-fb.h => include/video/samsung_fimd.h (73%)
