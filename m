Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1BOO0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:26:52 -0500
Received: from www.tglx.de ([62.245.132.106]:57071 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1BOO0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:26:49 -0500
Date: Tue, 15 Feb 2011 15:19:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Kenneth Albanowski (Palm GBU)" <Kenneth.Albanowski@palm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: Question about clearing of tsk->robust_list in clone
In-Reply-To: <1297778450.2413.11.camel@twins>
Message-ID: <alpine.LFD.2.00.1102151509460.26192@localhost6.localdomain6>
References: <23C1F4DA0B73684F85AD25A73E4BB50315252BD7@ushqwmb09>  <alpine.LFD.2.00.1102151233330.26192@localhost6.localdomain6> <1297778450.2413.11.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Peter Zijlstra wrote:

> On Tue, 2011-02-15 at 14:16 +0100, Thomas Gleixner wrote:
> > 
> > And I do not buy the argument about "complex glibc code" at all. glibc
> > already handles it for pthread_create() so why the hell can't it
> > handle it for fork() ? 
> 
> Going by comment #9 they think calling sys_set_robust_list() on every
> fork() is too expensive for them, but realistically we cannot do
> anything about it, ->robust_list is strictly task state.

Right. 

Vs. too expensive: We already call set_robust_list() on every
pthread_create and on every process start when libpthread is
linked. So what makes fork() so special? Aside of that
set_robust_list() is hardly an expensive syscall.

> I also think their suggestion in comment #11 (lazy state) is flawed,
> what if the parent never users robust futexes, in that case the state
> will indicate not to initialize the robust state for its children, again
> leading to the observed wreckage.

Yup.
 
> Realistically libpthread should register an on_fork() callback to ensure
> the state is properly propagated.

Makes sense.

Thanks,

	tglx
