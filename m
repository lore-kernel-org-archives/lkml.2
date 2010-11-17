Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935151Ab0KQRyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:54:16 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18537 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab0KQRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:54:15 -0500
Message-ID: <4CE416C6.5090701@caviumnetworks.com>
Date: Wed, 17 Nov 2010 09:54:14 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        arjan@linux.intel.com, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] of: Add support for linking device tree blobs into
 vmlinux
References: <cover.1289943240.git.dirk.brandewie@gmail.com> <9129f0a21ea48fb2dcb89cea290e88f3e8c0d8a2.1289943240.git.dirk.brandewie@gmail.com> <4CE32453.2090403@caviumnetworks.com> <4CE33C14.9030503@gmail.com> <AANLkTi=T_bqEswe32dTAfL4++WAitc7+VHnyjqP2sQfi@mail.gmail.com> <4CE372A9.2050704@gmail.com>
In-Reply-To: <4CE372A9.2050704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 17:55:03.0733 (UTC) FILETIME=[8FD68E50:01CB8680]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 10:14 PM, Dirk Brandewie wrote:
> On 11/16/2010 06:58 PM, Grant Likely wrote:
>> On Tue, Nov 16, 2010 at 7:21 PM, Dirk Brandewie
>> <dirk.brandewie@gmail.com> wrote:
>>>
>>> On 11/16/2010 04:39 PM, David Daney wrote:
>>>>
>>>> Thanks for doing this. However I have a few comments...
>>>>
>>>> On 11/16/2010 02:41 PM, dirk.brandewie@gmail.com wrote:
>>>>>
>>>>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>>>>
>>>>> /* .data section */
>>>>> #define DATA_DATA \
>>>>> *(.data) \
>>>>> @@ -468,7 +482,8 @@
>>>>> MCOUNT_REC() \
>>>>> DEV_DISCARD(init.rodata) \
>>>>> CPU_DISCARD(init.rodata) \
>>>>> - MEM_DISCARD(init.rodata)
>>>>> + MEM_DISCARD(init.rodata) \
>>>>> + KERNEL_DTB()
>>>>>
>>>>
>>>> I thought the init.rodata was only for data used by __init things.
>>>> Although the
>>>> current linker scripts do not put it in the section that gets
>>>> recycled as
>>>> usable
>>>> memory.
>>>>
>>>> IIRC the unflattened version of the device tree has pointers to the
>>>> flattened
>>>> data. Since the device tree nodes are live for the entire kernel
>>>> lifecycle,
>>>> shouldn't the device tree blobs be in non-init memory?
>>>>
>>>
>>> The contents of the blob get copied to allocated memory during
>>> unflatten_device_tree() so the blob that is linked in is no longer
>>> needed
>>> after init.
>>
>> Have you written a patch to add this behaviour? The current code
>> doesn't. :-)
>>
>
> I misspoke, my blob gets copied to allocated memory during
> unflatten_device_tree.
> my early_init_dt_alloc_memory_arch() returns the physical address of a
> kmalloc'd
> buffer.
>

Perhaps you should take a look at unflatten_dt_node(), especially the 
part where property names and values are assigned.  I could be mistaken, 
but it appears to me that the memory allocated by 
early_init_dt_alloc_memory_arch() is not used to hold the name and value 
strings.  It is possible that they might be referred to in their 
original location in the flattened blob.


> You would want copy the dtb that your platform is going to use to
> non-init memory.
>

... or you might want to locate the dtb somewhere where it would be 
unlikely to get clobbered if someone were to arrange for the init.rodata 
to be freed for reuse.

David Daney
