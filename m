Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2GQF0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:26:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50087 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab2GQF0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:26:33 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Adding support for configuring polarity in PWM framework.
Thread-Topic: Adding support for configuring polarity in PWM framework.
Thread-Index: Ac1jRByq1kMEXKqvQsO/bu3hkKjW/v//qtuA//+jJ2CAAG+IgP/+kRQQ
Date: Tue, 17 Jul 2012 05:25:22 +0000
Deferred-Delivery: Tue, 17 Jul 2012 05:25:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9645A3@DBDE01.ent.ti.com>
References: <518397C60809E147AF5323E0420B992E3E960B0E@DBDE01.ent.ti.com>
 <20120716113921.GA3015@avionic-0098.adnet.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E960C32@DBDE01.ent.ti.com>
 <50040D15.8040205@metafoo.de>
In-Reply-To: <50040D15.8040205@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 18:16:13, Lars-Peter Clausen wrote:
> On 07/16/2012 02:23 PM, Philip, Avinash wrote:
> 
> > 
> > 1. PWM framework API addition.
> > 	PWM frame work API support.
> > 	/**
> > 	 * pwm_setpolarity() - change a PWM device Polarity	
> > 	 * @pwm: PWM device
> > 	 * @polarity: Configure polarity of PWM
> >  	*
> > 	 * polarity     - false -> "on" time defined by duty ns
> > 	*              - true  -> "off' time defined by duty ns.
> >  	*/
> 
> Isn't this more about whether we start with a low or a high signal?

No, it is more about the average on time. On time determines the on duration of
the panel power and there by brightness. On one custom board, backlight power
booster gives power output on the OFF time of PWM (hardware connection).

> If it is
> just about the duty time you can easily achieve the same effect by setting
> it to (period_ns - duty_ns).

Yes this is possible. But the PWM hardware we uses supports configuration of
polarity. So I prefer PWM polarity configuration.
Also with polarity configuration support, we can achieve (period_ns - duty_ns),
for PWM devices don't have hardware support. Polarity configuration support
can be used for setting flags, duty cycle can be configured from config
depending on flag. 

Thanks
Avinash

> 
> - Lars
> 
> 

