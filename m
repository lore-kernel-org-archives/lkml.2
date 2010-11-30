Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0K3AZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:25:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56556 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0K3AZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:25:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Simon Kirby <sim@hostway.ca>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1011260943220.12265@router.home>
References: <20101125101803.F450.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011260943220.12265@router.home>
Message-Id: <20101130092534.82D5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Nov 2010 09:25:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 25 Nov 2010, KOSAKI Motohiro wrote:
> > Please try SLAB instead SLUB (it can be switched by kernel build option).
> > SLUB try to use high order allocation implicitly.
> 
> SLAB uses orders 0-1. Order is fixed per slab cache and determined based
> on object size at slab creation.
> 
> SLUB uses orders 0-3. Falls back to smallest order if alloc order cannot
> be met by the page allocator.
> 
> One can reduce SLUB to SLAB orders by specifying the following kernel
> commandline parameter:
> 
> slub_max_order=1

This?


>From 3edd305fc58ac89364806cd60140793d37422acc Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 24 Dec 2010 18:04:10 +0900
Subject: [PATCH] slub: reduce slub_max_order by default

slab is already using order-1.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/slub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8c66aef..babf359 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1964,7 +1964,8 @@ static struct page *get_object_page(const void *x)
  * take the list_lock.
  */
 static int slub_min_order;
-static int slub_max_order = PAGE_ALLOC_COSTLY_ORDER;
+/* order-1 is maximum size which we can assume to exist always. */
+static int slub_max_order = 1;
 static int slub_min_objects;
 
 /*
-- 
1.6.5.2



