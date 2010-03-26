Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0CZTKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:10:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:48924 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753229Ab0CZTKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:10:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+showiblis/mIt30hF51PehG75fEvrY50g5ED1gQ
	NEEcbSrfn4bb/W
Subject: Re: [BUG] perf: hard lockup when using perf-sched
From: Mike Galbraith <efault@gmx.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100326172350.GC5188@nowhere>
References: <4BA082EC.8030101@cn.fujitsu.com>
	 <4BA9A885.9050105@cn.fujitsu.com>
	 <1269415964.6530.25.camel@marge.simson.net>
	 <1269418671.6465.6.camel@marge.simson.net>
	 <4BAB1924.4060304@cn.fujitsu.com>
	 <1269509241.8438.30.camel@marge.simson.net>
	 <1269598293.6174.8.camel@marge.simson.net>  <20100326172350.GC5188@nowhere>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 20:10:40 +0100
Message-Id: <1269630640.6331.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 18:23 +0100, Frederic Weisbecker wrote:
> On Fri, Mar 26, 2010 at 11:11:33AM +0100, Mike Galbraith wrote:

> > perf: fix perf sched record forkbomb deadlock
> > 
> > perf sched record can deadlock a box should the holder of handle->data->lock
> > take an interrupt, and then attempt to acquire an rq lock held by a CPU trying
> > to acquire the same lock.  Disable interrupts.
> 
> 
> 
> Aah.
> 
> So the scenario is the following inversion?
> 
> 	CPU0				CPU1
> sched event with rq->lock held
> 				grab handle->data->lock
> spin on handle->data->lock
> 				interrupt
> 				try to grab rq->lock

Yeah, handle->data->lock holder dare not try to grab any rq lock because
of sched event with rq->lock held.

	-Mike

