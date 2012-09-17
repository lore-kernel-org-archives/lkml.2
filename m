Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2IQMHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 08:07:38 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:12769 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2IQMHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:07:14 -0400
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
Thread-Index: AQHNevk4pB6rQXiUMUetWtkXJKtKrJdt4YyAgCCl2oD///OMAIAAEiug///3xICAABI0wP//8ogAAAMEdPA=
Date: Mon, 17 Sep 2012 12:07:11 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032CC9D3@NB-EX-MBX02.diasemi.com>
References: <201208151518.q7FFILAM011604@latitude.olech.com>
 <20120827165057.GK4339@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC96A@NB-EX-MBX02.diasemi.com>
 <20120917104017.GB5401@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC993@NB-EX-MBX02.diasemi.com>
 <20120917111550.GE5401@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC9BB@NB-EX-MBX02.diasemi.com>
 <20120917113248.GF5401@opensource.wolfsonmicro.com>
In-Reply-To: <20120917113248.GF5401@opensource.wolfsonmicro.com>
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
> Sent: 17 September 2012 12:33
> To: Opensource [Anthony Olech]
> Cc: Liam Girdwood; Guenter Roeck; Jean Delvare; Randy Dunlap; LKML; David
> Dajun Chen
> Subject: Re: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
> On Mon, Sep 17, 2012 at 11:23:54AM +0000, Opensource [Anthony Olech]
> wrote:
> > Can you suggest a future proofed way of using the new regulator API
> > that would solve my problem?
> As I said you should set the voltage as part of the set voltage operation.

So I will have to write my own set_voltage_sel() callback instead of using
the default regulator_set_voltage_sel_regmap() ??

Well, I did try hard to use your defaults, but I suppose there is nothing to
stop me calling regulator_set_voltage_sel_regmap() explicitly as the first
part of my set_voltage_sel() callback before setting the ramp_enable bit.
Then my implemenation of the set_voltage_time_sel() callback needs to
just simply return the ramp time.
