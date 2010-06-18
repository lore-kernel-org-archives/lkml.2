Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab0FRT7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:59:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41362 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab0FRT7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OUkjWltQpmRmqp7YVdJXoFG+1TOM5T+GMedyh5rViD9wjEeWMbaU9b+XklwnCv0pCg
         UDsULQ/nFLGWIgaOT0bfEdR4vGHYue/aukE7ERZKcf22x+1ZoBFMWRsHAOA+cGiTMrTD
         PF8L5TvgfRMhnFIbBvah/rPfzkxDanZOF2g1w=
Message-ID: <4C1BD024.1030707@gmail.com>
Date: Fri, 18 Jun 2010 12:59:32 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	<1276666434-11227-5-git-send-email-justinmattock@gmail.com>	<20100618102330.29eccb5b@virtuousgeek.org>	<4C1BBF7D.8090904@kernel.org> <20100618124956.40c869a0@virtuousgeek.org>
In-Reply-To: <20100618124956.40c869a0@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 12:49 PM, Jesse Barnes wrote:
> On Fri, 18 Jun 2010 11:48:29 -0700
> Yinghai Lu<yinghai@kernel.org>  wrote:
>
>> On 06/18/2010 10:23 AM, Jesse Barnes wrote:
>>> On Tue, 15 Jun 2010 22:33:53 -0700
>>> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>>>
>>>> The below patch fixes a warning message when using gcc 4.6.0
>>>>    CC      drivers/pci/setup-bus.o
>>>> drivers/pci/setup-bus.c: In function 'pci_assign_unassigned_bridge_resources':
>>>> drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used
>>>>
>>>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>
>>>> ---
>>>>   drivers/pci/setup-bus.c |    2 --
>>>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>>>> index 19b1113..215590b 100644
>>>> --- a/drivers/pci/setup-bus.c
>>>> +++ b/drivers/pci/setup-bus.c
>>>> @@ -865,7 +865,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>>>>   	struct pci_bus *parent = bridge->subordinate;
>>>>   	int tried_times = 0;
>>>>   	struct resource_list_x head, *list;
>>>> -	int retval;
>>>>   	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>>>>   				  IORESOURCE_PREFETCH;
>>>>
>>>> @@ -874,7 +873,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>>>>   again:
>>>>   	pci_bus_size_bridges(parent);
>>>>   	__pci_bridge_assign_resources(bridge,&head);
>>>> -	retval = pci_reenable_device(bridge);
>>>>   	pci_set_master(bridge);
>>>>   	pci_enable_bridges(parent);
>>>>
>>
>> I sent following patch several weeks ago, can you put that in pci-next?
>>
>> Subject: [PATCH] pciehp: Enable bridges at last for multiple try assigning
>>
>> Found one PCIe Module with several bridges "cold" hotadd doesn't work.
>>
>> the root cause:
>> 1. BIOS assign small range the parent bridges.
>> 2. First try for hotadd only can make some bridges get resource assigned.
>> 3. Second will update parent bridge res, get right sizes for all child bridges
>>      and devices, but resource for child bridges are not set to HW register.
>>      Because first try already enable those bridges, so __pci_bridge_assign_resource
>>      skip the setting step.
>>
>> So try to move enabling of child bridges to last and only do that one time
>>
>> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>
> Yeah I had a hard time following the changelog, but just looked it
> over.  Looks safe, but Justin will still need to check the return value
> on pci_reenable_device.
>
> Justin, we don't want a message on every reenable, just on ones that
> fail.  So can you protect your printk with if (retval) instead?  You'll
> need to refresh it based on my linux-next branch in a few minutes, as
> I'm pushing Yinghai's patch now.
>


just added this in(as a test), and the retval warning still shows up.
with the last post I just added a printk was that legit, and if so what 
else might be added to it to make it complete and proper?

Justin P. Mattock
