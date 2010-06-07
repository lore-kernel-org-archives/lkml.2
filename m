Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0FGDJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:09:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40298 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732Ab0FGDJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:09:34 -0400
Date: Mon, 7 Jun 2010 04:09:15 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

3 regressions fixes, one radeon loading on IGP, one i865 loading, one and 
an evergreen userspace interaction workaround.

It adds hwmon support for a temperature sensor on r600 cards, later PM 
patches were build on this and Alex had tested them in one so I didn't 
want to cherry-pick around it. Also its useful to report the gpu temp to 
check if power management is helping cooling it down.

Dave.

The following changes since commit e44a21b7268a022c7749f521c06214145bd161e4:
  Linus Torvalds (1):
        Linux 2.6.35-rc2

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (5):
      drm/radeon/kms/evergreen: set accel_enabled
      drm/radeon/kms: add support for internal thermal sensors (v3)
      drm/radeon/kms/pm: Misc fixes
      drm/radeon/kms/pm: add mid profile
      drm/radeon/kms/combios: fix typo in voltage fix

Chris Wilson (4):
      drm/i915: Propagate error from drm_fb_helper_init().
      drm/i915: Propagate error from intel_fbdev_init().
      drm/nouveau: Propagate error from drm_fb_helper_init()
      drm/radeon: Propagate error from drm_fb_helper_init()

Dan Carpenter (2):
      drm/drm_crtc: return -EFAULT on copy_to_user errors
      drm/vmwgfx: return -EFAULT for copy_to_user errors

Dave Airlie (3):
      drm/i915: fix oops on single crtc devices.
      drm/radeon: fix PM on non-vram cards.
      drm/fb: use printk to print out the switching to text mode error.

 drivers/gpu/drm/Kconfig                  |    1 +
 drivers/gpu/drm/drm_crtc.c               |    4 +-
 drivers/gpu/drm/drm_fb_helper.c          |    2 +-
 drivers/gpu/drm/i915/i915_dma.c          |   19 +++-
 drivers/gpu/drm/i915/i915_drv.h          |    1 +
 drivers/gpu/drm/i915/intel_display.c     |    9 +-
 drivers/gpu/drm/i915/intel_fb.c          |   10 ++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c  |    8 ++-
 drivers/gpu/drm/radeon/evergreen.c       |   19 ++++-
 drivers/gpu/drm/radeon/evergreend.h      |    5 +
 drivers/gpu/drm/radeon/r100.c            |   10 +++
 drivers/gpu/drm/radeon/r420.c            |   12 +++-
 drivers/gpu/drm/radeon/r600.c            |  109 ++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/r600d.h           |    5 +
 drivers/gpu/drm/radeon/radeon.h          |   24 +++++-
 drivers/gpu/drm/radeon/radeon_atombios.c |   16 +++-
 drivers/gpu/drm/radeon/radeon_combios.c  |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c      |    3 +-
 drivers/gpu/drm/radeon/radeon_fb.c       |   12 ++-
 drivers/gpu/drm/radeon/radeon_kms.c      |    9 ++-
 drivers/gpu/drm/radeon/radeon_pm.c       |  128 +++++++++++++++++++++++------
 drivers/gpu/drm/radeon/rv770.c           |   15 ++++
 drivers/gpu/drm/radeon/rv770d.h          |    5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c  |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    8 ++-
 include/drm/radeon_drm.h                 |    1 +
 26 files changed, 372 insertions(+), 66 deletions(-)
