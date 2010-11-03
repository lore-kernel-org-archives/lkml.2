Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0KCPkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277Ab0KCPal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:30:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 15 of 66] config_transparent_hugepage
X-Mercurial-Node: 32991335ab1810031789f0b8f18691f39e65ab50
Message-Id: <32991335ab1810031789.1288798070@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:27:50 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

Add config option.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---

diff --git a/fs/Kconfig b/fs/Kconfig
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -147,7 +147,7 @@ config HUGETLBFS
 	  If unsure, say N.
 
 config HUGETLB_PAGE
-	def_bool HUGETLBFS
+	def_bool HUGETLBFS || TRANSPARENT_HUGEPAGE
 
 source "fs/configfs/Kconfig"
 
diff --git a/mm/Kconfig b/mm/Kconfig
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -302,6 +302,20 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 	  See Documentation/nommu-mmap.txt for more information.
 
+config TRANSPARENT_HUGEPAGE
+	bool "Transparent Hugepage Support" if EMBEDDED
+	depends on X86_64 && MMU
+	default y
+	help
+	  Transparent Hugepages allows the kernel to use huge pages and
+	  huge tlb transparently to the applications whenever possible.
+	  This feature can improve computing performance to certain
+	  applications by speeding up page faults during memory
+	  allocation, by reducing the number of tlb misses and by speeding
+	  up the pagetable walking.
+
+	  If memory constrained on embedded, you may want to say N.
+
 #
 # UP and nommu archs use km based percpu allocator
 #
