Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2ACWlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab2ACWlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:25 2012
Message-Id: <20120103223325.048201613@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [48/75] mm: hugetlb: fix non-atomic enqueue of huge page
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hillf Danton <dhillf@gmail.com>

commit b0365c8d0cb6e79eb5f21418ae61ab511f31b575 upstream.

If a huge page is enqueued under the protection of hugetlb_lock, then the
operation is atomic and safe.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -901,7 +901,6 @@ retry:
 	h->resv_huge_pages += delta;
 	ret = 0;
 
-	spin_unlock(&hugetlb_lock);
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
@@ -915,6 +914,7 @@ retry:
 		VM_BUG_ON(page_count(page));
 		enqueue_huge_page(h, page);
 	}
+	spin_unlock(&hugetlb_lock);
 
 	/* Free unnecessary surplus pages to the buddy allocator */
 free:


