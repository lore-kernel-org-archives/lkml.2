Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2DXKLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:11:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:41352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab2DXKLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:11:08 -0400
Message-ID: <1335262248.28150.191.camel@twins>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Date: Tue, 24 Apr 2012 12:10:48 +0200
In-Reply-To: <1335231007.14538.71.camel@ymzhang.sh.intel.com>
References: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
	 <1334915073.2463.36.camel@laptop>
	 <1335231007.14538.71.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 09:30 +0800, Yanmin Zhang wrote:
> > > +static inline void __save_stack_trace_user_task(struct task_struct *task,
> > > +           struct stack_trace *trace)
> > > +{
> > > +   const struct pt_regs *regs = task_pt_regs(task);
> > > +   const void __user *fp;
> > > +   unsigned long addr;
> > > +
> > > +   if (task != current && task->state == TASK_RUNNING && task->on_cpu) {
> > > +           /* To trap into kernel at least once */
> > > +           smp_send_reschedule(task_cpu(task));
> > > +   }
> > 
> > This doesn't make any sense at all..
> ptrace could put the task to a either STOPPED or TRACED state.
> But it's time-consuming. 

Yeah, but what is the above meant to achieve? it doesn't actually stop
the task or anything, it will just trap the remote cpu, by the time you
do your stack walk below the cpu might be running another task entirely
or you're walking a life stack with all the 'fun' issues that'll bring.


