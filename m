Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2ARArV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:47:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59535 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2ARArT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:47:19 -0500
MIME-Version: 1.0
In-Reply-To: <op.v781mqwl3l0zgt@mpn-glaptop>
References: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
 <1325162352-24709-5-git-send-email-m.szyprowski@samsung.com>
 <CA+K6fF6A1kPUW-2Mw5+W_QaTuLfU0_m0aMYRLOg98mFKwZOhtQ@mail.gmail.com> <op.v781mqwl3l0zgt@mpn-glaptop>
From: sandeep patil <psandeep.s@gmail.com>
Date: Tue, 17 Jan 2012 16:46:37 -0800
Message-ID: <CA+K6fF64hjVBjx6NPspQSud2hkJQWzeXkceLAChPrO-k7eCF+g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 04/11] mm: page_alloc: introduce alloc_contig_range()
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, we are wondering ourselves about that.  Could you try cherry-picking
> commit ad10eb079c97e27b4d27bc755c605226ce1625de (update migrate type on pcp
> when isolating) from git://github.com/mina86/linux-2.6.git?  It probably
> won't
> apply cleanly but resolving the conflicts should not be hard (alternatively
> you can try branch cma from the same repo but it is a work in progress at
> the
> moment).
>

I'll try this patch and report back ,,


>> is set to MIGRATE_CMA instead of MIGRATE_ISOLATED.
>
>
> My understanding of that situation is that the page is on pcp list in which
> cases it's page_private is not updated.  Draining and the first patch in
> the series (and also the commit I've pointed to above) are designed to fix
> that but I'm unsure why they don't work all the time.
>
>

Will verify this if the page is found on the pcp list as well .

>> I've also had a test case where it failed because (page_count() != 0)

With this, when it failed the page_count()
returned a value of 2. I am not sure why, but I will try and see If I can
reproduce this.

>
>
>> Have you or anyone else seen this during the CMA testing?
>>
>> Also, could this be because we are finding a page within (start, end)
>> that actually belongs to a higher order Buddy block ?
>
>
> Higher order free buddy blocks are skipped in the “if (PageBuddy(page))”
> path of __test_page_isolated_in_pageblock().  Then again, now that I think
> of it, something fishy may be happening on the edges.  Moving the check
> outside of __alloc_contig_migrate_range() after outer_start is calculated
> in alloc_contig_range() could help.  I'll take a look at it.

I was going to suggest that, moving the check until after outer_start
is calculated
will definitely help IMO. I am sure I've seen a case where

  page_count(page) = page->private = 0 and PageBuddy(page) was false.

I will try and reproduce this as well.

Thanks,
Sandeep
