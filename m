Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053Ab0COOkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:40:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61317 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042Ab0COOjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:39:54 -0400
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=cNj22-NcwO_uoGkf2NwA:9 a=BlZGyBYNgiMHJRlqqumi7Dxd4gkA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4B9D915A.6080101@cn.fujitsu.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>
	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>
	 <4B95AE4E.6060700@cn.fujitsu.com>
	 <1268101394.10871.1861.camel@gandalf.stny.rr.com>
	 <4B95C2AF.7010508@cn.fujitsu.com>
	 <1268446049.4471.787.camel@gandalf.stny.rr.com>
	 <1268502976.4471.798.camel@gandalf.stny.rr.com>
	 <4B9D915A.6080101@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 15 Mar 2010 10:39:50 -0400
Message-ID: <1268663990.4471.808.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 09:46 +0800, Li Zefan wrote:
> Steven Rostedt wrote:
> > On Fri, 2010-03-12 at 21:07 -0500, Steven Rostedt wrote:
> >> On Tue, 2010-03-09 at 11:38 +0800, Li Zefan wrote:
> >>
> >>> The segfault is from userspace. This is a segfault I just got:
> >>>
> >>> ftrace_stack_ma[14989]: segfault at fe2e ip 00000000004474c0 sp 00007fffb97e38c0 error 4 in bash[400000+d1000]
> >> Li and Lai,
> >>
> >> Thanks a lot for reporting all this, and writing the ftrace_stress_test.
> >> I've fixed all the bugs that it has reported (to my knowledge) and after
> >> a little more testing I will soon be sending a patch series out.
> > 
> > Li,
> > 
> > I ran your test for 13 hours on three different machines. I did not hit
> > any more errors. Although I see a lockdep warning (not a locking problem
> > but the WARN_ON in fork.c is triggering). I'll look into that on Monday.
> > 
> 
> As I said in the offline mail, this warning is caused by global trace_clock,
> and I sent a fix sometime ago:
> 
> http://lkml.org/lkml/2009/12/21/4

Ah, I was waiting for a final Acked-by: from Peter Zijlstra.

Peter,

Should I pull in that patch? I don't see anything wrong with converting
a raw_local_irq_save() to a local_irq_save() in the tracing code. I'll
apply it locally and see if it fixes the warn on that I see.

Note, even the function tracer uses straight local_irq_save(), so I
would think that the clock code could too.

-- Steve

> 
> > Please take the new patches that Ingo just pushed to Linus, if you find
> > any more bugs, please let me know right away.
> > 
> 
> Thanks for the fixes!
> 


