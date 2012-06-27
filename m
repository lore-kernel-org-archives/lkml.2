Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2F0NL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:11:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab2F0NL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:11:27 -0400
Message-ID: <4FEB0664.3030408@redhat.com>
Date: Wed, 27 Jun 2012 10:11:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jose Alberto Reguero <jareguero@telefonica.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch -resend] [media] az6007: precedence bug in az6007_i2c_xfer()
References: <20120627090644.GP31212@elgon.mountain>
In-Reply-To: <20120627090644.GP31212@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-06-2012 06:06, Dan Carpenter escreveu:
> The intent here was to test that the flag was clear but the '!' has
> higher precedence than the '&'.  I2C_M_RD is 0x1 so the current code is
> equivalent to "&& (!sgs[i].flags) ..."
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I sent this originally on Wed, 25 Jan 2012 and Emil Goode sent the same
> fix on Thu, May 3, 2012.
> 
> diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
> index 4008b9c..f6f0cf9 100644
> --- a/drivers/media/dvb/dvb-usb/az6007.c
> +++ b/drivers/media/dvb/dvb-usb/az6007.c
> @@ -711,7 +711,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
>   		addr = msgs[i].addr << 1;
>   		if (((i + 1) < num)
>   		    && (msgs[i].len == 1)
> -		    && (!msgs[i].flags & I2C_M_RD)
> +		    && (!(msgs[i].flags & I2C_M_RD))
>   		    && (msgs[i + 1].flags & I2C_M_RD)
>   		    && (msgs[i].addr == msgs[i + 1].addr)) {
>   			/*
> 

Dan,

Your logic is correct, however, I didn't apply this patch because it broke
the driver.

I'll need to re-visit the driver when I have some time, in order to be
able to apply this one, without breaking the driver. I'll likely need to
change some other things on this routine.

(this has a low priority, as the driver is working properly the way it is).

So, I'm keeping your patch at patchwork, while I don't find some time for it.

Regards,
Mauro

