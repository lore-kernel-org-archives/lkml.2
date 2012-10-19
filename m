Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2JSGlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:41:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab2JSGlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:41:09 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6029359"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v3 0/9] bugfix for memory hotplug
Date: Fri, 19 Oct 2012 14:46:33 +0800
Message-Id: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 14:40:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 14:40:44,
	Serialize complete at 2012/10/19 14:40:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

Changes from v2 to v3:
  Merge the bug fix from ishimatsu to this patchset(Patch 1-3)
  Patch 3: split it from patch as it fixes another bug.
  Patch 4: new patch, and fix bad-page state when hotadding a memory
           device after hotremoving it. I forgot to post this patch in v2.
  Patch 6: update it according to Dave Hansen's comment.

Changes from v1 to v2:
  Patch 1: updated according to kosaki's suggestion

  Patch 2: new patch, and update mce_bad_pages when removing memory.

  Patch 4: new patch, and fix a NR_FREE_PAGES mismatch, and this bug
           cause oom in my test.

  Patch 5: new patch, and fix a new bug. When repeating to online/offline
           pages, the free pages will continue to decrease. 

Wen Congyang (6):
  clear the memory to store struct page
  memory-hotplug: skip HWPoisoned page when offlining pages
  memory-hotplug: update mce_bad_pages when removing the memory
  memory-hotplug: auto offline page_cgroup when onlining memory block
    failed
  memory-hotplug: fix NR_FREE_PAGES mismatch
  memory-hotplug: allocate zone's pcp before onlining pages

Yasuaki Ishimatsu (3):
  suppress "Device memoryX does not have a release() function" warning
  suppress "Device nodeX does not have a release() function" warning
  memory-hotplug: flush the work for the node when the node is offlined

 drivers/base/memory.c          |    9 ++++++++-
 drivers/base/node.c            |   11 +++++++++++
 include/linux/page-isolation.h |   10 ++++++----
 mm/memory-failure.c            |    2 +-
 mm/memory_hotplug.c            |   14 ++++++++------
 mm/page_alloc.c                |   37 ++++++++++++++++++++++++++++---------
 mm/page_cgroup.c               |    3 +++
 mm/page_isolation.c            |   27 ++++++++++++++++++++-------
 mm/sparse.c                    |   22 +++++++++++++++++++++-
 9 files changed, 106 insertions(+), 29 deletions(-)

