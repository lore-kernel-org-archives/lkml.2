Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2AQUCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:02:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42834 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2AQUCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:02:33 -0500
Date: Tue, 17 Jan 2012 20:02:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCH 06/07] LEDS: LED module for DA9052/53 PMIC
Message-ID: <20120117200227.GC31854@sirena.org.uk>
References: <1326806904.3542.341.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326806904.3542.341.camel@dhruva>
X-Cookie: Edwin Meese made me wear CORDOVANS!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 06:58:24PM +0530, Ashish Jangam wrote:

> +	error = da9052_reg_write(led->da9052, led_reg[led->led_index],
> +				 led->brightness | DA9052_LED_CONT_DIM);

The device has 8 bit registers but brightness could be any 8 bit number
by default (and the driver doesn't set a maxmimum brightness that I
noticed).

> +static int __init da9052_led_init(void)
> +{
> +	return platform_driver_register(&da9052_led_driver);
> +}
> +module_init(da9052_led_init);
> +
> +static void __exit da9052_led_exit(void)
> +{
> +	platform_driver_unregister(&da9052_led_driver);
> +}
> +module_exit(da9052_led_exit);

Use module_platform_driver()
