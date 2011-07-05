Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1GEOng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:43:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1GEOnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:43:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/49] GMA50 series update
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:33:48 +0100
Message-ID: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Rebased versus the patches Greg took earlier)

The main things here are modularisation and support for Cedarview (this is
unaccelerated as it has no 2D acceleration). I have some crazy ideas about using
the GTT to do 2D console acceleration however but not much can be done for X.

At this point I think the Poulsbo (GMA500) and Cedarview code are probably ready
to move out of staging - hence the modularisation work. The MID platforms need
more cleaning up.

HDMI support at this point is pretty basic with no HDMI audio support. I'm hoping
that will be something that can be addressed in future and now the basic bits
are there I need to take a look at Oaktrail (Atom Z760/GMA600) and see if the
same code can be used to bring up HDMI on that device too.

Alan



---

Alan Cox (48):
      gma500: power can be touched in IRQ state
      gma500: Fix missing memory check
      gma500: Workaround for Medfield/Cedarview cursor bug
      gma500: Fix backlight crash
      gma500: Add the HDMI bits
      gma500: begin adding CDV specific code
      gma500: move the power header
      gma500: move the BIOS header
      gma500: tidying up the power stuff a spot
      gma500: move the i2c code
      gma500: the MMU code is also generic
      gma500: move opregion files
      gma500: tidy up the opregion and lid code
      gma500: Rename the psb_intel_bios code
      gma500: begin the config based split
      gma500: the GEM and GTT code is device independant
      gma500: The 2D code is now also device independent
      gma500: move framebuffer file
      gma500: tidy the framebuffer fixme and oddments
      gma500: the 'mrst' BIOS is actually MID generic
      gma500: Add the beginnings of Cedarview support
      gma500: move configuration bits into the psb_ops structure
      gma500: remove an un-needed check
      gma500: add more ops
      gma500: enable Medfield CRTC support
      gma500: Read the GCT panel type information for Medfield
      gma500: Fix early Medfield crash
      gma500: continue abstracting platform specific code
      gma500: being abstracting out devices a bit more
      gma500: Only fiddle with clock gating on PSB
      gma500: Update the GEM todo
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
      gma500: Ensure the frame buffer has a linear virtual mapping

Jani Nikula (1):
      commit ee12661199b82934552c7636b10217a9aa42958a


 drivers/staging/gma500/Kconfig                |   27 
 drivers/staging/gma500/Makefile               |   43 +
 drivers/staging/gma500/accel_2d.c             |  358 ++++++
 drivers/staging/gma500/backlight.c            |   47 +
 drivers/staging/gma500/cdv_device.c           |  350 ++++++
 drivers/staging/gma500/cdv_intel_display.c    | 1513 +++++++++++++++++++++++++
 drivers/staging/gma500/cdv_intel_lvds.c       |  718 ++++++++++++
 drivers/staging/gma500/displays/hdmi.h        |   33 +
 drivers/staging/gma500/displays/pyr_cmd.h     |   34 +
 drivers/staging/gma500/displays/pyr_vid.h     |   34 +
 drivers/staging/gma500/displays/tmd_cmd.h     |   34 +
 drivers/staging/gma500/displays/tmd_vid.h     |   34 +
 drivers/staging/gma500/displays/tpo_cmd.h     |   35 +
 drivers/staging/gma500/displays/tpo_vid.h     |   33 +
 drivers/staging/gma500/framebuffer.c          |  810 +++++++++++++
 drivers/staging/gma500/framebuffer.h          |   49 +
 drivers/staging/gma500/gem.c                  |  252 ++++
 drivers/staging/gma500/gem_glue.c             |  110 ++
 drivers/staging/gma500/gem_glue.h             |    4 
 drivers/staging/gma500/gtt.c                  |  510 ++++++++
 drivers/staging/gma500/gtt.h                  |   62 +
 drivers/staging/gma500/intel_bios.c           |  303 +++++
 drivers/staging/gma500/intel_bios.h           |  430 +++++++
 drivers/staging/gma500/intel_i2c.c            |  169 +++
 drivers/staging/gma500/intel_opregion.c       |   80 +
 drivers/staging/gma500/mdfld_device.c         |  713 ++++++++++++
 drivers/staging/gma500/mdfld_dsi_dbi.c        |  872 ++++++++++++++
 drivers/staging/gma500/mdfld_dsi_dbi.h        |  188 +++
 drivers/staging/gma500/mdfld_dsi_dbi_dpu.h    |  157 +++
 drivers/staging/gma500/mdfld_dsi_dpi.c        |  991 ++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_dpi.h        |   80 +
 drivers/staging/gma500/mdfld_dsi_output.c     |  980 ++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_output.h     |  328 +++++
 drivers/staging/gma500/mdfld_dsi_pkg_sender.c | 1097 ++++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_pkg_sender.h |  158 +++
 drivers/staging/gma500/mdfld_intel_display.c  | 1415 +++++++++++++++++++++++
 drivers/staging/gma500/mdfld_msic.h           |   31 +
 drivers/staging/gma500/mdfld_output.c         |  144 ++
 drivers/staging/gma500/mdfld_output.h         |   80 +
 drivers/staging/gma500/mdfld_pyr_cmd.c        |  575 ++++++++++
 drivers/staging/gma500/mdfld_tmd_vid.c        |  144 ++
 drivers/staging/gma500/mdfld_tpo_cmd.c        |  495 ++++++++
 drivers/staging/gma500/mdfld_tpo_vid.c        |  140 ++
 drivers/staging/gma500/mid_bios.c             |  271 ++++
 drivers/staging/gma500/mid_bios.h             |   21 
 drivers/staging/gma500/mmu.c                  |  858 ++++++++++++++
 drivers/staging/gma500/mrst.h                 |   38 -
 drivers/staging/gma500/mrst_crtc.c            |   31 -
 drivers/staging/gma500/mrst_device.c          |  377 ++++++
 drivers/staging/gma500/mrst_lvds.c            |   26 
 drivers/staging/gma500/power.c                |  315 +++++
 drivers/staging/gma500/power.h                |   67 +
 drivers/staging/gma500/psb_2d.c               |  410 -------
 drivers/staging/gma500/psb_bl.c               |  227 ----
 drivers/staging/gma500/psb_device.c           |  352 ++++++
 drivers/staging/gma500/psb_drm.h              |  109 --
 drivers/staging/gma500/psb_drv.c              |  419 +------
 drivers/staging/gma500/psb_drv.h              |  460 +++++---
 drivers/staging/gma500/psb_fb.c               |  834 --------------
 drivers/staging/gma500/psb_fb.h               |   49 -
 drivers/staging/gma500/psb_gem.c              |  308 -----
 drivers/staging/gma500/psb_gtt.c              |  539 ---------
 drivers/staging/gma500/psb_gtt.h              |   61 -
 drivers/staging/gma500/psb_intel_bios.c       |  306 -----
 drivers/staging/gma500/psb_intel_bios.h       |  430 -------
 drivers/staging/gma500/psb_intel_display.c    |  164 +--
 drivers/staging/gma500/psb_intel_display.h    |    3 
 drivers/staging/gma500/psb_intel_drv.h        |   24 
 drivers/staging/gma500/psb_intel_i2c.c        |  169 ---
 drivers/staging/gma500/psb_intel_lvds.c       |   91 --
 drivers/staging/gma500/psb_intel_opregion.c   |   78 -
 drivers/staging/gma500/psb_intel_reg.h        | 1144 ++++++++++---------
 drivers/staging/gma500/psb_intel_sdvo.c       |   35 -
 drivers/staging/gma500/psb_intel_sdvo_regs.h  |   14 
 drivers/staging/gma500/psb_irq.c              |   99 +-
 drivers/staging/gma500/psb_irq.h              |    8 
 drivers/staging/gma500/psb_lid.c              |    6 
 drivers/staging/gma500/psb_mmu.c              |  858 --------------
 drivers/staging/gma500/psb_powermgmt.c        |  489 --------
 drivers/staging/gma500/psb_powermgmt.h        |   67 -
 drivers/staging/gma500/psb_reg.h              |  842 +++++++-------
 81 files changed, 18550 insertions(+), 6709 deletions(-)
 create mode 100644 drivers/staging/gma500/accel_2d.c
 create mode 100644 drivers/staging/gma500/backlight.c
 create mode 100644 drivers/staging/gma500/cdv_device.c
 create mode 100644 drivers/staging/gma500/cdv_intel_display.c
 create mode 100644 drivers/staging/gma500/cdv_intel_lvds.c
 create mode 100644 drivers/staging/gma500/displays/hdmi.h
 create mode 100644 drivers/staging/gma500/displays/pyr_cmd.h
 create mode 100644 drivers/staging/gma500/displays/pyr_vid.h
 create mode 100644 drivers/staging/gma500/displays/tmd_cmd.h
 create mode 100644 drivers/staging/gma500/displays/tmd_vid.h
 create mode 100644 drivers/staging/gma500/displays/tpo_cmd.h
 create mode 100644 drivers/staging/gma500/displays/tpo_vid.h
 create mode 100644 drivers/staging/gma500/framebuffer.c
 create mode 100644 drivers/staging/gma500/framebuffer.h
 create mode 100644 drivers/staging/gma500/gem.c
 create mode 100644 drivers/staging/gma500/gem_glue.c
 create mode 100644 drivers/staging/gma500/gem_glue.h
 create mode 100644 drivers/staging/gma500/gtt.c
 create mode 100644 drivers/staging/gma500/gtt.h
 create mode 100644 drivers/staging/gma500/intel_bios.c
 create mode 100644 drivers/staging/gma500/intel_bios.h
 create mode 100644 drivers/staging/gma500/intel_i2c.c
 create mode 100644 drivers/staging/gma500/intel_opregion.c
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
 create mode 100644 drivers/staging/gma500/mid_bios.c
 create mode 100644 drivers/staging/gma500/mid_bios.h
 create mode 100644 drivers/staging/gma500/mmu.c
 create mode 100644 drivers/staging/gma500/mrst_device.c
 create mode 100644 drivers/staging/gma500/power.c
 create mode 100644 drivers/staging/gma500/power.h
 delete mode 100644 drivers/staging/gma500/psb_2d.c
 delete mode 100644 drivers/staging/gma500/psb_bl.c
 create mode 100644 drivers/staging/gma500/psb_device.c
 delete mode 100644 drivers/staging/gma500/psb_fb.c
 delete mode 100644 drivers/staging/gma500/psb_fb.h
 delete mode 100644 drivers/staging/gma500/psb_gem.c
 delete mode 100644 drivers/staging/gma500/psb_gtt.c
 delete mode 100644 drivers/staging/gma500/psb_gtt.h
 delete mode 100644 drivers/staging/gma500/psb_intel_bios.c
 delete mode 100644 drivers/staging/gma500/psb_intel_bios.h
 delete mode 100644 drivers/staging/gma500/psb_intel_i2c.c
 delete mode 100644 drivers/staging/gma500/psb_intel_opregion.c
 delete mode 100644 drivers/staging/gma500/psb_mmu.c
 delete mode 100644 drivers/staging/gma500/psb_powermgmt.c
 delete mode 100644 drivers/staging/gma500/psb_powermgmt.h

-- 
Signature
