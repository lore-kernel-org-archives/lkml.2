Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab2AQNXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:23:53 -0500
Received: from smtp.nokia.com ([147.243.1.48]:60752 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab2AQNXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:23:50 -0500
From: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: cesarb@cesarb.net, kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net,
        penberg@kernel.org, aarcange@redhat.com, riel@redhat.com,
        mel@csn.ul.ie, rientjes@google.com, dima@android.com, gregkh@suse.de,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com
Subject: [PATCH v2 1/2] Making si_swapinfo exportable
Date: Tue, 17 Jan 2012 15:22:10 +0200
Message-Id: <56cc3c5d40a8653b7d9bef856ff02d909b98f36f.1326803859.git.leonid.moiseichuk@nokia.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
In-Reply-To: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we will make si_swapinfo() exportable it could be called from modules.
Otherwise modules have no interface to obtain information about swap usage.
Change made in the same way as si_meminfo() declared.

Signed-off-by: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
---
 mm/swapfile.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b1cd120..192cc25 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -5,10 +5,12 @@
  *  Swap reorganised 29.12.95, Stephen Tweedie
  */
 
+#include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/mman.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 #include <linux/kernel_stat.h>
 #include <linux/swap.h>
 #include <linux/vmalloc.h>
@@ -2177,6 +2179,7 @@ void si_swapinfo(struct sysinfo *val)
 	val->totalswap = total_swap_pages + nr_to_be_unused;
 	spin_unlock(&swap_lock);
 }
+EXPORT_SYMBOL(si_swapinfo);
 
 /*
  * Verify that a swap entry is valid and increment its swap map count.
-- 
1.7.7.3

