Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2LEXvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:51:39 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40110 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2LEXvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:51:37 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH -next] powerpc/85xx: use for_each_compatible_node() macro
To: Wei Yongjun <weiyj.lk@gmail.com>, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulus@samba.org, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd_esknTwVv4EeehwSJz6ee5eFJ+zf6xntH-vaNwdxkrvg@mail.gmail.com>
References: <CAPgLHd_esknTwVv4EeehwSJz6ee5eFJ+zf6xntH-vaNwdxkrvg@mail.gmail.com>
Date: Wed, 05 Dec 2012 23:51:27 +0000
Message-Id: <20121205235127.DB25F3E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012 08:36:03 -0500, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Use for_each_compatible_node() macro instead of open coding it.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/powerpc/platforms/85xx/mpc85xx_mds.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> index bd12588..a7b3621 100644
> --- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> +++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> @@ -206,9 +206,7 @@ static void __init mpc85xx_mds_reset_ucc_phys(void)
>  		setbits8(&bcsr_regs[7], BCSR7_UCC12_GETHnRST);
>  		clrbits8(&bcsr_regs[8], BCSR8_UEM_MARVELL_RST);
>  
> -		for (np = NULL; (np = of_find_compatible_node(np,
> -						"network",
> -						"ucc_geth")) != NULL;) {
> +		for_each_compatible_node(np, "network", "ucc_geth") {
>  			const unsigned int *prop;
>  			int ucc_num;
>  
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
