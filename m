Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2IEKhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:37:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758484Ab2IEKgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:36:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789513"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/11 V5] workqueue: rebind newly created worker
Date: Wed, 5 Sep 2012 18:37:46 +0800
Message-Id: <1346841475-4422-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:51,
	Serialize complete at 2012/09/05 18:35:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when the newly created needs to be rebound. exile it!
it will rebind itself in worker_thead().

It just prepares, this code is useless until
"we unbind/rebind without manager_mutex"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 223d128..819c84e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1838,6 +1838,11 @@ static void manager_start_worker(struct worker *worker, struct worker *manager)
 
 	/* copy the flags. also unbind the worker if the manager is unbound */
 	worker->flags |= manager->flags & WORKER_COPY_FLAGS;
+
+	if (need_to_rebind_worker(worker)) {
+		/* exile it, and let it rebind itself */
+		list_del_init(&worker->entry);
+	}
 }
 
 /**
-- 
1.7.4.4

