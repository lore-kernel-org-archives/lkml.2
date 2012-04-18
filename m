Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab2DRNwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:52:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55426 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2DRNwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:52:45 -0400
Date: Wed, 18 Apr 2012 06:51:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c:271
Message-ID: <20120418135152.GC2493@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1334561244.3339.7.camel@aep-desktop>
 <20120418025626.GB23877@home.goodmis.org>
 <20120418040636.GD2449@linux.vnet.ibm.com>
 <1334724679.2019.20.camel@aep-desktop>
 <1334750926.28106.36.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334750926.28106.36.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041813-4242-0000-0000-00000161F39E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 08:08:46AM -0400, Steven Rostedt wrote:
> On Wed, 2012-04-18 at 10:51 +0600, Alexander E. Patrakov wrote:
> 
> > > > 
> > > > Hmm, this can also be reported if you have an rcu leak. Which would also
> > > > explain your memory leak. RCU is the kernel's "garbage collector" and if
> > > > it gets stuck, then you will definitely start seeing memory leaks, as
> > > > memory wont be freed.
> > > 
> > > If RCU is stuck, you should see RCU CPU stall warnings, which can
> > > give clues as to what is causing RCU to get stuck.
> > 
> > Yes, there were such warnings, but all of them said that the stall ended
> > before dump start. So nothing reportable here, but I have just found
> > that https://bugzilla.novell.com/show_bug.cgi?id=754186 looks quite
> > similar in the sense that it (and duplicates) also has undumpable stalls
> > of increasing length, and IPv6 is in use both at home and at work.
> > 
> 
> Do you see the RT throttling message too? That's a bug with an RT task
> going haywire. If that is happening, an RT task may be preventing an RCU
> grace period to finish, and causing the RCU stalls.

Hmmm...  Maybe I should revisit running the RCU core processing in
real-time kernel threads...  Though it was quite painful the last time
I tried that.

							Thanx, Paul

> Just because they ended, doesn't mean that the problem went a way. If
> RCU is being blocked, you will start to see memory leaks. As I said, RCU
> works as the kernels garbage collector. If it stops or just slows down
> significantly, memory does not get freed.
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

