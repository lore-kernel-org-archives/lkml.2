Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1HZX34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:29:56 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:40166 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752936Ab1HZX3z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:29:55 -0400
From: Philip Rakity <prakity@marvell.com>
To: "cbou@mail.ru" <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <hzhuang1@marvell.com>
Date: Fri, 26 Aug 2011 16:29:21 -0700
Subject: Re: [PATCH] power: max8925_power.  Do not detect ac insert if
 handled by other code 
Thread-Topic: [PATCH] power: max8925_power.  Do not detect ac insert if
 handled by other code 
Thread-Index: AcxkR/ScjsnueqSuSZu4bJNJE2AX+Q==
Message-ID: <1D8C4706-7905-4E64-8C18-2057DA57FECF@marvell.com>
References: <7F69A365-0154-4B4A-9ED9-D60AE4BEB23C@marvell.com>
In-Reply-To: <7F69A365-0154-4B4A-9ED9-D60AE4BEB23C@marvell.com>
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


loop maintainer
On Aug 24, 2011, at 3:27 PM, Philip Rakity wrote:

> On brownstone rev 4 ac-insert detect is handled by vbus.
> 
> allow the platform code to configure the disabling of insert
> by setting no_insert_detect.
> 
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> ---
> drivers/power/max8925_power.c |    8 ++++++--
> include/linux/mfd/max8925.h   |    1 +
> 2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index dba07f3..fd32c08 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -79,6 +79,7 @@ struct max8925_power_info {
> 	unsigned		topoff_threshold:2;
> 	unsigned		fast_charge:3;
> 	unsigned		no_temp_support:1;
> +	unsigned		no_insert_detect:1;
> 
> 	int (*set_charger) (int);
> };
> @@ -366,8 +367,10 @@ static __devinit int max8925_init_charger(struct max8925_chip *chip,
> 	int ret;
> 
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_OVP, "ac-ovp");
> -	REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_F, "ac-remove");
> -	REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_R, "ac-insert");
> +	if (!info->no_insert_detect) {
> +		REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_F, "ac-remove");
> +		REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_R, "ac-insert");
> +	}
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_OVP, "usb-ovp");
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_F, "usb-remove");
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_R, "usb-insert");
> @@ -482,6 +485,7 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
> 	info->fast_charge = pdata->fast_charge;
> 	info->set_charger = pdata->set_charger;
> 	info->no_temp_support = pdata->no_temp_support;
> +	info->no_insert_detect = pdata->no_insert_detect;
> 
> 	max8925_init_charger(chip, info);
> 	return 0;
> diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
> index 69ec8f0..e742e04 100644
> --- a/include/linux/mfd/max8925.h
> +++ b/include/linux/mfd/max8925.h
> @@ -224,6 +224,7 @@ struct max8925_power_pdata {
> 	unsigned	topoff_threshold:2;
> 	unsigned	fast_charge:3;	/* charge current */
> 	unsigned	no_temp_support:1; /* set if no temperature detect */
> +	unsigned	no_insert_detect:1; /* set if no ac insert detect */
> };
> 
> /*
> -- 
> 1.7.6
> 

