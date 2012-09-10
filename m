Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2IJJAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:00:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20577 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab2IJJAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:00:10 -0400
X-IronPort-AV: E=Sophos;i="4.80,397,1344182400"; 
   d="scan'208";a="5814201"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V4 PATCH 22/26] x86: use memblock_set_current_limit() to set memblock.current_limit
Date: Mon, 10 Sep 2012 16:59:14 +0800
Message-Id: <1347267558-6707-23-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:21,
	Serialize complete at 2012/09/10 16:57:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

memblock.current_limit is set directly though memblock_set_current_limit()
is prepared. So fix it.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..bb9d9f8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -889,7 +889,7 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());
 	memblock_x86_fill();
 
 	/*
@@ -925,7 +925,7 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 	}
 #endif
-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
-- 
1.7.1

