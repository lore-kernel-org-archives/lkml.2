Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1CWClw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 22:41:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47975 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752743Ab1CWClv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 22:41:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bocFNBiPbtQCgnjKCxLWgjlXDM0SycqIGSu3KuI
	AlsecX0DWyU6cT
Subject: Re: [PATCH 3/5] oom: create oom autogroup
From: Mike Galbraith <efault@gmx.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
In-Reply-To: <20110323102738.1AC2.A69D9226@jp.fujitsu.com>
References: <20110322200759.B067.A69D9226@jp.fujitsu.com>
	 <AANLkTikN835dfU9xozTWbOh6cjSEG0XgU_Ayn+dRqDug@mail.gmail.com>
	 <20110323102738.1AC2.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 03:41:39 +0100
Message-ID: <1300848099.7492.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 10:27 +0900, KOSAKI Motohiro wrote:
> > On Tue, Mar 22, 2011 at 8:08 PM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > When plenty processes (eg fork bomb) are running, the TIF_MEMDIE task
> > > never exit, at least, human feel it's never. therefore kernel become
> > > hang-up.
> > >
> > > "perf sched" tell us a hint.
> > >
> > >  ------------------------------------------------------------------------------
> > >  Task                  |   Runtime ms  | Average delay ms | Maximum delay ms |
> > >  ------------------------------------------------------------------------------
> > >  python:1754           |      0.197 ms | avg: 1731.727 ms | max: 3433.805 ms |
> > >  python:1843           |      0.489 ms | avg: 1707.433 ms | max: 3622.955 ms |
> > >  python:1715           |      0.220 ms | avg: 1707.125 ms | max: 3623.246 ms |
> > >  python:1818           |      2.127 ms | avg: 1527.331 ms | max: 3622.553 ms |
> > >  ...
> > >  ...
> > >
> > > Processes flood makes crazy scheduler delay. and then the victim process
> > > can't run enough. Grr. Should we do?
> > >
> > > Fortunately, we already have anti process flood framework, autogroup!
> > > This patch reuse this framework and avoid kernel live lock.
> > 
> > That's cool idea but I have a concern.
> > 
> > You remove boosting priority in [2/5] and move victim tasks into autogroup.
> > If I understand autogroup right, victim process and threads in the
> > process take less schedule chance than now.
> 
> Right. Icky cpu-cgroup rt-runtime default enforce me to seek another solution.

I was going to mention rt, and there's s/fork/clone as well.

> Today, I got private mail from Luis and he seems to have another improvement
> idea. so, I might drop this patch if his one works fine.

Perhaps if TIF_MEMDIE threads needs special treatment, preemption tests
could take that into account?  (though I don't like touching fast path
for oddball cases)

	-Mike





