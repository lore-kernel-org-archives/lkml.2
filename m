Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2IUMig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:38:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2IUMie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:38:34 -0400
Date: Fri, 21 Sep 2012 05:37:52 -0700
From: tip-bot for Wen Congyang <wency@cn.fujitsu.com>
Message-ID: <tip-85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, minchan@kernel.org, mel@csn.ul.ie,
        stable@vger.kernel.org, wency@cn.fujitsu.com, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie,
        stable@vger.kernel.org, wency@cn.fujitsu.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <505AB1FF.8020104@cn.fujitsu.com>
References: <505AB1FF.8020104@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Don't call page_to_pfn()
  if page is NULL
Git-Commit-ID: 85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 05:37:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa
Gitweb:     http://git.kernel.org/tip/85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa
Author:     Wen Congyang <wency@cn.fujitsu.com>
AuthorDate: Thu, 20 Sep 2012 14:04:47 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 20 Sep 2012 15:51:16 -0400

tracing: Don't call page_to_pfn() if page is NULL

When allocating memory fails, page is NULL. page_to_pfn() will
cause the kernel panicked if we don't use sparsemem vmemmap.

Link: http://lkml.kernel.org/r/505AB1FF.8020104@cn.fujitsu.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable <stable@vger.kernel.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/kmem.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
