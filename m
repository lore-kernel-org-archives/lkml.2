Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581Ab2JXJmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:42:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53754 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757979Ab2JXJmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:42:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344182400"; 
   d="scan'208";a="6060155"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mel Gorman <mgorman@suse.de>,
        "'FNST-Wen Congyang'" <wency@cn.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/2 V2] memory_hotplug: fix memory hotplug bug
Date: Wed, 24 Oct 2012 17:43:50 +0800
Message-Id: <1351071840-5060-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/24 17:41:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/24 17:41:22,
	Serialize complete at 2012/10/24 17:41:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found 2 bugs while we test and develop memory hotplug.

The hotplug code does not handle node_states[N_NORMAL_MEMORY] correctly,
it may corrupt the memory.

And we ensure the SLUB do NOT respond when node_states[N_NORMAL_MEMORY]
is not changed.

The patchset is based on mainline(3d0ceac129f3ea0b125289055a3aa7519d38df77)


CC: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Rob Landley <rob@landley.net>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jiang Liu <jiang.liu@huawei.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Mel Gorman <mgorman@suse.de>
CC: 'FNST-Wen Congyang' <wency@cn.fujitsu.com>
CC: linux-doc@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org

Lai Jiangshan (2):
  memory_hotplug: fix possible incorrect node_states[N_NORMAL_MEMORY]
  slub, hotplug: ignore unrelated node's hot-adding and hot-removing

 Documentation/memory-hotplug.txt |    5 +-
 include/linux/memory.h           |    1 +
 mm/memory_hotplug.c              |  136 +++++++++++++++++++++++++++++++++-----
 mm/slub.c                        |    4 +-
 4 files changed, 127 insertions(+), 19 deletions(-)

-- 
1.7.4.4

