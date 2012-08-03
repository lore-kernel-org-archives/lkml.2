Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2HCNGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:06:08 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:52784 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752037Ab2HCNGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <D32DBB77-844C-400A-9E3F-3F779431D1C7@dominion.thruhere.net>
References: <1343997486-710-1-git-send-email-sourav.poddar@ti.com>
	<1343997486-710-4-git-send-email-sourav.poddar@ti.com>
	<D32DBB77-844C-400A-9E3F-3F779431D1C7@dominion.thruhere.net>
Date: Fri, 3 Aug 2012 18:36:04 +0530
Message-ID: <CAKdam54HpC33Bk8gDjRRcB+9=O8Dh4UAKhY4mpHBdvk_uEj9uQ@mail.gmail.com>
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

Hi,

On Fri, Aug 3, 2012 at 6:20 PM, Koen Kooi <koen@dominion.thruhere.net> wrote:
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
> This not a criticism on your patch, but a generic question about DT: Is there no way to have nice constants for keys like we have in the kernel, like KEY_POWER, KEY_UP, etc?
There is way, something like this ..
               key_C {
                       keypad,row = <2>;
                       keypad,column = <1>;
                       linux,code = <46>;
               };
But its not the preferred approach mainly because of the fact that
it is too big. So suppose, if we have 100 key codes, we will have
400 -500 lines of code in our dts file for the mapping only.
 If no, does DT allow comments so I can look at a dts and see which
keycodes are mapped instead of having to dig up the sources?
Yes, comments are allowed and seems to be better option to do.

~Sourav
>
> regards,
>
> Koen
