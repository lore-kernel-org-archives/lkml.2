Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0KRHjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:39:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181Ab0KRHjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:39:12 -0500
Date: Wed, 17 Nov 2010 23:33:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] IO-less dirty throttling v2
Message-Id: <20101117233350.321f9935.akpm@linux-foundation.org>
In-Reply-To: <20101118072706.GW13830@dastard>
References: <20101117042720.033773013@intel.com>
	<20101117150330.139251f9.akpm@linux-foundation.org>
	<20101118020640.GS22876@dastard>
	<20101117180912.38541ca4.akpm@linux-foundation.org>
	<20101118032141.GP13830@dastard>
	<20101117193431.ec1f4547.akpm@linux-foundation.org>
	<20101118072706.GW13830@dastard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 18:27:06 +1100 Dave Chinner <david@fromorbit.com> wrote:

> > > Indeed, nobody has
> > > realised (until now) just how inefficient it really is because of
> > > the fact that the overhead is mostly hidden in user process system
> > > time.
> > 
> > "hidden"?  You do "time dd" and look at the output!
> > 
> > _now_ it's hidden.  You do "time dd" and whee, no system time!
> 
> What I meant is that the cost of foreground writeback was hidden in
> the process system time. Now we have separated the two of them, we
> can see exactly how much it was costing us because it is no longer
> hidden inside the process system time.

About a billion years ago I wrote the "cyclesoak" thingy which measures
CPU utilisation the other way around: run a lowest-priority process on
each CPU in the background, while running your workload, then find out
how much CPU time cyclesoak *didn't* consume.  That way you account for
everything: user time, system time, kernel threads, interrupts,
softirqs, etc.  It turned out to be pretty accurate, despite the
then-absence of SCHED_IDLE.

