Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0KMWa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:30:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61599 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab0KMWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aL/zKPN1kXemLO+QjU1PAWyO0HSdOpNX7K9swWyze/fDb6yUiwrdbEPXVAHsaAlhyd
         R0DNnp7tIXw0iW5oHd4e/nOSW0LvVrS9q6Yh9PHpe9tLwJ/GnkPf8HNO1vXtoimth0hy
         Vdfygl313iyiFniVzcSBVbLo2eWYZi5oZxtqw=
Date: Sat, 13 Nov 2010 23:30:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Joe Korty <joe.korty@ccur.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        houston.jim@comcast.net
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101113223046.GB5445@nowhere>
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105210059.GA27317@tsunami.ccur.com> <4CD912E9.1080907@cn.fujitsu.com> <20101110155419.GC5750@nowhere> <1289410271.2084.25.camel@laptop> <20101111041920.GD3134@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111041920.GD3134@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 08:19:20PM -0800, Paul E. McKenney wrote:
> On Wed, Nov 10, 2010 at 06:31:11PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-11-10 at 16:54 +0100, Frederic Weisbecker wrote:
> > > run the sched tick and if there was nothing to do
> > > for some time and we are in userspace, deactivate it. 
> > 
> > Not for some time, immediately, have the tick track if it was useful, if
> > it was not, have it stop itself, like:
> > 
> > tick()
> > {
> >  int stop = 1;
> > 
> >  if (nr_running > 1)
> >   stop = 0;
> > 
> >  if(rcu_needs_cpu())
> >   stop = 0;
> > 
> >  ...
> > 
> > 
> >  if (stop)
> >   enter_nohz_mode();
> > }
> 
> I am still holding out for a dyntick-hpc version of RCU that does not
> need the tick.  ;-)


So you don't think it would be an appropriate solution? Keeping the tick for short
periods of time while we need it only, that looks quite a good way to try.

Hmm?

