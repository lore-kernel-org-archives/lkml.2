Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0C3XMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:12:17 -0400
Received: from kroah.org ([198.145.64.141]:48844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab0C3XML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:11 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:21 2010
Message-Id: <20100330225821.274719916@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [21/89] page allocator: update NR_FREE_PAGES only when necessary
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 6ccf80eb15ccaca4d3f1ab5162b9ded5eecd9971 upstream.

commit f2260e6b (page allocator: update NR_FREE_PAGES only as necessary)
made one minor regression.  if __rmqueue() was failed, NR_FREE_PAGES stat
go wrong.  this patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reported-by: Huang Shijie <shijie8@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1167,10 +1167,10 @@ again:
 		}
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
-		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);


