Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2I1IeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:34:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:49980 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab2I1IeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:34:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="227650601"
Date: Fri, 28 Sep 2012 16:34:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH] slub: init_kmem_cache_cpus() and put_cpu_partial() can be
 static
Message-ID: <20120928083405.GA23740@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/mm/slub.c	2012-09-24 10:22:11.000000000 +0800
+++ linux/mm/slub.c	2012-09-28 16:31:31.987092387 +0800
@@ -1709,7 +1709,7 @@ static inline void note_cmpxchg_failure(
 	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
 }
 
-void init_kmem_cache_cpus(struct kmem_cache *s)
+static void init_kmem_cache_cpus(struct kmem_cache *s)
 {
 	int cpu;
 
@@ -1934,7 +1934,7 @@ static void unfreeze_partials(struct kme
  * If we did not find a slot then simply move all the partials to the
  * per node partial list.
  */
-int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
+static int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 {
 	struct page *oldpage;
 	int pages;
