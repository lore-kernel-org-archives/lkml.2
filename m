Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2H0R5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:57:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2H0R5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:57:11 -0400
X-IronPort-AV: E=Sophos;i="4.77,837,1336320000"; 
   d="scan'208";a="5733845"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/7] workqueue: cleanup rebind_workers().
Date: Tue, 28 Aug 2012 01:58:20 +0800
Message-Id: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:00,
	Serialize complete at 2012/08/28 01:57:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These small patches change the rebind_workers() a little.

Patch1,5 fix possible bug.

Patch1,2 idle_worker_rebind() uses manage_mutex to wait rebind_workers()
	to finish and ease WORKER_REBIND

Patch3,4 makes rebind_workers() single pass and makes code clean.

Patch5 use single write instruction to void other CPU see wrong flags.

Patch6,7 small fix.

Lai Jiangshan (7):
  wait on manager_mutex instead of rebind_hold
  simple clear WORKER_REBIND
  explit way to wait for idles workers to finish
  single pass rebind
  ensure the wq_worker_sleeping() see the right flags
  init 0
  static idle_rebind

 kernel/workqueue.c |   81 ++++++++++++++++++++-------------------------------
 1 files changed, 32 insertions(+), 49 deletions(-)

-- 
1.7.4.4

