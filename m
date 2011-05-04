Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1EDA03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 20:26:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37947 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab1EDA02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 20:26:28 -0400
Date: Wed, 4 May 2011 01:25:55 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1105040122110.8999@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

One core fix for stopping userspace apps hanging when the kernel turns off 
a display, mainly affects i915,

Some new radeon pci ids, a regression fix for people running switchable 
graphics laptops, and a fix to stabilise the fusion APU hw, which 3 of us 
have been searching for for over a week now, finally Jerome narrowed it 
down and Alex found the hw guys moved 3 registers just slightly to piss us 
off, maybe it saved a transistor and software is easy.

Dave.

The following changes since commit 609cfda586c7fe3e5d1a02c51edb587506294167:

  Merge branch 'stable/bug-fixes-for-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2011-05-03 09:25:42 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: add some new pci ids
      drm/radeon/kms: fix gart setup on fusion parts (v2)

Christopher James Halse Rogers (1):
      drm: Send pending vblank events before disabling vblank.

Dave Airlie (1):
      drm/radeon: fix regression on atom cards with hardcoded EDID record.

 drivers/gpu/drm/drm_irq.c                |   23 +++++++++++++++++++++++
 drivers/gpu/drm/radeon/evergreen.c       |   17 +++++++++--------
 drivers/gpu/drm/radeon/evergreend.h      |    5 +++++
 drivers/gpu/drm/radeon/radeon_atombios.c |    5 +++--
 drivers/gpu/drm/radeon/radeon_kms.c      |    3 +++
 include/drm/drm_pciids.h                 |    5 +++++
 include/drm/radeon_drm.h                 |    1 +
 7 files changed, 49 insertions(+), 10 deletions(-)
