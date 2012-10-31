Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233Ab2JaJQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:16:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab2JaJP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:15:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107685"
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
Subject: [PART5 Patch 0/5] introduce a new boot option 'kernelcore_max_addr'
Date: Wed, 31 Oct 2012 17:21:38 +0800
Message-Id: <1351675303-11786-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:15:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:15:14,
	Serialize complete at 2012/10/31 17:15:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

This patch is part5 of the following patchset:
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

You can apply this patch without the other parts. But it only can work with
part1-5.

We need something like kernelcore_max_addr=XX boot option to limit the
kernelcore upper address.

The memory with higher address will be migratable(movable) and they
are easier to be offline(always ready to be offline when the system don't require
so much memory).

It makes things easy when we dynamic hot-add/remove memory, make better
utilities of memories, and helps for THP.

Lai Jiangshan (1):
  page_alloc: add kernelcore_max_addr

Yasuaki Ishimatsu (4):
  x86: get pg_data_t's memory from other node
  x86: use memblock_set_current_limit() to set memblock.current_limit
  memblock: limit memory address from memblock
  memblock: compare current_limit with end variable at
    memblock_find_in_range_node()

 Documentation/kernel-parameters.txt |  9 +++++++++
 arch/x86/kernel/setup.c             |  4 ++--
 arch/x86/mm/numa.c                  |  8 ++++++--
 include/linux/memblock.h            |  1 +
 mm/memblock.c                       | 10 +++++++---
 mm/page_alloc.c                     | 33 ++++++++++++++++++++++++++++++++-
 6 files changed, 57 insertions(+), 8 deletions(-)

-- 
1.8.0

