Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2JAR0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:26:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab2JAR0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:26:36 -0400
Date: Mon, 1 Oct 2012 19:26:24 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/3] Virtual huge zero page
Message-ID: <20121001172624.GD18051@redhat.com>
References: <1348875441-19561-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120929134811.GC26989@redhat.com>
 <5069B804.6040902@linux.intel.com>
 <20121001163118.GC18051@redhat.com>
 <5069CCF9.7040309@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5069CCF9.7040309@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 10:03:53AM -0700, H. Peter Anvin wrote:
> Something isn't quite right about that.  If you look at your numbers:
> 
> 1,049,134,961 LLC-loads
>         6,222 LLC-load-misses
> 
> This is another way of saying in your benchmark the huge zero page is
> parked in your LLC - using up 2 MB of your LLC, typically a significant
> portion of said cache.  In a real-life application that will squeeze out
> real data, but in your benchmark the system is artificially quiescent.

Agreed. And that argument applies to the cache benefits of the virtual
zero page too: squeeze the cache just more aggressively so those 4k
got out of the cache too, and that 6% improvement will disappear
(while the TLB benefit of the physical zero page is guaranteed and is
always present no matter the workload, even if the TLB miss at the
same frequency, it'll get filled with one less cacheline access every
time).

> It is well known that microbenchmarks can be horribly misleading.  What
> led to Kirill investigating huge zero page in the first place was the
> fact that some applications/macrobenchmarks benefit, and I think those
> are the right thing to look at.

The whole point of the two microbenchmarks was to measure the worst
cases for both scenarios and I think that was useful. Real life using
zero pages are going to be somewhere in that range.
