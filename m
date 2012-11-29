Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2K2VOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:14:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52628 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab2K2VOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:14:30 -0500
Message-ID: <50B7CFF8.7010401@zytor.com>
Date: Thu, 29 Nov 2012 13:13:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <m2obigf9xa.fsf@firstfloor.org>
In-Reply-To: <m2obigf9xa.fsf@firstfloor.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 12:09 PM, Andi Kleen wrote:
> Jim Kukunas <james.t.kukunas@linux.intel.com> writes:
>> +
>> +	/* ymm0 = x0f[16] */
>> +	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
>> +
>> +	while (bytes) {
>> +#ifdef CONFIG_X86_64
>> +		asm volatile("vmovdqa %0, %%ymm1" : : "m" (q[0]));
>> +		asm volatile("vmovdqa %0, %%ymm9" : : "m" (q[32]));
>> +		asm volatile("vmovdqa %0, %%ymm0" : : "m" (p[0]));
>> +		asm volatile("vmovdqa %0, %%ymm8" : : "m" (p[32]));
> 
> This is somewhat dangerous to assume registers do not get changed
> between assembler statements or assembler statements do not get
> reordered. Better always put such values into explicit variables or
> merge them into a single asm statement.
> 
> asm volatile is also not enough to prevent reordering. If anything
> you would need a memory clobber.
> 

The code is compiled so that the xmm/ymm registers are not available to
the compiler.  Do you have any known examples of asm volatiles being
reordered *with respect to each other*?  My understandings of gcc is
that volatile operations are ordered with respect to each other (not
necessarily with respect to non-volatile operations, though.)

Either way, this implementatin technique was used for the MMX/SSE
implementations without any problems for 9 years now.

	-h[a


