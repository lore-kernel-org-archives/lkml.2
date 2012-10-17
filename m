Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2JQMDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:03:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33626 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2JQMDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:03:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,600,1344182400"; 
   d="scan'208";a="6017129"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v2 0/5] bugfix for memory hotplug
Date: Wed, 17 Oct 2012 20:08:50 +0800
Message-Id: <1350475735-26136-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 20:02:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 20:02:57,
	Serialize complete at 2012/10/17 20:02:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

Wen Congyang (5):
  memory-hotplug: skip HWPoisoned page when offlining pages
  memory-hotplug: update mce_bad_pages when removing the memory
  memory-hotplug: auto offline page_cgroup when onlining memory block
    failed
  memory-hotplug: fix NR_FREE_PAGES mismatch
  memory-hotplug: allocate zone's pcp before onlining pages

 include/linux/page-isolation.h |   10 ++++++----
 mm/memory-failure.c            |    2 +-
 mm/memory_hotplug.c            |   14 ++++++++------
 mm/page_alloc.c                |   37 ++++++++++++++++++++++++++++---------
 mm/page_cgroup.c               |    3 +++
 mm/page_isolation.c            |   27 ++++++++++++++++++++-------
 mm/sparse.c                    |   21 +++++++++++++++++++++
 7 files changed, 87 insertions(+), 27 deletions(-)

