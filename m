Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1CSRVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 13:21:52 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:54298 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab1CSRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 13:21:49 -0400
Message-ID: <4D84E62B.1070301@wildgooses.com>
Date: Sat, 19 Mar 2011 17:21:47 +0000
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: kernel@wildgooses.com
CC: grant.likely@secretlab.ca, dilinger@queued.net,
        linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: New PCEngines Alix system driver (enables LEDs
 via gpio interface)
References: <AANLkTinJNFZ-c_+Cuan5ebuRadrOvdfivxQjnN9GZPt=@mail.gmail.com> <1300553466-23873-1-git-send-email-kernel@wildgooses.com>
In-Reply-To: <1300553466-23873-1-git-send-email-kernel@wildgooses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19/03/2011 16:51, kernel@wildgooses.com wrote:
> From: Ed Wildgoose <git@wildgooses.com>
> 
> This new driver replaces the old PCEngines Alix 2/3 LED driver with
> a new driver that controls the LEDs through the leds-gpio driver.
> The old driver accessed GPIOs directly, which created a conflict
> and prevented also loading the cs5535-gpio driver to read other
> GPIOs on the Alix board. With this new driver, we hook into leds-gpio
> which in turn uses GPIO to control the LEDs and therefore it's
> possible to control both the LEDs and access onboard GPIOs
> 
> Driver is moved to platform/geode and any other geode
> initialisation modules should move here also.
> 
> This driver is inspired by leds-net5501.c
> by: Alessandro Zummo <a.zummo@towertech.it>
> Ideally, leds-net5501.c should also be moved to platform/geode.
> Additionally the driver relies on parts of the patch: 7f131cf3ed
> by: Daniel Mack <daniel@caiaq.de> to perform detection of the Alix board
> Signed-off-by: Ed Wildgoose <kernel@wildgooses.com>

Hi Grant

I *think* this patch should now be satisfactory and I believe to be
implemented as we discussed:

- I have made the driver look like a straightforward platform
initialisation routine and so further platform setup could be added here
if required.

My only thought is that it's quite tucked away and hard to find here,
given that at present it only enables LEDs on this platform (and seems
reasonably unlikely to grow beyond that). Would it be
acceptable/sensible to put the Kconfig entry under LEDs for the time
being (but the code under /platform/)? Obviously if it starts to do more
initialisation/setup then the KConfig can be moved back to /arch/x86/ ?

However, grateful if you could please now review this for inclusion?

I will submit a second patch momentarily which adds the extra dependency
of -gpio on -mfd as we discussed in the previous email

Many thanks

Ed W
