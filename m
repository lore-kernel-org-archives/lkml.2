Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2KZKtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:49:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52169 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab2KZKtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:49:49 -0500
X-IronPort-AV: E=Sophos;i="4.83,320,1352044800"; 
   d="scan'208";a="6277339"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <liuj97@gmail.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH 0/5] cpu-hotplug,memory-hotplug: bug fix for offlining node
Date: Mon, 26 Nov 2012 18:20:22 +0800
Message-Id: <1353925227-1877-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/26 18:13:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/26 18:13:39,
	Serialize complete at 2012/11/26 18:13:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on the following patchset:
https://lkml.org/lkml/2012/11/1/93

The following patch in mm tree can be dropped now:
    cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch

Tang Chen (1):
  Do not use cpu_to_node() to find an offlined cpu's node.

Wen Congyang (4):
  cpu_hotplug: clear apicid to node when the cpu is hotremoved
  memory-hotplug: export the function try_offline_node()
  cpu-hotplug, memory-hotplug: try offline the node when hotremoving a
    cpu
  cpu-hotplug,memory-hotplug: clear cpu_to_node() when offlining the
    node

 arch/x86/kernel/acpi/boot.c     |  4 ++++
 drivers/acpi/processor_driver.c |  2 ++
 include/linux/memory_hotplug.h  |  2 ++
 kernel/sched/core.c             | 28 +++++++++++++++++++---------
 mm/memory_hotplug.c             | 33 +++++++++++++++++++++++++++++++--
 5 files changed, 58 insertions(+), 11 deletions(-)

-- 
1.8.0

