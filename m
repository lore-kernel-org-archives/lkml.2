Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab1AMJoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 04:44:55 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42863 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1AMJox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 04:44:53 -0500
Date: Thu, 13 Jan 2011 18:42:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.38-rc1, part 2.
Message-ID: <20110113094242.GA20418@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git

Which contains:

Alexey Charkov (1):
      fbdev: Implement simple blanking in pseudocolor modes for vt8500lcdfb

Archit Taneja (4):
      OMAP: DSS2: Fix: Read correct bit in dispc_enable_alpha_blending()
      OMAP: DSS2: Clean up DISPC color mode validation checks
      OMAP: DSS2: Add dss_features for omap4 and overlay manager related features
      OMAP: DSS2: Use dss_features to handle DISPC bits removed on OMAP4

Bryan Wu (4):
      OMAP: DSS2: Add generic DPI panel display driver
      OMAP: use generic DPI panel driver in board files
      OMAP: DSS2: remove generic DPI panel driver duplicated panel drivers
      OMAP: DSS2: Add back authors of panel-generic.c based drivers

Dmitry Eremin-Solenikov (1):
      video: move SH_MIPI_DSI/SH_LCD_MIPI_DSI to the top of menu

Erik Gilling (1):
      OMAP: DSS2: Add NEC NL8048HL11-01B display panel

Fabio Estevam (1):
      video: imx: Update the manufacturer's name

Guennadi Liakhovetski (3):
      fbdev: sh_mobile_hdmi: add command line option to use the preferred EDID mode
      fbdev: sh_mobile_hdmi: framebuffer notifiers have to be registered
      fbdev: sh_mobile_hdmi: simplify pointer handling

Jamie Iles (2):
      s3c2410fb: don't treat NULL clk as an error
      nuc900fb: don't treat NULL clk as an error

Kishore Y (2):
      OMAP3: ZOOM2/3/3630SDP: Add display board file for OMAP3
      OMAP3: Enable display on ZOOM2/3/3630SDP

Mayuresh Janorkar (1):
      video: tidy up modedb formatting.

Rajkumar N (1):
      OMAP3630: DSS2: Enable Pre-Multiplied Alpha Support

Samreen (2):
      OMAP3: DSS2: Split OMAP3 has feature for 3430 & 3630
      OMAP: DSS2: OMAPFB: Add null pointer check

Sumit Semwal (5):
      OMAP: DSS2: Represent DISPC register defines with channel as parameter
      OMAP: DSS2: Introduce omap_channel argument to DISPC functions used by interface drivers
      OMAP: DSS2: Change remaining DISPC functions for new omap_channel argument
      OMAP: DSS2: LCD2 Channel Changes for DISPC
      OMAP: DSS2: Introduce omap_channel as an omap_dss_device parameter, add new overlay manager.

Vicente Jiménez (1):
      video: matroxfb: Correct video option in comments and kernel config help.

 arch/arm/mach-omap2/Makefile                       |    3 +
 arch/arm/mach-omap2/board-3430sdp.c                |   12 +-
 arch/arm/mach-omap2/board-3630sdp.c                |    1 +
 arch/arm/mach-omap2/board-am3517evm.c              |   23 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   23 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   26 +-
 arch/arm/mach-omap2/board-igep0020.c               |   12 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   12 +-
 arch/arm/mach-omap2/board-omap3evm.c               |   12 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   23 +-
 arch/arm/mach-omap2/board-zoom-display.c           |  168 +++++
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   49 ++-
 arch/arm/mach-omap2/board-zoom.c                   |    1 +
 arch/arm/mach-omap2/include/mach/board-zoom.h      |    3 +
 arch/arm/plat-omap/include/plat/display.h          |    9 +
 .../arm/plat-omap/include/plat/panel-generic-dpi.h |   37 ++
 drivers/video/Kconfig                              |   18 +-
 drivers/video/imxfb.c                              |    2 +-
 drivers/video/matrox/matroxfb_base.c               |   70 ++--
 drivers/video/modedb.c                             |  420 +++++++------
 drivers/video/nuc900fb.c                           |    5 +-
 drivers/video/omap2/displays/Kconfig               |   27 +-
 drivers/video/omap2/displays/Makefile              |    5 +-
 drivers/video/omap2/displays/panel-generic-dpi.c   |  365 +++++++++++
 drivers/video/omap2/displays/panel-generic.c       |  174 ------
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |  325 ++++++++++
 .../video/omap2/displays/panel-sharp-lq043t1dg01.c |  165 -----
 .../video/omap2/displays/panel-toppoly-tdo35s.c    |  164 -----
 drivers/video/omap2/dss/dispc.c                    |  636 +++++++++++++-------
 drivers/video/omap2/dss/dpi.c                      |   40 +-
 drivers/video/omap2/dss/dsi.c                      |   27 +-
 drivers/video/omap2/dss/dss.h                      |   35 +-
 drivers/video/omap2/dss/dss_features.c             |   66 ++-
 drivers/video/omap2/dss/dss_features.h             |   10 +-
 drivers/video/omap2/dss/manager.c                  |   80 ++-
 drivers/video/omap2/dss/overlay.c                  |   55 ++-
 drivers/video/omap2/dss/rfbi.c                     |   20 +-
 drivers/video/omap2/dss/sdi.c                      |   24 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |    5 +-
 drivers/video/s3c2410fb.c                          |    5 +-
 drivers/video/sh_mobile_hdmi.c                     |   97 ++--
 drivers/video/vt8500lcdfb.c                        |   28 +
 42 files changed, 2112 insertions(+), 1170 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-zoom-display.c
 create mode 100644 arch/arm/plat-omap/include/plat/panel-generic-dpi.h
 create mode 100644 drivers/video/omap2/displays/panel-generic-dpi.c
 delete mode 100644 drivers/video/omap2/displays/panel-generic.c
 create mode 100644 drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
 delete mode 100644 drivers/video/omap2/displays/panel-sharp-lq043t1dg01.c
 delete mode 100644 drivers/video/omap2/displays/panel-toppoly-tdo35s.c
