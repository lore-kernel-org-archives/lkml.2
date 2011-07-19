Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1GSLqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 07:46:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1GSLqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 07:46:24 -0400
Date: Tue, 19 Jul 2011 12:46:19 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: page allocator: Reconsider zones for allocation after
 direct reclaim fix
Message-ID: <20110719114619.GG5349@suse.de>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de>
 <1310742540-22780-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1310742540-22780-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mm/page_alloc.c: In function ‘__alloc_pages_direct_reclaim’:
mm/page_alloc.c:1983:3: error: implicit declaration of function ‘zlc_clear_zones_full’

This patch is a build fix for !CONFIG_NUMA that should be merged with
mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch .

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 149409c..0f50cdb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1647,6 +1647,10 @@ static int zlc_zone_worth_trying(struct zonelist *zonelist, struct zoneref *z,
 static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
 {
 }
+
+static void zlc_clear_zones_full(struct zonelist *zonelist)
+{
+}
 #endif	/* CONFIG_NUMA */
 
 /*
