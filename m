Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2DCQgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:36:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48585 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2DCQgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:36:03 -0400
Date: Tue, 3 Apr 2012 17:36:01 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm intel fixes
Message-ID: <alpine.DEB.2.00.1204031733420.31796@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

this pull just contains a forward of the Intel fixes from Daniel,

The only annoyance is the RC6 enable, which really should have made -next,
but since Ubuntu are shipping it I reckon its getting a good testing now
by the time 3.4 comes out.

The pull from Daniel contains his pull message to me,

"A few patches for 3.4, major part is 3 regression fixes:
- ppgtt broke hibernate on snb/ivb. Somehow our QA claims that it still
 works, which is why this has not been caught earlier.
- ppgtt flails in combination with dmar. I kinda expected this one :(
- fence handling bugfix for gen2/3. Iirc this one is about a year old, fix
 curtesy Chris Wilson. I've created an shockingly simple i-g-t test to
 catch this in the future.

Wrt regressions I've just got a report that gmbus (newly enabled again in
3.4) is a bit noisy. I'm looking into this atm.

Also included are the rc6 enable patches for snb from Eugeni. I wanted to
include these in the main 3.4 pull but screwed it up. Please hit me. Imo
these kind of patches really should go in before -rc1, but in thise case
rc6 has brought us tons of press and guinea pigs^W^W testers and ubuntu is
already running with it. So I estimate a pretty small chance for this to
blow up.

And some smaller things:
- two minor locking snafus
- server gt2 ivb pciid
- 2 patches to sanitize the register state left behind by the bios some
 more
- 2 new quirk entries
- cs readback trick against missed IRQs from ivb also enabled on snb
- sprite fix from Jesse"

Dave.

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes-intel

Anisse Astier (1):
      drm/i915: no-lvds quirk on MSI DC500

Chris Wilson (2):
      drm/i915: Sanitize BIOS debugging bits from PIPECONF
      drm/i915: Mark untiled BLT commands as fenced on gen2/3

Daniel Vetter (6):
      drm/i915: properly restore the ppgtt page directory on resume
      drm/i915: quirk away broken OpRegion VBT
      drm/i915: apply CS reg readback trick against missed IRQ on snb
      drm/i915: properly clear SSC1 bit in the pch refclock init code
      drm/i915: disable ppgtt on snb when dmar is enabled
      drm/i915: don't leak struct_mutex lock on ppgtt init failures

Dave Airlie (1):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-intel-fixes

Eugeni Dodonov (3):
      drm/i915: allow to select rc6 modes via kernel parameter
      drm/i915: enable plain RC6 on Sandy Bridge by default
      drm/i915: add Ivy Bridge GT2 Server entries

Jesse Barnes (1):
      drm/i915: treat src w & h as fixed point in sprite handling code

Sean Paul (1):
      drm/i915: Add lock on drm_helper_resume_force_mode

 drivers/char/agp/intel-agp.h               |    1 +
 drivers/char/agp/intel-gtt.c               |    3 +-
 drivers/gpu/drm/i915/i915_dma.c            |   21 ++++++++++++++-
 drivers/gpu/drm/i915/i915_drv.c            |   13 +++++++--
 drivers/gpu/drm/i915/i915_drv.h            |   23 ++++++++++++++++-
 drivers/gpu/drm/i915/i915_gem.c            |   37 ++++++++++++++++++++++-----
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c        |    9 -------
 drivers/gpu/drm/i915/i915_reg.h            |    1 +
 drivers/gpu/drm/i915/intel_bios.c          |   23 ++++++++++++++++-
 drivers/gpu/drm/i915/intel_display.c       |   37 +++++++++++++++++++++-------
 drivers/gpu/drm/i915/intel_lvds.c          |    8 ++++++
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    2 +-
 drivers/gpu/drm/i915/intel_sprite.c        |    3 ++
 include/drm/intel-gtt.h                    |    4 +++
 15 files changed, 152 insertions(+), 35 deletions(-)
