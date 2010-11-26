Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0KZLCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:02:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54007 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab0KZLCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:02:42 -0500
Date: Fri, 26 Nov 2010 11:02:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@iki.fi>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mika Westerberg <ext-mika.1.westerberg@nokia.com>
Subject: Re: [PATCH 1/4] proc/vmcore: allow archs to override
	vmcore_elf_check_arch()
Message-ID: <20101126110224.GH9310@n2100.arm.linux.org.uk>
References: <cover.1289292124.git.mika.westerberg@iki.fi> <df680f67f33d8b0ef815045b53f205b3ff35de63.1289292124.git.mika.westerberg@iki.fi> <20101116142850.df5e9805.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116142850.df5e9805.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:28:50PM -0800, Andrew Morton wrote:
> On Tue,  9 Nov 2010 11:06:10 +0200
> Mika Westerberg <mika.westerberg@iki.fi> wrote:
> 
> > From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
> > 
> > Allow architectures to redefine this macro if needed. This is useful for
> > example in architectures where 64-bit ELF vmcores are not supported.
> > Specifying zero vmcore_elf64_check_arch() allows compiler to optimize
> > away unnecessary parts of parse_crash_elf64_headers().
> > 
> > We also rename the macro to vmcore_elf64_check_arch() to reflect that it
> > is used for 64-bit vmcores only.
> > 
> > Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
> > ---
> >  fs/proc/vmcore.c           |    2 +-
> >  include/linux/crash_dump.h |    9 ++++++++-
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> > index 2367fb3..74802bc5 100644
> > --- a/fs/proc/vmcore.c
> > +++ b/fs/proc/vmcore.c
> > @@ -499,7 +499,7 @@ static int __init parse_crash_elf64_headers(void)
> >  	/* Do some basic Verification. */
> >  	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
> >  		(ehdr.e_type != ET_CORE) ||
> > -		!vmcore_elf_check_arch(&ehdr) ||
> > +		!vmcore_elf64_check_arch(&ehdr) ||
> >  		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
> >  		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
> >  		ehdr.e_version != EV_CURRENT ||
> > diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> > index 0026f26..088cd4a 100644
> > --- a/include/linux/crash_dump.h
> > +++ b/include/linux/crash_dump.h
> > @@ -20,7 +20,14 @@ extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
> >  #define vmcore_elf_check_arch_cross(x) 0
> >  #endif
> >  
> > -#define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
> > +/*
> > + * Architecture code can redefine this if there are any special checks
> > + * needed for 64-bit ELF vmcores. In case of 32-bit only architecture,
> > + * this can be set to zero.
> > + */
> > +#ifndef vmcore_elf64_check_arch
> > +#define vmcore_elf64_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
> > +#endif
> >  
> 
> Looks OK to me.  I'd suggest that this patch be merged along with the
> others, via whatever tree they're taken into.  Russell's ARM tree, I
> assume.
> 
> Should elf_check_arch() be renamed to elf64_check_arch()?
> 
> Ditto vmcore_elf_check_arch_cross()?

BTW, it would be nice to have some Acked-by's or other attributations on
this patch, so it looks like it had some review.
