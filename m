Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2GZVZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:25:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:40426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2GZVZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:25:46 -0400
Message-ID: <1343337937.32120.20.camel@twins>
Subject: Re: [ 028/108] sched/nohz: Rewrite and fix load-avg computation --
 again
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jul 2012 23:25:37 +0200
In-Reply-To: <1343138818.5132.98.camel@deadeye.wl.decadent.org.uk>
References: <20120723010655.768372060@decadent.org.uk>
	 <1343138818.5132.98.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 15:06 +0100, Ben Hutchings wrote:
> On Mon, 2012-07-23 at 02:07 +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > commit 5167e8d5417bf5c322a703d2927daec727ea40dd upstream.
> > 
> > Thanks to Charles Wang for spotting the defects in the current code:
> > 
> >  - If we go idle during the sample window -- after sampling, we get a
> >    negative bias because we can negate our own sample.
> > 
> >  - If we wake up during the sample window we get a positive bias
> >    because we push the sample to a known active period.
> > 
> > So rewrite the entire nohz load-avg muck once again, now adding
> > copious documentation to the code.
> [...]
> 
> Based on <http://bugs.debian.org/674153>, I think we also need:
> 
> 556061b sched/nohz: Fix rq->cpu_load[] calculations
> 5aaa0b7 sched/nohz: Fix rq->cpu_load calculations some more
> 
> Does this ('sched/nohz: Rewrite and fix load-avg computation -- again')
> depend in any way on those, or are they separate fixes?

they might touch on a few entry points but the logic is separate.

->cpu_load[] is per-cpu weight tracking for the load-balancer.




