Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2BUPzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:55:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3728 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2BUPzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:55:11 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=CvlS4R1r7kYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=bNEnXefycaPkDHUF5vwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329839709.25686.63.camel@gandalf.stny.rr.com>
Subject: Re: ftrace_enabled set to 1 on bootup, slow downs with
 CONFIG_FUNCTION_TRACER in virt environments?
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Date: Tue, 21 Feb 2012 10:55:09 -0500
In-Reply-To: <20120221153827.GA7529@phenom.dumpdata.com>
References: <20120214152955.GA17671@phenom.dumpdata.com>
	 <1329243722.7469.7.camel@acer.local.home>
	 <20120221153827.GA7529@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 10:38 -0500, Konrad Rzeszutek Wilk wrote:
>  
> > You mean that we get a lot more functions because the compiler made them
> > functions? Maybe we should add "notrace" to all paravirt functions? Then
> > they wont have the calls or nops.
> 
> <nods> Do you remember the rational of why some have notrace but not all?

They probably all should. Unless there's some reason people want to
trace those functions. But if they are not traced on bare-metal, then it
probably isn't worth tracing them on paravirt either.

> 
> > 
> > > - Somehow the low-level para-virt (like the assembler ones) calls don't get
> > >    patched over and still end up calling mcount? (but I really doubt that is the
> > >    case - but you never know).
> > 
> > We only live patch code in a white list of sections. But with the latest
> > scripts/recordmcount.c, as I stated above, the ones that don't get
> > patched at boot up, should be patched at compile time. But that still
> > keeps the nops there.
> 
> So the ideal_nop in the looks to be different from what the trace code
> decides to patch during execution. Is that OK? I am not that familiar with the
> variants of nops to know if some are just not ok on certain architectures?

What gets patched at compile time isn't the ideal for the arch. But it's
the "best" that can be done at that moment. But pretty much all of the
non ideal nops are patched over .init sections that are called only once
(at boot up). Even though they may not be the ideal nop for the running
box, it shouldn't be any noticeable overhead.

-- Steve


