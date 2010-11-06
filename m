Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0KFOlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:41:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64795 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0KFOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HCYUe4YMKZQb31pi1vO+LuOQob0LTSz2Jk/HD6VCnumhqJXNsbJcoE9LSTFXPZJB1g
         +gGTwk2IlVfotmYKmCElPM8liKAMH5dsNP5Mai3ktFMIlb0/fMsrbSwL0XDEY41gE2SK
         qUY9vK/PQFrBD7+B8JdHYZqdb19XuY9QUT82E=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>,
        Dan Carpenter <error27@gmail.com>, Jerome Glisse <jglisse@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: vmwgfx: fix information leak to userland
Date: Sat,  6 Nov 2010 17:41:16 +0300
Message-Id: <1289054477-18100-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure drm_vmw_fence_rep is copied to userland with field "pad64"
uninitialized.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 51d9f9f..76954e3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -691,6 +691,7 @@ int vmw_execbuf_ioctl(struct drm_device *dev, void *data,
 
 	fence_rep.error = ret;
 	fence_rep.fence_seq = (uint64_t) sequence;
+	fence_rep.pad64 = 0;
 
 	user_fence_rep = (struct drm_vmw_fence_rep __user *)
 	    (unsigned long)arg->fence_rep;
-- 
1.7.0.4

