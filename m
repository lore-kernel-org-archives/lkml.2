Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0IGK4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:56:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:51633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab0IGK4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:56:15 -0400
Message-Id: <8u3s94$geldgp@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,328,1280732400"; 
   d="scan'208";a="552252953"
Date: Tue, 07 Sep 2010 11:55:58 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull v2] i915
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <89kc63$i063ms@fmsmga002.fm.intel.com> <AANLkTi=pFSB5AfqXbPNUQUknbnCBwqUHdUVzR6jaZqaQ@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTi=pFSB5AfqXbPNUQUknbnCBwqUHdUVzR6jaZqaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I've gone over the set of patches and removed any that are not a
regression, hang, compilation or other stability fix. I have left one in
from Zhenyu that adds new PCI-IDs for Sandybridge.

I've dropped the eDP patches from Jesse as the machine should still be
usable in spite of the blank panel. And they are not yet a complete set of
patches, there are still failing eDP machines.

Daniel requested that his module unload patches be dropped as although
they fix oopses, they should not impact ordinary users.

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://anongit.freedesktop.org/~ickle/drm-intel drm-intel-fixes

Andrew Morton (1):
      drivers/gpu/drm/i915/intel_overlay.c needs seq_file.h

Chris Wilson (13):
      Revert "drm/i915: Unreference object not handle on creation"
      drm/i915: Clear the vblank status bit before polling for the next vblank
      agp/intel: Promote warning about failure to setup flush to error.
      drm/i915: Include a generation number in the device info
      drm/i915: Fix offset page-flips on i965+
      drm/i915: Re-use set_base_atomic to share setting of the display registers
      drm/i915/dp: Boost timeout for enabling transcoder to 100ms
      drm/i915/sdvo: Restore guess of the DDC bus in absence of VBIOS
      drm/i915/dp: Really try 5 times before giving up.
      drm/i915: Allocate the PCI resource for the MCHBAR
      drm/i915: Tightly scope intel_encoder to prevent invalid use
      drm/i915: Avoid use of uninitialised values when disabling panel-fitter
      drm/i915: Prevent double dpms on

Dan Carpenter (2):
      i915: return -EFAULT if copy_to_user fails
      i915: return -EFAULT if copy_to_user fails

Daniel Vetter (1):
      drm/i915: overlay on gen2 can't address above 1G

Pavel Roskin (1):
      i915: revert some checks added by commit 32aad86f

Pekka Enberg (1):
      i915: Fix spurious TV detection after 9d0498a2bf + 9559fcdbff

Simon Farnsworth (1):
      drm/i915: Avoid pageflipping freeze when we miss the flip prepare interrupt

Zhenyu Wang (5):
      agp/intel: fix physical address mask bits for sandybridge
      agp/intel: use #ifdef idiom for intel-agp.h
      agp/intel: Fix cache control for Sandybridge
      drm/i915: Enable MI_FLUSH on Sandybridge
      intel_agp,i915: Add more sandybridge graphics device ids

 drivers/char/agp/intel-agp.c            |   16 ++-
 drivers/char/agp/intel-agp.h            |   22 ++-
 drivers/char/agp/intel-gtt.c            |   66 ++++++---
 drivers/gpu/drm/i915/i915_debugfs.c     |   50 +++++++
 drivers/gpu/drm/i915/i915_dma.c         |   36 +++--
 drivers/gpu/drm/i915/i915_drv.c         |   65 ++++----
 drivers/gpu/drm/i915/i915_drv.h         |   27 +---
 drivers/gpu/drm/i915/i915_gem.c         |   11 +-
 drivers/gpu/drm/i915/i915_irq.c         |   51 ++++++-
 drivers/gpu/drm/i915/i915_reg.h         |    1 +
 drivers/gpu/drm/i915/intel_display.c    |  244 ++++++++++++++-----------------
 drivers/gpu/drm/i915/intel_dp.c         |   58 ++++----
 drivers/gpu/drm/i915/intel_drv.h        |   10 ++
 drivers/gpu/drm/i915/intel_overlay.c    |    2 +
 drivers/gpu/drm/i915/intel_ringbuffer.c |    8 +-
 drivers/gpu/drm/i915/intel_sdvo.c       |   69 +++++++--
 drivers/gpu/drm/i915/intel_tv.c         |    9 +-
 include/linux/intel-gtt.h               |   20 +++
 18 files changed, 479 insertions(+), 286 deletions(-)
 create mode 100644 include/linux/intel-gtt.h
-- 
Chris Wilson, Intel Open Source Technology Centre
