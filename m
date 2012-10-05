Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2JEJ7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:59:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab2JEJ7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:59:51 -0400
Date: Fri, 5 Oct 2012 10:59:45 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH] mm: compaction: Iron out isolate_freepages_block() and
 isolate_freepages_range() -fix2
Message-ID: <20121005095945.GC29125@suse.de>
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
 <20120927151159.4427fc8f.akpm@linux-foundation.org>
 <20120928054330.GA27594@bbox>
 <20121004140017.GW29125@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121004140017.GW29125@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry reported offline that the strict check "mm: compaction: Iron out
isolate_freepages_block() and isolate_freepages_range() -fix1" check is
still too strict because it's possible for more pages to be isolated
than required. This patch corrects the check.

There are still CMA-related problems but they are "somewhere else" yet
to be determined.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 2c4ce17..9eef558 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -346,7 +346,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 	 * pages requested were isolated. If there were any failures, 0 is
 	 * returned and CMA will fail.
 	 */
-	if (strict && nr_strict_required != total_isolated)
+	if (strict && nr_strict_required > total_isolated)
 		total_isolated = 0;
 
 	if (locked)
