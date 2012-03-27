Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2C0NIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:08:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36004 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab2C0NIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:08:16 -0400
Date: Tue, 27 Mar 2012 14:08:14 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1203271406550.12921@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

gma500 build fix + some regression fixes for nouveau/radeon, along with 
one radeon patch that was posted a while ago and I missed and it also required 
rebasing around some other stuff.

Dave.

The following changes since commit e22057c8599373e5caef0bc42bdb95d2a361ab0d:

  Merge tag 'stable/for-linus-3.4-tag-two' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2012-03-24 12:20:25 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms/atom: force bpc to 8 for now

Ben Skeggs (3):
      drm/nouveau: fix thinko causing init to fail on cards without accel
      drm/nouveau: default to 8bpc for non-LVDS panels if EDID isn't useful
      drm/nouveau/i2c: fix thinko/regression on really old chipsets

Jerome Glisse (1):
      drm/radeon/kms: add htile support to the cs checker v3

Kirill A. Shutemov (1):
      gma500: medfield: fix build without CONFIG_BACKLIGHT_CLASS_DEVICE

 drivers/gpu/drm/gma500/mdfld_dsi_output.c   |    5 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c |    9 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.c       |    6 +-
 drivers/gpu/drm/nouveau/nouveau_state.c     |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    8 +-
 drivers/gpu/drm/radeon/atombios_dp.c        |    3 +
 drivers/gpu/drm/radeon/atombios_encoders.c  |    4 +-
 drivers/gpu/drm/radeon/evergreen_cs.c       |   98 +++++++-
 drivers/gpu/drm/radeon/evergreend.h         |    8 +
 drivers/gpu/drm/radeon/r600_cs.c            |  391 +++++++++++++++++++--------
 drivers/gpu/drm/radeon/r600d.h              |    8 +
 drivers/gpu/drm/radeon/reg_srcs/cayman      |    1 -
 drivers/gpu/drm/radeon/reg_srcs/evergreen   |    1 -
 drivers/gpu/drm/radeon/reg_srcs/r600        |    1 -
 14 files changed, 409 insertions(+), 136 deletions(-)
