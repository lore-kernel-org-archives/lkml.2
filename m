Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1LAQjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:39:49 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44326 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab1LAQjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:39:47 -0500
Message-ID: <4ED7ADCE.8040609@arm.com>
Date: Thu, 01 Dec 2011 16:39:42 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: exynos4: Fix build error due to 'gic_bank_offset'
 undeclared
References: <1322753070.11611.0.camel@phoenix>
In-Reply-To: <1322753070.11611.0.camel@phoenix>
X-Enigmail-Version: 1.4a1pre
X-OriginalArrivalTime: 01 Dec 2011 16:39:40.0983 (UTC) FILETIME=[D2A0EC70:01CCB047]
X-MC-Unique: 111120116394309401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/11 15:24, Axel Lin wrote:
> Fix below build error:
>   CC      arch/arm/mach-exynos/cpu.o
> arch/arm/mach-exynos/cpu.c: In function 'exynos4_init_irq':
> arch/arm/mach-exynos/cpu.c:245: error: 'gic_bank_offset' undeclared (first use in this function)
> arch/arm/mach-exynos/cpu.c:245: error: (Each undeclared identifier is reported only once
> arch/arm/mach-exynos/cpu.c:245: error: for each function it appears in.)
> arch/arm/mach-exynos/cpu.c:243: warning: unused variable 'bank_offset'
> make[1]: *** [arch/arm/mach-exynos/cpu.o] Error 1
> make: *** [arch/arm/mach-exynos] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Arghhh... My bad. Thanks for fixing that.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

> ---
>  arch/arm/mach-exynos/cpu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/cpu.c b/arch/arm/mach-exynos/cpu.c
> index fed62f4..c7cb462 100644
> --- a/arch/arm/mach-exynos/cpu.c
> +++ b/arch/arm/mach-exynos/cpu.c
> @@ -240,7 +240,7 @@ static const struct of_device_id exynos4_dt_irq_match[] = {
>  void __init exynos4_init_irq(void)
>  {
>  	int irq;
> -	unsigned int bank_offset;
> +	unsigned int gic_bank_offset;
>  
>  	gic_bank_offset = soc_is_exynos4412() ? 0x4000 : 0x8000;
>  


-- 
Jazz is not dead. It just smells funny...

