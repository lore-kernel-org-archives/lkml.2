Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1DGWF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:05:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60433 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab1DGWF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:05:27 -0400
Date: Thu, 7 Apr 2011 15:05:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Huang Ying <ying.huang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: About lock-less data structure patches
Message-ID: <20110407220524.GK2262@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D93DB49.3060205@intel.com>
 <20110401213748.GA26543@Krystal>
 <4D96AEAE.2010800@intel.com>
 <20110404155328.GA13390@Krystal>
 <BANLkTin3XpOnnqWcu-bsUCJ_6JaYcBkJkg@mail.gmail.com>
 <20110405044227.GA20013@Krystal>
 <BANLkTinLH=s419RVQXSUTjBSdH0XjdpZWg@mail.gmail.com>
 <20110406014824.GB32321@Krystal>
 <4D9D1DF0.6030704@intel.com>
 <20110407183206.GB6104@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407183206.GB6104@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 02:32:06PM -0400, Mathieu Desnoyers wrote:
> * Huang Ying (ying.huang@intel.com) wrote:
> > On 04/06/2011 09:48 AM, Mathieu Desnoyers wrote:
> > > * huang ying (huang.ying.caritas@gmail.com) wrote:
> > [snip]
> > >>>>
> > >>>> OK.  I will change the comments, adding these semantics explanation.
> > >>>> The user should be warned :)
> > >>>
> > >>> Yes, that makes sense. After this generalization step, if you're ok with
> > >>> this, we could aim at moving the implementation from a stack to a queue
> > >>> and provide fifo semantic rather than lifo, so that other users (e.g.
> > >>> call_rcu in the kernel) can start benefiting from it.

Just to be clear...  Currently, call_rcu() works on a per-CPU basis,
so that it can simply disable interrupts and then do the queuing
non-atomically.

However, should it be necessary to cross-queue RCU callbacks in order
to avoid ever executing an RCU callback on a given CPU, then something
like this might become useful.

							Thanx, Paul

> > >> I think that is good to move from stack to queue.
> > >>
> > >> I will send out changed lock-less data structure patchset soon.  And
> > >> we can continue to work on the new lock-less queue at the same time.
> > > 
> > > Sounds like a very good plan! Thanks!
> > 
> > Maybe you can send out your lock-less queue patches, so we can work on that.
> 
> Yep, let's wait until your implementation is finalized and merged, and
> then ping me again so I can cook up a RFC patch turning llist into a
> queue, if it's OK with you.
> 
> Thanks,
> 
> Mathieu
> 
> > 
> > Best Regards,
> > Huang Ying
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
