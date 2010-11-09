Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0KIPzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:55:13 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37105 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0KIPzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ji4ajl5nutgWqB5cCzBAmF1FvmxIDy7kYZrj8+BpiDfkHcbJUdFtxFz++K28iOaWZc
         xLJ8iQPX21SPypCWKTPzvVGqlxvI5uZyVC1LKSj9JlnojX3UQTONiJZHO9CqAJfKr2I2
         lGRtNhQiYFWjiNPABfj1NtyJTftKKrTT2t9x4=
Date: Tue, 9 Nov 2010 07:54:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Vincent Sanders <support@simtec.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: touchscreen: s3c2410: Add ABS_PRESSURE event
 sending.
Message-ID: <20101109155455.GA3682@core.coreip.homeip.net>
References: <1289307616-10336-1-git-send-email-marek.belisko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289307616-10336-1-git-send-email-marek.belisko@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 02:00:16PM +0100, Marek Belisko wrote:
> This patch add sending of event ABS_PRESSURE for
> s3c24xx touchscreen.
> 
> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
> ---
>  drivers/input/touchscreen/s3c2410_ts.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
> index 8feb7f3..a937105 100644
> --- a/drivers/input/touchscreen/s3c2410_ts.c
> +++ b/drivers/input/touchscreen/s3c2410_ts.c
> @@ -126,6 +126,7 @@ static void touch_timer_fire(unsigned long data)
>  			input_report_abs(ts.input, ABS_Y, ts.yp);
>  
>  			input_report_key(ts.input, BTN_TOUCH, 1);
> +			input_report_abs(ts.input, ABS_PRESSURE, 1);

No, if device does not provide true pressure readings it should not send
ABS_PRESSURE events. Please fix your userspace.

Thanks.

-- 
Dmitry
