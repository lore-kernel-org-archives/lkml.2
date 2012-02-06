Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2BFNJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 08:09:53 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:43996 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab2BFNJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 08:09:52 -0500
Date: Mon, 6 Feb 2012 14:09:48 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
cc: Lars-Peter Clausen <lars@metafoo.de>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCH 03/07] LEDS: LED module for DA9052/53 PMIC v1
In-Reply-To: <1328532157.30549.75.camel@dhruva>
Message-ID: <alpine.DEB.2.01.1202061359020.23821@pmeerw.net>
References: <1328532157.30549.75.camel@dhruva>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	da9052 = dev_get_drvdata(pdev->dev.parent);
> +	pdata = da9052->dev->platform_data;
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "No platform data\n");
> +		error = -ENODEV;
> +		goto err_mem;
> +	}
> +
> +	pled = pdata->pled;
> +	if (pled == NULL) {
> +		dev_err(&pdev->dev, "Failed no platform data for LED\n");
> +		return -ENOMEM;
> +	}

this should be ENODEV as well, there is no alloc
the message could be improved, e.g. "No platform data for LED"

> +	for (i = 0; i < pled->num_leds; i++) {
> +		led[i].cdev.name = pled->leds[i].name;
> +		led[i].cdev.brightness_set = da9052_led_set;
> +		led[i].cdev.brightness = LED_OFF;
> +		led[i].brightness = LED_OFF;
> +		led[i].led_index = pled->leds[i].flags;
> +		led[i].da9052 = dev_get_drvdata(pdev->dev.parent);
> +		INIT_WORK(&led[i].work, da9052_led_work);
> +
> +		error = led_classdev_register(pdev->dev.parent, &led[i].cdev);
> +		if (error) {
> +			dev_err(&pdev->dev, "Failed to register led %d\n",
> +				led[i].led_index);
> +			goto err_register;
> +		}
> +
> +		error = da9052_set_led_brightness(&led[i]);
> +		if (error) {
> +			dev_err(&pdev->dev, "Unable to init led %d\n",
> +				led[i].led_index);
> +			continue;
> +		}
> +	}
> +	error = da9052_configure_leds(led);
> +	if (error) {
> +		dev_err(&pdev->dev, "Failed to configure GPIO Led,%d\n", error);
> +		goto err_register;
> +	}

Led or led or LED?
Led,%d looks odd, maybe "LED%d"?

-- 

Peter Meerwald
+43-664-2444418 (mobile)
