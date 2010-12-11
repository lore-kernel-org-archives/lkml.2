Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab0LKA2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:28:40 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36969 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0LKA2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:28:39 -0500
Date: Fri, 10 Dec 2010 16:27:50 -0800
From: Kees Cook <kees.cook@canonical.com>
To: mat <castet.matthieu@free.fr>
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
Message-ID: <20101211002750.GT4464@outflux.net>
References: <4CE2F914.9070106@free.fr>
 <24422.1290656467@localhost>
 <20101126182355.62615dff@mat-laptop>
 <20101208221951.GO5750@outflux.net>
 <20101211001857.4c5e0794@mat-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101211001857.4c5e0794@mat-laptop>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 11, 2010 at 12:18:57AM +0100, mat wrote:
> Le Wed, 8 Dec 2010 14:19:51 -0800,
> Kees Cook <kees.cook@canonical.com> a écrit :
> 
> > On Fri, Nov 26, 2010 at 06:23:55PM +0100, mat wrote:
> > > could you try the attached patch ?
> > > 
> > > on module load, we sort the __jump_table section. So we should make
> > > it writable.
> > > 
> > > 
> > > Matthieu
> > 
> > > diff --git a/arch/x86/include/asm/jump_label.h
> > > b/arch/x86/include/asm/jump_label.h index f52d42e..574dbc2 100644
> > > --- a/arch/x86/include/asm/jump_label.h
> > > +++ b/arch/x86/include/asm/jump_label.h
> > > @@ -14,7 +14,7 @@
> > >  	do
> > > {							\ asm
> > > goto("1:"					\
> > > JUMP_LABEL_INITIAL_NOP			\
> > > -			".pushsection __jump_table,  \"a\" \n\t"\
> > > +			".pushsection __jump_table,  \"aw\" \n\t"\
> > >  			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> > >  			".popsection \n\t"			\
> > >  			: :  "i" (key) :  : label);
> > > \
> > 
> > Acked-by: Kees Cook <kees.cook@canonical.com>
> > 
> > Can this please get committed to tip?
> I think it is not need anymore with  Steven Rostedt patch [1]
> 
> Matthieu
> 
> [1]
> > > Here we set the text read only before we call the notifiers. The
> > > function tracer changes the calls to mcount into nops via a notifier
> > > call so this must be done after the module notifiers.

Which patch was that? (Or, rather, what's a good url to see it?)

-Kees

-- 
Kees Cook
Ubuntu Security Team
