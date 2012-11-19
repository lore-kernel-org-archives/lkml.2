Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2KSPvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:51:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62760 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab2KSPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:49:37 -0500
X-IronPort-AV: E=Sophos;i="4.83,281,1352044800"; 
   d="scan'208";a="6232232"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        rob@landley.net, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        yinghai@kernel.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 0/5] Add movablecore_map boot option.
Date: Mon, 19 Nov 2012 22:27:21 +0800
Message-Id: <1353335246-9127-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 22:28:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 22:28:24,
	Serialize complete at 2012/11/19 22:28:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provide a boot option for user to specify ZONE_MOVABLE memory
map for each node in the system.

movablecore_map=nn[KMG]@ss[KMG]

This option make sure memory range from ss to ss+nn is movable memory.
1) If the range is involved in a single node, then from ss to the end of
   the node will be ZONE_MOVABLE.
2) If the range covers two or more nodes, then from ss to the end of
   the node will be ZONE_MOVABLE, and all the other nodes will only
   have ZONE_MOVABLE.
3) If no range is in the node, then the node will have no ZONE_MOVABLE
   unless kernelcore or movablecore is specified.
4) This option could be specified at most MAX_NUMNODES times.
5) If kernelcore or movablecore is also specified, movablecore_map will have
   higher priority to be satisfied.
6) This option has no conflict with memmap option.

Tang Chen (4):
  page_alloc: add movable_memmap kernel parameter
  page_alloc: Sanitize movablecore_map.
  page_alloc: Limit movable zone areas with movablecore_map parameter
  page_alloc: Bootmem limit with movablecore_map

Yasuaki Ishimatsu (1):
  x86: get pg_data_t's memory from other node

 Documentation/kernel-parameters.txt |   17 +++
 arch/x86/mm/numa.c                  |    9 +-
 include/linux/memblock.h            |    1 +
 include/linux/mm.h                  |   11 ++
 mm/memblock.c                       |   43 ++++++-
 mm/page_alloc.c                     |  233 ++++++++++++++++++++++++++++++++++-
 6 files changed, 307 insertions(+), 7 deletions(-)

