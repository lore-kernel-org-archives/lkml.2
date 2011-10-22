Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1JVVnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 17:43:35 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:60699 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961Ab1JVVnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 17:43:35 -0400
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Paul Schilling <paul.s.schilling@gmail.com>
Subject: Re: [PATCH 06/14] ARM : SAMSUNG : S3C2416 Added io mapping for Static memory controller.
Date: Sat, 22 Oct 2011 23:43:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <static_memory> <1319257301-5040-1-git-send-email-paul.s.schilling@gmail.com>
In-Reply-To: <1319257301-5040-1-git-send-email-paul.s.schilling@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110222343.24141.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 22 Oktober 2011, 06:21:41 schrieb Paul Schilling:
> Added MMU access to the Static Memory Controller.
> 
> Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
> ---
>  arch/arm/mach-s3c2416/s3c2416.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2416/s3c2416.c
> b/arch/arm/mach-s3c2416/s3c2416.c index 494ce91..823a034 100644
> --- a/arch/arm/mach-s3c2416/s3c2416.c
> +++ b/arch/arm/mach-s3c2416/s3c2416.c
> @@ -65,6 +65,18 @@ static struct map_desc s3c2416_iodesc[] __initdata = {
>  	IODESC_ENT(WATCHDOG),
>  	IODESC_ENT(CLKPWR),
>  	IODESC_ENT(TIMER),
> +	{
> +		.virtual	= (u32)S3C2412_VA_SSMC,
> +		.pfn		= __phys_to_pfn(S3C2412_PA_SSMC),
> +		.length		= SZ_1M,
> +		.type		= MT_DEVICE,
> +	},
> +	/*{
> +		.virtual	= (u32)S3C2412_VA_EBI,
> +		.pfn		= __phys_to_pfn(S3C2412_PA_EBI),
> +		.length		= SZ_1M,
> +		.type		= MT_DEVICE,
> +	},*/
>  };
why are you adding disabled code?

Btw. it seems your posts got mangled somehow... only your patches 2,5 and 6 of 
14 made it to linux-kernel and linux-arm-kernel.

Heiko
