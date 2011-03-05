Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab1CEBS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:18:58 -0500
Received: from kroah.org ([198.145.64.141]:50130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760177Ab1CEA7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:59:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:35 2011
Message-Id: <20110305005635.458998955@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [09/73] Revert "drm/radeon/kms: switch back to min->max pll post divider iteration"
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit bd6a60afeb4c9ada3ff27f1d13db1a2b5c11d8c0 upstream.

This reverts commit a6f9761743bf35b052180f4a8bdae4d2cc0465f6.

Remove this commit as it is no longer necessary. The relevant bugs
were fixed properly in:
drm/radeon/kms: hopefully fix pll issues for real (v3)
5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff
drm/radeon/kms: add missing frac fb div flag for dce4+
9f4283f49f0a96a64c5a45fe56f0f8c942885eef

This commit also broke certain ~5 Mhz modes on old arcade monitors,
so reverting this commit fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=29502

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -639,7 +639,7 @@ void radeon_compute_pll_legacy(struct ra
 		max_fractional_feed_div = pll->max_frac_feedback_div;
 	}
 
-	for (post_div = min_post_div; post_div <= max_post_div; ++post_div) {
+	for (post_div = max_post_div; post_div >= min_post_div; --post_div) {
 		uint32_t ref_div;
 
 		if ((pll->flags & RADEON_PLL_NO_ODD_POST_DIV) && (post_div & 1))


