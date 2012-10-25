Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2JYWwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 18:52:36 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41512 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751780Ab2JYWwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 18:52:35 -0400
Message-ID: <5089C2B0.6050900@xenotime.net>
Date: Thu, 25 Oct 2012 15:52:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, festevam@gmail.com
Subject: Re: [PATCH] regmap: Fix printing of size_t variable
References: <1351181238-25568-1-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1351181238-25568-1-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 09:07 AM, Fabio Estevam wrote:

> val_bytes is of 'size_t', so it should be printed as '%zu'.
> 
> Fixes the following build warning on x86:
> 
> drivers/base/regmap/regmap.c:872:4: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat]
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

http://marc.info/?l=linux-kernel&m=135041943424273&w=2


> ---
>  drivers/base/regmap/regmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 0585726..cc90dfc 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -869,7 +869,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
>  
>  		/* If the write goes beyond the end of the window split it */
>  		while (val_num > win_residue) {
> -			dev_dbg(map->dev, "Writing window %d/%d\n",
> +			dev_dbg(map->dev, "Writing window %d/%zu\n",
>  				win_residue, val_len / map->format.val_bytes);
>  			ret = _regmap_raw_write(map, reg, val, win_residue *
>  						map->format.val_bytes);



-- 
~Randy
