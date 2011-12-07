Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab1LGQQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:16:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab1LGQQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:16:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:23 2011
Message-Id: <20111207160823.366499992@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:29 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Eric Anholt <eric@anholt.net>,
        Keith Packard <keithp@keithp.com>
Subject: [09/80] drm/i915: Turn on another required clock gating bit on gen6.
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 9ca1d10d748e56964de95e3ed80211b192f56cf4 upstream.

Unlike the previous one, I don't have known testcases it fixes.  I'd
rather not go through the same debug cycle on whatever testcases those
might be.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3372,6 +3372,7 @@
 
 #define GEN6_UCGCTL2				0x9404
 # define GEN6_RCPBUNIT_CLOCK_GATE_DISABLE		(1 << 12)
+# define GEN6_RCCUNIT_CLOCK_GATE_DISABLE		(1 << 11)
 
 #define GEN6_RPNSWREQ				0xA008
 #define   GEN6_TURBO_DISABLE			(1<<31)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7411,8 +7411,13 @@ static void gen6_init_clock_gating(struc
 	 * some amount of runtime in the Mesa "fire" demo, and Unigine
 	 * Sanctuary and Tropics, and apparently anything else with
 	 * alpha test or pixel discard.
+	 *
+	 * According to the spec, bit 11 (RCCUNIT) must also be set,
+	 * but we didn't debug actual testcases to find it out.
 	 */
-	I915_WRITE(GEN6_UCGCTL2, GEN6_RCPBUNIT_CLOCK_GATE_DISABLE);
+	I915_WRITE(GEN6_UCGCTL2,
+		   GEN6_RCPBUNIT_CLOCK_GATE_DISABLE |
+		   GEN6_RCCUNIT_CLOCK_GATE_DISABLE);
 
 	/*
 	 * According to the spec the following bits should be


