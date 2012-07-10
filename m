Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab2GJIcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:32:55 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:52744 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685Ab2GJIcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:32:51 -0400
Message-ID: <4FFBE8A9.6050608@ti.com>
Date: Tue, 10 Jul 2012 14:02:41 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Subject: Re: [PATCH v1 10/11] arm/dts: omap: Add usb_otg and glue data
References: <1340884267-28908-1-git-send-email-kishon@ti.com>	<1340884267-28908-11-git-send-email-kishon@ti.com>	<4FFBCB39.1010809@ti.com> <CAAe_U6LqF9aZLZgHQYhX6VXXB41HUNmZgXfOwe9V9VtWVe+46g@mail.gmail.com>
In-Reply-To: <CAAe_U6LqF9aZLZgHQYhX6VXXB41HUNmZgXfOwe9V9VtWVe+46g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012 01:43 PM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>
> On Tue, Jul 10, 2012 at 11:57 AM, Rajendra Nayak<rnayak@ti.com>  wrote:
>> On Thursday 28 June 2012 05:21 PM, Kishon Vijay Abraham I wrote:
>>>
>>> Add usb otg data node in omap4/omap3 device tree file. Also update
>>> the node with board specific setting in omapx-<board>.dts file.
>>>
>>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>>> ---
>>>    arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
>>>    arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
>>>    arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
>>>    arch/arm/boot/dts/omap4-panda.dts  |    6 ++++++
>>>    arch/arm/boot/dts/omap4-sdp.dts    |    6 ++++++
>>>    arch/arm/boot/dts/omap4.dtsi       |    8 ++++++++
>>>    6 files changed, 40 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/omap3-beagle.dts
>>> b/arch/arm/boot/dts/omap3-beagle.dts
>>> index 5b4506c..f3d7076 100644
>>> --- a/arch/arm/boot/dts/omap3-beagle.dts
>>> +++ b/arch/arm/boot/dts/omap3-beagle.dts
>>> @@ -67,3 +67,9 @@
>>>    &mmc3 {
>>>          status = "disable";
>>>    };
>>> +
>>> +&usb_otg_hs {
>>> +       interface_type =<0>;
>>> +       mode =<3>;
>>> +       power =<50>;
>>> +};
>>> diff --git a/arch/arm/boot/dts/omap3-evm.dts
>>> b/arch/arm/boot/dts/omap3-evm.dts
>>> index 2eee16e..8963b3d 100644
>>> --- a/arch/arm/boot/dts/omap3-evm.dts
>>> +++ b/arch/arm/boot/dts/omap3-evm.dts
>>> @@ -18,3 +18,9 @@
>>>                  reg =<0x80000000 0x10000000>; /* 256 MB */
>>>          };
>>>    };
>>> +
>>> +&usb_otg_hs {
>>> +       interface_type =<0>;
>>> +       mode =<3>;
>>> +       power =<50>;
>>> +};
>>> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
>>> index 99474fa..2f565d6 100644
>>> --- a/arch/arm/boot/dts/omap3.dtsi
>>> +++ b/arch/arm/boot/dts/omap3.dtsi
>>> @@ -215,5 +215,13 @@
>>>                          compatible = "ti,omap3-hsmmc";
>>>                          ti,hwmods = "mmc3";
>>>                  };
>>> +
>>> +               usb_otg_hs: usb_otg_hs@4a0ab000 {
>>> +                       compatible = "ti,musb-omap2430";
>>
>>
>> this compatible doesn't seem right in omap3.dtsi. Same with
>> the below entry in omap4.dtsi.
>> See other IP blocks which are reused across OMAP2/3/4 on
>> how the compatible for those are handled.
>
> Ok. So it should be like *ti,omap4-musb*, *ti,omap3-musb*?

Yes, that would be more appropriate.

>
> Thanks
> Kishon

