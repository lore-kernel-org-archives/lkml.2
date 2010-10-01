Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0JAJH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:07:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40341 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab0JAJH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:07:57 -0400
Date: Fri, 1 Oct 2010 10:07:45 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1010010623270.29377@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1010011005470.14941@skynet.skynet.ie>
References: <alpine.DEB.2.00.1010010623270.29377@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Linus,
> 
> We had an unplanned leak/race finding week:

Updated pull request, TTM extra fix, GEM updated patch with tested by 
lines, and some urgent vmwgfx oops/fixes. (vmwgfx is in staging still, 
though I need to discuss that with vmware).

Dave.


> Had a pretty nasty race in TTM reported (scrolling certain pages in 
> firefox caused a major leak of objects), fix from Thomas in here.
> 
> A nasty slow leak in the i915 GEM code, fix from Chris here.
> A race on object deletion in the GEM code, fix from Chris.
> 
> A leak/memory corruptor when unloading drm modules after X had started due 
> to using krefs in a non-kref compatible manner, fix from me (found while 
> tracking down the firefox one).
> 
> Apart from that, just some general radeon fixes, a BKL regression fix, a 
> vmware regression fix from the ioctl cleanups.
> 
The following changes since commit 32163f4b2cef28a5aab8b226ffecfc6379a53786:

  alpha: fix usp value in multithreaded coredumps (2010-09-25 14:38:13 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (3):
      drm/radeon/kms: fix up encoder info messages for DFP6
      drm/radeon/kms: fix potential segfault in r600_ioctl_wait_idle
      drm/radeon/kms: add quirk for MSI K9A2GM motherboard

Arnd Bergmann (1):
      drm: i810/i830: fix locked ioctl variant

Chris Wilson (2):
      drm: Prune GEM vma entries
      drm: Hold the mutex when dropping the last GEM reference (v2)

Dave Airlie (2):
      drm/radeon: fix PCI ID 5657 to be an RV410
      drm/gem: handlecount isn't really a kref so don't make it one.

Thomas Hellstrom (7):
      drm/ttm: Fix two race conditions
      drm/vmwgfx: Fix breakage introduced by commit "drm: block userspace under allocating buffer and having drivers overwrite it (v2)"
      drm/ttm: Fix missing return
      vmwgfx: vt-switch (master drop) fixes
      vmwgfx: Enable use of the vblank system
      vmwgfx: Remove initialisation of dev::devname
      vmwgfx: Fix fb VRAM pinning failure due to fragmentation

 drivers/gpu/drm/drm_gem.c                  |   39 ++------
 drivers/gpu/drm/drm_info.c                 |    2 +-
 drivers/gpu/drm/drm_vm.c                   |   28 ++++--
 drivers/gpu/drm/i810/i810_dma.c            |    2 +-
 drivers/gpu/drm/i830/i830_dma.c            |    2 +-
 drivers/gpu/drm/i915/i915_gem.c            |    6 +-
 drivers/gpu/drm/i915/intel_fb.c            |    4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c    |    1 +
 drivers/gpu/drm/nouveau/nouveau_gem.c      |    6 +-
 drivers/gpu/drm/nouveau/nouveau_notifier.c |    1 +
 drivers/gpu/drm/radeon/r600.c              |    3 +-
 drivers/gpu/drm/radeon/radeon_atombios.c   |    9 ++
 drivers/gpu/drm/radeon/radeon_display.c    |    5 +-
 drivers/gpu/drm/radeon/radeon_fb.c         |   14 +--
 drivers/gpu/drm/radeon/radeon_gem.c        |    4 +-
 drivers/gpu/drm/ttm/ttm_bo.c               |   75 ++++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |  145 +++++++++++++++++++++-------
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        |    8 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c         |    5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c       |    3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c        |   17 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c        |   27 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |    4 +
 include/drm/drmP.h                         |   29 ++++--
 include/drm/drm_pciids.h                   |    2 +-
 include/drm/ttm/ttm_bo_api.h               |    4 +-
 26 files changed, 313 insertions(+), 132 deletions(-)
