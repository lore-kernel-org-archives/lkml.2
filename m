Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2FMHBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:01:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2FMHBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:01:05 -0400
Message-ID: <4FD83AAD.2010701@linaro.org>
Date: Wed, 13 Jun 2012 08:01:01 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C
 driver
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com> <4FD6F0E8.5040606@linaro.org> <CACRpkdYxiT-0x4aetMxB2x8SkB+Mmy8rk8uSzgU_anemSayhMw@mail.gmail.com>
In-Reply-To: <CACRpkdYxiT-0x4aetMxB2x8SkB+Mmy8rk8uSzgU_anemSayhMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/12 06:40, Linus Walleij wrote:
> On Tue, Jun 12, 2012 at 9:34 AM, Lee Jones<lee.jones@linaro.org>  wrote:
>> On 11/06/12 21:37, Linus Walleij wrote:
>>>
>>> So why don't we create proper device tree bindings for the above platform
>>> data?
>>> (...)
>>> This looks to me like a way to push the burden of doing the real
>>> device tree binding for the above to the next user.
>>> (Which will likely be me, so therefore I care a bit ...)
>>
>>
>> On the contrary. This will avoid any added Device Tree complexity and ensure
>> that no extra vendor specific bindings are required. When a new user wishes
>> to use the driver, all they (you) have to do is create a new struct with the
>> platform specific information and add the entry to nmk_gpio_match[],
>> simples.
>>
>> I've even added the logic to extract any information you provide via
>> nmk_gpio_match[] for use as platform data. This keeps it both out of
>> platform code and the Device Tree binary. Everyone's a winner. :)
>
> No. You assume that the platform data is a chip-specific property,
> and that it will be the same for all busses on the chip. But it
> isn't.
>
> The above platform data is *board specific*, it depends on
> what devices have been connected to each bus.
>
> For example the max frequency: this depends on the maximum
> frequency any of the devices connected to one very bus
> can support.
>
> The other platforms have put this frequency into their device
> trees for a reason, and this is it.
>
> So for the four different i2c busses there may need to be
> four different platform data sets. How are you going to
> distinguish between the four buses?
>
> This is thus broken and needs to have proper bindings.

Board specific is fine, as the data is protected by a board specific 
property. Do you mean that the properties are *bus specific*? In which 
case I see your point and will apply the correct bindings.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
