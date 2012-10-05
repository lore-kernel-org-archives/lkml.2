Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2JEONv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:13:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2JEONu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:13:50 -0400
X-Authority-Analysis: v=2.0 cv=fb8vOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zYQHrSgTeTAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_67WK3i7ub8A:10 a=JG5_MIiJ_YBOF9KV83kA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349446428.6755.56.camel@gandalf.local.home>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 05 Oct 2012 10:13:48 -0400
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
	 <50612729.2080307@zytor.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
	 <50650A7E.90807@zytor.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 19:10 +0000, Seiji Aguchi wrote:
> > >
> > > If I misunderstand something, please let me know.
> > >
> > 
> > Quite.
> > 
> > These functions are being invoked from the IDT, which is an indirect pointer structure.  When not being traced, there is absolutely no
> > reason why it should go through a thunk with tracepoints.
> 
> I agree that the cost can be absolutely zero by switching  each interrupt hander when turning on/off the tracepoint.
> 

Peter,

I agree that the IDT version is a zero cost in performance, where as the
tracepoint version is a negligible cost in performance. But my worry is
the complexity (read error prone and possible openings of security
exploits) worth it?

Switching of the IDT is not that trivial, and to make it something for
common activities such as reading tracepoints by tools like ftrace and
perf, that do it often, even on production machines, may lead to issues
if its not done right.

You are the maintainer and are responsible for the outcome of changes to
the x86 arch, thus you do have final say. And if you think there's
nothing to worry about with an IDT change then Seiji should implement
it.

I just want to point out some possible repercussions of doing it in a
more complex way. As tracepoints use nops, and I may be pushing to even
out-of-line the tracepoint unlikely part even more, I'm not sure the
complexity is worth the amount of savings it would be against just
adding the tracepoint in the code.

-- Steve


