Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0C3JfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:35:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:44982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0C3JfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:35:11 -0400
Subject: Re: scheduler bug: process running since 5124095h
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1269940324.19286.16.camel@marge.simson.net>
References: <4BADD408.8080609@gmail.com>  <4BAF1802.8070002@gmail.com>
	 <1269859960.6844.4.camel@marge.simson.net>
	 <4BB09736.5010009@jp.fujitsu.com>  <4BB1989D.4050809@jp.fujitsu.com>
	 <1269939704.5109.513.camel@twins>
	 <1269940324.19286.16.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Mar 2010 11:34:34 +0200
Message-ID: <1269941674.5109.514.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 11:12 +0200, Mike Galbraith wrote:
> On Tue, 2010-03-30 at 11:01 +0200, Peter Zijlstra wrote:
> > On Tue, 2010-03-30 at 15:22 +0900, Hidetoshi Seto wrote:
> > > 
> > > [kernel/sched_debug.c]
> > > void proc_sched_set_task(struct task_struct *p)
> > > {
> > >  :
> > >         p->se.sum_exec_runtime                  = 0;
> > >         p->se.prev_sum_exec_runtime             = 0;
> > >         p->nvcsw                                = 0;
> > >         p->nivcsw                               = 0;
> > > } 
> > 
> > Urgh, that code should really die, bugger that latencytop relies on that
> > though. Arjan anything you can do to cure latencytop of this madness?
> 
> I killed those 4 fields without _seeming_ to upset it.

OK, if Arjan doesn't complain I'll take it ;-)
