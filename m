Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1I1Wj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab1I1WjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:30 2011
Message-Id: <20110928220130.639155715@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [051/244] drm/radeon/kms: set a default max_pixel_clock
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 9adceaa5b3d2480e2252c4a7f9c4bd7d66b8c4a2 upstream.

On some Power rv100 cards, we have no ATY OF table, but we have
no combios table either, and hence we refuse all modes on VGA-0
since we end up with a 0 max pixel clock.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_clocks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_clocks.c
+++ b/drivers/gpu/drm/radeon/radeon_clocks.c
@@ -219,6 +219,9 @@ void radeon_get_clock_info(struct drm_de
 		} else {
 			DRM_INFO("Using generic clock info\n");
 
+			/* may need to be per card */
+			rdev->clock.max_pixel_clock = 35000;
+
 			if (rdev->flags & RADEON_IS_IGP) {
 				p1pll->reference_freq = 1432;
 				p2pll->reference_freq = 1432;


