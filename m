Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2DRTZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:25:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:35518 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2DRTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:25:31 -0400
Date: Wed, 18 Apr 2012 21:25:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul Bolle <pebolle@tiscali.nl>, Andi Kleen <ak@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [v3.4-rc1] ACPI regression bisected
In-Reply-To: <CA+55aFyHgQ8QgfLKaCaAJ2gLMrOkFMkQBtt4Bfo=dOzzxSpGHw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1204182124230.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com> <20120402235412.GD16303@tassilo.jf.intel.com> <alpine.LFD.2.02.1204031001510.2542@ionos> <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
 <alpine.LFD.2.02.1204121055200.2542@ionos> <20120412142904.GA4130@srcf.ucam.org> <alpine.LFD.2.02.1204121903250.2542@ionos> <alpine.LFD.2.02.1204121907330.2542@ionos> <4F872C7B.6000106@linux.intel.com> <alpine.LFD.2.02.1204122241460.2542@ionos>
 <1334741105.1924.5.camel@x61.thuisdomein> <alpine.LFD.2.02.1204181216380.2542@ionos> <CA+55aFyHgQ8QgfLKaCaAJ2gLMrOkFMkQBtt4Bfo=dOzzxSpGHw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Linus Torvalds wrote:

> On Wed, Apr 18, 2012 at 3:29 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Linus, can you please apply directly?
> 
> Applied. Can we perhaps also make request_threaded_irq() noisily
> reject things that are not marked IRQF_ONESHOT and have a NULL
> low-level handler?

Yes, it's on my (ever growing) todo list.
 
> That still allows people to do IRQF_SHARED | IRQF_ONESHOT, and that
> won't be rejected until somebody else actually tries to share it. Then
> it breaks that somebody else ;(
> 
> Sadly, that would tend to break fairly silently.
> 
> I wonder if we should make the mismatch error printout be
> unconditional (and make just the "dump_stack()" part be conditional on
> CONFIG_DEBUG_SHIRQ)?

That's my plan.

Thanks,

	tglx
