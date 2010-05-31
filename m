Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0EaTKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:10:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51889 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0EaTKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dpCCLdbVJrZPI6JmG5WKiWLpsEkiZwlTHVoZQZJiLM4ErXXefsqK+SaQt9nrTRGoAK
         94LASIUhrMjDrxLFTdkOihpFWwt1X32E87InwVdCnfGnTMHEBFDsD+9Hq4uFObU7gFXg
         n60sliMk5+XsVIrJybvA8hSieYqBU97ODG/Cg=
Date: Mon, 31 May 2010 12:10:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
       Todd Fischer <todd.fischer@ridgerun.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] input/tps6507x-ts: zero vs NULL
Message-ID: <20100531191029.GD30712@core.coreip.homeip.net>
References: <20100531120215.GS5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531120215.GS5483@bicker>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 02:02:15PM +0200, Dan Carpenter wrote:
> This patch silences a sparse warning:
> 
> drivers/input/touchscreen/tps6507x-ts.c:345:19:
> 	warning: Using plain integer as NULL pointer
> drivers/input/touchscreen/tps6507x-ts.c:367:19:
> 	warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
> index b99db09..1e57e4e 100644
> --- a/drivers/input/touchscreen/tps6507x-ts.c
> +++ b/drivers/input/touchscreen/tps6507x-ts.c
> @@ -342,7 +342,7 @@ err2:
>  	cancel_delayed_work(&tsc->work);
>  	flush_workqueue(tsc->wq);
>  	destroy_workqueue(tsc->wq);
> -	tsc->wq = 0;
> +	tsc->wq = NULL;
>  	input_free_device(input_dev);
>  err1:
>  	kfree(tsc);
> @@ -364,7 +364,7 @@ static int __devexit tps6507x_ts_remove(struct platform_device *pdev)
>  	cancel_delayed_work(&tsc->work);
>  	flush_workqueue(tsc->wq);

Why isn't it cancel_delayed_work_sync()?

>  	destroy_workqueue(tsc->wq);
> -	tsc->wq = 0;
> +	tsc->wq = NULL;
>  

Setting tsc to 0/NULL does not make much sense as it is being freed a
couple of lines below.

>  	input_free_device(input_dev);
>  

-- 
Dmitry
