Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab1FBH0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:26:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:40609 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1FBH0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:26:14 -0400
Subject: Re: [RFC][PATCH] Kexec support for PPC440x
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Suzuki Poulose <suzuki@in.ibm.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4DE50617.7090509@linutronix.de>
References: <4DE345B0.8020505@in.ibm.com>  <4DE50617.7090509@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 17:25:51 +1000
Message-ID: <1306999551.29297.57.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 17:15 +0200, Sebastian Andrzej Siewior wrote:
> Suzuki Poulose wrote:
> > Index: powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
> > ===================================================================
> > --- /dev/null
> > +++ powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
> ....
> 
> > + *
> > + */
> > +    bl    nxtins                /* Find our address */
> > +nxtins:    mflr    r5                /* Make it accessible */
> 
> Please don't mix labels and instructions.

With proper indent it's fine as long as he uses numerical relative
labels which should be the case here. For example, the above, it should
look like:

	bl	1f
1:	mflr	r5

> > +    tlbsx    r23,0,r5            /* Find entry we are in */
> 
> using tabs instead of spaces would make it look nice. Please also separate 
> the arguments of the instruction i.e.
> 	tlbsx	r23, 0, r5

That's arguable. If you look at arch/powerpc, we tend not to separate
the arguments ;-)

Actually I used to, others didn't and I changed my own style.

> > Index: powerpc/arch/powerpc/kernel/misc_32.S
> > ===================================================================
> > --- powerpc.orig/arch/powerpc/kernel/misc_32.S
> > +++ powerpc/arch/powerpc/kernel/misc_32.S
> > @@ -736,6 +736,28 @@ relocate_new_kernel:
> >      mr      r5, r31
> >  
> >      li    r0, 0
> > +#elif defined(CONFIG_44x)  && !defined(CONFIG_47x)
> > +
> > +    mr    r29, r3
> > +    mr    r30, r4
> > +    mr    r31, r5
> > +
> > +#include "44x_kexec_mapping.S"
> 
> The way you setup the 1:1 mapping should be close to what you are doing on
> kernel entry. Isn't it possible to include the file here and in the entry
> code?

It should just not be #included, what about branching out instead ?

Cheers,
Ben.


