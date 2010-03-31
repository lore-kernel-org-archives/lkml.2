Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0CaPtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:49:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35787 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab0CaPtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:49:17 -0400
In-Reply-To: <1270044116.1616.26.camel@laptop>
References: <4B560ACD.4040206@linux.vnet.ibm.com>	 <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com>
	 <1269934931.8575.6.camel@minggr.sh.intel.com>	 <4BB22BB0.8030208@linux.vnet.ibm.com> <1269969305.5258.479.camel@laptop>
	 <4BB27764.2060802@linux.vnet.ibm.com> <1270044116.1616.26.camel@laptop>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
X-KeepSent: 10DAFDB7:4623FE5C-862576F7:00569322;
 type=4; name=$KeepSent
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, cel@linux.vnet.ibm.com,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Philip Mucci <mucci@eecs.utk.edu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Dan Terpstra <terpstra@eecs.utk.edu>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
X-Mailer: Lotus Notes Release 8.0.2 HF623 January 16, 2009
Message-ID: <OF10DAFDB7.4623FE5C-ON862576F7.00569322-862576F7.0056F0E4@us.ibm.com>
From: Maynard Johnson <mpjohn@us.ibm.com>
Date: Wed, 31 Mar 2010 10:49:07 -0500
X-MIMETrack: Serialize by Router on d27ml103/27/M/IBM(Release 8.5.1FP1|January 05, 2010) at
 03/31/2010 10:49:12 AM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote on 03/31/2010 09:01:56 AM:

> [image removed]
>
> Re: [RFC] perf_events: support for uncore a.k.a. nest units
>
> Peter Zijlstra
>
> to:
>
> Corey Ashford
>
> 03/31/2010 09:02 AM
>
> Cc:
>
> Lin Ming, Ingo Molnar, LKML, Andi Kleen, Paul Mackerras, Stephane
> Eranian, Frederic Weisbecker, Xiao Guangrong, Dan Terpstra, Philip
> Mucci, Maynard Johnson, cel, Steven Rostedt, Arnaldo Carvalho de
> Melo, Masami Hiramatsu
>
> On Tue, 2010-03-30 at 15:12 -0700, Corey Ashford wrote:
> >
> > > Initially I'd not allow per-pmu-per-task contexts
> > > because then things like perf_event_task_sched_out() would get rather
> > > complex.
> >
> > Definitely.  I don't think it makes sense to have per-task context on
> > nest/uncore PMUs.  At least we haven't found any justification for it.
>
> For uncore no, but there is also the hw-breakpoint stuff that is being
> presented as a pmu, for those it would make sense to have a separate
> per-task context.
hw-breakpoint presented as a pmu?  hmmmm.  IMHO, this is an example where
shoehorning something into the perf_events subsystem that logically doesn't
belong there just makes for more complexity in the code.
>
> But doing multiple per-task contexts is something for a next step
> indeed.
>
[snip]

