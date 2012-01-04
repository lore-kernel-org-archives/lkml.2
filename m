Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2ADRYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:24:55 -0500
Received: from smtp.nokia.com ([147.243.1.48]:23750 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab2ADRYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:24:53 -0500
From: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: cesarb@cesarb.net, kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net,
        penberg@kernel.org, aarcange@redhat.com, riel@redhat.com,
        mel@csn.ul.ie, rientjes@google.com, dima@android.com, gregkh@suse.de,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com
Subject: [PATCH 3.2.0-rc1 1/3] Making si_swapinfo exportable
Date: Wed,  4 Jan 2012 19:21:54 +0200
Message-Id: <58b74a5014e323cebeb4d3654f7f8a18c2f8d132.1325696593.git.leonid.moiseichuk@nokia.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
In-Reply-To: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
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

