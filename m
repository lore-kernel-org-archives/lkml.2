Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1AEJxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:53:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:55025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1AEJxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:53:08 -0500
Subject: Re: [RFC][PATCH 05/18] sched: Provide p->on_rq
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <AANLkTinmKHSPbrR5Z3_wD52RQRXfZHPSH+b9n2CNPZ8K@mail.gmail.com>
References: <20110104145929.772813816@chello.nl>
	 <20110104150102.562967001@chello.nl>
	 <AANLkTinmKHSPbrR5Z3_wD52RQRXfZHPSH+b9n2CNPZ8K@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 10:53:21 +0100
Message-ID: <1294221201.2016.209.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 16:13 +0800, Yong Zhang wrote:
> > +       if (p->on_rq && p->rt.nr_cpus_allowed > 1)
> 
> How about on_rt_rq(&p->rt) here?
> 
> Quoted from my previous reply:
> [Seems we need on_rt_rq(&p->rt) here, otherwise we enqueue the
> task to pushable list when called from rt_mutex_setprio()/
> __sched_setscheduler() etc. Thus add a little overhead.
> Though we call dequeue_pushable_task() in set_curr_task_rt()
> unconditionally.] 

Ah, sorry for loosing that reply..

Yes I think that would work, Steven?
