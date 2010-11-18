Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0KRInH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:43:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab0KRInF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:43:05 -0500
Date: Thu, 18 Nov 2010 09:42:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: Re: [PATCH 4/9 UPDATED-1] x86: Initialize 32bit logical apicid
 mapping early during boot
Message-ID: <20101118084257.GF26398@elte.hu>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
 <1289473363-29440-5-git-send-email-tj@kernel.org>
 <4CDD17EC.8000507@kernel.org>
 <20101118083045.GB26398@elte.hu>
 <4CE4E655.30207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE4E655.30207@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hey, Ingo.
> 
> On 11/18/2010 09:30 AM, Ingo Molnar wrote:
> > This patch is still _WAY_ too large.
> 
> Really?  Alright, I'll split it further.

This is a very sensitive area of code that tends to blow up in nasty ways. So when 
we do changes here we want them super-finegrained. If you split it up into 30 
reasonable patches - no problem at all. (here up to 5 would suffice i think)

Yinghai used to have this too big patches illness too.

> > Also, these:
> > 
> >> +#ifdef CONFIG_X86_32
> >> +#endif
> > 
> >> +#ifdef CONFIG_X86_32
> >> +#endif
> > 
> >> +#ifdef CONFIG_X86_32
> >> +#endif
> > 
> >> +#ifdef CONFIG_X86_32
> >> +#endif
> > 
> > Are rather ugly.
> 
> Yeah, what they do is ugly.  It gets less uglier after the patchset.
> I'll see if some of them can be dropped but I don't think putting them
> inside ifdef'd inline functions necessarily improves things.  It often
> just makes things more difficult to follow.

Can we remove them? Or does it make any sense on the 64-bit side?

Thanks,

	Ingo
