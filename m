Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1HAN4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:56:47 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51607 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1HAN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:56:42 -0400
Subject: [GIT PULL] OMAP display subsystem patches for 3.1
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
        linux-omap mailing list <linux-omap@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        lk-ml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 16:49:40 +0300
Message-ID: <1312206580.1956.21.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for sending this pull request so late.

This pull request contains mostly OMAP display subsystem driver patches
related to preparing and making the DSS driver use runtime PM. Using
runtime PM creates new dependencies to the lower level arch stuff
(clocks and HWMODs), and while the patches for arch side have been ready
for some time, some of them seem to have fallen into some cracks and
didn't make it into the pull requests sent by the HWMOD maintainer. And
then the maintainer went to vacation before I could react.

I had to make two hack patches to the DSS driver to circumvent the
problems. The hack patches are small and easily removed for -rc2
presuming the arch side gets fixed at that point.

So, this pull request got delayed until I could make the fixes and test
them, and thus I'm sending this directly to you, and not via fbdev tree.
I hope this is not too late to make it into 3.1-rc1.

Br,
 Tomi


The following changes since commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f:

  Linux 3.0-rc4 (2011-06-20 20:25:46 -0700)

are available in the git repository at:
  git://gitorious.org/linux-omap-dss2/linux.git for-3.1-rc1

Nishant Kamat (1):
      OMAP: DSS: Minor cleanup in ovl and mgr cache structs

Tomi Valkeinen (30):
      OMAP: DSS2: remove extra includes from include/video/omapdss.h
      OMAP: DSS2: DSI: Change dummy macros to inline functions
      OMAP: DSS2: OMAPFB: Add struct to store per-display data
      OMAP: DSS2: OMAPFB: Implement auto-update mode
      OMAP: DSS2: remove update_mode from omapdss
      OMAP: DSS2: Taal: Make driver more fault tolerant
      OMAP: DSS2: Reset LANEx_ULPS_SIG2 bits after use
      OMAP: DSS2: Add FEAT_VENC_REQUIRES_TV_DAC_CLK
      OMAP: DSS2: Add new FEAT definitions for features missing from OMAP2
      OMAP: DSS2: Add Color Phase Rotation support
      OMAP: DSS2: DSI: sync when disabling a display
      OMAP: DSS2: Fix FIFO threshold and burst size for OMAP4
      OMAP: DSS2: Handle dpll4_m4_ck in dss_get/put_clocks
      OMAP: DSS2: Clean up probe for DSS & DSI
      OMAP: DSS2: Fix init and unit sequence
      OMAP: DSS2: Remove clk optimization at dss init
      OMAP: DSS2: rewrite use of context_loss_count
      OMAP: DSS2: Use omap_pm_get_dev_context_loss_count to get ctx loss count
      OMAP: DSS2: DPI: remove unneeded SYSCK enable/disable
      OMAP: DSS2: Remove core_dump_clocks
      OMAP: DSS2: Remove CONFIG_OMAP2_DSS_SLEEP_BEFORE_RESET
      OMAP: DSS2: Use PM runtime & HWMOD support
      OMAP: DSS2: Remove unused opt_clock_available
      OMAP: DSS2: DISPC: remove finegrained clk enables/disables
      OMAP: DSS2: Remove unused code from display.c
      OMAP: DSS2: Remove ctx loss count from dss.c
      OMAP: DSS2: DISPC: Fix context save/restore
      OMAP: DSS2: DSS: Fix context save/restore
      HACK: OMAP: DSS2: clk hack for OMAP2/3
      OMAP: DSS2: HDMI: fix hdmi clock name

 arch/arm/mach-omap2/display.c             |   26 +--
 drivers/video/omap2/displays/panel-taal.c |   55 ++--
 drivers/video/omap2/dss/Kconfig           |   12 -
 drivers/video/omap2/dss/core.c            |   21 +-
 drivers/video/omap2/dss/dispc.c           |  562 ++++++++++++++++------------
 drivers/video/omap2/dss/display.c         |   57 +---
 drivers/video/omap2/dss/dpi.c             |   73 +++--
 drivers/video/omap2/dss/dsi.c             |  296 +++++++++------
 drivers/video/omap2/dss/dss.c             |  583 +++++++----------------------
 drivers/video/omap2/dss/dss.h             |   54 ++--
 drivers/video/omap2/dss/dss_features.c    |   36 ++-
 drivers/video/omap2/dss/dss_features.h    |    7 +
 drivers/video/omap2/dss/hdmi.c            |  162 ++++++--
 drivers/video/omap2/dss/manager.c         |  351 ++++++++++--------
 drivers/video/omap2/dss/overlay.c         |   27 +-
 drivers/video/omap2/dss/rfbi.c            |  114 +++++-
 drivers/video/omap2/dss/sdi.c             |   40 ++-
 drivers/video/omap2/dss/venc.c            |  183 +++++++--
 drivers/video/omap2/omapfb/omapfb-ioctl.c |   72 ++--
 drivers/video/omap2/omapfb/omapfb-main.c  |  166 +++++++--
 drivers/video/omap2/omapfb/omapfb-sysfs.c |   34 ++
 drivers/video/omap2/omapfb/omapfb.h       |   37 ++-
 include/video/omapdss.h                   |   26 +-
 23 files changed, 1639 insertions(+), 1355 deletions(-)


