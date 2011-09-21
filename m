Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab1IUOSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:18:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50089 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1IUOSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:18:20 -0400
Subject: Re: [PATCH 2/8] mm: alloc_contig_freed_pages() added
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>
In-Reply-To: <op.v15tv0183l0zgt@mnazarewicz-glaptop>
References: <1313764064-9747-1-git-send-email-m.szyprowski@samsung.com>
	 <1313764064-9747-3-git-send-email-m.szyprowski@samsung.com>
	 <1315505152.3114.9.camel@nimitz>  <op.v15tv0183l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 07:07:36 -0700
Message-ID: <1316614056.16137.278.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11092114-8974-0000-0000-000000509902
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 15:17 +0200, Michal Nazarewicz wrote:
> > This 'struct page *'++ stuff is OK, but only for small, aligned areas.
> > For at least some of the sparsemem modes (non-VMEMMAP), you could walk
> > off of the end of the section_mem_map[] when you cross a MAX_ORDER
> > boundary.  I'd feel a little bit more comfortable if pfn_to_page() was
> > being done each time, or only occasionally when you cross a section
> > boundary.
> 
> I'm fine with that.  I've used pointer arithmetic for performance reasons
> but if that may potentially lead to bugs then obviously pfn_to_page()  
> should be used

pfn_to_page() on x86 these days is usually:

	#define __pfn_to_page(pfn)      (vmemmap + (pfn))

Even for the non-vmemmap sparsemem it stays pretty quick because the
section array is in cache as you run through the loop.

There are ways to _minimize_ the number of pfn_to_page() calls by
checking when you cross a section boundary, or even at a
MAX_ORDER_NR_PAGES boundary.  But, I don't think it's worth the trouble.

-- Dave

