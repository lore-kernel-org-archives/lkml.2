Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab0FVGGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:06:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab0FVGGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:06:43 -0400
Date: Tue, 22 Jun 2010 16:06:39 +1000
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 11/33] fs: dcache scale subdirs
Message-ID: <20100622060639.GE31679@laptop>
References: <20090904065142.114706411@nick.local0.net>
 <20090904065535.609317663@nick.local0.net>
 <1276787615.27822.426.camel@twins>
 <20100617165329.GA6138@laptop>
 <1277127322.1875.516.camel@laptop>
 <20100621144806.GC31679@laptop>
 <1277132103.1875.519.camel@laptop>
 <1277186557.1791.7.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277186557.1791.7.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:02:37PM -0700, John Stultz wrote:
> On Mon, 2010-06-21 at 16:55 +0200, Peter Zijlstra wrote:
> > On Tue, 2010-06-22 at 00:48 +1000, Nick Piggin wrote:
> > > > Right, so I was staring at the -rt splat, so its John who created that
> > > > wreckage?
> > > 
> > > It was, but apparently they saw an RCU bug there somewhere and hit it
> > > with the big hammer. I haven't been able to reproduce it on a non-rt
> > > kernel yet, and I see yet why RCU is not good enough here.
> > 
> > John, could you describe the failure you spotted?
> 
> The problem was that the rcu_read_lock() on the dentry ascending wasn't
> preventing d_put/d_kill from removing entries from the parent node. So
> the next entry we tried to follow was invalid. So we were getting odd
> oopses from select_parent().

Oh, ah OK that makes sense. I was thinking it was a use after grace
period problem. Hmm, I'll think about whether we can fix it better.

> 
> I'm not as familiar with the rcu rules there, so the patch I made just
> held the locks as it went down the chain. Not ideal of course, but still
> an improvement over the dcache_lock that was there prior.
> 
> Peter: I'm sorry, I've been out for a few days. Can you give me some
> background on what brought this up and what -rt splat you mean?
> 
> thanks
> -john
> 
