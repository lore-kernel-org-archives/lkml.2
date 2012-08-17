Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab2HQHQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:16:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37917 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2HQHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:15:56 -0400
Date: Fri, 17 Aug 2012 09:08:55 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] first drm-intel-next for 3.7
Message-ID: <20120817070855.GA5410@phenom.ffwll.local>
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

First -next pull for 3.7. Highlights:
- hsw hdmi improvements (Paulo)
- ips/rps locking rework and cleanups
- rc6 on ilk by default again
- hw context&dp&dpff support for hsw (Ben)
- GET_PARAM_HAS_SEMAPHORES (Chris)
- gen6+ pipe_control improvements (Chris)
- set_cacheing ioctl and assorted support code (Chris)
- cleanups around the busy/idle/pm code (Chris&me)
- flushing_list removal, hopefully for good (Chris)
- read_reg ioctl (Ben)
- support the ns2501 dvo (Thomas Richter)
- avoid the costly gen6+ "missed IRQ" workaround where we don't need a
  race-free seqno readback (Chris)
- various bits&pieces, mostly early patches from the modeset rework branch

As discussed on irc I'll send you a pull with 3.6-rc2 merged in, since
there's a funny conflict with mainline.

Wrt regressions nothing new popped up since my -fixes pull, and QA has
been rather happy with testing this -next pull here.

Yours, Daniel

Aside: I've frobbed the shortlog to exclude everything in -rc2.

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel for-airlied

for you to fetch changes up to a22ddff8bedfe33eeb1330bbb7ef1fbe007a42c4:

  Merge tag 'v3.6-rc2' into drm-intel-next (2012-08-17 09:01:08 +0200)

----------------------------------------------------------------

Ben Widawsky (4):
      drm/i915: add register read IOCTL
      drm/i915: Add contexts for HSW
      drm/i915: Macro to determine DPF support
      drm/i915: Expand DPF support to Haswell

Chris Wilson (17):
      drm/i915: Cleanup context switching through do_switch()
      drm/i915: Return a mask of the active rings in the high word of busy_ioctl
      drm/i915: Allow late allocation of request for i915_add_request()
      drm/i915: Remove assertion over write domain after i915_gem_object_sync()
      drm/i915: Replace the pending_gpu_write flag with an explicit seqno
      drm/i915: Remove the defunct flushing list
      drm/i915: Remove the per-ring write list
      drm/i915: Remove explicit flush from i915_gem_object_flush_fence()
      drm/i915: Remove the explicit flush of the GPU write domain
      drm/i915: Clear the pending_gpu_fenced_access flag at the start of execbuffer
      drm/i915: Split i915_gem_flush_ring() into seperate invalidate/flush funcs
      drm/i915: Avoid concurrent access when marking the device as idle/busy
      drm/i915: Segregate memory domains in the GTT using coloring
      drm/i915: Export ability of changing cache levels to userspace
      drm/i915: Only apply the SNB pipe control w/a to gen6
      drm/i915: Add I915_GEM_PARAM_HAS_SEMAPHORES
      drm/i915: Lazily apply the SNB+ seqno w/a

Daniel Vetter (21):
      drm/i915: group ADPA #defines together
      drm/i915: simplify possible_clones computation
      drm/i915: add port parameter to intel_hdmi_init
      drm/i915: Reserve ioctl numbers for set/get_caching
      drm/i915: create VLV_DSIPLAY_BASE #define
      drm/i915: add inte_crt->adpa_reg
      drm/i915: Replace the complex flushing logic with simple invalidate/flush all
      drm/i915: Only set the down rps limit when at the loweset frequency
      drm/i915: rip out sanitize_pm again
      drm/i915: fixup desired rps frequency computation
      drm/i915: dump the device info
      drm/i915: properly guard ilk ips state
      drm/i915: fixup up debugfs rps state handling
      drm/i915: use mutex_lock_interruptible for debugfs files
      drm/i915: move all rps state into dev_priv->rps
      drm/i915: kill dev_priv->mchdev_lock
      drm/i915: DE_PCU_EVENT irq is ilk-only
      drm/i915: fix up ilk drps/ips locking
      drm/i915: enable rc6 on ilk again
      drm/i915: don't grab dev->struct_mutex for userspace forcewak
      Merge tag 'v3.6-rc2' into drm-intel-next

Eugeni Dodonov (1):
      drm/i915: prevent possible pin leak on error path

Paulo Zanoni (10):
      drm/i915: move common code to intel_dp_set_link_train
      drm/i915: add port field to struct intel_dp and use it
      drm/i915: fix pipe DDI mode select
      drm/i915: set the DDI sync polarity bits
      drm/i915: correctly set the DDI_FUNC_CTL bpc field
      drm/i915: completely reset the value of DDI_FUNC_CTL
      drm/i915: reindent Haswell register definitions
      drm/i915: add parentheses around PIXCLK_GATE definitions
      drm/i915: use the correct encoder type when comparing
      drm/i915: try harder to find WR PLL clock settings

Shobhit Kumar (1):
      drm/i915: Move DP structs to shared location

Thomas Richter (1):
      drm/i915: Support for ns2501-DVO

 drivers/gpu/drm/i915/Makefile              |    1 +
 drivers/gpu/drm/i915/dvo.h                 |    1 +
 drivers/gpu/drm/i915/dvo_ns2501.c          |  582 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_debugfs.c        |  143 ++++---
 drivers/gpu/drm/i915/i915_dma.c            |   26 +-
 drivers/gpu/drm/i915/i915_drv.c            |   48 ++-
 drivers/gpu/drm/i915/i915_drv.h            |  108 ++++--
 drivers/gpu/drm/i915/i915_gem.c            |  477 ++++++++++++-----------
 drivers/gpu/drm/i915/i915_gem_context.c    |   61 ++-
 drivers/gpu/drm/i915/i915_gem_evict.c      |   27 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |  252 ++----------
 drivers/gpu/drm/i915/i915_gem_gtt.c        |   19 +
 drivers/gpu/drm/i915/i915_irq.c            |   68 ++--
 drivers/gpu/drm/i915/i915_reg.h            |  243 ++++++------
 drivers/gpu/drm/i915/i915_sysfs.c          |    2 +-
 drivers/gpu/drm/i915/intel_crt.c           |   27 +-
 drivers/gpu/drm/i915/intel_ddi.c           |   79 ++--
 drivers/gpu/drm/i915/intel_display.c       |  216 +++--------
 drivers/gpu/drm/i915/intel_dp.c            |  175 ++++-----
 drivers/gpu/drm/i915/intel_drv.h           |   74 ++--
 drivers/gpu/drm/i915/intel_dvo.c           |   17 +-
 drivers/gpu/drm/i915/intel_hdmi.c          |   51 +--
 drivers/gpu/drm/i915/intel_lvds.c          |    2 +-
 drivers/gpu/drm/i915/intel_pm.c            |  245 ++++++------
 drivers/gpu/drm/i915/intel_ringbuffer.c    |   77 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.h    |   20 +-
 drivers/gpu/drm/i915/intel_sdvo.c          |   14 +-
 drivers/gpu/drm/i915/intel_tv.c            |    2 +-
 include/drm/i915_drm.h                     |   34 +-
 29 files changed, 1795 insertions(+), 1296 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/dvo_ns2501.c
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
