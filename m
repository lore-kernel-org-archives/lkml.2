Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2JFRci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:32:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37143 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2JFRcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:32:35 -0400
Date: Sat, 6 Oct 2012 19:32:31 +0200
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
Message-ID: <20121006173231.GA6110@liondog.tnic>
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
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
 <50612729.2080307@zytor.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
 <50650A7E.90807@zytor.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
 <1349446428.6755.56.camel@gandalf.local.home>
 <506F7849.2080805@zytor.com>
 <1349492261.6755.87.camel@gandalf.local.home>
 <20121006130532.GB11120@liondog.tnic>
 <1349535105.6755.104.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349535105.6755.104.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 10:51:45AM -0400, Steven Rostedt wrote:
> On Sat, 2012-10-06 at 15:05 +0200, Borislav Petkov wrote:
> > What I'm missing with all those patches on LKML is: here's a patch that
> > doesn't add a new feature but gives us n% improv with this and that
> > workload. I wish we had more of those instead of the gazillion new
> > features each 3 months.
> 
> That would be nice too. But we can also add a patch that gives us
> negligible improvement that makes things a little more complex and also
> opens the possibility of a security hole.
> 
> Thus my question is, is the swap IDT really worth it? I'm fine if
> someone goes ahead and implements it. Heck, I'd love to implement it
> when I have time, as it refreshes my knowledge of how intel archs do
> interrupt processing.
> 
> I'm just worried that we are adding more complexity to code for very
> little gain.
> 
> I think we need to take another look at this.
> 
> 1) Are the tracepoints that Seiji worth adding? If not then we can stop
> the discussion here.

I like straight talk - it saves everybody a lot of time :-)

But seriously, I was adressing the general observation how a lot of new
features get added because "it would be cool if we could do X and Y" and
how we're progressively getting fatter and slowing down over time.

And I like how you're giving that feature a hard look - something we
should be doing always, btw.

So http://marc.info/?l=linux-kernel&m=134827445716419 talks about how it
is good to know which cores handle IRQs and how this affects the system,
and IRQ interaction and yadda yadda... But frankly speaking, that still
doesn't give me a hard-on; I gotta say - it sounds more like a debugging
feature which people can enable, with certain overhead like most of
those in "Kernel hacking" but the general public doesn't need it.

So, do we really really need this or are we better off with a debugging
design where we don't care about overhead?

Hmm, I'd say make it off by default and let people who want it enable it
and go crazy.

> 2) Are the tracepoints done in a way that it's not going to cause "ABI"
> issues. If not then we need to redesign the tracepoints.

Btw, this we should be asking ourselves about *all* TPs, especially if
they're in generic code.

[ … ]

Thanks.

-- 
Regards/Gruss,
    Boris.
