Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2KZL6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:58:09 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43651 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2KZL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:58:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        jg1.han@samsung.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 1/5] backlight: Add GPIO-based backlight driver
Date: Mon, 26 Nov 2012 12:59:10 +0100
Message-ID: <1701286.svlH7lvIeJ@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50B347F4.2080705@metafoo.de>
References: <32552643.33371353923376540.JavaMail.weblogic@epv6ml07> <50B347F4.2080705@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

On Monday 26 November 2012 11:44:04 Lars-Peter Clausen wrote:
> On 11/26/2012 10:49 AM, Jingoo Han wrote:
> > On Saturday, November 24, 2012 1:35 AM, Laurent Pinchart wrote
> 
> [...]
> 
> >> +static int gpio_backlight_check_fb(struct backlight_device *bl,
> >> +				   struct fb_info *info)
> >> +{
> >> +	struct gpio_backlight *gbl = bl_get_data(bl);
> >> +
> >> +	return gbl->fbdev == info->dev;
> 
> I think it makes sense to return true if fbdev is NULL, to provide a simple
> fallback for systems with only one framebuffer device.

Agreed, I'll change that.

> >> +}
> >> +
> 
> [...]
> 
> >> +#ifdef CONFIG_PM
> >> +static int gpio_backlight_suspend(struct device *dev)
> >> +{
> >> +	struct backlight_device *bl = dev_get_drvdata(dev);
> >> +	struct gpio_backlight *gbl = bl_get_data(bl);
> >> +
> >> +	gpio_set_value(gbl->gpio, !gbl->active);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int gpio_backlight_resume(struct device *dev)
> >> +{
> >> +	struct backlight_device *bl = dev_get_drvdata(dev);
> >> +
> >> +	backlight_update_status(bl);
> >> +	return 0;
> >> +}
> 
> If you use BL_CORE_SUSPENDRESUME you can get rid of the custom
> suspend/resume handlers.

Good point, I'll do that.

> >> +
> >> +static SIMPLE_DEV_PM_OPS(gpio_backlight_pm_ops, gpio_backlight_suspend,
> >> +			 gpio_backlight_resume);
> >> +
> >> +#endif
> >> +

-- 
Regards,

Laurent Pinchart

