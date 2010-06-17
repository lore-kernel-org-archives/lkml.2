Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab0FQUic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:38:32 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56323 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757466Ab0FQUi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:38:28 -0400
Subject: Re: [PATCH 1/5] vmlinux.lds.h: Include *(.text.*) in TEXT_TEXT
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Matt Fleming <matt@console-pimps.org>,
       linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Michal Marek <mmarek@suse.cz>,
       Parisc List <linux-parisc@vger.kernel.org>
In-Reply-To: <AANLkTink485wn-EaLibaD3Xh7X5RwXM06d6jx3GijD40@mail.gmail.com>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
	 <alpine.DEB.1.10.1006141014360.1432@dr-wily.mit.edu>
	 <87y6ehxvby.fsf@linux-g6p1.site> <1276545951.5374.260.camel@mulgrave.site>
	 <alpine.DEB.1.10.1006141608550.1248@dr-wily.mit.edu>
	 <1276556919.5374.822.camel@mulgrave.site>
	 <alpine.DEB.1.10.1006142039250.1248@dr-wily.mit.edu>
	 <1276724403.2847.453.camel@mulgrave.site>
	 <AANLkTikgzvZvb30QhSMs_GQ6MCawl0V6GzixnDYfqmzg@mail.gmail.com>
	 <1276804567.7398.264.camel@mulgrave.site>
	 <AANLkTink485wn-EaLibaD3Xh7X5RwXM06d6jx3GijD40@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 15:38:24 -0500
Message-ID: <1276807104.7398.315.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 22:19 +0200, Denys Vlasenko wrote:
> >> This is doable in asm, yes. For .bss, we need to not forget about
> >> @nobits too: section .bss.foo,"aw",@nobits
> >
> > That's only for bss ... we have about a handful of such statements and
> > they always use the assembler .bss directive (which doesn't need flags).
> >
> >> > Actually, as I said, that would be .data-
> 
> You are right, in assembly we can specify needed attributes.
> 
> I am more concerned about C:
> 
> arch/x86/include/asm/cache.h:
> #define __read_mostly __attribute__((__section__(".data..read_mostly")))
> 
> If we change it to
> 
> #define __read_mostly __attribute__((__section__(".data-read_mostly")))
> 
> What makes this section have correct attributes?

The fact that we specify it correctly in the sectional gather in the
linker scripts.  i.e. we should have a (NOLOAD) type for the
gathered .bss section ... although currently we don't.

The point (for the third time) is that if our linker scripts specify the
sections and attributes absolutely (and correctly) it doesn't matter
what random attributes the .o files pick up.  It's only if we miss a
specifier that the linker tries to work it out from the input sections.

That's how we make postfix or any other type of "nonstandard" section
name work.

James


