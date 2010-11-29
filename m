Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0K2SQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:16:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab0K2SQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:16:28 -0500
Date: Mon, 29 Nov 2010 19:08:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 4/4] taskstats: Export "cdata_acct" with taskstats
Message-ID: <20101129180854.GA21217@redhat.com>
References: <20101119201108.269346583@linux.vnet.ibm.com> <20101119201144.871656307@linux.vnet.ibm.com> <20101125132639.GB25836@redhat.com> <1290705675.1941.73.camel@holzheu-laptop> <20101129164329.GA16648@redhat.com> <1291049917.1935.14.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291049917.1935.14.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, Michael Holzheu wrote:
>
> Hello Oleg,
>
> On Mon, 2010-11-29 at 17:43 +0100, Oleg Nesterov wrote:
> > > I just did it like it is done in e.g. fs/proc/base.c (proc_pid_limits).
> > > Can we remove the locking there, too?
> >
> > We can certainly remove more siglock's which were previously
> > needed to access ->signal.
> >
> > This particular one is just wrong. We need task_lock(group_leader)
> > to read signal->rlim atomically. However, it is not trivial to do
> > this correctly. Probably we should ignore this minor problem.
> >
> > In any case, this ->siglock buys nothing today.
>
> But at least to get the two values cutime and cstime consistent we need
> the siglock? There could be a parallel update for
> tsk->signal->cutime/cstime, while the taskstats are created, no?

I guess you mean 4/4 you sent. Probably you are right, I'll try
to look tomorrow.

Oleg.

