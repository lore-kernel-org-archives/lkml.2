Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab0GVLRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:17:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:16627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210Ab0GVLRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:17:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="640712473"
Subject: [RFC][PATCH v1 12/15] perf: export tracepoint events via sysfs:
 kmem
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 19:17:35 +0800
Message-ID: <1279797455.20942.95.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem tracepoint events are exported like below,

/sys/kernel/slab/events/
|-- kfree
|   |-- config
|   `-- type
|-- kmalloc
|   |-- config
|   `-- type
|-- kmalloc_node
|   |-- config
|   `-- type
|-- kmem_cache_alloc
|   |-- config
|   `-- type
|-- kmem_cache_alloc_node
|   |-- config
|   `-- type
|-- kmem_cache_free
|   |-- config
|   `-- type
|-- mm_page_alloc
|   |-- config
|   `-- type
|-- mm_page_alloc_extfrag
|   |-- config
|   `-- type
|-- mm_page_alloc_zone_locked
|   |-- config
|   `-- type
|-- mm_page_free_direct
|   |-- config
|   `-- type
|-- mm_page_pcpu_drain
|   |-- config
|   `-- type
`-- mm_pagevec_free
    |-- config
    `-- type
---
 mm/slub.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7bb7940..0de39dd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -27,6 +27,7 @@
 #include <linux/memory.h>
 #include <linux/math64.h>
 #include <linux/fault-inject.h>
+#include <linux/perf_event.h>
 
 /*
  * Lock order:
@@ -4554,6 +4555,8 @@ static int __init slab_sysfs_init(void)
 		return -ENOSYS;
 	}
 
+	perf_sys_add_tp(&slab_kset->kobj, "kmem");
+
 	slab_state = SYSFS;
 
 	list_for_each_entry(s, &slab_caches, list) {



