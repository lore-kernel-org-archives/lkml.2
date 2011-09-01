Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab1IAV6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:58:13 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41355 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab1IAV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:58:11 -0400
Date: Fri, 2 Sep 2011 00:55:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>, devel@driverdev.osuosl.org,
        Arnd Bergmann <arnd@arndb.de>, linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Bryan Freed <bfreed@chromium.org>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] staging: iio: light: Fix compiler warning in tsl2563.c
Message-ID: <20110901215540.GA2430@shale.localdomain>
References: <20110901212413.GA3371@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901212413.GA3371@maxin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 12:24:13AM +0300, Maxin B. John wrote:
> --- a/drivers/staging/iio/light/tsl2563.c
> +++ b/drivers/staging/iio/light/tsl2563.c
> @@ -225,9 +225,9 @@ static int tsl2563_read_id(struct tsl2563_chip *chip, u8 *id)
>  
>  	ret = i2c_smbus_read_byte_data(client, TSL2563_CMD | TSL2563_REG_ID);
>  	if (ret < 0)
> -		return ret;
> +		return -EIO;

Don't overwrite the error code.  For example, the lower layers can
return -EAGAIN and that's more useful than just returning -EIO every
time.

Your fix works, but it's not very clean.  Just add a "*id = ret;"
line before the "return 0;" and that's it.  (It doesn't make sense
to pass a pointer to "id" and not use it).

(In other words, don't make any changes to the tsl2563_probe()
function)

>  
> -	return 0;
> +	return ret;
>  }
>  

regards,
dan carpenter

