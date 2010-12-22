Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0LVV55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:57:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40545 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab0LVV5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:57:55 -0500
Date: Wed, 22 Dec 2010 22:57:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: mat <castet.matthieu@free.fr>, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20101222215725.GB5585@elte.hu>
References: <4CE2F914.9070106@free.fr>
 <24422.1290656467@localhost>
 <20101126182355.62615dff@mat-laptop>
 <20101208221951.GO5750@outflux.net>
 <20101211001857.4c5e0794@mat-laptop>
 <20101222124019.GG10809@elte.hu>
 <34428.1293053719@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34428.1293053719@localhost>
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Wed, 22 Dec 2010 13:40:19 +0100, Ingo Molnar said:
> > 
> > * mat <castet.matthieu@free.fr> wrote:
> > 
> > > Le Wed, 8 Dec 2010 14:19:51 -0800,
> > > Kees Cook <kees.cook@canonical.com> a écrit :
> > > 
> > > > On Fri, Nov 26, 2010 at 06:23:55PM +0100, mat wrote:
> > > > > could you try the attached patch ?
> > > > > 
> > > > > on module load, we sort the __jump_table section. So we should make
> > > > > it writable.
> > > > > 
> > > > > 
> > > > > Matthieu
> > > > 
> > > > > diff --git a/arch/x86/include/asm/jump_label.h
> > > > > b/arch/x86/include/asm/jump_label.h index f52d42e..574dbc2 100644
> > > > > --- a/arch/x86/include/asm/jump_label.h
> > > > > +++ b/arch/x86/include/asm/jump_label.h
> > > > > @@ -14,7 +14,7 @@
> > > > >  	do
> > > > > {							\ asm
> > > > > goto("1:"					\
> > > > > JUMP_LABEL_INITIAL_NOP			\
> > > > > -			".pushsection __jump_table,  \"a\" \n\t"\
> > > > > +			".pushsection __jump_table,  \"aw\" \n\t"\
> > > > >  			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> > > > >  			".popsection \n\t"			\
> > > > >  			: :  "i" (key) :  : label);
> > > > > \
> > > > 
> > > > Acked-by: Kees Cook <kees.cook@canonical.com>
> > > > 
> > > > Can this please get committed to tip?
> > > I think it is not need anymore with  Steven Rostedt patch [1]
> > > 
> > > Matthieu
> > > 
> > > [1]
> > > > > Here we set the text read only before we call the notifiers. The
> > > > > function tracer changes the calls to mcount into nops via a notifier
> > > > > call so this must be done after the module notifiers.
> > 
> > What's the status of this bug?
> > 
> > If we still need the patch then please submit it standalone with a proper subject 
> > line, with acks/signoffs added, etc.
> 
> Steve Rostedt's patch that moves the setting of the page permissions seems to make 
> this patch no longer necessary.  I tripped over this same issue, but the version 
> in the latest -mmotm does not need it, as it includes Steve's fix.

It would be nice to see that fix submitted so that it gets into the tree that 
introduced the bug.

Steve, Andrew?

Thanks,

	Ingo
