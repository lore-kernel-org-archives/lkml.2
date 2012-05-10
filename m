Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab2EJJZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:25:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27651 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab2EJJZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:25:18 -0400
X-AuditID: cbfee61a-b7b97ae000004342-c2-4fab897c7f1a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "=?utf-8?Q?'Jos=C3=A9_Miguel_Gon=C3=A7alves'?=" 
	<jose.goncalves@inov.pt>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1336607209-6409-1-git-send-email-jose.goncalves@inov.pt>
In-reply-to: <1336607209-6409-1-git-send-email-jose.goncalves@inov.pt>
Subject: RE: [PATCH] ARM: SAMSUNG: Fix for S3C2412 EBI memory mapping.
Date: Thu, 10 May 2012 18:25:16 +0900
Message-id: <036701cd2e8e$cf4cc100$6de64300$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0uPmPAymWmPA6UTlGLxP931XpqWAAT+MDA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

José Miguel Gonçalves wrote:
> 
> While upgrading the kernel on a S3C2412 based board I've noted that it was
> impossible to boot the board with a 2.6.32 or upper kernel.
> I've tracked down the problem to the EBI virtual memory mapping that is in
> conflict with the IO mapping definition in arch/arm/mach-s3c24xx/s3c2412.c.
> 
> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> ---
>  arch/arm/plat-samsung/include/plat/map-s3c.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/include/plat/map-s3c.h b/arch/arm/plat-
> samsung/include/plat/map-s3c.h
> index 7d04875..c0c70a8 100644
> --- a/arch/arm/plat-samsung/include/plat/map-s3c.h
> +++ b/arch/arm/plat-samsung/include/plat/map-s3c.h
> @@ -22,7 +22,7 @@
>  #define S3C24XX_VA_WATCHDOG	S3C_VA_WATCHDOG
> 
>  #define S3C2412_VA_SSMC		S3C_ADDR_CPU(0x00000000)
> -#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00010000)
> +#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00100000)
> 
>  #define S3C2410_PA_UART		(0x50000000)
>  #define S3C24XX_PA_UART		S3C2410_PA_UART
> --
> 1.7.5.4

Yeah, as you said, the mapping for SSMC invade EBI area but I think, just SZ_4K is enough for SSMC. So following is better in this case. How do you think? And there is no problem on your board?

diff --git a/arch/arm/mach-s3c24xx/s3c2412.c b/arch/arm/mach-s3c24xx/s3c2412.c
index d4bc7f9..ac906bf 100644
--- a/arch/arm/mach-s3c24xx/s3c2412.c
+++ b/arch/arm/mach-s3c24xx/s3c2412.c
@@ -72,7 +72,7 @@ static struct map_desc s3c2412_iodesc[] __initdata = {
 	{
 		.virtual = (unsigned long)S3C2412_VA_SSMC,
 		.pfn     = __phys_to_pfn(S3C2412_PA_SSMC),
-		.length  = SZ_1M,
+		.length  = SZ_4K,
 		.type    = MT_DEVICE,
 	},
 	{

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

