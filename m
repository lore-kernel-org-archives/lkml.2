Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab1ERLXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:23:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37163 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168Ab1ERLXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:23:10 -0400
Date: Wed, 18 May 2011 13:22:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richter, Robert" <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP
 support
Message-ID: <20110518112259.GG16556@elte.hu>
References: <4D91FA76.1010908@zytor.com>
 <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com>
 <20110407072305.GA20291@elte.hu>
 <20110516191012.GA575@escobedo.osrc.amd.com>
 <20110517113020.GA13475@elte.hu>
 <20110517152210.GA16336@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517152210.GA16336@escobedo.osrc.amd.com>
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


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> > Here are a couple of suggestions to LWP hardware designers:
> > 
> >  - the fact that LWP cannot count kernel events right now is unfortunate - 
> >    there's no reason not to allow privileged user-space to request ring 3
> >    events as well - hopefully this misfeature will be fixed in future 
> >    iterations of the hardware.
> > 
> >  - it would be nice to allow the per task masking/unmasking of LWP without
> >    having to modify the cr0 (which can be expensive). A third mode
> >    implemented in the LWP_CFG MSG would suffice: it would make the LWP
> >    instructions privileged, but would otherwise allow LWP event collection
> >    to occur even on sandboxed code.
> > 
> >  - it would be nice to also log the previous retired instruction in the
> >    trace entry, to ease decoding of the real instruction that generated
> >    an event. (Fused instructions can generate their RIP at the first
> >    instruction.)
> 
> I will forward this to our hardware designers, but I have my doubts about the 
> first two of your suggestions. They seem to be orthogonal to what LWP is 
> supposed to be.

Not sure why you think those two suggestions are 'orthogonal to LWP', they are 
not:

 - the second suggestion adds a third security model to the current 
   all-or-nothing nature of LWP instructions.

 - the first suggestion is a variation of its current security model as well:
   it allows LWP driven event collection in kernel mode, not just user mode.

There is nothing fundamentally ring-3-only about the concept of 'light weight 
profiling' - while ring-3-only event collection is understandably necessary for 
unprivileged user-space, it is not the only interesting mode of lightweight 
event collection.

Thanks,

	Ingo
