Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2J2Pxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:53:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18353 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759873Ab2J2PsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:48:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,673,1344182400"; 
   d="scan'208";a="6093343"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Jim Cromie <jim.cromie@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [V5 PATCH 15/26] init: use N_MEMORY instead N_HIGH_MEMORY
Date: Mon, 29 Oct 2012 23:21:05 +0800
Message-Id: <1351524078-20363-14-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:19:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:19:17,
	Serialize complete at 2012/10/29 23:19:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 9cf77ab..9595968 100644
--- a/init/main.c
+++ b/init/main.c
@@ -855,7 +855,7 @@ static void __init kernel_init_freeable(void)
 	/*
 	 * init can allocate pages on any node
 	 */
-	set_mems_allowed(node_states[N_HIGH_MEMORY]);
+	set_mems_allowed(node_states[N_MEMORY]);
 	/*
 	 * init can run on any cpu.
 	 */
-- 
1.7.4.4

