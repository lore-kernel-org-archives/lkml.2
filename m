Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1EXEOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:14:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43308 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1EXEOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:14:47 -0400
Date: Mon, 23 May 2011 21:14:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110524041443.GA2329@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306189249.15900.10.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306189249.15900.10.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:20:40AM +0200, Paul Bolle wrote:
> On Mon, 2011-05-23 at 08:38 -0700, Paul E. McKenney wrote:
> > Running under CONFIG_PREEMPT=y (along with CONFIG_TREE_PREEMPT_RCU=y)
> > could be very helpful in and of itself.  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> > can also be helpful.  In post-2.6.39 mainline, it should be possible
> > to set CONFIG_DEBUG_OBJECTS_RCU_HEAD=y without CONFIG_PREEMPT=y, but
> > again, CONFIG_PREEMPT=y can help find problems.
> 
> 0) The first thing I tried (from your suggestions) was
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y. Given its dependencies (and, well, the
> build system I used) I ended up with:
> 
>     $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local3.fc16.i686 |
>     grep -v "^#"
>     CONFIG_TREE_PREEMPT_RCU=y
>     CONFIG_PREEMPT_RCU=y
>     CONFIG_RCU_FANOUT=32
>     CONFIG_PREEMPT_NOTIFIERS=y
>     CONFIG_PREEMPT=y
>     CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
>     CONFIG_DEBUG_PREEMPT=y
>     CONFIG_PROVE_RCU=y
>     CONFIG_SPARSE_RCU_POINTER=y
> 
> It looks like I am unable to trigger the issue we're talking about here
> when using that config.

Interesting.  One way for this to happen is to block inside an RCU
read-side critical section.  I need to think about appropriate
diagnostics for this.

> 1) For reference, the config of a kernel that does trigger it had:
> 
>     $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local2.fc16.i686 |
>     grep -v "^#"
>     CONFIG_TREE_RCU=y
>     CONFIG_RCU_FANOUT=32
>     CONFIG_RCU_FAST_NO_HZ=y
>     CONFIG_PREEMPT_NOTIFIERS=y
>     CONFIG_PREEMPT_VOLUNTARY=y
>     CONFIG_PROVE_RCU=y
>     CONFIG_SPARSE_RCU_POINTER=y
> 
> > > Again CONFIG_TREE_PREEMPT_RCU is available only if PREEMPT=y. So should
> > > we enable preemtion and CONFIG_TREE_PREEMPT_RCU=y and try to reproduce
> > > the issue?
> > 
> > Please!
> 
> 2) It appears I can't reproduce with those options enabled (see above).
> 
> > Polling is fine.  Please see attached for a script to poll at 15-second
> > intervals.  Please also feel free to adjust, just tell me what you
> > adjusted.
> 
> And should I now try to run that script on a config that triggers this
> issue (such as the config under 1) above)?

It might help while I am working out more targetted diagnostics.

							Thanx, Paul
