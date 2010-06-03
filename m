Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab0FCRC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:02:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41288 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755306Ab0FCRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:02:56 -0400
Date: Thu, 3 Jun 2010 18:02:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: sonic zhang <sonic.adi@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH v4] regulator: new drivers for AD5398 and AD5821
Message-ID: <20100603170254.GG2762@rakim.wolfsonmicro.main>
References: <1275535640.18536.2.camel@eight.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275535640.18536.2.camel@eight.analog.com>
X-Cookie: In the next world, you're on your own.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:27:20AM +0800, sonic zhang wrote:

> The AD5398 and AD5821 are single 10-bit DAC with 120 mA output current
> sink capability. They feature an internal reference and operates from
> a single 2.7 V to 5.5 V supply.

> This driver supports both the AD5398 and the AD5821.  It adapts into the
> voltage and current framework.

Looks good, just a few fairly small things.

> +	if (chip->min_uA < init_data->constraints.min_uA)
> +		chip->user_min_uA = init_data->constraints.min_uA;
> +	else
> +		chip->user_min_uA = chip->min_uA;
> +	if (chip->max_uA > init_data->constraints.max_uA)
> +		chip->user_max_uA = init_data->constraints.max_uA;
> +	else
> +		chip->user_max_uA = chip->max_uA;

Your driver should not be worrying about the constraints, the regulator
core will take care of enforcing them.

> +MODULE_DESCRIPTION("AD5398 and AD5821 current regulator driver");
> +MODULE_AUTHOR("Sonic Zhang");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:ad5398-regulator");

This is an I2C device, not a platform device.
