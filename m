Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1LSOW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:22:57 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36253 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1LSOWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:22:54 -0500
Date: Mon, 19 Dec 2011 14:22:42 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] vmware fixes
Message-ID: <alpine.DEB.2.00.1112191420040.19088@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

These are just vmware fixes, Thomas sent them a couple of weeks back and 
my brain misparsed them, they are all crucial correctness fixes for vmwgfx 
and I really should have sent them on earlier.

Thanks,
Dave.

The following changes since commit 390f998509bf049019df0b078c0a6606e0d57fb4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6 (2011-12-18 14:28:31 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Jakob Bornecrantz (7):
      vmwgfx: Remove dmabuf check in present ioctl
      vmwgfx: Refactor cursor update
      vmwgfx: Add helper function to get surface or dmabuf
      vmwgfx: Refactor kms code to use vmw_user_lookup_handle helper
      vmwgfx: Do better culling of presents
      vmwgfx: Resend the cursor after legacy modeset
      vmwgfx: Clip cliprects against screen boundaries in present and dirty

Thomas Hellstrom (1):
      vmwgfx: Use the revised fifo hw version register when present

 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h      |    5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c     |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c    |   16 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c      |  394 +++++++++++++++++++-----------
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h      |    5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c      |   22 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   23 ++
 7 files changed, 318 insertions(+), 155 deletions(-)
