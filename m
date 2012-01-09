Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2AIHdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:33:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3855 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2AIHdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:33:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 08 Jan 2012 23:33:09 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Mon, 9 Jan 2012 13:03:06 +0530
Subject: RE: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Topic: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Index: AczOnfswNwmfcPjTTamHp+8tmvMaUgAAfn3A
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9B6@BGMAIL01.nvidia.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
 <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
 <20120108165819.GB29065@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9A3@BGMAIL01.nvidia.com>
 <20120109071128.GA22134@opensource.wolfsonmicro.com>
In-Reply-To: <20120109071128.GA22134@opensource.wolfsonmicro.com>
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


> On Monday, January 09, 2012 12:41 PM, Mark Brown wrote
> > In my design, the voltage vary from 900mV to the 1300mV in increment of
> > 50mV. In this case, the voltage change request is 900, 950, 1000, 1050,
> > 1100, 1150, 1200, 1250, 1300.
> > I would like to have entry like
> > 900-950->vsel0
> > 950-1000>vsel1,
> > 1000-1050->vsel2
> > 1050-1100->vsel3
> > 1100-1150->vsel0
> > 1150-1200->vsel1
> > 1200-1250->vsel2
> > 1250->1300->vsel3
> 
> Why?  I'm not sure I understand this.  You're asking the regulator to
> output ranges not voltages and you're setting multiple overlapping
> ranges for each VSEL.

If I fix the voltage with each VSEL then only 4 voltages will be
possible but I want to have more than 4 different output.
How do I achieve this?

> 
> > Based on voltage increment requirements for a given application, this
> > table can be tune more. Now if client request for voltage setting for
> > range of 1000-1050, I will select the VSET1 for configuration, similarly
> > for 1100-1150, VSET0 will be the configuration register.
> 
> This just seems like it makes the driver configuration much more
> complex and restricts the ability of the system to adapt itself to
> what's happening at runtime.
> 
> What I'd expect to see is nothing but the GPIOs and their default state
> (since sadly we can't read back from output GPIOs with gpiolib) being
> specified.

I did not understand it correctly. Can you please elaborate how can we
pass the voltage with corresponding vsel?
I want to have around 10 different voltages at output.

