Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2IMAlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:41:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33291 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2IMAlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:41:11 -0400
Message-ID: <50512B9A.9060905@ti.com>
Date: Wed, 12 Sep 2012 20:40:58 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>, <davem@davemloft.net>,
        <eric.dumazet@gmail.com>, <hannes@cmpxchg.org>,
        <shangw@linux.vnet.ibm.com>, <vitalya@ti.com>
Subject: Re: [PATCH] mm: bootmem: use phys_addr_t for physical addresses
References: <1347466008-7231-1-git-send-email-cyril@ti.com> <20120912203920.GU7677@google.com> <505123FE.2090305@ti.com> <20120913003400.GA25889@localhost>
In-Reply-To: <20120913003400.GA25889@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 9/12/2012 8:34 PM, Tejun Heo wrote:
> Hello,
>
> On Wed, Sep 12, 2012 at 08:08:30PM -0400, Cyril Chemparathy wrote:
>>> So, a function which takes phys_addr_t for goal and limit but returns
>>> void * doesn't make much sense unless the function creates directly
>>> addressable mapping somewhere.
>>
>> On the 32-bit PAE platform in question, physical memory is located
>> outside the 4GB range.  Therefore phys_to_virt takes a 64-bit
>> physical address and returns a 32-bit kernel mapped lowmem pointer.
>
> Yes but phys_to_virt() can return the vaddr only if the physical
> address is already mapped in the kernel address space; otherwise, you
> need one of the kmap*() calls which may not be online early in the
> boot and consumes either the vmalloc area or fixmaps.  bootmem
> interface can't handle unmapped memory.
>

You probably missed the lowmem bit from my response?

This system has all of its memory outside the 4GB physical address 
space.  This includes lowmem, which is permanently mapped into the 
kernel virtual address space as usual.

-- 
Thanks
- Cyril
