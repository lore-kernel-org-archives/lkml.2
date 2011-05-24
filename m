Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab1EXVmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:42:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab1EXVmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:42:01 -0400
Date: Tue, 24 May 2011 23:41:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
Message-ID: <20110524214139.GP27634@elte.hu>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <20110524034023.GB25230@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
 <20110524173326.GA7635@gere.osrc.amd.com>
 <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
 <1306272274.2497.73.camel@laptop>
 <BANLkTi=BrrwL=gzn7H6O1rAGJpe=VPAQRQ@mail.gmail.com>
 <1306273062.2497.80.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306273062.2497.80.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-05-24 at 14:30 -0700, Linus Torvalds wrote:
> > On Tue, May 24, 2011 at 2:24 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > Right, so you can't do things like that from NMI context, but what perf
> > > can do is raise a self-IPI and continue from IRQ context (question for
> > > the HW folks, can there be cycles between the NMI iret and IRQ assert
> > > from whatever context was before the NMI hit?)
> > 
> > Of course there can be - the code where the NMI hit may have
> > interrupts disabled.
> 
> D'0h yes of course!..
> 
> Then I can't immediately see a way to stop a thread dead in its tracks.
> Userspace yes, but not kernel-space.

It's a best-effort thing: run proper kernel code (hardirq context) as soon as 
possible - but obviously not sooner than that! :-)

Thanks,

	Ingo
