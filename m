Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0K3PjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:39:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47398 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab0K3PjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:39:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=w8Fy+Ea7raN00WA+ez4H8iAdFdVTwZNZKFv9GT3xWbio9dSjNs82QzMjzwGLaCparB
         CGUSJpTCa/mBWRa6w3qoocw3ZHOt5/UvDWYVMuXGKXokBdNcpLF1iKKrwZKiC0GDuV9+
         CHXx5CtXZcCSRr6FbXJJefYyBaJRwfyJzp1fc=
Date: Tue, 30 Nov 2010 16:38:54 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
X-X-Sender: elektroman@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
In-Reply-To: <201011291657.53316.arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1011301633040.9052@localhost.localdomain>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <20101129142200.GA14941@n2100.arm.linux.org.uk> <alpine.LNX.2.00.1011291546550.12293@localhost.localdomain> <201011291657.53316.arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Nov 2010, Arnd Bergmann wrote:

> On Monday 29 November 2010, Hans Ulli Kroll wrote:
> > @@ -1164,7 +1169,7 @@ config ISA_DMA_API
> >         bool
> >  
> >  config PCI
> > -       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || 
> > ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
> > +       bool "PCI support" if MIGHT_HAVE_PCI
> >         help
> >           Find out whether you have a PCI motherboard. PCI is the name of 
> > a
> >           bus system, i.e. the way the CPU talks to the other stuff inside
> 
> This does not solve the problem that Russell mentioned: existing platforms
> select PCI unconditionally, e.g. Iop13XX, some IXP, Orion, Shark
> and more. At the very least, these would need to also select MIGHT_HAVE_PCI
> to avoid the warning.
> 

so 
select MIGHT_HAVE_PCI 
in conjunction of
select PCI
on other almost platforms 

> > index fe0c82e..f5c39a8 100644
> > --- a/arch/arm/mach-ks8695/Kconfig
> > +++ b/arch/arm/mach-ks8695/Kconfig
> > @@ -4,6 +4,7 @@ menu "Kendin/Micrel KS8695 Implementations"
> >  
> >  config MACH_KS8695
> >         +++ b/arch/arm/mach-versatile/Kconfig
> > @@ -4,6 +4,7 @@ menu "Versatile platform type"
> >  config ARCH_VERSATILE_PB
> >         bool "Support Versatile/PB platform"
> >         select CPU_ARM926T
> > +       select HAVE_PCI
> >         default y
> >         help
> >           Include support for the ARM(R) Versatile/PB platform.bool 
> 
> Typo: you certainly meant MIGHT_HAVE_PCI here.
> 

Damn, I missed this.
HAVE_PCI was my first approach to do this.

> We still need to agree on what it should be doing, but otherwise this
> is what I had in mind.
> 
> 	Arnd
> 


