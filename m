Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1BUUam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:30:42 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45383 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1BUUak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:30:40 -0500
Date: Mon, 21 Feb 2011 15:25:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Luciano Coelho <luciano.coelho@nokia.com>,
        Roger Quadros <roger.quadros@nokia.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] wl12xx: fix sdio_test kconfig/build errors
Message-ID: <20110221202538.GK9650@tuxdriver.com>
References: <20110217162650.092e77c3.sfr@canb.auug.org.au>
 <20110218172536.970b5b39.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218172536.970b5b39.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca, I'm merging this one...

On Fri, Feb 18, 2011 at 05:25:36PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The wl12xx sdio_test code uses wl12xx_get_platform_data, which is
> only present when WL12*_SDIO is enabled, so make WL12XX_SDIO_TEST
> depend on WL12XX_SDIO so that the needed interface will be present.
> 
> sdio_test.c:(.devinit.text+0x13178): undefined reference to `wl12xx_get_platform_data'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Luciano Coelho <luciano.coelho@nokia.com>
> Cc: Roger Quadros <roger.quadros@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20110217.orig/drivers/net/wireless/wl12xx/Kconfig
> +++ linux-next-20110217/drivers/net/wireless/wl12xx/Kconfig
> @@ -54,7 +54,7 @@ config WL12XX_SDIO
>  
>  config WL12XX_SDIO_TEST
>  	tristate "TI wl12xx SDIO testing support"
> -	depends on WL12XX && MMC
> +	depends on WL12XX && MMC && WL12XX_SDIO
>  	default n
>  	---help---
>  	  This module adds support for the SDIO bus testing with the
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
