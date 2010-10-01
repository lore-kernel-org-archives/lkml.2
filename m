Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0JAS5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:57:00 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58803 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab0JAS47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:56:59 -0400
Message-ID: <4CA62EF6.8000204@austin.ibm.com>
Date: Fri, 01 Oct 2010 13:56:54 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, steiner@sgi.com
Subject: Re: [PATCH 4/9] v3 Allow memory blocks to span multiple memory sections
References: <4CA62700.7010809@austin.ibm.com> <4CA62917.80008@austin.ibm.com> <20101001185250.GK14064@sgi.com>
In-Reply-To: <20101001185250.GK14064@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 01:52 PM, Robin Holt wrote:
> On Fri, Oct 01, 2010 at 01:31:51PM -0500, Nathan Fontenot wrote:
>> Update the memory sysfs code such that each sysfs memory directory is now
>> considered a memory block that can span multiple memory sections per
>> memory block.  The default size of each memory block is SECTION_SIZE_BITS
>> to maintain the current behavior of having a single memory section per
>> memory block (i.e. one sysfs directory per memory section).
>>
>> For architectures that want to have memory blocks span multiple
>> memory sections they need only define their own memory_block_size_bytes()
>> routine.
>>
>> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
>>
>> ---
>>  drivers/base/memory.c |  155 ++++++++++++++++++++++++++++++++++----------------
>>  1 file changed, 108 insertions(+), 47 deletions(-)
>>
>> Index: linux-next/drivers/base/memory.c
>> ===================================================================
>> --- linux-next.orig/drivers/base/memory.c	2010-09-30 14:13:50.000000000 -0500
>> +++ linux-next/drivers/base/memory.c	2010-09-30 14:46:00.000000000 -0500
> ...
>> +static unsigned long get_memory_block_size(void)
>> +{
>> +	u32 block_sz;
>         ^^^
> 
> I think this should be unsigned long.  u32 will work, but everything
> else has been changed to use unsigned long.  If you disagree, I will
> happily acquiesce as nothing is currently broken.  If SGI decides to make
> memory_block_size_bytes more dynamic, we will fix this up at that time.

You're right, that should have been made an unsigned long also.  I'll attach a new
patch with that corrected.

-Nathan
