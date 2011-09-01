Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab1IAWBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:01:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47577 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab1IAWBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:01:46 -0400
Message-ID: <4E6000C4.7030007@linux.vnet.ibm.com>
Date: Thu, 01 Sep 2011 17:01:40 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, ngupta@vflare.org, cascardo@holoscopio.com,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] staging: zcache: xcfmalloc support
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com> <6e0e7950-0c91-4bb3-929b-3853fa95e63d@default 4E5EB066.6020007@linux.vnet.ibm.com> <36dad993-ea60-43f4-89f0-77831befd483@default> <4E5FB3CF.3020703@linux.vnet.ibm.com> <1314896087.13161.30.camel@nimitz>
In-Reply-To: <1314896087.13161.30.camel@nimitz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 11:54 AM, Dave Hansen wrote:
> On Thu, 2011-09-01 at 11:33 -0500, Seth Jennings wrote:
>> xcfmalloc is also 0(1) in that the number of freelists
>> at that have to be checked is constant and not increasing
>> with the number of allocations.  The constant hidden
>> in the O(1) for finding a suitable block is NUM_FREELISTS.
> 
> The algorithm is technically O(n^2) since there are
> XCF_MAX_BLOCKS_PER_ALLOC searches through XCF_NUM_FREELISTS.  There's
> also the reserved pages refill loop, which is linear too.
> 

I was seeing n as the number of allocations.  Since 
XCF_MAX_BLOCKS_PER_ALLOC and XCF_NUM_FREELISTS are constant (i.e.
not increasing with the number of allocations) wouldn't it be
O(1)?

I see it like this:

for (i=0; i<2; i++) {
	do_something();
}

vs.

do_something();
do_something();

Is one O(n) and the other O(1)?  They do the same thing because the
loop iterates a constant number of times.

For it to be O(n) it would have to be:

for (i=0; i<n; i++) {
	do_something();
}

Right?

> xcfmalloc's big compromise is that it doesn't do any searching or
> fitting.  It might needlessly split larger blocks when two small ones
> would have worked, for instance.

Splitting a larger block is the last option.  I might not
be understanding you correctly, but find_remove_block() does try to
find the optimal block to use, which is "searching and fitting" in my
mind.

> 
> -- Dave
> 

