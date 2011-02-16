Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1BPAZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:25:40 -0500
Received: from kroah.org ([198.145.64.141]:49886 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab1BPAZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:50 2011
Message-Id: <20110216001450.585177732@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [255/272] drm/i915: check eDP encoder correctly when setting modes
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 858bc21f0637c407601a05626854ae58b242f75d upstream.

We were using a stale pointer in the check which caused us to use CPU
attached DP params when we should have been using PCH attached params.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=31988
Tested-by: Jan-Hendrik Zab <jan@jhz.name>
Tested-by: Christoph Lukas <christoph.lukas@gmx.net>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3714,7 +3714,7 @@ static int intel_crtc_mode_set(struct dr
 		int lane = 0, link_bw, bpp;
 		/* CPU eDP doesn't require FDI link, so just set DP M/N
 		   according to current link config */
-		if (has_edp_encoder && !intel_encoder_is_pch_edp(&encoder->base)) {
+		if (has_edp_encoder && !intel_encoder_is_pch_edp(&has_edp_encoder->base)) {
 			target_clock = mode->clock;
 			intel_edp_link_config(has_edp_encoder,
 					      &lane, &link_bw);


