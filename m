Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0IHCEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:04:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57923 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab0IHCEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:04:50 -0400
Date: Wed, 8 Sep 2010 12:04:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@linux.ie>
Subject: linux-next: build failure after merge of the final tree (kgdb and
 Linus trees interaction)
Message-Id: <20100908120445.ffafbf11.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

drivers/gpu/drm/i915/intel_display.c: In function 'intel_pipe_set_base':
drivers/gpu/drm/i915/intel_display.c:1582: error: too few arguments to function 'intel_pipe_set_base_atomic'

Caused by commit 1c5b2529a07ff343731d2b7a44ddedf22951dc6c ("drm,kdb,kms:
Add an enter argument to mode_set_base_atomic() API") (from the kgdb
tree) interacting with commit 4e6cfefc729be2aa20647415317577ed98d4f7bf
("drm/i915: Re-use set_base_atomic to share setting of the display
registers") from Linus' tree (drm fix).

I applied the following merge fix up patch and can carry it for a while.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 8 Sep 2010 12:02:08 +1000
Subject: [PATCH] kgdb: merge fix for mode_set_base_atomic API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 4342b42..0dcb647 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1579,7 +1579,7 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		return ret;
 	}
 
-	ret = intel_pipe_set_base_atomic(crtc, crtc->fb, x, y);
+	ret = intel_pipe_set_base_atomic(crtc, crtc->fb, x, y, 0);
 	if (ret) {
 		i915_gem_object_unpin(obj);
 		mutex_unlock(&dev->struct_mutex);
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
