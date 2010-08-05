Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab0HEOld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:41:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:41925 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481Ab0HEOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:41:22 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        David Airlie <airlied@linux.ie>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 8/9] drm_fb_helper: Preserve capability to use atomic kms
Date: Thu,  5 Aug 2010 09:39:57 -0500
Message-Id: <1281019198-6777-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-8-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-4-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-5-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-6-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-7-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:10.0592 (UTC) FILETIME=[1B38D600:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5349ef3127c77075ff70b2014f17ae0fbcaaf199 (drm/fb: fix
FBIOGET/PUT_VSCREENINFO pixel clock handling) changed the logic of
when a pixclock was valid vs invalid.

The atomic kernel mode setting used by the kernel debugger relies upon
the drm_fb_helper_check_var() to always return -EINVAL.  Until a
better solution exists, this behavior will be restored.

CC: David Airlie <airlied@linux.ie>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 6245add..de82e20 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -685,7 +685,7 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
 	struct drm_framebuffer *fb = fb_helper->fb;
 	int depth;
 
-	if (var->pixclock != 0)
+	if (var->pixclock != 0 || in_dbg_master())
 		return -EINVAL;
 
 	/* Need to resize the fb object !!! */
-- 
1.6.4.rc1

