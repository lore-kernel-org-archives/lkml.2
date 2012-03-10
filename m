Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab2CJEec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 23:34:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab2CJEeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 23:34:31 -0500
Message-ID: <4F5AD95C.5020209@redhat.com>
Date: Sat, 10 Mar 2012 12:32:28 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux@arm.linux.org.uk,
        vgoyal@redhat.com
Subject: Re: [PATCH] kdump x86: fix total mem size calculation for reservation
References: <20120309083009.GA14067@darkstar.nay.redhat.com> <4F5ACA2D.5000000@gmail.com>
In-Reply-To: <4F5ACA2D.5000000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 11:27 AM, Cong Wang wrote:

> On 03/09/2012 04:30 PM, Dave Young wrote:
>> crashkernel reservation need know the total memory size. Current
>> get_total_mem
>> simply use max_pfn - min_low_pfn. It is wrong because it will including
>> memory holes in the middle.
>>
>> Especially for kvm guest with memory>  0xe0000000, there's below in
>> qemu code:
>> qemu split memory as below:
>>      if (ram_size>= 0xe0000000 ) {
>>          above_4g_mem_size = ram_size - 0xe0000000;
>>          below_4g_mem_size = 0xe0000000;
>>      } else {
>>          below_4g_mem_size = ram_size;
>>      }
>> So for 4G mem guest, seabios will insert a 512M usable region beyond
>> of 4G.
>> Thus in above case max_pfn - min_low_pfn will be more than original
>> memsize.
>>
>> Fixing this issue by using memblock_phys_mem_size() to get the total
>> memsize.
>>
> 
> Makes sense for me!
> 
>> -static inline unsigned long long get_total_mem(void)
>> -{
>> -    unsigned long long total;
>> -
>> -    total = max_pfn - min_low_pfn;
>> -    printk("hidave: memsize=%llu\n", memblock_phys_mem_size());
> 
> This debugging line does not exist... so this patch can't be applied.


Yes, good catch, will remove the line and resend.


-- 
Thanks
Dave
