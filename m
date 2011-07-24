Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1GXNsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 09:48:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43750 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab1GXNsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 09:48:04 -0400
Date: Sun, 24 Jul 2011 15:47:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110724134711.GC8496@elte.hu>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <20110724111350.GD21120@elte.hu>
 <20110724134046.GA10583@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724134046.GA10583@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Borislav Petkov <bp@amd64.org> wrote:

> > > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > > index b13ed39..2d380c6 100644
> > > --- a/arch/x86/kernel/cpu/amd.c
> > > +++ b/arch/x86/kernel/cpu/amd.c
> > > @@ -458,6 +458,13 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
> > >  					"with P0 frequency!\n");
> > >  		}
> > >  	}
> > > +
> > > +	if (unalias_va_addr == -1) {
> > > +		if (c->x86 == 0x15)
> > > +			unalias_va_addr = UNALIAS_VA_32 | UNALIAS_VA_64;
> > > +		else
> > > +			unalias_va_addr = 0;
> > 
> > the placement here feels a bit wrong - don't we have run-once CPU 
> > quirks?
> 
> Maybe another func ptr in struct x86_cpuinit_ops
> (arch/x86/kernel/x86_init.c) would be a better place?

Yeah.

Assuming no objections come i'd suggest to do that as an add-on patch 
- so the first patch can be backported, the second patch cleans up 
the x86_cpuinit_ops aspect.

Thanks,

	Ingo
