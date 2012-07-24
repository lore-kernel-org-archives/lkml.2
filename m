Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2GXIcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:32:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:54333 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755763Ab2GXIcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:32:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX187e2JO2xs7e4qF3XqgmSoaK9MvIlRdibZrxuV/hq
	dV59XhIkM/Rgv2
Message-ID: <1343118731.7412.72.camel@marge.simpson.net>
Subject: Re: [MMTests] Sysbench read-only on ext3
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Jul 2012 10:32:11 +0200
In-Reply-To: <20120724081903.GL9222@suse.de>
References: <20120620113252.GE4011@suse.de> <20120629111932.GA14154@suse.de>
	 <20120723211334.GA9222@suse.de>
	 <1343096969.7412.21.camel@marge.simpson.net>
	 <20120724081903.GL9222@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 09:19 +0100, Mel Gorman wrote: 
> On Tue, Jul 24, 2012 at 04:29:29AM +0200, Mike Galbraith wrote:
> > On Mon, 2012-07-23 at 22:13 +0100, Mel Gorman wrote:
> > 
> > > The backing database was postgres.
> > 
> > FWIW, that wouldn't have been my choice.  I don't know if it still does,
> > but it used to use userland spinlocks to achieve scalability. 
> 
> The tests used to support mysql but the code bit-rotted and eventually
> got deleted. I'm not going to get into a mysql vs postgres discussion on
> which is better :O
> 
> Were you thinking of mysql or something else as an alternative?
> Completely different test?

Which db is under the hood doesn't matter much, but those spinlocks got
me thinking.

> > Turning
> > your CPUs into space heaters to combat concurrency issues makes a pretty
> > flat graph, but probably doesn't test kernels as well as something that
> > did not do that.
> > 
> 
> I did not check the source, but even if it is true then your comments only
> applies to testing scalability of locking. If someone really cares to check,
> the postgres version was 9.0.4. However, even if they are using user-space
> locking, the test is still useful for looking at the IO performance,
> page reclaim decisions and so on.

I was thinking while you're spinning in userspace, you're not giving the
kernel decisions to make.  But you're right.  If they didn't have
spinning locks, they'd have sleeping locks.  With spinning locks they
can be less smart I suppose.

-Mike


