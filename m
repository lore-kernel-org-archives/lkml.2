Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1F1WD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:03:27 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35030 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1F1WDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:03:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/29] GMA500 updates
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:02:57 +0100
Message-ID: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings the tree close to sync with the working tree.
---

Alan Cox (26):
      gma500: enable Medfield CRTC support
      gma500: Read the GCT panel type information for Medfield
      gma500: Fix early Medfield crash
      gma500: continue abstracting platform specific code
      gma500: being abstracting out devices a bit more
      gma500: Only fiddle with clock gating on PSB
      gma500: psb_fb tidy/cleanup pass
      gma500: Extract BIOSisy stuff from psb_drv
      gma500: Move our other GEM helper into the bits want to push into GEM
      gma500: Medfield support
      gma500: 2D polish
      gma500: CodingStyle pass
      gma500: Use the GEM tweaks to provide a GEM frame buffer
      gma500: GEM glue
      gma500: Kill spare kref
      gma500: nuke the PSB debug stuff
      gma500: nuke the last bits of TTM code
      gma500: 2D acceleration tidying
      gma500: polish for completion of this phase
      gma500: trim some of the debug
      gma500: Do sane FB cleanup
      gma500: revamp frame buffer creation and handling
      gma500: Set the correct bits according to the pipe
      gma500: Ensure the frame buffer has a linear virtual mapping
      gma500: Make GTT pages uncached
      gma500: fix warnings

Andre Bartke (1):
      gma500: Fix uninitialized variable and style issues

Andrew Morton (1):
      gma500: drivers/staging/gma501/psb_intel_display.c: fix build

Jani Nikula (1):
      gma500: fix build without backlight device support


 drivers/staging/gma500/Makefile               |   21 
 drivers/staging/gma500/backlight.c            |   46 +
 drivers/staging/gma500/displays/hdmi.h        |   33 +
 drivers/staging/gma500/displays/pyr_cmd.h     |   34 +
 drivers/staging/gma500/displays/pyr_vid.h     |   34 +
 drivers/staging/gma500/displays/tmd_cmd.h     |   34 +
 drivers/staging/gma500/displays/tmd_vid.h     |   34 +
 drivers/staging/gma500/displays/tpo_cmd.h     |   35 +
 drivers/staging/gma500/displays/tpo_vid.h     |   33 +
 drivers/staging/gma500/gem_glue.c             |  101 ++
 drivers/staging/gma500/gem_glue.h             |    4 
 drivers/staging/gma500/mdfld_device.c         |  702 ++++++++++++
 drivers/staging/gma500/mdfld_dsi_dbi.c        |  872 +++++++++++++++
 drivers/staging/gma500/mdfld_dsi_dbi.h        |  188 +++
 drivers/staging/gma500/mdfld_dsi_dbi_dpu.h    |  157 +++
 drivers/staging/gma500/mdfld_dsi_dpi.c        |  991 ++++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_dpi.h        |   80 +
 drivers/staging/gma500/mdfld_dsi_output.c     |  980 +++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_output.h     |  328 ++++++
 drivers/staging/gma500/mdfld_dsi_pkg_sender.c | 1097 +++++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_pkg_sender.h |  158 +++
 drivers/staging/gma500/mdfld_intel_display.c  | 1415 +++++++++++++++++++++++++
 drivers/staging/gma500/mdfld_msic.h           |   31 +
 drivers/staging/gma500/mdfld_output.c         |  144 +++
 drivers/staging/gma500/mdfld_output.h         |   80 +
 drivers/staging/gma500/mdfld_pyr_cmd.c        |  575 ++++++++++
 drivers/staging/gma500/mdfld_tmd_vid.c        |  144 +++
 drivers/staging/gma500/mdfld_tpo_cmd.c        |  495 +++++++++
 drivers/staging/gma500/mdfld_tpo_vid.c        |  140 ++
 drivers/staging/gma500/mrst.h                 |   38 -
 drivers/staging/gma500/mrst_bios.c            |  263 +++++
 drivers/staging/gma500/mrst_bios.h            |   22 
 drivers/staging/gma500/mrst_crtc.c            |   27 
 drivers/staging/gma500/mrst_device.c          |  367 ++++++
 drivers/staging/gma500/mrst_lvds.c            |   22 
 drivers/staging/gma500/power.c                |  320 ++++++
 drivers/staging/gma500/psb_2d.c               |  235 ++--
 drivers/staging/gma500/psb_bl.c               |  227 ----
 drivers/staging/gma500/psb_device.c           |  297 +++++
 drivers/staging/gma500/psb_drm.h              |  109 --
 drivers/staging/gma500/psb_drv.c              |  344 +-----
 drivers/staging/gma500/psb_drv.h              |  428 ++++----
 drivers/staging/gma500/psb_fb.c               |  492 ++++-----
 drivers/staging/gma500/psb_fb.h               |    6 
 drivers/staging/gma500/psb_gem.c              |  109 --
 drivers/staging/gma500/psb_gtt.c              |  200 +---
 drivers/staging/gma500/psb_gtt.h              |   11 
 drivers/staging/gma500/psb_intel_bios.c       |   17 
 drivers/staging/gma500/psb_intel_display.c    |  149 +--
 drivers/staging/gma500/psb_intel_display.h    |    3 
 drivers/staging/gma500/psb_intel_drv.h        |   22 
 drivers/staging/gma500/psb_intel_lvds.c       |   85 --
 drivers/staging/gma500/psb_intel_opregion.c   |   15 
 drivers/staging/gma500/psb_intel_reg.h        | 1055 +++++++++----------
 drivers/staging/gma500/psb_intel_sdvo.c       |   35 -
 drivers/staging/gma500/psb_intel_sdvo_regs.h  |   14 
 drivers/staging/gma500/psb_irq.c              |   92 +-
 drivers/staging/gma500/psb_irq.h              |    8 
 drivers/staging/gma500/psb_powermgmt.c        |  489 ---------
 drivers/staging/gma500/psb_powermgmt.h        |    2 
 drivers/staging/gma500/psb_reg.h              |  842 +++++++--------
 61 files changed, 12186 insertions(+), 3145 deletions(-)
 create mode 100644 drivers/staging/gma500/backlight.c
 create mode 100644 drivers/staging/gma500/displays/hdmi.h
 create mode 100644 drivers/staging/gma500/displays/pyr_cmd.h
 create mode 100644 drivers/staging/gma500/displays/pyr_vid.h
 create mode 100644 drivers/staging/gma500/displays/tmd_cmd.h
 create mode 100644 drivers/staging/gma500/displays/tmd_vid.h
 create mode 100644 drivers/staging/gma500/displays/tpo_cmd.h
 create mode 100644 drivers/staging/gma500/displays/tpo_vid.h
 create mode 100644 drivers/staging/gma500/gem_glue.c
 create mode 100644 drivers/staging/gma500/gem_glue.h
 create mode 100644 drivers/staging/gma500/mdfld_device.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dbi.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dbi.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dbi_dpu.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dpi.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dpi.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_output.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_output.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_pkg_sender.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_pkg_sender.h
 create mode 100644 drivers/staging/gma500/mdfld_intel_display.c
 create mode 100644 drivers/staging/gma500/mdfld_msic.h
 create mode 100644 drivers/staging/gma500/mdfld_output.c
 create mode 100644 drivers/staging/gma500/mdfld_output.h
 create mode 100644 drivers/staging/gma500/mdfld_pyr_cmd.c
 create mode 100644 drivers/staging/gma500/mdfld_tmd_vid.c
 create mode 100644 drivers/staging/gma500/mdfld_tpo_cmd.c
 create mode 100644 drivers/staging/gma500/mdfld_tpo_vid.c
 create mode 100644 drivers/staging/gma500/mrst_bios.c
 create mode 100644 drivers/staging/gma500/mrst_bios.h
 create mode 100644 drivers/staging/gma500/mrst_device.c
 create mode 100644 drivers/staging/gma500/power.c
 delete mode 100644 drivers/staging/gma500/psb_bl.c
 create mode 100644 drivers/staging/gma500/psb_device.c
 delete mode 100644 drivers/staging/gma500/psb_powermgmt.c

-- 
	"It's 106 miles to Chicago, we've got a full tank of gas, the
	 sat-nav has crashed, it's dark and we're completely lost"
