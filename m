Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2BFM1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:27:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab2BFM1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:27:13 -0500
Date: Mon, 6 Feb 2012 13:27:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: chris@cnpbagwell.com, pinglinux@gmail.com,
        linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] HID: wacom: Fix invalid power_supply_powers calls
In-Reply-To: <1328481324-7241-1-git-send-email-przemo@firszt.eu>
Message-ID: <alpine.LNX.2.00.1202061326150.24127@pobox.suse.cz>
References: <1328481324-7241-1-git-send-email-przemo@firszt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Feb 2012, Przemo Firszt wrote:

> power_supply_powers calls added in 35b4c01e29bdd9632dabf9784ed3486333f00427
> have to be called after power device is created. This patch also fixes the
> second call - it has to be "ac" instead of "battery"
> 
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>

[ adding Jeremy to CC ]

> ---
>  drivers/hid/hid-wacom.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> index b47e58b..acab74c 100644
> --- a/drivers/hid/hid-wacom.c
> +++ b/drivers/hid/hid-wacom.c
> @@ -531,7 +531,6 @@ static int wacom_probe(struct hid_device *hdev,
>  	wdata->battery.type = POWER_SUPPLY_TYPE_BATTERY;
>  	wdata->battery.use_for_apm = 0;
>  
> -	power_supply_powers(&wdata->battery, &hdev->dev);
>  
>  	ret = power_supply_register(&hdev->dev, &wdata->battery);
>  	if (ret) {
> @@ -540,6 +539,8 @@ static int wacom_probe(struct hid_device *hdev,
>  		goto err_battery;
>  	}
>  
> +	power_supply_powers(&wdata->battery, &hdev->dev);
> +
>  	wdata->ac.properties = wacom_ac_props;
>  	wdata->ac.num_properties = ARRAY_SIZE(wacom_ac_props);
>  	wdata->ac.get_property = wacom_ac_get_property;
> @@ -547,14 +548,14 @@ static int wacom_probe(struct hid_device *hdev,
>  	wdata->ac.type = POWER_SUPPLY_TYPE_MAINS;
>  	wdata->ac.use_for_apm = 0;
>  
> -	power_supply_powers(&wdata->battery, &hdev->dev);
> -
>  	ret = power_supply_register(&hdev->dev, &wdata->ac);
>  	if (ret) {
>  		hid_warn(hdev,
>  			 "can't create ac battery attribute, err: %d\n", ret);
>  		goto err_ac;
>  	}
> +
> +	power_supply_powers(&wdata->ac, &hdev->dev);
>  #endif
>  	return 0;

Hmm, seems valid. How did you notice? Have you seen crashes because of 
wild pointers?

Thanks,

-- 
Jiri Kosina
SUSE Labs
