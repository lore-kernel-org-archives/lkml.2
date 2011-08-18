Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1HRCX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:23:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61446 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab1HRCXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:23:53 -0400
Message-ID: <4E4C77D0.4020601@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 10:24:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: Mark perf_data_size() inline
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 10:22:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 10:22:37,
	Serialize complete at 2011-08-18 10:22:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we'll get compile warning if internal.h is included but
perf_data_size() is not used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/events/internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 09097dd..a318056 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -64,7 +64,7 @@ static inline int page_order(struct ring_buffer *rb)
 }
 #endif
 
-static unsigned long perf_data_size(struct ring_buffer *rb)
+static inline unsigned long perf_data_size(struct ring_buffer *rb)
 {
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
 }
-- 
1.7.3.1
