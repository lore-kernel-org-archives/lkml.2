Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1LLSFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:05:06 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24445 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751373Ab1LLSFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:05:00 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19fQ2kPjiA4NvXnFrHh+9b6
Date: Mon, 12 Dec 2011 10:04:56 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] GPIO: gpio-generic: Move initialization up to
 postcore
Message-ID: <20111212180456.GF31337@atomide.com>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1323634328-856-2-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323634328-856-2-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111211 11:41]:
> This will allow boards with custom memory mapped GPIO ports to set up
> and use those port pins while initializing devices from arch init.

Care to explain a bit more why you need to initialize those devices
early on?

Usually moving things earlier and earlier is an endless loop 
adding more and more nasty dependencies..

I'd rather see things getting initialized later as regular
device drivers so we have decent kernel error messages when
something goes wrong without having to enable debug_ll.

Regards,

Tony


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
> -- 
> 1.7.3.4
> 
