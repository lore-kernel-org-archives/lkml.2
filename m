Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1LMSEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:04:20 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41166 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1LMSET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:04:19 -0500
MIME-Version: 1.0
In-Reply-To: <4EE792DF.1010701@gmail.com>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
 <20111212232903.GC2616@gallagher> <CACxGe6t50zJNpo=QWPzgFMpQ6Cfi9YZyrKuMSTrrA2oYiLF2Pw@mail.gmail.com>
 <4EE792DF.1010701@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 13 Dec 2011 11:03:57 -0700
X-Google-Sender-Auth: X6K84AQEtuaiKJgCcMU1iZlfZDg
Message-ID: <CACxGe6sh+ofJWSA8xpDazEKVOUOpaHK45Qm8C20zpyRaLT77Mg@mail.gmail.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
To: Rob Herring <robherring2@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 11:01 AM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> On 12/13/2011 11:54 AM, Grant Likely wrote:
>> On Mon, Dec 12, 2011 at 4:29 PM, Jamie Iles <jamie@jamieiles.com> wrote:
>>> Hi Grant,
>>>
>>> I'm still going through these and trying to digest them but a couple of
>>> quick questions/comments.
>>>
>>> Jamie
>>>
>>> On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
>>>> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>>> new file mode 100644
>>>> index 0000000..e40c436
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>>> @@ -0,0 +1,114 @@
>>>> +This binding is a work-in-progress, and are based on some experimental
>>>> +work by benh[1].
>>>> +
>>>> +Sources of clock signal can be represented by any node in the device
>>>> +tree.  Those nodes are designated as clock providers.  Clock consumer
>>>> +nodes use a phandle and clock specifier pair to connect clock provider
>>>> +outputs to clock inputs.  Similar to the gpio specifiers, a clock
>>>> +specifier is an array of one more more cells identifying the clock
>>>> +output on a device.  The length of a clock specifier is defined by the
>>>> +value of a #clock-cells property in the clock provider node.
>>>> +
>>>> +[1] http://patchwork.ozlabs.org/patch/31551/
>>>> +
>>>> +==Clock providers==
>>>> +
>>>> +Required properties:
>>>> +#clock-cells:           Number of cells in a clock specifier; typically will be
>>>> +                set to 1
>>>
>>> I'm not sure I fully understand what the extra cells actually mean for
>>> clocks.  I think the first integer is the clock output to use but some
>>> of the versatile and highbank ones only have a phandle or is it more
>>> implementation defined?  The clock-output-names description hints at
>>> recommended, so I find this a little confusing, but that could just be
>>> me!
>>
>> I'm following convention here that has been established with
>> interrupts, gpios, and others.  Sometimes more information is needed
>> that just the clock number.  Using #clock-cells gives a clock provider
>> the option of having additional fields for clock flags or other data.
>> This is very much implementation defined.  Simple clock providers that
>> only have a single clock output can easily use #clock-cells = <0>.
>> Providers with multiple outputs will need to use 1 or more cells.
>>
>
> Aren't you off by 1 here? The minimum cells is 1 to hold the phandle of
> the source/parent. Multiple outputs will need a cell size of 2 (typically).

No.  The #clock-cells does not include the phandle.  Never did.

g.
