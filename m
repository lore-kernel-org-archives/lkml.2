Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2E3KM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:12:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33008 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab2E3KM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:12:27 -0400
Date: Wed, 30 May 2012 11:12:25 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1205301110550.26588@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-2080927463-1338372745=:26588"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-2080927463-1338372745=:26588
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

just regular fixes, bunch from intel, quieting some of the over zealous 
power warnings, and the rest just misc.

I've got another pull with the remaining dma-buf bits, since the vmap bits 
are in your tree now. I'll send tomorrow just to space things out a bit.

Dave.

The following changes since commit a01ee165a132fadb57659d26246e340d6ac53265:

  Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd (2012-05-28 13:10:41 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to bc42aabc6a01b92b0f961d65671564e0e1cd7592:

  drm/edid/quirks: ViewSonic VA2026w (2012-05-29 16:16:38 +0100)

----------------------------------------------------------------
Adam Jackson (1):
      drm/edid/quirks: ViewSonic VA2026w

Alex Deucher (2):
      drm/radeon: fix typo in trinity tiling setup
      drm/radeon: fix XFX quirk

Chris Wilson (4):
      drm/i915: Always update RPS interrupts thresholds along with frequency
      drm/i915: Fix PCH PLL assertions to not assume CRTC:PLL relationship
      drm/i915: Limit page allocations to lowmem (dma32) for i965
      drm/i915: Remove the error message for unbinding pinned buffers

Dan Carpenter (1):
      drm/udl: unlock before returning in udl_gem_mmap()

Daniel Vetter (7):
      drm/i915: be more careful when returning -ENXIO in gmbus transfer
      drm/i915: fix module unload since error_state rework
      drm/i915: properly handle interlaced bit for sdvo dtd conversion
      drm/i915: enable vdd when switching off the eDP panel
      drm/i915: wait for a vblank to pass after tv detect
      drm/i915: reject doubleclocked cea modes on dp
      drm/i915: tune down the noise of the RP irq limit fail

Dave Airlie (3):
      radeon: make radeon_cs_update_pages static.
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      drm/udl: remove unused variables.

Jan-Benedict Glaw (1):
      drm/i915: no lvds quirk for HP t5740e Thin Client

Jesse Barnes (1):
      drm/i915: always use RPNSWREQ for turbo change requests

Rodrigo Vivi (1):
      drm/i915: Adding TV Out Missing modes.

Ville Syrjälä (2):
      drm: Constify params to format_check() and framebuffer_checks()
      drm: Use stdint types for consistency

 drivers/gpu/drm/drm_crtc.c               |    8 ++--
 drivers/gpu/drm/drm_edid.c               |   22 ++++++++--
 drivers/gpu/drm/i915/i915_debugfs.c      |    2 +
 drivers/gpu/drm/i915/i915_gem.c          |   16 +++++---
 drivers/gpu/drm/i915/i915_irq.c          |   37 ++++-------------
 drivers/gpu/drm/i915/intel_display.c     |   56 +++++++++++++++-----------
 drivers/gpu/drm/i915/intel_dp.c          |   24 ++++++-----
 drivers/gpu/drm/i915/intel_i2c.c         |   21 +++++-----
 drivers/gpu/drm/i915/intel_lvds.c        |    8 ++++
 drivers/gpu/drm/i915/intel_pm.c          |   64 ++++++++++++++++++++----------
 drivers/gpu/drm/i915/intel_sdvo.c        |   12 ++++--
 drivers/gpu/drm/i915/intel_sdvo_regs.h   |    5 +++
 drivers/gpu/drm/i915/intel_tv.c          |   53 +++++++++++++++++++++++++
 drivers/gpu/drm/radeon/ni.c              |    2 +-
 drivers/gpu/drm/radeon/radeon.h          |    1 -
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 +-
 drivers/gpu/drm/radeon/radeon_cs.c       |   27 ++++++++++++-
 drivers/gpu/drm/radeon/radeon_ring.c     |   25 ------------
 drivers/gpu/drm/udl/udl_gem.c            |    4 +-
 19 files changed, 250 insertions(+), 141 deletions(-)
--29444707-2080927463-1338372745=:26588--
