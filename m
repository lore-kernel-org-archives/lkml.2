Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2IZRSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:18:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59288 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab2IZRSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:38 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922244"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 00/12] workqueue: simple cleanups
Date: Thu, 27 Sep 2012 01:20:31 +0800
Message-Id: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize complete at 2012/09/27 01:18:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these all are different cleanups for workqueue.

depends:
Patch2 depends on Patch1
Patch3 depends on Patch1
Patch7 depends on Patch6

Patch7 need to be merged after Patch3 is merged.(not really depends)

Lai Jiangshan (12):
  workqueue: add WORKER_RESCUER
  workqueue: disallow set_cpus_allowed_ptr() from work item
  workqueue: remove WORKER_PREP from rescuer
  workqueue: simplify is_chained_work()
  workqueue: don't wake up other workers in rescuer
  workqueue: destroy_worker() can only destory idle worker not just
    created worker
  workqueue: remove WORKER_STARTED
  workqueue: fix comments of insert_work()
  workqueue: declare system_highpri_wq
  cpu-hotplug.txt: fix comments of work_on_cpu()
  workqueue: add WQ_CPU_INTENSIVE to system_long_wq
  workqueue: avoid work_on_cpu() to interfere system_wq

 Documentation/cpu-hotplug.txt |    2 +-
 include/linux/workqueue.h     |    4 ++
 kernel/sched/core.c           |    8 ++-
 kernel/workqueue.c            |   82 +++++++++++++++++------------------------
 4 files changed, 44 insertions(+), 52 deletions(-)

-- 
1.7.7.6

