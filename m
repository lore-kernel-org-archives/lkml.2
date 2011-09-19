Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1ISJI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:08:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39224 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab1ISJI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:08:28 -0400
Date: Mon, 19 Sep 2011 10:10:48 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1109191009430.16797@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-582266197-1316423448=:16797"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-582266197-1316423448=:16797
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Some fixes for page size mismatches in radeon, a lockdep noticed locking 
problem, and a fix to zero some memory that was being passed to userspace.

Dave.

The following changes since commit 003f6c9df54970d8b19578d195b3e2b398cdbde2:

  lib/sha1.c: quiet sparse noise about symbol not declared (2011-09-13 16:09:41 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~/linux.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: fix typo in r100_blit_copy
      drm/radeon/kms: Make GPU/CPU page size handling consistent in blit code (v2)

Ben Skeggs (1):
      drm/ttm: request zeroed system memory pages for new TT buffer objects

Michel Dänzer (2):
      drm/radeon: Don't read from CP ring write pointer registers.
      drm/radeon: Unreference GEM object outside of spinlock in page flip error path.

 drivers/gpu/drm/radeon/evergreen.c      |   14 ++++++++------
 drivers/gpu/drm/radeon/ni.c             |   12 ++++++------
 drivers/gpu/drm/radeon/r100.c           |   22 ++++++++++------------
 drivers/gpu/drm/radeon/r200.c           |    4 ++--
 drivers/gpu/drm/radeon/r600.c           |   14 ++++++++------
 drivers/gpu/drm/radeon/radeon.h         |    7 ++++---
 drivers/gpu/drm/radeon/radeon_asic.h    |    8 ++++----
 drivers/gpu/drm/radeon/radeon_display.c |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c     |    7 ++++++-
 drivers/gpu/drm/ttm/ttm_bo.c            |    3 ++-
 10 files changed, 51 insertions(+), 42 deletions(-)
--29444707-582266197-1316423448=:16797--
