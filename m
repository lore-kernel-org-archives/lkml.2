Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1HPHK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:10:56 -0400
Received: from h1778886.stratoserver.net ([85.214.133.74]:36276 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1HPHKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:10:55 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Aug 2011 03:10:55 EDT
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: S3C2443: Remove redundant s3c_register_clocks call for init_clocks
Date: Tue, 16 Aug 2011 08:48:22 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>
References: <1313463881.16359.2.camel@phoenix>
In-Reply-To: <1313463881.16359.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108160848.25088.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. August 2011, 05:04:41 schrieb Axel Lin:
> Since commit af337f3e633a198034a99450416257ddf2307497
> "ARM: S3C2443: Move parts of the clock code to common clock file",
> the init_clocks array is moved to arch/arm/plat-s3c24xx/s3c2443-clock.c.
> Now we call s3c_register_clocks for init_clocks in
> s3c2443_common_init_clocks.
> 
> Thus we can remove the empty init_clocks array here and remove the
> redundant s3c_register_clocks call for init_clocks in s3c2443_init_clocks.
I'm not 100% sure, but you might want to include Kukjin Kim 
<kgene.kim@samsung.com> who seems to be handling the Samsung-stuff most of the 
time.

Heiko

> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/mach-s3c2443/clock.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2443/clock.c b/arch/arm/mach-s3c2443/clock.c
> index a1a7176..4018dbe 100644
> --- a/arch/arm/mach-s3c2443/clock.c
> +++ b/arch/arm/mach-s3c2443/clock.c
> @@ -305,9 +305,6 @@ static struct clk init_clocks_off[] = {
>  	}
>  };
> 
> -static struct clk init_clocks[] = {
> -};
> -
>  /* clocks to add straight away */
> 
>  static struct clksrc_clk *clksrcs[] __initdata = {
> @@ -345,10 +342,6 @@ void __init s3c2443_init_clocks(int xtal)
>  	for (ptr = 0; ptr < ARRAY_SIZE(clksrcs); ptr++)
>  		s3c_register_clksrc(clksrcs[ptr], 1);
> 
> -	/* register clocks from clock array */
> -
> -	s3c_register_clocks(init_clocks, ARRAY_SIZE(init_clocks));
> -
>  	/* We must be careful disabling the clocks we are not intending to
>  	 * be using at boot time, as subsystems such as the LCD which do
>  	 * their own DMA requests to the bus can cause the system to lockup

