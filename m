Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1JQQTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:19:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab1JQQTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:19:16 -0400
Date: Mon, 17 Oct 2011 09:18:54 -0700
From: Greg KH <gregkh@suse.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, jamie@jamieiles.com, arnd@arndb.de
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Message-ID: <20111017161854.GB5108@suse.de>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
 <1318852378-14180-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318852378-14180-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 12:52:54PM +0100, Lee Jones wrote:
> +void soc_device_unregister(struct device *dev)

Ick, no, pass in the struct soc_device, which the register function
should return, not a "raw" struct device.


> +{
> +	struct soc_device *soc_dev =
> +		container_of(dev, struct soc_device, dev);
> +
> +	sysfs_remove_group(&dev->kobj, &soc_attr_group);
> +
> +	if (device_is_registered(dev))
> +		device_unregister(dev);

Why is this call needed?

> +
> +	bus_unregister(&soc_bus_type);

What happens if you have more than one SOC device?  I think you just
oopsed.

> +
> +	kfree(soc_dev->attr);
> +	kfree(soc_dev);

Nope, you just failed again.  I can tell you never tried this code path,
otherwise you would have noticed the HUGE warnings that the kernel spit
back at you.  Please fix this.

greg k-h
