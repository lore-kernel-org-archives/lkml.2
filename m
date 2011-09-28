Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1I1Rci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:32:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41374 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1I1Rcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:32:36 -0400
MIME-Version: 1.0
In-Reply-To: <4E8350A8.7090307@cavium.com>
References: <1317166015-20714-1-git-send-email-david.daney@cavium.com>
 <1317166015-20714-3-git-send-email-david.daney@cavium.com>
 <CAHXqBFLzrkH4AJVozbtT4k7ccgVgfaPoq69J48DeSJKSwEtxHw@mail.gmail.com> <4E8350A8.7090307@cavium.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 28 Sep 2011 19:32:16 +0200
Message-ID: <CAHXqBF+ZVbCGEvnCcOtHk+sOWFLp1CuEnGLq+GEtHQTpu9PuYg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
To: David Daney <david.daney@cavium.com>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 28 wrze¶nia 2011 18:51 u¿ytkownik David Daney
<david.daney@cavium.com> napisa³:
> On 09/28/2011 12:25 AM, Micha³ Miros³aw wrote:
>>
>> 2011/9/28 David Daney<david.daney@cavium.com>:
>> [...]
>>>
>>> +Example :
>>> +
>>> +       /* The parent MDIO bus. */
>>> +       smi1: mdio@1180000001900 {
>>> +               compatible = "cavium,octeon-3860-mdio";
>>> +               #address-cells =<1>;
>>> +               #size-cells =<0>;
>>> +               reg =<0x11800 0x00001900 0x0 0x40>;
>>> +       };
>>> +
>>> +       /*
>>> +          An NXP sn74cbtlv3253 dual 1-of-4 switch controlled by a
>>> +          pair of GPIO lines.  Child busses 2 and 3 populated with 4
>>> +          PHYs each.
>>> +        */
>>> +       mdio-mux {
>>> +               compatible = "cavium,mdio-mux-sn74cbtlv3253",
>>> "cavium,mdio-mux";
>>> +               gpios =<&gpio1 3 0>,<&gpio1 4 0>;
>>> +               mdio-parent-bus =<&smi1>;
>>> +               #address-cells =<1>;
>>> +               #size-cells =<0>;
>>
>> This should probably have 'compatible = "nxp,sn74cbtlv3253";' here.
>>
>
> No, the sn74cbtlv3253 is a general purpose part that could be used to
> multiplex anything (I2C, SPI, random analog signals, etc.).  Only when it is
> in the "cavium,mdio-mux-sn74cbtlv3253" configuration is it an MDIO bus
> multiplexer.

This should use some generic name then. 'mdio-mux-gpio' or something.
There's no point in introducing chip's model for a gate-like discrete
device.

Best Regards,
Micha³ Miros³aw
