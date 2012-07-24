Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2GXTY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:24:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2GXTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:24:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cyril Chemparathy <cyril@ti.com>
Subject: Re: [RFC 21/23] ARM: keystone: introducing TI Keystone platform
Date: Tue, 24 Jul 2012 18:45:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nico@linaro.org, will.deacon@arm.com, catalin.marinas@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <201207241446.53401.arnd@arndb.de> <500EE1CD.6030701@ti.com>
In-Reply-To: <500EE1CD.6030701@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207241845.57784.arnd@arndb.de>
X-Provags-ID: V02:K0:tZ9ttKzVOweaF3jkZJAVqRis5d2dq1FA66ABjggMhVi
 PtJT5UNIptCLf1WlHS9gDiZbwmuvf+IdasCZMtlzF3kT7Ooi+q
 qeZ9NsmMwS1XR6P0XQXBqeu1a1miBtH1LkHmzsj1lnpy/PPh+y
 0Z7Ympa+E+N15h4ybxSUDuLjfXU78h3/3gRn3FKylBLBJ1T5Mm
 t27opBjJPNcB/8Q5TPtVqNrg2gfCJGMOQiZ7wx0OHfkn/j2P4d
 C/wWpj/voanHdKNpToptrU5Jx/kGmnzknSaBb0O62StGWp0sym
 PAN7yvAOu01TzdqFxWfnNfe6hadZBEkuWo+olmZk3j0GnssAIJ
 vQxZ9r8LvXCSCbEoP5aA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2012, Cyril Chemparathy wrote:
> >> diff --git a/arch/arm/mach-keystone/include/mach/memory.h b/arch/arm/mach-keystone/include/mach/memory.h
> >> new file mode 100644
> >> index 0000000..7c78b1e
> >> --- /dev/null
> >> +++ b/arch/arm/mach-keystone/include/mach/memory.h
> >
> >> +#ifndef __ASM_MACH_MEMORY_H
> >> +#define __ASM_MACH_MEMORY_H
> >> +
> >> +#define MAX_PHYSMEM_BITS    36
> >> +#define SECTION_SIZE_BITS   34
> >> +
> >> +#endif /* __ASM_MACH_MEMORY_H */
> >
> > I wonder if there is anything we can do to make these generic. What you
> > have here is ok for now, but we will need to do this differently once
> > we are building multiplatform kernels with keystone and sparse memory.
> >
> 
> Understood.  Any ideas on the general direction towards solving this?

I can't remember discussing this in the past. Maybe it never came up
because most platforms don't enable sparsemem.

IIRC this is done through Kconfig on powerpc, where we pick the minimum
required size based on which platforms are enabled.

I also don't know what to do about ARM_PATCH_PHYS_VIRT here: my
impression so far was that we would enable it for all multiplatform
builds, but it conflicts with sparsemem.

> >> +DT_MACHINE_START(KEYSTONE, "Keystone")
> >> +    .map_io         = keystone_map_io,
> >> +    .init_irq       = keystone_init_irq,
> >> +    .timer          = &keystone_timer,
> >> +    .handle_irq     = gic_handle_irq,
> >> +    .init_machine   = keystone_init,
> >> +    .dt_compat      = keystone_match,
> >> +    .nr_irqs        = 480,
> >> +MACHINE_END
> >
> > IIRC, you don't need to set the nr_irqs this high in advance,
> > they will be allocated automatically since you have enabled
> > sparse IRQs.
> >
> 
> We were seeing a complaint without nr_irqs set, but I'll dig into that 
> further.

Maybe a driver that hardcodes an IRQ number?

	Arndx
