Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab2EXPzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:55:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213Ab2EXPzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:55:06 -0400
Date: Thu, 24 May 2012 17:56:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [pull] drm-intel-fixes for 3.5
Message-ID: <20120524155624.GD5078@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

A set of fixes for 3.5:
- Fixes for regressions in 3.5: fix spurious gmbus NAK, fix module unload,
  fix pch pll asserts.
- Fix up eDP panel power sequencing - turns out we need to keep vdd on
  while switching everything off.
- Reject doubleclocked modes on dp.
- Fixup sdvo interlaced handling. It never worked, but the missing bits
  are just a tiny patch.
- Re-add some accidentally killed tv modes, also re-add
  a vblank wait in the tv detect code that we've lost somewhere around
  2.6.36.
- Preliminary ducttape for gpu turbo on snb+ - we're working the hw guys
  to figure out what's missing, because this code /should/ be the same the
  windows driver does. But that usually takes a while ...
- Fixup turbo for media workloads on snb+.
- And a no-lvds quirk.

Most of the patches are cc: stable.

Yours, Daniel


The following changes since commit f15b4ca2ccbc0a4661c35a744d254e1e32dd1e15:

  Merge tag 'drm-intel-next-2012-05-20' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next (2012-05-21 08:17:42 +0100)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to 89ba829e38bd500f438bc08af4229204c8ed7f35:

  drm/i915: always use RPNSWREQ for turbo change requests (2012-05-24 17:54:15 +0200)

----------------------------------------------------------------
Chris Wilson (2):
      drm/i915: Always update RPS interrupts thresholds along with frequency
      drm/i915: Fix PCH PLL assertions to not assume CRTC:PLL relationship

Daniel Vetter (6):
      drm/i915: be more careful when returning -ENXIO in gmbus transfer
      drm/i915: fix module unload since error_state rework
      drm/i915: properly handle interlaced bit for sdvo dtd conversion
      drm/i915: enable vdd when switching off the eDP panel
      drm/i915: wait for a vblank to pass after tv detect
      drm/i915: reject doubleclocked cea modes on dp

Jan-Benedict Glaw (1):
      drm/i915: no lvds quirk for HP t5740e Thin Client

Jesse Barnes (1):
      drm/i915: always use RPNSWREQ for turbo change requests

Rodrigo Vivi (1):
      drm/i915: Adding TV Out Missing modes.

 drivers/gpu/drm/i915/i915_debugfs.c    |    2 ++
 drivers/gpu/drm/i915/i915_irq.c        |   37 ++++----------------
 drivers/gpu/drm/i915/intel_display.c   |   56 +++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_dp.c        |   24 +++++++------
 drivers/gpu/drm/i915/intel_i2c.c       |   21 +++++++-----
 drivers/gpu/drm/i915/intel_lvds.c      |    8 +++++
 drivers/gpu/drm/i915/intel_pm.c        |   59 ++++++++++++++++++++++----------
 drivers/gpu/drm/i915/intel_sdvo.c      |   12 ++++---
 drivers/gpu/drm/i915/intel_sdvo_regs.h |    5 +++
 drivers/gpu/drm/i915/intel_tv.c        |   53 ++++++++++++++++++++++++++++
 10 files changed, 183 insertions(+), 94 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
