Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab0JOBy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 21:54:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60683 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab0JOByY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 21:54:24 -0400
Date: Fri, 15 Oct 2010 12:54:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20101015125420.11500d62.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/r600_blit_kms.c between commit
c919b371cb734f42b1130e706ecee262f8d9261d ("drm/radeon/kms: avoid corner
case issue with unmappable vram V2") from Linus' tree and commit
b70d6bb3f67b2e2964abafb0117f1733f062cba5 ("drm/radeon/kms: clean up
r6xx/r7xx blit init (v2)") from the drm tree.

Just context.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/r600_blit_kms.c
index 3473c007,2a4747d..0000000
--- a/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
@@@ -532,7 -533,18 +533,19 @@@ int r600_blit_init(struct radeon_devic
  	memcpy(ptr + rdev->r600_blit.ps_offset, r6xx_ps, r6xx_ps_size * 4);
  	radeon_bo_kunmap(rdev->r600_blit.shader_obj);
  	radeon_bo_unreserve(rdev->r600_blit.shader_obj);
 +	rdev->mc.active_vram_size = rdev->mc.real_vram_size;
+ 
+ done:
+ 	r = radeon_bo_reserve(rdev->r600_blit.shader_obj, false);
+ 	if (unlikely(r != 0))
+ 		return r;
+ 	r = radeon_bo_pin(rdev->r600_blit.shader_obj, RADEON_GEM_DOMAIN_VRAM,
+ 			  &rdev->r600_blit.shader_gpu_addr);
+ 	radeon_bo_unreserve(rdev->r600_blit.shader_obj);
+ 	if (r) {
+ 		dev_err(rdev->dev, "(%d) pin blit object failed\n", r);
+ 		return r;
+ 	}
  	return 0;
  }
  
