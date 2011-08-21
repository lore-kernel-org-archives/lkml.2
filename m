Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1HUWKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:10:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34453 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1HUWKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:10:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6445"; a="111887897"
Message-ID: <bd22ca4871ed2ce80b881a36dac5061c.squirrel@www.codeaurora.org>
In-Reply-To: <1313724284.19990.136.camel@finisterre.wolfsonmicro.main>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
    <201108171242.24918.arnd@arndb.de>
    <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
    <201108171600.37791.arnd@arndb.de>
    <1313724284.19990.136.camel@finisterre.wolfsonmicro.main>
Date: Sun, 21 Aug 2011 15:10:49 -0700 (PDT)
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: "Sagar Dharia" <sdharia@codeaurora.org>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Kenneth Heitke" <kheitke@codeaurora.org>,
        sdharia@codeaurora.org, "David Brown" <davidb@codeaurora.org>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: sdharia@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 1. A simple potentially hotplugged device that registers itself to the
>> bus
>>    can be automatically matched to the driver.
>> 2. A device tree representation for hardwired devices that require
>>    something to happen in order to register to the bus (clock,
>> regulator,
>>    ...).
>> 3. A hardcoded list of devices on a slimbus host for stuff that is known
>>    to be there, e.g. on a PCI card that has its own driver and that
>>    also need some special setup as in case 2.
>
>> I think in all three cases, we should identify the device by its EA and
>> match that to the device driver. We create the slim_device and register
>> it to the bus as soon as one of the three above is found, but in case 2
>> and 3, the driver is responsible for the device to actually become
>> active
>> on the bus before it's allowed to send any commands to it.
>
> Yes, I think that makes sense and it matches what we're doing with the
> other subsystems well. We should be able to make the drivers work with
> all cases. Probably the probe function should have a flag and/or query
> function to let the driver know if the device has actually appeared yet.
>

Thanks again everyone for your feedback.
I will make sure to use the fields of the 48-bit elemental address for
device-to-driver-matching and will try to incorporate hot-plug
capabilities for the device powering up without assistance from the
driver's probe function. Other cases discussed in the mixed-approach will
be supported as well.
Another suggestion about probe is having callback to notify when the
device is ready-to-use after driver probe powers it up. I will change the
framework accordingly to have this done.

>> For the device tree binding, I would suggest defining a slimbus bus to
>> have #address-cells=1, #size-cells=0 and just put the EA into the reg
>> property. This is enough for the host driver to add create a
>> slim_device and match a driver to it. The driver can access all the
>> properties from the device_node (or platform_data in case of statically
>> defined devices). When the physical device shows up on the bus, it is
>> automatically associated with the existing slim_device.
>
> Sounds reasonable I'd need to actually look at the specs again for the
> details.
I will try to incorporate device-tree binding in the framework and put it
up for review for more suggestions.

-Sagar

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

