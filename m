Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1AUVWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:22:51 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49315 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab1AUVWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:22:49 -0500
Date: Fri, 21 Jan 2011 13:22:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
Message-ID: <20110121212245.GN17752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <x49aaiwd6cs.fsf@segfault.boston.devel.redhat.com>
 <AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
 <x491v48d47d.fsf@segfault.boston.devel.redhat.com>
 <AANLkTi=ChBc3+o_GcdKKn4HZykNkQ70mxPLu9HYDfeFj@mail.gmail.com>
 <x49wrm0bo7g.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikTJ-eCR2M73=G4q=0AAsb9aVosrFdwP+uY7enB@mail.gmail.com>
 <20110120040308.GD8476@linux.vnet.ibm.com>
 <AANLkTi=RdmWV9MLWzDxe6N_kWZQA+a2o8jg-PkB-7QGk@mail.gmail.com>
 <20110120200237.GC17752@linux.vnet.ibm.com>
 <1295554555.2613.15.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295554555.2613.15.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 09:15:55PM +0100, Eric Dumazet wrote:
> Le jeudi 20 janvier 2011 à 12:02 -0800, Paul E. McKenney a écrit :
> > On Fri, Jan 21, 2011 at 05:31:53AM +1100, Nick Piggin wrote:
> > > call_rcu() is the obvious alternative, yes.
> > > 
> > > Basically, once we give in to synchronize_rcu() we're basically giving
> > > up. That's certainly a very good tradeoff for something like filesystem
> > > unregistration or module unload, it buys big simplifications in real
> > > fastpaths. But I just don't think it should be taken lightly.
> > 
> > Makes sense to me!
> > 
> > BTW, on your earlier usage classification:
> > 
> > > I think synchronize_rcu should firstly not be used unless it gives a good
> > > simplification, or speedup in fastpath.
> > >
> > > When that is satified, then it is a question of exactly what kind of slow
> > > path it should be used in. I don't think it should be used in process-
> > > synchronous code (eg syscalls) except for error cases, resource
> > > exhaustion, management syscalls (like module unload).
> > 
> > I don't have any feedback either way on your guidance to where
> > synchronize_rcu() should be used, as I believe that it depends a lot
> > on the details of usage, and would vary from one part of the kernel
> > to another, and possibly also over time.
> > 
> 
> Sometime, a mixture of call_rcu() and synchronize_rcu() is used, to have
> a limit on pending callbacks (eating too much memory)
> 
> net/ipv4/fib_trie.c for example issues call_rcu() most of the time, but
> is able to trigger one synchronize_rcu() if more than XXX (128) pages of
> memory were queued in rcu queues.
> 
> For details, check commit c3059477fce2d956
> (ipv4: Use synchronize_rcu() during trie_rebalance())

Good point!

							Thanx, Paul
