Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2EaNiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:38:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44840 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758032Ab2EaNiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:38:11 -0400
Date: Thu, 31 May 2012 14:38:09 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm prime mmap/vmap
Message-ID: <alpine.DEB.2.00.1205311436470.17618@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

as mentioned previously these are the extra bits of drm that relied on the 
dma-buf pull to work, the first three just stub out the mmap interface, 
and the next set provide vmap export to i915/radeon/nouveau and vmap 
import to udl.

Dave.

The following changes since commit af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2012-05-30 11:17:19 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-prime-vmap

for you to fetch changes up to 63bc620b45af8c743ac291c8725933278c712692:

  radeon: add radeon prime vmap support. (2012-05-31 14:14:01 +0100)

----------------------------------------------------------------
Dave Airlie (7):
      i915: add stub dma-buf mmap callback.
      nouveau: add stub dma-buf mmap functionality.
      radeon: add stub dma-buf mmap functionality
      i915: add dma-buf vmap support for exporting vmapped buffer
      udl: support vmapping imported dma-bufs
      nouveau: add vmap support to nouveau prime support
      radeon: add radeon prime vmap support.

 drivers/gpu/drm/i915/i915_drv.h         |    3 ++
 drivers/gpu/drm/i915/i915_gem_dmabuf.c  |   61 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h   |    3 ++
 drivers/gpu/drm/nouveau/nouveau_prime.c |   45 +++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon.h         |    3 ++
 drivers/gpu/drm/radeon/radeon_prime.c   |   44 ++++++++++++++++++++++
 drivers/gpu/drm/udl/udl_fb.c            |   13 ++++++-
 drivers/gpu/drm/udl/udl_gem.c           |   25 +++++++++++--
 8 files changed, 192 insertions(+), 5 deletions(-)
