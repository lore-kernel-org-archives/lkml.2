Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1CPQOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:14:50 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:54017 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092Ab1CPQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:14:43 -0400
Date: Wed, 16 Mar 2011 17:08:04 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: Jerome Glisse <jglisse@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] radeon: merge list_del()/list_add_tail() to
 list_move_tail()
Message-ID: <20110316170804.4fd96754@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge list_del() + list_add_tail() to list_move_tail().

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/gpu/drm/radeon/radeon_fence.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 171b0b2..9e59868 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -60,8 +60,7 @@ int radeon_fence_emit(struct radeon_device *rdev, struct radeon_fence *fence)
 
 	trace_radeon_fence_emit(rdev->ddev, fence->seq);
 	fence->emited = true;
-	list_del(&fence->list);
-	list_add_tail(&fence->list, &rdev->fence_drv.emited);
+	list_move_tail(&fence->list, &rdev->fence_drv.emited);
 	write_unlock_irqrestore(&rdev->fence_drv.lock, irq_flags);
 	return 0;
 }
@@ -121,8 +120,7 @@ static bool radeon_fence_poll_locked(struct radeon_device *rdev)
 		i = n;
 		do {
 			n = i->prev;
-			list_del(i);
-			list_add_tail(i, &rdev->fence_drv.signaled);
+			list_move_tail(i, &rdev->fence_drv.signaled);
 			fence = list_entry(i, struct radeon_fence, list);
 			fence->signaled = true;
 			i = n;
-- 
1.7.3.4
