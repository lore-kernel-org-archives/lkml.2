Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2IQPov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:44:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab2IQPou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:44:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344182400"; 
   d="scan'208";a="5859715"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 for-next PATCH 0/7] workqueue: async idle rebinding and cleanup for hotplug
Date: Mon, 17 Sep 2012 23:46:41 +0800
Message-Id: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize complete at 2012/09/17 23:45:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch1 fix new found possible bug.

Patch2 use async algorithm to replace the synchronous algorithm to rebind
idle workers.

The synchronous algorithm requires 3 hand shakes, it introduces much
complicated. 

The new async algorithm does not do any synchronization. it removes
the idle workers from idle_list to ensure the local-wake-up is correct
instead.

Patch3-7 do simple cleanup

Patch2-7 are ready for for-next. I have other devlopment and cleanup for workqueue,
should I wait this patchset merged or send them at the same time?

Lai Jiangshan (7):
  workqueue: clear WORKER_REBIND unconditionaly in
    busy_worker_rebind_fn()
  workqueue: async idle rebinding
  workqueue: new day don't need WORKER_REBIND for busy rebinding
  workqueue: remove WORKER_REBIND
  workqueue: rename manager_mutex to assoc_mutex
  workqueue: use __cpuinit instead of __devinit for cpu callback
  workqueue: use hotcpu_notifier() for workqueue_cpu_down_callback()

 kernel/workqueue.c |  228 ++++++++++++++++++---------------------------------
 1 files changed, 81 insertions(+), 147 deletions(-)

-- 
1.7.4.4

