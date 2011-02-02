Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1BBBJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:09:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:1497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab1BBAnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504903"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: borislav.petkov@amd.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [19/139] amd64_edac: Fix interleaving check
Message-Id: <20110202004333.AF0D83E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Borislav Petkov <borislav.petkov@amd.com>

commit e726f3c368e7c1919a7166ec09c5705759f1a69d upstream.

When matching error address to the range contained by one memory node,
we're in valid range when node interleaving

1. is disabled, or
2. enabled and when the address bits we interleave on match the
interleave selector on this node (see the "Node Interleaving" section in
the BKDG for an enlightening example).

Thus, when we early-exit, we need to reverse the compound logic
statement properly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/edac/amd64_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/edac/amd64_edac.c
===================================================================
--- linux-2.6.35.y.orig/drivers/edac/amd64_edac.c
+++ linux-2.6.35.y/drivers/edac/amd64_edac.c
@@ -1567,7 +1567,7 @@ static int f10_match_to_this_node(struct
 	debugf1("   HoleOffset=0x%x  HoleValid=0x%x IntlvSel=0x%x\n",
 			hole_off, hole_valid, intlv_sel);
 
-	if (intlv_en ||
+	if (intlv_en &&
 	    (intlv_sel != ((sys_addr >> 12) & intlv_en)))
 		return -EINVAL;
 
