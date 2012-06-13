Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2FMM2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:28:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37739 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2FMM2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:28:22 -0400
Message-ID: <4FD88761.9050703@linaro.org>
Date: Wed, 13 Jun 2012 13:28:17 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C
 driver
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com> <4FD6F0E8.5040606@linaro.org> <CACRpkdYxiT-0x4aetMxB2x8SkB+Mmy8rk8uSzgU_anemSayhMw@mail.gmail.com> <4FD83AAD.2010701@linaro.org> <CACRpkdZC8E6izDpdnWy6DMjOdA6KsqTaPoaq9pErWoNW0Ewytw@mail.gmail.com>
In-Reply-To: <CACRpkdZC8E6izDpdnWy6DMjOdA6KsqTaPoaq9pErWoNW0Ewytw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/12 09:12, Linus Walleij wrote:
> On Wed, Jun 13, 2012 at 9:01 AM, Lee Jones<lee.jones@linaro.org>  wrote:
>
>> Board specific is fine, as the data is protected by a board specific
>> property. Do you mean that the properties are *bus specific*? In which case
>> I see your point and will apply the correct bindings.
>
> I cannot parse this, the board for me is a SoC, busses and a
> number of components connected via e.g. I2C.
>
> Can you define what you mean with a "board specific property"?
> It seems you are talking about what I would call an
> "SoC-specific property", i.e. something out of a .dtsi file for
> a certain SoC, whereas the .dts for an entire board is,
> well, for a board, a set of components on a PCB.
>
> The arrangement of accelerometers and battery monitors on a
> certain board is board-specific, and it is also by definition
> bus-specific.

Okay, let's put it another way. We can individualise any board, bus, 
platform, machine or system by placing all of the information in a DT 
node so long as we plonk it in the correct place within the Device Tree. 
However, we have just as much control by keeping them in separate 
structs in the C file and selecting the right one using the compatible 
sting.

The real item for discussion is; if we have varying configurations for 
each of the i2c buses residing on the same SoC, do we really want to use 
different compatible strings to identify each one. If the answer is no, 
which I think it is, then I need to write the bindings and have 
everything individually configurable from Device Tree.

While you're mulling this over, I'm just going to write the bindings anyway.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
