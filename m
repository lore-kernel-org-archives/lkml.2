Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab2IEUjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:39:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53805 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2IEUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:39:15 -0400
Date: Wed, 5 Sep 2012 13:36:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Hlavacek <tmshlvck@gmail.com>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, marek.vasut@gmail.com
Subject: Re: [PATCHv4 1/1] [RFC] uartclk from serial_core exposed to sysfs
Message-ID: <20120905203641.GA21427@kroah.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
 <1345401285-14473-1-git-send-email-tmshlvck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345401285-14473-1-git-send-email-tmshlvck@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 08:34:45PM +0200, Tomas Hlavacek wrote:
> Added file /sys/devices/.../tty/ttySX/uartclk to allow reading
> uartclk value in struct uart_port in serial_core via sysfs.
> 
> It simplifies initialization verification of no-name cards that
> have non-standard oscillator speed while having no distinguishing
> PCI IDs to allow autodetection.
> 
> tty_register_device() has been generalized and refactored in order
> to add support for setting drvdata and attribute_group to the device.
> 
> Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>

This looks good, but it doesn't apply to my tty-next branch in
linux-next, so I can't apply it.

But, when you redo it, here's one tiny thing to change:

> +/**
> + *	tty_register_device_attr - register a tty device
> + *	@driver: the tty driver that describes the tty device
> + *	@index: the index in the tty driver for this tty device
> + *	@device: a struct device that is associated with this tty device.
> + *		This field is optional, if there is no known struct device
> + *		for this tty device it can be set to NULL safely.
> + *	@drvdata: Driver data to be set to device (NULL = do not touch).
> + *	@attr_grp: Attribute group to be set on device (NULL = do not touch).

No need to mention the NULL thing here, "do not touch" doesn't mean
much to me.

> +	if (attr_grp)
> +		dev->groups = attr_grp;
> +	if (drvdata)
> +		dev_set_drvdata(dev, drvdata);

No need to test for NULL, just set them, it can't really hurt, right?

thanks,

greg k-h
