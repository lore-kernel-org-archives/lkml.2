Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0F1H6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 03:58:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab0F1H6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 03:58:45 -0400
Message-ID: <4C285625.6000806@cn.fujitsu.com>
Date: Mon, 28 Jun 2010 15:58:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers
 for cpufeature index
References: <tip-*@git.kernel.org> <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org> <4C2474EF.4050902@cn.fujitsu.com> <4C24CCB7.2020806@zytor.com>
In-Reply-To: <4C24CCB7.2020806@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 06/25/2010 02:20 AM, Lai Jiangshan wrote:
>>> x86, alternatives: Use 16-bit numbers for cpufeature index
>>>
>>> We already have cpufeature indicies above 255, so use a 16-bit number
>>> for the alternatives index.  This consumes a padding field and so
>>> doesn't add any size, but it means that abusing the padding field to
>>> create assembly errors on overflow no longer works.  We can retain the
>>> test simply by redirecting it to the .discard section, however.
>>>
>> My machine hits "invalid opcode" at *prepare_to_copy+0x79,
>> and it can't boot up.
>>
>> (gdb) l *prepare_to_copy+0x79
>> 0xc0101789 is in prepare_to_copy (/home/njubee/work/linux-2.6-tip/arch/x86/include/asm/xsave.h:118).
>> 113
>> 114     static inline void fpu_xsave(struct fpu *fpu)
>> 115     {
>> 116             /* This, however, we can work around by forcing the compiler to select
>> 117                an addressing mode that doesn't require extended registers. */
>> 118             __asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
>> 119                                  : : "D" (&(fpu->state->xsave)),
>> 120                                      "a" (-1), "d"(-1) : "memory");
>> 121     }
>> 122     #endif
>>
> 
> There are no alternatives in that code, at all... so it makes me really
> wonder what is going on.  One possibility, of course, is that one
> alternative has ended up with the wrong address.  Will look...
> 

There is alternative in use_xsave().
use_xsave() should return false in my system, but it returns true after this patch applied.

>> Does this patch change the return value of "use_xsave()"
