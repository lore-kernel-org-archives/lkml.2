Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223Ab2FAQLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:11:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56116 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964952Ab2FAQLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:11:00 -0400
Date: Fri, 1 Jun 2012 17:10:58 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1206011708110.16881@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

A bunch of fixes:

vmware memory corruption, ttm spinlock balance,
cirrus/mgag200, work in the presence of efifb
and finally Alex and Jerome managed to track down a magic set of bits that 
on certain rv740 and evergreen cards allow the correct use of the 
complete set of render backends, this makes the cards operate correctly in 
a number of scenarios we had issues in before, it also manages to boost 
speed on benchmarks my large amounts on these specific gpus.

Dave.

The following changes since commit bc42aabc6a01b92b0f961d65671564e0e1cd7592:

  drm/edid/quirks: ViewSonic VA2026w (2012-05-29 16:16:38 +0100)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 47819ba234d41465b76f179ba674ff549255a5d2:

  drm/edid: Make the header fixup threshold tunable (2012-06-01 17:00:23 +0100)

----------------------------------------------------------------
Adam Jackson (1):
      drm/edid: Make the header fixup threshold tunable

Alex Deucher (4):
      drm/radeon: fix bank information in tiling config
      drm/radeon: properly program gart on rv740, juniper, cypress, barts, hemlock
      drm/radeon: fixup tiling group size and backendmap on r6xx-r9xx (v4)
      drm/radeon: fix regression in UMS CS ioctl

Dave Airlie (3):
      cirrus: avoid crash if driver fails to load
      drm/cirrus: kick out conflicting framebuffers earlier
      drm/mgag200: kick off conflicting framebuffers earlier.

Jerome Glisse (1):
      drm/radeon: fix HD6790, HD6570 backend programming

Thomas Hellstrom (2):
      drm/ttm: Fix spinlock imbalance
      drm/vmwgfx: Fix nasty write past alloced memory area

 drivers/gpu/drm/cirrus/cirrus_drv.c   |   19 ++
 drivers/gpu/drm/cirrus/cirrus_drv.h   |    2 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c   |    5 +
 drivers/gpu/drm/drm_edid.c            |   11 +-
 drivers/gpu/drm/mgag200/mgag200_drv.c |   19 ++
 drivers/gpu/drm/radeon/evergreen.c    |  382 +++++----------------------------
 drivers/gpu/drm/radeon/evergreend.h   |   11 +
 drivers/gpu/drm/radeon/ni.c           |  360 +++----------------------------
 drivers/gpu/drm/radeon/nid.h          |   11 +
 drivers/gpu/drm/radeon/r600.c         |  199 ++++++-----------
 drivers/gpu/drm/radeon/r600d.h        |    2 +
 drivers/gpu/drm/radeon/radeon.h       |    5 +
 drivers/gpu/drm/radeon/radeon_cs.c    |   31 +--
 drivers/gpu/drm/radeon/rv770.c        |  274 +++++------------------
 drivers/gpu/drm/radeon/rv770d.h       |    4 +
 drivers/gpu/drm/ttm/ttm_bo.c          |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c   |    2 +-
 17 files changed, 321 insertions(+), 1017 deletions(-)
