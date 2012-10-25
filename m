Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab2JYOMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:12:13 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:35013 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2JYOMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:12:08 -0400
Message-ID: <508948A5.3020005@free-electrons.com>
Date: Thu, 25 Oct 2012 16:11:49 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>, Ike Pan <ike.pan@canonical.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jon Masters <jcm@redhat.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and config
 update
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com> <1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com> <20121024160139.6dbf5e16@skate> <5087F5B9.0@free-electrons.com> <20121025131818.GF18811@titan.lakedaemon.net> <50894471.9040000@gmail.com>
In-Reply-To: <50894471.9040000@gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 03:53 PM, Rob Herring wrote:
> On 10/25/2012 08:18 AM, Jason Cooper wrote:
>> On Wed, Oct 24, 2012 at 04:05:45PM +0200, Gregory CLEMENT wrote:
>>> On 10/24/2012 04:01 PM, Thomas Petazzoni wrote:
>>>> Hello,
>>>>
>>>> Shouldn't you split into one commit adding the SATA definition in
>>>> the .dtsi + doing the defconfig change (the "SoC" level modifications),
>>>> and then another commit for the .dts change? I don't really care
>>>> personally, it's really up to Jason/Andrew on this.
>>>>
>>>> Another comment below, though.
>>>>
>>>> On Wed, 24 Oct 2012 15:49:21 +0200, Gregory CLEMENT wrote:
>>>>
>>>>> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
>>>>> index 94b4b9e..3f08233 100644
>>>>> --- a/arch/arm/boot/dts/armada-370-xp.dtsi
>>>>> +++ b/arch/arm/boot/dts/armada-370-xp.dtsi
>>>>> @@ -69,6 +69,16 @@
>>>>>  			compatible = "marvell,armada-addr-decoding-controller";
>>>>>  			reg = <0xd0020000 0x258>;
>>>>>  		};
>>>>> +
>>>>> +		sata@d00a0000 {
>>>>> +                        compatible = "marvell,orion-sata";
>>>>> +                        reg = <0xd00a0000 0x2400>;
>>>>> +                        interrupts = <55>;
>>>>> +                        nr-ports = <2>;
>>>>> +			clocks = <&coreclk 0>;//,  <&coreclk 0>;
>>>>
>>>> Alignment problem + remainings of tests or something like that.
>>>
>>> True I missed this one.
>>>
>>> Jason, Andrew, do you want I split this patch as suggested by Thomas or
>>> are you fine with having one single patch?
>>
>> Yes, please make the defconfig changes a separate patch.  Also, please
>> make sure only the minimum is enabled (eq RAID... isn't needed).
> 
> What about updating multi_v7_defconfig instead?

About the _instead_, when I proposed to removed mvebu_defconfig Thomas
argued that it was more convenient to build a mvebu-only kernel when
doing kernel development, and Andrew also pointed that this defconfig
should be useful for kisskb.

And about updated both mvebu_defconfig and multi_v7_defconfig, I'm
fine with it.

Gregory
