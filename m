Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab1ALGDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:03:42 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40358 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab1ALGDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:03:40 -0500
Date: Wed, 12 Jan 2011 06:03:16 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel only fixes
Message-ID: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1118229598-1294812196=:6210"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1118229598-1294812196=:6210
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


I'm stuck at home with just my i5 laptop due to the office being shut due 
to the ongoing floods. But I've booted and ran this for a few hours and it
seems to be better than the current tree. It contains a couple of patches 
to fix DMAR interaction issues I see on this laptop on top of Chris's 
pull.

Dave.

The following changes since commit 4162cf64973df51fc885825bc9ca4d055891c49f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-01-11 16:32:41 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Chris Wilson (25):
      drm/i915/sdvo: Defer detection of output capabilities until probing
      drm/i915/panel: Only record the backlight level when it is enabled
      drm/i915/lvds: Always use 0 to disable the pfit controller
      drm/i915: Use the mappable sizes determined by GTT for consistency.
      drm/i915: Workaround erratum on i830 for TAIL pointer within last 2 cachelines
      agp/intel: Flush the chipset write buffers when changing GTT base
      drm/i915: add 'reset' parameter
      drm/i915: Remove impossible test
      drm/i915: Enforce write ordering through the GTT
      drm/i915: Handle ringbuffer stalls when flushing
      drm/i915: Mask USER interrupts on gen6 (until required)
      drm/i915/debugfs: Show the per-ring IMR
      drm/i915/ringbuffer: Simplify the ring irq refcounting
      drm/i915: Make the ring IMR handling private
      drm/i915: Propagate error from flushing the ring
      drm/i915: Include TLB miss overhead for computing WM
      drm/i915: Record the error batchbuffer on each ring
      drm/i915/gtt: Unmap the PCI pages after unbinding them from the GTT
      drm/i915: Periodically flush the active lists and requests
      drm/i915: Record AGP memory type upon error
      drm/i915/debugfs: Show all objects in the gtt
      drm/i915/execbuffer: Correctly clear the current object list upon EFAULT
      drm/i915/evict: Ensure we completely cleanup on failure
      drm/i915: If we hit OOM when allocating GTT pages, clear the aperture
      drm/i915/execbuffer: Reorder binding of objects to favour restrictions

Dave Airlie (3):
      Merge branch 'drm-intel-fixes' of ssh://master.kernel.org/.../ickle/drm-intel
      i915/gtt: fix ordering issues with status setup and DMAR
      i915/gtt: fix ordering causing DMAR errors on object teardown.

David Müller (1):
      drm/i915/crt: Check for a analog monitor in case of DVI-I

Jesse Barnes (9):
      drm/i915: check eDP encoder correctly when setting modes
      drm/i915: make DP training try a little harder
      drm/i915: support overclocking on Sandy Bridge
      drm/i915: support low power watermarks on Ironlake
      drm/i915: avoid reading non-existent PLL reg on Ironlake+
      drm/i915: re-enable rc6 support for Ironlake+
      drm/i915: fix rc6 enabling around suspend/resume
      drm/i915: cleanup rc6 code
      drm/i915: detect & report PCH display error interrupts

Yuanhan Liu (2):
      drm/i915: fix calculation of eDP signal levels on Sandybridge
      drm/i915: fix the wrong latency value while computing wm0

 drivers/char/agp/intel-agp.h               |    2 +
 drivers/char/agp/intel-gtt.c               |   17 +-
 drivers/gpu/drm/i915/i915_debugfs.c        |   87 +++++-
 drivers/gpu/drm/i915/i915_dma.c            |    8 -
 drivers/gpu/drm/i915/i915_drv.c            |    9 +
 drivers/gpu/drm/i915/i915_drv.h            |   24 +-
 drivers/gpu/drm/i915/i915_gem.c            |  156 +++++++---
 drivers/gpu/drm/i915/i915_gem_evict.c      |    9 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |  119 +++++---
 drivers/gpu/drm/i915/i915_gem_gtt.c        |   10 +-
 drivers/gpu/drm/i915/i915_irq.c            |  269 +++++++-----------
 drivers/gpu/drm/i915/i915_reg.h            |   95 ++++++-
 drivers/gpu/drm/i915/i915_suspend.c        |    8 +-
 drivers/gpu/drm/i915/intel_crt.c           |   30 ++-
 drivers/gpu/drm/i915/intel_display.c       |  434 ++++++++++++++++------------
 drivers/gpu/drm/i915/intel_dp.c            |   50 +++-
 drivers/gpu/drm/i915/intel_drv.h           |    3 +
 drivers/gpu/drm/i915/intel_fb.c            |   20 +-
 drivers/gpu/drm/i915/intel_lvds.c          |   14 +-
 drivers/gpu/drm/i915/intel_panel.c         |   31 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c    |  255 ++++++++++++-----
 drivers/gpu/drm/i915/intel_ringbuffer.h    |   36 ++-
 drivers/gpu/drm/i915/intel_sdvo.c          |   33 +--
 23 files changed, 1082 insertions(+), 637 deletions(-)
--29444707-1118229598-1294812196=:6210--
