Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab2FGEYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:24:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab2FGEYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:24:38 -0400
Message-Id: <20120607041402.199402156@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:26 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 28/47] drm/radeon: fix HD6790, HD6570 backend programming
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 95c4b23ec4e2fa5604df229ddf134e31d7b3b378 upstream.

Without this bit sets we get broken rendering and
lockups.

fglrx sets this bit.

Bugs that should be fixed by this patch :
https://bugs.freedesktop.org/show_bug.cgi?id=49792
https://bugzilla.kernel.org/show_bug.cgi?id=43207
https://bugs.freedesktop.org/show_bug.cgi?id=39282

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2069,9 +2069,9 @@ static void evergreen_gpu_init(struct ra
 		WREG32(CC_SYS_RB_BACKEND_DISABLE, rb);
 		WREG32(GC_USER_RB_BACKEND_DISABLE, rb);
 		WREG32(CC_GC_SHADER_PIPE_CONFIG, sp);
-        }
+	}
 
-	grbm_gfx_index |= SE_BROADCAST_WRITES;
+	grbm_gfx_index = INSTANCE_BROADCAST_WRITES | SE_BROADCAST_WRITES;
 	WREG32(GRBM_GFX_INDEX, grbm_gfx_index);
 	WREG32(RLC_GFX_INDEX, grbm_gfx_index);
 


