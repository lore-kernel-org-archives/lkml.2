Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0JALS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:18:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38459 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab0JALSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:18:55 -0400
Date: Fri, 1 Oct 2010 12:18:43 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1010011005470.14941@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1010011214110.7838@skynet.skynet.ie>
References: <alpine.DEB.2.00.1010010623270.29377@skynet.skynet.ie> <alpine.DEB.2.00.1010011005470.14941@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > We had an unplanned leak/race finding week:
> 
> Updated pull request, TTM extra fix, GEM updated patch with tested by 
> lines, and some urgent vmwgfx oops/fixes. (vmwgfx is in staging still, 
> though I need to discuss that with vmware).

Today is proof the phenylephrine is a poor substitute for pseudoephedrine, 
and both are a poor substitute for sleep.

I've dropped the TTM fixes until next week since Thomas keeps finding 
corner-case issues and I'd like to get to my test box in the office and 
confirm, we know the patch fixes a major leak, just a matter of having 
more confidence in it working in the corners.

Lets get the simpler patches I'm sure about in and I'll send the ttm leak 
fix on its own next week.

Dave.

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

Thomas Hellstrom (5):
      drm/vmwgfx: Fix breakage introduced by commit "drm: block userspace under allocating buffer and having drivers overwrite it (v2)"
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
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |  145 +++++++++++++++++++++-------
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        |    8 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c         |    5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c       |    3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c        |   17 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c        |   27 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |    4 +
 include/drm/drmP.h                         |   29 ++++--
 include/drm/drm_pciids.h                   |    2 +-
 24 files changed, 246 insertions(+), 120 deletions(-)
