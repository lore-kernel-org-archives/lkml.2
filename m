Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0LJXTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:19:17 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:35843 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab0LJXTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:19:13 -0500
Date: Sat, 11 Dec 2010 00:18:57 +0100
From: mat <castet.matthieu@free.fr>
To: Kees Cook <kees.cook@canonical.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20101211001857.4c5e0794@mat-laptop>
In-Reply-To: <20101208221951.GO5750@outflux.net>
References: <4CE2F914.9070106@free.fr>
	<24422.1290656467@localhost>
	<20101126182355.62615dff@mat-laptop>
	<20101208221951.GO5750@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 8 Dec 2010 14:19:51 -0800,
Kees Cook <kees.cook@canonical.com> a écrit :

> On Fri, Nov 26, 2010 at 06:23:55PM +0100, mat wrote:
> > could you try the attached patch ?
> > 
> > on module load, we sort the __jump_table section. So we should make
> > it writable.
> > 
> > 
> > Matthieu
> 
> > diff --git a/arch/x86/include/asm/jump_label.h
> > b/arch/x86/include/asm/jump_label.h index f52d42e..574dbc2 100644
> > --- a/arch/x86/include/asm/jump_label.h
> > +++ b/arch/x86/include/asm/jump_label.h
> > @@ -14,7 +14,7 @@
> >  	do
> > {							\ asm
> > goto("1:"					\
> > JUMP_LABEL_INITIAL_NOP			\
> > -			".pushsection __jump_table,  \"a\" \n\t"\
> > +			".pushsection __jump_table,  \"aw\" \n\t"\
> >  			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> >  			".popsection \n\t"			\
> >  			: :  "i" (key) :  : label);
> > \
> 
> Acked-by: Kees Cook <kees.cook@canonical.com>
> 
> Can this please get committed to tip?
I think it is not need anymore with  Steven Rostedt patch [1]

Matthieu

[1]
> > Here we set the text read only before we call the notifiers. The
> > function tracer changes the calls to mcount into nops via a notifier
> > call so this must be done after the module notifiers.
