Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2LRUdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:33:40 -0500
Received: from www84.your-server.de ([213.133.104.84]:37626 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2LRUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:33:39 -0500
Message-ID: <1355862759.28056.14.camel@wall-e>
Subject: Re: [PATCH 6/6] Add 32 bit VDSO support for 32 and 64 bit kernels
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
Date: Tue, 18 Dec 2012 21:32:39 +0100
In-Reply-To: <50D0B986.7020009@zytor.com>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
	 <1355823656-13902-7-git-send-email-stefani@seibold.net>
	 <50D09733.3080502@zytor.com> <1355849558.26967.24.camel@wall-e>
	 <50D0B986.7020009@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 18.12.2012, 10:44 -0800 schrieb H. Peter Anvin:
> On 12/18/2012 08:52 AM, Stefani Seibold wrote:
> > 
> > Pardon, i never disregarded nor i have agreed that this is going to be a
> > part of the VDSO. I currently have also no idea how to do this and i see
> > no need at the moment to do this revamp. The 64 bit VDSO lives since
> > more than 6 years with this kind of implementation.
> > 
> 
> It was part of this discussion thread, about how to best manage the
> address space.  Fixed addresses are a major problem, and introducing new
> ones are extremely undesirable.
> 

There is no introduce of new fix address. There are still there for
x86_64. If this will currently not a major problem on this architecture
than it will not for x86_32 too.

> Hence I wrote:
> 
> > IMO it seems this is making it way more complicated than it is. Just
> > make sure you have a section in the vdso where you can map in a data
> > page with the symbols in the right offsets. Extra points for doing
> > magic so that it is at the beginning or end, but I think that might
> > be harder than necessary.
> 
> Basically, make the vvar and hpet pages part of the vdso page list.
> Optionally they can be mapped without the MAYWRITE option -- in fact, we
> could easily split the vdso into an executable area which gets MAYWRITE
> to be able to set breakpoints and a data area which doesn't -- but that
> is a minor tweak IMO.
> 

I see the benefits, but it will not work under all circumstance. The
VDSO compat mode for x86_32 requires a fix address and there is no room
behind this. So since this must preserved, i see no real gain for this.

> > You asked me to do the VDSO 32 bit stuff for the IA32_EMULATION, before
> > it is ready for inclusion into the kernel. Thats exactly what i did. I
> > spend the whole weekend of my spare time to do this implementation. Now
> > we have them all.
> > 
> > The patch works perfectly, all issues are solved:
> > 
> > - Calling conventions
> > - ABI transformations
> > - System call gateway for X86 32 bit
> > - Mapping of the FIXMAP and HPET into the lower 32 bit address space for
> > IA32_EMULATION
> > - Support for 32 bit programs in 32 kernel and 64 bit kernel
> > - One VDSO source for all
> > 
> > If you prefer an other solutions, its okay. There are many ways to code
> > things. But for now i think it is a good step ahead. That is what i
> > currently can provide.
> 
> This is good.  We have some time anyway to get this ready for the 3.9
> merge window.
> 

What does this mean? Do you accept my patch or drop it? I see no real
technical issue to drop it. It makes things better not worse. Maybe
there is a better solution, but this is the next step.

I advocate to apply this patch, because i spend a lot time to write it
and it is a good base to continue the work.

- Stefani


