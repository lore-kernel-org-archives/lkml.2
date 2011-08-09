Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1HITRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:17:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37085 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1HITRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:17:11 -0400
MIME-Version: 1.0
In-Reply-To: <4E418388.9050600@zytor.com>
References: <cover.1312899174.git.luto@mit.edu> <135b827ce7b4e6059f11de631ea4a455e2b433be.1312899174.git.luto@mit.edu>
 <4E418388.9050600@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 9 Aug 2011 15:16:50 -0400
X-Google-Sender-Auth: 6ix4zsegyfU4OaGBF__gPIRgJf4
Message-ID: <CAObL_7Fq9qHNgu6-+bhagp=_kVnKzx2Kb1BufR2=g6pGeNEPdQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86-64: Allow emulated vsyscalls from user addresses
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 2:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/09/2011 09:27 AM, Andy Lutomirski wrote:
>>   *
>>   *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
>> - *  Vectors  32 ... 127 : device interrupts
>> - *  Vector  128         : legacy int80 syscall interface
>> - *  Vector  204         : legacy x86_64 vsyscall emulation
>> - *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 except 204 : device interrupts
>> + *  Vectors  32 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts, except:
>> + *   Vectors 64 ... 66  : legacy x86_64 vsyscall emulation
>> + *   Vector  128        : legacy int80 syscall interface
>>   *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
>>   *
>
> Hi Andy,
>
> Was there a reason to not use the vectors in the 0x2X range?

My general lack of understanding of how all the numbers work, and the
fact that I was waiting for Suresh to answer.  I assumed that
/proc/interrupts showed numbers that corresponded to offsets from
FIRST_EXTERNAL_VECTOR, in which case the 0x2X range is no good.  I
think that's wrong and they start at 0x40 (maybe?).  This comment in
irq_vector.h doesn't help:

/*
 * Vectors 0x30-0x3f are used for ISA interrupts.
 *   round up to the next 16-vector boundary
 */
#define IRQ0_VECTOR                     ((FIRST_EXTERNAL_VECTOR + 16) & ~15)


If IRQ0_VECTOR is a legacy ISA interrupt, then it's 0x30.  So what's
with the rounding?  In any case, I don't actually know which vector
irq 18 uses, and I don't know how to dump that information out of
/proc or /sys.



In any case, I won't fix this unless you and/or the rest of the x86
maintainers tell me you prefer this patch to the one that adds a
vsyscall boot parameter.

--Andy
