Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0KYN2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:28:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab0KYN2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:28:54 -0500
Date: Thu, 25 Nov 2010 14:21:55 +0100
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
Subject: Re: [patch 3/4] taskstats: Introduce cdata_acct for complete
	cumulative accounting
Message-ID: <20101125132155.GA25836@redhat.com>
References: <20101119201108.269346583@linux.vnet.ibm.com> <20101119201144.542948128@linux.vnet.ibm.com> <20101123165951.GA5938@redhat.com> <1290678022.1941.29.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290678022.1941.29.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Michael Holzheu wrote:
>
> Hello Oleg,
>
> On Tue, 2010-11-23 at 17:59 +0100, Oleg Nesterov wrote:
> > On 11/19, Michael Holzheu wrote:
> > > TODO:
> > > -----
> > > With this patch we take the siglock twice. First for the dead task
> > > and second for the parent of the dead task. This give the following
> > > lockdep warning (probably a lockdep annotation is needed here):
> >
> > And we already discussed this ;) We do not need 2 siglock's, only
> > parent's. Just move the callsite in __exit_signal() down, under
> > another (lockless) group_dead check.
> >
> > Or I missed something?
>
> The problem with moving this down to the second group_dead check is that
> after __unhash_process() is called, pid_alive(tsk) which is checked in
> thread_group_cputime() returns false. Therefore we always get zero CPU
> times.

I see, thanks.

> So I probably have to introduce a second group_dead check at the
> beginning of __exit_signal():

Probably...

But in fact this reminds we should cleanup this code somehow.
By the time we call thread_group_times() there are no other
threads.

> My personal feeling is that probably the only acceptable thing would be
> to make the new behavior configurable with a sysctl and define the
> default as it currently is (POSIX compliant).
>
> This would only introduce two additional checks in __exit_signal() and
> wait_task_zombie() and would not add any new fields to the
> signal_struct.

Yeah, it would be nice to avoid new fields.


Hmm. Somehow I forgot about 4/4, please see another email...

Oleg.

