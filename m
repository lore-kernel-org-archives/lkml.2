Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1ADIWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:22:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55199 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1ADIWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:22:53 -0500
Message-ID: <4D22D8EB.1050804@cn.fujitsu.com>
Date: Tue, 04 Jan 2011 16:23:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        MiaoX <miaox@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: remove cpuset_unlock()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:22:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:22:33,
	Serialize complete at 2011-01-04 16:22:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used.
It is not declared.
There is no corresponding cpuset_lock().

signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4349935..6ef90dd 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2440,17 +2440,6 @@ int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 }
 
 /**
- * cpuset_unlock - release lock on cpuset changes
- *
- * Undo the lock taken in a previous cpuset_lock() call.
- */
-
-void cpuset_unlock(void)
-{
-	mutex_unlock(&callback_mutex);
-}
-
-/**
  * cpuset_mem_spread_node() - On which node to begin search for a file page
  * cpuset_slab_spread_node() - On which node to begin search for a slab page
  *
