Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2IHRLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:11:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab2IHRLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:11:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,392,1344182400"; 
   d="scan'208";a="5807473"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/7 V6] workqueue: fix hoplug things
Date: Sun, 9 Sep 2012 01:12:49 +0800
Message-Id: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:47,
	Serialize complete at 2012/09/09 01:10:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set is based on 3b07e9ca26866697616097044f25fbe53dbab693 of wq.git

Patch 1,2 are accepted. Patch 1 goes to 3.6. tj has a replacement goes
to 3.6 instead of Patch 2. so Patch2 will go to 3.7. Patch2 will need
to be rebased if the replacement is still in 3.7.
(tj, could you help me do the rebase if I don't need to respin the patchset
as V7 ?)

Patch3,4 fix depletion problem, it is simple enough. it goes to 3.6.

Patch 5,6,7 are clean up. -> 3.7


Lai Jiangshan (7):
  workqueue: ensure the wq_worker_sleeping() see the right flags
  workqueue: async idle rebinding
  workqueue:  add manager pointer for worker_pool
  workqueue: fix idle worker depletion
  workqueue: rename manager_mutex to assoc_mutex
  workqueue: new day don't need WORKER_REBIND for busy rebinding
  workqueue: remove WORKER_REBIND

 kernel/workqueue.c |  195 +++++++++++++++++++++++-----------------------------
 1 files changed, 85 insertions(+), 110 deletions(-)

-- 
1.7.4.4

