Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab2AFBJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:09:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62637 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab2AFBJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:09:14 -0500
Date: Fri, 6 Jan 2012 05:09:09 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] power_supply: wm97xx_battery: Use DEFINE_MUTEX() for
 work_lock
Message-ID: <20120106010909.GB17587@oksana.dev.rtsoft.ru>
References: <1322491055.13921.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1322491055.13921.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 10:37:35PM +0800, Axel Lin wrote:
> work_lock can be initialized automatically with
> DEFINE_MUTEX() rather than explicitly calling mutex_init().
> 
> This patch also removes an unused bat_lock mutex.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks!

> ---
>  drivers/power/wm97xx_battery.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
> index cf8681c..eaa454b 100644
> --- a/drivers/power/wm97xx_battery.c
> +++ b/drivers/power/wm97xx_battery.c
> @@ -25,9 +25,8 @@
>  #include <linux/irq.h>
>  #include <linux/slab.h>
>  
> -static DEFINE_MUTEX(bat_lock);
>  static struct work_struct bat_work;
> -static struct mutex work_lock;
> +static DEFINE_MUTEX(work_lock);
>  static int bat_status = POWER_SUPPLY_STATUS_UNKNOWN;
>  static enum power_supply_property *prop;
>  
> @@ -181,8 +180,6 @@ static int __devinit wm97xx_bat_probe(struct platform_device *dev)
>  	if (dev->id != -1)
>  		return -EINVAL;
>  
> -	mutex_init(&work_lock);
> -
>  	if (!pdata) {
>  		dev_err(&dev->dev, "No platform_data supplied\n");
>  		return -EINVAL;
> -- 
> 1.7.5.4

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
