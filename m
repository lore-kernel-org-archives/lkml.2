Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2LCOhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:37:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43987 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932472Ab2LCOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:37:04 -0500
Message-Id: <20121203143150.070434560@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:06 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 20/89] x86, mm: Undo incorrect revert in arch/x86/mm/init.c
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit f82f64dd9f485e13f29f369772d4a0e868e5633a upstream.

Commit

    844ab6f9 x86, mm: Find_early_table_space based on ranges that are actually being mapped

added back some lines back wrongly that has been removed in commit

    7b16bbf97 Revert "x86/mm: Fix the size calculation of mapping tables"

remove them again.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQW_vuaYQbmagVnxT2DGsYc=9tNeAbdBq53sYkitPOwxSQ@mail.gmail.com
Acked-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/mm/init.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc287d6..d7aea41 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -65,10 +65,6 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 #ifdef CONFIG_X86_32
 			extra += PMD_SIZE;
 #endif
-			/* The first 2/4M doesn't use large pages. */
-			if (mr[i].start < PMD_SIZE)
-				extra += range;
-
 			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		} else {
 			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;


