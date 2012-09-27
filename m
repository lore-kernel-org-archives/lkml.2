Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2I0HAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:00:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab2I0HAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:00:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,495,1344182400"; 
   d="scan'208";a="5926328"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Jianguo Wu <wujianguo@huawei.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Xishi Qiu <qiuxishi@huawei.com>,
        Mel Gorman <mgorman@suse.de>, linux-doc@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 0/3] memory_hotplug: fix memory hotplug bug
Date: Thu, 27 Sep 2012 14:47:47 +0800
Message-Id: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 14:46:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 14:46:49,
	Serialize complete at 2012/09/27 14:46:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found 3 bug while we test and develop memory hotplug.

PATCH1~2: the old code does not handle node_states[N_NORMAL_MEMORY] correctly,
it corrupts the memory.

PATCH3: move the modification of zone_start_pfn into corresponding lock.

CC: Rob Landley <rob@landley.net>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jiang Liu <jiang.liu@huawei.com>
CC: Jianguo Wu <wujianguo@huawei.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Xishi Qiu <qiuxishi@huawei.com>
CC: Mel Gorman <mgorman@suse.de>
CC: linux-doc@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org

Lai Jiangshan (3):
  memory_hotplug: fix missing nodemask management
  slub, hotplug: ignore unrelated node's hot-adding and hot-removing
  memory,hotplug: Don't modify the zone_start_pfn outside of
    zone_span_writelock()

 Documentation/memory-hotplug.txt |    5 ++-
 include/linux/memory.h           |    1 +
 mm/memory_hotplug.c              |   96 +++++++++++++++++++++++++++++++-------
 mm/page_alloc.c                  |    3 +-
 mm/slub.c                        |    4 +-
 5 files changed, 87 insertions(+), 22 deletions(-)

-- 
1.7.4.4

