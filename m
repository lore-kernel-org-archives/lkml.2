Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2DSQ7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:59:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49705 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab2DSQ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:59:43 -0400
Message-ID: <4F90445B.9050106@zytor.com>
Date: Thu, 19 Apr 2012 09:59:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/5] x86-64: Handle exception table entries during early
 boot
References: <1334794610-5546-1-git-send-email-hpa@zytor.com> <1334794610-5546-5-git-send-email-hpa@zytor.com> <20120419130240.GE30447@aftab>
In-Reply-To: <20120419130240.GE30447@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 06:02 AM, Borislav Petkov wrote:>> +	# 56(%rsp) %rflags
>> +	# 48(%rsp) %cs
>> +	# 40(%rsp) %rip
>> +	# 32(%rsp) error code
> 
> Just a question about understanding this: I was strugging with the
> exact interrupt-handler stack layout, so how do you know the exact
> offsets of rflags, cs et all? I've been staring at our APM v2, p. 144
> (http://support.amd.com/us/Processor_TechDocs/24593_APM_v2.pdf) which
> shows the interrupt stack with error code but it has different offsets
> than those above:
> 
> [Return SS]	40(%rsp)
> [Return RSP]	32(%rsp)
> [rFLAGS]	24(%rsp)
> [CS]		16(%rsp)
> [RIP]		 8(%rsp)
> [ErrorCode]	 0(%rsp)
> 
> but I see below that we have room for %rax, %rcx and %rdx on the stack.
> 
> Are we doing something different in Linux, or what am I missing?

The offsets in my code refer to offsets after we push the vector number,
%rax, %rcx and %rdx onto the stack manually; that is 4*8 = 32 bytes,
hence the offset.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

