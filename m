Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2I0Cjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:39:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2I0Cja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:39:30 -0400
Date: Wed, 26 Sep 2012 19:36:48 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 09/57] power: ab8500_fg: usleep_range instead of short
 msleep
Message-ID: <20120927023648.GA8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-10-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-10-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:06AM -0600, mathieu.poirier@linaro.org wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Signed-off-by: Jonas ABERG <jonas.aberg@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>
> ---
>  drivers/power/ab8500_fg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index 1e02b00..0db17c7 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -957,7 +957,7 @@ static int ab8500_fg_load_comp_volt_to_capacity(struct ab8500_fg *di)
>  	do {
>  		vbat += ab8500_fg_bat_voltage(di);
>  		i++;
> -		msleep(5);
> +		usleep_range(5000, 5001);

Um.. why? From the commit message it's not obvious the rationale behind
this change. :-)

>  	} while (!ab8500_fg_inst_curr_done(di));
>  
>  	ab8500_fg_inst_curr_finalize(di, &di->inst_curr);
> -- 
> 1.7.5.4
