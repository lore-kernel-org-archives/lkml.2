Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0DVT1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:27:32 -0400
Received: from kroah.org ([198.145.64.141]:37121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0DVT1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:30 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:08 2010
Message-Id: <20100422190907.954471397@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@redhat.com>
Subject: [006/197] drm/radeon/kms: dont print error on -ERESTARTSYS.
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 97f23b3d85a4d734a8584dade3a34579931c8f8d upstream.

We can get this if the user moves the mouse when we are waiting to move
some stuff around in the validate. Don't fail.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -247,7 +247,8 @@ int radeon_cs_ioctl(struct drm_device *d
 	}
 	r = radeon_cs_parser_relocs(&parser);
 	if (r) {
-		DRM_ERROR("Failed to parse relocation !\n");
+		if (r != -ERESTARTSYS)
+			DRM_ERROR("Failed to parse relocation %d!\n", r);
 		radeon_cs_parser_fini(&parser, r);
 		mutex_unlock(&rdev->cs_mutex);
 		return r;


