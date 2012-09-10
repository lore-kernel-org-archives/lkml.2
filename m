Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab2IJJFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:05:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62513 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab2IJI5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:57:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,397,1344182400"; 
   d="scan'208";a="5814152"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V4 PATCH 03/26] slub, hotplug: ignore unrelated node's hot-adding and hot-removing
Date: Mon, 10 Sep 2012 16:58:55 +0800
Message-Id: <1347267558-6707-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:19,
	Serialize complete at 2012/09/10 16:57:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB only fucus on the nodes which has normal memory, so ignore the other
node's hot-adding and hot-removing.

so we only do something when marg->status_change_nid_normal > 0.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/slub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8f78e25..7a1d02c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3572,7 +3572,7 @@ static void slab_mem_offline_callback(void *arg)
 	struct memory_notify *marg = arg;
 	int offline_node;
 
-	offline_node = marg->status_change_nid;
+	offline_node = marg->status_change_nid_normal;
 
 	/*
 	 * If the node still has available memory. we need kmem_cache_node
@@ -3605,7 +3605,7 @@ static int slab_mem_going_online_callback(void *arg)
 	struct kmem_cache_node *n;
 	struct kmem_cache *s;
 	struct memory_notify *marg = arg;
-	int nid = marg->status_change_nid;
+	int nid = marg->status_change_nid_normal;
 	int ret = 0;
 
 	/*
-- 
1.7.1

