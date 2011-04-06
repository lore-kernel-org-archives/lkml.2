Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1DFHBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:01:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48492 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753394Ab1DFHBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:01:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+R3LVAGyOR2OTmgxbX22Kd5c6OS12J7kShaN18f/
	RZIiNgtwwCl14T
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
From: Mike Galbraith <efault@gmx.de>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Rik van Riel <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <1302070509.15889.7351.camel@debian>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
	 <4D9BF512.6080309@redhat.com>  <1302070509.15889.7351.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 09:01:29 +0200
Message-ID: <1302073289.21156.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 14:15 +0800, Alex,Shi wrote:
> On Wed, 2011-04-06 at 13:07 +0800, Rik van Riel wrote:
> > On 04/05/2011 06:33 PM, Alex Shi wrote:
> > > commit ac53db596cc08ecb8040c removed the sched_yield task running
> > > time increase, so the yielded task get more opportunity to be launch
> > > again. That may not the caller want to be. And this also causes
> > > volano benchmark drop 50~80 percent performance on core2/NHM/WSM
> > > machines. This patch recover the sched_yield task vruntime up.
> > >
> > > Signed-off-by: alex.shi@intel.com
> > 
> > NACK
> > 
> > This was switched off by default and under
> > the sysctl sched_compat_yield for a reason.
> > 
> > Reintroducing it under that sysctl option
> > may be acceptable, but by default it would
> > be doing the wrong thing for other workloads.
> 
> I can implement this as sysctl option. But when I checked again the man
> page of sched_yield. I have some concerns on this. 
> 
> ----
>        int sched_yield(void);
> 
> DESCRIPTION
>        A  process  can  relinquish  the processor voluntarily without blocking by calling sched_yield().
>        The process will then be moved to the end of the queue for its static priority and a new  process
>        gets to run.
> ----
> 
> If a application calls sched_yield system call, most of time it is not
> want to be launched again right now. so the man page said "the caller
> process will then be moved to the _end_ of the queue..."

Moving a yielding nice 0 task behind a SCHED_IDLE (or nice 19) task
could be incredibly painful.

	-Mike

