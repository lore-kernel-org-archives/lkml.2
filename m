Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994Ab1IIXMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:12:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33249 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759932Ab1IIXM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:12:29 -0400
X-Sasl-enc: X9GziWnzemCOjssW1YyEfMnoIorLO3WFXk0s3NB/SPyh 1315609948
Date: Fri, 9 Sep 2011 16:09:25 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] zram: Kernel config option for number of devices
Message-ID: <20110909230925.GA23699@kroah.com>
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org>
 <1315609264-13632-3-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315609264-13632-3-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 07:01:01PM -0400, Nitin Gupta wrote:
> Allows configuring default number of zram devices
> as kernel config option. User can override this
> value using 'num_devices' module parameter.

Ick, another config value, is this really needed?  Why can't we rely on
the module parameter instead?


> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  drivers/staging/zram/Kconfig    |    9 +++++++++
>  drivers/staging/zram/zram_drv.c |   13 ++++++++-----
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
> index 3bec4db..ca31cb3 100644
> --- a/drivers/staging/zram/Kconfig
> +++ b/drivers/staging/zram/Kconfig
> @@ -21,6 +21,15 @@ config ZRAM
>  	  See zram.txt for more information.
>  	  Project home: http://compcache.googlecode.com/
>  
> +config ZRAM_NUM_DEVICES
> +	int "Default number of zram devices"
> +	depends on ZRAM
> +	range 1 32
> +	default 1
> +	help
> +	  Select default number of zram devices. You can override this value
> +	  using 'num_devices' module parameter.
> +
>  config ZRAM_DEBUG
>  	bool "Compressed RAM block device debug support"
>  	depends on ZRAM
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 03ec5a2..55f2c0e 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -781,6 +781,14 @@ static int __init zram_init(void)
>  {
>  	int ret, dev_id;
>  
> +	/*
> +	 * Module parameter not specified by user. Use default
> +	 * value as defined during kernel config.
> +	 */
> +	if (num_devices == 0) {
> +		num_devices = CONFIG_ZRAM_NUM_DEVICES;
> +	}

Wrong coding style, which, for some odd reason, checkpatch doesn't
catch.  Please remove the braces.

thanks,

greg k-h
