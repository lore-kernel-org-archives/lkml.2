Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0KOSJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:09:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756654Ab0KOSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:09:52 -0500
MIME-Version: 1.0
In-Reply-To: <4CE17098.8090000@xs4all.nl>
References: <4CD843DC.10106@gmail.com> <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
 <20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com>
 <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com> <4CE17098.8090000@xs4all.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 10:08:54 -0800
Message-ID: <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
To: Jim Bos <jim876@xs4all.nl>
Cc: Jakub Jelinek <jakub@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 9:40 AM, Jim Bos <jim876@xs4all.nl> wrote:
>
> Hmm, that doesn't work.
>
> [ Not sure if you read to whole thread but initial workaround was to
> change the asm(..) to asm volatile(..) which did work. ]

Since I have a different gcc than yours (and I'm not going to compile
my own), have you posted your broken .s file anywhere? In fact, with
the noinline (and the removal of the "+m" thing - iow just the patch
you tried), what does just the "i8k_smm" function assembly look like
for you after you've done a "make drivers/char/i8k.s"?

If the asm just doesn't exist AT ALL, that's just odd. Because every
single call-site of i8k_smm() clearly looks at the return value. So
the volatile really shouldn't make any difference from that
standpoint. Odd.

                       Linus
