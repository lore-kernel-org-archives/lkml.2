Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1KRWMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:12:46 -0500
Received: from smtp171.dfw.emailsrvr.com ([67.192.241.171]:35185 "EHLO
	smtp171.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1KRWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:12:45 -0500
Message-ID: <4EC6D85B.6020005@calxeda.com>
Date: Fri, 18 Nov 2011 16:12:43 -0600
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Wojciech Baranowski <baranowski@google.com>
CC: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/platform: Allow missing address for dev name lookup
References: <1321628948.21392.37.camel@zalecze.wat.corp.google.com> <4EC6838F.8020705@calxeda.com> <CAC0oEedK1E4K9mSS_pOKz_xvHtXy576kCe9oG+D3aHz14tW=WA@mail.gmail.com>
In-Reply-To: <CAC0oEedK1E4K9mSS_pOKz_xvHtXy576kCe9oG+D3aHz14tW=WA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 10:45 AM, Wojciech Baranowski wrote:
> On Fri, Nov 18, 2011 at 11:10 AM, Rob Herring <rob.herring@calxeda.com> wrote:
>> On 11/18/2011 09:09 AM, Wojciech Baranowski wrote:
>>> While looking up linux name for platform device, check the address only if it
>>> has been supplied in lookup table.
>>>
>> And the reason you want to do this is?
> 
> Name lookup table is used to provide names for platform devices on the
> board I'm working on. I'm adding /sound node without address for audio
> subsystem and don't want to break that convention.

auxdata is really meant to be a temporary solution to plug platform_data.

All platform devices do not necessarily go into the DT. The DT should
describe the h/w. For sound I would expect this to be all the h/w blocks
like i2s, dma, codec and then information on how they are connected. Can
you show what your sound binding looks like.

Rob

> 
>>> Signed-off-by: Wojciech Baranowski <baranowski@chromium.org>
>>> ---
>>>  drivers/of/platform.c |    8 +++++---
>>>  1 files changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>>> index cbd5d70..94763c0 100644
>>> --- a/drivers/of/platform.c
>>> +++ b/drivers/of/platform.c
>>> @@ -314,12 +314,14 @@ static const struct of_dev_auxdata *of_dev_lookup(const struct of_dev_auxdata *l
>>>       if (!lookup)
>>>               return NULL;
>>>
>>> -     for(; lookup->name != NULL; lookup++) {
>>> +     for (; lookup->name != NULL; lookup++) {
>>>               if (!of_device_is_compatible(np, lookup->compatible))
>>>                       continue;
>>> -             if (of_address_to_resource(np, 0, &res))
>>> +             if (lookup->phys_addr &&
>>> +                             of_address_to_resource(np, 0, &res))
>>>                       continue;
>>> -             if (res.start != lookup->phys_addr)
>>> +             if (lookup->phys_addr &&
>>> +                             res.start != lookup->phys_addr)
>>>                       continue;
>>>               pr_debug("%s: devname=%s\n", np->full_name, lookup->name);
>>>               return lookup;
>>
>>

