Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab2GMSz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:55:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54513 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab2GMSz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:55:26 -0400
Date: Fri, 13 Jul 2012 20:55:26 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [pull] drm-intel-next
Message-ID: <20120713185526.GI5721@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

New pull for -next. Highlights:
- rc6/turbo support for hsw (Eugeni)
- improve corner-case of the reset handling code - gpu reset handling
  should be rock-solid now
- support for fb offset > 4096 pixels on gen4+ (yeah, you need some fairly
  big screens to hit that)
- the "Flush Me Harder" patch to fix the gen6+ fallout from disabling the
  flushing_list
- no more /dev/agpgart on gen6+!
- HAS_PCH_xxx improvements from Paulo
- a few minor bits&pieces all over, most of it in thew hsw code

QA reported 2 regression, one due a bad cable (fixed by a walk to the next
radioshack) and one due to the HPD v2 patch - I owe you one for refusing
to take v2 for -fixes after v1 blew up on Linus' machine I guess ;-) The
later has a confirmed fix already queued up in my tree.

Regressions from the last pull are all fixed and some really good news:
We've finally fixed the last DP regression from 3.2. Although I'm vary of
that blowing up elseplaces, hence I prefer that we soak it in 3.6 a bit
before submitting it to stable.

Otherwise Chris is hunting down an obscure bug that got recently
introduced due to a funny interaction between two seemingly unrelated
patches, one improving our gpu death handling, the other preparing the
removal of the flushing_list. But he has patches already, although I'm
still complaining a bit about the commit messages ...

Wrt further pulls for 3.6 I'll merge feature-y stuff only at the end of
the current drm-intel-next cycle so that if this will miss 3.6 I can just
send you a pull for the bugfixes that are currently merged (or in the case
of Chris' patches, hopefully merged soon).

Yours, Daniel

PS: This pull will make the already existing conflict with Linus' tree a
bit more fun, but I think it should be still doable (the important thing
is to keep the revert from -fixes, but don't kill any other changes from
-next).

The following changes since commit 7b0cfee1a24efdfe0235bac62e53f686fe8a8e24:

  Merge tag 'v3.5-rc4' into drm-intel-next-queued (2012-06-25 19:10:36 +0200)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm-intel tags/drm-intel-next-2012-07-06

for you to fetch changes up to 4acf518626cdad5bbf7aac9869bd4accbbfb4ad3:

  drm/i915: program FDI_RX TP and FDI delays (2012-07-05 15:09:03 +0200)

----------------------------------------------------------------
Ben Widawsky (1):
      drm/i915: linuxify create_hw_context()

Chris Wilson (2):
      drm/i915: Group the GT routines together in both code and vtable
      drm/i915: Implement w/a for sporadic read failures on waking from rc6

Daniel Vetter (15):
      drm/i915: wrap up gt powersave enabling functions
      drm/i915: make enable/disable_gt_powersave locking consistent
      drm/i915: don't use dev->agp
      drm/i915: disable drm agp support for !gen3 with kms enabled
      agp/intel-agp: remove snb+ host bridge pciids
      drm/i915: "Flush Me Harder" required on gen6+
      drm/i915: fix up ilk rc6 disabling confusion
      drm/i915: don't trylock in the gpu reset code
      drm/i915: non-interruptible sleeps can't handle -EAGAIN
      drm/i915: don't hang userspace when the gpu reset is stuck
      drm/i915: properly SIGBUS on I/O errors
      drm/i915: don't return a spurious -EIO from intel_ring_begin
      drm/i915: introduce crtc->dspaddr_offset
      drm/i915: adjust framebuffer base address on gen4+
      drm/i915: introduce for_each_encoder_on_crtc

Eugeni Dodonov (11):
      drm/i915: support Haswell force waking
      drm/i915: add RPS configuration for Haswell
      drm/i915: slightly improve gt enable/disable routines
      drm/i915: enable RC6 by default on Haswell
      drm/i915: disable RC6 when disabling rps
      drm/i915: introduce haswell_init_clock_gating
      drm/i915: enable RC6 workaround on Haswell
      drm/i915: move force wake support into intel_pm
      drm/i915: re-initialize DDI buffer translations after resume
      drm/i915: prevent bogus intel_update_fbc notifications
      drm/i915: program FDI_RX TP and FDI delays

Jesper Juhl (1):
      drm/i915/sprite: Fix mem leak in intel_plane_init()

Jesse Barnes (3):
      drm/i915: mask tiled bit when updating IVB sprites
      drm/i915: correct IVB default sprite format
      drm/i915: prefer wide & slow to fast & narrow in DP configs

Paulo Zanoni (5):
      drm/i915: fix PIPE_WM_LINETIME definition
      drm/i915: add PCH_NONE to enum intel_pch
      drm/i915: get rid of dev_priv->info->has_pch_split
      drm/i915: don't ironlake_init_pch_refclk() on LPT
      drm/i915: fix PIPE_DDI_PORT_MASK

Ville Syrjälä (2):
      drm/i915: Zero initialize mode_cmd
      drm/i915: Reject page flips with changed format/offset/pitch

 drivers/char/agp/intel-agp.c            |   11 -
 drivers/gpu/drm/i915/i915_dma.c         |    9 +-
 drivers/gpu/drm/i915/i915_drv.c         |  172 ++------------
 drivers/gpu/drm/i915/i915_drv.h         |   28 ++-
 drivers/gpu/drm/i915/i915_gem.c         |   44 +++-
 drivers/gpu/drm/i915/i915_gem_context.c |   50 ++--
 drivers/gpu/drm/i915/i915_reg.h         |   21 +-
 drivers/gpu/drm/i915/i915_suspend.c     |    5 +-
 drivers/gpu/drm/i915/intel_ddi.c        |    9 +
 drivers/gpu/drm/i915/intel_display.c    |  162 ++++++-------
 drivers/gpu/drm/i915/intel_dp.c         |   26 +-
 drivers/gpu/drm/i915/intel_drv.h        |   16 +-
 drivers/gpu/drm/i915/intel_fb.c         |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c       |    6 +-
 drivers/gpu/drm/i915/intel_pm.c         |  396 +++++++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_ringbuffer.c |   34 +--
 drivers/gpu/drm/i915/intel_sprite.c     |    5 +-
 drivers/gpu/drm/i915/intel_tv.c         |   10 +-
 18 files changed, 579 insertions(+), 427 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
