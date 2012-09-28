Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031572Ab2I1Tnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:43:41 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:49661 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965233Ab2I1S7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:30 -0400
MIME-Version: 1.0
In-Reply-To: <5065BE44.3090903@ti.com>
References: <1346943430-18236-1-git-send-email-kishon@ti.com>
	<1346943430-18236-2-git-send-email-kishon@ti.com>
	<50605CFB.5090402@gmail.com>
	<CAAe_U6+2Vxd8F_JMafm41+0SnZSrZCa_9VKRbdB200BUHw5vEQ@mail.gmail.com>
	<506461A0.4050103@gmail.com>
	<5064D7CA.1070909@ti.com>
	<CAAe_U6KHk1nuSBVn-4H397wzUk0cnqGe_H0D8RVqrSFYGJVMCg@mail.gmail.com>
	<5065BE44.3090903@ti.com>
Date: Sat, 29 Sep 2012 00:29:26 +0530
Message-ID: <CAAe_U6KfcucSHyndadUXiHer4jxYmMkFp1Ur0oNHTjJeOui04g@mail.gmail.com>
Subject: Re: [PATCH 1/5] drivers: usb: phy: add a new driver for omap usb2 phy
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Rob Herring <robherring2@gmail.com>, grant.likely@secretlab.ca,
        rob@landley.net, tony@atomide.com, linux@arm.linux.org.uk,
        balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 28, 2012 at 8:42 PM, Cousson, Benoit <b-cousson@ti.com> wrote:
> On 9/28/2012 3:07 AM, ABRAHAM, KISHON VIJAY wrote:
>>
>> Hi,
>>
>> On Fri, Sep 28, 2012 at 4:18 AM, Cousson, Benoit <b-cousson@ti.com> wrote:
>>>
>>> On 9/27/2012 7:24 AM, Rob Herring wrote:
>>>>
>>>>
>>>> On 09/25/2012 05:06 AM, ABRAHAM, KISHON VIJAY wrote:
>>>>>
>>>>>
>>>>> Hi,
>>>>>
>>>>> On Mon, Sep 24, 2012 at 6:45 PM, Rob Herring <robherring2@gmail.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> On 09/06/2012 09:57 AM, Kishon Vijay Abraham I wrote:
>>>>>>>
>>>>>>>
>>>>>>> All phy related programming like enabling/disabling the clocks,
>>>>>>> powering
>>>>>>> on/off the phy is taken care of by this driver. It is also used for
>>>>>>> OTG
>>>>>>> related functionality like srp.
>>>>>>>
>>>>>>> This also includes device tree support for usb2 phy driver and
>>>>>>> the documentation with device tree binding information is updated.
>>>>>>>
>>>>>>> Currently writing to control module register is taken care in this
>>>>>>> driver which will be removed once the control module driver is in
>>>>>>> place.
>>>>>>>
>>>>>>> Cc: Felipe Balbi <balbi@ti.com>
>>>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>>>> ---
>>>>>>>    Documentation/devicetree/bindings/usb/usb-phy.txt |   17 ++
>>>>>>>    drivers/usb/phy/Kconfig                           |    9 +
>>>>>>>    drivers/usb/phy/Makefile                          |    1 +
>>>>>>>    drivers/usb/phy/omap-usb2.c                       |  271
>>>>>>> +++++++++++++++++++++
>>>>>>>    include/linux/usb/omap_usb.h                      |   46 ++++
>>>>>>>    include/linux/usb/phy_companion.h                 |   34 +++
>>>>>>>    6 files changed, 378 insertions(+)
>>>>>>>    create mode 100644
>>>>>>> Documentation/devicetree/bindings/usb/usb-phy.txt
>>>>>>>    create mode 100644 drivers/usb/phy/omap-usb2.c
>>>>>>>    create mode 100644 include/linux/usb/omap_usb.h
>>>>>>>    create mode 100644 include/linux/usb/phy_companion.h
>>>>>>>
>>>>>>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt
>>>>>>> b/Documentation/devicetree/bindings/usb/usb-phy.txt
>>>>>>> new file mode 100644
>>>>>>> index 0000000..80d4148
>>>>>>> --- /dev/null
>>>>>>> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
>>>>>>
>>>>>>
>>>>>>
>>>>>> This is a very generic name...
>>>>>>
>>>>>>> @@ -0,0 +1,17 @@
>>>>>>> +USB PHY
>>>>>>> +
>>>>>>> +OMAP USB2 PHY
>>>>>>> +
>>>>>>> +Required properties:
>>>>>>> + - compatible: Should be "ti,omap-usb2"
>>>>>>
>>>>>>
>>>>>>
>>>>>> ...for a specific phy. However, I do think a generic binding to
>>>>>> describe
>>>>>> host ctrlr to phy connections is needed.
>>>>>>
>>>>>>> + - reg : Address and length of the register set for the device. Also
>>>>>>> +add the address of control module dev conf register until a driver
>>>>>>> for
>>>>>>> +control module is added
>>>>>>
>>>>>>
>>>>>>
>>>>>> The dts should describe the h/w, not what you need for the current
>>>>>> driver. The 2nd reg field does not belong here.
>>>>>
>>>>>
>>>>>
>>>>> Indeed. This was discussed and agreed upon as a interim solution till
>>>>> we have a control module driver in place to write to the control
>>>>> module register.
>>>>
>>>>
>>>>
>>>> Discussed where and agreed by who? I for one do not agree.
>>>
>>>
>>>
>>> Yeah, what was tolerated was the addition of that address inside hwmod
>>> data,
>>> but I do agree that it should not go into DTS.
>>
>>
>> So how can we handle reg writes to control module until we have a
>> control module driver. usb2 phy does not have a hwmod data for itself.
>> Do you think we should add a new hwmod data for usb2 phy and use this
>> in the usb2phy data node in the dts file?
>
>
> Now, I'm confused... didn't you already do that? What was the hwmod you
> added?

That was in usb_otg_hs (musb glue for omap) for writing to MUSB
mailbox. This is for usb2 phy for powering on/off the PHY.

Thanks
Kishon
