Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2BIGDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:03:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10149 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2BIGDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:03:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 08 Feb 2012 22:03:14 -0800
Message-ID: <4F33613F.2080805@nvidia.com>
Date: Thu, 9 Feb 2012 11:31:35 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "grant@secretlab.ca" <grant@secretlab.ca>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: fixed: Support for open-drain gpio
References: <1328611596-13279-1-git-send-email-ldewangan@nvidia.com> <20120207114341.GJ3332@opensource.wolfsonmicro.com>
In-Reply-To: <20120207114341.GJ3332@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 February 2012 05:13 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Feb 07, 2012 at 04:16:36PM +0530, Laxman Dewangan wrote:
>
>> To make the pin to high/low for enabling/disabling the switches,
>> the pins will have the pull-up connected and the high/low can be
>> set using following methods:
>> LOW: gpio_direction_output(gpio, 0) ... this drives the signal
>> 	and overrides the pullup.
>> HIGH: gpio_direction_input(gpio) ... this turns off the output,
>> 	so the pullup (or some other device) controls the signal.
> Thinking about this further this is potentially going to apply to any
> GPIO output - perhaps we should push the implementation down into
> gpiolib so we just specify a flag when requesting the GPIO and then
> gpiolib does the pull low/high Z thing for us.  That would be much less
> effort in individual drivers, we'd just need to be able to set the flag
> and could potentially directly use any hardware open drain output
> support (some GPIO controllers will do all this in hardware) if the
> driver API were extended.  Grant, does that sound reasonable?
>
If Grant agree on this then we can have following thing:
- we have already apis like gpio_request_one() and 
gpio_request_multiple() which take the flags.
- We need to add the flag GPIOF_OD in current list of flags for requester.
- In the gpio_request_xx(), just store this flag in gpio_desc for 
corresponding gpios.
- When client set direction_output() with val 1 then do 
direction_input(). So check will be in function direction_output()
- When client  call set_value(), again check for value ==1 and GPIO_OD 
and if it is there, call direction_input.

On client side change, call proper request function with proper flag 
(with GPIOF_OD if it is require).

Does it sound good?

> * Unknown Key
> * 0x6E30FDDD

