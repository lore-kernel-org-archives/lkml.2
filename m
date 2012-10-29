Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab2J2Psa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:48:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18353 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759658Ab2J2PsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:48:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,673,1344182400"; 
   d="scan'208";a="6093334"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [V5 PATCH 04/26] node: cleanup node_state_attr
Date: Mon, 29 Oct 2012 23:20:54 +0800
Message-Id: <1351524078-20363-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:18:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:18:54,
	Serialize complete at 2012/10/29 23:18:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use [index] = init_value
use N_xxxxx instead of hardcode.

Make it more readability and easy to add new state.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/base/node.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index af1a177..5d7731e 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -614,23 +614,23 @@ static ssize_t show_node_state(struct device *dev,
 	{ __ATTR(name, 0444, show_node_state, NULL), state }
 
 static struct node_attr node_state_attr[] = {
-	_NODE_ATTR(possible, N_POSSIBLE),
-	_NODE_ATTR(online, N_ONLINE),
-	_NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
-	_NODE_ATTR(has_cpu, N_CPU),
+	[N_POSSIBLE] = _NODE_ATTR(possible, N_POSSIBLE),
+	[N_ONLINE] = _NODE_ATTR(online, N_ONLINE),
+	[N_NORMAL_MEMORY] = _NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
 #ifdef CONFIG_HIGHMEM
-	_NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
+	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
+	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 };
 
 static struct attribute *node_state_attrs[] = {
-	&node_state_attr[0].attr.attr,
-	&node_state_attr[1].attr.attr,
-	&node_state_attr[2].attr.attr,
-	&node_state_attr[3].attr.attr,
+	&node_state_attr[N_POSSIBLE].attr.attr,
+	&node_state_attr[N_ONLINE].attr.attr,
+	&node_state_attr[N_NORMAL_MEMORY].attr.attr,
 #ifdef CONFIG_HIGHMEM
-	&node_state_attr[4].attr.attr,
+	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
+	&node_state_attr[N_CPU].attr.attr,
 	NULL
 };
 
-- 
1.7.4.4

