Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab2IARod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 13:44:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2IARoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 13:44:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344182400"; 
   d="scan'208";a="5764891"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 00/10 V4] workqueue: fix and cleanup hotplug/rebind_workers()
Date: Sun, 2 Sep 2012 00:28:18 +0800
Message-Id: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:27:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:28:30,
	Serialize complete at 2012/09/02 00:28:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1~4   fix possible bugs.

Patch 1     fix possible double-write bug
Patch 2,5,6 makes the waiting logic more clear
Patch 3,4   fix bugs from manage VS hotplug
Patch 7,8,9,10 explicit logic to wait in busy-work-rebind and make rebind_workers()
	       single pass.

Change from V3.
A new approach to fix the bug manage VS hotplug. The new approach
still need POOL_MANAGING_WORKERS. so patch3 is kept.

busy-work-rebind wait on a different thing to wait all idles. so
the patch 8,9,10 's aim and changlog are almost not changed, but
the code are changed a little.(based on synchronize_all_idles_rebound())


Lai Jiangshan (10):
  workqueue: ensure the wq_worker_sleeping() see the right flags
  workqueue: fix deadlock in rebind_workers()
  workqueue: add POOL_MANAGING_WORKERS
  workqueue: add manage_workers_slowpath()
  workqueue: move rebind_hold to idle_rebind
  workqueue: simple clear WORKER_REBIND
  workqueue: move idle_rebind pointer to gcwq
  workqueue: explicit way to wait for idles workers to finish
  workqueue: single pass rebind_workers
  workqueue: merge the role of rebind_hold to idle_done

 kernel/workqueue.c |  236 +++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 187 insertions(+), 49 deletions(-)

-- 
1.7.4.4

