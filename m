Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2LTTSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:18:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21623 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2LTTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:04 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm: memory_hotplug: no need to check res twice in add_memory
Date: Thu, 20 Dec 2012 14:11:32 -0500
Message-Id: <1356030701-16284-24-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove one redundant check of res.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/memory_hotplug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 962e353..4082244 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -898,8 +898,7 @@ error:
 	/* rollback pgdat allocation and others */
 	if (new_pgdat)
 		rollback_node_hotadd(nid, pgdat);
-	if (res)
-		release_memory_resource(res);
+	release_memory_resource(res);
 
 out:
 	unlock_memory_hotplug();
-- 
1.8.0

