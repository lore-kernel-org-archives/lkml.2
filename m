Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1GEOub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:50:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab1GEOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:50:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: ashish.jangam@kpitcummins.com
Subject: Re: [PATCH 9/11] Backlight: DA9052 Backlight driver v1
Date: Tue, 5 Jul 2011 16:50:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: rpurdie@rpsys.net, tfransosi@gmail.com, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, dchen@diasemi.com
References: <1309270692.376.227.camel@L-0532.kpit.com>
In-Reply-To: <1309270692.376.227.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051650.19178.arnd@arndb.de>
X-Provags-ID: V02:K0:h3hEeNJA6CgYQkqli6F8iWk69LWXomI//TyJ3j42X95
 Ld7vaMQvZsSaAiLMJxey7rZpw9zQPNvwTLnOC5fiUQOzF8+8nJ
 4uRX5IcpKLZtMJ9w+MayjSuc4Ib5wKX90V4uy9tL3EYPsTE3KM
 0fXmw3YTbqov9Qq1WxkpFz5HgvpnrpGIasr1qL01lkdwPpDIdH
 9X/Y8ZxYNQMjPRYdrsoXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, ashishj3 wrote:
> +static struct platform_driver da9052_wled1_driver = {
> +       .probe  = da9052_backlight_probe,
> +       .remove = da9052_backlight_remove,
> +       .driver = {
> +               .name   = "da9052-WLED1",
> +               .owner  = THIS_MODULE,
> +       },
> +};
> +
> +static struct platform_driver da9052_wled2_driver = {
> +       .probe  = da9052_backlight_probe,
> +       .remove = da9052_backlight_remove,
> +       .driver = {
> +               .name   = "da9052-WLED2",
> +               .owner  = THIS_MODULE,
> +       },
> +};
> +
> +static struct platform_driver da9052_wled3_driver = {
> +       .probe  = da9052_backlight_probe,
> +       .remove = da9052_backlight_remove,
> +       .driver = {
> +               .name   = "da9052-WLED3",
> +               .owner  = THIS_MODULE,
> +       },
> +};
> +
> +static int __init da9052_backlight_init(void)
> +{
> +       int ret;
> +
> +       ret = platform_driver_register(&da9052_wled1_driver);
> +       if (ret)
> +               return ret;
> +
> +       ret = platform_driver_register(&da9052_wled2_driver);
> +       if (ret)
> +               return ret;
> +
> +       ret = platform_driver_register(&da9052_wled3_driver);
> +       if (ret)
> +               return ret;
> +
> +       return 0;
> +}
> +module_init(da9052_backlight_init);

As mentioned before, you should only need to register a single driver
for these three devices: Either you name them all the same and just
give the individual devices a different platform_device->id, or
you leave them with different names and add a platform_driver->id_table
to match them all.

	Arnd
