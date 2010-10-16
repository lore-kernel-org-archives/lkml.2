Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab0JPCDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:03:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab0JPCDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:03:30 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=Zt58hVK3vDgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JFugqVhUno0uHbKyxY4A:9 a=kfTBU1aQiVglcGVMT0FA1NTk3PsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/9] [GIT PULL] tracing: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101013214614.GC2878@redhat.com>
References: <20101006033445.465428951@goodmis.org>
	 <20101008081655.GC13754@elte.hu> <20101008084541.GA23742@elte.hu>
	 <1286596787.23994.1285.camel@gandalf.stny.rr.com>
	 <20101013214614.GC2878@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 22:03:29 -0400
Message-ID: <1287194609.16971.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 17:46 -0400, Jason Baron wrote:
> On Fri, Oct 08, 2010 at 11:59:47PM -0400, Steven Rostedt wrote:
> > On Fri, 2010-10-08 at 10:45 +0200, Ingo Molnar wrote:
> > > hm, i'm getting:
> > > 
> > > arch/x86/kernel/alternative.c: Assembler messages:
> > > arch/x86/kernel/alternative.c:674: Error: symbol `ftrace_test_jmp' is already defined
> > > arch/x86/kernel/alternative.c:678: Error: symbol `ftrace_test_p6nop' is already defined
> > > arch/x86/kernel/alternative.c:680: Error: symbol `ftrace_test_nop5' is already defined
> > > 
> > > Config attached.
> > 
> > I'll see if I can get to this early next week. I'll be leaving to NYC on
> > Monday for the End Users Summit. I'll try to look at this while there.
> > 
> > Thanks!
> > 
> > -- Steve
> > 
> 
> just saw this...looks like this is broken for gcc < 4.5. Anyways, the
> patch below fixes the compilation by making arch_init_ideal_nop5()
> static (and moving its definition ahead of its usage). I'm not quite
> sure why this makes the compiler happy...applies on top of this series.
> 

I can't reproduce this. And I don't like patches that have comments
like: "not quite sure why this makes the compiler happy".

Is this still an issue?  I tried out gcc 4.4.2, 4.4.4 and gcc 4.5.1 with
the config given, and did not get the above errors.

-- Steve


