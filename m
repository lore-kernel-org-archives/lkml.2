Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab1BPAZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:25:29 -0500
Received: from kroah.org ([198.145.64.141]:49864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab1BPAZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:50 2011
Message-Id: <20110216001450.293918592@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [252/272] drm/radeon/kms/evergreen: always set certain VGT regs at CP init
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 18ff84da29b3f0c073e0ce6e341663cc6bcb0ab7 upstream.

These should be handled by the clear_state setup, but set them
directly as well just to be sure.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1135,7 +1135,7 @@ static int evergreen_cp_start(struct rad
 	cp_me = 0xff;
 	WREG32(CP_ME_CNTL, cp_me);
 
-	r = radeon_ring_lock(rdev, evergreen_default_size + 15);
+	r = radeon_ring_lock(rdev, evergreen_default_size + 19);
 	if (r) {
 		DRM_ERROR("radeon: cp failed to lock ring (%d).\n", r);
 		return r;
@@ -1168,6 +1168,11 @@ static int evergreen_cp_start(struct rad
 	radeon_ring_write(rdev, 0xffffffff);
 	radeon_ring_write(rdev, 0xffffffff);
 
+	radeon_ring_write(rdev, 0xc0026900);
+	radeon_ring_write(rdev, 0x00000316);
+	radeon_ring_write(rdev, 0x0000000e); /* VGT_VERTEX_REUSE_BLOCK_CNTL */
+	radeon_ring_write(rdev, 0x00000010); /*  */
+
 	radeon_ring_unlock_commit(rdev);
 
 	return 0;


