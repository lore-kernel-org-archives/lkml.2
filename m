Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2DSNHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:07:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34331 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab2DSNH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:07:29 -0400
Date: Thu, 19 Apr 2012 15:08:27 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: [pull] drm-intel-fixes for 3.4-rc4
Message-ID: <20120419130827.GE4256@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Just 3 fixes this time around:
- Regression fix for upscaled lvds modes on older machines, the clean-up
  of our crtc timing handling from the interlaced patches screwed things
  up there.
- Locking fix in lastclose, prevents an oops.
- Black panel on vt switch due to pageflip when upscaling fix for snb.

Wrt regressions from 3.4 I'm only aware of a funky report that might
implies rc6 in sometimes causing resume failures, but it's not yet clear
what's going on there.

Yours, Daniel
on vt switch 
The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to 99d9acdd0c5ce970eaf8e8671c0bc4cb7c6fb0c1:

  drm/i915: Do not set "Enable Panel Fitter" on SNB pageflips (2012-04-18 10:30:47 +0200)

----------------------------------------------------------------
Chris Wilson (2):
      drm/i915: Hold mode_config lock whilst changing mode for lastclose()
      drm/i915: Do not set "Enable Panel Fitter" on SNB pageflips

Daniel Vetter (1):
      drm/i915: don't clobber the special upscaling lvds timings

 drivers/gpu/drm/i915/intel_display.c |   15 ++++++++++++---
 drivers/gpu/drm/i915/intel_drv.h     |    4 ++++
 drivers/gpu/drm/i915/intel_fb.c      |    4 ++++
 drivers/gpu/drm/i915/intel_lvds.c    |    6 ++++++
 drivers/gpu/drm/i915/intel_panel.c   |    2 --
 5 files changed, 26 insertions(+), 5 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
