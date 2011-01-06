Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1AFPVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:21:30 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49079 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1AFPV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:21:27 -0500
Date: Fri, 7 Jan 2011 00:19:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.38-rc1
Message-ID: <20110106151928.GA17448@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git

Which contains:

Aaro Koskinen (13):
      sisfb: eliminate unused variable compiler warning
      sisfb: delete HAVE_CONFIG_H checks
      sisfb: remove duplicate function declarations
      sisfb: change register I/O functions to use fixed size types
      sisfb: replace inSISREG with SiS_GetRegByte
      sisfb: replace outSISREG with SiS_SetRegByte
      sisfb: replace inSISIDXREG with SiS_GetReg
      sisfb: replace outSISIDXREG with SiS_SetReg
      sisfb: replace orSISIDXREG with SiS_SetRegOR
      sisfb: replace andSISIDXREG with SiS_SetRegAND
      sisfb: replace setSISIDXREG with SiS_SetRegANDOR
      sisfb: delete unused register I/O macros
      sisfb: eliminate compiler warnings

Alexey Charkov (3):
      ARM: Add support for the display controllers in VT8500 and WM8505
      fbdev: Minor cleanup in WM8505-related code
      fbdev: Modify vsync timing calculation in wm8505fb

Andres Salomon (1):
      s1d13xxxfb: drop unused code

Arnd Hannemann (1):
      fbdev: modedb: fix CEA modes

Brent Cook (1):
      video: Fix the HGA framebuffer driver

Daniel Drake (2):
      viafb: General power management infrastructure
      viafb: Add OLPC XO-1.5 port configs

Erik Gilling (1):
      video: add fb_edid_add_monspecs for parsing extended edid information

Fabio Estevam (1):
      video: imxfb: Fix the maximum value for yres

Guennadi Liakhovetski (13):
      fbdev: sh_mobile_hdmi: add support for more precise HDMI clock configuration
      fbdev: sh_mobile_hdmi: improve support for more video modes
      fbdev: sh_mobile_lcdc: increase maximum framebuffer size to support 1080p
      fbdev: sh_mobile_hdmi: add support for 1080p modes
      ARM: mach-shmobile: optimize PLLC2 frequency for HDMI
      fbdev: export fb_edid_add_monspecs() for modules, improve algorithm
      fbdev: when parsing E-EDID blocks, also use SVD entries
      fbdev: sh_mobile_hdmi: add support for E-EDID parsing
      fbdev: sh-mobile: implement MIPI DSI runtime PM support
      ARM: mach-shmobile: improve MIPI DSI clock configuration
      fbdev: sh_mipi_dsi: support different register layouts
      ARM: mach-shmobile: specify sh7372 MIPI DSI register layout
      fbdev: sh_mipi_dsi: use platform provided register layout and values

Jingoo Han (1):
      s3c-fb: add support for runtime pm

Joe Perches (1):
      video: mx3fb: Use vsprintf extension %pR for struct resource

Jonathan Corbet (1):
      viafb: suspend/resume for GPIOs

Julia Lawall (1):
      drivers/video/carminefb.c: improve error handling

Magnus Damm (5):
      fbdev: sh_mipi_dsi: Make use of register names
      ARM: mach-shmobile: Extend AP4EVB MIPI-DSI resources
      fbdev: sh_mipi_dsi: Require two I/O resources V2
      fbdev: sh_mipi_dsi: Allow LCDC board callbacks
      fbdev: sh_mobile_lcdcfb: Enable 32 bpp and 24 bpp support

Mayuresh Janorkar (1):
      fbdev: modedb: Add a new mode for 864x480 TAAL panels.

Michael Hennerich (2):
      fbdev: bf537-lq035: new Blackfin Sharp LQ035 framebuffer driver
      fbdev: bfin_adv7393fb: new Blackfin ADV7393 driver

Paul Mundt (6):
      fbdev: sh_mobile_lcdcfb: fix up compiler warnings.
      fbdev: sh_mobile_hdmi: fix up compiler warnings.
      fbdev: move udlfb out of staging.
      video: udlfb: deifdefify (yes, that's a word).
      video: udlfb: Kill off some magic constants for EDID sizing.
      video: udlfb: Kill off special printk wrappers, use pr_fmt().

Stefani Seibold (1):
      drivers/video/i810/i810-i2c.c: fix i2c bus handling

 .../staging/udlfb => Documentation/fb}/udlfb.txt   |    0
 arch/arm/mach-shmobile/board-ap4evb.c              |   70 +-
 arch/arm/mach-shmobile/clock-sh7372.c              |   13 +-
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/udlfb/Kconfig                      |   14 -
 drivers/staging/udlfb/Makefile                     |    1 -
 drivers/video/Kconfig                              |  120 ++-
 drivers/video/Makefile                             |    6 +
 drivers/video/bf537-lq035.c                        |  914 +++++++++++++++
 drivers/video/bfin_adv7393fb.c                     |  832 ++++++++++++++
 drivers/video/bfin_adv7393fb.h                     |  321 ++++++
 drivers/video/carminefb.c                          |    6 +-
 drivers/video/fbmon.c                              |   88 ++
 drivers/video/hgafb.c                              |   22 +-
 drivers/video/i810/i810-i2c.c                      |   12 +-
 drivers/video/modedb.c                             |   51 +
 drivers/video/mx3fb.c                              |    3 +-
 drivers/video/s1d13xxxfb.c                         |   50 -
 drivers/video/s3c-fb.c                             |  111 ++-
 drivers/video/sh_mipi_dsi.c                        |  129 ++-
 drivers/video/sh_mobile_hdmi.c                     |  219 +++--
 drivers/video/sh_mobile_lcdcfb.c                   |   76 ++-
 drivers/video/sis/init.c                           |   46 +-
 drivers/video/sis/init.h                           |   13 -
 drivers/video/sis/init301.c                        |    8 +-
 drivers/video/sis/init301.h                        |   11 -
 drivers/video/sis/sis.h                            |   65 +-
 drivers/video/sis/sis_main.c                       | 1196 ++++++++++----------
 drivers/{staging/udlfb => video}/udlfb.c           |  135 +--
 drivers/video/via/via-core.c                       |   96 ++-
 drivers/video/via/via-gpio.c                       |   29 +
 drivers/video/via/viafbdev.c                       |   34 +-
 drivers/video/via/viafbdev.h                       |    2 -
 drivers/video/vt8500lcdfb.c                        |  447 ++++++++
 drivers/video/vt8500lcdfb.h                        |   34 +
 drivers/video/wm8505fb.c                           |  422 +++++++
 drivers/video/wm8505fb_regs.h                      |   76 ++
 drivers/video/wmt_ge_rops.c                        |  186 +++
 drivers/video/wmt_ge_rops.h                        |    5 +
 include/linux/fb.h                                 |    3 +
 include/linux/via-core.h                           |   15 +
 include/video/s1d13xxxfb.h                         |    6 -
 include/video/sh_mipi_dsi.h                        |    6 +
 include/video/sh_mobile_hdmi.h                     |    3 +
 {drivers/staging/udlfb => include/video}/udlfb.h   |   22 -
 46 files changed, 4820 insertions(+), 1101 deletions(-)
 rename {drivers/staging/udlfb => Documentation/fb}/udlfb.txt (100%)
 delete mode 100644 drivers/staging/udlfb/Kconfig
 delete mode 100644 drivers/staging/udlfb/Makefile
 create mode 100644 drivers/video/bf537-lq035.c
 create mode 100644 drivers/video/bfin_adv7393fb.c
 create mode 100644 drivers/video/bfin_adv7393fb.h
 rename drivers/{staging/udlfb => video}/udlfb.c (94%)
 create mode 100644 drivers/video/vt8500lcdfb.c
 create mode 100644 drivers/video/vt8500lcdfb.h
 create mode 100644 drivers/video/wm8505fb.c
 create mode 100644 drivers/video/wm8505fb_regs.h
 create mode 100644 drivers/video/wmt_ge_rops.c
 create mode 100644 drivers/video/wmt_ge_rops.h
 rename {drivers/staging/udlfb => include/video}/udlfb.h (78%)
