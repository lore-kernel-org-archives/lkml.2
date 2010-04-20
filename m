Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0DTLN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 07:13:28 -0400
Received: from trinity.fluff.org ([89.16.178.74]:49010 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab0DTLN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 07:13:26 -0400
Date: Tue, 20 Apr 2010 12:13:14 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] i2c-s3c2410: Decrease delay after end of transaction
Message-ID: <20100420111314.GD2234@trinity.fluff.org>
References: <1271760799-30913-1-git-send-email-yauhen.kharuzhy@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271760799-30913-1-git-send-email-yauhen.kharuzhy@promwad.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 01:53:19PM +0300, Yauhen Kharuzhy wrote:
> msleep(1) which has been used for delay after issuing a STOP condition
> to bus cause very big delay (min 1/HZ s). This is makes bulk register
> update in I2C devices (for instance video camera) very slowly.
> 
> Seems that this delay can be safely decreased to few tens of
> microseconds.

Mark Brown has already submitted a similar patch that uses the bus
busy bit. will be in the i2c-next tree soon.
 
> Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
> ---
>  drivers/i2c/busses/i2c-s3c2410.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index d27072b..de20a4e 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -521,7 +521,7 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
>  
>  	/* ensure the stop has been through the bus */
>  
> -	msleep(1);
> +	udelay(50);
>  
>   out:
>  	return ret;
> -- 
> 1.6.6.1
> 

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

