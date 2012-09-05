Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2IEKix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:38:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2IEKgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:36:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789507"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 00/11 V5] workqueue: reimplement unbind/rebind
Date: Wed, 5 Sep 2012 18:37:37 +0800
Message-Id: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize complete at 2012/09/05 18:35:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2 a different way to fix deadlock problem. it removes 50 LOC !!
Patch 3-4 cleanup rebind

Patch 5-9 prepare for patch 10
Patch 10  unbind/rebind without manager_mutex, fix bug hotplug VS manage

	The first core algorithm for 5-10 is detecting the changes of binding
	by GCWQ_DISASSOCIATED bit and WORKER_UNBOUND bit.
	The second core algorithm is exile-operation. Patch2,9


Patch 11  cleanup manager.


Patch 1 accepted, just resent.

Changed from V4:
Give up to make manage_mutex safer, remove it instead.

Lai Jiangshan (11):
  workqueue: ensure the wq_worker_sleeping() see the      right flags
  async idle rebinding
  new day don't need WORKER_REBIND for busy worker
  remove WORKER_REBIND
  Add @bind arguement back
  unbind manager
  rebind manager
  unbind newly created worker
  rebind newly created worker
  unbind/rebind without manager_mutex
  remove manager_mutex

 kernel/workqueue.c |  270 ++++++++++++++++++++++++----------------------------
 1 files changed, 124 insertions(+), 146 deletions(-)

-- 
1.7.4.4

