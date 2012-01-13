Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2AMSRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:17:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41469 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753471Ab2AMSRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:17:14 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+6D9MNcqC6V8YEKzRqieixIsw2hxW1GgTqndB55Q
	rDku6aR+OQxXil
Message-ID: <4F10751E.8040906@gmx.de>
Date: Fri, 13 Jan 2012 18:17:02 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev updates for 3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes to the fbdev subsystem. It contains

- removal of the (unused) display subsystem

- an API extension to support YUV formats via FOURCC done by Laurent

- large updates to OMAP, some updates to sh_mipi_dsi, s3c-fb, fsl-diu-fb, amifb,
cirrusfb and atmel_lcdfb, few patches to others

This merge window was not as quite as I hoped but it all looks pretty reasonable.


Thanks,

Florian Tobias Schandinat


The following changes since commit 384703b8e6cd4c8ef08512e596024e028c91c339:

  Linux 3.2-rc6 (2011-12-16 18:36:26 -0800)

are available in the git repository at:
  git://github.com/schandinat/linux-2.6.git fbdev-next

Alexander Stein (2):
      atmel_lcdfb: Adjust HFP calculation so it matches the manual.
      atmel_lcdfb: Use proper blanking on negative contrast polarity

Archit Taneja (3):
      OMAPDSS: DSI: Fix HSDIV related PLL info in dsi_dump_clocks()
      OMAPDSS: Panel NEC: Set omap_dss_device states correctly
      OMAPDSS: Displays: Make PICODLP driver depend on DPI

Axel Lin (5):
      video: convert drivers/video/* to use module_platform_driver()
      video: convert mbxfb to use module_platform_driver()
      video: pnx4008: convert drivers/video/pnx4008/* to use
module_platform_driver()
      video: omap: Staticise non-exported symbols
      video: omap: convert drivers/video/omap/* to use module_platform_driver()

Chandrabhanu Mahapatra (2):
      OMAPDSS: DISPC: Update Fir Coefficients
      OMAPDSS: DISPC: Update Scaling Clock Logic

Daniel Mack (1):
      OMAP: DSS2: Support for UMSH-8173MD TFT panel

Florian Tobias Schandinat (6):
      fbdev: remove display subsystem
      Merge commit 'v3.2-rc2' into fbdev-next
      Merge branch 'fbdev-for-linus' into fbdev-next
      Merge commit 'v3.2-rc6' into fbdev-next
      Merge branch 'for-florian' of git://gitorious.org/linux-omap-dss2/linux
into fbdev-next
      Revert "atmel_lcdfb: Adjust HFP calculation so it matches the manual."

Geert Uytterhoeven (12):
      zorro: Rename Picasso IV Z2 "MEM" to "RAM" for consistency
      fbdev/cirrusfb: Rewrite Zorro graphics card probing
      fbdev/cirrusfb: Add support for Picasso IV in Zorro II mode
      fbdev/cirrusfb: Add support for "64 MiB" version of Picasso IV
      fbdev/amifb: Correct whitespace
      fbdev/amifb: Fix double free
      fbdev/amifb: Reorder functions to remove forward declarations
      fbdev/amifb: Make amifb_setup() static
      fbdev/amifb: Remove superfluous casts when assigning void *
      fbdev/amifb: Store monitor limits in separate __initdata variables
      fbdev/amifb: Enable Copper DMA after setting up the Copper
      fbdev/amifb: Use framebuffer_alloc()

Ilya Yanok (2):
      OMAPDSS: add FocalTech ETM070003DH6 display support
      OMAPDSS: add OrtusTech COM43H4M10XTC display support

Jingoo Han (6):
      video: s3c-fb: fix transparency length for pixel blending
      video: s3c2410: fix checkpatch error and warnings
      video: s3c-fb: set missing bitmask of enabled hardware window
      video: s3c-fb: modify runtime pm functions
      video: s3c-fb: add shadow register protect
      MAINTAINERS: add a maintainer for Samsung Framebuffer driver

Kuninori Morimoto (15):
      fbdev: sh_mobile_lcdcfb: fixup LDHAJR :: HSYNPAJ needs mask
      fbdev: sh_mipi_dsi: tidyup dsip_clk
      fbdev: sh_mipi_dsi: typo fix of SH_MIPI_DSI_HBPBM
      fbdev: sh_mipi_dsi: tidyup VMCTR2 parameter expression
      fbdev: sh_mipi_dsi: add SH_MIPI_DSI_HFPBM flag
      fbdev: sh_mipi_dsi: add SH_MIPI_DSI_BL2E flag
      fbdev: sh_mipi_dsi: add lane control support
      fbdev: sh_mipi_dsi: add sync_pulses/sync_events/burst mode
      fbdev: sh_mipi_dsi: add VMLEN1/VMLEN2 calculation
      fbdev: sh_mipi_dsi: add set_dot_clock() for each platform
      fbdev: sh_mipi_dsi: add HSxxCLK support
      fbdev: sh_mipi_dsi: sh_mipi has pdata instead of dev
      fbdev: sh_mipi_dsi: fixup setup timing of sh_mipi_setup()
      fbdev: sh_mipi_dsi: fixup setup timing of SYSCONF
      fbdev: sh_mipi_dsi: fixup setup timing DSICTRL

Lars-Peter Clausen (1):
      video: Remove redundant spi driver bus initialization

Laurent Pinchart (4):
      fbdev: Add FOURCC-based format configuration API
      v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
      fbdev: sh_mobile_lcdc: Support FOURCC-based format API
      fbdev: matroxfb: Fix compilation after fb_var_screeninfo change

Marek Vasut (1):
      MXSFB: Fix driver registration

Mark Brown (7):
      video: s3c-fb: Unify runtime and system PM functions
      video: s3c-fb: Make runtime PM functional again
      video: s3c-fb: Use s3c_fb_enable() to enable the framebuffer
      video: s3c-fb: Disable runtime PM in error paths from probe
      video: s3c-fb: Take a runtime PM reference when unblanked
      video: s3c-fb: Hold runtime PM references when touching registers
      video: s3c-fb: Don't keep device runtime active when open

Mythri P K (2):
      OMAPDSS: HDMI: Move duplicate code from boardfile
      OMAPDSS: HDMI: Disable DDC internal pull up

Ondrej Zary (1):
      s3fb: fix Virge/VX

Peter Korsgaard (1):
      atmel_lcdfb: support new-style palette format

Ricardo Neri (4):
      ASoC: OMAP: HDMI: Introduce driver data for audio codec
      ASoC: OMAP: HDMI: Correct signature of ASoC functions
      OMAPDSS: HDMI: Create function to enable HDMI audio
      ASoC: OMAP: HDMI: Move HDMI codec trigger function to generic HDMI driver

Rob Clark (2):
      OMAPDSS: fix potential NULL pointer ref in OCP_ERR handling path
      OMAPDSS: APPLY: fix NULL pointer deref when mgr is not set

Rusty Russell (2):
      i810: fix module_param bool abuse.
      module_param: make bool parameters really bool (drivers/video/i810)

Sam Ravnborg (1):
      grvga: fix section mismatch warnings

Timur Tabi (7):
      drivers/video: fsl-diu-fb: merge all allocated data into one block
      drivers/video: fsl-diu-fb: rename "machine_data" to "data"
      drivers/video: fsl-diu-fb: merge init_fbinfo() into install_fb()
      drivers/video: fsl-diu-fb: set correct framebuffer flags
      drivers/video: fsl-diu-fb: remove broken reference count enabling the display
      drivers/video: fsl-diu-fb: add default platform ops functions
      drivers/video: fsl-diu-fb: merge fsl_diu_alloc() into map_video_memory()

Tomi Valkeinen (90):
      OMAPDSS: DSI: flush posted write when entering ULPS
      OMAPDSS: DSI: flush posted write in send_bta
      OMAPDSS: DISPC: Flush posted writes when enabling outputs
      OMAPDSS: DSI: count with number of lanes
      OMAPDSS: DSI: Parse lane config
      OMAPDSS: DSI: Use new lane config in dsi_set_lane_config
      OMAPDSS: DSI: use lane config in dsi_get_lane_mask
      OMAPDSS: DSI: use lane config in dsi_cio_wait_tx_clk_esc_reset
      OMAPDSS: DSI: use lane config in dsi_cio_enable_lane_override
      OMAPDSS: DSI: remove dsi_get_num_lanes_used
      OMAPDSS: DSI: fix lane handling when entering ULPS
      OMAPDSS: DSI: improve wait_for_bit_change
      OMAPDSS: DSI: disable DDR_CLK_ALWAYS_ON when entering ULPS
      OMAPDSS: DISPC: add missing prototype
      OMAPDSS: Remove old fifomerge hacks
      OMAPDSS: remove L4_EXAMPLE code
      OMAPDSS: DISPC: make dispc_ovl_set_channel_out() public
      OMAPDSS: DISPC: make dispc_ovl_set_fifo_threshold() public
      OMAPDSS: remove partial update from the overlay manager
      OMAPDSS: remove partial update from DSI
      OMAPDSS: remove partial update from panel-taal
      OMAPDSS: pass ovl manager to dss_start_update
      OMAPDSS: DISPC: handle 0 out_width/out_height in ovl_setup()
      OMAPDSS: handle ilace/replication when configuring overlay
      OMAPDSS: separate FIFO threshold setup from ovl_setup
      OMAPDSS: separate overlay channel from ovl_setup
      OMAPDSS: setup manager with dispc_mgr_setup()
      OMAPDSS: DISPC: remove unused functions
      OMAPDSS: remove unneeded dss_ovl_wait_for_go()
      OMAPDSS: add ovl/mgr_manual_update() helpers
      OMAPDSS: split omap_dss_mgr_apply() to smaller funcs
      OMAPDSS: apply affects only one overlay manager
      OMAPDSS: create apply.c
      OMAPDSS: hide manager's enable/disable()
      OMAPDSS: APPLY: track whether a manager is enabled
      OMAPDSS: APPLY: skip isr register and config for manual update displays
      OMAPDSS: APPLY: skip isr register and config for disabled displays
      OMAPDSS: APPLY: cleanup dss_mgr_start_update
      OMAPDSS: store overlays in an array
      OMAPDSS: store managers in an array
      OMAPDSS: store overlays in a list for each manager
      OMAPDSS: APPLY: separate vsync isr register/unregister
      OMAPDSS: DISPC: Add dispc_mgr_get_vsync_irq()
      OMAPDSS: APPLY: use dispc_mgr_get_vsync_irq()
      OMAPDSS: APPLY: configure_* funcs take ovl/manager as args
      OMAPDSS: APPLY: rename overlay_cache_data
      OMAPDSS: APPLY: rename manager_cache_data
      OMAPDSS: APPLY: move spinlock outside the struct
      OMAPDSS: APPLY: rename dss_cache to dss_data
      OMAPDSS: APPLY: move ovl funcs to apply.c
      OMAPDSS: APPLY: move mgr funcs to apply.c
      OMAPDSS: remove ovl/mgr check-code temporarily
      OMAPDSS: APPLY: add mutex
      OMAPDSS: APPLY: add missing uses of spinlock
      OMAPDSS: DSI: call mgr_enable/disable for cmd mode displays
      OMAPDSS: APPLY: move mgr->enabled to mgr_priv_data
      OMAPDSS: APPLY: add busy field to mgr_priv_data
      OMAPDSS: APPLY: rewrite overlay enable/disable
      OMAPDSS: APPLY: rewrite register writing
      OMAPDSS: DISPC: add dispc_mgr_get_framedone_irq
      OMAPDSS: APPLY: add updating flag
      OMAPDSS: APPLY: clean up isr_handler
      OMAPDSS: APPLY: move mgr->info to apply.c
      OMAPDSS: APPLY: move ovl->info to apply.c
      OMAPDSS: APPLY: move channel-field to extra_info set
      OMAPDSS: APPLY: move fifo thresholds to extra_info set
      OMAPDSS: APPLY: rename dirty & shadow_dirty
      OMAPDSS: APPLY: remove device_changed field
      OMAPDSS: APPLY: add dss_apply_ovl_enable()
      OMAPDSS: APPLY: skip enable/disable if already enabled/disabled
      OMAPDSS: APPLY: add wait_pending_extra_info_updates()
      OMAPDSS: APPLY: remove runtime_get
      OMAPDSS: Add comments about blocking of ovl/mgr functions
      OMAPDSS: APPLY: add dss_ovl_simple_check()
      OMAPDSS: APPLY: add dss_mgr_simple_check()
      OMAPDSS: APPLY: add checking of ovls/mgrs settings
      OMAPDSS: APPLY: add return value to dss_mgr_enable()
      OMAPDSS: check the return value of dss_mgr_enable()
      OMAPDSS: APPLY: fix extra_info_update_ongoing
      OMAPDSS: APPLY: fix need_isr
      OMAPDSS: APPLY: clear shadow dirty flags only if GO had been set
      OMAPDSS: APPLY: add dss_set_go_bits()
      OMAPDSS: APPLY: cleanup extra_info_update_ongoing
      OMAPDSS: APPLY: add op->enabling
      OMAPDSS: APPLY: simplify dss_mgr_enable
      OMAPDSS: APPLY: add dss_setup_fifos
      OMAPDSS: APPLY: write fifo thresholds only if changed
      OMAPDSS: APPLY: remove unused variables
      OMAPDSS: APPLY: move check functions
      OMAPDSS: APPLY: move simple_check functions

Zac Storer (2):
      Drivers: video: controlfb: fixed a brace coding style issue
      Drivers: video: sbuslib: fixed a brace coding style issue

 Documentation/DocBook/media/v4l/pixfmt-nv24.xml    |  121 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 Documentation/fb/api.txt                           |  306 ++
 MAINTAINERS                                        |    6 +
 arch/arm/mach-omap2/board-4430sdp.c                |   23 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   25 +-
 arch/arm/mach-omap2/display.c                      |   39 +
 arch/arm/mach-shmobile/board-ag5evm.c              |   43 +-
 arch/arm/mach-shmobile/board-ap4evb.c              |   32 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    4 +-
 arch/arm/mach-shmobile/clock-sh7372.c              |    4 +-
 arch/arm/mach-shmobile/clock-sh73a0.c              |    4 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |    2 +-
 arch/sh/boards/mach-ecovec24/setup.c               |    2 +-
 arch/sh/boards/mach-kfr2r09/setup.c                |    2 +-
 arch/sh/boards/mach-migor/setup.c                  |    4 +-
 arch/sh/boards/mach-se/7724/setup.c                |    2 +-
 drivers/media/video/omap/omap_vout.c               |   33 +-
 drivers/video/Kconfig                              |    1 -
 drivers/video/Makefile                             |    2 +-
 drivers/video/amifb.c                              | 5012 ++++++++++----------
 drivers/video/atmel_lcdfb.c                        |   37 +-
 drivers/video/cirrusfb.c                           |  266 +-
 drivers/video/controlfb.c                          |    2 +-
 drivers/video/display/Kconfig                      |   24 -
 drivers/video/display/Makefile                     |    6 -
 drivers/video/display/display-sysfs.c              |  219 -
 drivers/video/fbmem.c                              |   14 +
 drivers/video/fsl-diu-fb.c                         |  587 ++--
 drivers/video/grvga.c                              |    4 +-
 drivers/video/i810/i810_main.c                     |   16 +-
 drivers/video/matrox/matroxfb_base.c               |    1 -
 drivers/video/matrox/matroxfb_crtc2.c              |    1 -
 drivers/video/mbx/mbxfb.c                          |   13 +-
 drivers/video/mxsfb.c                              |   13 +-
 drivers/video/nuc900fb.c                           |   13 +-
 drivers/video/omap/lcd_ams_delta.c                 |   15 +-
 drivers/video/omap/lcd_h3.c                        |   16 +-
 drivers/video/omap/lcd_htcherald.c                 |   16 +-
 drivers/video/omap/lcd_inn1510.c                   |   16 +-
 drivers/video/omap/lcd_inn1610.c                   |   16 +-
 drivers/video/omap/lcd_mipid.c                     |    1 -
 drivers/video/omap/lcd_osk.c                       |   16 +-
 drivers/video/omap/lcd_palmte.c                    |   16 +-
 drivers/video/omap/lcd_palmtt.c                    |   15 +-
 drivers/video/omap/lcd_palmz71.c                   |   15 +-
 drivers/video/omap2/displays/Kconfig               |    2 +-
 drivers/video/omap2/displays/panel-acx565akm.c     |    1 -
 drivers/video/omap2/displays/panel-generic-dpi.c   |   66 +
 drivers/video/omap2/displays/panel-n8x0.c          |    1 -
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |   62 +-
 drivers/video/omap2/displays/panel-taal.c          |   38 +-
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |    1 -
 drivers/video/omap2/dss/Makefile                   |    3 +-
 drivers/video/omap2/dss/apply.c                    | 1324 ++++++
 drivers/video/omap2/dss/core.c                     |    2 +
 drivers/video/omap2/dss/dispc.c                    |  407 +-
 drivers/video/omap2/dss/dispc.h                    |   11 +
 drivers/video/omap2/dss/dispc_coefs.c              |  326 ++
 drivers/video/omap2/dss/dpi.c                      |    7 +-
 drivers/video/omap2/dss/dsi.c                      |  612 ++--
 drivers/video/omap2/dss/dss.h                      |   74 +-
 drivers/video/omap2/dss/dss_features.c             |   11 +
 drivers/video/omap2/dss/dss_features.h             |    1 +
 drivers/video/omap2/dss/hdmi.c                     |   59 +-
 drivers/video/omap2/dss/manager.c                  | 1221 +-----
 drivers/video/omap2/dss/overlay.c                  |  435 +--
 drivers/video/omap2/dss/rfbi.c                     |    1 -
 drivers/video/omap2/dss/sdi.c                      |    8 +-
 drivers/video/omap2/dss/ti_hdmi.h                  |   10 +-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c          |   37 +-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.h          |    3 -
 drivers/video/omap2/dss/venc.c                     |   28 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |   42 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |   14 +-
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |    4 +-
 drivers/video/omap2/omapfb/omapfb.h                |   11 +-
 drivers/video/pnx4008/pnxrgbfb.c                   |   13 +-
 drivers/video/pnx4008/sdum.c                       |   13 +-
 drivers/video/pxa168fb.c                           |   12 +-
 drivers/video/pxa3xx-gcu.c                         |   15 +-
 drivers/video/s3c-fb.c                             |  202 +-
 drivers/video/s3c2410fb.c                          |   29 +-
 drivers/video/s3fb.c                               |   30 +-
 drivers/video/sbuslib.c                            |    2 +-
 drivers/video/sh7760fb.c                           |   13 +-
 drivers/video/sh_mipi_dsi.c                        |  218 +-
 drivers/video/sh_mobile_lcdcfb.c                   |  375 +-
 drivers/video/sh_mobile_meram.c                    |   13 +-
 drivers/video/sm501fb.c                            |   13 +-
 drivers/video/vt8500lcdfb.c                        |   13 +
 drivers/video/w100fb.c                             |   13 +-
 drivers/video/wm8505fb.c                           |   13 +-
 drivers/video/wmt_ge_rops.c                        |   13 +-
 drivers/video/xilinxfb.c                           |   20 +-
 include/linux/display.h                            |   61 -
 include/linux/fb.h                                 |   14 +-
 include/linux/videodev2.h                          |    2 +
 include/linux/zorro_ids.h                          |    4 +-
 include/video/omapdss.h                            |   58 +-
 include/video/sh_mipi_dsi.h                        |   21 +-
 include/video/sh_mobile_lcdc.h                     |    4 +-
 102 files changed, 6924 insertions(+), 6108 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml
 create mode 100644 Documentation/fb/api.txt
 delete mode 100644 drivers/video/display/Kconfig
 delete mode 100644 drivers/video/display/Makefile
 delete mode 100644 drivers/video/display/display-sysfs.c
 create mode 100644 drivers/video/omap2/dss/apply.c
 create mode 100644 drivers/video/omap2/dss/dispc_coefs.c
 delete mode 100644 include/linux/display.h
