Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0K2Q6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:58:50 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:38835 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0K2Q6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:58:49 -0500
Subject: Re: [patch 4/4] taskstats: Export "cdata_acct" with taskstats
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
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
In-Reply-To: <20101129164329.GA16648@redhat.com>
References: <20101119201108.269346583@linux.vnet.ibm.com>
	 <20101119201144.871656307@linux.vnet.ibm.com>
	 <20101125132639.GB25836@redhat.com>
	 <1290705675.1941.73.camel@holzheu-laptop>
	 <20101129164329.GA16648@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 29 Nov 2010 17:58:37 +0100
Message-ID: <1291049917.1935.14.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Mon, 2010-11-29 at 17:43 +0100, Oleg Nesterov wrote:
> > I just did it like it is done in e.g. fs/proc/base.c (proc_pid_limits).
> > Can we remove the locking there, too?
> 
> We can certainly remove more siglock's which were previously
> needed to access ->signal.
> 
> This particular one is just wrong. We need task_lock(group_leader)
> to read signal->rlim atomically. However, it is not trivial to do
> this correctly. Probably we should ignore this minor problem.
> 
> In any case, this ->siglock buys nothing today.

But at least to get the two values cutime and cstime consistent we need
the siglock? There could be a parallel update for
tsk->signal->cutime/cstime, while the taskstats are created, no?

Michael

