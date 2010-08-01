Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0HAVXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 17:23:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37257 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0HAVXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 17:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cyn+Q7yylpXPLfjTgrHfvDRRpwH1N02qpkX5crHH1c+dmQ74e01ccjjK8MlnClxT2T
         28xK7ozdAIZkVrejHJK/RsrxcCBP4aQsQ2ZC86gPReOlcQKF2AWhOAiUnBWtxXFRtu74
         BI3KAOQM1zw3V7kt85HUI3icgoaXZaS15tSRE=
MIME-Version: 1.0
In-Reply-To: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Sun, 1 Aug 2010 23:23:35 +0200
Message-ID: <AANLkTi=hPg-12w9ihz-RsvD0d6Zawus14qF9hamA6nES@mail.gmail.com>
Subject: Re: [PATCH 01/11] ARM: cam60: move cam60_spi_devices to .init.data
From: "avictor.za@gmail.com" <avictor.za@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "Samuel R. C. Vale" <srcvale@holoscopio.com>,
        Jiri Kosina <jkosina@suse.cz>, Andrew Victor <linux@maxim.org.za>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> cam60_spi_devices is passed to at91_add_device_spi which calls
> spi_register_board_info.  The latter makes a copy of it, so living in
> .init.data is OK.

The  copy still maintains a pointers to
"cam60_spi_flash_platform_data", so I'm wondering if that and
"cam60_spi_partitions" should maybe not be marked as __initdata.


Regards,
  Andrew Victor



> ---
>  arch/arm/mach-at91/board-cam60.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
> index 02138af..05c7072 100644
> --- a/arch/arm/mach-at91/board-cam60.c
> +++ b/arch/arm/mach-at91/board-cam60.c
> @@ -98,14 +98,14 @@ static struct mtd_partition __initdata cam60_spi_partitions[] = {
>        },
>  };
>
> -static struct flash_platform_data __initdata cam60_spi_flash_platform_data = {
> +static struct flash_platform_data cam60_spi_flash_platform_data __initdata = {
>        .name           = "spi_flash",
>        .parts          = cam60_spi_partitions,
>        .nr_parts       = ARRAY_SIZE(cam60_spi_partitions)
>  };
>  #endif
>
> -static struct spi_board_info cam60_spi_devices[] = {
> +static struct spi_board_info cam60_spi_devices[] __initdata = {
>  #if defined(CONFIG_MTD_DATAFLASH)
>        {       /* DataFlash chip */
>                .modalias       = "mtd_dataflash",
