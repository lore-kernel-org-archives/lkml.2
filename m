Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2KRWu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 17:50:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49301 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2KRWu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 17:50:58 -0500
Date: Sun, 18 Nov 2012 14:47:32 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] ds2782_battery: signedness bug in ds278x_read_reg16()
Message-ID: <20121118224732.GA29066@lizard.sbx05977.paloaca.wayport.net>
References: <20121024071229.GB2536@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121024071229.GB2536@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:12:29AM +0300, Dan Carpenter wrote:
> We need to check for negative values before doing the swab16() for the
> error handling to work.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks!

> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> index 6bb6e2f..2fa9b6b 100644
> --- a/drivers/power/ds2782_battery.c
> +++ b/drivers/power/ds2782_battery.c
> @@ -80,13 +80,13 @@ static inline int ds278x_read_reg16(struct ds278x_info *info, int reg_msb,
>  {
>  	int ret;
>  
> -	ret = swab16(i2c_smbus_read_word_data(info->client, reg_msb));
> +	ret = i2c_smbus_read_word_data(info->client, reg_msb);
>  	if (ret < 0) {
>  		dev_err(&info->client->dev, "register read failed\n");
>  		return ret;
>  	}
>  
> -	*val = ret;
> +	*val = swab16(ret);
>  	return 0;
>  }
