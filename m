Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab2ITF7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:59:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab2ITF7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:59:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344182400"; 
   d="scan'208";a="5875808"
Message-ID: <505AB1FF.8020104@cn.fujitsu.com>
Date: Thu, 20 Sep 2012 14:04:47 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, khlebnikov@openvz.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace: don't call page_to_pfn() if page is NULL
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/20 13:59:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/20 13:59:23,
	Serialize complete at 2012/09/20 13:59:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating memory fails, page is NULL. page_to_pfn() will
cause the kernel panicked if we don't use sparsemem vmemmap.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

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
-- 
1.7.1
