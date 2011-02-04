Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab1BDFLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 00:11:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49886 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab1BDFLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 00:11:48 -0500
Date: Fri, 4 Feb 2011 05:11:21 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm
Message-ID: <alpine.DEB.2.00.1102040506490.5315@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

more across the board fixes, some from Chris for some regressions around 
device reset, a few AGP fixes, and Alex is still trying to get radeon PLLs 
into a state that works everwhere, along with an oops fix. One fix from 
Ben for a nouveau regression also.

I haven't pulled Keith's fix for the DPMS issue, I can't reproduce the 
problem on my hw, I suspect userspace needs to be a certain version as 
well for it to trigger, I've tried 3 different machines this afternoon, so 
hopefully if we get some positive feedback from testers we can pull it in 
then.

Dave.

The following changes since commit 1f0324caefd39985e9fe052fac97da31694db31e:

  Merge branch 'stable/bug-fixes-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2011-01-28 12:24:34 +1000)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (10):
      drm/radeon/kms: rv6xx+ thermal sensor fixes
      drm/radeon/kms: switch back to min->max pll post divider iteration
      drm/radeon/kms: add pll debugging output
      drm/radeon/kms: add new pll algo for avivo asics
      drm/radeon/kms: Enable new pll calculation for avivo+ asics
      drm/radeon: remove 0x4243 pci id
      drm/radeon/kms: add updated ib_execute function for evergreen
      drm/radeon/kms/evergreen: always set certain VGT regs at CP init
      drm/radeon/kms: fix s/r issues with bios scratch regs
      drm/radeon/kms: dynamically allocate power state space

Ben Skeggs (1):
      drm/nv50: fix display on 0x50

Chris Wilson (10):
      drm/i915/sdvo: If at first we don't succeed in reading the response, wait
      drm: Add an interface to reset the device
      drm/i915: Reset state after a GPU reset or resume
      drm/i915/crt: Force the initial probe after reset
      drm/i915: Reset crtc after resume
      drm: Don't switch fb when disabling an output
      drm: Simplify and defend later checks when disabling a crtc
      drm: Avoid leak of adjusted mode along quick set_mode paths
      drm/i915: Suppress spurious vblank interrupts
      drm/i915: Only bind to function 0 of the PCI device

Dave Airlie (2):
      Merge remote branch 'intel/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes
      Merge remote branch 'nouveau/drm-nouveau-next' of /ssd/git/drm-nouveau-next into drm-fixes

Lucas Stach (1):
      drm/nouveau: correctly pair hwmon_init and hwmon_fini

Matt Turner (2):
      amd-k7-agp: remove non-x86 code
      Revert "agp: AMD AGP is used on UP1100 & UP1500 alpha boxen"

Randy Dunlap (1):
      gpu/stub: fix acpi_video build error, fix stub kconfig dependencies

Stefan Weil (1):
      drm/radeon: Fix wrong boolean operator

Stephen Kitt (1):
      agp: ensure GART has an address before enabling it

 drivers/char/agp/Kconfig                    |    2 +-
 drivers/char/agp/amd-k7-agp.c               |   19 ----
 drivers/char/agp/intel-agp.c                |   27 +++--
 drivers/gpu/drm/drm_crtc.c                  |   20 ++++
 drivers/gpu/drm/drm_crtc_helper.c           |   21 ++--
 drivers/gpu/drm/drm_irq.c                   |    7 +-
 drivers/gpu/drm/i915/i915_drv.c             |   10 ++
 drivers/gpu/drm/i915/i915_irq.c             |    8 +-
 drivers/gpu/drm/i915/intel_crt.c            |   10 ++
 drivers/gpu/drm/i915/intel_display.c        |   17 +++-
 drivers/gpu/drm/i915/intel_sdvo.c           |   46 +++++-----
 drivers/gpu/drm/nouveau/nouveau_pm.c        |    2 +-
 drivers/gpu/drm/nouveau/nv50_evo.c          |    3 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |   18 +++-
 drivers/gpu/drm/radeon/evergreen.c          |   41 ++++++--
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |   10 ++-
 drivers/gpu/drm/radeon/evergreend.h         |    2 +
 drivers/gpu/drm/radeon/r600.c               |    8 +-
 drivers/gpu/drm/radeon/radeon.h             |   11 +-
 drivers/gpu/drm/radeon/radeon_asic.c        |    6 +-
 drivers/gpu/drm/radeon/radeon_asic.h        |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |   59 +++++++-----
 drivers/gpu/drm/radeon/radeon_combios.c     |   11 ++
 drivers/gpu/drm/radeon/radeon_display.c     |  132 +++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_encoders.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    6 +-
 drivers/gpu/drm/radeon/radeon_mode.h        |   23 +++--
 drivers/gpu/drm/radeon/radeon_pm.c          |    5 +-
 drivers/gpu/drm/radeon/rv770.c              |   19 +++--
 drivers/gpu/stub/Kconfig                    |    2 +
 include/drm/drmP.h                          |    2 +-
 include/drm/drm_crtc.h                      |    7 ++
 include/drm/drm_pciids.h                    |    1 -
 33 files changed, 400 insertions(+), 158 deletions(-)
