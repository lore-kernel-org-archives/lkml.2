Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0KRCDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:03:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277Ab0KRCDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:03:50 -0500
Date: Wed, 17 Nov 2010 17:59:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] IO-less dirty throttling
Message-Id: <20101117175900.0d7878e5.akpm@linux-foundation.org>
In-Reply-To: <20101118014051.GR22876@dastard>
References: <20101117035821.000579293@intel.com>
	<20101117072538.GO22876@dastard>
	<20101117100655.GA26501@localhost>
	<20101118014051.GR22876@dastard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 12:40:51 +1100 Dave Chinner <david@fromorbit.com> wrote:

> 
> There's no point
> waking a dirtier if all they can do is write a single page before
> they are throttled again - IO is most efficient when done in larger
> batches...

That assumes the process was about to do another write.  That's
reasonable on average, but a bit sad for interactive/rtprio tasks.  At
some stage those scheduler things should be brought into the equation.

>
> ...
>
> Yeah, sorry, should have posted them - I didn't because I snapped
> the numbers before the run had finished. Without series:
> 
> 373.19user 14940.49system 41:42.17elapsed 612%CPU (0avgtext+0avgdata 82560maxresident)k
> 0inputs+0outputs (403major+2599763minor)pagefaults 0swaps
> 
> With your series:
> 
> 359.64user 5559.32system 40:53.23elapsed 241%CPU (0avgtext+0avgdata 82496maxresident)k
> 0inputs+0outputs (312major+2598798minor)pagefaults 0swaps
> 
> So the wall time with your series is lower, and system CPU time is
> way down (as I've already noted) for this workload on XFS.

How much of that benefit is an accounting artifact, moving work away
from the calling process's CPU and into kernel threads?

