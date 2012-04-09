Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2DISsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:48:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51266 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2DISsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:48:06 -0400
Date: Mon, 9 Apr 2012 11:45:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: semaphore and mutex in current Linux kernel (3.2.2)
Message-ID: <20120409184538.GE2430@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
 <20120403075245.GD26826@gmail.com>
 <4F7DA8FD.1020909@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
 <4F7EC111.4010608@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9ED2@SCYBEXDAG02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE0439F9ED2@SCYBEXDAG02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040918-7282-0000-0000-0000080D5682
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 05:47:28PM +0000, Chen, Dennis (SRDC SW) wrote:
> On Fri, Apr 6, 2012 at 6:10 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> > Chen, Dennis (SRDC SW) wrote:
> >> On Thu, Apr 5, 2012 at 10:15 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> >>
> >> I guess this is related with RCU component, but I don't found the right place where the code
> >> Located yet.
> >
> > "On the internet, nobody can hear you being subtle."
> >
> > If some other process wants to run on the same CPU, needs_resched() is set.
> > (This might happen to make the cursor blink, for keyboard input, or when
> > somebody starts a rogue process like ps.)
> >
> 
> Hmm, I forget that in each timer interrupt, __rcu_pending() will be called, it will call
> set_need_resched() to set the TIF_NEED_RESCHED in some condition...
> The optimization of mutex work closely with rcu, so fantastic!

I must confess that you all lost me on this one.

There is a call to set_need_resched() in __rcu_pending(), which is
invoked when the current CPU has not yet responded to a non-preemptible
RCU grace period for some time.  However, in the common case where the
CPUs all respond in reasonable time, __rcu_pending() will never call
set_need_resched().

However, we really do not want to call set_need_resched() on every call
to __rcu_pending().  There is almost certainly a better solution to any
problem that might be solved by a per-jiffy call to set_need_resched().

So, what are you really trying to do?

							Thanx, Paul

