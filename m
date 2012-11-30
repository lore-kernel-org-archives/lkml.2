Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab2K3SDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:03:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35099 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab2K3SDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:03:32 -0500
Message-ID: <50B8F4D7.2010204@zytor.com>
Date: Fri, 30 Nov 2012 10:03:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com> <1354132230-21854-9-git-send-email-hpa@linux.intel.com> <20121128204158.GC14635@liondog.tnic> <50B7D28A.4000401@linux.intel.com> <CA+55aFziiaWt1nU-EPKc=tFd0EvSm2iSBJ2MAqxNiWP5O0mv+w@mail.gmail.com>
In-Reply-To: <CA+55aFziiaWt1nU-EPKc=tFd0EvSm2iSBJ2MAqxNiWP5O0mv+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 09:01 AM, Linus Torvalds wrote:
> On Thu, Nov 29, 2012 at 1:24 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> Thinking about it some more, there is another reason to not do this,
>> which is that we don't want this particular CPUID to be paravirtualized;
>> we're after the synchronizing side effect, not the CPUID return value
>> itself.
>>
>> So let's leave it as a primitive; it gets too confusing otherwise.
>
> Hmm. The virtualization issue brings up another point: do we *really*
> want to use cpuid for serialization at all?
>

Well, the grand total of serializing instructions are:

INVD, INVEPT, INVLPG, INVVPID, LGDT, LIDT, LLDT, LTR, MOV to CR, MOV to 
DR, WBINVD, WRMSR, CPUID, IRET, RSM.

It doesn't really leave a lot of wiggle room, and in the microcode case, 
the use of CPUID level 1 is actually mandated (presumably to get a 
uniform sequence for validation purposes.)

> From all of the above, the alternatives case is kinda relevant for virt
> where we do text_poke_early in a loop for every alternative section
> so this could pile up to a bunch of vmexits depending on the emulated
> hardware. Might be worth a replacement if it is noticeable in guests.

This is still boot time, and I really doubt it is measurable in the long 
run.  Yes, exists suck, but at least CPUID is generally a quick exit, 
since all the relevant state is in registers.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

