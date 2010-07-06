Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0GFXQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 19:16:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57492 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0GFXQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 19:16:27 -0400
Message-ID: <4C33B883.6010206@kernel.org>
Date: Tue, 06 Jul 2010 16:13:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ram Pai <linuxram@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       clemens@ladisch.de
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port
 resources
References: <20100630211516.GA25991@us.ibm.com>	<AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>	<20100630235949.GA5120@us.ibm.com> <20100702143515.2896d728@virtuousgeek.org>
In-Reply-To: <20100702143515.2896d728@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C33B93F.007A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 02:35 PM, Jesse Barnes wrote:
> On Wed, 30 Jun 2010 16:59:49 -0700
> Ram Pai <linuxram@us.ibm.com> wrote:
> 
>> On Wed, Jun 30, 2010 at 04:10:26PM -0700, Linus Torvalds wrote:
>>> On Wed, Jun 30, 2010 at 2:15 PM, Ram Pai <linuxram@us.ibm.com> wrote:
>>>>       PCI: skip release and reallocation of io port resources
>>>
>>> Gaah. This still looks like just total ad-hoc hackery. The logic for
>>> it all seems very fragile, just a random case made up from the one
>>> failing issue. There's no underlying logic or design to it.
>>>
>>> I still think that we should just make people explicitly ask for a
>>> blank slate if the bios allocations don't work out. 
>>
>> and interactively allocate resource?
> 
> No I don't think we want to add any prompts to the kernel boot
> process. :)
> 
>>> Rather than trying
>>> to fix it up automatically, which has been a total rats nest of random
>>> crud.
>>
>> Can Yinghai Lu's patch 'pci=try=' be some temporary middle ground till
>> a more elaborate patch is found?
>>
>> His suggestion partly meets your suggestion. It does not automatically 
>> reassign unless the user explicitly asks for it. Hence should not
>> break any working systems, at the same time can handle system like 
>> mine.
> 
> pci=try just doesn't communicate much, it should be something like
> pci=override_bios and do as Linus suggests.

So you want to use pci=override_bios to reallocate all bios assigned resource include
peer root buses resources and pci bridge resource and pci devices BAR?

in that case, we may need to update
1. io apic related BAR to be consistent with io apic addr from MADT.
2. other ACPI related tables like return for _CRS...

or just change pci=try to pci=override_bios in my patch?

> 
> But we should continue to shoot for not ever having to use that option
> on normal systems.
> 

replacing legacy bios with linuxbios is cleanest way.

Yinghai
