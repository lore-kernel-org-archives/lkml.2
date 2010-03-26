Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0CZObL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:31:11 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:47753 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0CZObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:31:08 -0400
Message-ID: <4BACC526.7090109@monstr.eu>
Date: Fri, 26 Mar 2010 15:31:02 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/7] uartlite: Fix build on sparc.
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-3-git-send-email-gregkh@suse.de>
In-Reply-To: <1269011916-8836-3-git-send-email-gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> From: David Miller <davem@davemloft.net>
> 
> We can get this driver enabled via MFD_TIMBERDALE which only
> requires GPIO to be on.
> 
> But the of_address_to_resource() function is only present on
> powerpc and microblaze, so we have to conditionalize the
> CONFIG_OF probing bits on that.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/serial/uartlite.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
> index ab2ab3c..f0a6c61 100644
> --- a/drivers/serial/uartlite.c
> +++ b/drivers/serial/uartlite.c
> @@ -19,7 +19,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <asm/io.h>
> -#if defined(CONFIG_OF)
> +#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))

What about do this in Kconfig?

Michal

>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/of_platform.h>
> @@ -581,7 +581,7 @@ static struct platform_driver ulite_platform_driver = {
>  /* ---------------------------------------------------------------------
>   * OF bus bindings
>   */
> -#if defined(CONFIG_OF)
> +#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
>  static int __devinit
>  ulite_of_probe(struct of_device *op, const struct of_device_id *match)
>  {
> @@ -631,11 +631,11 @@ static inline void __exit ulite_of_unregister(void)
>  {
>  	of_unregister_platform_driver(&ulite_of_driver);
>  }
> -#else /* CONFIG_OF */
> -/* CONFIG_OF not enabled; do nothing helpers */
> +#else /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
> +/* Appropriate config not enabled; do nothing helpers */
>  static inline int __init ulite_of_register(void) { return 0; }
>  static inline void __exit ulite_of_unregister(void) { }
> -#endif /* CONFIG_OF */
> +#endif /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
>  
>  /* ---------------------------------------------------------------------
>   * Module setup/teardown


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
