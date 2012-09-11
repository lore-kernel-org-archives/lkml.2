Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab2IKKAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:00:04 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:39405 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629Ab2IKKAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:00:00 -0400
Message-ID: <504F0B99.5090500@ti.com>
Date: Tue, 11 Sep 2012 15:29:53 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: linux-watchdog@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko.nikula@bitmer.com
Subject: Re: [PATCH v2] watchdog: omap_wdt: convert to new watchdog core
References: <1347127441-23125-1-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1347127441-23125-1-git-send-email-aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2012 11:34 PM, Aaro Koskinen wrote:
> -static struct platform_device *omap_wdt_dev;
> -
>  static unsigned timer_margin;
>  module_param(timer_margin, uint, 0);
>  MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
>  
> -static unsigned int wdt_trgr_pattern = 0x1234;
> -static DEFINE_SPINLOCK(wdt_lock);
> -
you may want to describe this more.
>  struct omap_wdt_dev {
>  	void __iomem    *base;          /* physical */
>  	struct device   *dev;
> -	int             omap_wdt_users;
> +	bool		omap_wdt_users;
>  	struct resource *mem;
> -	struct miscdevice omap_wdt_miscdev;
> +	int		wdt_trgr_pattern;
> +	struct mutex	lock;		/* to avoid races with PM */
>  };
>  

