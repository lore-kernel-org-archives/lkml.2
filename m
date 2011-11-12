Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1KLAU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:20:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1KLAU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:20:57 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=d1TCUqu53CkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=dQtGILt0rAsnjp2ECwEA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: function_graph selftest fails with !DYNAMIC
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20111111165554.GA28752@debian>
References: <20111102150255.GA6973@debian>
	 <1320414269.19219.12.camel@gandalf.stny.rr.com>
	 <20111111165554.GA28752@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 19:20:24 -0500
Message-ID: <1321057224.2346.0.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 22:25 +0530, Rabin Vincent wrote:
> On Fri, Nov 04, 2011 at 09:44:29AM -0400, Steven Rostedt wrote:
> > On Wed, 2011-11-02 at 20:32 +0530, Rabin Vincent wrote:
> > > The function_graph selftest fails when CONFIG_DYNAMIC_FTRACE is not set
> > > (tested on x86-64) on current kernels:
> > > 
> > > [    0.300124] Testing tracer function: PASSED
> > > [    0.446092] Testing tracer function_graph: .. no entries found ..FAILED!
> > > 
> > > Bisecting goes back to this commit:
> > > 
> > > 2b499381bc50ede01b3d8eab164ca2fad00655f0 is the first bad commit
> > 
> > Your bisect is wrong. I ran it though ktest.pl and it gave me this
> > bisect commit:
> 
> Odd.  2b499381bc50ede really doesn't work for me.  2b499381bc50ede^
> does, so the bisect to 2b499381bc50ede seems correct for my config.
> 
> It appears I'm seeing a different problem, because ...

Hmm, strange, I'll take a look at this on Monday. Thanks.

-- Steve

> 
> > The simple fix is:
> > 
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -151,7 +151,6 @@ void clear_ftrace_function(void)
> >         ftrace_pid_function = ftrace_stub;
> >  }
> >  
> > -#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
> >  #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
> >  /*
> >   * For those archs that do not test ftrace_trace_stop in their
> 
> ... this doesn't seem to fix it.  I've test 3.2-rc1 with this patch
> applied, and the self-test failure is still seen.
> 
> Maybe there's some difference between our configs?  I've attached mine.
> I run it with the "native linux KVM tool".


