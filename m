Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab2FFIPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:15:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab2FFIPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:15:19 -0400
X-IronPort-AV: E=Sophos;i="4.75,722,1330876800"; 
   d="scan'208";a="5122724"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/7] highmem: rearrange export symbol of __kmap_atomic_idx
Date: Wed, 6 Jun 2012 16:14:55 +0800
Message-Id: <1338970501-5098-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/06 16:15:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/06 16:16:01,
	Serialize complete at 2012/06/06 16:16:01
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make it near to its defintion.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/highmem.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 57d82c6..0036dd5 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -32,6 +32,7 @@
 
 #if defined(CONFIG_HIGHMEM) || defined(CONFIG_X86_32)
 DEFINE_PER_CPU(int, __kmap_atomic_idx);
+EXPORT_PER_CPU_SYMBOL(__kmap_atomic_idx);
 #endif
 
 /*
@@ -47,9 +48,6 @@ DEFINE_PER_CPU(int, __kmap_atomic_idx);
 unsigned long totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(totalhigh_pages);
 
-
-EXPORT_PER_CPU_SYMBOL(__kmap_atomic_idx);
-
 unsigned int nr_free_highpages (void)
 {
 	pg_data_t *pgdat;
-- 
1.7.7

