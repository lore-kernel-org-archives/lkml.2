Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1BVWgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:36:23 -0500
Received: from kroah.org ([198.145.64.141]:46577 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab1BVWVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221837.973296507@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [09/70] drm/radeon/kms: add bounds checking to avivo pll algo
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit a4b40d5d97f5c9ad0b7f4bf2818291ca184bb433 upstream.

Prevent divider overflow.
Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=28932

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_display.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -461,6 +461,11 @@ static void avivo_get_fb_div(struct rade
 	tmp *= target_clock;
 	*fb_div = tmp / pll->reference_freq;
 	*frac_fb_div = tmp % pll->reference_freq;
+
+        if (*fb_div > pll->max_feedback_div)
+		*fb_div = pll->max_feedback_div;
+        else if (*fb_div < pll->min_feedback_div)
+                *fb_div = pll->min_feedback_div;
 }
 
 static u32 avivo_get_post_div(struct radeon_pll *pll,
@@ -494,6 +499,11 @@ static u32 avivo_get_post_div(struct rad
 			post_div--;
 	}
 
+	if (post_div > pll->max_post_div)
+		post_div = pll->max_post_div;
+	else if (post_div < pll->min_post_div)
+		post_div = pll->min_post_div;
+
 	return post_div;
 }
 


