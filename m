Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642Ab0HMNKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:10:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53631 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761578Ab0HMNKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qWUFXJGPqso1ANrDUlRxqy1zIR1Ek3g+V39cNUlbJqD4+FAy+fyhbr/8Fc0NdQQggW
         ijTYW7WaLsEsjjkkbmPRnrZyM11BL17GFApGU25q6FcxGi5mdNOH2BXssYw/x+y+W9or
         oaZRLQ8Hs1SwGyeu3IU4jZh7Tl9sw0UtSLpNk=
Subject: Re: [REGRESSION 2.6.35+] crash (maybe kmemleak related)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <1281695919.25390.31.camel@e102109-lin.cambridge.arm.com>
References: <AANLkTi=uD1FAPcu1_dVy_KhnqHwqj1rjpZTA8bn96q9i@mail.gmail.com>
	 <1281695919.25390.31.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 16:10:30 +0300
Message-ID: <1281705030.4160.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 11:38 +0100, Catalin Marinas wrote: 
> On Fri, 2010-08-13 at 11:28 +0100, Pekka Enberg wrote:
> > On Fri, Aug 13, 2010 at 12:26 PM, Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > > This kmemleak warning tells us that the kmemleak_alloc() hook got called
> > > with a pointer (0xffff880079fe6000) that's already registered with
> > > kmemleak. The first trace tells us where the hook gets called from while
> > > the second trace shows the details of the already existing pointer.
> > >
> > > So __getname() allocates the same 4096 bytes block twice via
> > > kmem_cache_alloc() but there is no kmemleak_free() call between them and
> > > kmemleak gives up. It disables itself but does not panic the system.
> > >
> > > Pekka, were there any recent changes in the slab/slob/slub area and
> > > maybe a kmemleak_free() hook is missing? Or maybe something else went
> > > wrong with the slab allocator and returns an already allocated block?
> > >
> > >> <0>[   24.578578] general protection fault: 0000 [#1] PREEMPT SMP
> > >
> > > That's what's causing the fault but it doesn't seem to be related to
> > > kmemleak.
> > 
> > Looking at Maxim's log, slab seems to be corrupted. I don't see
> > anything obviously wrong with SLUB (which he is using) kmemleak hooks
> > so it doesn't look like a slab allocator problem either. Could this be
> > related to the bootmem kmemleak hook changes?
> 
> I don't think in this case since both allocations came via
> kmem_cache_alloc() (and not one from bootmem and the other from slab, as
> it happened to me in the past). But it's worth trying with kmemleak
> disabled.


Thank you.
I will try all the suggestions soon.

Best regards,
Maxim Levitsky


