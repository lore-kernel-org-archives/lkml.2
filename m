Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1KJSxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:53:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:53413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab1KJSxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:53:00 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Date: Thu, 10 Nov 2011 19:52:47 +0100
References: <20111107110149.GA5177@quad>
	 <20111110180308.GD15738@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320951167.13800.50.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 19:41 +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-10 at 19:03 +0100, Robert Richter wrote:
> > But this algorithm does not work for all cases and does not solve the
> > problem in general. 
> 
> Yeah, the problem in general is O(n!) no O(n^3) algorithm can compute
> the optimal solution for n>3 or so.
> 
> I think the goal is to keep the 'normal' case O(n^2) but try and suck
> less for the corner cases without degenerating into a full blown O(n!).
> 
> So I think we want an amortized O(n^2) with an upper bound well below
> O(n!).

I don't think its reasonable to require a perfect solver for the generic
problem since O(n!) is well outside sanity.

Practically though, the most challenging problem is the AMD F15 thing,
since those constraints are quite specific it might just be possible to
construct an algorithm that finds optimal solutions well below O(n!) for
that particular constraint set.

IIRC, Robert's proposal limits the rewind stack to 1, which, if my mind
didn't completely stop working, should end up being something like
O(n^3). Now I don't know if Robert's thing is perfect for AMD F15 or if
there's still some odd fail cases, but since he's from AMD I suspect its
good enough in practice.

In fact, I almost merged his code, my only complaint was a lack of
comments and having had to spend several hours to fully understand the
thing a few months ago, I felt it really could use some since I didn't
want to have to spend that amount of effort every time I'd have to look
at the thing.


