Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2KSPVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:21:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:56884 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2KSPVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:21:45 -0500
Message-ID: <50AA4E61.4070800@windriver.com>
Date: Mon, 19 Nov 2012 10:21:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        <kernel@pengutronix.de>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v6 3/4] media: coda: use genalloc API
References: <1353061817-3207-1-git-send-email-p.zabel@pengutronix.de>  <1353061817-3207-4-git-send-email-p.zabel@pengutronix.de>  <50A656E2.707@windriver.com>  <1353079273.2413.160.camel@pizza.hi.pengutronix.de>  <50A66307.3080706@windriver.com> <1353084667.2413.414.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1353084667.2413.414.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-11-16 11:51 AM, Philipp Zabel wrote:
> Am Freitag, den 16.11.2012, 11:00 -0500 schrieb Paul Gortmaker:
>> On 12-11-16 10:21 AM, Philipp Zabel wrote:
>>> Am Freitag, den 16.11.2012, 10:08 -0500 schrieb Paul Gortmaker:
>>>> On 12-11-16 05:30 AM, Philipp Zabel wrote:
>>>>> This patch depends on "genalloc: add a global pool list,
>>>>> allow to find pools by phys address", which provides the
>>>>> of_get_named_gen_pool function.
>>>>>
>>>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>>>> ---
>>>>>  drivers/media/platform/Kconfig |    3 +--
>>>>>  drivers/media/platform/coda.c  |   47 ++++++++++++++++++++++++++++------------
>>>>>  2 files changed, 34 insertions(+), 16 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>>>>> index 181c768..09d45c6 100644
>>>>> --- a/drivers/media/platform/Kconfig
>>>>> +++ b/drivers/media/platform/Kconfig
>>>>> @@ -130,10 +130,9 @@ if V4L_MEM2MEM_DRIVERS
>>>>>  
>>>>>  config VIDEO_CODA
>>>>>  	tristate "Chips&Media Coda multi-standard codec IP"
>>>>> -	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
>>>>> +	depends on VIDEO_DEV && VIDEO_V4L2
>>>>
>>>> What was the logic for reducing the dependency scope here?
>>>> Your commit log doesn't mention that at all, and when I see
>>>> things like that, I predict allyesconfig build failures,
>>>> unless there is a similar dependency elsewhere that isn't
>>>> visible in just the context of this patch alone.
>>>>
>>>> P.
>>>
>>> iram_alloc and iram_free are i.MX specific wrappers around
>>> gen_pool_alloc and gen_pool_free, located in <mach/iram.h>.
>>> Those were responsible for the dependency in the first place.
>>
>> So when I do an allyesconfig for sparc, or parisc or alpha,
>> and VIDEO_CODA gets selected, it will build just fine then?
> 
> I don't know, as I don't have compilers for those available right now.
> I'd like to know if it doesn't, though. It builds fine on x86 and mips,
> for example.

Probably worthwhile to watch the linux-next builds once you
know your commit(s) will be present there, since it has a
wide arch coverage.

> 
>> My point was that when you remove the ARCH_MXC dep, this
>> probably gets opened up as a viable option to a _lot_ more
>> platforms than you might want it exposed to.
> 
> I don't see the problem. Isn't this a good thing?

Well, it can be, if it was intentional, and if the hardware
is genuinely architecture agnostic.  On the other hand, I
don't think it makes sense to be building arm specific drivers
on sparc (or similar) just because we can.  It just adds to
the overall build coverage overhead for minimal gain.

Paul.
--

> 
> regards
> Philipp
> 
