Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2HFJXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:23:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44379 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab2HFJX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:23:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,719,1336320000"; 
   d="scan'208";a="5560125"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Subject: [RFC V3 PATCH 03/25] slub, hotplug: ignore unrelated node's hot-adding and hot-removing
Date: Mon, 6 Aug 2012 17:22:57 +0800
Message-Id: <1344244999-5081-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
 <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:23:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:23:52,
	Serialize complete at 2012/08/06 17:23:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB only fucus on the nodes which has normal memory, so ignore the other
node's hot-adding and hot-removing.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/slub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8c691fa..f8b137a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3568,7 +3568,7 @@ static void slab_mem_offline_callback(void *arg)
 	struct memory_notify *marg = arg;
 	int offline_node;
 
-	offline_node = marg->status_change_nid;
+	offline_node = marg->status_change_nid_normal;
 
 	/*
 	 * If the node still has available memory. we need kmem_cache_node
@@ -3601,7 +3601,7 @@ static int slab_mem_going_online_callback(void *arg)
 	struct kmem_cache_node *n;
 	struct kmem_cache *s;
 	struct memory_notify *marg = arg;
-	int nid = marg->status_change_nid;
+	int nid = marg->status_change_nid_normal;
 	int ret = 0;
 
 	/*
-- 
1.7.4.4

