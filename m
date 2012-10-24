Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935143Ab2JXPKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935093Ab2JXPKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:10:18 -0400
Date: Wed, 24 Oct 2012 17:11:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
Message-ID: <20121024151100.GA16793@redhat.com>
References: <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com> <20121023165912.GA18712@redhat.com> <20121023192318.GA25872@redhat.com> <1351025831.13456.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351025831.13456.43.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Peter Zijlstra wrote:
>
> On Tue, 2012-10-23 at 21:23 +0200, Oleg Nesterov wrote:
> >
> >         static void mb_ipi(void *arg)
> >         {
> >                 smp_mb(); /* unneeded ? */
> >         }
> >
> >         static void force_mb_on_each_cpu(void)
> >         {
> >                 smp_mb();
> >                 smp_call_function(mb_ipi, NULL, 1);
> >         }
>
> You know we're spending an awful lot of time and effort to get rid of
> such things, right? RT and HPC people absolutely hate these random IPI
> things.

No I do not know ;) but I am not suprized.

And,

> > I have to admit, I have
> > no idea how much cli/sti is slower compared to preempt_disable/enable.
> >
> A lot.. esp on stupid hardware (insert pentium-4 reference), but I think
> its more expensive for pretty much all hardware,

Thanks Peter, this alone answers my question.

Oleg.

