Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab2FKJ0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:26:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:37433 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2FKJ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:26:33 -0400
Date: Mon, 11 Jun 2012 11:26:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Peter Zijlstra <peterz@infradead.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] kthread: Implement park/unpark facility
In-Reply-To: <878vfviv1h.fsf@rustcorp.com.au>
Message-ID: <alpine.LFD.2.02.1206111124110.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au> <alpine.LFD.2.02.1206051135260.3086@ionos> <alpine.LFD.2.02.1206051538280.3086@ionos>
 <878vfviv1h.fsf@rustcorp.com.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2012, Rusty Russell wrote:

> On Tue, 5 Jun 2012 15:41:48 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> > Subject: kthread: Implement park/unpark facility
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Wed, 18 Apr 2012 16:37:40 +0200
> > 
> > To avoid the full teardown/setup of per cpu kthreads in the case of
> > cpu hot(un)plug, provide a facility which allows to put the kthread
> > into a park position and unpark it when the cpu comes online again.
> 
> Like the idea, but the API is awkward.  Now you've made returning from a
> thread do different things depending on whether it was parked or not.
> 
> How about just have the thread call "kthread_parkme()" which only
> returns if/when the thread is unparked?
> 
> So the thread does:
> 
>         while (!kthread_should_stop()) {
>                 if (kthread_should_park()) {
>                         ... cleanup ...
>                         kthread_parkme();
>                         ... restore ...
>                 }
>                 ... work ...
>         }
> 
> Threads which never exit have "for (;;)" instead of while
> (!kthread_should_stop()).

Makes sense. Will have a go on that.

One other thing what I'm thinking about is to avoid the synchronous
parking mechanism, i.e. just tell the thread to park and check the
park state later before going further down.

Thanks,

	tglx
