Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2HGPtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:49:24 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:38248 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661Ab2HGPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <2AE404CF-E456-408A-B7A2-D9B3D331C58E@dominion.thruhere.net>
References: <1343997486-710-1-git-send-email-sourav.poddar@ti.com>
	<1343997486-710-4-git-send-email-sourav.poddar@ti.com>
	<2AE404CF-E456-408A-B7A2-D9B3D331C58E@dominion.thruhere.net>
Date: Tue, 7 Aug 2012 21:19:15 +0530
Message-ID: <CAKdam56BCGkfwM8XKnULJ0bXDu6UF+mZqcyMgdqDZJ=oLZp3Gg@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm/dts: omap5-evm: Add keypad data
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Koen,

On Tue, Aug 7, 2012 at 6:24 PM, Koen Kooi <koen@dominion.thruhere.net> wrote:
>
> Op 3 aug. 2012, om 14:38 heeft Sourav Poddar <sourav.poddar@ti.com> het volgende geschreven:
>
>> Add keypad data node in omap5 device tree file.
>> Also fill the device tree binding parameters
>> with the required value in "omap5-evm" dts file.
>>
>> Tested on omap5430 evm with 3.5 custom kernel.
>>
>> Cc: Benoit Cousson <b-cousson@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>> ---
>> arch/arm/boot/dts/omap5-evm.dts |   12 ++++++++++++
>> arch/arm/boot/dts/omap5.dtsi    |    5 +++++
>> 2 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-evm.dts
>> index 45a8aeb..09fe941 100644
>> --- a/arch/arm/boot/dts/omap5-evm.dts
>> +++ b/arch/arm/boot/dts/omap5-evm.dts
>> @@ -17,6 +17,18 @@
>>               device_type = "memory";
>>               reg = <0x80000000 0x40000000>; /* 1 GB */
>>       };
>> +
>> +     keypad {
>> +             keypad,num-rows = <8>;
>> +             keypad,num-columns = <8>;
>> +             linux,keymap = < 0x02020073
>> +                     0x02030072
>> +                     0x020400e7
>> +                     0x02050066
>> +                     0x0206006b
>> +                     0x020700d9 >;
>> +             linux,input-no-autorepeat;
>> +     };
>
> Again not a coment on your patch, but on DT:
>
> If DT bindings must be OS independent, what then, is that linux keycode doing there?
>
Currently, for all matrix connected keyboards the keymap are defined
in the scope of the
linux key code since that is a stable and standardized interface at this time.

For the above reason , computation of the  keymap uses linux keycode

  row << 24 | column << 16 | linux-key-code
I think this is the primary reason for keeping "linux" prefix with this
property.
> regards,
>
> Koen
>
