Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1JAFlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 01:41:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39712 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751227Ab1JAFlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 01:41:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+vMm9MzZCvEkCtGnrZl7awaoPqH9/SqAHdpsOiXy
	tjJG9xF4XMtQ8D
Subject: Re: [Priority Inheritance] SCHED_FIFO or SCHED_RR?
From: Mike Galbraith <efault@gmx.de>
To: "Tadeus (Eus) Prastowo" <0x657573@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAOVSwNHoNuNBsuUecZhF0iWOL3PbJQt0cHR7Evf+gW6Q6SGA7Q@mail.gmail.com>
References: <CAOVSwNFp=p3TmkfvB=BKq8b_jJVTywRspJSE3fhyKQaCfnzUvg@mail.gmail.com>
	 <CAOVSwNHoNuNBsuUecZhF0iWOL3PbJQt0cHR7Evf+gW6Q6SGA7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 07:41:09 +0200
Message-ID: <1317447669.6337.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 21:12 +0200, Tadeus (Eus) Prastowo wrote:
> Anyone familiar with the Linux scheduler, please?
> 
> On Wed, Sep 28, 2011 at 1:06 AM, Tadeus (Eus) Prastowo
> <0x657573@googlemail.com> wrote:
> > Hi!
> >
> > When a SCHED_RR task with RT priority X blocks on a
> > priority-inheriting mutex held by a SCHED_NORMAL task with nice value
> > Y, RT-Mutex code will change the SCHED_NORMAL task priority to that of
> > the SCHED_RR task and based on the new priority, will change the
> > scheduling class too. But, each task retains its own scheduling
> > policy.
> >
> > This means that the task inheriting the SCHED_RR priority will be
> > scheduled using SCHED_FIFO policy because task_tick_rt does not
> > enforce the SCHED_RR time slice when the task policy is not SCHED_RR.
> >
> > Why should a SCHED_NORMAL task inheriting the priority of a SCHED_RR
> > task get the privilege of SCHED_FIFO task for running as long as it
> > wishes even when the task giving the inheritance does not have such
> > privilege?

Existence of a critical section > slice would be the real problem, no?

	-Mike

