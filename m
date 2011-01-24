Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1AXXTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:19:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55080 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab1AXXTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:19:47 -0500
Date: Mon, 24 Jan 2011 23:19:23 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.1101242317050.29414@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1859150887-1295911163=:29414"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1859150887-1295911163=:29414
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Mostly i915 serious fixes, along with some minor radeon changes.

(no global header files touched ;-)

Dave.

The following changes since commit d315777b32a4696feb86f2a0c9e9f39c94683649:

  Merge branch 'BUG_ON' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus (2011-01-24 19:58:39 +1000)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (5):
      drm/radeon/kms: fix a spelling error in an error message
      drm/radeon/kms: make the mac rv630 quirk generic
      drm/radeon/kms: match r6xx/r7xx/evergreen asic_reset with previous asics
      drm/radeon/kms: simplify atom adjust pll setup
      drm/radeon/kms: add new radeon_info ioctl query for clock crystal freq

Chris Wilson (12):
      drm/i915: Initialise ring vfuncs for old DRI paths
      drm/i915: Add dependency on CONFIG_TMPFS
      drm/i915: Don't kick-off hangcheck after a DRI interrupt
      drm/i915/ringbuffer: Fix use of stale HEAD position whilst polling for space
      drm/i915: Fix use of invalid array size for ring->sync_seqno
      drm/i915: Recognise non-VGA display devices
      drm/i915,agp/intel: Do not clear stolen entries
      drm/i915: Increase the amount of defense before computing vblank timestamps
      drm/i915: Disable high-precision vblank timestamping for UMS
      drm/i915: Handle the no-interrupts case for UMS by polling
      Merge remote branch 'linus/master' into drm-intel-fixes
      drm/i915: Prevent uninitialised reads during error state capture

Dave Airlie (1):
      Merge branch 'drm-intel-fixes-2' of ssh://master.kernel.org/.../ickle/drm-intel into drm-fixes

Jesse Barnes (2):
      drm/i915: set more FBC chicken bits
      drm/i915: make the blitter report buffer modifications to the FBC unit

Michael Karcher (1):
      drm/i915: Use consistent mappings for OpRegion between ACPI and i915

Michel Dänzer (1):
      drm/radeon/kms: Initialize pageflip spinlocks.

 drivers/char/agp/intel-gtt.c               |   19 +++---
 drivers/gpu/drm/Kconfig                    |    3 +
 drivers/gpu/drm/i915/i915_dma.c            |   35 +++++-------
 drivers/gpu/drm/i915/i915_drv.c            |    5 +-
 drivers/gpu/drm/i915/i915_drv.h            |    5 +-
 drivers/gpu/drm/i915/i915_gem.c            |   12 +++-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c        |    4 +
 drivers/gpu/drm/i915/i915_irq.c            |   37 +++++++++---
 drivers/gpu/drm/i915/i915_reg.h            |    6 ++
 drivers/gpu/drm/i915/intel_display.c       |   25 ++++++++-
 drivers/gpu/drm/i915/intel_opregion.c      |    3 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c    |   83 ++++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_ringbuffer.h    |    3 +
 drivers/gpu/drm/radeon/atombios_crtc.c     |   22 ++------
 drivers/gpu/drm/radeon/evergreen.c         |    3 +
 drivers/gpu/drm/radeon/r100.c              |    2 +-
 drivers/gpu/drm/radeon/r600.c              |    3 +
 drivers/gpu/drm/radeon/radeon_atombios.c   |   14 ++---
 drivers/gpu/drm/radeon/radeon_drv.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c    |    3 +
 drivers/gpu/drm/radeon/radeon_kms.c        |    4 +
 drivers/gpu/vga/vgaarb.c                   |    2 +-
 include/drm/radeon_drm.h                   |    1 +
 24 files changed, 203 insertions(+), 95 deletions(-)
--29444707-1859150887-1295911163=:29414--
