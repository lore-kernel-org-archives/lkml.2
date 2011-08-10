Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1HJM7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:59:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48816 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab1HJM7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:59:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Wed, 10 Aug 2011 14:59:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC][PATCH 1/2] S5PV210: SPI: Add clkdev support
In-reply-to: <CAAgF-BftGYkZ6aaSZgxd8gk1Zy9-sJEroZcaijd6zN3Qr9MEhQ@mail.gmail.com>
To: padma venkat <padma.kvr@gmail.com>
Cc: Padmavathi Venna <padma.v@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, jassi Brar <jassisinghbrar@gmail.com>
Message-id: <4E42809B.7070504@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18)
 Gecko/20110617 Thunderbird/3.1.11
References: <1312898222-7165-1-git-send-email-padma.v@samsung.com>
 <4E413941.10307@samsung.com>
 <CAAgF-BftGYkZ6aaSZgxd8gk1Zy9-sJEroZcaijd6zN3Qr9MEhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Padmavathi,

On 08/10/2011 02:04 PM, padma venkat wrote:
> Hi Sylwester,
> 
> On Tue, Aug 9, 2011 at 7:12 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> [corrected Jassi's email address]
>>
>> On 08/09/2011 03:57 PM, Padmavathi Venna wrote:
>>> Create a clkdev alias for spi bus clock and modify the spi
>>> driver to lookup the clock using the alias name instead of
>>> passing clock name and clock number from SPI platform data.
>>>
>>> Signed-off-by: Padmavathi Venna <padma.v@samsung.com>
>>> ---
>>> This patch is tested for S5PV210 platform and similar
>>> changes can be adopted for rest of the Samsung's s3c
>>> and s5p platforms, if this approach is accepted.
>>
>> It is a bit surprising to me how you do intend to use the clock aliases.
>> Are we seriously going to be creating clock con_id aliases for most
>> of the available devices ? It doesn't sound sane to me..
>
> We don't need to create the alias names for all the devices. But we need
> to create only for those which need clock information from platform data.
> As far as I know we need to create for spi,hsmmc,uart and iis.

That's already a lot. 
Just to clarify, the clock names were originally passed in platform_data
because they differ across SoCs the driver supports, right ?
Or are there any other reasons ?

The whole idea of the clkdev is not to require any information about 
the clocks in platform_data. You just need to be registering the clock 
identifiers *at the device*, not the clock names specific to the machine.
The platform code takes care of the translation and the drivers only need
to ask clkdev for the 'clock connection id', rather than the original
machine clock name.
You can do this by adding the aliases, but it's not optimal. You are adding
the code which could well be avoided.

>
>>
>> Wouldn't it be possible to avoid the aliases by correcting the clock
>> registration process ?
>
> Yes it is possible but we don't have the flexibility to create the alias names
> only for the required clocks.

By registering proper clock connection ids you would not need the aliases at all.

--
Regards,
Sylwester
