Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0I2Dxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 23:53:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48428 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab0I2Dxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 23:53:42 -0400
Date: Wed, 29 Sep 2010 13:53:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: linux-next: manual merge of the cleancache tree with the slab tree
Message-Id: <20100929135336.2347427a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Today's linux-next merge of the cleancache tree got a conflict in
mm/Kconfig between commit 6fc80ef491b981f59233beaf6aeaccc0c947031d
("percpu: use percpu allocator on UP too") from the slab tree and commit
52f08871df905eec43d34d20102cbaf8e397e280 ("mm: cleancache core ops
functions and config") from the cleancache tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fax as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/Kconfig
index c2c8a4a,9ee0751..0000000
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@@ -302,10 -302,24 +302,32 @@@ config NOMMU_INITIAL_TRIM_EXCES
  
  	  See Documentation/nommu-mmap.txt for more information.
  
 +#
 +# UP and nommu archs use km based percpu allocator
 +#
 +config NEED_PER_CPU_KM
 +	depends on !SMP
 +	bool
 +	default y
++
+ config CLEANCACHE
+ 	bool "Enable cleancache pseudo-RAM driver to cache clean pages"
+ 	default y
+ 	help
+ 	  Cleancache can be thought of as a page-granularity victim cache
+ 	  for clean pages that the kernel's pageframe replacement algorithm
+ 	  (PFRA) would like to keep around, but can't since there isn't enough
+ 	  memory.  So when the PFRA "evicts" a page, it first attempts to put
+ 	  it into a synchronous concurrency-safe page-oriented pseudo-RAM
+ 	  device (such as Xen's Transcendent Memory, aka "tmem") which is not
+ 	  directly accessible or addressable by the kernel and is of unknown
+ 	  (and possibly time-varying) size.  And when a cleancache-enabled
+ 	  filesystem wishes to access a page in a file on disk, it first
+ 	  checks cleancache to see if it already contains it; if it does,
+ 	  the page is copied into the kernel and a disk access is avoided.
+ 	  When a pseudo-RAM device is available, a significant I/O reduction
+ 	  may be achieved.  When none is available, all cleancache calls
+ 	  are reduced to a single pointer-compare-against-NULL resulting
+ 	  in a negligible performance hit.
+ 
+ 	  If unsure, say Y to enable cleancache
