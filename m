Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2BEQ7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 11:59:38 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:58556 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2BEQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 11:59:37 -0500
Date: Sun, 5 Feb 2012 08:59:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
Message-ID: <20120205165927.GH2467@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201184045.GG2382@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202011404500.2074@router.home>
 <20120201201336.GI2382@linux.vnet.ibm.com>
 <4F2A58A1.90800@redhat.com>
 <20120202153437.GD2518@linux.vnet.ibm.com>
 <4F2AB66C.2030309@redhat.com>
 <20120202170134.GM2518@linux.vnet.ibm.com>
 <4F2AC69B.7000704@redhat.com>
 <20120202175155.GV2518@linux.vnet.ibm.com>
 <4F2E7311.8060808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2E7311.8060808@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020516-5518-0000-0000-000002038FB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 02:16:17PM +0200, Avi Kivity wrote:
> On 02/02/2012 07:51 PM, Paul E. McKenney wrote:
> > On Thu, Feb 02, 2012 at 07:23:39PM +0200, Avi Kivity wrote:
> > > On 02/02/2012 07:01 PM, Paul E. McKenney wrote:
> > > > > 
> > > > > It's not called (since the cpu is not idle).  Instead we call
> > > > > rcu_virt_note_context_switch().
> > > >
> > > > Frederic's work checks to see if there is only one runnable user task
> > > > on a given CPU.  If there is only one, then the scheduling-clock interrupt
> > > > is turned off for that CPU, and RCU is told to ignore it while it is
> > > > executing in user space.  Not sure whether this covers KVM guests.
> > > 
> > > Conceptually it's the same.  Maybe it needs adjustments, since kvm
> > > enters a guest in a different way than the kernel exits to userspace.
> > > 
> > > > In any case, this is not yet in mainline.
> > > 
> > > Let me know when it's in, and I'll have a look.
> >
> > Could you please touch base with Frederic Weisbecker to make sure that
> > what he is doing works for you?
> 
> Looks like there are new rcu_user_enter() and rcu_user_exit() APIs which
> we can use.  Hopefully they subsume rcu_virt_note_context_switch() so we
> only need one set of APIs.

Now that you mention it, that is a good goal.  However, it requires
coordination with Frederic's code as well, so some investigation
is required.  Bad things happen if you tell RCU you are idle when you
really are not and vice versa!

							Thanx, Paul

