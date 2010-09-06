Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0IFIa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:30:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:51308 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab0IFIa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:30:27 -0400
Message-Id: <89kc63$i063ms@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,324,1280732400"; 
   d="scan'208";a="604180188"
Date: Mon, 06 Sep 2010 09:30:23 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [git pull] i915
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

in order to reduce the burden upon Eric and to try and feed patches
upstream in a more timely manner I volunteered to take over maintaining
the upstream i915 branches.

This batch of fixes include the timing fixes for the fallout from the
conversion of intel_wait_for_vblank() and the error checking for SDVO
modesetting. It also includes a [double dose] of module unload oopsen
fixes from Daniel Vetter, more work by Jesse on bringing eDP machines to
life and some of my pending fixes from bugzilla.

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://anongit.freedesktop.org/~ickle/drm-intel drm-intel-fixes

Chris Wilson (22):
      agp/intel: Promote warning about failure to setup flush to error.
      drm/i915: Drop the msleep parameter to wait_for()
      drm/i915: Avoid using msleep under kdb and wait_for()
      drm/i915: Include a generation number in the device info
      drm/i915: Fix offset page-flips on i965+
      drm/i915: Re-use set_base_atomic to share setting of the display registers
      drm/i915/crt: Flush register prior to waiting for vblank.
      drm/i915/dp: Boost timeout for enabling transcoder to 100ms
      drm/i915/sdvo: Guess the DDC bus in absence of VBIOS
      drm/i915/tv: Flush register writes before sleeping.
      drm/i915/dp: Really try 5 times before giving up.
      drm/i915: Allocate the PCI resource for the MCHBAR
      drm/i915: Rename i915_opregion.c to intel_opregion.c
      drm/i915: Use the VBT from OpRegion when available (v3)
      drm/i915: Addin-offset is an unreliable indicator of LVDS presence (v2)
      drm/i915: Tightly scope intel_encoder to prevent invalid use
      drm/i915: Ironlake page-flipping is per-plane not per-pipe
      drm/i915: Avoid use of uninitialised values when disabling panel-fitter
      Merge remote branch 'jbarnes/edp-testing' into drm-intel-fixes
      drm/i915/dp: Flush the PLL register write before udelay()
      drm/i915/dp: Remove unused variables
      drm/i915: Clear the vblank status bit before polling for the next vblank

Dan Carpenter (2):
      i915: return -EFAULT if copy_to_user fails
      i915: return -EFAULT if copy_to_user fails

Daniel Vetter (17):
      drm/i915: unload: fix intel dp encoder cleanup
      drm/i915: unload: fix error_work races
      drm/i915: unload: fix hotplug_work races
      drm/i915: unload: don't leak error state
      drm/i915: unload: fix idle_timer/idle_work races
      drm/i915: unload: fix unpin_work related races
      drm/i915: unload: ensure that gem is idle
      drm/i915: unload: fix retire_work races
      drm/i915: overlay on gen2 can't address above 1G
      drm/i915: unload: fix intel dp encoder cleanup
      drm/i915: unload: fix error_work races
      drm/i915: unload: fix hotplug_work races
      drm/i915: unload: don't leak error state
      drm/i915: unload: fix idle_timer/idle_work races
      drm/i915: unload: fix unpin_work related races
      drm/i915: unload: ensure that gem is idle
      drm/i915: unload: fix retire_work races

Jesse Barnes (8):
      drm/i915: fix eDP detection
      drm/i915: fix vblank wait test condition
      drm/i915: use 125MHz reference clock for PCH attached eDP
      drm/i915: use VDD AUX for panel power around detection and in prepare
      drm/i915: split DP link training across panel power sequencing
      drm/i915: don't change VDD AUX status in panel power functions
      drm/i915: make sure VDD AUX power has time to settle
      drm/i915: make sure panel is sequenced off when starting a mode set

Pavel Roskin (1):
      i915: revert some checks added by commit 32aad86f

Pekka Enberg (1):
      i915: Fix spurious TV detection after 9d0498a2bf + 9559fcdbff

Simon Farnsworth (1):
      drm/i915: Avoid pageflipping freeze when we miss the flip prepare interrupt

Sitsofe Wheeler (1):
      drm/i915: Revert extra intel_wait_for_vblank to prevent stalls.

 drivers/char/agp/intel-gtt.c                       |    8 +-
 drivers/gpu/drm/i915/Makefile                      |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   71 +++++
 drivers/gpu/drm/i915/i915_dma.c                    |   71 ++++--
 drivers/gpu/drm/i915/i915_drv.c                    |   68 ++---
 drivers/gpu/drm/i915/i915_drv.h                    |   54 ++---
 drivers/gpu/drm/i915/i915_gem.c                    |    5 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   63 ++++-
 drivers/gpu/drm/i915/intel_bios.c                  |   73 +++--
 drivers/gpu/drm/i915/intel_crt.c                   |    5 +-
 drivers/gpu/drm/i915/intel_display.c               |  305 ++++++++++----------
 drivers/gpu/drm/i915/intel_dp.c                    |  240 ++++++++++------
 drivers/gpu/drm/i915/intel_drv.h                   |   17 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   50 ++--
 .../drm/i915/{i915_opregion.c => intel_opregion.c} |  120 ++++----
 drivers/gpu/drm/i915/intel_sdvo.c                  |   69 ++++--
 drivers/gpu/drm/i915/intel_tv.c                    |   14 +-
 17 files changed, 745 insertions(+), 490 deletions(-)
 rename drivers/gpu/drm/i915/{i915_opregion.c => intel_opregion.c} (92%)

-- 
Chris Wilson, Intel Open Source Technology Centre
