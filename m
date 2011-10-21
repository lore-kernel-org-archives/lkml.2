Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1JURzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 13:55:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab1JURzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 13:55:39 -0400
Date: Fri, 21 Oct 2011 12:51:02 -0400
From: Dave Jones <davej@redhat.com>
To: airlied@redhat.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [DRM] Lower the severity of the radeon lockup messages.
Message-ID: <20111021165101.GA27960@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, airlied@redhat.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

abrt files a lot of bug reports when users get GPU lockups, but there's not really
enough context to do anything useful with them.  Given the lack of GPU context being
dumped, this patch removes the stack trace, so that abrt ignores the messages.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 7fd4e3e..a488b50 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -263,7 +263,7 @@ retry:
 		 */
 		if (seq == rdev->fence_drv.last_seq && radeon_gpu_is_lockup(rdev)) {
 			/* good news we believe it's a lockup */
-			WARN(1, "GPU lockup (waiting for 0x%08X last fence id 0x%08X)\n",
+			printk(KERN_WARNING "GPU lockup (waiting for 0x%08X last fence id 0x%08X)\n",
 			     fence->seq, seq);
 			/* FIXME: what should we do ? marking everyone
 			 * as signaled for now
