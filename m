Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0KRIek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:34:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35701 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab0KRIei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:34:38 -0500
Date: Thu, 18 Nov 2010 09:34:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>, Milton Miller <miltonm@bga.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v2)
Message-ID: <20101118083420.GC26398@elte.hu>
References: <20101111214546.4e573cad@queued.net>
 <reply-olpc-3-v2@mdm.bga.com>
 <20101112002704.50c629e2@queued.net>
 <20101114095013.GB24206@elte.hu>
 <4CE0B54E.6000101@zytor.com>
 <20101115070254.GA25243@elte.hu>
 <4CE17133.2050101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE17133.2050101@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/14/2010 11:02 PM, Ingo Molnar wrote:
> > 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> >> What?  What is wrong with static variables in functions?  It really doesn't seem 
> >> to be a good idea to make them file-scope if they don't need to be.
> > 
> > They are very easy to overlook and mix up with regular stack variables and i've seen 
> > (and introduced myself) a number of bugs due to them.
> > 
> > They also often are used in buggy ways (with SMP not taken into consideration), so 
> > overlooking them during review compounds their negative effects. Putting them in 
> > front of the function isnt a big deal in exchange.
> > 
> > There are people who never overlook them (like yourself), but my brain is wired up 
> > differently.
> > 
> 
> However, I have to vehemently object to putting them in a wider scope
> than is otherwise necessary.  I agree that static variables should be
> used sparsely if at all (there really are vary few uses of them that are
> valid), but putting them in a larger scope screams "I'm used in more
> than one function", and that is *not* a good thing.

That's why we sometimes use the (imperfect) compromise to put them in front of that 
function, not at the top of the file.

Look at the general balance of hardship: very little harm is done (it's not a big 
deal if a variable is only used in a single function) but having it with local 
variables can be _really_ harmful - for example i overlooked them when i reviewed 
this patch. I dont like important details obscured - i like them to be apparent. 
Again, this is something that some people can parse immediately on the visual level 
- me and many others cannot.

Thanks,

	Ingo
