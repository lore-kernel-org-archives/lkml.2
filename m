Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031279Ab2ERX1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:27:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946393Ab2ERXET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:19 -0400
Message-Id: <20120518211602.468326387@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russ Anderson <rja@sgi.com>,
        Jack Steiner <steiner@sgi.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: [ 33/54] mm: nobootmem: fix sign extend problem in __free_pages_memory()
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/nobootmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -83,8 +83,7 @@ void __init free_bootmem_late(unsigned l
 
 static void __init __free_pages_memory(unsigned long start, unsigned long end)
 {
-	int i;
-	unsigned long start_aligned, end_aligned;
+	unsigned long i, start_aligned, end_aligned;
 	int order = ilog2(BITS_PER_LONG);
 
 	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);


