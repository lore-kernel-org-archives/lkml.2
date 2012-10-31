Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2JaHE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:04:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50828 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab2JaHEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:04:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,686,1344182400"; 
   d="scan'208";a="6106421"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: [PART2 Patch] node: cleanup node_state_attr
Date: Wed, 31 Oct 2012 14:55:28 +0800
Message-Id: <1351666528-8226-2-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351666528-8226-1-git-send-email-wency@cn.fujitsu.com>
References: <1351666528-8226-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 14:48:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 14:49:06,
	Serialize complete at 2012/10/31 14:49:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

use [index] = init_value
use N_xxxxx instead of hardcode.

Make it more readability and easier to add new state.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/base/node.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

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
1.8.0

