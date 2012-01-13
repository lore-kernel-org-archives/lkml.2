Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab2AMWKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:10:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2AMWKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:10:20 -0500
Date: Fri, 13 Jan 2012 14:10:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH] backlight: Fix the logic to set bits in adp8860_bl and
 adp8870_bl drivers
Message-Id: <20120113141019.1fc1439e.akpm@linux-foundation.org>
In-Reply-To: <1326442521.5482.1.camel@phoenix>
References: <1326442521.5482.1.camel@phoenix>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 16:15:21 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> We need to write new value if the bit mask fields of new value is not equal to
> old value. It does not make sense to write new value only when all the bit_mask
> bits are zero.

When fixing bugs, please always describe the user-visible effects of
the bug.

> diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
> index 66bc74d..378276c 100644
> --- a/drivers/video/backlight/adp8860_bl.c
> +++ b/drivers/video/backlight/adp8860_bl.c
> @@ -146,7 +146,7 @@ static int adp8860_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask
>  
>  	ret = adp8860_read(client, reg, &reg_val);
>  
> -	if (!ret && ((reg_val & bit_mask) == 0)) {
> +	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
>  		reg_val |= bit_mask;
>  		ret = adp8860_write(client, reg, reg_val);
>  	}
> diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
> index 6c68a68..6735059 100644
> --- a/drivers/video/backlight/adp8870_bl.c
> +++ b/drivers/video/backlight/adp8870_bl.c
> @@ -160,7 +160,7 @@ static int adp8870_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask
>  
>  	ret = adp8870_read(client, reg, &reg_val);
>  
> -	if (!ret && ((reg_val & bit_mask) == 0)) {
> +	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
>  		reg_val |= bit_mask;
>  		ret = adp8870_write(client, reg, reg_val);
>  	}

This patch is applicable to 3.2.x, but I don't know whether to route it
to -stable becasue you didn't tell me what effect the patch has :(

