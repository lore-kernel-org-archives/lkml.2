Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0KKOGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:06:02 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46646 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab0KKOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W7106xTJwsEx25NA7CJ8tlv1iHYAT7ysV2CC7tTlgXdzpEwGhI1cR7+h07YASy3p3O
         saSNuMhFZTF7ELzlLpZBi7Jz44htmxzD3X9ZIxhBOTl+TYOF7TG2Kh1QVRStaOAdBNMW
         aLEPVtJzQQxKh+tDe1/tiJI4ULMe2mtiKPqNs=
Date: Thu, 11 Nov 2010 15:05:51 +0100
From: Dhaval Giani <dhaval@retis.sssup.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
Message-ID: <20101111140551.GA26238@gondor.retis>
References: <1288333128.8661.137.camel@Palantir>
 <1288333622.8661.141.camel@Palantir>
 <1289410114.2084.23.camel@laptop>
 <1289427476.13577.285.camel@Palantir>
 <1289482333.2084.102.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289482333.2084.102.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 02:32:13PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 23:17 +0100, Raistlin wrote:
> > On Wed, 2010-11-10 at 18:28 +0100, Peter Zijlstra wrote:
> > > On Fri, 2010-10-29 at 08:27 +0200, Raistlin wrote:
> > > > +struct sched_param_ex {
> > > > +       int sched_priority;
> > > > +       struct timespec sched_runtime;
> > > > +       struct timespec sched_deadline;
> > > > +       struct timespec sched_period;
> > > > +       unsigned int sched_flags;
> > > > +
> > > > +       struct timespec curr_runtime;
> > > > +       struct timespec used_runtime;
> > > > +       struct timespec curr_deadline;
> > > > +}; 
> > > 
> > > It would be better for alignment reasons to move the sched_flags field
> > > next to the sched_priority field.
> > > 
> > Makes sense, thanks. :-)
> > 
> > > I would suggest we add at least one more field so we can implement the
> > > stochastic model from UNC, sched_runtime_dev or sched_runtime_var or
> > > somesuch.
> > > 
> > Ok, no problem with that too.
> > 
> > BTW, as Dhaval was suggesting, are (after those changes) fine with this
> > new sched_param? Do we need some further mechanism to grant its
> > extendability?
> > Padding?
> > Versioning?
> > void *data field?
> > Whatever?
> > 
> > :-O
> > 
> > I'd like very much to have some discussion here, if you think it is
> > needed, in hope of avoiding future ABI issues as much as possible! :-P
> 
> Right, so you mentioned doing s/_ex/2/ on all this stuff, which brings
> it more in line with that other syscalls have done.
> 
> The last three parameters look to be output only as I've not yet found
> code that reads it, and __getparam_dl() doesn't even appear to set
> used_runtime.
> 

So, do you think its a good idea moving this information to schedstats?
It seems more in line for monitoring, which schedstat seems a more
appropriate destination.

thanks,
Dhaval
