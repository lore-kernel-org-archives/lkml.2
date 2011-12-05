Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1LEJOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:14:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42079 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab1LEJOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:14:15 -0500
MIME-Version: 1.0
In-Reply-To: <20111205085228.GF9900@legolas.emea.dhcp.ti.com>
References: <1323074921-29291-1-git-send-email-thomas.abraham@linaro.org>
	<20111205085228.GF9900@legolas.emea.dhcp.ti.com>
Date: Mon, 5 Dec 2011 14:44:14 +0530
Message-ID: <CAJuYYwTJOfCGUObv4+GakO8BN3N10=T6pH7MdCAiqtBrVGz1_Q@mail.gmail.com>
Subject: Re: [PATCH] backlight: add regulator support for platform_lcd driver
From: Thomas Abraham <thomas.abraham@linaro.org>
To: balbi@ti.com
Cc: rpurdie@rpsys.net, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 5 December 2011 14:22, Felipe Balbi <balbi@ti.com> wrote:

[...]

>> +     if (lcd_power) {
>> +             if (plcd->pdata->min_uV || plcd->pdata->max_uV)
>> +                     if (regulator_set_voltage(lcd_regulator,
>> +                             plcd->pdata->min_uV, plcd->pdata->max_uV))
>> +                             dev_info(plcd->us,
>> +                                     "regulator voltage set failed\n");
>> +
>> +             if (regulator_enable(lcd_regulator))
>> +                     dev_info(plcd->us, "failed to enable regulator\n");
>> +     } else {
>> +             regulator_disable(lcd_regulator);
>> +     }
>> +
>> +     regulator_put(lcd_regulator);
>
> I wonder why you ->get() and ->put() everytime here. Wouldn't it be
> enough to ->get() on probe() and ->put() on remove() ??

Thanks for the suggestion. It would be simpler if done in probe. I
will redo this patch.

Regards,
Thomas.

>
> --
> balbi
>
