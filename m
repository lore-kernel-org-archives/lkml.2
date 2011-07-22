Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1GVLnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:43:45 -0400
Received: from ozlabs.org ([203.10.76.45]:33883 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab1GVLno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:43:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
In-Reply-To: <20110721083501.GC3455@htj.dyndns.org>
References: <4E1D6900.6040500@cam.ac.uk> <20110713133139.GO2872@htj.dyndns.org> <4E1DA232.30408@cam.ac.uk> <878vrs2if3.fsf@rustcorp.com.au> <20110721081946.GB3455@htj.dyndns.org> <20110721083501.GC3455@htj.dyndns.org>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Fri, 22 Jul 2011 20:43:05 +0930
Message-ID: <87sjpyzhz2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 10:35:01 +0200, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Jul 21, 2011 at 10:19:46AM +0200, Tejun Heo wrote:
> > On Thu, Jul 21, 2011 at 05:07:36PM +0930, Rusty Russell wrote:
> > > From: Rusty Russell <rusty@rustcorp.com.au>
> > > Subject: ida: Simplified functions for id allocation.
> > > 
> > > The current hyper-optimized functions are overkill if you simply want
> > > to allocate an id for a device.  Create versions which use an internal
> > > lock.
> > > 
> > > Thanks to Tejun for feedback.  Feel free to delete the #ifdef TEST
> > > code.
> > > 
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > ...
> > >  static struct kmem_cache *idr_layer_cache;
> > > +static DEFINE_SPINLOCK(simple_ida);
> > 
> > I think the name is a bit confusing.  Maybe simple_ida_lock is better?
> > Other than that,
> 
> Ooh, one more thing, maybe it would be better to use spin_lock_irq()
> to allow calling free under other irq locks.

Jonathan, please take original patch and mod it to taste, and produce a
series on it you can push to Andrew.

As for irqsave etc, as soon as someone needs that we can add
it... Jonathan will run into it soon enough.

Thanks,
Rusty.
