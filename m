Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0FYIbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:31:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40522 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0FYIbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:31:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vmscan: zone_reclaim don't call disable_swap_token()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100625173002.8052.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 17:31:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap token don't works when zone reclaim is enabled since it was born.
Because __zone_reclaim() always call disable_swap_token()
unconditionally.

This kill swap token feature completely. As far as I know, nobody want
to that. Remove it.

Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c7e57c..0c961f1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2590,7 +2590,6 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	};
 	unsigned long slab_reclaimable;
 
-	disable_swap_token();
 	cond_resched();
 	/*
 	 * We need to be able to allocate from the reserves for RECLAIM_SWAP
-- 
1.6.5.2



