Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987Ab2FHF0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:26:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43179 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760232Ab2FHFHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:16 -0400
Message-Id: <20120608041847.276867984@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 48/82] drm/radeon: fix HD6790, HD6570 backend programming
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 0408ac2..6a57f0d 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2178,9 +2178,9 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 		WREG32(CC_SYS_RB_BACKEND_DISABLE, rb);
 		WREG32(GC_USER_RB_BACKEND_DISABLE, rb);
 		WREG32(CC_GC_SHADER_PIPE_CONFIG, sp);
-        }
+	}
 
-	grbm_gfx_index |= SE_BROADCAST_WRITES;
+	grbm_gfx_index = INSTANCE_BROADCAST_WRITES | SE_BROADCAST_WRITES;
 	WREG32(GRBM_GFX_INDEX, grbm_gfx_index);
 	WREG32(RLC_GFX_INDEX, grbm_gfx_index);
 


