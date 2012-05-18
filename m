Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966069Ab2ERRnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965964Ab2ERRnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:43:15 -0400
Message-ID: <4FB68A28.9090205@redhat.com>
Date: Fri, 18 May 2012 14:43:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC v26 00/66] EDAC patches for v3.5
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com> <20120518164615.GY20215@aftab.osrc.amd.com>
In-Reply-To: <20120518164615.GY20215@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-05-2012 13:46, Borislav Petkov escreveu:
> On Fri, May 18, 2012 at 01:31:47PM -0300, Mauro Carvalho Chehab wrote:
>> This is a long series of patches to fix the EDAC subsystem,
>> and is being under discussions since Jan.
>>
>> The current EDAC subsystem has several serious issues with regards
>> to all Intel Xeon and i3/i5/i7 processors. The EDAC subsystem used
>> to assume that all DIMM memory sticks have the same topology as the
>> initial PC designs, e. g:
>>
>> 	- the DRAM chips inside the DIMM slots are directly
>> 	  accessible by the memory controller;
>>
>> 	- there's no Advanced Memory Bufffer chips between DIMMs
>> 	  and the memory controller;
>>
>> 	- if the memory controller has more than one channel, all
>> 	  channels are filled with the same memory type/size;
>>
>> Due to that, all Intel drivers for hardware newer than 2005 (and
>> some older Intel hardware) have to lie to the EDAC core, providing
>> fake memory location information.
>>
>> Also, the memory errors are reported via snprintk/printk's. As the
>> printk ABI is not preserved among Kernel versions, applications can't
>> (and don't) rely on it.
>>
>> So, userspace applications rely, instead, on error counter sysfs
>> nodes, with don't allow them to do decay and burst detection, nor
>> to correlate errors among the same address range (with might help
>> userspace to distinguish between a real error from a temporary
>> interference.
>>
>> -
>>
>> v.26: 
>>
>> - "RAS: Add a tracepoint for reporting memory..." patch was re-written
>>    in order to send to userspace ABI integer fields as such;
>> - added a fixup atch from Dan.
>> - The other patches weren't touched on this version.
>>
>> TODO: improve per-driver error message and error details.
>>
>> Dan Carpenter (1):
>>   edac_mc: check for allocation failure in edac_mc_alloc()
>>
>> Joe Perches (2):
>>   edac: Use more normal debugging macro style
>>   edac: Convert debugfX to edac_dbg(X,
>>
>> Mauro Carvalho Chehab (63):
>>   edac: Create a dimm struct and move the labels into it
>>   edac: move dimm properties to struct dimm_info
>>   edac: Don't initialize csrow's first_page & friends when not needed
>>   edac: move nr_pages to dimm struct
>>   edac: rewrite edac_align_ptr()
>>   edac.h: Add generic layers for describing a memory location
>>   edac: Change internal representation to work with layers
>>   amd64_edac: convert driver to use the new edac ABI
>>   amd76x_edac: convert driver to use the new edac ABI
>>   cell_edac: convert driver to use the new edac ABI
>>   cpc925_edac: convert driver to use the new edac ABI
>>   e752x_edac: convert driver to use the new edac ABI
>>   e7xxx_edac: convert driver to use the new edac ABI
>>   i3000_edac: convert driver to use the new edac ABI
>>   i3200_edac: convert driver to use the new edac ABI
>>   i5000_edac: convert driver to use the new edac ABI
>>   i5100_edac: convert driver to use the new edac ABI
>>   i5400_edac: convert driver to use the new edac ABI
>>   i7300_edac: convert driver to use the new edac ABI
>>   i7core_edac: convert driver to use the new edac ABI
>>   i82443bxgx_edac: convert driver to use the new edac ABI
>>   i82860_edac: convert driver to use the new edac ABI
>>   i82875p_edac: convert driver to use the new edac ABI
>>   i82975x_edac: convert driver to use the new edac ABI
>>   mpc85xx_edac: convert driver to use the new edac ABI
>>   mv64x60_edac: convert driver to use the new edac ABI
>>   pasemi_edac: convert driver to use the new edac ABI
>>   ppc4xx_edac: convert driver to use the new edac ABI
>>   r82600_edac: convert driver to use the new edac ABI
>>   sb_edac: convert driver to use the new edac ABI
>>   tile_edac: convert driver to use the new edac ABI
>>   x38_edac: convert driver to use the new edac ABI
>>   edac: Remove the legacy EDAC ABI
>>   edac: Initialize the dimm label with the known information
>>   edac: Cleanup the logs for i7core and sb edac drivers
>>   i5400_edac: improve debug messages to better represent the filled
>>     memory
>>   RAS: Add a tracepoint for reporting memory controller events
> 
> Are you kidding me?
> 
> You want to send patches upstream which are still in review and 

No, I want to post the last version of the patches and provide a clearer
description of what this patch series do, before sending the git pull
request when the merge window opens.

> and who knows how untested: http://marc.info/?l=linux-next&m=133735830119299&w=2

Rebase 22 caused this small issue, when the bit_order argument got removed.

Regards,
Mauro
