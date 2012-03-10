Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2CJQGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 11:06:53 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34275 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2CJQGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 11:06:48 -0500
MIME-Version: 1.0
In-Reply-To: <4F5B1305.4080306@gmail.com>
References: <20120309083009.GA14067@darkstar.nay.redhat.com>
	<4F5ACA2D.5000000@gmail.com>
	<20120310045632.GA4214@darkstar.redhat.com>
	<4F5B1305.4080306@gmail.com>
Date: Sun, 11 Mar 2012 00:06:47 +0800
Message-ID: <CABqxG0e5MbkLs=YfbGqirkeD-mLPN8-N1gNyG4WR_EqQjadXpw@mail.gmail.com>
Subject: Re: [PATCH v2] kdump x86: fix total mem size calculation for reservation
From: Dave Young <hidave.darkstar@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux@arm.linux.org.uk, vgoyal@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 4:38 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On 03/10/2012 12:56 PM, Dave Young wrote:
>>
>> crashkernel reservation need know the total memory size. Current
>> get_total_mem
>> simply use max_pfn - min_low_pfn. It is wrong because it will including
>> memory holes in the middle.
>>
>> Especially for kvm guest with memory>  0xe0000000, there's below in qemu
>> code:
>> qemu split memory as below:
>>     if (ram_size>= 0xe0000000 ) {
>>         above_4g_mem_size = ram_size - 0xe0000000;
>>         below_4g_mem_size = 0xe0000000;
>>     } else {
>>         below_4g_mem_size = ram_size;
>>     }
>> So for 4G mem guest, seabios will insert a 512M usable region beyond of
>> 4G.
>> Thus in above case max_pfn - min_low_pfn will be more than original
>> memsize.
>>
>> Fixing this issue by using memblock_phys_mem_size() to get the total
>> memsize.
>>
>> [v1 ->  v2]: refresh the patch based on latest linus tree
>>
>
> Looks good to my eyes,
>
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> Can you post the result of crashkernel after this patch to convince people?

Sure, for the qemu  4G vm results below:
-[    0.000000] Reserving 128MB of memory at 768MB for crashkernel
(System RAM: 4608MB)
+[    0.000000] Reserving 128MB of memory at 768MB for crashkernel
(System RAM: 4095MB)

>
> Thanks.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards
Dave
