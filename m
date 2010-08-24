Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0HXSb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:31:28 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:47228 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752871Ab0HXSbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:31:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OlX0lRfnjXfBZRvsK5rubzDKP/VYH+KiK300EMKZ/DWc/95gWSoiptPhRRx+5fAVLUTzs1/IKDhldDM4TkcRXWeezjO8UDo6pRW8O9wAygjLMp1BXB2IaAwDrkeRIt5t;
Date: Tue, 24 Aug 2010 11:31:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH] drm/i915: fix vblank wait test condition
Message-ID: <20100824113116.249c13b4@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting this to the new wait_for macro I inverted the wait
condition, which causes all sorts of problems.  So correct it to fix
several failures caused by the bad wait (flickering, bad output
detection, tearing, etc.).

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 6ccb797..dd90b80 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -992,7 +992,7 @@ void intel_wait_for_vblank(struct drm_device *dev, int pipe)
 
 	/* Wait for vblank interrupt bit to set */
 	if (wait_for((I915_READ(pipestat_reg) &
-		      PIPE_VBLANK_INTERRUPT_STATUS) == 0,
+		      PIPE_VBLANK_INTERRUPT_STATUS),
 		     50, 0))
 		DRM_DEBUG_KMS("vblank wait timed out\n");
 }
-- 
1.6.3.3

