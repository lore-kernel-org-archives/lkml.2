Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0KOKYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:24:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37027 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0KOKYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:24:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n633cfSUpVT4EvzQjGbeB6rED5I9LporZ3NnrDRsJ3Vfw2Ay4cfZWPHfu5kJVLA2wI
         I4vlMrNBzhGoqg2UD7Ce5dHHHYK+FxyBgR9rxxCo3U8P2pO1agesqHdgLbNS6XoQEFdZ
         w2hrkpdrw+/e2+qx5de/D5g+eSsupUFB9Po/4=
MIME-Version: 1.0
In-Reply-To: <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
References: <87k4kospnd.fsf@basil.nowhere.org>
	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
	<877hgorrj1.fsf@basil.nowhere.org>
	<4CD843DC.10106@gmail.com>
	<Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
	<20101109134816.GB29433@basil.fritz.box>
	<m3lj52txaq.fsf@redhat.com>
	<4CD97A3D.1040602@xs4all.nl>
	<m31v6nmmr3.fsf@jhcloos.com>
	<AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
	<20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
Date: Mon, 15 Nov 2010 11:24:48 +0100
Message-ID: <AANLkTinAfq4HbPvEMDUM6230Qp41bJgZYPL1WtpkYHLN@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
From: Richard Guenther <richard.guenther@gmail.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        gcc@gcc.gnu.org, Jim Bos <jim876@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 9:56 AM, Jakub Jelinek <jakub@redhat.com> wrote:
> On Sun, Nov 14, 2010 at 07:21:50PM -0800, Linus Torvalds wrote:
>> So when Richard Gunther says "a memory clobber doesn't cover automatic
>> storage", to me that very clearly spells "gcc is buggy as hell".
>> Because automatic storage with its address taken _very_ much gets
>> clobbered by things like memset etc. If the compiler doesn't
>> understand that, the compiler is just broken.
>
> I'll leave the discussion about meaning of "memory" clobber aside to
> Richard,

Of course GCC handles memset just fine.  Note that I was refering
to non-address taken automatic storage for "memory" (even though
when double-checking the current implementation GCC even thinks
that all address-taken memory is clobbered by asms as soon as
they have at least one memory operand or a "memory" clobber).

It's just that in future we might want to improve this and I think
not covering non-address taken automatic storage for "memory"
is sensible.  And I see that you don't see address-taken automatic
storage as a sensible choice to exclude from "memory", and I
have noted that.

Btw, I still haven't seen an testcase for the actual problem we are
talking about.

Richard.
