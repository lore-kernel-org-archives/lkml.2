Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab0JYTlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:41:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52414 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab0JYTlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:41:44 -0400
Date: Mon, 25 Oct 2010 12:41:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about synchronize_sched_expedited()
Message-ID: <20101025194140.GB6390@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101025154358.GA6919@linux.vnet.ibm.com>
 <4CC5AA5F.9060909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC5AA5F.9060909@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 06:03:43PM +0200, Tejun Heo wrote:
> Hello, Paul.
> 
> On 10/25/2010 05:43 PM, Paul E. McKenney wrote:
> > Hello, Tejun,
> > 
> > I was taking another look at synchronize_sched_expedited(), and was
> > concerned about the scenario listed out in the following commit.
> > Is this scenario a real problem, or am I missing the synchronization
> > that makes it safe?
> > 
> > (If my concerns are valid, I should also be able to change this
> > to non-atomically increment synchronize_sched_expedited_count, but
> > one step at a time...)
> 
> I think your concern is valid and this can happen w/o preemption given
> enough cpus and perfect timing.  Was the original code free from this
> problem?

I believe so -- there was a mutex guarding the whole operation, including
the increment.

> IMHO the counter based mechanism is a bit too difficult to ponder and
> verify.  Can we do more conventional double queueing (ie. flipping
> pending and executing queues so that multiple sync calls can get
> coalesced while another one is in progress)?  That's what the code is
> trying to achieve anyway, right?

Hmmm...  But it would be necessary to flip the queues somewhere, and
wouldn't determining where that somewhere was involve the same analysis
and complexity as determining where to increment the counter?

							Thanx, Paul
