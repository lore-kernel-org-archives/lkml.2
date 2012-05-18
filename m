Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031066Ab2ERDFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:05:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40469 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762579Ab2ERCwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:34 -0400
Message-Id: <20120518023255.578914137@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russ Anderson <rja@sgi.com>,
        Jack Steiner <steiner@sgi.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: [ 09/53] mm: nobootmem: fix sign extend problem in __free_pages_memory()
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Anderson <rja@sgi.com>

commit 6bc2e853c6b46a6041980d58200ad9b0a73a60ff upstream.

Systems with 8 TBytes of memory or greater can hit a problem where only
the the first 8 TB of memory shows up.  This is due to "int i" being
smaller than "unsigned long start_aligned", causing the high bits to be
dropped.

The fix is to change `i' to unsigned long to match start_aligned
and end_aligned.

Thanks to Jack Steiner for assistance tracking this down.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/nobootmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index e53bb8a..1983fb1 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -82,8 +82,7 @@ void __init free_bootmem_late(unsigned long addr, unsigned long size)
 
 static void __init __free_pages_memory(unsigned long start, unsigned long end)
 {
-	int i;
-	unsigned long start_aligned, end_aligned;
+	unsigned long i, start_aligned, end_aligned;
 	int order = ilog2(BITS_PER_LONG);
 
 	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
-- 
1.7.10



