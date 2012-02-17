Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2BQNov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:44:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39881 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab2BQNot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:44:49 -0500
Message-ID: <4F3E59CD.6050108@ti.com>
Date: Fri, 17 Feb 2012 14:44:45 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Aneesh V <aneesh@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 4/8] misc: emif: add basic infrastructure for EMIF
 driver
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-5-git-send-email-aneesh@ti.com> <4F3D2F2F.8050406@ti.com> <4F3E558A.3060605@ti.com>
In-Reply-To: <4F3E558A.3060605@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aneesh,

On 2/17/2012 2:26 PM, Aneesh V wrote:
> On Thursday 16 February 2012 10:00 PM, Cousson, Benoit wrote:
>> On 2/4/2012 1:16 PM, Aneesh V wrote:

[...]

>>> +/**
>>> + * struct emif_data - Per device static data for driver's use
>>> + * @duplicate: Whether the DDR devices attached to this EMIF
>>> + * instance are exactly same as that on EMIF1. In
>>> + * this case we can save some memory and processing
>>> + * @temperature_level: Maximum temperature of LPDDR2 devices attached
>>> + * to this EMIF - read from MR4 register. If there
>>> + * are two devices attached to this EMIF, this
>>> + * value is the maximum of the two temperature
>>> + * levels.
>>> + * @irq: IRQ number
>>
>> Do you really need to store the IRQ number?
>
> Yes, I need it right now because setup_interrupts() is called later,
> after the first frequency notification, because that's when I have the
> registers to be programmed on a temperature event. But I am re-thinking
> on this strategy. I will move it back to probe() because other
> interrupts can/should be enabled at probe() time. When I do that I
> won't have to store it anymore and I will remove it.

Yes, I saw the code in a later patch. But in that case you should have 
introduced that attribute in the patch that will use it and not before.

But I do agree, that requesting the interrupt in the probe is probably 
better.

[...]

>>> + emif = kzalloc(sizeof(struct emif_data), GFP_KERNEL);
>>
>> You should use the devm_* version of this API to get the simplify the
>> error handling / removal.
>
> Please note that most of my allocations are happening through
> kmemdup(). kmemdup() doesn't have a devm_* equivalent. So, I have a
> cleanup() function and in the interest of uniformity decided to avoid
> devm_* variants altogether.

I think it still worth using devm_kzalloc + memcopy here instead of 
kmemdup to avoid the cleanup() and simplify as well the error handling.

You might even propose a new devm_kmemdup API if you want.

Regards,
Benoit
