Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1FGKUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:20:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37782 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750990Ab1FGKUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:20:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/2lrV7FLb20hdg3s1U2Sj8xdSfY78xNOo7re56y2
	TZiHIxeSZ6/7yf
Subject: Re: [PATCH] sched: remove redundant check in select_task_rq_fair
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <1307441361.2322.239.camel@twins>
References: <20110607094821.29969.50197.stgit@IBM-009124035060.in.ibm.com>
	 <1307440414.2322.236.camel@twins>
	 <m3hb82aren.fsf@IBM-009124035060.in.ibm.com>
	 <1307441361.2322.239.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 12:20:43 +0200
Message-ID: <1307442043.3625.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 12:09 +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 15:34 +0530, Nikunj A. Dadhania wrote:
> > On Tue, 07 Jun 2011 11:53:34 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, 2011-06-07 at 15:18 +0530, Nikunj A. Dadhania wrote:
> > > > When balancing for wakeup affinity, a redundant check can removed.
> > > 
> > > Yes, tempting, but no, now you've got an extra call to wake_affine(),
> > > which is more expensive.
> 
> > Ah, got that. How about this, it is more readable. Other options would
> > be to add a comment.
> 
> > -		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> > +		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
> >  			prev_cpu = cpu;
> 
> I guess that depends on which way your head is wired and how strong your
> boolean algebra is.. Suresh, Mike any preference? I don't much care
> either way.

Me either.

	-Mike


