Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1CEQuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:50:00 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:37140 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1CEQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:22 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 21/24] sys_swapon: remove nr_good_pages variable
Date: Sat,  5 Mar 2011 13:42:22 -0300
Message-Id: <1299343345-3984-22-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It still exists within setup_swap_map_and_extents(), but after it
nr_good_pages == p->pages.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5f6df81..369816d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2039,7 +2039,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int i, prev;
 	int error;
 	union swap_header *swap_header;
-	unsigned int nr_good_pages;
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
@@ -2123,7 +2122,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		error = nr_extents;
 		goto bad_swap;
 	}
-	nr_good_pages = p->pages;
 
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
@@ -2143,12 +2141,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		p->prio = --least_priority;
 	p->swap_map = swap_map;
 	p->flags |= SWP_WRITEOK;
-	nr_swap_pages += nr_good_pages;
-	total_swap_pages += nr_good_pages;
+	nr_swap_pages += p->pages;
+	total_swap_pages += p->pages;
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
 			"Priority:%d extents:%d across:%lluk %s%s\n",
-		nr_good_pages<<(PAGE_SHIFT-10), name, p->prio,
+		p->pages<<(PAGE_SHIFT-10), name, p->prio,
 		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
 		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(p->flags & SWP_DISCARDABLE) ? "D" : "");
-- 
1.7.4

