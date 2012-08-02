Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2HBQOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:14:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44625 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab2HBQN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:13:59 -0400
Date: Thu, 2 Aug 2012 17:13:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NEW DRIVER V1 4/7] DA9058 RTC driver
Message-ID: <20120802161355.GD4537@opensource.wolfsonmicro.com>
References: <201208020849.q728nhll007819@latitude.olech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208020849.q728nhll007819@latitude.olech.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:48:56AM +0100, Anthony Olech wrote:

> -comment "I2C RTC drivers"
> -	depends on I2C
> -
> -if I2C
> -
>  config RTC_DRV_88PM860X
>  	tristate "Marvell 88PM860x"
>  	depends on RTC_CLASS && I2C && MFD_88PM860X
> @@ -135,6 +130,21 @@ config RTC_DRV_88PM860X
>  	  This driver can also be built as a module. If so, the module
>  	  will be called rtc-88pm860x.
>  
> +comment "I2C RTC drivers"
> +	depends on I2C
> +
> +if I2C
> +

Hrm?

> +	dev_info(dev, "Read RTC: %02x %02x %02x %02x %02x %02x\n",
> +		rtc_time[0], rtc_time[1], rtc_time[2],
> +		rtc_time[3], rtc_time[4], rtc_time[5]);

This is way too noisy to be doing every time you read the RTC.

> +	dev_info(dev, "Setting RTC: %02x %02x %02x %02x %02x %02x\n",
> +		rtc_time[0], rtc_time[1], rtc_time[2], rtc_time[3],
> +		rtc_time[4], rtc_time[5]);

Similarly here...

> +	ret = da9058_bulk_write(da9058, DA9058_COUNTS_REG, rtc_time, 6);
> +	if (ret) {
> +		dev_dbg(dev, "failed %d to write to RTC\n", ret);

...especially given that things like actual error messages are at debug
level!

> +static int da9058_rtc_proc(struct device *dev, struct seq_file *seq)
> +{
> +	seq_printf(seq, "Tony Olech was here\n");
> +
> +	return 0;
> +}

Perhaps the driver needs some cleanup...
