Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2LMGLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 01:11:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58949 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab2LMGLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 01:11:21 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1355378005.24283.11.camel@wall-e>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net> <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 12 Dec 2012 22:10:52 -0800
To: Stefani Seibold <stefani@seibold.net>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net
Message-ID: <ac005b18-0503-4390-9b76-0a5a4c34539c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, let's not.  Why?  Because if we do that we may inadvertently create an ABI which is hard to support across the board.

Stefani Seibold <stefani@seibold.net> wrote:

>Am Mittwoch, den 12.12.2012, 15:34 -0800 schrieb H. Peter Anvin:
>> On 12/12/2012 12:19 PM, stefani@seibold.net wrote:
>> > diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c
>b/arch/x86/vdso/vdso32/vclock_gettime.c
>> > new file mode 100644
>> > index 0000000..c9a1909
>> > --- /dev/null
>> > +++ b/arch/x86/vdso/vdso32/vclock_gettime.c
>> > @@ -0,0 +1,7 @@
>> > +/*
>> > + * since vgtod layout differs between X86_64 and x86_32, it is not
>possible to
>> > + * provide a 32 bit vclock with a 64 bit kernel
>> > + */
>> > +#ifdef CONFIG_X86_32
>> > +#include "../vclock_gettime.c"
>> > +#endif
>> 
>> This is where this goes fail.  Sorry, it is not acceptable to
>introduce 
>> an ABI on x86-32 without providing it also on x86-64 in compatibility
>mode.
>> 
>> I also don't believe it is not possible... it might require some more
>
>> cleverness; perhaps we need to do the 32-bit vgtod in such a way that
>it 
>> *is* compatible with 64 bits.
>> 
>
>The comment is ambiguous:
>
>Since vgtod layout differs between X86_64 and x86_32 AND the vgtod is
>not inside the accessible address space of a 32 bit program, it is
>CURRENTLY not possible to provide a 32 bit vclock with a 64 bit kernel
>
>As i understand VDSO it is an alternativ way, so if there is no support
>for it, there must be a fall back to the system call interface in the
>program or lib, which tries to use it.
>
>So there is no drawback for 32 bit programs running on a 64 bit kernel.
>
>
>I think this feature is not so important and can implemented in a
>subsequent patch, because a 64 bit kernel system mostly runs 64 bit
>programs. Let us fix this things step by step.
>
>- Stefani

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
