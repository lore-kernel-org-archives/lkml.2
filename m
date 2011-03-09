Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab1CITE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:04:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42728 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1CITE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:04:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=U51ytynie6YElMsz/O++X919s8UvwwsSNxys/oCKIol2UH+zOMBCR92D9sD+zBeqeZ
         WTD0JHbvl2VItWtaH4EOhf3N6m9l1c4JbUdQLPGiE4RZ6WT8F2I+iykoxUeIuVeNG99m
         mhOwgWtXAR1fnaAakOk0Poi7sgo4xwViYiXYA=
MIME-Version: 1.0
In-Reply-To: <20110309160241.GC31249@elte.hu>
References: <AANLkTik_Cb7tXheZNOBjqnoQc4MSL1LnDtFGFP5mqZRi@mail.gmail.com>
	<AANLkTinBv__n7k3Z=EJWv1fdQScyB7AJV0SsYJE0mCwQ@mail.gmail.com>
	<AANLkTiknsT1iQzUQ_oBiOORaqWBFyk2BaLq_xu9C5E_G@mail.gmail.com>
	<1299605269.29313.1427511237@webmail.messagingengine.com>
	<AANLkTi=6YstJxad41knR4Q9WN3wYKikPv-g1i3kg3HS1@mail.gmail.com>
	<1299615939.25628.1427572905@webmail.messagingengine.com>
	<AANLkTimBMP1jiuEEUwmKKVNZcZnrkFxFA_YBcLmkEFJM@mail.gmail.com>
	<AANLkTikpMAXfG5aNWo8x7pKKppaQiE-U8qjFaG0B2azV@mail.gmail.com>
	<20110309085150.GC21294@elte.hu>
	<AANLkTiks9o18LRS46CrYHBXzq_6U-v-CqK=0Fzc4Tuco@mail.gmail.com>
	<20110309160241.GC31249@elte.hu>
Date: Wed, 9 Mar 2011 11:04:56 -0800
Message-ID: <AANLkTinCzzqq6KC5H1Gad7a99dkp_x-cc8f3FHnXdjLJ@mail.gmail.com>
Subject: Re: linux-next: Tree for March 8 (BROKEN: arch/x86/kernel/entry_32.S?
 Debian's binutils/as?)
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        linux-next <linux-next@vger.kernel.org>, psomas@cslab.ece.ntua.gr,
        Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 8:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>> > This binutils change is breaking numerous upstream kernel builds (and is making
>> > bisection with new binutils impossible) for no particular good reason: binutils
>> > was capable to figure out the symbol name before this change.
>>
>> That is totally false. The old assembler just generates incorrect size and It
>> couldn't read the programmer's mind to find the correct symbol name.
>
> Still it didnt make the kernel not build and it did not make the kernel not boot. It
> at most confused some ELF symbol table - which the kernel does not need.
>
> So all i'm trying to point out to you is that you appear to be seeing the world in a
> very binary way: 'broken' versus 'correct' and that it can be rather harmful if you
> project that binary view on the real world that in reality is not binary but is
> shades of grey.
>
> You are turning a benign ELF symbol table detail (that does not affect the kernel's
> ability to boot/work) into a hard build breakage and bisection barrier, covering
> hundreds of commits.

The original assembler change didn't mention the bogus symbol name
in error message, which is very unhelpful. I changed the assembler to
print out the bogus symbol name in error message. It should be very
trivial to identify the bogus kernel assembly codes.

> I'm not denying that it's buggy code - I'm just asking you to *PLEASE* at minimum
> acknowledge that surprise flag days that turn a before-benign condition into a fatal
> build failure suck to everyone else outside your own little universe.
>

There is no way for assembler to know if a bug in input source code is
"benign" or
not. For assembler, a bug in input is a bug in input.  Assembly programmers
should appreciate this assembler change for helping him/her catch such bugs
in his/her codes.


-- 
H.J.
