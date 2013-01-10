Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3AJK5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:57:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43633 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3AJK5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:57:24 -0500
Date: Thu, 10 Jan 2013 10:57:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gpio: vt8500: memory cleanup missing
Message-ID: <20130110105710.GA19944@n2100.arm.linux.org.uk>
References: <1357163240-23131-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357163240-23131-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 10:47:20AM +1300, Tony Prisk wrote:
> There is also no .remove callback defined. To allow removing the
> registered chips, I have moved *vtchip to be a static global.

What?  Why?

> +/* Pointer to our array of chips */
> +static struct vt8500_gpio_chip *vtchip;
> +
...
> +static int vt8500_gpio_remove(struct platform_device *pdev)
> +{
> +	int i;
> +	int ret;
> +	const struct vt8500_gpio_data *data;
> +	void __iomem *gpio_base = vtchip[0].base;
> +	const struct of_device_id *of_id =
> +				of_match_device(vt8500_gpio_dt_ids, &pdev->dev);
> +

You can get at the vtchip pointer if you put it into the platform device's
driver data pointer.  That way, you're not artificially limiting this
driver to just one device, and, with your changes it will go wrong if DT
ever lists more than one device.
