Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab1LFCtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 21:49:39 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40311 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab1LFCti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 21:49:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111206021749.GA7202@earth.universe>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
	<20111206021749.GA7202@earth.universe>
Date: Tue, 6 Dec 2011 04:49:37 +0200
Message-ID: <CAMP44s3JF9QM00x=aUq3tHGfeuTRnKMbT2WrMseZXZTJg1qUyQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/12/6 Sebastian Reichel <sre@debian.org>:
> Good to hear somebody is working on this :) I planned to do this
> myself, but didn't find any time for it. Here are some comments
> from me:

:)

> [...]
>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>
> I would expect the driver in drivers/power. But maybe MFD is
> better, since the chip can also be used to power USB host?

Perhaps, at least I haven't tried that.

> [...]
>
>> +#define BQ2415X_VOLTAGE_SCALE 20000
>
> If I remember correctly (I read the specs some time ago), this can
> be configured via external resistor. So this is board specific?

Not really. There are 6 bits: 640, 320, 160, 80, 40, 20. So values
from 0 to 1260mV can be represented, at steps of 20mV. A value of 0
means 3.5V.

> [...]
>
>> +     bq2415x_i2c_write(cli, BQ2415X_CHG_CTL, 0x42);
>> +     bq2415x_set_voltage(cli, 0, 4200000);
>> +     bq2415x_set_current_limit(cli, 1800000, 1800000);
>
> So it always charges with 1.8A? Shouldn't this be dependent on the
> input source (e.g. 500mA from USB)? Also what's if no charger is
> connected at all?

No. I'm hard-coding those values, but I wrote the functions
(set_voltate, set_current_limit) so all values are supported.

What is missing is the code to connect this driver to the charger
detector driver (isp1704), so those values are determined dynamically.

> Apart from this I think those values should be exposed to sysfs
> via /sys/class/power_supply.

Perhaps. Although I don't see much of the power supply interface that
could be useful here, but if so, I guess this should be indeed in
'drivers/power'.

Cheers.

-- 
Felipe Contreras
