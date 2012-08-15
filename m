Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2HOSxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:53:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41031 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab2HOSxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:53:20 -0400
Date: Wed, 15 Aug 2012 19:53:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V3 1/8] DA9058 MFD core driver
Message-ID: <20120815185316.GG15365@opensource.wolfsonmicro.com>
References: <201208151518.q7FFIN9v011639@latitude.olech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151518.q7FFIN9v011639@latitude.olech.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:05:21PM +0100, Anthony Olech wrote:

>  
>  if HAS_IOMEM
> +
>  menu "Multifunction device drivers"

This random change is still present from the first version....

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

You appear to have ignored my previous review comments about this...  it
still shouldn't be needed with modern kernels.

> +static bool da9058_register_volatile(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case DA9058_ADCMAN_REG:
> +	case DA9058_ADCRESH_REG:
> +	case DA9058_ADCRESL_REG:
> +	case DA9058_ALARMD_REG:
> +	case DA9058_ALARMH_REG:
> +	case DA9058_ALARMMI_REG:
> +	case DA9058_ALARMMO_REG:
> +	case DA9058_ALARMS_REG:
> +	case DA9058_ALARMY_REG:

Are all the alarm registers really volatile?

> +	case DA9058_LDO9_REG:
> +	case DA9058_TOFFSET_REG:
> +	default:
> +		return false;

Just use the default.

> +static struct regulator_consumer_supply platform_vddarm_consumers[] = {
> +	{.supply = "vcc",}
> +};

No, this and all your other regulator configuration is board specific.
