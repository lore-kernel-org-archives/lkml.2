Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab0HXXC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:02:29 -0400
Received: from kroah.org ([198.145.64.141]:41048 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933447Ab0HXXCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:20 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:05 2010
Message-Id: <20100824224505.360732270@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: [047/114] drm/i915/edp: Flush the write before waiting for PLLs
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 5ddb954b9ee50824977d2931e0ff58b3050b337d upstream.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1502,6 +1502,7 @@ static void ironlake_enable_pll_edp (str
 	dpa_ctl = I915_READ(DP_A);
 	dpa_ctl |= DP_PLL_ENABLE;
 	I915_WRITE(DP_A, dpa_ctl);
+	POSTING_READ(DP_A);
 	udelay(200);
 }
 


