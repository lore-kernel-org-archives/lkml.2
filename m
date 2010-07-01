Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab0GASpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:45:35 -0400
Received: from kroah.org ([198.145.64.141]:35520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab0GASXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:14 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:11 2010
Message-Id: <20100701173211.009400014@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrea Arcangeli <aarcange@redhat.com>, David Gibson <dwg@au1.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: [patch 050/149] mm: hugetlb: fix clear_huge_page()
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 74dbdd239bb1348ad86d28b18574d9c1f28b62ca upstream.

sz is in bytes, MAX_ORDER_NR_PAGES is in pages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Gibson <dwg@au1.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -401,7 +401,7 @@ static void clear_huge_page(struct page
 {
 	int i;
 
-	if (unlikely(sz > MAX_ORDER_NR_PAGES)) {
+	if (unlikely(sz/PAGE_SIZE > MAX_ORDER_NR_PAGES)) {
 		clear_gigantic_page(page, addr, sz);
 		return;
 	}


