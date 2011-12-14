Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab1LNLOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:14:44 -0500
Received: from d1.icnet.pl ([212.160.220.21]:45399 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab1LNLOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:14:41 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 01/10] GPIO: gpio-generic: Move initialization up to postcore
Date: Wed, 14 Dec 2011 12:13:51 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl> <1323634328-856-2-git-send-email-jkrzyszt@tis.icnet.pl>
In-Reply-To: <1323634328-856-2-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112141213.51610.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 of December 2011 at 21:11:59, Janusz Krzysztofik wrote:
> This will allow boards with custom memory mapped GPIO ports to set up
> and use those port pins while initializing devices from arch init.

Please ignore this patch, I'm going to submit a replacement, based on an 
alternative approach suggested by Tony.

Thanks,
Janusz

> Created against linux-3.2-rc5.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
>  drivers/gpio/gpio-generic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> index 4e24436..a6eaf38 100644
> --- a/drivers/gpio/gpio-generic.c
> +++ b/drivers/gpio/gpio-generic.c
> @@ -528,7 +528,7 @@ static int __init bgpio_platform_init(void)
>  {
>  	return platform_driver_register(&bgpio_driver);
>  }
> -module_init(bgpio_platform_init);
> +postcore_initcall(bgpio_platform_init);
>  
>  static void __exit bgpio_platform_exit(void)
>  {
> 
