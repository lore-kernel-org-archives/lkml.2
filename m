Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2JaFft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:35:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52986 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab2JaFfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:35:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,686,1344182400"; 
   d="scan'208";a="6105342"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: [PART1 Patch 0/3] mm, memory-hotplug: allow to online movable memory
Date: Wed, 31 Oct 2012 13:40:33 +0800
Message-Id: <1351662036-7435-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 13:34:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 13:34:08,
	Serialize complete at 2012/10/31 13:34:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

This patch is part1 of the following patchset:
    https://lkml.org/lkml/2012/10/29/319

The patchset is based on Linus's tree with these three patches already applied:
    https://lkml.org/lkml/2012/10/24/151
    https://lkml.org/lkml/2012/10/26/150

Movable memory is a very important concept of memory-management,
we need to consolidate it and make use of it on systems.

Movable memory is needed for
    anti-fragmentation(hugepage, big-order allocation...)
    logic hot-remove(virtualization, Memory capacity on Demand)
    physic hot-remove(power-saving, hardware partitioning, hardware fault management)

All these require dynamic configuring the memory and making better utilities of
memories and safer. We also need physic hot-remove, so we need movable node too.
(Although some systems support physic-memory-migration, we don't require all
memory on physic-node is movable, but movable node is still needed here
for logic-node if we want to make physic-migration is transparent)

We add dynamic configuration commands "online_movalbe" and "online_kernel" in
this patchset, and you can't make a movable node(it will be implemented in
part4).

Usage:
1. online_movable:
   echo online_movable >/sys/devices/system/memory/memoryX/state
   The memory must be offlined before doing this.
2. online_kernel:
   echo online_kernel >/sys/devices/system/memory/memoryX/state
   The memory must be offlined before doing this.
3. online:
   echo online_kernel >/sys/devices/system/memory/memoryX/state
   The memory must be offline before doing this. This operation does't change
   the memory's attribute: movable or normal/high

Note:
   You only can move the highest memory in normal/high zone to movable zone,
   and only can move the lowest memory in movable zone to normal/high zone.

Lai Jiangshan (3):
  mm, memory-hotplug: dynamic configure movable memory and portion
    memory
  memory_hotplug: handle empty zone when online_movable/online_kernel
  memory_hotplug: ensure every online node has NORMAL memory

 Documentation/memory-hotplug.txt |  14 ++-
 drivers/base/memory.c            |  27 +++---
 include/linux/memory_hotplug.h   |  13 ++-
 mm/memory_hotplug.c              | 180 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 221 insertions(+), 13 deletions(-)

-- 
1.8.0

