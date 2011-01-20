Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1ATIWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:22:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37691 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1ATIWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SlWpuTLX2a7cpqmk4EO74gM7TyCK1qsNhvOkfzTcSvQcrbZOfP0jq63IF1DtYhNn18
         rxbTh7jpvOrd+G+SxS+OOkBnFg4tv5VQv1JKPw/3/j8JAjJKYtDmc16/vqO3ozmD5h1n
         zj5yse0hTZnttuI6r2FBR65qOhAVBzCXKzgkE=
Date: Thu, 20 Jan 2011 00:22:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Luotao Fu <l.fu@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] leds: leds-pwm: return proper error if pwm_request failed
Message-ID: <20110120082207.GD2498@core.coreip.homeip.net>
References: <1295494735.20884.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295494735.20884.1.camel@mola>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 11:38:55AM +0800, Axel Lin wrote:
> Return PTR_ERR(led_dat->pwm) instead of 0 if pwm_request failed
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks good.

Reviewed-by: Dmitry Torokhov <dtor@mail.ru>

> ---
>  drivers/leds/leds-pwm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index da3fa8d..666daf7 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -69,6 +69,7 @@ static int led_pwm_probe(struct platform_device *pdev)
>  		led_dat->pwm = pwm_request(cur_led->pwm_id,
>  				cur_led->name);
>  		if (IS_ERR(led_dat->pwm)) {
> +			ret = PTR_ERR(led_dat->pwm);
>  			dev_err(&pdev->dev, "unable to request PWM %d\n",
>  					cur_led->pwm_id);
>  			goto err;

-- 
Dmitry
