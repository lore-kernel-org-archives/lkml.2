Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2ILUbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:31:34 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57007 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2ILUbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:31:33 -0400
Date: Wed, 12 Sep 2012 16:31:29 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Rob Herring <robherring2@gmail.com>
cc: Cyril Chemparathy <cyril@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux@openrisc.net, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, x86@kernel.org,
        david.daney@cavium.com, benh@kernel.crashing.org,
        bigeasy@linutronix.de, grant.likely@secretlab.ca,
        paul.gortmaker@windriver.com, paulus@samba.org, hpa@zytor.com,
        m.szyprowski@samsung.com, jonas@southpole.se, linux@arm.linux.org.uk,
        a-jacquiot@ti.com, mingo@redhat.com, suzuki@in.ibm.com,
        mahesh@linux.vnet.ibm.com, linus.walleij@linaro.org, arnd@arndb.de,
        msalter@redhat.com, rob.herring@calxeda.com, tglx@linutronix.de,
        blogic@openwrt.org, dhowells@redhat.com, monstr@monstr.eu,
        ralf@linux-mips.org, tj@kernel.org
Subject: Re: [PATCH] of: specify initrd location using 64-bit
In-Reply-To: <5050EF3F.6030003@gmail.com>
Message-ID: <alpine.LFD.2.02.1209121629260.28681@xanadu.home>
References: <1347465937-7056-1-git-send-email-cyril@ti.com> <5050EF3F.6030003@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Rob Herring wrote:

> On 09/12/2012 11:05 AM, Cyril Chemparathy wrote:
> > On some PAE architectures, the entire range of physical memory could reside
> > outside the 32-bit limit.  These systems need the ability to specify the
> > initrd location using 64-bit numbers.
> > 
> > This patch globally modifies the early_init_dt_setup_initrd_arch() function to
> > use 64-bit numbers instead of the current unsigned long.
> 
> S-o-B?
> 
> > ---
> >  arch/arm/mm/init.c            |    2 +-
> >  arch/c6x/kernel/devicetree.c  |    3 +--
> >  arch/microblaze/kernel/prom.c |    3 +--
> >  arch/mips/kernel/prom.c       |    3 +--
> >  arch/openrisc/kernel/prom.c   |    3 +--
> >  arch/powerpc/kernel/prom.c    |    3 +--
> >  arch/x86/kernel/devicetree.c  |    3 +--
> >  drivers/of/fdt.c              |   10 ++++++----
> >  include/linux/of_fdt.h        |    3 +--
> >  9 files changed, 14 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > index ad722f1..579792c 100644
> > --- a/arch/arm/mm/init.c
> > +++ b/arch/arm/mm/init.c
> > @@ -76,7 +76,7 @@ static int __init parse_tag_initrd2(const struct tag *tag)
> >  __tagtable(ATAG_INITRD2, parse_tag_initrd2);
> >  
> >  #ifdef CONFIG_OF_FLATTREE
> > -void __init early_init_dt_setup_initrd_arch(unsigned long start, unsigned long end)
> > +void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
> 
> phys_initrd_start/size need to change too. Not sure about similar things
> on other arches.

size ?


Nicolas
