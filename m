Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032069Ab2CIT6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:58:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46417 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030866Ab2CIT6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:58:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120309190842.GC13745@aftab>
References: <20120309074202.GA28609@www.outflux.net>
	<20120309092845.GA10281@elte.hu>
	<CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
	<4F5A448D.70605@zytor.com>
	<CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com>
	<20120309182829.GA13745@aftab>
	<CAGXu5jJaO29hqMfACav9v8yEdHXt-SegozGuc+tigYCF6K57WA@mail.gmail.com>
	<20120309190842.GC13745@aftab>
Date: Fri, 9 Mar 2012 11:58:02 -0800
X-Google-Sender-Auth: XH9yRo-LTFCSxldH2ZHZVTzhE7E
Message-ID: <CAGXu5jL6P7JkG73+qLs402FKHTEay132EWfse3Nf_wCJihxRPg@mail.gmail.com>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 11:08 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Fri, Mar 09, 2012 at 10:54:19AM -0800, Kees Cook wrote:
>> On Fri, Mar 9, 2012 at 10:28 AM, Borislav Petkov <bp@amd64.org> wrote:
>> > On Fri, Mar 09, 2012 at 10:21:52AM -0800, Kees Cook wrote:
>> >> > I have to admit personally to prefer something like X86_XCP_XX where XX
>> >> > is the two-letter code that the Intel documentation uses for that trap,
>> >> > i.e. #GP, #BR, #MC and so on.
>> >>
>> >> We need a single person to decide on this bike shed color. :) If the
>> >> list of enum names can be agreed on, I'll be happy to do the
>> >> search/replace for it.
>> >
>> > Well,
>> >
>> > here are my 2¢: I agree with hpa because
>> >
>> > a) it maps the CPU vendor documentation
>> > b) it is nicely short
>>
>> How about:
>>
>> X86_XCP_DE = 0,         /* 0, Divide-by-zero */
>> X86_XCP_DB,             /* 1, Debug */
>> X86_XCP_NMI,            /* 2, Non-maskable Interrupt */
>> X86_XCP_BP,             /* 3, Breakpoint */
>> X86_XCP_OF,             /* 4, Overflow */
>> X86_XCP_BR,             /* 5, Bound Range Exceeded */
>> X86_XCP_UD,             /* 6, Invalid Opcode */
>> X86_XCP_NM,             /* 7, Device Not Available */
>> X86_XCP_DF,             /* 8, Double Fault */
>> X86_XCP_OLD_MF,         /* 9, Coprocessor Segment Overrun */
>> X86_XCP_TS,             /* 10, Invalid TSS */
>> X86_XCP_NP,             /* 11, Segment Not Present */
>> X86_XCP_SS,             /* 12, Stack-Segment Fault */
>> X86_XCP_GP,             /* 13, General Protection Fault  */
>> X86_XCP_PF,             /* 14, Page Fault */
>> X86_XCP_RES,            /* 15, Reserved */
>
> So is this reserved or are we using it for Spurious IRQs? If we use it,
> then 'RES' is a bad name. Maybe we define our own like
>
> X86_VEC_SP

Yeah, it's used for spurious.

> and then do
>
> X86_VEC_IR for IRET
>
> in the manner we assumed for the rest?

Sure. I wasn't sure if it was dangerous to take a two-letter combo. I
guess if there is a future collision, we can just solve it then.

>> X86_XCP_MF,             /* 16, x87 Floating-Point Exception */
>> X86_XCP_AC,             /* 17, Alignment Check */
>> X86_XCP_MC,             /* 18, Machine Check */
>> X86_XCP_XM,             /* 19, SIMD Floating-Point Exception */
>
> Shouln't this be #XF actually? At least it is so in the AMD docs.

XM in Intel, XF in AMD. I have no preference.

>> X86_XCP_IRET = 32,      /* 32, IRET Exception */
>>
>> There is a name collision for "MF", there's no mnemonic for NMI,
>
> Well, in the AMD docs we actually do have the '#NMI' mnemonic in use.

If AMD's list is more complete, I think that's a good enough reason to
use "XF" above. :)

>> IRET, or the reserved "spurious" interrupt.
>>
>> Can use "VEC" instead "XCP", as Steven suggests.
>
> Yeah, because those actually are fixed interrupt vectors, as they're
> called in the AMD docs. Makes sense.

That seems reasonable to me. Peter, how's that sound to you?

-Kees

-- 
Kees Cook
ChromeOS Security
