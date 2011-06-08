Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1FHKXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:23:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60856 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1FHKXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:23:18 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/15] GMA500 KMS and GEM
To: greg@kroah.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Wed, 08 Jun 2011 11:10:54 +0100
Message-ID: <20110608100411.9478.86672.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series versus linux-next 2011/06/08 fixes various bugs including a
nasty pinning bug found by Andre Bartke.

With these patches applied the driver passes the various GEM tests and you can
use the KMS tools and test sets to set modes and display stuff from GEM
buffers including those mapped from main memory via the GTT.

You can't yet take a GEM handle of the system frame buffer. That requires
a trivial patch to drm_gem and a similar trivial patch to this driver.

The two main remaining tasks now are to provide a 2D command interface for the
X server including support for blitting between GEM objects (so we need relocs)
and to clean the code up.

Vblank support is also possible but doesn't seem terribly useful.
---

Alan Cox (12):
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

Michael Chang (1):
      staging/gma500: get control from firmware framebuffer if conflicts

Patrik Jakobsson (1):
      gma500: Skip bogus LVDS VBT mode and check for LVDS before adding backlight


 drivers/staging/gma500/mrst_crtc.c          |   27 +-
 drivers/staging/gma500/mrst_lvds.c          |   14 -
 drivers/staging/gma500/psb_2d.c             |   39 +--
 drivers/staging/gma500/psb_bl.c             |   12 -
 drivers/staging/gma500/psb_drm.h            |   90 --------
 drivers/staging/gma500/psb_drv.c            |   58 ++---
 drivers/staging/gma500/psb_drv.h            |  181 ++++------------
 drivers/staging/gma500/psb_fb.c             |  309 +++++++++++++++------------
 drivers/staging/gma500/psb_fb.h             |    6 -
 drivers/staging/gma500/psb_gem.c            |   39 +--
 drivers/staging/gma500/psb_gtt.c            |  187 ++++++----------
 drivers/staging/gma500/psb_gtt.h            |   11 +
 drivers/staging/gma500/psb_intel_bios.c     |   26 +-
 drivers/staging/gma500/psb_intel_display.c  |  130 +++--------
 drivers/staging/gma500/psb_intel_drv.h      |   19 --
 drivers/staging/gma500/psb_intel_lvds.c     |   53 +----
 drivers/staging/gma500/psb_intel_opregion.c |    7 -
 drivers/staging/gma500/psb_intel_sdvo.c     |   34 +--
 drivers/staging/gma500/psb_irq.c            |   33 +--
 drivers/staging/gma500/psb_irq.h            |    8 -
 drivers/staging/gma500/psb_powermgmt.c      |    4 
 drivers/staging/gma500/psb_powermgmt.h      |    2 
 drivers/staging/gma500/psb_reg.h            |    2 
 23 files changed, 461 insertions(+), 830 deletions(-)

-- 
Signature
