Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0CVMis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:38:48 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:34336 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab0CVMiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:38:46 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BA76568.4070002@jic23.retrosnub.co.uk>
Date: Mon, 22 Mar 2010 12:41:12 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH 21/24] staging/iio/adc: fix dangling pointers
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-22-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1269094385-16114-22-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/10 14:13, Wolfram Sang wrote:
> Fix I2C-drivers which missed setting clientdata to NULL before freeing the
> structure it points to. Also fix drivers which do this _after_ the structure
> was freed already.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Thanks,
> ---
> 
> Found using coccinelle, then reviewed. Full patchset is available via
> kernel-janitors, linux-i2c, and LKML.
> ---
>  drivers/staging/iio/adc/max1363_core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
> index 9703881..1682fd0 100644
> --- a/drivers/staging/iio/adc/max1363_core.c
> +++ b/drivers/staging/iio/adc/max1363_core.c
> @@ -556,6 +556,7 @@ error_put_reg:
>  	if (!IS_ERR(st->reg))
>  		regulator_put(st->reg);
>  error_free_st:
> +	i2c_set_clientdata(client, NULL);
>  	kfree(st);
>  
>  error_ret:
> @@ -573,6 +574,7 @@ static int max1363_remove(struct i2c_client *client)
>  		regulator_disable(st->reg);
>  		regulator_put(st->reg);
>  	}
> +	i2c_set_clientdata(client, NULL);
>  	kfree(st);
>  
>  	return 0;

