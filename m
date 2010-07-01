Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0GAXtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:49:14 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:52323 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751009Ab0GAXtM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:49:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UZI9sI9aajtr3Ae6OgWtWEUcRz1Z9/2nvzJVT41T6ThnTvxsYrknW5IjWYwAiVPO1E9nH0pY8EdpdNWIwISpd+Mm5uzcnanMaH9rTyCVkw7nMb2Kx00kGe3xdgxeJeyD;
Date: Thu, 1 Jul 2010 16:46:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm-intel fixes since 2.6.35-rc1
Message-ID: <20100701164649.7fbeaadf@virtuousgeek.org>
In-Reply-To: <87iq4ykca0.fsf@pollan.anholt.net>
References: <87iq4ykca0.fsf@pollan.anholt.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       drm/i915: gen3 page flipping fixes

I didn't think this one would be queued up yet, it needs a typo fix (see
below).

Linus, if you pull, please apply this on top.

Thanks, 
Jesse Barnes, Intel Open Source Technology Center

>From c76f1288e580ce5ee95ccf55ae7aedc433a3cb54 Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@jbarnes-acer.localdomain>
Date: Thu, 1 Jul 2010 04:45:43 -0700
Subject: [PATCH] drm/i915: fix page flip finish vs. prepare on plane B

The refreshed patch had a copy & paste bug.

Reported-by: Simon Farnsworth <simon.farnsworth@onelan.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index d676e55..dba53d4 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -947,9 +947,9 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 		}
 
 		if (iir & I915_DISPLAY_PLANE_B_FLIP_PENDING_INTERRUPT) {
+			intel_prepare_page_flip(dev, 1);
 			if (dev_priv->flip_pending_is_done)
 				intel_finish_page_flip_plane(dev, 1);
-			intel_prepare_page_flip(dev, 1);
 		}
 
 		if (pipea_stats & vblank_status) {
-- 
1.6.1.3


