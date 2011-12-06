Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1LFQTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:19:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39571 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1LFQTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:19:10 -0500
Date: Tue, 6 Dec 2011 16:21:52 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1112061619190.11925@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

3 fixes, one for an ongoing Intel VT-d/Ironlake GPU that I've been 
testing, and one kexec fix from Jerome for an issue reported on the list
where the gpu writeback engines need to be switched off, along with a 
trivial fix from Alex.

Due to the size of the kexec fix I've decided to keep this pull small.
(I have some kzalloc->kcalloc fixes to check on).

Dave.

The following changes since commit 45e713efe2fa574b6662e7fb63fae9497c5e03d4:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2011-12-05 16:54:15 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: fix return type for radeon_encoder_get_dp_bridge_encoder_id

Daniel Vetter (1):
      drm/i915: fix infinite recursion on unbind due to ilk vt-d w/a

Jerome Glisse (1):
      drm/radeon: disable possible GPU writeback early v3

 drivers/gpu/drm/i915/i915_gem.c          |    7 ++++++-
 drivers/gpu/drm/radeon/evergreen.c       |    2 ++
 drivers/gpu/drm/radeon/ni.c              |   18 ++++++++++++++++++
 drivers/gpu/drm/radeon/nid.h             |   19 +++++++++++++++++++
 drivers/gpu/drm/radeon/r100.c            |   20 ++++++--------------
 drivers/gpu/drm/radeon/r520.c            |    2 +-
 drivers/gpu/drm/radeon/r600.c            |   16 ++++++++++++++++
 drivers/gpu/drm/radeon/radeon_asic.h     |    2 ++
 drivers/gpu/drm/radeon/radeon_encoders.c |    7 +++----
 drivers/gpu/drm/radeon/rs600.c           |   20 +++++++++++++++++++-
 drivers/gpu/drm/radeon/rs600d.h          |   21 +++++++++++++++++++++
 drivers/gpu/drm/radeon/rs690.c           |    2 +-
 drivers/gpu/drm/radeon/rv515.c           |    2 +-
 drivers/gpu/drm/radeon/rv770.c           |   16 ++++++++++++++++
 drivers/gpu/drm/radeon/rv770d.h          |   20 ++++++++++++++++++++
 15 files changed, 151 insertions(+), 23 deletions(-)
