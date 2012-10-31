Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188Ab2JaIuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:50:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64698 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935123Ab2JaIuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:50:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107355"
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
Subject: [PART4 Patch 0/2] memory-hotplug: allow online/offline memory to result movable node
Date: Wed, 31 Oct 2012 16:15:32 +0800
Message-Id: <1351671334-10243-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 16:09:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 16:09:11,
	Serialize complete at 2012/10/31 16:09:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

This patch is part4 of the following patchset:
    https://lkml.org/lkml/2012/10/29/319

Part1 is here:
    https://lkml.org/lkml/2012/10/31/30

Part2 is here:
    http://marc.info/?l=linux-kernel&m=135166705909544&w=2

Part3 is here:
    http://marc.info/?l=linux-kernel&m=135167050510527&w=2

You must apply part1-3 before applying this patchset.

we need a node which only contains movable memory. This feature is very
important for node hotplug. If a node has normal/highmem, the memory
may be used by the kernel and can't be offlined. If the node only contains
movable memory, we can offline the memory and the node.


Lai Jiangshan (2):
  numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
  memory_hotplug: allow online/offline memory to result movable node

 drivers/base/node.c      |  6 ++++++
 include/linux/nodemask.h |  4 ++++
 mm/Kconfig               |  8 ++++++++
 mm/memory_hotplug.c      | 16 ++++++++++++++++
 mm/page_alloc.c          |  3 +++
 5 files changed, 37 insertions(+)

-- 
1.8.0

