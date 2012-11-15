Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768391Ab2KOQPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:15:40 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:49817 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993458Ab2KOQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:15:38 -0500
Message-ID: <50A51515.3020206@stericsson.com>
Date: Thu, 15 Nov 2012 17:15:17 +0100
From: =?ISO-8859-1?Q?Per_F=F6rlin?= <per.forlin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Fredrik SODERSTEDT <fredrik.soderstedt@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt: platform: Extract device name from device tree blob
References: <1352732343-1199-1-git-send-email-per.forlin@stericsson.com> <CACxGe6vjLA3j-bc_048UrdB5Q=8pV8=LPSVUnU_k3anX23vwyw@mail.gmail.com> <50A17E30.7030807@stericsson.com> <20121115155246.C4EC83E194B@localhost>
In-Reply-To: <20121115155246.C4EC83E194B@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 04:52 PM, Grant Likely wrote:
> On Mon, 12 Nov 2012 23:54:40 +0100, Per Förlin <per.forlin@stericsson.com> wrote:
>> On 11/12/2012 04:20 PM, Grant Likely wrote:
>>> On Mon, Nov 12, 2012 at 2:59 PM, Per Forlin <per.forlin@stericsson.com> wrote:
>>>> Add support to extract device name from device tree blob.
>>>> If the property "dev-name" is set in the DTS this name will
>>>> be used when creating the device.
>>>> The auxdata_lookup has precedence and will override
>>>> the "dev-name" property.
>>>
>>> Using a 'dev-name' property has the same problem that the 'cell-index'
>>> properties have in that it is encoding part of the global namespace
>>> local to the node and it becomes easy to create collisions. Instead of
>>> this check to see if one of the properties in /aliases points to the
>>> node and use that for the name.
>>>
>>> g.
>>>
>> Thanks Grant for your feedback,
>>
>> Extract from exynos5250.dtsi:
>> -----------
>> 	aliases {
>> 		spi0 = &spi_0;
>> 		spi1 = &spi_1;
>> 		spi2 = &spi_2;
>> 	};
>>
>> 	spi_0: spi@12d20000 {
>> ...
>> 	};
>>
>> 	spi_1: spi@12d30000 {
>> ...
>> 	};
>>
>> 	spi_2: spi@12d40000 {
>> ...
>> 	};
>> ---------------
>>
>> Alias refers to the device node. The device node is not aware of the alias.
>>
>> How to get a device name from the aliases.
>> 1. Traverse all aliases for each device node (time consuming if there are many aliases)
>> 2. Make a new function of_alias_get_name(), today there is only of_alias_get_id()
>> 3. The functionality of setting device_name based on alias name needs to be optional because one may want to use aliases without changing the name of the device.
>> All this is feasible but perhaps not optimal.
>>
>> I don't really see how come name space is a big issue in this case. The name space of "dev-name" is local to the device node. A child device node can use the same dev-name as the parent (unless I'm mistaken which happens quite often). Introducing yet another property name pollutes the name space of the device node. Still I think the pros are stronger than the cons.
>>
>> Do you still prefer to use the name of the Alias? Could you please elaborate a bit more how this can be done in practice?
>> I would agree with you if there was a reference from the device node to the alias.
> 
> Oh, I see what you're trying to do. As Lee pointed out you're trying to
> make the Linux internal way of matching up clocks and regulators happy.
> That is very much a Linux-kernel internal thing and should be solved in
> the kernel. Trying to solve it with fixed names in the device tree will
> cause problems down the road.
> 
> I though you were wanting to have logical names for the devices that
> make sense to the user which is how aliases is used now.
> 
> So, no, don't do this.
> 
> g.
> 
Hi,

I came to the same conclusion when I dag into it some more. I replied to my own comment and concluded (https://lkml.org/lkml/2012/11/13/309).
The solution is to move clocks and regulators into the DTS. When this is done there will be no need for setting a specific device-name (all those auxdata_lookup can be removed)

BR
Per

