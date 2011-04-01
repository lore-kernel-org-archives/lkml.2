Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab1DASsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:48:04 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11021 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1DASsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:48:03 -0400
Message-ID: <4D961DE1.50807@caviumnetworks.com>
Date: Fri, 01 Apr 2011 11:48:01 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Michael Sundius <msundius@cisco.com>
CC: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        David VomLehn <dvomlehn@cisco.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andy Whitcroft <apw@shadowen.org>, Jon Fraser <jfraser@broadcom.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH v2] MIPS: Kernel crashes on boot with SPARSEMEM + HIGHMEM
 enabled
References: <c300b67a7a723369872c0b9a023d0b2e@localhost> <4D9603D8.2010709@caviumnetworks.com> <4D961C6A.9070808@cisco.com>
In-Reply-To: <4D961C6A.9070808@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2011 18:48:02.0048 (UTC) FILETIME=[54073000:01CBF09D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 11:41 AM, Michael Sundius wrote:
> David Daney wrote:
>>
>>
>> I think this may do the same thing as my patch:
>>
>> http://patchwork.linux-mips.org/patch/1988/
>>
>> Although my patch had different motivations, and changes some other
>> things around too.
>>
>> David Daney
>>
> I'm not really sure why your kernel or initrd would be in memory was not
> within
> the range that had been accounted for. are you saying its in high mem?
>

Well the memory initialization code has a bunch of weird rules built in 
that prevent some memory from being used.

For example if the kernel resides in a different SPARSE page than the 
rest of memory bad things happen because memory_present() was not called 
on something that is later freed (when init memory is released).

If I try to put an initrd at a high physical address, the memory below 
that is not usable.

My three patches try to make some sense out of the whole thing.

David Daney

