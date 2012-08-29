Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab2H2Quo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab2H2Qu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:28 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344182400"; 
   d="scan'208";a="5748907"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/9 V3] workqueue: fix and cleanup hotplug/rebind_workers()
Date: Thu, 30 Aug 2012 00:51:51 +0800
Message-Id: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:15,
	Serialize complete at 2012/08/30 00:50:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1~4   fix possible bugs.

Patch 1     fix possible double-write bug
Patch 2,5,7 makes the waiting logic more clear
Patch 3,4   fix bugs from manage VS hotplug
Patch 7,8,9 explicit logic to wait in busy-work-rebind and make rebind_workers()
	    single pass.

Lai Jiangshan (9):
  workqueue: ensure the wq_worker_sleeping() see the right flags
  workqueue: fix deadlock in rebind_workers()
  workqueue: add POOL_MANAGING_WORKERS
  workqueue: add non_manager_role_manager_mutex_unlock()
  workqueue: move rebind_hold to idle_rebind
  workqueue: simple clear WORKER_REBIND
  workqueue: explicit way to wait for idles workers to finish
  workqueue: single pass rebind_workers
  workqueue: merge the role of rebind_hold to idle_done

 kernel/workqueue.c |  151 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 96 insertions(+), 55 deletions(-)

-- 
1.7.4.4

