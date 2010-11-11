Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0KKOZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:25:42 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57312 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab0KKOZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:25:41 -0500
Date: Thu, 11 Nov 2010 14:25:27 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [BUG] Commit d065bd81 severely regresses huge page allocation
	success rates
Message-ID: <20101111142527.GG19679@csn.ul.ie>
References: <20101111121545.GF19679@csn.ul.ie> <AANLkTinxYntXjK7V8W3+3j7m0xQUVpB1eeysSE0ifO1k@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTinxYntXjK7V8W3+3j7m0xQUVpB1eeysSE0ifO1k@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 04:25:00AM -0800, Michel Lespinasse wrote:
> On Thu, Nov 11, 2010 at 4:15 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > When testing 2.6.37-rc1, I noticed that huge page allocation success
> > rates were severely impaired. Bisection showed that commit [d065bd81: mm:
> > retry page fault when blocking on disk transfer] was the biggest factor.
> > Reverting the patch confirmed this. Here are the results of a high-order
> > allocation stress test. The vanilla kernel is 2.6.37-rc1 and the revert
> > kernel has this commit removed with minor conflicts cleaned up.
> [...]
> > I have not digested what the patch is doing but am reporting it in case
> > people familiar with the patch spot the problem quickly.
> 
> There was a bug in that commit, which was fixed in
> d88c0922fa0e2c021a028b310a641126c6d4b7dc
> 
> I think this may explain the issue; compaction won't work well if
> extra references are kept :/
> 

Reclaim would not work either as it is effectively a leak.

> Can you check that this indeed solves your test case ?
> 

It does. Thanks very much.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
