Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2HTFyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:54:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40766 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754133Ab2HTFyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:54:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ysndj/iIyfgHf5bYd1uTaTRDP6G4UYpVfKyLkn2
	WI+LexH8R2lxy/
Message-ID: <1345442050.25011.38.camel@marge.simpson.net>
Subject: Re: changing timeslice in linux
From: Mike Galbraith <efault@gmx.de>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 20 Aug 2012 07:54:10 +0200
In-Reply-To: <CALKntY0G6WBYT-MGbzQ-e6X_XyRENzeJww7FiLGAgiHtrfwQiA@mail.gmail.com>
References: <CALKntY0G6WBYT-MGbzQ-e6X_XyRENzeJww7FiLGAgiHtrfwQiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 11:58 -0700, Xin Tong wrote: 
> I have 2 questions about linux 2.6 x86_64 scheduler.
> 
> 1. is the default scheduling algorithm SCHED_NORMAL in linux ?

Yes.

> 2. how do i change the time slice in linux source code ?

You shouldn't need to.  You can tune "slice" by adjusting
sched_latency_ns and sched_min_granularity_ns, but note that "slice" is
not a fixed quantum.  Also note that CFS preemption decisions are based
upon instantaneous state.  A task may have received a full (variable)
"slice" of CPU time, but preemption will be triggered only if a more
deserving task is available, so a "slice" is not the "max uninterrupted
CPU time" that you may expect it to be.. but it is somewhat similar.

-Mike

