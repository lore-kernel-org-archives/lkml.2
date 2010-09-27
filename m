Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0I0LY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:24:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63337 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0I0LY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lTefVQSwEDm77oXwvYVidgcmYS/XsulOTZJ3jYliydVwOsOAiJ+VFUn3myHSaqngxn
         ZuaCZ4dGDkrlotHRkftnKMeow4yrNFz1ufgQhk8Kp7izewfxzmzGMYyDu3YTiQP6844d
         Y54vQIfHgC86UIEmLfAZxqn8vnu46z2vXh5GU=
MIME-Version: 1.0
In-Reply-To: <1285529740-28232-1-git-send-email-notasas@gmail.com>
References: <1285529740-28232-1-git-send-email-notasas@gmail.com>
Date: Mon, 27 Sep 2010 16:00:35 +0530
Message-ID: <AANLkTik=M9S6iB9YitHevJ0e7X=jxsug6qLkYdGBqmoo@mail.gmail.com>
Subject: Re: [PATCH v3] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Arun Murthy <arunrmurthy.83@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 1:05 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
>
> TWL4030/TPS65950 is a multi-function device with integrated charger,
> which allows charging from AC or USB. This driver enables the
> charger and provides several monitoring functions.
>
> Tested on OMAP3 Pandora board.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
> This is v3 of BCI charger driver I first sent nearly a year ago [1].
> I've updated it to use the new OTG notifiers for VBUS notifications,
> however it still is not able to determine charge current to use.
> For that reason there is now a temporary module param to enable USB
> charging, until I can figure out how to get that info from the gadget
> stack (hopefully Felipe can help me here).
On detecting USB plug, the driver is suppose to detect the type of usb
device. Then if the device is a PC(standard host) the charging current
is to be obtained from the usb stack. Hence the driver will have to
wait until the usb stack or driver notifies the current that can be
drawn. The usb stack or driver gets to know the amount of current to
be drawn through the negotiations that happen between the host and
device.

> +
> +       platform_set_drvdata(pdev, bci);
> +
> +       bci->ac.name = "twl4030_ac";
> +       bci->ac.type = POWER_SUPPLY_TYPE_MAINS;
> +       bci->ac.properties = twl4030_charger_props;
> +       bci->ac.num_properties = ARRAY_SIZE(twl4030_charger_props);
> +       bci->ac.get_property = twl4030_bci_get_property;
> +
> +       ret = power_supply_register(&pdev->dev, &bci->ac);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to register ac: %d\n", ret);
> +               goto fail_register_ac;
> +       }
> +
> +       bci->usb.name = "twl4030_usb";
> +       bci->usb.type = POWER_SUPPLY_TYPE_USB;
> +       bci->usb.properties = twl4030_charger_props;
> +       bci->usb.num_properties = ARRAY_SIZE(twl4030_charger_props);
> +       bci->usb.get_property = twl4030_bci_get_property;
> +
> +       ret = power_supply_register(&pdev->dev, &bci->usb);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to register usb: %d\n", ret);
> +               goto fail_register_usb;
> +       }
Only AC and USB monitoring is achieved by registering with power supply class.
How is battery monitored?
An instance of battery is to be registered with power supply class in
order to monitor battery.

Thanks and Regards,
Arun R Murthy
---------------------
