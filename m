Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0C3KIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:08:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51595 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab0C3KIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:08:20 -0400
Date: Tue, 30 Mar 2010 02:32:04 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, abogani@texware.it,
       menage@google.com, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
Message-ID: <20100330093204.GP3345@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Mar 29, 2010 at 11:42:55PM +0200, Peter Zijlstra wrote:
> > On Mon, 2010-03-29 at 14:34 -0700, Paul E. McKenney wrote:
> >
> > > And it appears that my patch is at best insufficient:
> > > http://paste.ubuntu.com/406189/
> > >
> > > Left to myself, I would wrap copy_process() with rcu_read_lock(),
> > > but I would rather hear your thoughts before doing too much more
> > > semi-random hacking.  ;-)
> >
> > Well, I don't think you can get away with that, copy_process() wants to
> > sleep on quite a few places ;-) Also, locks should be taken at the
> > smallest possible scope, unless we want to go back to BKL style
> > locking :-)
> 
> No argument here!  ;-)
> 
> > As to that freezer splat, you'd have to chase down the cgroup folks, I'm
> > fully ignorant on that.
> 
> K, adding them to CC.  The two splats are:
> 
>        http://pastebin.ubuntu.com/406131/
>         http://paste.ubuntu.com/406189/

Please feel free to Cc me on cgroup freezer stuff.

There's a comment in the code explaining why it's not used in freezer_fork():

       /*
        * No lock is needed, since the task isn't on tasklist yet,
        * so it can't be moved to another cgroup, which means the
        * freezer won't be removed and will be valid during this
        * function call.
        */
	freezer = task_freezer(task);

Cheers,
	-Matt Helsley
