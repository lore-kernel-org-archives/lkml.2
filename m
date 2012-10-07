Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2JGX23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:28:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38654 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648Ab2JGXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:20 -0400
Message-Id: <20121007225839.545899321@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wen Congyang <wency@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 035/108] tracing: Dont call page_to_pfn() if page is NULL
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Congyang <wency@cn.fujitsu.com>

commit 85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa upstream.

When allocating memory fails, page is NULL. page_to_pfn() will
cause the kernel panicked if we don't use sparsemem vmemmap.

Link: http://lkml.kernel.org/r/505AB1FF.8020104@cn.fujitsu.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/trace/events/kmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 5f889f1..08fa272 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -214,7 +214,7 @@ TRACE_EVENT(mm_page_alloc,
 
 	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		show_gfp_flags(__entry->gfp_flags))
@@ -240,7 +240,7 @@ DECLARE_EVENT_CLASS(mm_page,
 
 	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		__entry->order == 0)


