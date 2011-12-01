Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1LAJUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:20:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46218 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1LAJUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:20:38 -0500
From: Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [PATCH] mm: incorrect overflow check in shrink_slab()
Date: Thu, 1 Dec 2011 04:20:34 -0500
Message-Id: <0D9D9F79-204D-4460-8CE7-A583C5C38A1E@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

total_scan is unsigned long, so the overflow check (total_scan < 0)
didn't work.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a1893c0..46a04e7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -270,7 +270,7 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
 		total_scan += delta;
-		if (total_scan < 0) {
+		if ((long)total_scan < 0) {
 			printk(KERN_ERR "shrink_slab: %pF negative objects to "
 			       "delete nr=%ld\n",
 			       shrinker->shrink, total_scan);
-- 
1.7.5.4


