Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1EKPzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:55:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40723 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab1EKPzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:55:43 -0400
Date: Wed, 11 May 2011 05:08:51 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1105110505340.23958@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

two fixes for issues myself and Alex discovered trying to bring up accel 
on the cayman hardware. The other change is a bit gross but is all I'm 
comfortable with doing this close to a release, it fixes an build failure 
on alpha due to the first attempt at supporting Xen + drm drivers, we 
actually backed out the change that needs these paths to work so I've just 
commented out the two paths for now until Konrad and Thomas work out how 
to do this cleanly or just go back to having no Xen support, I seem to 
remember someone worrying about Xen making crap out of drivers once merged 
and I'm hoping we aren't the first victim, but I'll give them some more 
time to find an acceptable solution.

Dave.

The following changes since commit 9f381a61f58bb6487c93ce2233bb9992f8ea9211:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-05-10 17:39:01 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: fix cayman acceleration

Dave Airlie (2):
      drm/radeon: fix cayman struct accessors.
      drm/radeon/nouveau: fix build regression on alpha due to Xen changes.

 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    3 ++-
 drivers/gpu/drm/radeon/ni.c             |   18 +++++++++---------
 drivers/gpu/drm/radeon/radeon_gart.c    |    6 +++---
 3 files changed, 14 insertions(+), 13 deletions(-)
