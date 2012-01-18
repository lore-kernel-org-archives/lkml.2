Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2ARNOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:14:49 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:53207 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab2ARNOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:14:48 -0500
Date: Wed, 18 Jan 2012 14:14:47 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH] leds: add driver for PCA9663 I2C chip
In-Reply-To: <4F14A06F.90507@metafoo.de>
Message-ID: <alpine.DEB.2.01.1201181403350.29913@pmeerw.net>
References: <1326747861-10874-1-git-send-email-pmeerw@pmeerw.net> <4F14A06F.90507@metafoo.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > simple driver for the PCA9633 I2C chip supporting four LEDs and
> > 255 brightness levels

> Looks good, just a few minor issues.

thanks for the timely review and suggestions; I'll respond to our comments 
below and resubmit a v2 shortly

the driver is based on leds-pca955x.c, all your comments apply there as 
well :)

> > +static void pca9633_led_set(struct led_classdev *led_cdev,
> > +	enum led_brightness value)
> > +	spin_lock(&pca9633->lock);
> Does the spinlock actually protect against anything?

removed it

> > +	printk(KERN_INFO "leds-pca9633: LED driver at slave address 0x%02x\n",
> > +		client->addr);
> dev_info, but it probably wouldn't hurt either if the message is removed
> altogether.

dropped as suggested

> > +	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
> > +		return -EIO;
> You check for I2C functionality, but only ever use the smbus subset, which
> should be supported by all adapters anyway, so you should be safe even without
> the check.

dropped

> > +			dev_err(&client->dev, "board info must claim at most 4 LEDs");
> > +			return -ENODEV;
> -EINVAL?

changed

> > +			if (pdata->leds[i].name)
> > +				snprintf(pca9633[i].name,
> > +					 sizeof(pca9633[i].name), "pca9633:%s",
> > +					 pdata->leds[i].name);
> Why the prefix?

pca955x does it the same way; I'd rather keep it so one knowns where a LED 
is connected

> > +module_init(pca9633_leds_init);
> > +module_exit(pca9633_leds_exit);
> Use the new module_i2c_driver macro.

agree; I've submitted a patch to linux-i2c to mentionen the macro in 
Documentation/i2c/writing-clients

thanks, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
