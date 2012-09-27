Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2I0DNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:13:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53477 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab2I0DNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:13:46 -0400
Date: Wed, 26 Sep 2012 20:11:03 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 08/57] power: ab8500_fg: flush sync on suspend
Message-ID: <20120927031103.GE8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-9-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-9-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:05AM -0600, mathieu.poirier@linaro.org wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Do flush sync on the fg workqueue at suspend instead of
> just flushing it.

OK, but why? I guess I know why you're doing it, but still...

> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>
> ---
>  drivers/power/ab8500_fg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index 342d118..1e02b00 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -2437,7 +2437,7 @@ static int ab8500_fg_suspend(struct platform_device *pdev,
>  {
>  	struct ab8500_fg *di = platform_get_drvdata(pdev);
>  
> -	flush_delayed_work(&di->fg_periodic_work);
> +	flush_delayed_work_sync(&di->fg_periodic_work);
>  
>  	/*
>  	 * If the FG is enabled we will disable it before going to suspend
> -- 
> 1.7.5.4
> 
> 
