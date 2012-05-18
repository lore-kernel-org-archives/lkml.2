Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967227Ab2ERD7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:59:13 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:33521 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966450Ab2ERD7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:59:07 -0400
MIME-Version: 1.0
In-Reply-To: <4FB5C843.9070002@kernel.org>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
	<1337292816-10839-9-git-send-email-hjl.tools@gmail.com>
	<4FB58EFD.7010302@zytor.com>
	<4FB5C050.9070805@kernel.org>
	<CAMe9rOrKq8Ait8wKudRF535J5c=dDTKekmUN_=HOs5BBLtsoGQ@mail.gmail.com>
	<CA+55aFxtejaM8ecOw8VYk74OaXfGY7=LO3JSyz3rdHEv2r9goQ@mail.gmail.com>
	<4FB5C843.9070002@kernel.org>
Date: Thu, 17 May 2012 20:59:06 -0700
Message-ID: <CAMe9rOoH4GbJ5LQxYnySoh-mpLuaA3kPuHj0r=OhJN+xCs4dBQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de, Paul Mundt <lethal@linux-sh.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 8:55 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> On 05/17/2012 08:49 PM, Linus Torvalds wrote:
>> On Thu, May 17, 2012 at 8:39 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>>>
>>> That will be wrong.   __BITS_PER_LONG defines # bits of long
>>> as seen by kernel.  We don't use it in user space.
>>
>> Yes you do. Exactly in that structure that Peter points to. *Exactly*
>> because that structure uses "long" instead of some fixed size. Which
>> will be different in user mode than in kernel mode.
>>
>> And if user mode doesn't use these headers at all, then we should stop
>> playing the insane games.
>>
>
> User mode can, and should, be able to use the exported headers.  David
> Howells have been doing even more work to distill out the actual
> exported ABIs from the kernel and remove remaining chaff.
>
> That being said it seems kind of loopy to expect something called
> __BITS_PER_LONG to be anything other than (CHAR_BIT*sizeof(long)),
> especially since one of the main uses of it seems to be sizing
> bitvectors (which has its own issues on bigendian machines because I
> think we do littleendian bit numbering even on bigendian iron).
>

But __BITS_PER_LONG used in kernel header files really
means "long" as seen by kernel, not by user space. 64-bit
kernel can have 32-bit and 64-bit longs in use space.
__BITS_PER_LONG is a bad name for user space.


-- 
H.J.
