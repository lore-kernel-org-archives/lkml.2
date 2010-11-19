Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0KSIQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:16:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47041 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0KSIQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:16:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Nov 2010 17:10:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        minchan.kim@gmail.com, Bob Liu <lliubbo@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, m.nazarewicz@samsung.com,
        pawel@osciak.com, andi.kleen@intel.com, felipe.contreras@gmail.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 0/4] big chunk memory allocator v4
Message-Id: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is an updated version. 

No major changes from the last one except for page allocation function.
removed RFC.

Order of patches is

[1/4] move some functions from memory_hotplug.c to page_isolation.c
[2/4] search physically contiguous range suitable for big chunk alloc.
[3/4] allocate big chunk memory based on memory hotplug(migration) technique
[4/4] modify page allocation function.

For what:

  I hear there is requirements to allocate a chunk of page which is larger than
  MAX_ORDER. Now, some (embeded) device use a big memory chunk. To use memory,
  they hide some memory range by boot option (mem=) and use hidden memory
  for its own purpose. But this seems a lack of feature in memory management.

  This patch adds 
	alloc_contig_pages(start, end, nr_pages, gfp_mask)
  to allocate a chunk of page whose length is nr_pages from [start, end)
  phys address. This uses similar logic of memory-unplug, which tries to
  offline [start, end) pages. By this, drivers can allocate 30M or 128M or
  much bigger memory chunk on demand. (I allocated 1G chunk in my test).

  But yes, because of fragmentation, this cannot guarantee 100% alloc.
  If alloc_contig_pages() is called in system boot up or movable_zone is used,
  this allocation succeeds at high rate.

  I tested this on x86-64, and it seems to work as expected. But feedback from
  embeded guys are appreciated because I think they are main user of this
  function.

Thanks,
-Kame


  


