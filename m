Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0JVS4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:50 -0400
Received: from kroah.org ([198.145.64.141]:34253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab0JVS4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:43 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185233.020270979@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [063/103] drm/i915: fix GMCH power reporting
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit d270ae34eb77c58dea60e5b1e300a698d2ce39ac upstream.

The IPS driver needs to know the current power consumption of the GMCH
in order to make decisions about when to increase or decrease the CPU
and/or GPU power envelope.  So fix up the divisions to save the results
so the numbers are actually correct (contrary to some earlier comments
and code, these functions do not modify the first argument and use it
for the result).

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1778,9 +1778,9 @@ unsigned long i915_chipset_val(struct dr
 		}
 	}
 
-	div_u64(diff, diff1);
+	diff = div_u64(diff, diff1);
 	ret = ((m * diff) + c);
-	div_u64(ret, 10);
+	ret = div_u64(ret, 10);
 
 	dev_priv->last_count1 = total_count;
 	dev_priv->last_time1 = now;
@@ -1849,7 +1849,7 @@ void i915_update_gfx_val(struct drm_i915
 
 	/* More magic constants... */
 	diff = diff * 1181;
-	div_u64(diff, diffms * 10);
+	diff = div_u64(diff, diffms * 10);
 	dev_priv->gfx_power = diff;
 }
 


