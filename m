Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab2DKNbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab2DKNbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:31:41 -0400
Date: Wed, 11 Apr 2012 09:31:26 -0400
From: Andy Gospodarek <gospo@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, netdev@vger.kernel.org,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH 09/26] tehuti: delete redundant NULL check before
 release_firmware()
Message-ID: <20120411133126.GA8258@quad.redhat.com>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1204092217250.13925@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204092217250.13925@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 10:50:42PM +0200, Jesper Juhl wrote:
> release_firmware() checks for NULL pointers - no need to test before
> the call.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>

> ---
>  drivers/net/ethernet/tehuti/tehuti.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
> index ad973ff..a445e77 100644
> --- a/drivers/net/ethernet/tehuti/tehuti.c
> +++ b/drivers/net/ethernet/tehuti/tehuti.c
> @@ -341,8 +341,8 @@ static int bdx_fw_load(struct bdx_priv *priv)
>  out:
>  	if (master)
>  		WRITE_REG(priv, regINIT_SEMAPHORE, 1);
> -	if (fw)
> -		release_firmware(fw);
> +
> +	release_firmware(fw);
>  
>  	if (rc) {
>  		netdev_err(priv->ndev, "firmware loading failed\n");
> -- 
> 1.7.10
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
