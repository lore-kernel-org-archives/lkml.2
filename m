Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2HFM00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:26:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50702 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab2HFM0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:26:07 -0400
Date: Mon, 6 Aug 2012 13:26:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V2 1/7] DA9058 MFD core and ADC driver
Message-ID: <20120806122606.GD16861@opensource.wolfsonmicro.com>
References: <201208060742.q767gwDA005770@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208060742.q767gwDA005770@ubuntu>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 09:43:42PM +0100, Anthony Olech wrote:

> @@ -3,6 +3,7 @@
>  #
>  
>  if HAS_IOMEM
> +
>  menu "Multifunction device drivers"

Hrm?

> +static int da9058_automatic_adc_conversion(struct da9058 *da9058,
> +				const int channel, int *value)
> +{

I see you've ignored my comments about using IIO.

> +	/*
> +	 * the init_board_irq() call-back function should be defined in
> +	 * the machine driver initialization code and is used to set up
> +	 * the actual (probably GPIO) line as an interrupt line.
> +	 */
> +	if (pdata->init_board_irq) {
> +		ret = pdata->init_board_irq();
> +		if (ret)
> +			goto failed_to_setup_the_actual_i2c_hw_irq;
> +	}

Why on earth do you need this?  This should not be needed with modern
kernels, especially not for the documented purpose.

> +	regmap = devm_regmap_init_i2c(i2c, &da9058_regmap_config);

Does the device support any other control interfaces?

You've also not defined the regmap config which means that this patch
will break the build.  This suggests these patches haven't been
tested...
