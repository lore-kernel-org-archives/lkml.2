Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965976Ab2B2SVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:21:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47114 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965845Ab2B2SVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:21:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arunrmurthy.83@gmail.com designates 10.42.174.194 as permitted sender) smtp.mail=arunrmurthy.83@gmail.com; dkim=pass header.i=arunrmurthy.83@gmail.com
MIME-Version: 1.0
In-Reply-To: <CANndwHasH6cVdVu=bzYkz2Ri8Hp5OBzaMeVmp6hMkvP99ujc6w@mail.gmail.com>
References: <1330532668-5673-1-git-send-email-arun.murthy@stericsson.com>
	<1330532668-5673-3-git-send-email-arun.murthy@stericsson.com>
	<CANndwHasH6cVdVu=bzYkz2Ri8Hp5OBzaMeVmp6hMkvP99ujc6w@mail.gmail.com>
Date: Wed, 29 Feb 2012 23:51:21 +0530
Message-ID: <CAAnUQp1u7cT+2wRKZ6qZ9Wg7QWjyTQ3uTDyXvu9Mwc0p650DbA@mail.gmail.com>
Subject: Re: [PATCH 2/4] power: ab8500-charger: AB8500 charger driver
From: Arun Murthy <arunrmurthy.83@gmail.com>
To: Andi <andi.shyti@gmail.com>
Cc: Arun Murthy <arun.murthy@stericsson.com>, cbou@mail.ru,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +       /* Enable main watchdog in OTP */
>> +       ret = abx500_set_register_interruptible(di->dev,
>> +               AB8500_OTP_EMUL, AB8500_OTP_CONF_15, OTP_ENABLE_WD);
>> +       if (ret) {
>> +               dev_err(di->dev, "failed to enable main WD in OTP\n");
>> +               goto out;
>> +       }
>> +
>> +       /* Enable main watchdog */
>> +       ret = abx500_set_register_interruptible(di->dev,
>> +               AB8500_SYS_CTRL2_BLOCK,
>> +               AB8500_MAIN_WDOG_CTRL_REG, MAIN_WDOG_ENA);
>> +       if (ret) {
>> +               dev_err(di->dev, "faile to enable main watchdog\n");
>> +               goto out;
>> +       }
>> +
>> +       /*
>> +        * Due to internal synchronisation, Enable and Kick watchdog bits
>> +        * cannot be enabled in a single write.
>> +        * A minimum delay of 2*32 kHz period (62.5µs) must be inserted
>> +        * between writing Enable then Kick bits.
>> +        */
>> +       udelay(63);
>
> Are you sure about this udelay?
>

Yes, a minimum of 62.5µsec is required. Its also commented just above.

Thanks and Regards,
Arun R Murthy
----------------------
