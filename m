Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab2BTUmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:42:54 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34803 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab2BTUm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:42:29 -0500
From: Andrew Vagin <avagin@openvz.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, avagin@openvz.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] Re: [PATCH] trace: don't print an extra separator of flags
Date: Mon, 20 Feb 2012 23:43:30 +0300
Message-Id: <1329770610-703006-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1329767276.25686.40.camel@gandalf.stny.rr.com>
References: <1329767276.25686.40.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you send me that patch. Or a change to the kernel that shows the
> problemi.

Without my patch:
    event-sample-1731  [000] ...1 546886.253576: foo_bar: foo hello 3 |A B
    event-sample-1731  [000] ...1 546887.253677: foo_bar: foo hello 4 |A B

With my patch:
    event-sample-1731  [000] ...1 546886.253576: foo_bar: foo hello 3 A B
    event-sample-1731  [000] ...1 546887.253677: foo_bar: foo hello 4 A B


---
 samples/trace_events/trace-events-sample.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 6af3732..812be4b 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -90,7 +90,7 @@ TRACE_EVENT(foo_bar,
 		__entry->bar	= bar;
 	),
 
-	TP_printk("foo %s %d", __entry->foo, __entry->bar)
+	TP_printk("foo %s %d %s %s", __entry->foo, __entry->bar, __print_flags(1, "|", {1, "A"}), __print_flags(2, "&", {2, "B"}))
 );
 #endif
 
-- 
1.7.1

