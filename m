Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2FJMkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 08:40:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:52185 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab2FJMkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 08:40:12 -0400
Message-ID: <4FD4959A.4060907@atmel.com>
Date: Sun, 10 Jun 2012 14:39:54 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: <trivial@kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] trivial: treewide: remove extra semicolon added by module_init/exit
References: <1338990069-6627-1-git-send-email-balbi@ti.com>
In-Reply-To: <1338990069-6627-1-git-send-email-balbi@ti.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.49.60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Not putting everybody in copy, but still replying)

Felipe,

On 06/06/2012 03:41 PM, Felipe Balbi :
> The definition of module_init() and module_exit()
> already added the final semicolon creating a situation
> where most of our drivers end up with two semicolons
> at the end of every module_init()/module_exit() call.
> 
> To fix that, we add missing semicolons to the places
> which didn't have them and remove the semicolons from
> the definition of module_init/module_exit.
> 
> Patch generated with the following sed script:
> 
> $ sed -i 's/^module_\(init\|exit\)\s*\((\w\+)\)$/module_\1\2;/g' \
> 	$(git ls-files)
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> 
> compile tested with allyesconfig, allnoconfig and allmodconfig on
> x86 only.
> 
> Unfortunately I couldn't Cc everybody on get_maintainer.pl's output
> due to recipient limits on TI's mail server.

[..]

>  drivers/net/ethernet/cadence/at91_ether.c             |    4 ++--

[..]


> diff --git a/drivers/net/ethernet/cadence/at91_ether.c b/drivers/net/ethernet/cadence/at91_ether.c
> index 7788419..b107e7f 100644
> --- a/drivers/net/ethernet/cadence/at91_ether.c
> +++ b/drivers/net/ethernet/cadence/at91_ether.c
> @@ -1290,8 +1290,8 @@ static void __exit at91ether_exit(void)
>  	platform_driver_unregister(&at91ether_driver);
>  }
>  
> -module_init(at91ether_init)
> -module_exit(at91ether_exit)
> +module_init(at91ether_init);
> +module_exit(at91ether_exit);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("AT91RM9200 EMAC Ethernet driver");

For this Atmel network driver, you can add my:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Best regards,
-- 
Nicolas Ferre
