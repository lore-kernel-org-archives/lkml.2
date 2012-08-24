Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030614Ab2HXWQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:16:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43052 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252Ab2HXWQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:16:41 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH drm-next 3/3] drm/i915/contexts: Fixup merge with commit b6c7488df68a
Date: Sat, 25 Aug 2012 00:16:24 +0200
Message-Id: <1345846584-5910-3-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345846584-5910-1-git-send-email-sedat.dilek@gmail.com>
References: <1345846584-5910-1-git-send-email-sedat.dilek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fixup patch for the merge of drm-next into linux-next caused
by commit b6c7488df68a ("drm/i915/contexts: fix list corruption").

Reported-By: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 4f6841d..e8a5cb2 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2273,11 +2273,11 @@ int i915_gpu_idle(struct drm_device *dev)
 
 	/* Flush everything onto the inactive list. */
 	for_each_ring(ring, dev_priv, i) {
-		ret = i915_switch_context(ring, NULL, DEFAULT_CONTEXT_ID);
+		ret = i915_ring_idle(ring);
 		if (ret)
 			return ret;
 
-		ret = i915_ring_idle(ring);
+		ret = i915_switch_context(ring, NULL, DEFAULT_CONTEXT_ID);
 		if (ret)
 			return ret;
 
-- 
1.7.9.5

