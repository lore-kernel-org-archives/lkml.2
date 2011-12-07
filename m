Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab1LGQPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:15:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab1LGQPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:15:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:23 2011
Message-Id: <20111207160823.530826216@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:31 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>, Timo Aaltonen <timo@canonical.com>
Subject: [11/80] drm/i915: fix CB tuning check for ILK+
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit cb0e093162d7b6589c2217a00e2abfef686b32d6 upstream.

CB tuning is needed to handle potential process variations that might
cause clock jitter for certain PLL settings.  However, we were setting
it incorrectly since we were using the wrong M value as a check (M1 when
we needed to use the whole M value).  Fix it up, making my HDMI
attached display a little prettier (used to have occasional dots crawl
across the display).

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Timo Aaltonen <timo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4972,7 +4972,7 @@ static int ironlake_crtc_mode_set(struct
 	} else if (is_sdvo && is_tv)
 		factor = 20;
 
-	if (clock.m1 < factor * clock.n)
+	if (clock.m < factor * clock.n)
 		fp |= FP_CB_TUNE;
 
 	dpll = 0;


