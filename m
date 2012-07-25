Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2GYKoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:44:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab2GYKoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:44:21 -0400
Message-ID: <500FCDF3.7080808@redhat.com>
Date: Wed, 25 Jul 2012 13:44:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Stefan Bader <stefan.bader@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: x86/mm: Limit 2/4M size calculation to x86_32
References: <5000259D.9020303@canonical.com> <CAM_iQpVPzB69R1_4E_J5Yw=d1TncqHe0+dWEwOufQniNcpBVtg@mail.gmail.com>
In-Reply-To: <CAM_iQpVPzB69R1_4E_J5Yw=d1TncqHe0+dWEwOufQniNcpBVtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 06:52 PM, Cong Wang wrote:

>> From 6b679d1af20656929c0e829f29eed60b0a86a74f Mon Sep 17 00:00:00 2001
>> From: Stefan Bader <stefan.bader@canonical.com>
>> Date: Fri, 13 Jul 2012 15:16:33 +0200
>> Subject: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32
>>
>> commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)
>> did modify the extra space calculation for mapping tables in order
>> to make up for the first 2/4M memory range using 4K pages.
>> However this setup is only used when compiling for 32bit. On 64bit
>> there is only the trailing area of 4K pages (which is already added).
>>
>> The code was already adapted once for things went wrong on a 8TB
>> machine (bd2753b x86/mm: Only add extra pages count for the first memory
>> range during pre-allocation early page table space), but it looks a bit
>> like it currently would overdo things for 64bit.
>> I only noticed while bisecting for the reason I could not make a crash
>> kernel boot (which ended up on this patch).
>>
>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>> Cc: WANG Cong <xiyou.wangcong@gmail.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Tejun Heo <tj@kernel.org>
> 
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
> 
> Sorry for that I was not aware of x86_64 is different with x86 in the
> first 2/4M.

Why would there be a difference?

Shouldn't the IO space at 0xa0000-0x100000 be mapped with uncacheable
attributes (or WC for VGA)?  If it's done later, it can be done later
for both.

-- 
error compiling committee.c: too many arguments to function


