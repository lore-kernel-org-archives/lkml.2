Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2JDSLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:11:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44208 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2JDSLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:11:41 -0400
Date: Thu, 04 Oct 2012 14:11:36 -0400 (EDT)
Message-Id: <20121004.141136.1763670567147718953.davem@davemloft.net>
To: aarcange@redhat.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        hannes@cmpxchg.org, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH 0/8] THP support for Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121004103548.GB6793@redhat.com>
References: <20121002155544.2c67b1e8.akpm@linux-foundation.org>
	<20121003.220027.1636081487098835868.davem@davemloft.net>
	<20121004103548.GB6793@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Date: Thu, 4 Oct 2012 12:35:48 +0200

> Hi Dave,
> 
> On Wed, Oct 03, 2012 at 10:00:27PM -0400, David Miller wrote:
>> From: Andrew Morton <akpm@linux-foundation.org>
>> Date: Tue, 2 Oct 2012 15:55:44 -0700
>> 
>> > I had a shot at integrating all this onto the pending stuff in linux-next. 
>> > "mm: Add and use update_mmu_cache_pmd() in transparent huge page code."
>> > needed minor massaging in huge_memory.c.  But as Andrea mentioned, we
>> > ran aground on Gerald's
>> > http://ozlabs.org/~akpm/mmotm/broken-out/thp-remove-assumptions-on-pgtable_t-type.patch,
>> > part of the thp-for-s390 work.
>> 
>> While working on a rebase relative to this work, I noticed that the
>> s390 patches don't even compile.
>> 
>> It's because of that pmd_pgprot() change from Peter Z. which arrives
>> asynchonously via the linux-next tree.  It makes THP start using
>> pmd_pgprot() (a new interface) which the s390 patches don't provide.
> 
> My suggestion would be to ignore linux-next and port it to -mm only
> and re-send to Andrew. schednuma is by mistake in linux-next, and
> it's not going to get merged as far as I can tell.

Sorry Andrea, that simply is impractical.

The first thing Andrew's patch series does is include linux-next,
therefore every THP and MM patch in his series is against linux-next.

So there are already dependencies in there on the pmd_pgprot() bits
and I already did the implementation for sparc64 so that's what I'm
submitting against.
