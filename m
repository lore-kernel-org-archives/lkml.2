Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab2CIQlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:41:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754Ab2CIQlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:41:11 -0500
Message-ID: <4F5A329A.70702@redhat.com>
Date: Fri, 09 Mar 2012 13:40:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120308215716.GA5925@aftab> <4F59DC38.5080104@redhat.com> <20120309143806.GA11962@aftab>
In-Reply-To: <20120309143806.GA11962@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-03-2012 11:38, Borislav Petkov escreveu:
> On Fri, Mar 09, 2012 at 07:32:24AM -0300, Mauro Carvalho Chehab wrote:
> 
> [..]
> 
>>> Also, what does the nomenclature
>>>
>>> [   12.196138] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
>>> [   12.204636] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: dimm1 (0:1:0): row 0, chan 1
>>> [   12.213127] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: dimm2 (1:0:0): row 1, chan 0
>>> [   12.221613] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: dimm3 (1:1:0): row 1, chan 1
>>> [   12.230103] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: dimm4 (2:0:0): row 2, chan 0
>>> [   12.238590] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: dimm5 (2:1:0): row 2, chan 1
>>> [   12.247078] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: dimm6 (3:0:0): row 3, chan 0
>>> [   12.255560] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: dimm7 (3:1:0): row 3, chan 1
>>> [   12.264058] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (4:0:0): row 4, chan 0
>>> [   12.272552] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: dimm9 (4:1:0): row 4, chan 1
>>> [   12.281041] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: dimm10 (5:0:0): row 5, chan 0
>>> [   12.289699] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: dimm11 (5:1:0): row 5, chan 1
>>> [   12.298362] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 12: dimm12 (6:0:0): row 6, chan 0
>>> [   12.307018] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 13: dimm13 (6:1:0): row 6, chan 1
>>> [   12.315684] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 14: dimm14 (7:0:0): row 7, chan 0
>>> [   12.324352] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 15: dimm15 (7:1:0): row 7, chan 1
>>>
>>> mean? 16 DIMMs? No way.
>>
>> The debug message needs to be fixed. The above message shows how many ranks were
>> allocated, and not DIMMs. That means that patch 5/6 of the last series is incomplete,
>> as it doesn't touch on the debug messages.
>>
>> This debug info has the purpose of showing how the dimm or rank real location
>> is mapped into the virtual csrow/channel notation.
>>
>> From your logs, the machine you're testing has 16 ranks, so, except for the
>> debug log fix, it is properly detecting everything.
> 
> No, it has 8 ranks (4 dual-ranked DIMMs on MCT 0 and the same on the
> 3 other MCTs).

Your logs show:

[   12.058897] EDAC MC: DCT0 chip selects:
[   12.063091] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   12.068155] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   12.073219] EDAC amd64: MC: 4:     0MB 5:     0MB
[   12.078281] EDAC amd64: MC: 6:     0MB 7:     0MB
[   12.093305] EDAC MC: DCT1 chip selects:
[   12.097499] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   12.102562] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   12.107623] EDAC amd64: MC: 4:     0MB 5:     0MB
[   12.112690] EDAC amd64: MC: 6:     0MB 7:     0MB

This memory controller has 16 ranks (8 filled/8 empty). The above
debug info is at edac_mc_alloc(). The EDAC core doesn't know yet how 
many of those were filled or not, as the driver didn't fill the rank
size yet.

> So rank0-7 is correct, actually, sorry.

> The dimm0-15
> labeling above is rather wrong though and needs fixing.

Ok, I'll write a patch fixing it, or resent patch 5/6 with the fix.

>> The rank location (the number in parenthesis) is being mapped to the right
>> row/channel. On this MC, the location has just 2 addresses, so, the above
>> message is showing "0" for the third location, as expected on this debug msg.
>>
>> On a machine where the csrow/channel is virtualized, the above map would be 
>> different. For example, on a machine with the i5000 Memory Controller, the
>> memory is organized as:
>>
>>        +-----------------------------------------------+
>>        |                      mc0                      |
>>        |        branch0        |        branch1        |
>>        | channel0  | channel1  | channel0  | channel1  |
>> -------+-----------------------------------------------+
>> slot3: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
>> slot2: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
>> -------+-----------------------------------------------+
>> slot1: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
>> slot0: |   512 MB  |   512 MB  |   512 MB  |   512 MB  |
>> -------+-----------------------------------------------+
>>
>> This is the map for it (in this case, the debug is correct, as the memory is organized
>> per dimm):
>>
>> [   16.946841] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
>> [   16.946845] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: dimm1 (0:0:1): row 0, chan 1
>> [   16.946848] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: dimm2 (0:0:2): row 0, chan 2
>> [   16.946852] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: dimm3 (0:0:3): row 0, chan 3
>> [   16.946855] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: dimm4 (0:1:0): row 1, chan 0
>> [   16.946859] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: dimm5 (0:1:1): row 1, chan 1
>> [   16.946862] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: dimm6 (0:1:2): row 1, chan 2
>> [   16.946866] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: dimm7 (0:1:3): row 1, chan 3
>> [   16.946869] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (1:0:0): row 2, chan 0
>> [   16.946873] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: dimm9 (1:0:1): row 2, chan 1
>> [   16.946876] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: dimm10 (1:0:2): row 2, chan 2
>> [   16.946880] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: dimm11 (1:0:3): row 2, chan 3
>> [   16.946883] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 12: dimm12 (1:1:0): row 3, chan 0
>> [   16.946887] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 13: dimm13 (1:1:1): row 3, chan 1
>> [   16.946890] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 14: dimm14 (1:1:2): row 3, chan 2
>> [   16.946894] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 15: dimm15 (1:1:3): row 3, chan 3
>>
>> It means that, on this driver, the dimm that it is at branch 1, channel 0
>> slot 0 is mapped, according with this debug message:
>> 	[   16.946869] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (1:0:0): row 2, chan 0
>> as row 2, channel 0, on the per-csrow node:
>>
>> /sys/devices/system/edac/mc/mc0/csrow2/ch0_dimm_label:mc#0branch#1channel#0slot#0
>>
>>> Basically, the problem with the DIMM nomenclature is that you cannot
>>> know from the hardware how many chip selects, aka ranks, comprise
>>> one DIMM. IOW, you cannot know whether your DIMMs are single-ranked,
>>> dual-ranked or quad-ranked and thus you cannot combine the csrows into
>>> DIMM structs.
>>
>> This may not be possible on amd64 hardware, but there are other memory
>> controllers that allow it. On several ones, the registers are per DIMM,
>> and there are fields there that counts the number of ranks per dimm.
> 
> Right, so all I'm saying is that on the drivers which have ranks but
> cannot tell you to which DIMMs they belong, we shouldn't have the word
> "DIMM" anywhere in sysfs or printk output because it is misleading
> anyway.

Agreed. I'll fix that.

> On those other drivers which explicitly support DIMMs, you can
> do the per-DIMM splitting in /sysfs or whatever.
> 
> Also, now we have:
> 
> csrow0
> |-- ce_count
> |-- ch0_ce_count
> |-- ch0_dimm_label
> |-- ch1_ce_count
> |-- ch1_dimm_label
> |-- dev_type
> |-- edac_mode
> |-- mem_type
> |-- size_mb
> `-- ue_count
> csrow1
> |-- ce_count
> |-- ch0_ce_count
> |-- ch0_dimm_label
> |-- ch1_ce_count
> |-- ch1_dimm_label
> |-- dev_type
> |-- edac_mode
> |-- mem_type
> |-- size_mb
> `-- ue_count
> csrow2
> ...
> 
> 
> 
> with your patches we get:
> 
> rank0/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> rank1/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> rank2/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> ...
> 
> 
> which splits the ch0 and ch1 of the csrow? dir above into ranks. All
> fine and dandy but that doesn't change the whole situation - we simply
> talk about ranks and not chip select rows anymore. Oh well...

Yes, it won't bring anything new there for rank-based hierarchy.
The only benefit in this case is that newer userspace programs/versions
would use the same struct as the one shown with DIMMs:

dimm0
├── dimm_dev_type
├── dimm_edac_mode
├── dimm_label
├── dimm_location
├── dimm_mem_type
└── dimm_size
dimm4
├── dimm_dev_type
├── dimm_edac_mode
├── dimm_label
├── dimm_location
├── dimm_mem_type
└── dimm_size
dimm8
├── dimm_dev_type
├── dimm_edac_mode
├── dimm_label
├── dimm_location
├── dimm_mem_type
└── dimm_size


> Also, the following hierarchy looks ugly:
> 
>  ce_csrow0
>  ce_csrow0_channel0
>  ce_csrow0_channel1
>  ce_csrow1
>  ce_csrow1_channel0
>  ce_csrow1_channel1
>  ce_csrow2
>  ce_csrow2_channel0
>  ce_csrow2_channel1
>  ce_csrow3
>  ce_csrow3_channel0
>  ce_csrow3_channel1

The actual error count node names depend on how the hierarchy is 
organized. This is how it looks like at the i5000 machine:

mc0
├── ce_branch0
├── ce_branch0_channel0
├── ce_branch0_channel0_slot0
├── ce_branch0_channel1
├── ce_branch0_channel1_slot0
├── ce_branch1
├── ce_branch1_channel0
├── ce_branch1_channel0_slot0
├── ce_branch1_channel1
├── ce_branch1_channel1_slot0
├── ce_count
├── ce_noinfo_count
├── ue_branch0
├── ue_branch0_channel0
├── ue_branch0_channel0_slot0
├── ue_branch0_channel1
├── ue_branch0_channel1_slot0
├── ue_branch1
├── ue_branch1_channel0
├── ue_branch1_channel0_slot0
├── ue_branch1_channel1
├── ue_branch1_channel1_slot0
├── ue_count
└── ue_noinfo_count

> 
> Much better would it be if you put the ch0 and ch1 CE error count into
> the csrow?/ directory, i.e. something like:
> 
> csrow?/ce/ch{0,1}
> csrow?/ue/ch{0,1}

There is a strong technical reason for not doing it. Now, the rank or
dimm information is not stored anymore at the legacy structures.
The "csrow?" sysfs nodes are created from the struct csrow_info,
while the rank/dimm nodes, are created from struct dimm_info.

A csrow? node only makes sense if the hierarchy is csrow/channel.
As the code should work with all kinds of hierarchy, it would require
two different implementations, one for each case.

It would also mix the old representation with the new one, creating
a complex code for the csrow-based sysfs nodes. After having
the new way adopted from some kernel versions, we may think on remove
the old nodes, as removing the csrow/ch hierarchy means to simplify
the EDAC code by removing the compatibility logic and data. 

So, keeping it on a separate hierarchy helps to have a sane implementation.

>From userspace POV, creating a node tree may make it  harder to parse, as 
there would be, currently, at least 3 different ways for them with the 
current hierarchies:
	csrow?/channel?/ce?
	branch?/channel?/slot?/ce?
	channel?/slot?/ce?

(and more could be added, as new memory technologies/arrangements
may be created).

I considered two other alternatives, before adopting this one on my patches:

1) remove the layer name from the name. So, the nodes could be called instead:

	ce_count_0:0:0
	ce_count_0:0:1
	ce_count_0:0
	ce_count_0
	ce_count_0:1:0
	ce_count_0:1:1
	ce_count_0:1
	ce_count_1
	...

It shouldn't be hard to change the code to use this way, but it is a little
more confusing for users to understand.

2) Put all error counters into a single sub-directory, like:
	error_counters
	├── ce_branch0
	├── ce_branch0_channel0
	├── ce_branch0_channel0_slot0
	├── ce_branch0_channel1
	├── ce_branch0_channel1_slot0	
	├── ce_branch1
	├── ce_branch1_channel0
	├── ce_branch1_channel0_slot0
	├── ce_branch1_channel1
	├── ce_branch1_channel1_slot0
	├── ce_count
	├── ce_noinfo_count
	├── ue_branch0
	├── ue_branch0_channel0
	├── ue_branch0_channel0_slot0
	├── ue_branch0_channel1
	├── ue_branch0_channel1_slot0
	├── ue_branch1
	├── ue_branch1_channel0
	├── ue_branch1_channel0_slot0
	├── ue_branch1_channel1
	├── ue_branch1_channel1_slot0
	├── ue_count
	└── ue_noinfo_count

In the last case, the EDAC core would need to keep the 4
"general" error counters also under the mc? level (ce_count & friends).

> 
> so that all is clear just from looking at the directory structure. Or
> put it into the rank?/ hierarchy and have all per-rank info in one
> concentrated, self-describing location.

Not sure if I understood what you're meaning here. Could you give an
example about what kind of tree are you imagining in this case?

> 
> Thanks.
> 

Regards,
Mauro
