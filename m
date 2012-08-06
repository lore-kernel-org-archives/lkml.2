Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2HFQRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:17:43 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:31426 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2HFQRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:17:41 -0400
Date: Mon, 6 Aug 2012 18:17:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: fix i2c-i801.c printk format warning
Message-ID: <20120806181728.56c471dd@endymion.delvare>
In-Reply-To: <501FEC87.6060506@xenotime.net>
References: <20120806140109.b1a33b63686ef04f30139c9e@canb.auug.org.au>
	<501FEC87.6060506@xenotime.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Mon, 06 Aug 2012 09:10:47 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warning.  ARRAY_SIZE() uses sizeof(),
> which is size_t, so use %zu to print it.
> 
> drivers/i2c/busses/i2c-i801.c: In function 'i801_add_mux':
> drivers/i2c/busses/i2c-i801.c:1043:4: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Mark D. Studebaker <mdsxyz123@yahoo.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20120806.orig/drivers/i2c/busses/i2c-i801.c
> +++ linux-next-20120806/drivers/i2c/busses/i2c-i801.c
> @@ -1039,7 +1039,7 @@ static int __devinit i801_add_mux(struct
>  
>  	/* Find absolute GPIO pin numbers */
>  	if (ARRAY_SIZE(priv->mux_priv) < mux_config->n_gpios) {
> -		dev_err(dev, "i801_priv.mux_priv too small (%lu, need %d)\n",
> +		dev_err(dev, "i801_priv.mux_priv too small (%zu, need %d)\n",
>  			ARRAY_SIZE(priv->mux_priv), mux_config->n_gpios);
>  		return -ENODEV;
>  	}

Good catch once again, thanks a lot. As the offending patch is still
not upstream, I've folded your fix into it.

-- 
Jean Delvare
