Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1DGCoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:44:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50939 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751012Ab1DGCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:44:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ke6EV5Nikh8B0IkaC3sr3yVmyrfGO40Ly1ouDRu
	P0M34zWsLbdZHN
Subject: RE: [PATCH] sched: recover sched_yield task running time increase
From: Mike Galbraith <efault@gmx.de>
To: "Shi, Alex" <alex.shi@intel.com>
Cc: Rik van Riel <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B4BBA01D83D@shsmsx502.ccr.corp.intel.com>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
	 <4D9BF512.6080309@redhat.com>  <1302070509.15889.7351.camel@debian>
	 <1302073289.21156.17.camel@marge.simson.net>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B4BBA01D83D@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 04:44:30 +0200
Message-ID: <1302144270.7441.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 21:28 +0800, Shi, Alex wrote:
> >> > NACK
> >> >
> >> > This was switched off by default and under
> >> > the sysctl sched_compat_yield for a reason.
> >> >
> >> > Reintroducing it under that sysctl option
> >> > may be acceptable, but by default it would
> >> > be doing the wrong thing for other workloads.
> >>
> >> I can implement this as sysctl option. But when I checked again the man
> >> page of sched_yield. I have some concerns on this.
> >>
> >> ----
> >>        int sched_yield(void);
> >>
> >> DESCRIPTION
> >>        A  process  can  relinquish  the processor voluntarily without blocking by calling sched_yield().
> >>        The process will then be moved to the end of the queue for its static priority and a new  process
> >>        gets to run.
> >> ----
> >>
> >> If a application calls sched_yield system call, most of time it is not
> >> want to be launched again right now. so the man page said "the caller
> >> process will then be moved to the _end_ of the queue..."
> >
> >Moving a yielding nice 0 task behind a SCHED_IDLE (or nice 19) task
> >could be incredibly painful.
> 
> Good reminder! Do you have more detailed idea on this?

Other than 'don't do that'?  Nope.  sched_yield() semantics suck.

	-Mike

