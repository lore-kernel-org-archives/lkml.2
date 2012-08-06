Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2HFNT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:19:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42251 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2HFNTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:19:25 -0400
Message-ID: <501FC44E.1040806@ti.com>
Date: Mon, 6 Aug 2012 09:19:10 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <will.deacon@arm.com>
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <20120806111224.GA18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120806111224.GA18957@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/2012 7:12 AM, Russell King - ARM Linux wrote:
> On Tue, Jul 31, 2012 at 07:04:37PM -0400, Cyril Chemparathy wrote:
>> +static void __init init_patch_kernel(void)
>> +{
>> +	const void *start = &__patch_table_begin;
>> +	const void *end   = &__patch_table_end;
>> +
>> +	BUG_ON(patch_kernel(start, end - start));
>> +	flush_icache_range(init_mm.start_code, init_mm.end_code);
>
> Err.  You are asking the kernel to flush every single cache line
> manually throughout the kernel code.  That's a flush every 32-bytes
> over maybe a few megabytes of address space.
>

With a flush_cache_all(), we could avoid having to operate a cacheline 
at a time, but that clobbers way more than necessary.

Maybe the better answer is to flush only the patched cachelines.

> This is one of the reasons we do the patching in assembly code before
> the caches are enabled - so we don't have to worry about the interaction
> with the CPU caches, which for this kind of application would be very
> expensive.
>

Sure, flushing caches is expensive.  But then, so is running the 
patching code with caches disabled.  I guess memory access latencies 
drive the performance trade off here.

-- 
Thanks
- Cyril
