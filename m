Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2KZJ4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:56:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:31750 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab2KZJ4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:56:02 -0500
X-IronPort-AV: E=Sophos;i="4.83,320,1352044800"; 
   d="scan'208";a="6277026"
Message-ID: <50B33E35.2020106@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 18:02:29 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
CC: Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Jiang Liu <liuj97@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] memory: fix the argument passed to sync_alobal_pgds()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/26 17:55:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/26 17:55:37,
	Serialize complete at 2012/11/26 17:55:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address rang of sync_global_pgds() should be [start, end],
but we pass [start, end) to this function.

Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/mm/init_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 3baff25..df50b43 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -605,7 +605,7 @@ kernel_physical_mapping_init(unsigned long start,
 	}
 
 	if (pgd_changed)
-		sync_global_pgds(addr, end);
+		sync_global_pgds(addr, end - 1);
 
 	__flush_tlb_all();
 
@@ -979,7 +979,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 		}
 
 	}
-	sync_global_pgds((unsigned long)start_page, end);
+	sync_global_pgds((unsigned long)start_page, end - 1);
 	return 0;
 }
 
-- 
1.8.0
