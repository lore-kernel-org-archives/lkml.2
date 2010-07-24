Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0GXIq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:46:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47502 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab0GXIqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:46:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 2/2] vmscan: change shrink_slab() return tyep with void
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100724174038.3C96.A69D9226@jp.fujitsu.com>
References: <20100722190100.GA22269@amd> <20100724174038.3C96.A69D9226@jp.fujitsu.com>
Message-Id: <20100724174455.3C9C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat, 24 Jul 2010 17:46:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, no caller use the return value of shrink_slab(). Thus we can change
it with void.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bfa1975..89b593e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -277,24 +277,23 @@ EXPORT_SYMBOL(shrinker_do_scan);
  *
  * Returns the number of slab objects which we shrunk.
  */
-static unsigned long shrink_slab(struct zone *zone, unsigned long scanned, unsigned long total,
+static void shrink_slab(struct zone *zone, unsigned long scanned, unsigned long total,
 			unsigned long global, gfp_t gfp_mask)
 {
 	struct shrinker *shrinker;
-	unsigned long ret = 0;
 
 	if (scanned == 0)
 		scanned = SWAP_CLUSTER_MAX;
 
 	if (!down_read_trylock(&shrinker_rwsem))
-		return 1;	/* Assume we'll be able to shrink next time */
+		return;
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		(*shrinker->shrink)(shrinker, zone, scanned,
 					total, global, gfp_mask);
 	}
 	up_read(&shrinker_rwsem);
-	return ret;
+	return;
 }
 
 void shrink_all_slab(void)
-- 
1.6.5.2



