Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2EXBGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:06:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41731 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2EXBGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:06:30 -0400
Date: Wed, 23 May 2012 18:06:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Use select .. if to get IRQ_DOMAIN enabled
In-Reply-To: <1337765513-16663-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.00.1205231805450.28167@chino.kir.corp.google.com>
References: <1337765513-16663-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Mark Brown wrote:

> Ensure that we can't get randconfig breakage by doing the IRQ_DOMAIN
> select automatically. Don't just do the select from REGMAP_IRQ to ensure
> that the select actually gets noticed.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/Kconfig |    1 +
>  drivers/mfd/Kconfig         |    3 ---
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
> index 9ef0a53..6be390b 100644
> --- a/drivers/base/regmap/Kconfig
> +++ b/drivers/base/regmap/Kconfig
> @@ -6,6 +6,7 @@ config REGMAP
>  	default y if (REGMAP_I2C || REGMAP_SPI)
>  	select LZO_COMPRESS
>  	select LZO_DECOMPRESS
> +	select IRQ_DOMAIN if REGMAP_IRQ
>  	bool
>  
>  config REGMAP_I2C

Just do the "select IRQ_DOMAIN" for REGMAP_IRQ like I did it in my patch 
and stop dropping cc's.  Thanks.
