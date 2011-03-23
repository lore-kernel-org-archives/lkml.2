Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1CWM2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:28:23 -0400
Received: from linux-sh.org ([111.68.239.195]:40381 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab1CWM2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:28:21 -0400
Date: Wed, 23 Mar 2011 21:28:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.39-rc1, part 2.
Message-ID: <20110323122815.GA11680@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the second batch of fbdev updates. The bulk of this is OMAP DSS
churn that had some dependencies on both the ARM and OMAP merges that
have since settled. The rest is basically random fixes, svgalib
modernization, and the usual smattering of driver updates.

This does not yet include Andy Whitcroft's registration locking or the
suspend/resume console locking fixes as we still need to make a few
changes and do some more testing (as well as getting confirmation that
things still work in both cases). My intention is to have that sorted out
for -rc2.

I noticed a few other fb drivers and churn popped up from various other
trees, but that should hopefully begin to slow down now that things are
for the most part being centrally maintained (the bulk of the ARM SoC trees
for example seem to prefer to lump all of their driver changes together
rather than going through subsystem trees -- basically all of them but
OMAP and SH/R-Mobile, but in general folks have been pretty good with
making sure patches still hit the lists and at least have some tentative
review, as with the unicore32 merge).

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git

Which contains:

Aaro Koskinen (6):
      sisfb: POST should fail if R/W test fails
      sisfb: move XGI POST RAM type detection into a subroutine
      sisfb: add subroutine for detecting XGI Z9
      sisfb: add RAM type detection for XGI Z9
      sisfb: move XGI POST DDR2 bootup code into subroutines
      sisfb: add support for XGI Z9 DDR2 POST

Andreas Bießmann (2):
      atmel_lcdfb: implement inverted contrast pwm
      atmel_lcdfb: add fb_blank function

Archit Taneja (15):
      OMAP2PLUS: DSS2: Generalize naming of PRCM related clock enums in DSS driver
      OMAP2PLUS: DSS2: Generalize external clock names in struct dss of dss.c
      OMAP: DSS2: Have separate irq handlers for DISPC and DSI
      OMAP2PLUS: DSS2: FEATURES: DISPC overlay code cleanup
      OMAP2PLUS: DSS2: FEATURES: Function to Provide the max fck supported
      OMAP2PLUS: DSS2: Make members of dss_clk_source generic
      OMAP2PLUS: DSS2: Use dss features to get clock source names of current OMAP
      OMAP2PLUS: DSS2: DSI: Generalize DSI PLL Clock Naming
      OMAP: DSS2: Functions to request/release DSI VCs
      OMAP: DSS2: Use request / release calls in Taal for DSI Virtual Channels.
      OMAP2PLUS: DSS2: Cleanup clock source related code
      OMAP4: DSS2: Clock source changes for OMAP4
      OMAP2PLUS: DSS2: FEATURES: Fix usage of dss_reg_field and dss_clk_source_name
      OMAP: DSS2: FEATURES: Functions to return min and max values of parameters
      OMAP: DSS2: FEATURES: DSI PLL parameter cleanup

Axel Lin (7):
      video: hpfb: use resource_size()
      video: sh7760fb: use resource_size()
      video: ffb: fix ffb_probe error path
      video: s3c-fb: return proper error if clk_get fails
      video: hecubafb: add __devexit_p around reference to hecubafb_remove
      video: metronomefb: add __devexit_p around reference to metronomefb_remove
      video: add missing framebuffer_release in error path

Dan Carpenter (1):
      fbdev: sh_mobile_lcdc: checking NULL instead of IS_ERR()

Dave Airlie (1):
      fbcon: fix situation where fbcon gets deinitialised and can't reinit.

David Miller (22):
      svga: Use proper VGA register name macros in svga_wattr.
      svga: Make svga_wattr take an iomem regbase pointer.
      svga: Make svga_wcrt_multi take an iomem regbase pointer.
      svga: Make svga_wseq_multi take an iomem regbase pointer.
      svga: Make svga_set_default_gfx_regs take an iomem regbase pointer.
      svga: Make svga_set_default_atc_regs take an iomem regbase pointer.
      svga: Make svga_set_default_seq_regs take an iomem regbase pointer.
      svga: Make svga_wseq_mask() take an iomem regbase pointer.
      svga: Make svga_wcrt_mask() take an iomem regbase pointer.
      svga: Make svga_set_default_crt_regs() take an iomem regbase pointer.
      svga: Make svga_set_textmode_vga_regs() take an iomem regbase pointer.
      svga: Make svga_tilecursor() take an iomem regbase pointer.
      svga: Make svga_set_timings() take an iomem regbase pointer.
      arkfb: Pass par->state.vgabase to vga_*() calls.
      s3fb: Pass par->state.vgabase to vga_*() calls.
      vt8623fb: Pass par->state.vgabase to vga_*() calls.
      arkfb: Don't clobber par->state.vgabase during open method.
      s3fb: Don't clobber par->state.vgabase during open method.
      vt8623fb: Don't clobber par->state.vgabase during open method.
      s3fb: Compute VGA base iomem pointer explicitly.
      arkfb: Compute VGA base iomem pointer explicitly.
      vt8623fb: Compute VGA base iomem pointer explicitly.

Heiko Schocher (3):
      video, sm501: add I/O functions for use on powerpc
      video, sm501: add edid and commandline support
      video, sm501: add OF binding to support SM501

Henry Nestler (1):
      fbcon: Bugfix soft cursor detection in Tile Blitting

Jani Nikula (1):
      OMAP: DSS2: Fix def_disp module param description

Jarkko Nikula (1):
      omapfb: Fix linker error in drivers/video/omap/lcd_2430sdp.c

Jean Delvare (1):
      radeonfb: Let hwmon driver probe the "monid" I2C bus

Justin P. Mattock (1):
      drivers:video:aty:radeon_base Fix typo occationally to occasionally

Kirill A. Shutemov (2):
      omap: use list_move() instead of list_del()/list_add() combination
      vmlfb: use list_move() instead of list_del()/list_add() combination

Martin Decky (1):
      video: Fix EDID macros H_SYNC_WIDTH and H_SYNC_OFFSET

Mayuresh Janorkar (4):
      OMAP2PLUS: DSS2: Add OMAP4 Kconfig support
      OMAP4: DSS2: Add hwmod device names for OMAP4.
      OMAPFB: Adding a check for timings in set_def_mode
      OMAP: OMAPFB: Adding help for FB_OMAP_LCD_VGA option

Murthy, Raghuveer (5):
      OMAP: DSS2: Adding dss_features for independent core clk divider
      OMAP: DSS2: Renaming register macro DISPC_DIVISOR(ch)
      OMAP4: DSS2: Using dss_features to set independent core clock divider
      OMAP: DSS2: Implement OMAP4 DSS fclk support
      OMAP4: PandaBoard: Adding DVI support

Mythri P K (10):
      OMAP4: DSS2: Add display type HDMI to DSS2
      OMAP4: DSS2: HDMI: Select between HDMI VENC clock source.
      OMAP4: DSS2: HDMI: Dispc gamma enable set/reset function for TV.
      OMAP4: DSS2: HDMI: HDMI driver header file addition
      OMAP4: DSS2: HDMI: HDMI driver addition in the DSS
      OMAP4: DSS2: HDMI: HDMI panel driver addition in the DSS
      OMAP4: DSS2: HDMI: Add makefile and kconfig changes to enable HDMI in OMAP4
      OMAP4: DSS: HDMI: Call to HDMI module init to register driver.
      OMAP4: HDMI: Add HDMI structure in the board file for OMAP4 SDP
      OMAP4: HDMI: Add HDMI structure in the board file for OMAP4 PANDA

Ondrej Zary (5):
      s3fb: maximize virtual vertical size for fast scrolling
      s3fb: add support for 86C365 Trio3D
      s3fb: fix 15/16bpp modes with over 115MHz pixclocks on 86C365 Trio3D
      s3fb: enable DTPC
      s3fb: use new start address register

Paul Mundt (4):
      mailmap: Update for OMAP DSS developers.
      video: Move sm501fb devicetree binding documentation to a better place.
      MAINTAINERS: Add file pattern for fb dt bindings.
      MAINTAINERS: de-orphan fbdev.

Samreen (1):
      OMAP2/3/4: DSS2: Enable Display SubSystem as modules

Senthilvadivu Guruswamy (9):
      OMAP2,3: DSS2: Build omap_device for each DSS HWIP
      OMAP2, 3: DSS2: DSS: create platform_driver, move init, exit to driver
      OMAP2, 3: DSS2: Move clocks from core driver to dss driver
      OMAP2, 3: DSS2: RFBI: create platform_driver, move init, exit to driver
      OMAP2, 3: DSS2: DISPC: create platform_driver, move init, exit to driver
      OMAP2, 3: DSS2: VENC: create platform_driver, move init, exit to driver
      OMAP2, 3: DSS2: DSI: create platform_driver, move init, exit to driver
      OMAP2,3: DSS2: Use platform device to get baseaddr
      OMAP2,3: DSS2: Get DSS IRQ from platform device

Steve Sakoman (5):
      OMAP: DSS2: Add support for LG Philips LB035Q02 panel
      OMAP: DSS2: Add DSS2 support for Overo
      omap: overo: Add regulator for ads7846
      OMAP: Add gpio-leds support for Overo
      OMAP: Add gpio-keys support for Overo

Sumit Semwal (6):
      OMAP2, 3: DSS2: remove forced clk-disable from omap_dss_remove
      OMAP2,3: DSS2: replace printk with dev_dbg in init
      OMAP2PLUS: clocks: Align DSS clock names and roles
      OMAP4: DSS2: clocks: Add ick as dummy clock
      OMAP2PLUS:DSS2: add opt_clock_available in pdata
      OMAP2PLUS:DSS2: Use opt_clock_available from pdata

Thomas Schlichter (1):
      uvesafb,vesafb: create WC or WB PAT-entries

Tomi Valkeinen (25):
      OMAP: 3430SDP: Remove unused vdda_dac supply
      OMAP: DSS2: Delay regulator_get() calls
      OMAP: DSS2: Support for Samsung LTE430WQ-F0C
      MAINTAINERS: Update OMAP DSS maintainer
      OMAP: DSS2: Clean up a switch-case
      OMAP: DSS2: FEATURES: Remove SDI from 3630 displays
      OMAP: DSS2: FEATURES: Remove DSI & SDI from OMAP2
      OMAP: DSS2: Check for SDI HW before accessing SDI registers
      OMAP: DSS2: Remove unused list
      OMAP: DSS2: DSI: remove unused function
      OMAP: DSS2: Remove FB_OMAP_BOOTLOADER_INIT support
      OMAP: DSS2: Remove pdev argument from dpi_init
      OMAP: DSS2: Move DPI & SDI init into DSS plat driver
      OMAP: DSS2: Remove unneeded cpu_is_xxx checks
      HACK: OMAP: DSS2: Fix OMAP2_DSS_USE_DSI_PLL
      HACK: OMAP: DSS2: add delay after enabling clocks
      OMAP: DSS2: fix omap_dispc_register_isr() fail path
      HACK: OMAP: DSS2: VENC: disable VENC on OMAP4 to prevent crash
      OMAP: DSS2: DSI: Restructure IRQ handler
      OMAP: DSS2: DSI: Add ISR support
      OMAP: DSS2: DSI: use ISR in send_bta_sync
      OMAP: DSS2: DSI: use ISR for BTA in framedone
      OMAP: DSS2: DSI: catch DSI errors in send_bta_sync
      OMAP: DSS2: DSI: fix IRQ debug prints
      OMAP: DSS2: Clean up for dpll4_m4_ck handling

 .mailmap                                           |    4 +
 Documentation/devicetree/bindings/fb/sm501fb.txt   |   34 +
 Documentation/fb/sm501.txt                         |   10 +
 MAINTAINERS                                        |    8 +-
 arch/arm/configs/omap2plus_defconfig               |   11 +
 arch/arm/mach-omap2/board-3430sdp.c                |    6 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   75 ++
 arch/arm/mach-omap2/board-cm-t35.c                 |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   12 +-
 arch/arm/mach-omap2/board-igep0020.c               |   10 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   12 +-
 arch/arm/mach-omap2/board-omap3evm.c               |   12 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    3 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   12 +-
 arch/arm/mach-omap2/board-omap4panda.c             |  203 +++-
 arch/arm/mach-omap2/board-overo.c                  |  357 +++++-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   12 +-
 arch/arm/mach-omap2/clock2420_data.c               |    8 +-
 arch/arm/mach-omap2/clock2430_data.c               |    8 +-
 arch/arm/mach-omap2/clock3xxx_data.c               |   14 +-
 arch/arm/mach-omap2/clock44xx_data.c               |   15 +-
 arch/arm/mach-omap2/display.c                      |   80 ++
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   13 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   12 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   23 +-
 arch/arm/plat-omap/include/plat/display.h          |   15 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |    2 +-
 drivers/mfd/sm501.c                                |  134 +-
 drivers/video/arkfb.c                              |  160 ++-
 drivers/video/atmel_lcdfb.c                        |   31 +-
 drivers/video/aty/radeon_base.c                    |    2 +-
 drivers/video/aty/radeon_i2c.c                     |    3 +
 drivers/video/cg14.c                               |    1 +
 drivers/video/cg6.c                                |    1 +
 drivers/video/console/fbcon.c                      |    4 +-
 drivers/video/console/tileblit.c                   |    2 +-
 drivers/video/edid.h                               |    4 +-
 drivers/video/ffb.c                                |    2 +-
 drivers/video/hecubafb.c                           |    2 +-
 drivers/video/hpfb.c                               |    6 +-
 drivers/video/metronomefb.c                        |    2 +-
 drivers/video/omap/Kconfig                         |    7 +-
 drivers/video/omap/blizzard.c                      |    3 +-
 drivers/video/omap/hwa742.c                        |    3 +-
 drivers/video/omap2/displays/Kconfig               |    6 +
 drivers/video/omap2/displays/Makefile              |    1 +
 drivers/video/omap2/displays/panel-generic-dpi.c   |   25 +
 .../omap2/displays/panel-lgphilips-lb035q02.c      |  279 ++++
 drivers/video/omap2/displays/panel-taal.c          |  123 +-
 drivers/video/omap2/dss/Kconfig                    |   14 +-
 drivers/video/omap2/dss/Makefile                   |    2 +
 drivers/video/omap2/dss/core.c                     |  480 +-------
 drivers/video/omap2/dss/dispc.c                    |  335 ++++--
 drivers/video/omap2/dss/display.c                  |   35 +-
 drivers/video/omap2/dss/dpi.c                      |   45 +-
 drivers/video/omap2/dss/dsi.c                      |  967 +++++++++++----
 drivers/video/omap2/dss/dss.c                      |  763 +++++++++--
 drivers/video/omap2/dss/dss.h                      |  153 ++-
 drivers/video/omap2/dss/dss_features.c             |  163 ++-
 drivers/video/omap2/dss/dss_features.h             |   27 +
 drivers/video/omap2/dss/hdmi.c                     | 1332 ++++++++++++++++++++
 drivers/video/omap2/dss/hdmi.h                     |  415 ++++++
 drivers/video/omap2/dss/hdmi_omap4_panel.c         |  222 ++++
 drivers/video/omap2/dss/manager.c                  |   13 +-
 drivers/video/omap2/dss/overlay.c                  |   10 +-
 drivers/video/omap2/dss/rfbi.c                     |  128 ++-
 drivers/video/omap2/dss/sdi.c                      |   62 +-
 drivers/video/omap2/dss/venc.c                     |  128 ++-
 drivers/video/omap2/omapfb/Kconfig                 |    6 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |   23 +-
 drivers/video/s3c-fb.c                             |    1 +
 drivers/video/s3fb.c                               |  341 +++--
 drivers/video/sh7760fb.c                           |    4 +-
 drivers/video/sh_mobile_lcdcfb.c                   |    5 +-
 drivers/video/sis/sis.h                            |    1 +
 drivers/video/sis/sis_main.c                       |  315 ++++--
 drivers/video/sis/vgatypes.h                       |    1 +
 drivers/video/sm501fb.c                            |  275 +++--
 drivers/video/svgalib.c                            |  175 ++--
 drivers/video/tcx.c                                |    1 +
 drivers/video/uvesafb.c                            |   49 +-
 drivers/video/vermilion/vermilion.c                |    3 +-
 drivers/video/vesafb.c                             |   44 +-
 drivers/video/vt8623fb.c                           |  157 ++-
 include/linux/sm501.h                              |    8 +
 include/linux/svga.h                               |   34 +-
 include/video/atmel_lcdc.h                         |    1 +
 88 files changed, 6494 insertions(+), 2020 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/fb/sm501fb.txt
 create mode 100644 Documentation/fb/sm501.txt
 create mode 100644 drivers/video/omap2/displays/panel-lgphilips-lb035q02.c
 create mode 100644 drivers/video/omap2/dss/hdmi.c
 create mode 100644 drivers/video/omap2/dss/hdmi.h
 create mode 100644 drivers/video/omap2/dss/hdmi_omap4_panel.c
