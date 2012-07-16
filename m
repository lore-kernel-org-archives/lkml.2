Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2GPMYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:24:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46146 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2GPMYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:24:52 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Adding support for configuring polarity in PWM framework.
Thread-Topic: Adding support for configuring polarity in PWM framework.
Thread-Index: Ac1jRByq1kMEXKqvQsO/bu3hkKjW/v//qtuA//+jJ2A=
Date: Mon, 16 Jul 2012 12:23:46 +0000
Deferred-Delivery: Mon, 16 Jul 2012 12:23:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E960C32@DBDE01.ent.ti.com>
References: <518397C60809E147AF5323E0420B992E3E960B0E@DBDE01.ent.ti.com>
 <20120716113921.GA3015@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120716113921.GA3015@avionic-0098.adnet.avionic-design.de>
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

On Mon, Jul 16, 2012 at 17:09:21, Thierry Reding wrote:
> On Mon, Jul 16, 2012 at 11:15:50AM +0000, Philip, Avinash wrote:
> > Hi Thierry,
> > 
> > On one of the custom boards we are using, uses PWM to drive the backlight. However, for
> > this device, PWM signal needs to be inversed.
> > So, we need to a platform data to indicate this parameter.
> > Current PWM framework doesn't provide .support for setting polarity (or inverse polarity).
> > 
> > Have you come across any such requirements? If so, do you have any plans to implement it?
> 
> I don't have any plans to implement such a feature.

Ok. Thanks for the quick response.
> 
> > I am planning to add support for the same but want to avoid duplication of work.
> > 
> > If you have no plans, then I will send a patch to support the same.
> 
> I wonder how you want to implement this. You'll need special hardware
> support for it 

Yes. Our custom hardware (backlight booster) requires the pwm signal to be 
inverted.

> you may be able to implement it in the driver itself 
> instead of putting it into the framework. 

This is a client specific data (backlight needs pwm signal inversed) 
and not the main device feature (not PWM IP). So we cannot send this in 
pwm platform data. This would come as call from client driver (which in 
our case is from pwm_bl.c)

> Anyway I'm interested in seeing your patch.

I am planning to modify PWM framework as below.
1. Configure PWM polarity from client driver (using platform data provided 
to pwm backlight driver).
2. PWM device needs to be disabled before calling the set-polarity API.

This involves

1. PWM framework API addition.
	PWM frame work API support.
	/**
	 * pwm_setpolarity() - change a PWM device Polarity	
	 * @pwm: PWM device
	 * @polarity: Configure polarity of PWM
 	*
	 * polarity     - false -> "on" time defined by duty ns
	*              - true  -> "off' time defined by duty ns.
 	*/
	int pwm_setpolarity(struct pwm_device *pwm, bool inversepol);

2. Add "set_polarity" operation support in pwm_ops.

3. Modification in backlight driver (pwm_bl.c) to support polarity configuration.

Thanks
Avinash

> 
> Thierry
> 

