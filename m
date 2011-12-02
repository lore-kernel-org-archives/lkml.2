Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1LBLEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:04:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34485 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1LBLEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:04:34 -0500
Date: Fri, 2 Dec 2011 11:07:02 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1112021102400.28364@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

nouveau fixes contain a few oops fixes found on Fedora recently, 
main radeon one fixes a GPU reset race where the CPU hangs in an endless loop,
and in core a framebuffer leak fix from Chris.

Otherwise a couple of radeon scanout fixes for a case we hadn't tested a 
lot, and dropping an ACPI message that was a bit louder than it should 
have been.

Dave.


The following changes since commit 11d814a20166461358e1cefaf6bcd425698b8460:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband (2011-11-30 16:25:02 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (4):
      drm/radeon/kms: add some loop timeouts in pageflip code
      drm/radeon/kms: add some new pci ids
      drm/radeon/kms: fix scanout of 2D tiled buffers on EG/CM
      drm/radeon/kms: fix 2D tiling CS support on EG/CM

Ben Skeggs (4):
      drm/nouveau: add dumb ioctl support
      drm/nvd0/disp: fix sor dpms typo, preventing dpms on in some situations
      drm/nouveau: fix oopses caused by clear being called on unpopulated ttms
      drm/nv50/disp: silence compiler warning

Chris Wilson (1):
      drm: Fix lack of CRTC disable for drm_crtc_helper_set_config(.fb=NULL)

Christoph Bumiller (1):
      drm/nvc0/gr: fix TP init for transform feedback offset queries

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Jean Delvare (2):
      drm/radeon/kms: Hide debugging message
      drm/radeon/kms: Skip ACPI call to ATIF when possible

Xi Wang (1):
      vmwgfx: integer overflow in vmw_kms_update_layout_ioctl()

Younes Manton (1):
      drm/nouveau: Keep RAMIN heap within the channel.

 drivers/gpu/drm/drm_crtc_helper.c         |   27 +++++-
 drivers/gpu/drm/nouveau/nouveau_display.c |   45 +++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.c     |    4 +
 drivers/gpu/drm/nouveau/nouveau_drv.h     |    6 +
 drivers/gpu/drm/nouveau/nouveau_object.c  |    2 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c   |    3 +
 drivers/gpu/drm/nouveau/nv50_display.c    |    4 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c      |    2 +
 drivers/gpu/drm/nouveau/nvd0_display.c    |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c    |   35 +++++++-
 drivers/gpu/drm/radeon/evergreen.c        |    7 +-
 drivers/gpu/drm/radeon/evergreen_cs.c     |  149 ++++++++++++++++++++++++-----
 drivers/gpu/drm/radeon/evergreen_reg.h    |   29 ++++++
 drivers/gpu/drm/radeon/evergreend.h       |   31 ++++++
 drivers/gpu/drm/radeon/r100.c             |    7 +-
 drivers/gpu/drm/radeon/radeon_acpi.c      |   11 +-
 drivers/gpu/drm/radeon/rs600.c            |    7 +-
 drivers/gpu/drm/radeon/rv770.c            |    7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c       |   11 +-
 include/drm/drm_pciids.h                  |    8 ++
 20 files changed, 349 insertions(+), 48 deletions(-)
