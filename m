Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2LSNv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:51:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35007 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab2LSNvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:51:21 -0500
Message-ID: <50D1C652.3050607@ti.com>
Date: Wed, 19 Dec 2012 14:51:14 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, Luciano Coelho <coelho@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, <svenkatr@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <r.sricharan@ti.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
References: <1352968293.10872.51.camel@cumari.coelho.fi> <20121218095450.GB27751@arwen.pp.htv.fi> <20121219094552.GN4985@opensource.wolfsonmicro.com> <50D19040.5090404@ti.com> <20121219100909.GO4985@opensource.wolfsonmicro.com> <50D19463.5010605@ti.com> <20121219103206.GQ4985@opensource.wolfsonmicro.com> <1355913954.5273.21.camel@cumari.coelho.fi> <50D19D54.2000307@ti.com> <20121219130128.GC17993@arwen.pp.htv.fi>
In-Reply-To: <20121219130128.GC17993@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 02:01 PM, Felipe Balbi wrote:
> Hi,
> 
> +Sricharan who commited that
> 
> On Wed, Dec 19, 2012 at 11:56:20AM +0100, Peter Ujfalusi wrote:
>> On 12/19/2012 11:45 AM, Luciano Coelho wrote:
>>>> Well, we still haven't got the foggiest idea what the actual problem is
>>>> beyond that it's probably related to the 32kHz clock in some way (unless
>>>> it was one of the other reverts that coincidentally made a difference,
>>>> but we don't know what they were) so it's unlikely that just randomly
>>>> implementing clock support is going to fix anything immediately here.
>>>
>>> This is exactly what I had to revert (as I mentioned in the other email,
>>> I had to revert the other patches otherwise compilation would break):
>>>
>>> 0e8e5c34 "regulator: twl: Remove references to 32kHz clock from DT bindings"
>>> e76ab829 "regulator: twl: Remove references to the twl4030 regulator"
>>> 029dd3ce "regulator: twl: Remove another unused variable warning"
>>
>> Yeah. 32k clock is not provided by twl.
>>
>> As I said I need to take a look at CCF to see if it already there. If it is
>> clock driver + mapping + patch for wl12xx should fix the issue you are facing.
>>
>>> Let me know if you need more info.
>>
>> BTW: have you happened to ubdate u-boot recently? There is a nice easter egg
>> added there:
>> f3f98bb ARM: OMAP4/5: Do not configure non essential pads, clocks, dplls.
>>
>> Which means that _essential_ clocks and pads are no longer configured.
> 
> anything essential you can list ?

Yeah, that u-boot version is just unusable at all with any mainline
kernel, since we are still missing pads conf for every drivers.

Regarding the 32k clock, I noticed as well that the OMAP4460 panda
u-boot is the only one to enable it at boot time, and thus this is the
only board that can probe the wilink chip properly as of today.

Regards,
Benoit

