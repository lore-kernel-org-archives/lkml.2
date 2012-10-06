Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2JFXd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 19:33:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50685 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab2JFXd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 19:33:27 -0400
Date: Sun, 7 Oct 2012 01:33:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
Message-ID: <20121006233322.GC3278@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Seiji Aguchi <seiji.aguchi@hds.com>,
	"Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
	"x86@kernel.org" <x86@kernel.org>,
	"dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>,
	Satoru Moriya <satoru.moriya@hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
 <50650A7E.90807@zytor.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
 <1349446428.6755.56.camel@gandalf.local.home>
 <506F7849.2080805@zytor.com>
 <1349492261.6755.87.camel@gandalf.local.home>
 <20121006130532.GB11120@liondog.tnic>
 <1349535105.6755.104.camel@gandalf.local.home>
 <20121006173231.GA6110@liondog.tnic>
 <1349547977.6755.108.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349547977.6755.108.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 02:26:17PM -0400, Steven Rostedt wrote:
> On Sat, 2012-10-06 at 19:32 +0200, Borislav Petkov wrote:
> 
> > > 2) Are the tracepoints done in a way that it's not going to cause "ABI"
> > > issues. If not then we need to redesign the tracepoints.
> > 
> > Btw, this we should be asking ourselves about *all* TPs, especially if
> > they're in generic code.
> 
> I agree, and I'm starting to think I shouldn't have given free reign
> over the TPs to system maintainers. That is, I should have pushed harder
> to understand all tracepoints added to code to make sure the maintainer
> knows that it can become an ABI.
> 
> Some maintainers don't worry about it. But I can see it coming back to
> haunt them. In the end, it will hurt the maintainer of the code, which
> is why I gave the ownership of tracepoints to locations where they are
> at (instead of a "joint" ownership). But I probably should have been a
> TP cop for a while to allow them to understand the consequences first.

Yeah, even if you were the TP cop and had a shiny uniform with a badge
8-), do you think you'd have the time to review all the code adding TPs?

I think maybe it would've been better to add some text to Documentation
explaining with what care TPs should be designed, have checkpatch warn
on all new tracepoints, hope for the best and prepare for the worst. In
addition maybe review all TPs added to generic or arch-you-care-about
code. Maybe...

-- 
Regards/Gruss,
    Boris.
