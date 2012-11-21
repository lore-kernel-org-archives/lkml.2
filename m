Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab2KURdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:33:23 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43362 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2KURdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:33:22 -0500
Date: Wed, 21 Nov 2012 18:33:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/46] Automatic NUMA Balancing V4
Message-ID: <20121121173316.GA29311@gmail.com>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <20121121165342.GH8218@suse.de>
 <20121121170306.GA28811@gmail.com>
 <20121121172011.GI8218@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121172011.GI8218@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> On Wed, Nov 21, 2012 at 06:03:06PM +0100, Ingo Molnar wrote:
> > 
> > * Mel Gorman <mgorman@suse.de> wrote:
> > 
> > > On Wed, Nov 21, 2012 at 10:21:06AM +0000, Mel Gorman wrote:
> > > > 
> > > > I am not including a benchmark report in this but will be posting one
> > > > shortly in the "Latest numa/core release, v16" thread along with the latest
> > > > schednuma figures I have available.
> > > > 
> > > 
> > > Report is linked here https://lkml.org/lkml/2012/11/21/202
> > > 
> > > I ended up cancelling the remaining tests and restarted with
> > > 
> > > 1. schednuma + patches posted since so that works out as
> > 
> > Mel, I'd like to ask you to refer to our tree as numa/core or 
> > 'numacore' in the future. Would such a courtesy to use the 
> > current name of our tree be possible?
> > 
> 
> Sure, no problem.

Thanks!

I ran a quick test with your 'balancenuma v4' tree and while 
numa02 and numa01-THREAD-ALLOC performance is looking good, 
numa01 performance does not look very good:

                    mainline    numa/core      balancenuma-v4
     numa01:           340.3       139.4          276 secs

97% slower than numa/core.

I did a quick SPECjbb 32-warehouses run as well:

                                numa/core      balancenuma-v4
      SPECjbb  +THP:               655 k/sec      607 k/sec

Here it's 7.9% slower.

Thanks,

	Ingo
