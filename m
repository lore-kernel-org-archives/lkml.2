Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2IUKvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:51:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56459 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab2IUKvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:51:17 -0400
Date: Fri, 21 Sep 2012 11:51:10 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm rc7 fixes
Message-ID: <alpine.DEB.2.00.1209211148400.2773@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

 fixes for big 3 drivers:
nouveau: revert earlier MBP fix, put a dmi based MBP fix in its place 
(fixes a regression we found on some Dell eDP panels doing some internal 
tseting)
radeon: revert pll fixes, real fix is too invasive, fix scratch leak
intel: 3 minor fixes, one for HDMI audio.

Dave.

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 017a27e7f52346ca8de6fc776579fbcc8ea55b48:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2012-09-21 20:46:01 +1000)

----------------------------------------------------------------

Alex Deucher (1):
      Revert "drm/radeon: rework pll selection (v3)"

Chris Wilson (1):
      drm/i915: Reduce a pin-leak BUG into a WARN

Daniel Vetter (1):
      drm/i915: enable lvds pin pairs before dpll on gen2

Dave Airlie (5):
      Merge branch 'drm-fixes-3.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Revert "drm/nv50-/gpio: initialise to vbios defaults during init"
      Merge branch 'drm-fixes-3.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      drm/nouveau: add dmi quirk for gpio reset
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Simon Kitching (1):
      drm/radeon: Prevent leak of scratch register on resume from suspend

Wang Xingchao (1):
      drm/i915: HDMI - Clear Audio Enable bit for Hot Plug

 drivers/gpu/drm/i915/i915_gem.c        |   3 +-
 drivers/gpu/drm/i915/intel_display.c   |  12 +--
 drivers/gpu/drm/i915/intel_hdmi.c      |   2 +-
 drivers/gpu/drm/nouveau/nv50_gpio.c    |  15 ++-
 drivers/gpu/drm/radeon/atombios_crtc.c | 163 +++++++--------------------------
 drivers/gpu/drm/radeon/r100.c          |   3 +-
 6 files changed, 59 insertions(+), 139 deletions(-)
