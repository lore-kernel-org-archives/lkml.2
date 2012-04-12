Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613Ab2DLH15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:27:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58662 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760840Ab2DLH14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:27:56 -0400
Date: Thu, 12 Apr 2012 09:28:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [pull] drm-intel-fixes for 3.4-rc3
Message-ID: <20120412072848.GC3705@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave

3 regression fixes:
- disable gmbus again, too broken for 3.4, we'll try again for 3.5
- dp bandwidth computation fix, we've lost the 6bpc dithering flag
  sometimes, this is a 3.3 regression (maybe even earlier for some
  configurations).
- fix resume regression caused by the gen2/3 fencing fix merged into -rc2.

And a few other fixes:
- gpu hang fix for i845 (Chris)
- sprite fix (Armin Reese)
- crtc disable vs. scanlinewait race fix (Chris)
- rc6 module option read-only, it confused testers (Jesse)
- fbc related blitter death hw workaround, note that we disable fbc on snb
  by default anyway.

With these fixes we have one 3.4 regression outstanding: One of the
cleanup patches for the interlaced support managed to confuse the lvds
panel fitter when upscaling. The root-cause is still unclear, but test
patches are awaiting feedback from the reporter.

Yours, Daniel

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to 15a13bbdffb0d6288a5dd04aee9736267da1335f:

  drm/i915: clear fencing tracking state when retiring requests (2012-04-12 09:02:37 +0200)

----------------------------------------------------------------
Chris Wilson (2):
      drm/i915: Finish any pending operations on the framebuffer before disabling
      drm/i915/ringbuffer: Exclude last 2 cachlines of ring on 845g

Daniel Vetter (4):
      drm/i915: properly compute dp dithering for user-created modes
      Revert "drm/i915: reenable gmbus on gen3+ again"
      drm/i915: implement ColorBlt w/a
      drm/i915: clear fencing tracking state when retiring requests

Jesse Barnes (1):
      drm/i915: make rc6 module parameter read-only

acreese (1):
      drm/i915: Removed IVB forced enable of sprite dest key.

 drivers/gpu/drm/i915/i915_drv.c         |    2 +-
 drivers/gpu/drm/i915/i915_gem.c         |    2 +
 drivers/gpu/drm/i915/i915_reg.h         |    3 +
 drivers/gpu/drm/i915/intel_display.c    |   69 ++++++++++++++++++++++--------
 drivers/gpu/drm/i915/intel_dp.c         |   49 ++++++++++++++++------
 drivers/gpu/drm/i915/intel_i2c.c        |    2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c |    2 +-
 drivers/gpu/drm/i915/intel_sprite.c     |    1 -
 8 files changed, 93 insertions(+), 37 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
