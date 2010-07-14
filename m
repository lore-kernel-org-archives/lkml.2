Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0GNDSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 23:18:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59880 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab0GNDSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 23:18:13 -0400
Message-ID: <4C3D2C6B.3050203@austin.ibm.com>
Date: Tue, 13 Jul 2010 22:18:03 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7] Allow sysfs memory directories to be split
References: <4C3B3446.5090302@austin.ibm.com>	<4C3B3895.3040209@austin.ibm.com>	<20100713152854.ec1f4d6a.kamezawa.hiroyu@jp.fujitsu.com>	<4C3C8B9E.7000208@austin.ibm.com> <20100714093550.40036034.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100714093550.40036034.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 07:35 PM, KAMEZAWA Hiroyuki wrote:
> On Tue, 13 Jul 2010 10:51:58 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>>>
>>> And for what purpose this interface is ? Does this split memory block into 2 pieces
>>> of the same size ?? sounds __very__ strange interface to me.
>>
>> Yes, this splits the memory_block into two blocks of the same size.  This was
>> suggested as something we may want to do.  From ppc perspective I am not sure we
>> would use this.
>>
>> The split functionality is not required.  The main goal of the patch set is to
>> reduce the number of memory sysfs directories created.  From a ppc perspective
>> the split functionality is not really needed.
>>
> 
> Okay, this is an offer from me.
> 
>   1. I think you can add an boot option as "don't create memory sysfs".
>      please do.

I posted a patch to do that a week or so ago, it didn't go over very well.

> 
>   2. I'd like to write a configfs module for handling memory hotplug even when
>      sysfs directroy is not created.
>      Because configfs support rmdir/mkdir, the user (ppc's daemon?) has to do
>      
>      When offlining section X.
>      # insmod configfs_memory.ko
>      # mount -t configfs none /configfs
>      # mkdir /configfs/memoryX
>      # echo offline > /configfs/memoryX/state
>      # rmdir /configfs/memoryX
> 
>   And making this operation as the default bahavior for all arch's memory hotplug may
>   be better...
> 
> Dave, how do you think ? Because ppc guys uses "probe" interface already,
> this can be handled... no ?

ppc would still require the existance of the 'probe' interface.

Are you objecting to the 'split' functionality?  If so I do not see any reason from ppc
perspective that it is needed.  This was something Dave suggested, unless I am missing
something.

Since ppc needs the 'probe' interface in sysfs, and for ppc having mutliple 
memory_block_sections reside under a single memory_block makes memory hotplug
simpler.  On ppc we do emory hotplug operations on an LMB size basis.  With my
patches this now lets us set each memory_block to span an LMB's worth of
memory.  Now we could do emory hotplug in a single operation instead of multiple
operations to offline/online all of the memory sections in an LMB.

Of course the easy solution would be to increase SECTION_SIZE_BITS, but we need
support hardware that can have LMB's from 16 MB to 256 MB in size so the
SECTION_SIZE_BITS value has to remain small. 

> 
> One problem is that I don't have enough knowledge about configfs..it seems complex.

Me neither, thoug I will take a look at it.

-Nathan

