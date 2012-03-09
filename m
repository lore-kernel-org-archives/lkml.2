Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2CITJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:09:08 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42544 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab2CITJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:09:06 -0500
Date: Fri, 9 Mar 2012 20:08:42 +0100
From: Borislav Petkov <bp@amd64.org>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
Message-ID: <20120309190842.GC13745@aftab>
References: <20120309074202.GA28609@www.outflux.net>
 <20120309092845.GA10281@elte.hu>
 <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
 <4F5A448D.70605@zytor.com>
 <CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com>
 <20120309182829.GA13745@aftab>
 <CAGXu5jJaO29hqMfACav9v8yEdHXt-SegozGuc+tigYCF6K57WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jJaO29hqMfACav9v8yEdHXt-SegozGuc+tigYCF6K57WA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 10:54:19AM -0800, Kees Cook wrote:
> On Fri, Mar 9, 2012 at 10:28 AM, Borislav Petkov <bp@amd64.org> wrote:
> > On Fri, Mar 09, 2012 at 10:21:52AM -0800, Kees Cook wrote:
> >> > I have to admit personally to prefer something like X86_XCP_XX where XX
> >> > is the two-letter code that the Intel documentation uses for that trap,
> >> > i.e. #GP, #BR, #MC and so on.
> >>
> >> We need a single person to decide on this bike shed color. :) If the
> >> list of enum names can be agreed on, I'll be happy to do the
> >> search/replace for it.
> >
> > Well,
> >
> > here are my 2¢: I agree with hpa because
> >
> > a) it maps the CPU vendor documentation
> > b) it is nicely short
> 
> How about:
> 
> X86_XCP_DE = 0,         /* 0, Divide-by-zero */
> X86_XCP_DB,             /* 1, Debug */
> X86_XCP_NMI,            /* 2, Non-maskable Interrupt */
> X86_XCP_BP,             /* 3, Breakpoint */
> X86_XCP_OF,             /* 4, Overflow */
> X86_XCP_BR,             /* 5, Bound Range Exceeded */
> X86_XCP_UD,             /* 6, Invalid Opcode */
> X86_XCP_NM,             /* 7, Device Not Available */
> X86_XCP_DF,             /* 8, Double Fault */
> X86_XCP_OLD_MF,         /* 9, Coprocessor Segment Overrun */
> X86_XCP_TS,             /* 10, Invalid TSS */
> X86_XCP_NP,             /* 11, Segment Not Present */
> X86_XCP_SS,             /* 12, Stack-Segment Fault */
> X86_XCP_GP,             /* 13, General Protection Fault  */
> X86_XCP_PF,             /* 14, Page Fault */
> X86_XCP_RES,            /* 15, Reserved */

So is this reserved or are we using it for Spurious IRQs? If we use it,
then 'RES' is a bad name. Maybe we define our own like

X86_VEC_SP

and then do

X86_VEC_IR for IRET

in the manner we assumed for the rest?

> X86_XCP_MF,             /* 16, x87 Floating-Point Exception */
> X86_XCP_AC,             /* 17, Alignment Check */
> X86_XCP_MC,             /* 18, Machine Check */
> X86_XCP_XM,             /* 19, SIMD Floating-Point Exception */

Shouln't this be #XF actually? At least it is so in the AMD docs.

> X86_XCP_IRET = 32,      /* 32, IRET Exception */
> 
> There is a name collision for "MF", there's no mnemonic for NMI,

Well, in the AMD docs we actually do have the '#NMI' mnemonic in use.

> IRET, or the reserved "spurious" interrupt.
>
> Can use "VEC" instead "XCP", as Steven suggests.

Yeah, because those actually are fixed interrupt vectors, as they're
called in the AMD docs. Makes sense.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
