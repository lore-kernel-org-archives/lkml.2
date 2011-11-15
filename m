Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab1KOHPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:15:52 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:52382
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752120Ab1KOHPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:15:51 -0500
Message-ID: <4EC2119C.5030405@compulab.co.il>
Date: Tue, 15 Nov 2011 09:15:40 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com> <74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/14/11 19:18, Stephen Warren wrote:
> Linus Walleij wrote at Monday, November 14, 2011 2:11 AM:
>> When requesting a single GPIO pin to be muxed in, some controllers
>> will need to poke a different value into the control register
>> depending on whether the pin will be used for GPIO output or GPIO
>> input. So pass this info along for the gpio_request_enable()
>> function, we assume this is not needed for the gpio_free_disable()
>> function for the time being.
> 
> I'm not sure this API change makes sense.
> 
> Functions gpio_direction_{input,output} already exist to configure the
> direction of a GPIO, and drivers should already be using them. These have
> to work to allow drivers to toggle the direction dynamically. Requiring
> them to additionally pass this same information to the pinmux driver when
> setting up the pinmux seems like extra redundant work.
> 
> Instead, shouldn't it work like this:
> 
> * If the pinmux driver implementation behind pinmux_request_gpio() needs
> to know the direction when configuring the HW, default to input for safety;
> that will prevent the SoC driving a signal on a GPIO that's driven by some
> other device.

If the GPIO has been configured for output by boot loader
and drives a value, and now you want Linux to take control over it,
then configuring it for input will not be safe at all.
I think this kind of flexibility is necessary (although it can be
implemented in different ways).

> 
> * Rely exclusively on gpio_direction_{input,output} to allow drivers to
> configure the direction.
> 
> * If the pinmux HW needs programming in response to the gpio_direction_*
> calls, have the GPIO and pinmux driver internally communicate to achieve
> this.
> 
> Does that seem reasonable?
> 

-- 
Regards,
Igor.
