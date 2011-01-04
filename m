Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab1ADXHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:07:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39465 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1ADXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:07:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6216"; a="69262570"
Message-ID: <4D23A839.6030205@codeaurora.org>
Date: Tue, 04 Jan 2011 15:07:37 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-i2c@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] i2c: Factor out runtime suspend checks from PM operations
References: <1293712813-4090-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1293712813-4090-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> When devices use dev_pm_ops the I2C API is implementing standard functionality
> for integration with runtime PM and for checking for the presence of a per
> device op. The PM core provides pm_generic_ functions implementing this
> behaviour - use them to reduce coupling with future PM updates.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/i2c/i2c-core.c |   68 ++++++++++++++---------------------------------
>  1 files changed, 20 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 6b4cc56..6793c51 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -196,88 +196,60 @@ static int i2c_device_pm_suspend(struct device *dev)
>  {
>  	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  
> -	if (pm) {
> -		if (pm_runtime_suspended(dev))
> -			return 0;
> -		else
> -			return pm->suspend ? pm->suspend(dev) : 0;
> -	}
> -
> -	return i2c_legacy_suspend(dev, PMSG_SUSPEND);
> +	if (pm)
> +		return pm_generic_suspend(dev);


pm_generic_suspend() and others needs to be externed in linux/pm_runtime.h?

--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
