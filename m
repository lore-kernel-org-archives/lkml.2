Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1I1RmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:42:12 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14231 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1I1RmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:42:11 -0400
Message-ID: <4E835C71.1010108@cavium.com>
Date: Wed, 28 Sep 2011 10:42:09 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
References: <1317166015-20714-1-git-send-email-david.daney@cavium.com> <1317166015-20714-3-git-send-email-david.daney@cavium.com> <CAHXqBFLzrkH4AJVozbtT4k7ccgVgfaPoq69J48DeSJKSwEtxHw@mail.gmail.com> <4E8350A8.7090307@cavium.com> <CAHXqBF+ZVbCGEvnCcOtHk+sOWFLp1CuEnGLq+GEtHQTpu9PuYg@mail.gmail.com>
In-Reply-To: <CAHXqBF+ZVbCGEvnCcOtHk+sOWFLp1CuEnGLq+GEtHQTpu9PuYg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Sep 2011 17:42:11.0180 (UTC) FILETIME=[F37B92C0:01CC7E05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 10:32 AM, Micha³ Miros³aw wrote:
> W dniu 28 wrze¶nia 2011 18:51 u¿ytkownik David Daney
> <david.daney@cavium.com>  napisa³:
>> On 09/28/2011 12:25 AM, Micha³ Miros³aw wrote:
>>>
>>> 2011/9/28 David Daney<david.daney@cavium.com>:
>>> [...]
>>>>
>>>> +Example :
>>>> +
>>>> +       /* The parent MDIO bus. */
>>>> +       smi1: mdio@1180000001900 {
>>>> +               compatible = "cavium,octeon-3860-mdio";
>>>> +               #address-cells =<1>;
>>>> +               #size-cells =<0>;
>>>> +               reg =<0x11800 0x00001900 0x0 0x40>;
>>>> +       };
>>>> +
>>>> +       /*
>>>> +          An NXP sn74cbtlv3253 dual 1-of-4 switch controlled by a
>>>> +          pair of GPIO lines.  Child busses 2 and 3 populated with 4
>>>> +          PHYs each.
>>>> +        */
>>>> +       mdio-mux {
>>>> +               compatible = "cavium,mdio-mux-sn74cbtlv3253",
>>>> "cavium,mdio-mux";
>>>> +               gpios =<&gpio1 3 0>,<&gpio1 4 0>;
>>>> +               mdio-parent-bus =<&smi1>;
>>>> +               #address-cells =<1>;
>>>> +               #size-cells =<0>;
>>>
>>> This should probably have 'compatible = "nxp,sn74cbtlv3253";' here.
>>>
>>
>> No, the sn74cbtlv3253 is a general purpose part that could be used to
>> multiplex anything (I2C, SPI, random analog signals, etc.).  Only when it is
>> in the "cavium,mdio-mux-sn74cbtlv3253" configuration is it an MDIO bus
>> multiplexer.
>
> This should use some generic name then. 'mdio-mux-gpio' or something.
> There's no point in introducing chip's model for a gate-like discrete
> device.

That could be.  We could define an "mdio-mux-gpio" as something that 
selects the child bus based on the binary encoded value presented on the 
GPIO lines.

I will regenerate the patch set with this in mind.  Note that the only 
part of this patch that will change is this mdio-mux.txt file, no actual 
code is affected.  In patch 3/3 I will add "mdio-mux-gpio" to the 
.of_match_table.

Thanks,
David Daney
