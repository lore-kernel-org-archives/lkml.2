Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0GZUxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:53:53 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:46717 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751847Ab0GZUxw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:53:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Rfd6rh5j46wm2z0SJz6TYUirfmOMuqnBrUkwgR7c4olyhrwoAYjnv05MTT0Kdc22FJENK01cysQHIyLNgFoWg1WuZJ+8ywtXqrOSJbyw5TF2B4PZLKXNA6vZSqh0DjKU;
Date: Mon, 26 Jul 2010 13:53:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm-intel fixes since 2.6.35-rc4
Message-ID: <20100726135348.32462738@virtuousgeek.org>
In-Reply-To: <20100726133333.2e540e50@virtuousgeek.org>
References: <87eieqf453.fsf@pollan.anholt.net>
	<AANLkTi=T90D3KNpsVCkyLgEQK4XZ2D6YA6U7pjFNdCUK@mail.gmail.com>
	<20100726133333.2e540e50@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here you go.  Tested on the problem machine, works fine.

>From a9daaec5a40d572d11f689edac5cb1710c998b1e Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 26 Jul 2010 13:51:22 -0700
Subject: [PATCH] drm/i915: make sure we shut off the panel in eDP configs

Merge error from the last pull request.  Making sure we shut the panel
off is more correct and saves power.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/intel_dp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 5d42661..5dde80f 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -798,7 +798,7 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 			intel_dp_link_down(intel_encoder, dp_priv->DP);
 			if (IS_eDP(intel_encoder)) {
 				ironlake_edp_backlight_off(dev);
-				ironlake_edp_backlight_off(dev);
+				ironlake_edp_panel_off(dev);
 			}
 		}
 	} else {
-- 
1.7.1

