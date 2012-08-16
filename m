Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab2HPXIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 19:08:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:43165 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab2HPXIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 19:08:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,781,1336374000"; 
   d="scan'208";a="181979107"
Message-ID: <502D7D6E.8090303@linux.intel.com>
Date: Thu, 16 Aug 2012 16:08:30 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, RFC 0/9] Introduce huge zero page
References: <1344503300-9507-1-git-send-email-kirill.shutemov@linux.intel.com> <20120816122023.c0e9bbc0.akpm@linux-foundation.org> <20120816194024.GP11188@redhat.com>
In-Reply-To: <20120816194024.GP11188@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 12:40 PM, Andrea Arcangeli wrote:
> Hi Andrew,
> 
> On Thu, Aug 16, 2012 at 12:20:23PM -0700, Andrew Morton wrote:
>> That's a pretty big improvement for a rather fake test case.  I wonder
>> how much benefit we'd see with real workloads?
> 
> The same discussion happened about the zero page in general and
> there's no easy answer. I seem to recall that it was dropped at some
> point and then we reintroduced the zero page later.
> 
> Most of the time it won't be worth it, it's just a few pathological
> compute loads that benefits IIRC. So I'm overall positive about it
> (after it's stable).
> 
> Because this is done the right way (i.e. to allocate an hugepage at
> the first wp fault, and to fallback exclusively if compaction fails)
> it will help much less than the 4k zero pages if the zero pages are
> scattered over the address space and not contiguous (it only helps if
> there are 512 of them in a row). OTOH if they're contiguous, the huge
> zero pages will perform better than the 4k zero pages.
> 

One thing that I asked for testing a "virtual zero page" where the same
page (or N pages for N-way page coloring) is reused across a page table.
 It would have worse TLB performance but likely *much* better cache
behavior.

	-hpa


