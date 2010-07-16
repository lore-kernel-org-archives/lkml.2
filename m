Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989Ab0GPKRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:17:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33511 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951Ab0GPKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:17:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: [PATCH 6/7] vmscan: convert mm_vmscan_lru_isolate to DEFINE_EVENT
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100716191006.7369.A69D9226@jp.fujitsu.com>
References: <20100716191006.7369.A69D9226@jp.fujitsu.com>
Message-Id: <20100716191649.737B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Jul 2010 19:17:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TRACE_EVENT() is a bit old fashion and we need to use
DECLARE_EVENT_CLASS for introducing memcg isolate pages
tracepoint.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/trace/events/vmscan.h |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index cc19cb0..e37fe72 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -152,7 +152,7 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_re
 );
 
 
-TRACE_EVENT(mm_vmscan_lru_isolate,
+DECLARE_EVENT_CLASS(mm_vmscan_lru_isolate_template,
 
 	TP_PROTO(int order,
 		unsigned long nr_requested,
@@ -198,6 +198,21 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_lumpy_failed)
 );
 
+DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_lru_isolate,
+
+	TP_PROTO(int order,
+		unsigned long nr_requested,
+		unsigned long nr_scanned,
+		unsigned long nr_taken,
+		unsigned long nr_lumpy_taken,
+		unsigned long nr_lumpy_dirty,
+		unsigned long nr_lumpy_failed,
+		int isolate_mode),
+
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
+
+);
+
 TRACE_EVENT(mm_vmscan_writepage,
 
 	TP_PROTO(struct page *page,
-- 
1.6.5.2



