Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab1LFNu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:50:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64043 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933248Ab1LFNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:50:57 -0500
MIME-Version: 1.0
In-Reply-To: <20111206132131.GA22855@earth.universe>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
	<20111206021749.GA7202@earth.universe>
	<CAMP44s3JF9QM00x=aUq3tHGfeuTRnKMbT2WrMseZXZTJg1qUyQ@mail.gmail.com>
	<20111206132131.GA22855@earth.universe>
Date: Tue, 6 Dec 2011 15:50:56 +0200
Message-ID: <CAMP44s1D8fbifOuuubMUbW=Z-DOF20B2dz+JR5ZPSqG-G3Ca-Q@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/6 Sebastian Reichel <sre@debian.org>:
> On Tue, Dec 06, 2011 at 04:49:37AM +0200, Felipe Contreras wrote:
>> Not really. There are 6 bits: 640, 320, 160, 80, 40, 20. So values
>> from 0 to 1260mV can be represented, at steps of 20mV. A value of 0
>> means 3.5V.
>
> I just checked it. You'r driver just writes 0x42 to the register,
> which makes use of the described platform specific resistor.
>
>> bq2415x_i2c_write(cli, BQ2415X_CHG_CTL, 0x42);
>
> I know that 42 is the "Answer to the Ultimate Question of Life, the
> Universe, and Everything" [0]. But in this case 0x42 is platform
> specific. Check page 30 in the specs, From Table 9 onwards.

Well, you were talking about BQ2415X_VOLTAGE_SCALE, which I used for
the voltage register calculation.

But yeah, you are right about BQ2415X_CHG_CTL. Maybe it would make
sense to make it a platform driver, or perhaps just expose functions
so the board can set the right values.

>> > Apart from this I think those values should be exposed to sysfs
>> > via /sys/class/power_supply.
>>
>> Perhaps. Although I don't see much of the power supply interface that
>> could be useful here, but if so, I guess this should be indeed in
>> 'drivers/power'.
>
> So it may need some new entries. Normal mobile userspace wants to
> know at least charging status & speed. Also it's probably a good
> idea to make current_limit sysfs entry writeable, so that advanced
> users can overwrite a autodetected value (e.g. a dumb wallcharger
> may be detected as 100mA, but can provide 1A).

True. drivers/power it is then :)

-- 
Felipe Contreras
