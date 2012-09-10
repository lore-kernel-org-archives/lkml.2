Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab2IJFf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:35:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34165 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab2IJFf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:35:57 -0400
Date: Mon, 10 Sep 2012 06:35:54 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1209100633180.14013@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just noticed I hadn't send these out, nothing majorly urgent, I know AMD 
guys have some regression fixes coming soon,

This contains:
2 nouveau fixes so it loads on the retina MBP systems properly,
2 vmwgfx fixes to load the driver earlier, and allow distros config it
1 error->debug fix in ast
and Keith was playing with 32-on-64 and decided we may as well stick the 
compat ioctl in all the drivers. It fixes udl for him.

Dave.

The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to c4903429a92be60e6fe59868924a65eca4cd1a38:

  drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot (2012-09-07 13:25:34 +1000)

----------------------------------------------------------------
Ben Skeggs (2):
      drm/nvd0/disp: hopefully fix selection of 6/8bpc mode on DP outputs
      drm/nv50-/gpio: initialise to vbios defaults during init

Dave Airlie (4):
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/nouveau/linux-2.6 into drm-fixes
      drm/ast: drop debug level on error printk
      drm/vmwgfx: allow a kconfig option to choose if fbcon is enabled
      drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot

Keith Packard (1):
      drm: use drm_compat_ioctl for 32-bit apps

 drivers/gpu/drm/ast/ast_drv.c           |    3 +++
 drivers/gpu/drm/ast/ast_mode.c          |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c     |    3 +++
 drivers/gpu/drm/exynos/exynos_drm_drv.c |    3 +++
 drivers/gpu/drm/i810/i810_dma.c         |    3 +++
 drivers/gpu/drm/i810/i810_drv.c         |    3 +++
 drivers/gpu/drm/mgag200/mgag200_drv.c   |    3 +++
 drivers/gpu/drm/nouveau/nv50_gpio.c     |    3 +++
 drivers/gpu/drm/nouveau/nvd0_display.c  |    4 ++--
 drivers/gpu/drm/savage/savage_drv.c     |    3 +++
 drivers/gpu/drm/sis/sis_drv.c           |    3 +++
 drivers/gpu/drm/tdfx/tdfx_drv.c         |    3 +++
 drivers/gpu/drm/udl/udl_drv.c           |    3 +++
 drivers/gpu/drm/via/via_drv.c           |    3 +++
 drivers/gpu/drm/vmwgfx/Kconfig          |    8 ++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c     |    3 ++-
 16 files changed, 49 insertions(+), 4 deletions(-)
