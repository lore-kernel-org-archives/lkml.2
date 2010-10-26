Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab0JZKGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:06:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59283 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab0JZKGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:06:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 26 Oct 2010 19:00:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>, andi.kleen@intel.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, felipe.contreras@gmail.com
Subject: [RFC][PATCH 0/3] big chunk memory allocator v2
Message-Id: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here is version 2.

I only did small test and it seems to work (but I think there will be bug...)
I post this now just because I'll be out of office 10/31-11/15 with ksummit and
a private trip.

Any comments are welcome but please see the interface is enough for use cases or
not.  For example) If MAX_ORDER alignment is too bad, I need to rewrite almost
all code.

Now interface is:


struct page *__alloc_contig_pages(unsigned long base, unsigned long end,
                        unsigned long nr_pages, int align_order,
                        int node, gfp_t gfpflag, nodemask_t *mask)

 * @base: the lowest pfn which caller wants.
 * @end:  the highest pfn which caller wants.
 * @nr_pages: the length of a chunk of pages to be allocated.
 * @align_order: alignment of start address of returned chunk in order.
 *   Returned' page's order will be aligned to (1 << align_order).If smaller
 *   than MAX_ORDER, it's raised to MAX_ORDER.
 * @node: allocate near memory to the node, If -1, current node is used.
 * @gfpflag: see include/linux/gfp.h
 * @nodemask: allocate memory within the nodemask.

If the caller wants a FIXED address, set end - base == nr_pages.

The patch is based onto the latest mmotm + Bob's 3 patches for fixing
memory_hotplug.c (they are queued.)

Thanks,
-Kame




