Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2AaWYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:24:53 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:41550 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2AaWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:24:52 -0500
Date: Tue, 31 Jan 2012 14:24:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
Message-ID: <20120131222447.GH2391@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1328016724.2446.229.camel@twins>
 <4F27F0E6.1040309@redhat.com>
 <1328017807.2446.230.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328017807.2446.230.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12013122-5518-0000-0000-000001EABC8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 02:50:07PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-01-31 at 15:47 +0200, Avi Kivity wrote:
> 
> > They really need to return quickly to userspace, and they really need to
> > perform some operation between rcu_assign_pointer() and returning, so no.
> 
> Bugger :/
> 
> > >
> > > Compile tested only!! :-)
> > >
> > 
> > How much did synchronize_srcu_expedited() regress?  Presumably your
> > compiler didn't tell you that.
> 
> Nope, quite a lot I figure.
> 
> > Can we get it back to speed by scheduling a work function on all cpus? 
> > wouldn't that force a quiescent state and allow call_srcu() to fire?
> > 
> > In kvm's use case synchronize_srcu_expedited() is usually called when no
> > thread is in a critical section, so we don't have to wait for anything
> > except the srcu machinery.
> 
> OK, I'll try and come up with means of making it go fast again ;-)

I cannot resist suggesting a kthread to do the call_srcu(), which
would allow synchronize_srcu_expedited() to proceed with its current
brute-force speed.

							Thanx, Paul

