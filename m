Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1CJP4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:56:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43718 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1CJP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:56:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fs0kPFZs5NKarG3ANhZUYaItbGUIRf1HBDcJEwIGyhJ5EMQPLiaD+s2uTtxT+hdokn
         MYIcN3+yXjYe5q4D5vtnT9KCikP0IXzq0KzId4h1+ZLX3d6rA4ao8jn1RvB5RsUFixA5
         sJ/YBtNvia5O4Lkmdt44KVfh4VkwvjTqqMz6M=
MIME-Version: 1.0
In-Reply-To: <20110310071709.GG9289@elte.hu>
References: <AANLkTiknsT1iQzUQ_oBiOORaqWBFyk2BaLq_xu9C5E_G@mail.gmail.com>
	<1299605269.29313.1427511237@webmail.messagingengine.com>
	<AANLkTi=6YstJxad41knR4Q9WN3wYKikPv-g1i3kg3HS1@mail.gmail.com>
	<1299615939.25628.1427572905@webmail.messagingengine.com>
	<AANLkTimBMP1jiuEEUwmKKVNZcZnrkFxFA_YBcLmkEFJM@mail.gmail.com>
	<AANLkTikpMAXfG5aNWo8x7pKKppaQiE-U8qjFaG0B2azV@mail.gmail.com>
	<20110309085150.GC21294@elte.hu>
	<AANLkTiks9o18LRS46CrYHBXzq_6U-v-CqK=0Fzc4Tuco@mail.gmail.com>
	<20110309160241.GC31249@elte.hu>
	<AANLkTinCzzqq6KC5H1Gad7a99dkp_x-cc8f3FHnXdjLJ@mail.gmail.com>
	<20110310071709.GG9289@elte.hu>
Date: Thu, 10 Mar 2011 07:54:22 -0800
Message-ID: <AANLkTim_oy_X9DGvyzyN3Y6w0YWp2CCy+dsMKCHob_cU@mail.gmail.com>
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

On Wed, Mar 9, 2011 at 11:17 PM, Ingo Molnar <mingo@elte.hu> wrote:

> Your "it's simple to fix" argument misses that point: i was talking about bisection
> breakage, and during bisection of kernel bugs we dive back into older versions of
> the code.
>
> It does not matter that you declare the .size directive bogus. It is buggy and yes
> i've already queued up the fixes and i apprecitate them being fixed, but that's
> immaterial to the compatibility argument i made: BINUTILS BUILT THE KERNEL FINE
> BEFORE.
>
> If you do changes to a major component of the build environment of thousands of free
> software projects you *must* consider the real-life compatbility effects of your
> change on others, not just your own motivation.
>
> If you do that you need to at least UNDERSTAND what i'm talking about. It scares the
> heck out of me that we are here at mail #20 with a *very* simple compatibility
> scenario and the maintainer of a major piece of free software infrastructure *still*
> does not understand this very simple argument. How the heck will you be able to
> handle more complex cases of compatibility in a responsible way?
>

If I understand it correctly, the issue here is in some cases, for whatever
reason, the assembly input files can't be changed even if they are incorrect.
On the other hand, this is the incorrect assembly input as far as assembler
is concern.  You can write a simple assembly wrapper to fix the assembly input
before sending it to the real assembler.  Yes, it may be a hassle.  I guess
it is the price you may have to pay when you can't fix your code.

FWIW, I can provide the assembler wrapper if needed.

-- 
H.J.
