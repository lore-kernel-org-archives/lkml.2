Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965474Ab2CPI0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:26:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965186Ab2CPI0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:26:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the s5p tree
Date: Fri, 16 Mar 2012 08:26:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
References: <20120316174546.5121be30a86c2937579bd3f5@canb.auug.org.au>
In-Reply-To: <20120316174546.5121be30a86c2937579bd3f5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203160826.36287.arnd@arndb.de>
X-Provags-ID: V02:K0:0uttrRaKWIcDvoL3MOEZ0mNM3oT58V11dDjVzJN81jq
 xDpJidGHVTJqz1Oeni+KpKYyzVFKZzsvDZjpiwNogOR0jUc7n7
 eXZ540SmtyOwwVNeLb8blSTzhEYwtYJpkeG/FOHXqJRyNV/iBR
 9Yi7j8UWf5uX3sqkCgv5HZUC3mbZIqeStq78y0bS5E2hdb0ASx
 26cZn3k2mGnim7FUXeh9FiqJB5k7cGnvS5/SQT0J7/NKNNtdzg
 +BSS1IO7nI3gKnuLhtZ8fe5ETTLof9IaLJpkg4RyKwLa3ZCcLR
 jM1ZlPtmE1rqX36gN8dHuiwXa6qiHNJpTkjsdoIfR1c9spo6T/
 6NMBoTjFZLGokf1j9swY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-exynos/common.c between commit 1d7233ac478a ("Merge branch
> 'next/soc-exynos5250-arch-gpio' into for-next") from the s5p tree and
> commit 853a0231e057 ("Merge branch 'samsung/soc' into next/soc2") from
> the arm-soc tree.
> 
> These merge commits both looks suspect, but I fixed it up as best I could
> (see below).

Right, both the arm-soc and the s5p tree merge the same commits and
come to different results. Kgene, please have a look and let me know
which of the three solutions is correct.

	Arnd

> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-exynos/common.c
> index 4e1d0b7,e6cc50e..0000000
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@@ -593,6 -586,14 +593,13 @@@ static int __init exynos4_l2x0_cache_in
>         if (soc_is_exynos5250())
>                 return 0;
>   
>  -      int ret;
> +       ret = l2x0_of_init(L2_AUX_VAL, L2_AUX_MASK);
> +       if (!ret) {
> +               l2x0_regs_phys = virt_to_phys(&l2x0_saved_regs);
> +               clean_dcache_area(&l2x0_regs_phys, sizeof(unsigned long));
> +               return 0;
> +       }
> + 
>         if (!(__raw_readl(S5P_VA_L2CC + L2X0_CTRL) & 0x1)) {
>                 l2x0_saved_regs.phy_base = EXYNOS4_PA_L2CC;
>                 /* TAG, Data Latency Control: 2 cycles */

