Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2HaJDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:03:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34734 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2HaJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:03:37 -0400
Date: Fri, 31 Aug 2012 11:03:55 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] drm-intel-next
Message-ID: <20120831090354.GA5511@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

New stuff for -next. Highlights:
- prep patches for the modeset rework. Note that one of those patches
  touches the fb helper in the common drm code.
- hasw hdmi audio support (Wang Xingchao)
- improved instdone dumping for gen7 (Ben)
- unbound tracking and a few follow-up patches from Chris
- dma_buf->begin/end_cpu_access plus fix for drm/udl (Dave)
- improve mmio error reporting for hsw
- prep patch for WQ_NON_REENTRANT removal (Tejun Heo)

I've expected a conflict with the raw_edid removal, but on second look
the conflicting patch went through -fixes and you've already resolved it.
I've also included a fixup on top of what QA tested to avoid a conflict
with linux-next (the NO_KSWAP removal).

Cheers, Daniel

The following changes since commit a22ddff8bedfe33eeb1330bbb7ef1fbe007a42c4:

  Merge tag 'v3.6-rc2' into drm-intel-next (2012-08-17 09:01:08 +0200)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm-intel for-airlied

for you to fetch changes up to d7c3b937bdf45f0b844400b7bf6fd3ed50bac604:

  drm/i915: Remove __GFP_NO_KSWAPD (2012-08-27 17:11:38 +0200)

----------------------------------------------------------------
Ben Widawsky (5):
      drm/i915: Add ERR_INT to gen7 error state
      drm/i915: Find unclaimed MMIO writes.
      drm/i915: Extract reading INSTDONE
      drm/i915: Add new INSTDONE registers
      drm/i915: Use new INSTDONE registers (Gen7+)

Chris Wilson (13):
      drm/i915: Track unbound pages
      drm/i915: Add some sanity checks to unbound tracking
      drm/i915: Show (count, size) of purgeable objects in i915_gem_objects
      drm/i915: Show pin count in debugfs
      drm/i915: Try harder to allocate an mmap_offset
      drm/i915: Cantiga+ cannot handle a hsync front porch of 0
      drm/i915: Only pwrite through the GTT if there is space in the aperture
      drm/i915: Protect private gem objects from truncate (such as imported dmabuf)
      drm/i915: Extract general object init routine
      drm/i915: Use cpu relocations if the object is in the GTT but not mappable
      drm/i915: Juggle code order to ease flow of the next patch
      drm/i915: Use a non-blocking wait for set-to-domain ioctl
      drm/i915: Avoid unbinding due to an interrupted pin_and_fence during execbuffer

Damien Lespiau (1):
      drm/i915: Don't hardcode the number of pipes in the error state dump

Daniel Vetter (11):
      drm/i915: add missing gen2 pipe A quirk entries
      drm/i915/ns2501: kill pll A enabling hack
      drm/i915: rip out the overlay pipe A workaround
      drm/i915: prepare load-detect pipe code for dpms changes
      drm/i915: drop intel_encoder argument to load_detect_pipe functions
      drm/i915: simplify dvo dpms interface
      drm/i915: kill a few unused things in dev_priv
      drm/i915: extract ironlake_fdi_pll_disable
      drm/fb-helper: don't clobber output routing in setup_crtcs
      drm/i915: move functions around
      drm/i915: disable rc6 on ilk when vt-d is enabled

Dave Airlie (2):
      drm/i915: implement dma buf begin_cpu_access (v2)
      drm/udl: call begin/end cpu access at more appropriate time

Keith Packard (1):
      drm/i915: Allow VGA on CRTC 2

Sedat Dilek (1):
      drm/i915: Remove __GFP_NO_KSWAPD

Tejun Heo (1):
      i915: use alloc_ordered_workqueue() instead of explicit UNBOUND w/ max_active = 1

Wang Xingchao (4):
      drm/i915: HSW audio registers definition
      drm/i915: write eld info for HDMI audio
      drm/i915: ironlake_write_eld code cleanup
      drm/i915: Haswell HDMI audio initialization

Xu, Anhua (2):
      drm/i915: fix wrong order of parameters in port checking functions
      drm/i915: fix reassignment of variable "intel_dp->DP"

 drivers/gpu/drm/drm_fb_helper.c            |    6 -
 drivers/gpu/drm/i915/dvo.h                 |    9 +-
 drivers/gpu/drm/i915/dvo_ch7017.c          |    8 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c          |    4 +-
 drivers/gpu/drm/i915/dvo_ivch.c            |    8 +-
 drivers/gpu/drm/i915/dvo_ns2501.c          |   21 +-
 drivers/gpu/drm/i915/dvo_sil164.c          |    4 +-
 drivers/gpu/drm/i915/dvo_tfp410.c          |    4 +-
 drivers/gpu/drm/i915/i915_debugfs.c        |   40 +-
 drivers/gpu/drm/i915/i915_dma.c            |   31 +-
 drivers/gpu/drm/i915/i915_drv.c            |    4 +
 drivers/gpu/drm/i915/i915_drv.h            |   39 +-
 drivers/gpu/drm/i915/i915_gem.c            | 1100 +++++++++++++++-------------
 drivers/gpu/drm/i915/i915_gem_context.c    |    4 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |   37 +-
 drivers/gpu/drm/i915/i915_gem_evict.c      |   19 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |  126 ++--
 drivers/gpu/drm/i915/i915_gem_gtt.c        |    2 +-
 drivers/gpu/drm/i915/i915_irq.c            |   76 +-
 drivers/gpu/drm/i915/i915_reg.h            |   79 ++
 drivers/gpu/drm/i915/i915_trace.h          |   10 +-
 drivers/gpu/drm/i915/intel_crt.c           |    8 +-
 drivers/gpu/drm/i915/intel_ddi.c           |    6 +-
 drivers/gpu/drm/i915/intel_display.c       |  254 ++++---
 drivers/gpu/drm/i915/intel_dp.c            |    2 -
 drivers/gpu/drm/i915/intel_drv.h           |    6 +-
 drivers/gpu/drm/i915/intel_dvo.c           |    4 +-
 drivers/gpu/drm/i915/intel_overlay.c       |   60 +-
 drivers/gpu/drm/i915/intel_pm.c            |    7 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    6 +-
 drivers/gpu/drm/i915/intel_tv.c            |    7 +-
 drivers/gpu/drm/udl/udl_fb.c               |   22 +-
 drivers/gpu/drm/udl/udl_gem.c              |    7 -
 include/drm/i915_drm.h                     |    1 +
 34 files changed, 1133 insertions(+), 888 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
