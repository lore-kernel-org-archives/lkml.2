Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab0HEUVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:21:10 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55482 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934050Ab0HEUVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:21:04 -0400
Date: Thu, 5 Aug 2010 22:21:02 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 14/42] drivers/video/aty/mach64_ct.c: Adjust confusing if
 indentation
Message-ID: <Pine.LNX.4.64.1008052220440.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Indent the branch of an if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/aty/mach64_ct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/aty/mach64_ct.c b/drivers/video/aty/mach64_ct.c
index 2745b85..204b580 100644
--- a/drivers/video/aty/mach64_ct.c
+++ b/drivers/video/aty/mach64_ct.c
@@ -179,7 +179,7 @@ static int aty_dsp_gt(const struct fb_info *info, u32 bpp, struct pll_ct *pll)
 		dsp_on = ((multiplier << vshift) + divider) / divider;
 		tmp = ((ras_multiplier << xshift) + ras_divider) / ras_divider;
 		if (dsp_on < tmp)
-		dsp_on = tmp;
+			dsp_on = tmp;
 		dsp_on = dsp_on + (tmp * 2) + (pll->xclkpagefaultdelay << xshift);
 	}
 
