Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab2JaJSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:18:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33690 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab2JaJSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:18:34 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107701"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PART6 Patch] memory-hotplug: bugfix for movable node
Date: Wed, 31 Oct 2012 17:24:17 +0800
Message-Id: <1351675458-11859-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:17:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:17:49,
	Serialize complete at 2012/10/31 17:17:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part6 of the following patchset:
    https://lkml.org/lkml/2012/10/29/319

The patchset is based on Linus's tree with these three patches already applied:
    https://lkml.org/lkml/2012/10/24/151
    https://lkml.org/lkml/2012/10/26/150

Part1 is here:
    https://lkml.org/lkml/2012/10/31/30

Part2 is here:
    http://marc.info/?l=linux-kernel&m=135166705909544&w=2

Part3 is here:
    http://marc.info/?l=linux-kernel&m=135167050510527&w=2

Part4 is here:
    http://marc.info/?l=linux-kernel&m=135167344211401&w=2

Part5 is here:
    http://marc.info/?l=linux-kernel&m=135167497312063&w=2

You can apply this patch without the other parts.

Issues):

mempolicy(M_BIND) don't act well when the nodemask has movable nodes only,
the kernel allocation will fail and the task can't create new task or other
kernel objects.

So we change the strategy/policy
	when the bound nodemask has movable node(s) only, we only
	apply mempolicy for userspace allocation, don't apply it
	for kernel allocation.

CPUSET also has the same problem, but the code spread in page_alloc.c,
and we doesn't fix it yet, we can/will change allocation strategy to one of
these 3 strategies:
	1) the same strategy as mempolicy
	2) change cpuset, make nodemask always has at least a normal node
	3) split nodemask: nodemask_user and nodemask_kernel

This patchset only fixes issue1.

Lai Jiangshan (1):
  mempolicy: fix is_valid_nodemask()

 mm/mempolicy.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

-- 
1.8.0

