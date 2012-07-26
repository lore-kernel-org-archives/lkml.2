Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2GZVda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:33:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55921 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab2GZVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:31:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>
Subject: [ 40/40] mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma
Date: Thu, 26 Jul 2012 14:29:58 -0700
Message-Id: <20120726211414.838347598@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit b1c12cbcd0a02527c180a862e8971e249d3b347d upstream.

Stable note: Not tracked in Bugzilla. [get|put]_mems_allowed() is extremely
	expensive and severely impacted page allocator performance. This
	is part of a series of patches that reduce page allocator overhead.

Fix a gcc warning (and bug?) introduced in cc9a6c877 ("cpuset: mm: reduce
large amounts of memory barrier related damage v3")

Local variable "page" can be uninitialized if the nodemask from vma policy
does not intersects with nodemask from cpuset.  Even if it doesn't happens
it is better to initialize this variable explicitly than to introduce
a kernel oops in a weird corner case.

mm/hugetlb.c: In function `alloc_huge_page':
mm/hugetlb.c:1135:5: warning: `page' may be used uninitialized in this function

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -454,7 +454,7 @@ static struct page *dequeue_huge_page_vm
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	struct zonelist *zonelist;


