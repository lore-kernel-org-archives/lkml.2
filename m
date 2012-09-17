Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2IQKt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:49:27 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:50602 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2IQKt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:49:26 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Liam Girdwood <lrg@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        "Jean Delvare" <khali@linux-fr.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
Thread-Topic: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
Thread-Index: AQHNevk4pB6rQXiUMUetWtkXJKtKrJdt4YyAgCCl2oD///OMAIAAEiug
Date: Mon, 17 Sep 2012 10:49:22 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032CC993@NB-EX-MBX02.diasemi.com>
References: <201208151518.q7FFILAM011604@latitude.olech.com>
 <20120827165057.GK4339@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC96A@NB-EX-MBX02.diasemi.com>
 <20120917104017.GB5401@opensource.wolfsonmicro.com>
In-Reply-To: <20120917104017.GB5401@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 17 September 2012 11:40
> To: Opensource [Anthony Olech]
> Cc: Liam Girdwood; Guenter Roeck; Jean Delvare; Randy Dunlap; LKML; David
> Dajun Chen
> Subject: Re: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
> On Mon, Sep 17, 2012 at 10:29:43AM +0000, Opensource [Anthony Olech]
> wrote:
> > > Why is this function writing to the hardware, especially writing the
> > > same value every time?
> > the ramp_register is DA9058_SUPPLY_REG and it is marked as volitile.
> > Writing to the ramp enable bit starts the voltage change. When the
> > PMIC has finished making the change it resets the bit. Thus to make
> > another voltage change the bit needs to be set again.
> This function is retrieving the amount of time it would take to set the voltage.
> Why would it be starting a voltage ramp?  The fact that it's not setting the new
> voltage in the hardware ought to be a warning sign here...

Thanks for the quick response Mark,

I thought that the set_voltage_sel = regulator_set_voltage_sel_regmap callback first
set the target voltage, and that the set_voltage_time_sel = da9058_buck_ramp_voltage
callback was called afterwards?

was I wrong?

