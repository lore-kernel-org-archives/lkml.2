Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab2AHHnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 02:43:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6565 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2AHHnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 02:43:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 07 Jan 2012 23:43:12 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Sun, 8 Jan 2012 13:12:47 +0530
Subject: RE: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Topic: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Index: AczNcBkuuKLx9NjJTcio0X78eFri5QAZ3dHA
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
 <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
In-Reply-To: <20120107191047.GA3590@opensource.wolfsonmicro.com>
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

> On Sunday, January 08, 2012 12:41 AM +5:30, Mark Brown Wrote

> > In the platform data, I will take 4 sets of regulator_init_data
> > corresponding to VSEL0/1. If client is not interested in all and tied
> > to fixed high/low, he will just pass NULL to unused index and proper
> > information to used option.
> 
> Taking multiple different regulator_init_data is definitely not what we
> want, there's a whole bunch of information in there, not just the
> voltages.  You should just use platform data to specify the GPIOs (and
> a set of voltages if you go with that approach).


How do you pass the voltages along with gpios? If I understand correctly
then it may be wither in range form or discrete form.
Like in range form 500-700 for VSEL:00, 710-800 VSEL:01 etc.
In discrete form VSEL00:500, 540, 550..
For, VSEL01, VSEL00:510, 900,

In range form, the disadvantages is that, most of time, the voltage
requirement is surrounding operating voltage and so it will use only
one combination of VSEL in most of time and will not get the benefit.
The discrete form have long list of voltage and filling table is pain.
Also need to maintain the big list of lookuptable to select voltage
configuration register.

If above is not correct then can you please help on understanding how
the information will be pass from platform data?

