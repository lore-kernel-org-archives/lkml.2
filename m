Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0JRBD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 21:03:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11341 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab0JRBDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 21:03:54 -0400
Date: Mon, 18 Oct 2010 10:04:11 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the s5p tree with the arm tree
In-reply-to: <20101018105524.e2460535.sfr@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Nicolas Pitre'" <nicolas.pitre@linaro.org>,
        "'Russell King'" <rmk@arm.linux.org.uk>
Message-id: <03fa01cb6e60$6189d5d0$249d8170$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActuVsWBIMsRVFYYQQ6NHQKvyaUTYgACTD3g
References: <20101018105524.e2460535.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen wrote:
> 
> Hi Kukjin,
> 
Hi ;-)

> Today's linux-next merge of the s5p tree got a conflict in
> arch/arm/mach-s5p64x0/mach-smdk6440.c between commit
> 861bd81ee62a0d6759144c22909a8a3938951656 ("arm: remove
> machine_desc.io_pg_offst and .phys_io") from the arm tree and commit
> cae6a3066d19a0c8b69cb25ee42b949ad6fb8c66 ("ARM: S5P64X0: Move SMDK6440
> board file and Add SMDK6450 board file") from the s5p tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.  I also
> applied the following merge fix patch:
> 
Ok...thanks, if need any my handling, please let me know.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 18 Oct 2010 10:52:24 +1100
> Subject: [PATCH] s5p: merge fix for removal of fielda from machine_desc
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/arm/mach-s5p64x0/mach-smdk6450.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-s5p64x0/mach-smdk6450.c b/arch/arm/mach-
> s5p64x0/mach-smdk6450.c
> index 8e98217..d609f5a 100644
> --- a/arch/arm/mach-s5p64x0/mach-smdk6450.c
> +++ b/arch/arm/mach-s5p64x0/mach-smdk6450.c
> @@ -171,8 +171,6 @@ static void __init smdk6450_machine_init(void)
> 
>  MACHINE_START(SMDK6450, "SMDK6450")
>  	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
> -	.phys_io	= S5P6450_PA_UART(0) & 0xfff00000,
> -	.io_pg_offst	= (((u32)S3C_VA_UART) >> 18) & 0xfffc,
>  	.boot_params	= S5P64X0_PA_SDRAM + 0x100,
> 
>  	.init_irq	= s5p6450_init_irq,
> --
> 1.7.1
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-s5p64x0/mach-smdk6440.c
> index 59d9f5b,28de0a5..0000000
> --- a/arch/arm/mach-s5p64x0/mach-smdk6440.c
> +++ b/arch/arm/mach-s5p64x0/mach-smdk6440.c
> @@@ -135,7 -152,9 +152,7 @@@ static void __init smdk6440_machine_ini
> 
>   MACHINE_START(SMDK6440, "SMDK6440")
>   	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
> - 	.boot_params	= S5P_PA_SDRAM + 0x100,
>  -	.phys_io	= S5P6440_PA_UART(0) & 0xfff00000,
>  -	.io_pg_offst	= (((u32)S3C_VA_UART) >> 18) & 0xfffc,
> + 	.boot_params	= S5P64X0_PA_SDRAM + 0x100,
> 
>   	.init_irq	= s5p6440_init_irq,
>   	.map_io		= smdk6440_map_io,

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

