Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0FYPft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:35:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0FYPfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:35:48 -0400
Message-ID: <4C24CCB7.2020806@zytor.com>
Date: Fri, 25 Jun 2010 08:35:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers
 for cpufeature index
References: <tip-*@git.kernel.org> <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org> <4C2474EF.4050902@cn.fujitsu.com>
In-Reply-To: <4C2474EF.4050902@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 02:20 AM, Lai Jiangshan wrote:
>>
>> x86, alternatives: Use 16-bit numbers for cpufeature index
>>
>> We already have cpufeature indicies above 255, so use a 16-bit number
>> for the alternatives index.  This consumes a padding field and so
>> doesn't add any size, but it means that abusing the padding field to
>> create assembly errors on overflow no longer works.  We can retain the
>> test simply by redirecting it to the .discard section, however.
>>
> 
> My machine hits "invalid opcode" at *prepare_to_copy+0x79,
> and it can't boot up.
> 
> (gdb) l *prepare_to_copy+0x79
> 0xc0101789 is in prepare_to_copy (/home/njubee/work/linux-2.6-tip/arch/x86/include/asm/xsave.h:118).
> 113
> 114     static inline void fpu_xsave(struct fpu *fpu)
> 115     {
> 116             /* This, however, we can work around by forcing the compiler to select
> 117                an addressing mode that doesn't require extended registers. */
> 118             __asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
> 119                                  : : "D" (&(fpu->state->xsave)),
> 120                                      "a" (-1), "d"(-1) : "memory");
> 121     }
> 122     #endif
> 

There are no alternatives in that code, at all... so it makes me really
wonder what is going on.  One possibility, of course, is that one
alternative has ended up with the wrong address.  Will look...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

