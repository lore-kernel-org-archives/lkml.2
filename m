Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0DFJpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:45:08 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:33467 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0DFJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eV9+A1dvxXCoebdx90CjYOP8FUDFOcp0Ed0dv9CAuibfjPi3AX9AMscE5bP4pyLaqo
         tGtdo9Jin57OnJMwR49hyk8B1EfAkFE1QlBQEESyLKUIi3cfkOpW4uXE1Cfpxz1YlMMd
         Mhn1RQf22NQT7twOFjhsL4T8eOCIRUQ118Jrc=
Date: Tue, 6 Apr 2010 11:44:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       tglx@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] Separate lock events with types
Message-ID: <20100406094451.GC5147@nowhere>
References: <20100129221252.GA5052@nowhere> <1267002166-7281-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100326233259.GI7166@nowhere> <1270542366.1597.720.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270542366.1597.720.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:26:06AM +0200, Peter Zijlstra wrote:
> On Sat, 2010-03-27 at 00:33 +0100, Frederic Weisbecker wrote:
> > So if we store the lock type in the lockdep_map, we can just dump
> > the type on lock class initialization:
> > 
> > - on register_lock_class
> > - on event injection to catchup with lock that have already registered
> > 
> > That's what does my tree perf/inject (minus the lock type), but this
> > all require a redesign, in both ftrace and perf sides.
> > 
> 
> Right, and I don't like to bloat dep_map for no reason. I still think
> all this lock type stuff is a waste of time.


Again, it makes no sense to mix up reports of spinlocks, rwlocks, mutexes
or whatever together in the same latency report.

I agree with you that such report makes no sense if you don't look at
the code and then find the nature of the locks on the deeper overview.

But the first overview is going to be unhelpful at best if you have
everything in the same linear report.

You'll naturally find the mutexes first reporting the worst latencies,
then rwsem, then the spinlocks, then the read rwlocks (read) at the end
of the list (depending on the cases).

And yet their latency intervals have utter different meanings. You can't
provide a taste report that mixes beers and wines qualities based on the
same magnitudes.

I really believe perf lock is going to suck at best without this.


