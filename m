Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1BOSAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:00:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab1BOSAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:00:32 -0500
Date: Tue, 15 Feb 2011 19:00:26 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric B Munson <emunson@mgebm.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 0/5] fix up /proc/$pid/smaps to not split huge pages
Message-ID: <20110215180026.GH5935@random.random>
References: <20110209195406.B9F23C9F@kernel>
 <20110215165510.GA2550@mgebm.net>
 <20110215170152.GF5935@random.random>
 <1297789525.9829.9616.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297789525.9829.9616.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 09:05:25AM -0800, Dave Hansen wrote:
> On Tue, 2011-02-15 at 18:01 +0100, Andrea Arcangeli wrote:
> > > The entire mapping is contained in a THP but the
> > > KernelPageSize shows 4kb.  For cases where the mapping might
> > > have mixed page sizes this may be okay, but for this
> > > particular mapping the 4kb page size is wrong.
> > 
> > I'm not sure this is a bug, if the mapping grows it may become 4096k
> > but the new pages may be 4k. There's no such thing as a
> > vma_mmu_pagesize in terms of hugepages because we support graceful
> > fallback and collapse/split on the fly without altering the vma. So I
> > think 4k is correct here
> 
> How about we bump MMUPageSize for mappings that are _entirely_ huge
> pages, but leave it at 4k for mixed mappings?  Anyone needing more
> detail than that can use the new AnonHugePages count.

Anyone needing the detail that you ask for, already can use the
AnonHugePages count.

> KernelPageSize is pretty ambiguous, and we could certainly make the
> argument that the kernel is or can still deal with things in 4k blocks.

That's my point. We could bring it to 2m whenever
AnonHugePages==Anonymous, that's a two liner change, but I'm not
really sure if it makes sense or it provides any meaningful info.

That is a slot specific to show hugetlbfs presence and to
differentiate between 2m/1g mappings. I think remaining mutually
exclusive between AnonHugePages > 0 and MMUPageSize >4k is actually
cleaner than a two liner magic returning 2m if AnonHugePages ==
Anonymous.
