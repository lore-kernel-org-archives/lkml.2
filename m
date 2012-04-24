Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab2DXKPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:15:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43161 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab2DXKPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:15:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Girdwood, Liam" <lrg@ti.com>
Date: Tue, 24 Apr 2012 03:15:09 -0700
Subject: RE: [PATCH] leds: lm3530: fix handling of already enabled regulators
Thread-Topic: [PATCH] leds: lm3530: fix handling of already enabled
 regulators
Thread-Index: Ac0h9wXiqfShsR+nTziKiCfpk70hWwACX7OQ
Message-ID: <DD6B9D658496A2488636C8C75B9C0CB601DA3AF6@EXMAIL04.scwf.nsc.com>
References: <1335107508.6261.3.camel@phoenix>
 <20120423110912.GC8318@opensource.wolfsonmicro.com>
 <CAF+7xWkzy5e0rcpwprEE3VWTikOu2+qtsgfdhTN12-yonDxadA@mail.gmail.com>
 <DD6B9D658496A2488636C8C75B9C0CB601DA3984@EXMAIL04.scwf.nsc.com>
 <CAF+7xWmB1YWjwmQmf9gk0DX7DH5euBD1QH8d7VW6r_nat8FwYQ@mail.gmail.com>
In-Reply-To: <CAF+7xWmB1YWjwmQmf9gk0DX7DH5euBD1QH8d7VW6r_nat8FwYQ@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Let me put it this way: Assume only this driver is using the regulator.
> If the regulator is enabled on boot, which means the reference count
> is init to 1.
> 

Could you explain what 'enabled on boot' means ?
1) The regulator_enable() is called in initial time
or
2) boot_on = 1 in regulator_init_data ?

If you mean 'boot_on = 1' in regulator_init_data, then no use_count increase.

> Then if we set brt_val to 0 in lm3530_brightness_set, which will then
> call
> regulator_disable(). 

It looks buggy code in lm3530_brightness_set().
Even the regulator_disable() is failed, drvdata->enable is set to false.
I think drvdata->enable is changed to false only when the regulator is off successfully.

Thanks & BR
Milo -
