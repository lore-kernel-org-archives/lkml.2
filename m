Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab1BPAac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:30:32 -0500
Received: from kroah.org ([198.145.64.141]:49831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab1BPAZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:49 2011
Message-Id: <20110216001449.781751909@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [247/272] drm/radeon/kms: switch back to min->max pll post divider iteration
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit a6f9761743bf35b052180f4a8bdae4d2cc0465f6 upstream.

Seems more reliable.  Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=26552

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -517,7 +517,7 @@ void radeon_compute_pll(struct radeon_pl
 		max_fractional_feed_div = pll->max_frac_feedback_div;
 	}
 
-	for (post_div = max_post_div; post_div >= min_post_div; --post_div) {
+	for (post_div = min_post_div; post_div <= max_post_div; ++post_div) {
 		uint32_t ref_div;
 
 		if ((pll->flags & RADEON_PLL_NO_ODD_POST_DIV) && (post_div & 1))


