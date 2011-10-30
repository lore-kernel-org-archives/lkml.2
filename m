Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab1J3JwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 05:52:04 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:48301 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481Ab1J3JwB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 05:52:01 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org Mailing List" 
	<linux-kernel@vger.kernel.org>
CC: "cbou@mail.ru" <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Mark Brown <mark.brown314@gmail.com>
Date: Sun, 30 Oct 2011 02:51:52 -0700
Subject: [PATCH] power: max8925 - Enable power change notifications   --
 RESEND
Thread-Topic: [PATCH] power: max8925 - Enable power change notifications
   -- RESEND
Thread-Index: AcyW6Y0MaqoF4Q+KQmSwJ/t4smzz8Q==
Message-ID: <E4D0EFE3-91AD-425F-90C7-3AF4E065BFDC@marvell.com>
References: <03653C9B-09A4-40D0-B63F-ABDDDC0124D9@marvell.com>
In-Reply-To: <03653C9B-09A4-40D0-B63F-ABDDDC0124D9@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resend

On Aug 29, 2011, at 9:32 AM, Philip Rakity wrote:

> 
> The power core infrastructure allow external power change
> events to be passed to drivers what are listed in the
> supplied_to call back field.  Enable this feature by
> allowing the supplied_to field to be passed to the driver.
> 
> This feature will enable drivers named in the supplied_to field that have a
> external_power_changed callback to be notified when power
> was been turned on or off.
> 
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> ---
> drivers/power/max8925_power.c |    5 +++++
> include/linux/mfd/max8925.h   |    2 ++
> 2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index fd32c08..29b5d2c 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -455,6 +455,8 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
> 	info->ac.properties = max8925_ac_props;
> 	info->ac.num_properties = ARRAY_SIZE(max8925_ac_props);
> 	info->ac.get_property = max8925_ac_get_prop;
> +	info->ac.supplied_to = pdata->supplied_to;
> +	info->ac.num_supplicants = pdata->num_supplicants;
> 	ret = power_supply_register(&pdev->dev, &info->ac);
> 	if (ret)
> 		goto out;
> @@ -465,6 +467,9 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
> 	info->usb.properties = max8925_usb_props;
> 	info->usb.num_properties = ARRAY_SIZE(max8925_usb_props);
> 	info->usb.get_property = max8925_usb_get_prop;
> +	info->usb.supplied_to = pdata->supplied_to;
> +	info->usb.num_supplicants = pdata->num_supplicants;
> +
> 	ret = power_supply_register(&pdev->dev, &info->usb);
> 	if (ret)
> 		goto out_usb;
> diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
> index e742e04..008f807 100644
> --- a/include/linux/mfd/max8925.h
> +++ b/include/linux/mfd/max8925.h
> @@ -225,6 +225,8 @@ struct max8925_power_pdata {
> 	unsigned	fast_charge:3;	/* charge current */
> 	unsigned	no_temp_support:1; /* set if no temperature detect */
> 	unsigned	no_insert_detect:1; /* set if no ac insert detect */
> +	char		**supplied_to;
> +	int		num_supplicants;
> };
> 
> /*
> -- 
> 1.7.6
> 
> 

