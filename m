Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1FNVYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:24:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303Ab1FNVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:24:54 -0400
MIME-Version: 1.0
In-Reply-To: <20110614211613.GB12249@elte.hu>
References: <1307777464.25182.3.camel@localhost.localdomain>
 <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com> <BANLkTi=yEo9fcXW8SqUCtSOag7Mn_+Ni9Q@mail.gmail.com>
 <BANLkTimv6F8NsH0Lg7q6gi1-oiBv8nUrSA@mail.gmail.com> <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
 <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com> <BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com>
 <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com> <4DF7A264.3030901@mit.edu>
 <20110614211613.GB12249@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Jun 2011 14:24:02 -0700
Message-ID: <BANLkTi=W1xFdoSFxnNBGX9gt_pYOH4oF=A@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Lutomirski <luto@mit.edu>, Rakib Mullick <rakib.mullick@gmail.com>,
        hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 2:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> I think correctness trumps code size and turning BUG() and BUG_ON()
> into a NOP is just crazy ...

Umm. It's even CRAZIER to turn it into a "compiler generates random code".

Which is what "unreachable()" ends up doing (different compilers will
generate different things - ranging from an infinite loop, to a "nop
with random behavior after it because gcc decided that it doesn't need
to pop arguments off the stack and just runs into random code
instead").

So a NOP is a *hell* of a lot better than turning BUG_ON() into
something random.

The only (and I mean *only*) valid use-case for unreachable() is after
an inline asm that really causes the next instruction to be
unreachable(), but the compiler just doesn't understand it. It is
*not* valid for that kind of crazy "if (condition) do-random-thing"
crap.

Seriously. If you want a "do random thing" thing, don't call it
BUG_ON(). Call it "I_M_A_FUCKING_MORON()".

There is no way I will ever accept a moronic patch like that.

Really.

                     Linus
