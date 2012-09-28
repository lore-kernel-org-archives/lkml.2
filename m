Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2I1BOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:14:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46544 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab2I1BOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:14:38 -0400
Date: Thu, 27 Sep 2012 18:11:57 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 47/57] power: Harmonising platform data
 declaration/handling
Message-ID: <20120928011156.GE5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-48-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-48-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:44AM -0600, mathieu.poirier@linaro.org wrote:
> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
> 
> Making platform data declaration and handling similar accross all
> ab8500_xyc.c battery management files.  Also adding gards against
> NULL platform data.
> 
> Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  drivers/power/ab8500_btemp.c    |   17 +++++++++--------
>  drivers/power/ab8500_charger.c  |   18 +++++++++---------
>  drivers/power/ab8500_fg.c       |   17 +++++++++--------
>  drivers/power/abx500_chargalg.c |   25 ++++++++++++++++++++-----
>  4 files changed, 47 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
> index 1f33122..cf4b653 100644
> --- a/drivers/power/ab8500_btemp.c
> +++ b/drivers/power/ab8500_btemp.c
> @@ -1028,10 +1028,10 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>  {
>  	int irq, i, ret = 0;
>  	u8 val;
> -	struct ab8500_platform_data *plat_data;
> -	struct ab8500_btemp *di;
> +	struct ab8500_platform_data *plat;
>  
> -	di = kzalloc(sizeof(*di), GFP_KERNEL);

While at it, you could remove the unneeded empty line.

> +	struct ab8500_btemp *di =
> +		kzalloc(sizeof(struct ab8500_btemp), GFP_KERNEL);

And here you need the empty line.

>  	if (!di)
>  		return -ENOMEM;
>  
