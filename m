Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2GJPfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:35:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64152 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJPfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:35:20 -0400
Message-ID: <4FFC4BB5.7040604@gmail.com>
Date: Tue, 10 Jul 2012 10:35:17 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of: mtd: nuke useless const qualifier
References: <1341927604.2963.101.camel@sauron>
In-Reply-To: <1341927604.2963.101.camel@sauron>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 08:35 AM, Bityutskiy, Artem wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> This patch does the following:
>  -const int of_get_nand_ecc_mode(struct device_node *np)
>  +int of_get_nand_ecc_mode(struct device_node *np)
> 
> because:
> 1. it is probably just a typo?
> 2. it causes warnings like this when people assing the returned
>    value to an 'int' variable:
>    include/linux/of_mtd.h:14:18: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
> 
> Remove also the unnecessary "extern" qualifier to be consistent with other
> declarations in this file.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---

Applied. Next time please don't PGP sign patches.

Rob

>  drivers/of/of_mtd.c    |    2 +-
>  include/linux/of_mtd.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/of_mtd.c b/drivers/of/of_mtd.c
> index e7cad62..a27ec94 100644
> --- a/drivers/of/of_mtd.c
> +++ b/drivers/of/of_mtd.c
> @@ -32,7 +32,7 @@ static const char *nand_ecc_modes[] = {
>   * The function gets ecc mode string from property 'nand-ecc-mode',
>   * and return its index in nand_ecc_modes table, or errno in error case.
>   */
> -const int of_get_nand_ecc_mode(struct device_node *np)
> +int of_get_nand_ecc_mode(struct device_node *np)
>  {
>  	const char *pm;
>  	int err, i;
> diff --git a/include/linux/of_mtd.h b/include/linux/of_mtd.h
> index bae1b60..ed7f267 100644
> --- a/include/linux/of_mtd.h
> +++ b/include/linux/of_mtd.h
> @@ -11,7 +11,7 @@
>  
>  #ifdef CONFIG_OF_MTD
>  #include <linux/of.h>
> -extern const int of_get_nand_ecc_mode(struct device_node *np);
> +int of_get_nand_ecc_mode(struct device_node *np);
>  int of_get_nand_bus_width(struct device_node *np);
>  bool of_get_nand_on_flash_bbt(struct device_node *np);
>  #endif
> 
> 
> 
> ---------------------------------------------------------------------
> Intel Finland Oy
> Registered Address: PL 281, 00181 Helsinki 
> Business Identity Code: 0357606 - 4 
> Domiciled in Helsinki 
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> 

