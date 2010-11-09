Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0KIJOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:14:47 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:11846 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0KIJOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:14:44 -0500
Date: Tue, 9 Nov 2010 10:14:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: axel.lin@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Simon Guinot <sguinot@lacie.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (gpio-fan) Fix fan_ctrl_init error path
Message-ID: <20101109101436.4346ea3b@endymion.delvare>
In-Reply-To: <AANLkTim9mNy+ocftWn0ZiGPyefjhc-eXj3gunFw1Q04s@mail.gmail.com>
References: <1289279919.14461.7.camel@mola>
	<20101109090147.155dd1e9@endymion.delvare>
	<AANLkTim9mNy+ocftWn0ZiGPyefjhc-eXj3gunFw1Q04s@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 16:22:02 +0800, Axel Lin wrote:
> 2010/11/9 Jean Delvare <khali@linux-fr.org>:
> > On Tue, 09 Nov 2010 13:18:39 +0800, Axel Lin wrote:
> >> Remove sysfs entries before return -ENODEV.
> >>
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >> ---
> >>  drivers/hwmon/gpio-fan.c |    4 +++-
> >>  1 files changed, 3 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
> >> index aa701a1..d2e66b4 100644
> >> --- a/drivers/hwmon/gpio-fan.c
> >> +++ b/drivers/hwmon/gpio-fan.c
> >> @@ -388,11 +388,13 @@ static int fan_ctrl_init(struct gpio_fan_data *fan_data,
> >>       fan_data->speed_index = get_fan_speed_index(fan_data);
> >>       if (fan_data->speed_index < 0) {
> >>               err = -ENODEV;
> >> -             goto err_free_gpio;
> >> +             goto err_remove_sysfs;
> >>       }
> >>
> >>       return 0;
> >>
> >> +err_remove_sysfs:
> >> +     sysfs_remove_group(&pdev->dev.kobj, &gpio_fan_ctrl_group);
> >>  err_free_gpio:
> >>       for (i = i - 1; i >= 0; i--)
> >>               gpio_free(ctrl[i]);
> >
> > Oh, and while you're here, fan_alarm_init() needs some love as well.
> > There's a "return 0" in the middle which clearly can't be correct.
> I think this part is correct. see the comment:
>         /*
>          * If the alarm GPIO don't support interrupts, just leave
>          * without initializing the fail notification support.
>          */

Oops, my bad. I should have read the comments before blaming the
author :(

-- 
Jean Delvare
