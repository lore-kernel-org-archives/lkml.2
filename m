Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2LTTPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:15:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21548 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2LTTN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:56 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] cgroup: remove redundant check
Date: Thu, 20 Dec 2012 14:11:31 -0500
Message-Id: <1356030701-16284-23-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already know that 'event' is non-NULL, remove the redundant check.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4855892..8d6c3f2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3898,7 +3898,7 @@ fail:
 	if (cfile)
 		fput(cfile);
 
-	if (event && event->eventfd && !IS_ERR(event->eventfd))
+	if (event->eventfd && !IS_ERR(event->eventfd))
 		eventfd_ctx_put(event->eventfd);
 
 	if (!IS_ERR_OR_NULL(efile))
-- 
1.8.0

