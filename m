Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0ERTa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:30:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab0ERTay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:30:54 -0400
Date: Tue, 18 May 2010 21:30:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Joe Perches <joe@perches.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, "Young, Brent" <brent.young@intel.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100518193022.GB30936@elte.hu>
References: <4BF18995.6070008@redhat.com>
 <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com>
 <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2260]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> > It makes sense to use the kernel's performance events 
> > logging framework when we are logging events about how the 
> > system performs.
> 
> Perhaps it makes more sense to say that the Linux 
> "performance events logging framework" has become more 
> generic and is really now an "event logging framework".

Yeah, it essentially is.

> > Furthermore it's NMI safe, offers structured logging, 
> > has various streaming, multiplexing and filtering 
> > capabilities that come handy for RAS purposes and 
> > more.
> 
> Those of us present at the mini-summit were not familiar 
> with all the features available. One area of concern was 
> how to be sure that something is in fact listening to 
> and logging the error events.  My understanding is that 
> if there is no process attached to an event, the kernel 
> will just drop it.  This is of particular concern 
> because the kernel's first scan of the machine check 
> banks occurs before there are any processes. So errors 
> found early in boot (which might be saved fatal errors 
> from before the boot) might be lost.

I proposed a (fairly straightforward) extension to which 
Boris agreed: we can introduce 'persistent events', which 
have task-less buffers attached to them, which will hold 
(a configurable amount of) of events.

Those can then be picked up by a task later on and no 
event is lost.

Would such a feature address your concern?

It would be useful not just for reliable error event 
collection, it could also be used for things like the boot 
tracer (which too deals with events that occur before 
there are any user-space tasks to pick up events).

I.e. it fits into the whole scheme in a pretty natural, 
multi-purpose way.

Thanks,

	Ingo
