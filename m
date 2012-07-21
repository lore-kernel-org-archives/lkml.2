Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2GUHr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:47:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45848 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750939Ab2GUHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:47:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+h3nA0kI2hhqqufToWin+0QSovbCr5F6lWJTzux2
	ycB3sI6g//OIpF
Message-ID: <1342856835.7739.19.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com, Steven Rostedt <rostedt@goodmis.org>
Date: Sat, 21 Jul 2012 09:47:15 +0200
In-Reply-To: <1342589411.7321.59.camel@marge.simpson.net>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	 <alpine.LFD.2.02.1207151057010.32033@ionos>
	 <1342343673.28142.2.camel@marge.simpson.net>
	 <1342405366.7659.35.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161058550.32033@ionos>
	 <1342432094.7659.39.camel@marge.simpson.net>
	 <1342433303.7659.42.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161216200.32033@ionos>
	 <1342530621.7353.116.camel@marge.simpson.net>
	 <1342586692.7321.45.camel@marge.simpson.net>
	 <1342589411.7321.59.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 07:30 +0200, Mike Galbraith wrote: 
> On Wed, 2012-07-18 at 06:44 +0200, Mike Galbraith wrote:
> 
> > The patch in question for missing Cc.  Maybe should be only mutex, but I
> > see no reason why IO dependency can only possibly exist for mutexes...
> 
> Well that was easy, box quickly said "nope, mutex only does NOT cut it".

And I also learned (ouch) that both doesn't cut it either.  Ksoftirqd
(or sirq-blk) being nailed by q->lock in blk_done_softirq() is.. not
particularly wonderful.  As long as that doesn't happen, IO deadlock
doesn't happen, troublesome filesystems just work.  If it does happen
though, you've instantly got a problem.

-Mike

