Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2LJSV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:21:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2LJSVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:21:24 -0500
Date: Mon, 10 Dec 2012 19:21:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tj@kernel.org,
        tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"
	atomic readers to prevent CPU offline
Message-ID: <20121210182115.GA30892@redhat.com>
References: <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com> <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com> <50BF999C.6030707@linux.vnet.ibm.com> <50BFAB17.3090603@linux.vnet.ibm.com> <20121206161850.GA6710@redhat.com> <50C0E88E.9050909@linux.vnet.ibm.com> <1354822103.17101.24.camel@gandalf.local.home> <20121207200014.GB13238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207200014.GB13238@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07, Oleg Nesterov wrote:
>
> On 12/06, Steven Rostedt wrote:
> >
> > You know reader locks can deadlock with each other, right? And this
> > isn't caught be lockdep yet. This is because rwlocks have been made to
> > be fair with writers. Before writers could be starved if a CPU always
> > let a reader in. Now if a writer is waiting, a reader will block behind
> > the writer. But this has introduced new issues with the kernel as
> > follows:
> >
> >
> >    CPU0			   CPU1	 	   CPU2		   CPU3
> >    ----			   ----		   ----		   ----
> > read_lock(A);
> > 			read_lock(B)
> > 					write_lock(A) <- block
> > 							write_lock(B) <- block
> > read_lock(B) <-block
> >
> > 			read_lock(A) <- block
> >
> > DEADLOCK!
>
> Really??? Oh I didn't know...
>
> Yes this was always true for rwsem, but rwlock_t?

Sorry, please ignore my email. I misread your email.

Oleg.

