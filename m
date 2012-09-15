Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab2IOIp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 04:45:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63329 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2IOIp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 04:45:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,427,1344182400"; 
   d="scan'208";a="5850808"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/6] workqueue: async idle rebinding and cleanup for hotplug
Date: Sat, 15 Sep 2012 16:13:33 +0800
Message-Id: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:51,
	Serialize complete at 2012/09/15 16:12:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch1 use async algorithm to replace the synchronous algorithm to rebind
idle workers.

The synchronous algorithm requires 3 hand shakes, it introduces much
complicated. 

The new async algorithm does not do any synchronization. it removes
the idle workers from idle_list to ensure the local-wake-up is correct
instead.

Patch2-6 do simple cleanup

Lai Jiangshan (6):
  workqueue: async idle rebinding
  workqueue: new day don't need WORKER_REBIND for busy rebinding
  workqueue: remove WORKER_REBIND
  workqueue: rename manager_mutex to assoc_mutex
  workqueue: use __cpuinit instead of __devinit for cpu callback
  workqueue: use hotcpu_notifier() for workqueue_cpu_down_callback()

 kernel/workqueue.c |  202 ++++++++++++++-------------------------------------
 1 files changed, 56 insertions(+), 146 deletions(-)

-- 
1.7.4.4

