Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0IBPzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:55:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56724 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0IBPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t6sXOHRpa7NNgnLDvg5tptmI4MIYuGm8zE5Vd4IkiCJ0k6G0WhMku0+HIA6SkVW3Zn
         6dFy3djT1dge29Gq8kDszAvR/eA5m+RAhpP+8JWVbl9ROxwGUdGJPsx/s53QW9f0k8fY
         8rNI85uWjIzDiRYM+01skW6THELHB+mJRwa4o=
Date: Thu, 2 Sep 2010 08:55:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Todd Fischer <todd.fischer@ridgerun.com>, linux-input@vger.kernel.org
Subject: Re: Input: tps6507x-ts - add missing platform_set_drvdata() in
 tps6507x_ts_probe()
Message-ID: <20100902155525.GB16914@core.coreip.homeip.net>
References: <1283419241.19272.9.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283419241.19272.9.camel@mola>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 05:20:41PM +0800, Axel Lin wrote:
> We call platform_get_drvdata() in tps6507x_ts_remove(),
> thus we should call platform_set_drvdata() in tps6507x_ts_probe().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks Axel.

> ---
>  drivers/input/touchscreen/tps6507x-ts.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
> index a644d18..7286209 100644
> --- a/drivers/input/touchscreen/tps6507x-ts.c
> +++ b/drivers/input/touchscreen/tps6507x-ts.c
> @@ -335,6 +335,7 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
>  		dev_err(tsc->dev, "schedule failed");
>  		goto err2;
>  	 }
> +	platform_set_drvdata(pdev, tps6507x_dev);
>  
>  	return 0;
>  
> -- 
> 1.7.2
> 
> 
> 

-- 
Dmitry
