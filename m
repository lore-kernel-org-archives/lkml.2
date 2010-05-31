Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab0EaTD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:03:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33710 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab0EaTDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hDLmQYn9ovqPjQ6N9NSbD5mljYbPVbQj2GvZMaIeKOkRiQba1KJkd2/tdPmlb99vKj
         zSLgLWAkwHmhJYP6kiZf2A2FRMAyVlobWEOSql7SV73QArURTCSlh7ijMlnjVxIZTA3E
         er3GOkfeUAqR5bv7n0z+wxtLg4JHSKGuK5jm4=
Date: Mon, 31 May 2010 12:03:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Tone down logging from S3C touchscreen driver
Message-ID: <20100531190319.GA30712@core.coreip.homeip.net>
References: <1275328371-32066-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275328371-32066-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 06:52:51PM +0100, Mark Brown wrote:
> The S3C touchscreen driver is logging at LOG_INFO on every stylus up
> event which spams the console needlessly.  Reduce the priority of the
> message to debug level for some peace and quiet.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thank you Mark.

> ---
>  drivers/input/touchscreen/s3c2410_ts.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
> index ac5d0f9..6085d12 100644
> --- a/drivers/input/touchscreen/s3c2410_ts.c
> +++ b/drivers/input/touchscreen/s3c2410_ts.c
> @@ -173,7 +173,7 @@ static irqreturn_t stylus_irq(int irq, void *dev_id)
>  	if (down)
>  		s3c_adc_start(ts.client, 0, 1 << ts.shift);
>  	else
> -		dev_info(ts.dev, "%s: count=%d\n", __func__, ts.count);
> +		dev_dbg(ts.dev, "%s: count=%d\n", __func__, ts.count);
>  
>  	if (ts.features & FEAT_PEN_IRQ) {
>  		/* Clear pen down/up interrupt */
> -- 
> 1.7.1
> 

-- 
Dmitry
