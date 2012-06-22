Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab2FVT3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:29:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58086 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2FVT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:29:24 -0400
Date: Fri, 22 Jun 2012 12:29:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early boot panic on machine with lots of memory
Message-ID: <20120622192919.GL4642@google.com>
References: <20120618223203.GE32733@google.com>
 <1340059850.3416.3.camel@lappy>
 <20120619041154.GA28651@shangw>
 <20120619212059.GJ32733@google.com>
 <20120619212618.GK32733@google.com>
 <CAE9FiQVECyRBie-kgBETmqxPaMx24kUt1W07qAqoGD4vNus5xQ@mail.gmail.com>
 <20120621201728.GB4642@google.com>
 <CAE9FiQXubmnKHjnqOxVeoJknJZFNuStCcW=1XC6jLE7eznkTmg@mail.gmail.com>
 <20120622185113.GK4642@google.com>
 <CAE9FiQVV+WOWywnanrP7nX-wai=aXmQS1Dcvt4PxJg5XWynC+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQVV+WOWywnanrP7nX-wai=aXmQS1Dcvt4PxJg5XWynC+Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Fri, Jun 22, 2012 at 12:23:24PM -0700, Yinghai Lu wrote:
> > Thanks for checking it.  I was worried because of the re-reservation
> > of reserved.regions after giving memory to the page allocator -
> > ie. memblock_reserve_reserved_regions() call.  If memblock is done at
> > that point, there's no reason to have that call at all.  It could be
> > that that's just dead code.  If so, why aren't we freeing
> > memory.regions?
> 
> During converting bootmem to use early_res stage, I still kept the
> numa handling.
> like one node by one node. So need to put the reserved.regions back.
> Later found we could do that for all node at the same time.
> 
> For memory.regions, a little different, at that time I want to kill
> e820 all like e820_all_mapped_ram.
> 
> Yes, we should get back region that is allocated for doubled memory.regions.
> but did not trigger that doubling yet.
> 
> Also for x86, all memblock in __initdata, and will be freed later.

Thanks for the explanation.

> > Also, shouldn't we be clearing
> > memblock.cnt/max/total_size/regions so that we know for sure that it's
> > never used again?  What am I missing?
> 
> 64bit mem_init(), after absent_page_in_range(), will not need memblock anymore.
>   --- absent_page_in_range will refer for_each_mem_pfn_range.
> 
> so after that could clear that for memory.regions too.

I wish we had a single call - say, memblock_die(), or whatever - so
that there's a clear indication that memblock usage is done, but yeah
maybe another day.  Will review the patch itself.  BTW, can't you post
patches inline anymore?  Attaching is better than corrupt but is still
a bit annoying for review.

Thanks.

-- 
tejun
