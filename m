Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2E1Top (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 15:44:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49319 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2E1Ton (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 15:44:43 -0400
Date: Mon, 28 May 2012 16:44:38 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [ 71/94] spi/spi-fsl-spi: reference correct pdata in
 fsl_spi_cs_control
Message-ID: <20120528194437.GC2915@herton-Z68MA-D2H-B3>
References: <20120527010332.GA11170@kroah.com>
 <20120527010433.768465216@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120527010433.768465216@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 10:05:34AM +0900, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------

In addition to this fix, please also cherry-pick into 3.3 series commit
5039a86973cd35bdb2f64d28ee12f13fe2bb5a4c, "spi/mpc83xx: fix NULL pdata
dereference bug". I noted now that 3.3 stable is missing it. It
was the first part addressing the issue introduced by commit 178db7d3 in
spi-fsl-spi, that is included in 3.3.

> 
> From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> commit 067aa4815a9bc12a569d8a06afef50ba5773afbf upstream.
> 
> Commit 178db7d3, "spi: Fix device unregistration when unregistering
> the bus master", changed spi device initialization of dev.parent pointer
> to be the master's device pointer instead of his parent.
> 
> This introduced a bug in spi-fsl-spi, since its usage of spi device
> pointer was not updated accordingly. This was later fixed by commit
> 5039a86, "spi/mpc83xx: fix NULL pdata dereference bug", but it missed
> another spot on fsl_spi_cs_control function where we also need to update
> usage of spi device pointer. This change address that.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/spi/spi-fsl-spi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/spi/spi-fsl-spi.c
> +++ b/drivers/spi/spi-fsl-spi.c
> @@ -931,7 +931,7 @@ err:
>  
>  static void fsl_spi_cs_control(struct spi_device *spi, bool on)
>  {
> -	struct device *dev = spi->dev.parent;
> +	struct device *dev = spi->dev.parent->parent;
>  	struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(dev->platform_data);
>  	u16 cs = spi->chip_select;
>  	int gpio = pinfo->gpios[cs];
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
