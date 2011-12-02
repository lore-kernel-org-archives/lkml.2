Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1LBInk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:43:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42359 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab1LBInj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:43:39 -0500
X-AuditID: cbfee61b-b7bdbae000001970-d5-4ed88fb9e6ea
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Marc Zyngier'" <marc.zyngier@arm.com>, "'Axel Lin'" <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <1322753070.11611.0.camel@phoenix> <4ED7ADCE.8040609@arm.com>
In-reply-to: <4ED7ADCE.8040609@arm.com>
Subject: RE: [PATCH 1/2] ARM: exynos4: Fix build error due to 'gic_bank_offset'
 undeclared
Date: Fri, 02 Dec 2011 17:43:37 +0900
Message-id: <04f701ccb0ce$7c044d30$740ce790$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcywR9doZA/SJWqfT/6btEbxZwYRFQAgxtJA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Zyngier wrote:
> 
> On 01/12/11 15:24, Axel Lin wrote:
> > Fix below build error:
> >   CC      arch/arm/mach-exynos/cpu.o
> > arch/arm/mach-exynos/cpu.c: In function 'exynos4_init_irq':
> > arch/arm/mach-exynos/cpu.c:245: error: 'gic_bank_offset' undeclared
> (first use in this function)
> > arch/arm/mach-exynos/cpu.c:245: error: (Each undeclared identifier is
> reported only once
> > arch/arm/mach-exynos/cpu.c:245: error: for each function it appears in.)
> > arch/arm/mach-exynos/cpu.c:243: warning: unused variable 'bank_offset'
> > make[1]: *** [arch/arm/mach-exynos/cpu.o] Error 1
> > make: *** [arch/arm/mach-exynos] Error 2
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Arghhh... My bad. Thanks for fixing that.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
Hi Marc,

Since the commit 4e44d2cb("ARM: exynos4: convert to CONFIG_MULTI_IRQ_HANDLER") is not in my tree, this should be handled in your tree and Axel's patch, "ARM: exynos4: Fix build error" is too.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> > ---
> >  arch/arm/mach-exynos/cpu.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/arm/mach-exynos/cpu.c b/arch/arm/mach-exynos/cpu.c
> > index fed62f4..c7cb462 100644
> > --- a/arch/arm/mach-exynos/cpu.c
> > +++ b/arch/arm/mach-exynos/cpu.c
> > @@ -240,7 +240,7 @@ static const struct of_device_id
> exynos4_dt_irq_match[] = {
> >  void __init exynos4_init_irq(void)
> >  {
> >  	int irq;
> > -	unsigned int bank_offset;
> > +	unsigned int gic_bank_offset;
> >
> >  	gic_bank_offset = soc_is_exynos4412() ? 0x4000 : 0x8000;
> >
> 
> 
> --
> Jazz is not dead. It just smells funny...

