Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab1BRIPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:15:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34390 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab1BRIPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:15:05 -0500
Date: Fri, 18 Feb 2011 09:14:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: tony.luck@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 2/3] x86-64: use relative 32-bit pointers in exception
 tables
Message-ID: <20110218081446.GA21125@elte.hu>
References: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
 <20110217172559.GD17058@elte.hu>
 <4D5E36DD02000078000329CE@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5E36DD02000078000329CE@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 17.02.11 at 18:25, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Nice patch. I've got a really small code readability nitpick:
> > 
> >> +#ifndef ex_insn /* until all architectures have this accessor */
> >> +#define ex_insn(x) (x)->insn
> >> +#endif
> > 
> >> +#else
> >> +#define swap_ex NULL
> >> +#endif
> > 
> > In the x86 architecture we tend to write this as:
> > 
> >> +#else
> >> +# define swap_ex NULL
> >> +#endif
> > 
> > So that the conditional structure stands out more, visually. (There might be 
> > more 
> > such cases in these patches as well.)
> 
> I can certainly fix this, but got a comment from (I think) Andrew
> Morton to do exactly the opposite quite some time ago, with the
> rationale that this indentation leads to more involved patches
> when further conditionals get added around them.

Well, the patch impact argument is a valid concern, but by that logic we should also 
drop the visual structure of other conditionals such as:

	if (x) {
		if (y)
			z;
		else
			k;
	} else {
		l;
	}

and write:

	if (x) {
	if (y)
	z;
	else
	k;
	} else {
	l;
	}

? I don't think so.

There might be other cases where marking CPP code this way looks ugly but in this 
patch it's clearly helpful to readability.

So i think for consistency's (and eyeball health's) sake lets bring as much 
meaningful geometric structure into source code as possible. Future patch size 
worries are secondary IMO.

Thanks,

	Ingo
