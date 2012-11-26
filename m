Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2KZKoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:44:00 -0500
Received: from smtp-out-226.synserver.de ([212.40.185.226]:1163 "EHLO
	smtp-out-226.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab2KZKn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:43:58 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26067
Message-ID: <50B347F4.2080705@metafoo.de>
Date: Mon, 26 Nov 2012 11:44:04 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: jg1.han@samsung.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 1/5] backlight: Add GPIO-based backlight driver
References: <32552643.33371353923376540.JavaMail.weblogic@epv6ml07>
In-Reply-To: <32552643.33371353923376540.JavaMail.weblogic@epv6ml07>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 10:49 AM, Jingoo Han wrote:
> On Saturday, November 24, 2012 1:35 AM, Laurent Pinchart wrote
[...]
>> +static int gpio_backlight_check_fb(struct backlight_device *bl,
>> +				   struct fb_info *info)
>> +{
>> +	struct gpio_backlight *gbl = bl_get_data(bl);
>> +
>> +	return gbl->fbdev == info->dev;

I think it makes sense to return true if fbdev is NULL, to provide a simple
fallback for systems with only one framebuffer device.

>> +}
>> +
[...]
>> +#ifdef CONFIG_PM
>> +static int gpio_backlight_suspend(struct device *dev)
>> +{
>> +	struct backlight_device *bl = dev_get_drvdata(dev);
>> +	struct gpio_backlight *gbl = bl_get_data(bl);
>> +
>> +	gpio_set_value(gbl->gpio, !gbl->active);
>> +
>> +	return 0;
>> +}
>> +
>> +static int gpio_backlight_resume(struct device *dev)
>> +{
>> +	struct backlight_device *bl = dev_get_drvdata(dev);
>> +
>> +	backlight_update_status(bl);
>> +	return 0;
>> +}

If you use BL_CORE_SUSPENDRESUME you can get rid of the custom
suspend/resume handlers.

>> +
>> +static SIMPLE_DEV_PM_OPS(gpio_backlight_pm_ops, gpio_backlight_suspend,
>> +			 gpio_backlight_resume);
>> +
>> +#endif
>> +
[...]
