Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab2HHQaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:30:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48291 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2HHQaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:30:03 -0400
Message-ID: <502293E2.8010505@linux.vnet.ibm.com>
Date: Wed, 08 Aug 2012 11:29:22 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Hackel <kurt.hackel@oracle.com>
Subject: Re: [PATCH 0/4] promote zcache from staging
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com> <5021795A.5000509@linux.vnet.ibm.com> <3f8dfac9-2b92-442c-800a-f0bfef8a90cb@default>
In-Reply-To: <3f8dfac9-2b92-442c-800a-f0bfef8a90cb@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080816-9360-0000-0000-000009396ACB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 04:47 PM, Dan Magenheimer wrote:
> I notice your original published benchmarks [1] include
> N=24, N=28, and N=32, but these updated results do not.  Are you planning
> on completing the runs?  Second, I now see the numbers I originally
> published for what I thought was the same benchmark as yours are actually
> an order of magnitude larger (in sec) than yours.  I didn't notice
> this in March because we were focused on the percent improvement, not
> the raw measurements.  Since the hardware is highly similar, I suspect
> it is not a hardware difference but instead that you are compiling
> a much smaller kernel.  In other words, your test case is much
> smaller, and so exercises zcache much less.  My test case compiles
> a full enterprise kernel... what is yours doing?

I am doing a minimal kernel build for my local hardware
configuration.

With the reduction in RAM, 1GB to 512MB, I didn't need to do
test runs with >20 threads to find the peak of the benefit
curve at 16 threads.  Past that, zcache is saturated and I'd
just be burning up my disk.  I'm already swapping out about
500MB (i.e. RAM size) in the 20 thread non-zcache case.

Also, I provide the magnitude numbers (pages, seconds) just
to show my source data.  The %change numbers are the real
results as they remove build size as a factor.

> At LSFMM, Andrea
> Arcangeli pointed out that zcache, for frontswap pages, has no "writeback"
> capabilities and, when it is full, it simply rejects further attempts
> to put data in its cache.  He said this is unacceptable for KVM and I
> agreed that it was a flaw that needed to be fixed before zcache should
> be promoted.

KVM (in-tree) is not a current user of zcache.  While the
use cases of possible future zcache users should be
considered, I don't think they can be used to prevent promotion.

> A second flaw is that the "demo" zcache has no concept of LRU for
> either cleancache or frontswap pages, or ability to reclaim pageframes
> at all for frontswap pages.
...
> 
> A third flaw is that the "demo" version has a very poor policy to
> determine what pages are "admitted".
...
> 
> I can add more issues to the list, but will stop here.

All of the flaws you list do not prevent zcache from being
beneficial right now, as my results demonstrate.  Therefore,
the flaws listed are really potential improvements and can
be done in mainline after promotion.  Even if large changes
are required to make these improvements, they can be made in
mainline in an incremental and public way.

Seth

