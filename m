Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2I0OYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:24:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65042 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2I0OYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:24:36 -0400
Message-ID: <506461A0.4050103@gmail.com>
Date: Thu, 27 Sep 2012 09:24:32 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob@landley.net, b-cousson@ti.com,
        tony@atomide.com, linux@arm.linux.org.uk, balbi@ti.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: usb: phy: add a new driver for omap usb2
 phy
References: <1346943430-18236-1-git-send-email-kishon@ti.com> <1346943430-18236-2-git-send-email-kishon@ti.com> <50605CFB.5090402@gmail.com> <CAAe_U6+2Vxd8F_JMafm41+0SnZSrZCa_9VKRbdB200BUHw5vEQ@mail.gmail.com>
In-Reply-To: <CAAe_U6+2Vxd8F_JMafm41+0SnZSrZCa_9VKRbdB200BUHw5vEQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 05:06 AM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
> 
> On Mon, Sep 24, 2012 at 6:45 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On 09/06/2012 09:57 AM, Kishon Vijay Abraham I wrote:
>>> All phy related programming like enabling/disabling the clocks, powering
>>> on/off the phy is taken care of by this driver. It is also used for OTG
>>> related functionality like srp.
>>>
>>> This also includes device tree support for usb2 phy driver and
>>> the documentation with device tree binding information is updated.
>>>
>>> Currently writing to control module register is taken care in this
>>> driver which will be removed once the control module driver is in place.
>>>
>>> Cc: Felipe Balbi <balbi@ti.com>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>> ---
>>>  Documentation/devicetree/bindings/usb/usb-phy.txt |   17 ++
>>>  drivers/usb/phy/Kconfig                           |    9 +
>>>  drivers/usb/phy/Makefile                          |    1 +
>>>  drivers/usb/phy/omap-usb2.c                       |  271 +++++++++++++++++++++
>>>  include/linux/usb/omap_usb.h                      |   46 ++++
>>>  include/linux/usb/phy_companion.h                 |   34 +++
>>>  6 files changed, 378 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/usb/usb-phy.txt
>>>  create mode 100644 drivers/usb/phy/omap-usb2.c
>>>  create mode 100644 include/linux/usb/omap_usb.h
>>>  create mode 100644 include/linux/usb/phy_companion.h
>>>
>>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
>>> new file mode 100644
>>> index 0000000..80d4148
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
>>
>> This is a very generic name...
>>
>>> @@ -0,0 +1,17 @@
>>> +USB PHY
>>> +
>>> +OMAP USB2 PHY
>>> +
>>> +Required properties:
>>> + - compatible: Should be "ti,omap-usb2"
>>
>> ...for a specific phy. However, I do think a generic binding to describe
>> host ctrlr to phy connections is needed.
>>
>>> + - reg : Address and length of the register set for the device. Also
>>> +add the address of control module dev conf register until a driver for
>>> +control module is added
>>
>> The dts should describe the h/w, not what you need for the current
>> driver. The 2nd reg field does not belong here.
> 
> Indeed. This was discussed and agreed upon as a interim solution till
> we have a control module driver in place to write to the control
> module register.

Discussed where and agreed by who? I for one do not agree.

Rob

>>
>>> +
>>> +This is usually a subnode of ocp2scp to which it is connected.
>>
>> How is usb port to phy connection described?
> Currently the usb controller to phy connection is established only by
> type. We have a couple of patches being currently discussed in the
> list to establish the connection by phandle.
> 
> https://patchwork.kernel.org/patch/1457801/ (Generic PHY Framework:
> devm_of_phy_get())
> http://www.spinics.net/lists/linux-usb/msg69547.html
> 
> Thanks
> Kishon
> 

