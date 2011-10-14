Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1JNHOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:14:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14280 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab1JNHOT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:14:19 -0400
X-AuditID: cbfee61b-b7b7fae000005864-0e-4e97e14a1e6f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1313463881.16359.2.camel@phoenix>
In-reply-to: <1313463881.16359.2.camel@phoenix>
Subject: RE: [PATCH] ARM: S3C2443: Remove redundant s3c_register_clocks call
 for init_clocks
Date: Fri, 14 Oct 2011 16:14:18 +0900
Message-id: <086001cc8a40$e3940350$aabc09f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcxbwVPSxqJTI7fjTVms3Um8SvQ/6wufQD7g
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> 
> Since commit af337f3e633a198034a99450416257ddf2307497
> "ARM: S3C2443: Move parts of the clock code to common clock file",
> the init_clocks array is moved to arch/arm/plat-s3c24xx/s3c2443-clock.c.
> Now we call s3c_register_clocks for init_clocks in s3c2443_common_init_clocks.
> 
> Thus we can remove the empty init_clocks array here and remove the
> redundant s3c_register_clocks call for init_clocks in s3c2443_init_clocks.
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
> --
> 1.7.4.1

Looks ok, applied.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

