Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2AIIrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:47:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14859 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2AIIrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:47:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 09 Jan 2012 00:47:21 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Mon, 9 Jan 2012 14:17:17 +0530
Subject: RE: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Topic: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Index: AczOocgP5glSAOkETBiJt417EvqcQwABtpJA
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9D6@BGMAIL01.nvidia.com>
References: <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
 <20120108165819.GB29065@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9A3@BGMAIL01.nvidia.com>
 <20120109071128.GA22134@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9B6@BGMAIL01.nvidia.com>
 <20120109073859.GG22134@opensource.wolfsonmicro.com>
In-Reply-To: <20120109073859.GG22134@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Monday, January 09, 2012 1:09 PM, Mark Brown wrote
> 
> > If I fix the voltage with each VSEL then only 4 voltages will be
> > possible but I want to have more than 4 different output.
> > How do I achieve this?
> 
> The driver can decide what voltages to set - like I said in a previous
> mail it could use something like LRU to decide which slot to use, or
> perhaps be clever with the upper end of the range it was given.

So we will change the gpios output also according to voltage register
slot from driver?

> 
> > > What I'd expect to see is nothing but the GPIOs and their default state
> > > (since sadly we can't read back from output GPIOs with gpiolib) being
> > > specified.
> 
> > I did not understand it correctly. Can you please elaborate how can we
> > pass the voltage with corresponding vsel?
> 
> For bootstrapping you can just read the values back.

So through platform data, I will pass the gpio nr for VSEL0, VSEL1 and
their default state. 
If these lines tied up with the  fixed logic, high or low then value
will be -1 and driver will not request for any gpios apis.
Default state will be the corresponding logic for this situation
which will be passed from platform data and driver will be use
corresponding slots for voltage configuration register always.

If valid gpios will be passed then driver will use the LRU mechanism
for getting desired configuration register for configuring the desired
voltage (passed through the regulator_setvoltage())and set the gpios
accordingly through gpio libs.
In this approach, because we need to set two different gpios for
desired logic, the output will not go in proper transition from
current to new one, for some time when we completed setting of
one gpio and setting second gpio.



> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
