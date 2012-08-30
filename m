Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2H3VKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:10:35 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:37319 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2H3VKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:10:33 -0400
Date: Thu, 30 Aug 2012 17:10:32 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Message-ID: <1040994502.402858.1346361031972.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <20120830201019.GA3875@roeck-us.net>
Subject: Re: [PATCH] hwmon: add Maxim MAX197 support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Thanks for your detailed comments. I'll send a new version soon.

About the following comment, I agree with you. However as there is no convention for this case, for now I would prefer to stick with the model as seen in drivers such as sht15.

In the future, I think we could add a field in the platform_data, something like .chip = "max199", or .variant = 199, and update the hwmon drivers.

Thanks,
Vivien

> +static int __devexit max197_remove(struct platform_device *pdev)
> +{
> +	struct max197_chip *chip = platform_get_drvdata(pdev);
> +
> +	hwmon_device_unregister(chip->hwmon_dev);
> +	sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver __refdata maxim_drivers[] = {
> +	{
> +		.driver = {
> +			.name = "max197",
> +			.owner = THIS_MODULE,
> +		},
> +		.probe = max197_probe,
> +		.remove = __devexit_p(max197_remove),
> +	}, {
> +		.driver = {
> +			.name = "max199",
> +			.owner = THIS_MODULE,
> +		},
> +		.probe = max197_probe,
> +		.remove = __devexit_p(max197_remove),
> +	}
> +};
> +
> +static int __init max197_init(void)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(maxim_drivers); i++) {
> +		ret = platform_driver_register(&maxim_drivers[i]);
> +		if (ret)
> +			goto error_unregister;
> +	}

I keep thinking about this; there must be a better way where we only need one
platform driver instance. After all, there is just one driver, only there can
be multiple devices. No idea how to do that right now, though. If I find out,
I'll let you know.
