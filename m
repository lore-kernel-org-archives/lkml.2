Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab0F3S1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:27:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39115 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab0F3S1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=t2AqrBcbJWMJZKAG4d75yX8ocpRS9/b5ohD8Ld0yV0Y3jVnTMeJ3p7ELhrgC16nmKe
         p1a4/vQ/QWSmRJu9yyYIIp0f2oU5aU7vpGsSmnPwrCWSM3taZBxPeyQb424TsaA4ma3C
         DsqVhVNqqSUnTYlvd1WS54FAYP1WESjlHVFkM=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Christoph Egger <siccegge@cs.fau.de>
Subject: Re: [PATCH 17/33] Removing dead SX1_OLD_FLASH
Date: Wed, 30 Jun 2010 20:24:46 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Kalle Valo <kalle.valo@iki.fi>, Ladislav Michl <ladis@linux-mips.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
References: <cover.1277911345.git.siccegge@cs.fau.de> <5b21086199b139a61888c16e92d3efe6b205dae2.1277911346.git.siccegge@cs.fau.de>
In-Reply-To: <5b21086199b139a61888c16e92d3efe6b205dae2.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006302024.47025.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 30. června 2010 17:59:25 Christoph Egger napsal(a):
> SX1_OLD_FLASH doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

There were two models of the phone made, you can toggle between old and new 
version. Maybe better documentation won't hurt.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-omap1/board-sx1.c |   26 --------------------------
>  1 files changed, 0 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/board-sx1.c
> b/arch/arm/mach-omap1/board-sx1.c index 2fb1e5f..1de809d 100644
> --- a/arch/arm/mach-omap1/board-sx1.c
> +++ b/arch/arm/mach-omap1/board-sx1.c
> @@ -295,31 +295,6 @@ static struct physmap_flash_data sx1_flash_data = {
>  	.nr_parts	= ARRAY_SIZE(sx1_partitions),
>  };
> 
> -#ifdef CONFIG_SX1_OLD_FLASH
> -/* MTD Intel StrataFlash - old flashes */
> -static struct resource sx1_old_flash_resource[] = {
> -	[0] = {
> -		.start	= OMAP_CS0_PHYS,	/* Physical */
> -		.end	= OMAP_CS0_PHYS + SZ_16M - 1,,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= OMAP_CS1_PHYS,
> -		.end	= OMAP_CS1_PHYS + SZ_8M - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -};
> -
> -static struct platform_device sx1_flash_device = {
> -	.name		= "physmap-flash",
> -	.id		= 0,
> -	.dev		= {
> -		.platform_data	= &sx1_flash_data,
> -	},
> -	.num_resources	= 2,
> -	.resource	= &sx1_old_flash_resource,
> -};
> -#else
>  /* MTD Intel 4000 flash - new flashes */
>  static struct resource sx1_new_flash_resource = {
>  	.start		= OMAP_CS0_PHYS,
> @@ -336,7 +311,6 @@ static struct platform_device sx1_flash_device = {
>  	.num_resources	= 1,
>  	.resource	= &sx1_new_flash_resource,
>  };
> -#endif
> 
>  /*----------- USB -------------------------*/
