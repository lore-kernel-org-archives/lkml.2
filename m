Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0H0Dgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 23:36:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37236 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab0H0Dgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 23:36:49 -0400
Date: Fri, 27 Aug 2010 04:36:35 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes.
Message-ID: <alpine.DEB.2.00.1008270434490.30866@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Some regression fixes, a couple around the BKL removal, and one in the 
drm_mm code that was causing SIGBUS errors for some radeon users.

Dave.

The following changes since commit d03330383c9255cdb184dd33594e89c3542f191b:

  Merge remote branch 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next into drm-core-next (2010-08-23 08:34:59 +1000)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Adam Jackson (1):
      drm/modes: Fix CVT-R modeline generation

Alex Deucher (2):
      drm/radeon/kms: remove stray radeon_i2c_destroy
      drm/radeon/kms: add missing scratch update in dp_detect

Arnd Bergmann (1):
      drm: fix regression in drm locking since BKL removal.

Ben Skeggs (3):
      drm/nv50: add dcb type 14 to enum to prevent compiler complaint
      drm: export drm_global_mutex for drivers to use
      drm/nouveau: drop drm_global_mutex before sleeping in submission path

Chris Wilson (1):
      vgaarb: Wrap vga_(get|put) in CONFIG_VGA_ARB

Daniel Vetter (1):
      drm: mm: fix range restricted allocations

Dave Airlie (1):
      Merge remote branch 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next into drm-fixes

Francisco Jerez (4):
      drm/nouveau: Use a helper function to match PCI device/subsystem IDs.
      drm/nouveau: Fix backlight control on PPC machines with an internal TMDS panel.
      drm/nouveau: Fix TMDS on some DCB1.5 boards.
      drm/nv20: Don't use pushbuf calls on the original nv20.

Patrice Mandin (1):
      drm/nv30: Apply modesetting to the correct slave encoder

 drivers/gpu/drm/drm_fops.c                 |    1 +
 drivers/gpu/drm/drm_lock.c                 |    2 +
 drivers/gpu/drm/drm_mm.c                   |   24 ++++++----
 drivers/gpu/drm/drm_modes.c                |    5 ++-
 drivers/gpu/drm/nouveau/nouveau_bios.c     |   64 +++++++---------------------
 drivers/gpu/drm/nouveau/nouveau_bios.h     |    1 +
 drivers/gpu/drm/nouveau/nouveau_drv.h      |    9 ++++
 drivers/gpu/drm/nouveau/nouveau_gem.c      |    6 ++-
 drivers/gpu/drm/nouveau/nv04_dfp.c         |   31 ++++++++++++-
 drivers/gpu/drm/nouveau/nv17_tv.c          |   10 +---
 drivers/gpu/drm/radeon/radeon_connectors.c |    1 +
 drivers/gpu/drm/radeon/radeon_pm.c         |    2 -
 include/linux/vgaarb.h                     |   15 ++++++-
 13 files changed, 95 insertions(+), 76 deletions(-)
